#!/bin/bash

psxy -JX12c/-10c -R-1/11/-5/5 -P -Ba2g1:"X":/a2f1g1WNse:"Z": -m -W0.2p  path.dat -K > path.ps
psxy -JX         -R -Sm14.12c -W1p,RED -K -O >> path.ps <<EOF
5 -5 225 315
EOF
psxy -JX         -R -S -GBLACK -K -O >> path.ps<<EOF
0  0 c0.2c
10 0 t0.3c
EOF
pstext -JX       -R -O >>path.ps<<EOF
6 -1.5 11 0 0 CM V = 3.0 + 0.6 Z
EOF
ps2raster -A -Tj -E720 path.ps 
