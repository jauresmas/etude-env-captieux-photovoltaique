# -*- coding: utf-8 -*-
"""Genere le plan d'implantation du scenario d'etude (DXF ASCII R12).

Le plan est calé en Lambert-93 (EPSG:2154) sur le perimetre de 49 ha defini dans
postgis/analyses.sql. Calques produits : CLOTURE, PISTE_ACCES, POSTE_LIVRAISON, TABLES_PV.
Usage : python 02_generer_plan_dxf.py
"""
from pathlib import Path

OUT_PATH = Path(__file__).resolve().parent.parent / "dwg" / "plan_implantation_pv_captieux.dxf"
OUT_PATH.parent.mkdir(exist_ok=True)

XMIN, YMIN, XMAX, YMAX = 435430.7, 6356476.0, 436130.7, 6357176.0

entities = []  # (calque, type, points)

inset = 20
cx0, cy0, cx1, cy1 = XMIN + inset, YMIN + inset, XMAX - inset, YMAX - inset
entities.append(("CLOTURE", "POLYLIGNE_FERMEE", [(cx0, cy0), (cx1, cy0), (cx1, cy1), (cx0, cy1)]))

midx, midy = (cx0 + cx1) / 2, (cy0 + cy1) / 2
entities.append(("PISTE_ACCES", "LIGNE", [(cx0 + 5, midy), (cx1 - 5, midy)]))
entities.append(("PISTE_ACCES", "LIGNE", [(midx, cy0 + 5), (midx, cy1 - 5)]))
entities.append(("PISTE_ACCES", "LIGNE", [(cx1 - 5, cy0 + 5), (cx1 + 180, cy0 - 260)]))

px0, py0, px1, py1 = cx1 - 40, cy0 + 10, cx1 - 20, cy0 + 25
entities.append(("POSTE_LIVRAISON", "POLYLIGNE_FERMEE", [(px0, py0), (px1, py0), (px1, py1), (px0, py1)]))

# Tables photovoltaiques : longueur 30 m (est-ouest), largeur 2,5 m
table_w, table_h = 30.0, 2.5
step_x, step_y = 35.0, 8.0
margin = 15.0

x = cx0 + margin
while x + table_w < cx1 - margin:
    y = cy0 + margin
    while y + table_h < cy1 - margin:
        sur_piste = abs((x + table_w / 2) - midx) < 6 or abs((y + table_h / 2) - midy) < 6
        if not sur_piste:
            entities.append(("TABLES_PV", "POLYLIGNE_FERMEE",
                             [(x, y), (x + table_w, y), (x + table_w, y + table_h), (x, y + table_h)]))
        y += step_y
    x += step_x


def polyligne_fermee(calque, pts):
    out = ["0\nPOLYLINE\n8\n%s\n66\n1\n70\n1\n" % calque]
    for px, py in pts:
        out.append("0\nVERTEX\n8\n%s\n10\n%.3f\n20\n%.3f\n30\n0.0\n" % (calque, px, py))
    out.append("0\nSEQEND\n")
    return "".join(out)


def ligne(calque, p0, p1):
    return ("0\nLINE\n8\n%s\n10\n%.3f\n20\n%.3f\n30\n0.0\n11\n%.3f\n21\n%.3f\n31\n0.0\n"
            % (calque, p0[0], p0[1], p1[0], p1[1]))


corps = []
for calque, kind, pts in entities:
    corps.append(polyligne_fermee(calque, pts) if kind == "POLYLIGNE_FERMEE" else ligne(calque, pts[0], pts[1]))

with open(OUT_PATH, "w", encoding="ascii") as f:
    f.write("0\nSECTION\n2\nENTITIES\n" + "".join(corps) + "0\nENDSEC\n0\nEOF\n")

print("DXF ecrit :", OUT_PATH)
print("Entites :", len(entities), "| tables PV :", sum(1 for e in entities if e[0] == "TABLES_PV"))
