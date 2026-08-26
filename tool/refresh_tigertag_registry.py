#!/usr/bin/env python3
"""Régénère lib/.../tigertag_registry.dart depuis le registre public TigerTag (CC0).

Source : github.com/TigerTag-Project/TigerTag-RFID-Guide/database (miroir des
endpoints api.tigertag.io). Lecture libre, licence CC0-1.0.

Usage :  python3 tool/refresh_tigertag_registry.py
À relancer périodiquement pour capter les nouveaux matériaux/marques/couleurs.
"""
import json
import sys
import urllib.request
from datetime import date, timezone, datetime

BASE = "https://raw.githubusercontent.com/TigerTag-Project/TigerTag-RFID-Guide/main/database"
OUT = "lib/features/nfc_reader/data/services/tigertag_registry.dart"

# Conversion des unités de POIDS vers grammes (label → grammes/unité).
WEIGHT_TO_GRAMS = {
    "µg": 1e-6, "ug": 1e-6, "mg": 0.001, "g": 1.0, "kg": 1000.0,
    "t": 1_000_000.0, "oz": 28.349523125, "lb": 453.59237,
}


def fetch(name):
    url = f"{BASE}/{name}"
    with urllib.request.urlopen(url, timeout=30) as r:
        return json.load(r)


def dart_map_int_str(entries, key_id, key_label):
    lines = []
    for e in sorted(entries, key=lambda x: x[key_id]):
        label = str(e[key_label]).replace("\\", "\\\\").replace("'", "\\'")
        lines.append(f"  {e[key_id]}: '{label}',")
    return "\n".join(lines)


def main():
    materials = fetch("id_material.json")
    brands = fetch("id_brand.json")
    diameters = fetch("id_diameter.json")
    units = fetch("id_measure_unit.json")

    # Unités de poids → grammes
    unit_lines = []
    for u in sorted(units, key=lambda x: x["id"]):
        if u.get("type") == "weight":
            g = WEIGHT_TO_GRAMS.get(u["label"])
            if g is not None:
                unit_lines.append(f"  {u['id']}: {g}, // {u['label']}")

    try:
        lu = fetch("last_update.json")
        src_stamp = json.dumps(lu) if isinstance(lu, (str, int)) else str(lu)
    except Exception:
        src_stamp = "n/a"

    today = date.today().isoformat()
    content = f"""// GÉNÉRÉ depuis TigerTag-RFID-Guide/database (CC0). Ne pas éditer à la main.
// Régénérer : python3 tool/refresh_tigertag_registry.py
// Snapshot du {today}. Le tag ne stocke que des IDs entiers ; ces tables
// résolvent les noms. Source : github.com/TigerTag-Project/TigerTag-RFID-Guide

/// ID Material (u16) → nom affichable (ex: 'PLA', 'PETG-CF').
const Map<int, String> kTigerTagMaterials = {{
{dart_map_int_str(materials, 'id', 'label')}
}};

/// ID Brand (u16) → nom de marque.
const Map<int, String> kTigerTagBrands = {{
{dart_map_int_str(brands, 'id', 'name')}
}};

/// ID Diameter (u8) → diamètre en mm (string).
const Map<int, String> kTigerTagDiameters = {{
{dart_map_int_str(diameters, 'id', 'label')}
}};

/// ID Unit (u8) → facteur de conversion vers grammes (poids uniquement).
const Map<int, double> kTigerTagUnitToGrams = {{
{chr(10).join(unit_lines)}
}};
"""
    with open(OUT, "w", encoding="utf-8") as f:
        f.write(content)

    print(f"✅ {OUT} régénéré")
    print(f"   materials={len(materials)} brands={len(brands)} "
          f"diameters={len(diameters)} weight_units={len(unit_lines)}")


if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print(f"❌ échec: {e}", file=sys.stderr)
        sys.exit(1)
