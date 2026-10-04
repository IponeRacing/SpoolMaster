#!/usr/bin/env python3
"""Génère lib/core/constants/creality_materials.g.dart : matériaux Creality
(code du tag → marque, nom, type, températures), pour décoder et écrire les
tags RFID Creality CFS.

Source : material_database.json de Creality (réponse de l'API Creality Print),
publié dans DnG-Crafts/K2-RFID (docs/), épinglé sur un commit. Seules des
données FACTUELLES sont reprises (code, marque, nom commercial, type,
températures de buse et de plateau), pas de code.

Le tag porte « 1 » + code matériau à 5 chiffres (octets 11-16 du texte clair) ;
l'app lit le code aux octets 12-16. Avant (jusqu'à la 1.4.10+92), la table de
l'app était fausse pour la plupart des codes (ex. 03001 « PLA Silk » au lieu de
« Hyper ABS ») : matériau faux à la lecture, code faux à l'écriture.

Usage : python3 tool/build_creality_materials.py [commit]
"""
import json
import sys
import urllib.request

COMMIT = "8db645afe07048546ca8b8483f9f0af81e5790ff"  # 15.05.2025
PATH = "docs/material_database.json"
OUT = "lib/core/constants/creality_materials.g.dart"


def dart_str(s):
    return "'" + s.replace("\\", "\\\\").replace("'", "\\'").replace("$", "\\$") + "'"


def to_int(v):
    try:
        return int(float(v))
    except (TypeError, ValueError):
        return 0


def main():
    commit = sys.argv[1] if len(sys.argv) > 1 else COMMIT
    url = f"https://raw.githubusercontent.com/DnG-Crafts/K2-RFID/{commit}/{PATH}"
    req = urllib.request.Request(url, headers={"User-Agent": "SpoolMaster-tool"})
    with urllib.request.urlopen(req, timeout=30) as r:
        items = json.load(r)["result"]["list"]

    rows = {}
    for it in items:
        b = it.get("base") or {}
        kv = it.get("kvParam") or {}
        code = (b.get("id") or "").strip()
        name = (b.get("name") or "").strip()
        if len(code) != 5 or not code.isdigit() or not name or code in rows:
            continue
        nozzle_min = to_int(kv.get("nozzle_temperature_range_low") or b.get("minTemp"))
        nozzle_max = to_int(kv.get("nozzle_temperature_range_high") or b.get("maxTemp"))
        bed = to_int(kv.get("hot_plate_temp") or kv.get("textured_plate_temp"))
        rows[code] = (
            f"  CrealityMaterial({dart_str(code)}, {dart_str((b.get('brand') or '').strip())}, "
            f"{dart_str(name)}, {dart_str((b.get('meterialType') or b.get('materialType') or '').strip())}, "
            f"{nozzle_min}, {nozzle_max}, {bed}),"
        )

    body = "\n".join(rows[k] for k in sorted(rows))
    header = f"""// GÉNÉRÉ par tool/build_creality_materials.py : ne pas modifier à la main.
// Source : material_database.json de Creality, DnG-Crafts/K2-RFID@{commit[:12]} {PATH}
// {len(rows)} matériaux (code du tag, marque, nom, type, buse min/max, plateau).

/// Matériau Creality identifié par le code à 5 chiffres du tag CFS.
class CrealityMaterial {{
  const CrealityMaterial(this.code, this.brand, this.name, this.type,
      this.nozzleMin, this.nozzleMax, this.bedTemp);

  final String code;
  final String brand;

  /// Nom commercial (ex. « Hyper PLA »).
  final String name;

  /// Type de base (ex. « PLA », « PETG », « PA-CF »).
  final String type;

  /// Températures recommandées par Creality (°C, 0 = inconnue).
  final int nozzleMin;
  final int nozzleMax;
  final int bedTemp;
}}

const List<CrealityMaterial> crealityMaterials = [
"""
    with open(OUT, "w", encoding="utf-8") as f:
        f.write(header + body + "\n];\n")
    print(f"{OUT} : {len(rows)} matériaux")


if __name__ == "__main__":
    main()
