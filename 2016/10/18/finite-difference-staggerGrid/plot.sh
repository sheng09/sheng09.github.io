#!/bin/sh

PS=img.ps
psxy -JX11c/5c -R-0.5/11.5/0/5 -W2p -K -P >${PS}<<EOF
0.5  3
10.5 3
EOF
psxy -JX -R -W2p,2_2_2_2:2p. -m -K -O >>${PS}<<EOF
0.5 3
0 3
>
10.5 3
11 3
EOF
pstext -JX -R -K -O >>${PS}<<EOF
1   2.7 6 0 6 CM k-4
2   2.7 6 0 6 CM k-3
3   2.7 6 0 6 CM k-2
4   2.7 6 0 6 CM k-1
5   2.7 6 0 6 CM k
5.5 2.7 6 0 6 CM x
6   2.7 6 0 6 CM k+1
7   2.7 6 0 6 CM k+2
8   2.7 6 0 6 CM k+3
9   2.7 6 0 6 CM k+4
10  2.7 6 0 6 CM k+5

EOF
psxy -JX -R -Sc0.15c -GBLUE -K -O >>${PS}<<EOF
5.5 3
EOF
psxy -JX -R -Sc0.2c -GRED -O >>${PS}<<EOF
1  3
2  3
3  3
4  3
5  3
6  3
7  3
8  3
9  3
10 3
EOF

ps2raster -Tj -A ${PS}