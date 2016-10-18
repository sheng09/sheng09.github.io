#!/bin/sh

PS="2order.ps"
psxy -JX18/-10c -R-1/17/0/10 -W2p -K -P >${PS}<<EOF
0.5 1
14 1
EOF
psxy -JX -R -Sc0.2c -GRED -K -O >>${PS}<<EOF
1  1
2  1
3  1
4  1
5  1
6  1
7  1
8  1
9  1
10 1
11 1
12 1
13 1
EOF
psxy -JX -R -Sc0.15c -GBLUE -K -O >>${PS}<<EOF
0.5 1
EOF
pstext -JX -R -GBLUE -K -O >>${PS}<<EOF
0.5 1.3 6 0 6 CM 0
EOF
pstext -JX -R -GRED -O >>${PS}<<EOF
1 1.3 7 0 6 CM 0
2 1.3 7 0 6 CM 1
3 1.3 7 0 6 CM 2
EOF
ps2raster -E600 -Tj -A ${PS}

PS="2Norder.ps"
psxy -JX18/-10c -R-1/17/0/10 -W2p -m -K -P >${PS}<<EOF
0.5 1
4   1
>
5   1
14  1
EOF
psxy -JX -R -W2p,2_2_2_2:2p -K -O -P >>${PS}<<EOF
4   1
5   1
EOF
psxy -JX -R -Sc0.2c -GRED -K -O >>${PS}<<EOF
1  1
2  1
3  1
4  1
5  1
6  1
7  1
8  1
9  1
10 1
11 1
EOF
psxy -JX -R -Sc0.15c -GBLUE -K -O >>${PS}<<EOF
 0.5  1
 1.5  1
 2.5  1
 3.5  1
 5.5  1
 6.5  1
 7.5  1
EOF
pstext -JX -R -GBLUE -K -O >>${PS}<<EOF
0.5  1.3 5 0 6 CM 0
1.5  1.3 5 0 6 CM 1
2.5  1.3 5 0 6 CM 2
3.5  1.3 5 0 6 CM 4
5.5  1.3 5 0 6 CM N-3
6.5  1.3 5 0 6 CM N-2
7.5  1.3 5 0 6 CM N-1
EOF
pstext -JX -R -GRED -O >>${PS}<<EOF
1  1.3 5 0 6 CM 0
2  1.3 5 0 6 CM 1
3  1.3 5 0 6 CM 2
5  1.3 5 0 6 CM 4
6  1.3 5 0 6 CM N-3
7  1.3 5 0 6 CM N-2
8  1.3 5 0 6 CM N-1
EOF
ps2raster -Tj -E600 -A ${PS}