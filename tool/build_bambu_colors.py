#!/usr/bin/env python3
"""Génère lib/core/constants/bambu_colors.g.dart : couleurs officielles des
filaments Bambu Lab, pour nommer la couleur lue sur un tag RFID Bambu.

Source : filaments_color_codes.json de BambuStudio (épinglé sur un commit).
Seules des données FACTUELLES sont reprises (identifiant de filament, code
couleur, nom commercial anglais, codes RGB), pas de code.

Le tag porte l'identifiant de filament (bloc 1, octets 8-15, ex. « GFA00 ») et
la variante (bloc 1, octets 0-7, ex. « A00-W1 ») : la partie après le tiret est
le `color_code` de ce fichier. Validé le 04.10.2026 sur 262 dumps réels
(bibliothèque communautaire Bambu-Lab-RFID-Library) : 257 noms exacts.

Usage : python3 tool/build_bambu_colors.py [commit]
À relancer quand Bambu sort de nouvelles couleurs (mettre à jour COMMIT).
"""
import json
import sys
import urllib.request

COMMIT = "804d93bb5de142c48c0dabedba87736ea9553206"  # 22.09.2026
PATH = "resources/profiles/BBL/filament/filaments_color_codes.json"
OUT = "lib/core/constants/bambu_colors.g.dart"


def dart_str(s):
    return "'" + s.replace("\\", "\\\\").replace("'", "\\'").replace("$", "\\$") + "'"


def main():
    commit = sys.argv[1] if len(sys.argv) > 1 else COMMIT
    url = f"https://raw.githubusercontent.com/bambulab/BambuStudio/{commit}/{PATH}"
    req = urllib.request.Request(url, headers={"User-Agent": "SpoolMaster-tool"})
    with urllib.request.urlopen(req, timeout=30) as r:
        data = json.load(r)["data"]

    rows = []
    seen = set()
    for e in data:
        fila_id = (e.get("fila_id") or "").strip()
        code = (e.get("color_code") or "").strip()
        name = ((e.get("fila_color_name") or {}).get("en") or "").strip()
        colors = [c.strip().lstrip("#")[:6].upper() for c in e.get("fila_color") or []]
        if not (fila_id and code and name and colors):
            continue
        if (fila_id, code) in seen:
            continue
        seen.add((fila_id, code))
        rgb = ", ".join(f"0x{c}" for c in colors)
        rows.append(
            f"  BambuColor({dart_str(fila_id)}, {dart_str(e.get('fila_type') or '')}, "
            f"{dart_str(code)}, {dart_str(name)}, [{rgb}]),"
        )

    rows.sort()
    header = f"""// GÉNÉRÉ par tool/build_bambu_colors.py : ne pas modifier à la main.
// Source : bambulab/BambuStudio@{commit[:12]} {PATH}
// {len(rows)} couleurs (identifiant de filament, code couleur, nom anglais, RGB).

/// Couleur officielle d'un filament Bambu Lab.
class BambuColor {{
  const BambuColor(this.filaId, this.type, this.code, this.name, this.rgb);

  /// Identifiant du filament (bloc 1 du tag, ex. « GFA00 »).
  final String filaId;

  /// Type détaillé (ex. « PLA Basic »).
  final String type;

  /// Code couleur : partie après le tiret de la variante du tag (ex. « W1 »).
  final String code;

  /// Nom commercial anglais (ex. « Jade White »).
  final String name;

  /// Couleur(s) RGB 24 bits : plusieurs pour les dégradés et multicolores.
  final List<int> rgb;
}}

const List<BambuColor> bambuColors = [
"""
    with open(OUT, "w", encoding="utf-8") as f:
        f.write(header + "\n".join(rows) + "\n];\n")
    print(f"{OUT} : {len(rows)} couleurs")


if __name__ == "__main__":
    main()
