#!/usr/bin/env python3
"""Génère lib/.../filament_library.dart : listes de marques + matériaux pour
l'autocomplete de saisie manuelle (après un scan non reconnu).

Fusion de sources FACTUELLES (noms de marques / types de matériau — non
copyrightables), snapshot BUNDLÉ offline (pas de dépendance runtime) :
  - FilaMan FilamentDB (db.filaman.app/api/v1) : 327 marques, 76 matériaux
  - TigerTag registry (CC0) : marques + matériaux
  - marques imprimantes 3D connues de l'app

Usage : python3 tool/build_filament_library.py
À relancer périodiquement pour rafraîchir.
"""
import json
import re
import sys
import urllib.request
from datetime import date

OUT = "lib/features/nfc_reader/data/services/filament_library.dart"
FILAMAN = "https://db.filaman.app/api/v1"
TIGERTAG = "https://raw.githubusercontent.com/TigerTag-Project/TigerTag-RFID-Guide/main/database"

# Marques connues de l'app (imprimantes/filaments majeurs) — priorité d'affichage.
KNOWN_BRANDS = [
    "Anycubic", "Bambu Lab", "Prusa", "Prusament", "Creality", "Elegoo",
    "Sunlu", "eSUN", "Polymaker", "Overture", "Hatchbox",
]
# Matériaux de base garantis (au cas où une source manque).
BASE_MATERIALS = ["PLA", "PLA+", "PETG", "ABS", "ASA", "TPU", "PC", "PA", "PVA", "HIPS"]


def get_json(url):
    req = urllib.request.Request(url, headers={"User-Agent": "SpoolMaster-tool"})
    with urllib.request.urlopen(req, timeout=30) as r:
        return json.load(r)


def filaman_all(endpoint, field):
    """Récupère tous les items paginés d'un endpoint FilaMan → liste de noms."""
    names, page = [], 1
    while True:
        d = get_json(f"{FILAMAN}/{endpoint}?page={page}")
        items = d.get("items", [])
        names += [it[field] for it in items if it.get(field)]
        total = d.get("total", len(names))
        if len(names) >= total or not items:
            break
        page += 1
    return names


def clean(name):
    return re.sub(r"\s+", " ", str(name).strip())


def dedupe_sorted(names):
    """Dédup insensible à la casse (garde la 1re occurrence), tri alpha."""
    seen, out = {}, []
    for n in names:
        n = clean(n)
        if not n:
            continue
        k = n.lower()
        if k not in seen:
            seen[k] = True
            out.append(n)
    return sorted(out, key=lambda s: s.lower())


def dart_list(names):
    return "\n".join(f"  '{n.replace(chr(92), chr(92)*2).replace(chr(39), chr(92)+chr(39))}'," for n in names)


def main():
    # Marques
    brands = list(KNOWN_BRANDS)
    brands += filaman_all("manufacturers", "name")
    tt_brands = get_json(f"{TIGERTAG}/id_brand.json")
    brands += [b["name"] for b in tt_brands if b.get("name")]
    brands = dedupe_sorted(brands)

    # Matériaux
    materials = list(BASE_MATERIALS)
    materials += filaman_all("materials", "name")
    tt_mats = get_json(f"{TIGERTAG}/id_material.json")
    materials += [m["label"] for m in tt_mats if m.get("label") and m["label"] != "None"]
    materials = dedupe_sorted(materials)

    today = date.today().isoformat()
    content = f"""// GÉNÉRÉ — ne pas éditer à la main. Régénérer :
//   python3 tool/build_filament_library.py
// Snapshot du {today}. Noms factuels (marques / types de matériau) fusionnés
// depuis FilaMan FilamentDB (db.filaman.app), TigerTag (CC0) et les marques
// connues de l'app. Sert l'autocomplete de saisie manuelle (offline).

/// Marques de filament pour l'autocomplete ({len(brands)} entrées).
const List<String> kFilamentBrands = [
{dart_list(brands)}
];

/// Types de matériau pour l'autocomplete ({len(materials)} entrées).
const List<String> kFilamentMaterials = [
{dart_list(materials)}
];
"""
    with open(OUT, "w", encoding="utf-8") as f:
        f.write(content)
    print(f"✅ {OUT} — {len(brands)} marques, {len(materials)} matériaux")


if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print(f"❌ échec: {e}", file=sys.stderr)
        sys.exit(1)
