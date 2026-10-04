#!/usr/bin/env python3
"""Rejoue un corpus de dumps réels de tags Bambu Lab dans la chaîne de lecture
de l'app et compare le résultat à la vérité terrain.

Corpus : https://github.com/queengooborg/Bambu-Lab-RFID-Library (5959 dumps au
04.10.2026). Il est sous GPL-3.0 : le cloner HORS du dépôt, ne rien y copier.

    git clone --depth 1 https://github.com/queengooborg/Bambu-Lab-RFID-Library /tmp/bambu-lib
    python3 tool/bambu_corpus_check.py /tmp/bambu-lib

Étapes :
1. Natif Android émulé (NativeNfcPlugin.kt) : clés A dérivées de l'UID (HKDF)
   comparées aux vraies clés du dump, repli FFFFFFFFFFFF en A puis B ;
   auto-détection (clé B Creality sur le secteur 1, si `cryptography` est
   installé) ; rawBlocks = blocs non-trailer des secteurs ouverts ; AUTH_ERROR
   sans bloc 5.
2. Décodage par le vrai code Dart (tool/bambu_corpus_decode.dart).
3. Comparaison : champs numériques et RGB avec le décodeur de référence de la
   bibliothèque (parse.py), matériau et couleur avec son classement
   (Catégorie/Matériau/Couleur/UID/).

Code de sortie 1 si un tag n'est pas lu, pas décodé, ou si un champ numérique
diffère de la référence. Les écarts de nom sont listés, sans faire échouer :
le classement de la bibliothèque contient des erreurs.
"""
import argparse
import collections
import glob
import hashlib
import hmac
import json
import os
import re
import subprocess
import sys
import tempfile

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# Paramètres de NativeNfcPlugin.kt (BAMBU_HKDF_SALT / BAMBU_HKDF_INFO, Creality).
SALT = bytes.fromhex("9a759cf2c4f7caff222cb9769b41bc96")
INFO_A = b"RFID-A\x00"
DEFAULT_KEY = b"\xff" * 6
CREALITY_UID_KEY = b"q3bu^t1nqfZ(pf$1"
CREALITY_AES_KEY = b"H@CFkRnz@KAtBJp2"

try:
    from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
except ImportError:  # contrôle Creality sauté
    Cipher = None


def hkdf_keys(uid):
    prk = hmac.new(SALT, uid, hashlib.sha256).digest()
    okm, t = b"", b""
    for i in range(1, 4):
        t = hmac.new(prk, t + INFO_A + bytes([i]), hashlib.sha256).digest()
        okm += t
    return [okm[i * 6:i * 6 + 6] for i in range(16)]


def aes(key, data, decrypt=False):
    c = Cipher(algorithms.AES(key), modes.ECB())
    op = c.decryptor() if decrypt else c.encryptor()
    return op.update(data) + op.finalize()


def creality_detected(uid, blocks):
    """Auto-détection : le tag passe-t-il pour un Creality (clé B + vendor) ?"""
    if Cipher is None:
        return None
    key_b = aes(CREALITY_UID_KEY, bytes.fromhex((uid[:4].hex().upper() * 4)[:32]))[:6]
    trailer = blocks.get(7)
    if not trailer or trailer[10:16] != key_b:
        return False
    data = b"".join(blocks.get(i) or b"\0" * 16 for i in (4, 5, 6))
    return aes(CREALITY_AES_KEY, data, decrypt=True)[8:12] == b"0276"


def read_blocks(dump):
    blocks = {}
    for k, v in dump["blocks"].items():
        blocks[int(k)] = None if "?" in v else bytes.fromhex(v)
    return blocks


def emulate_native(path):
    dump = json.load(open(path))
    uid = bytes.fromhex(dump["Card"]["UID"])
    blocks = read_blocks(dump)
    keys = hkdf_keys(uid)
    key_bin = path.replace("-dump.json", "-key.bin")
    kb = open(key_bin, "rb").read() if os.path.exists(key_bin) else b""
    opened, raw, how = [], {}, collections.Counter()
    for s in range(16):
        tr = blocks.get(4 * s + 3)
        key_a = tr[0:6] if tr else (kb[s * 6:s * 6 + 6] if len(kb) >= 192 else None)
        key_b = tr[10:16] if tr else (kb[96 + s * 6:102 + s * 6] if len(kb) >= 192 else None)
        if key_a == keys[s]:
            how["hkdf"] += 1
        elif key_a == DEFAULT_KEY or key_b == DEFAULT_KEY:
            how["default"] += 1
        else:
            how["refused" if key_a else "unknown_key"] += 1
            continue
        opened.append(s)
        for b in range(4 * s, 4 * s + 3):
            if blocks.get(b) is not None:
                raw["block_%d" % b] = list(blocks[b])
    return {
        "uid": uid.hex().upper(),
        "sectors": how,
        "creality": creality_detected(uid, blocks),
        "status": "OK" if "block_5" in raw else "AUTH_ERROR",
        "rawBlocks": raw,
    }


def reference(lib, path):
    sys.path.insert(0, lib)
    import parse  # noqa: E402  (décodeur de la bibliothèque, chargé depuis le clone)
    t = parse.Tag(path, open(path, "rb").read()).data
    temps = t["temperatures"]
    return {
        "detailed": t["detailed_filament_type"],
        "type": t["filament_type"],
        "rgb": int(t["filament_color"][1:7], 16),
        "alpha": int(t["filament_color"][7:9], 16),
        "weight": t["spool_weight"].value,
        "length": t["filament_length"].value or None,
        "diameter": round(t["filament_diameter"].value, 2),
        "eMin": temps["min_hotend"].value,
        "eMax": temps["max_hotend"].value,
        "bed": temps["bed_temp"].value,
        "dryT": temps["drying_temp"].value,
        "dryH": temps["drying_time"].value,
        "nozzle": round(t["min_nozzle_diameter"].value, 1),
        "date": str(t["production_date"]),
    }


