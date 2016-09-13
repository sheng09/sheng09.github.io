#!/bin/bash

PS1="grid.ps"

psbasemap -JX15c/-11c -R-2/13/-2/9 -BWNSE -P  -K > ${PS1}

psxy -JX -R -m -W0.5p,50,-  -K -O >> ${PS1} <<EOF
0  0
10 0
>
0  1
10 1
>
0  2
10 2
>
0  3
10 3
>
0  4
10 4
>
0  5
10 5
>
0  6
10 6
>
0  7
10 7
EOF
psxy -JX -R -m -W0.5p -K -O >> ${PS1} <<EOF
0 0
0 8
>
0 0
12 0
>
10 0
10 8
EOF

psxy -JX -R -St0.3c -GRED -WRED -K -O >> ${PS1} <<EOF
1 0
3 0
5 0
7 0
9 0
1 2
3 2
5 2
7 2
9 2
1 4
3 4
5 4
7 4
9 4
1 6
3 6
5 6
7 6
9 6
EOF

pstext -JX -R -K -O >> ${PS1} <<EOF
-0.7 0 9 0 0 RM 0
-0.7 1 9 0 0 RM dt/2
-0.7 2 9 0 0 RM dt
-0.7 3 9 0 0 RM 3dt/2
-0.7 4 9 0 0 RM 2dt
-0.7 5 9 0 0 RM 5dt/2
-0.7 6 9 0 0 RM 3dt
-0.7 7 9 0 0 RM 7dt/2
EOF

pstext -JX -R -K -O >> ${PS1} <<EOF
0  -0.7 9 0 0 CM 0
1  -0.7 9 0 0 CM dx/2
2  -0.7 9 0 0 CM dx
3  -0.7 9 0 0 CM 3dx/2
4  -0.7 9 0 0 CM 2dx
5  -0.7 9 0 0 CM 5dx/2
6  -0.7 9 0 0 CM 3dx
7  -0.7 9 0 0 CM 7dx/2
8  -0.7 9 0 0 CM 4dx
9  -0.7 9 0 0 CM 9dx/2
10 -0.7 9 0 0 CM 5dx
EOF

pstext -JX -R -K -O >> ${PS1} <<EOF
0    8.5  12 0 1 CM t
12.5 0    12 0 1 CM x
EOF


psxy -JX -R -Sc0.25c -GBLACK -K -O >> ${PS1} <<EOF
0  1
2  1
4  1
6  1
8  1
10 1
0  3
2  3
4  3
6  3
8  3
10 3
0  5
2  5
4  5
6  5
8  5
10 5
0  7
2  7
4  7
6  7
8  7
10 7
EOF



psxy -JX -R -L -W1p,- -K -O >> ${PS1} <<EOF
1.5 3.5
4.5 3.5
4.5 6.5
1.5 6.5
EOF

psxy -JX -R -L -W1p,- -K -O >> ${PS1} <<EOF
6.5 0.5
9.5 0.5
9.5 3.5
6.5 3.5
EOF


pstext -JX -R -K -O >> ${PS1}<<EOF
3.25 4.75 9 0 0 CM A
3.00 5.25 6 0 0 CM (m+1/2, i+1/2)
2.00 5.25 6 0 0 CM i
4.00 5.25 6 0 0 CM i+1
3.00 4.25 6 0 0 CM m
3.00 6.25 6 0 0 CM m+1
EOF

pstext -JX -R -K -O >> ${PS1}<<EOF
8.25 1.75 9 0 0 CM B
8.00 2.25 6 0 0 CM (m, i)
7.00 2.25 6 0 0 CM i-1/2
9.00 2.25 6 0 0 CM 1+1/2
8.00 1.25 6 0 0 CM m-1/2
8.00 3.25 6 0 0 CM m+1/2
EOF

psxy -JX -R -St0.3c -GWHITE -W0.5p,RED, -K -O >>${PS1}<<EOF
3 5
EOF

psxy -JX -R -Sc0.25c -GWHITE -W0.5p, -K -O >>${PS1}<<EOF
8 2
EOF

psxy -JX -R -St0.3c -GRED -K -O >> ${PS1}<<EOF
11 6
EOF

psxy -JX -R -Sc0.25c -GBLACK -K -O >> ${PS1}<<EOF
11 6.5
EOF

pstext -JX -R -O >> ${PS1}<<EOF
11.5 6   9 0 0 CM q
11.5 6.5 9 0 0 CM p
EOF



ps2raster -Tj -A ${PS1}