def norm(s):
    s = (s or "").lower().replace("grey", "gray")
    s = re.sub(r"^translucent ", "", s).replace("transparent", "clear")
    return re.sub(r"[^a-z0-9+]", "", s)


def dart_bin():
    fvm = os.path.join(ROOT, ".fvm", "flutter_sdk", "bin", "dart")
    return fvm if os.path.exists(fvm) else "dart"


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("library", help="clone de Bambu-Lab-RFID-Library")
    ap.add_argument("--details", type=int, default=20, help="écarts détaillés affichés par catégorie")
    args = ap.parse_args()

    files = sorted(glob.glob(os.path.join(args.library, "**", "*-dump.json"), recursive=True))
    if not files:
        sys.exit(f"Aucun *-dump.json sous {args.library}")

    tags = {}
    with tempfile.TemporaryDirectory() as tmp:
        native_in = os.path.join(tmp, "native.jsonl")
        decoded_out = os.path.join(tmp, "decoded.jsonl")
        with open(native_in, "w") as f:
            for path in files:
                rel = os.path.relpath(path, args.library)
                nat = emulate_native(path)
                parts = rel.split(os.sep)
                tags[rel] = {"label_material": parts[1], "label_color": parts[2],
                             "native": nat, "ref": reference(args.library, path)}
                f.write(json.dumps({"path": rel, "rawBlocks": nat["rawBlocks"]}) + "\n")
        subprocess.run([dart_bin(), "run", "tool/bambu_corpus_decode.dart", native_in, decoded_out],
                       cwd=ROOT, check=True)
        for line in open(decoded_out):
            d = json.loads(line)
            tags[d["path"]]["app"] = d

    n = len(tags)
    stats = collections.Counter()
    issues = collections.defaultdict(list)
    for rel, t in tags.items():
        nat, ref, app = t["native"], t["ref"], t["app"]
        if nat["status"] != "OK":
            issues["natif : bloc 5 illisible"].append(rel)
            continue
        if nat["creality"]:
            issues["auto-détection : pris pour un Creality"].append(rel)
        if app["status"] != "OK":
            issues[f"décodage : {app['status']}"].append(f"{rel} {app.get('error', '')}")
            continue
        if app["dropped"]:
            issues["bornes : champ écarté"].append(f"{rel} {app['dropped']}")

        expected_rgb = ref["rgb"] if ref["alpha"] else None
        if expected_rgb is not None and app["colorRgb"] != expected_rgb:
            issues["RGB ≠ référence"].append(f"{rel} {app['colorRgb']:06X} ≠ {expected_rgb:06X}")
        for k in ("weight", "length", "diameter", "eMin", "eMax", "bed", "dryT", "dryH", "nozzle"):
            ours, theirs = app[k], ref[k]
            if ours is None and theirs in (None, 0):
                continue
            if ours is not None and theirs is not None and abs(ours - theirs) < 0.051:
                continue
            issues[f"{k} ≠ référence"].append(f"{rel} {ours} ≠ {theirs}")
        m = re.match(r"(\d{4})-(\d\d)-(\d\d) (\d\d):(\d\d)", ref["date"])
        if m and int(m.group(1)) >= 2015 and (app["date"] or "")[:16].replace("T", " ") != ref["date"][:16]:
            issues["date ≠ référence"].append(f"{rel} {app['date']} ≠ {ref['date']}")

        # Noms : écarts expliqués (tag ou catalogue) ou non.
        if norm(app["material"]) == norm(t["label_material"]):
            stats["material_ok"] += 1
        elif norm(app["material"]) in (norm(ref["detailed"]), norm(ref["type"])):
            stats["material_tag_text"] += 1
        else:
            issues["matériau inexpliqué"].append(f"{rel} app={app['material']} tag={ref['type']}/{ref['detailed']}")
        if norm(app["color"]) == norm(t["label_color"]):
            stats["color_ok"] += 1
        elif app["catalogColor"] and norm(app["color"]) == norm(app["catalogColor"]):
            stats["color_tag_code"] += 1
            issues["couleur ≠ classement, mais = code du tag (à vérifier côté bibliothèque)"].append(
                f"{rel} app={app['color']}")
        else:
            issues["couleur inexpliquée"].append(f"{rel} app={app['color']} rgb={ref['rgb']:06X}")

    print(f"Tags : {n}")
    print(f"Secteurs : {dict(stats_sectors(tags))}")
    print(f"Matériau = classement : {stats['material_ok']}, = texte du tag : {stats['material_tag_text']}")
    print(f"Couleur = classement : {stats['color_ok']}, = code couleur du tag : {stats['color_tag_code']}")
    blocking = 0
    for cat, rows in sorted(issues.items()):
        print(f"\n{cat} : {len(rows)}")
        for r in rows[:args.details]:
            print("  " + r)
        if not cat.startswith(("matériau", "couleur")):
            blocking += len(rows)
    print(f"\nÉchecs bloquants : {blocking}")
    sys.exit(1 if blocking else 0)


def stats_sectors(tags):
    c = collections.Counter()
    for t in tags.values():
        c.update(t["native"]["sectors"])
    return c


if __name__ == "__main__":
    main()
