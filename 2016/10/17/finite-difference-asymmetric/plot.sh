#!/bin/sh

PS="img.ps"
#psbasemap -JX17/-10c -R0/17/0/10 -B -P -K > ${PS}
psxy -JX17/-10c -R0/17/0/10 -W2p -m -K -P >${PS}<<EOF
1 1
14 1
>
1 2
14 2
>
1 3
14 3
>
1 4
14 4
>
1 5
14 5
>
1 6
14 6
>
>
1  8
7  8
>
8  8
14 8
>
EOF
psxy -JX -R -m -W2p,2_2_2_2:2p. -K -O >>${PS}<<EOF
7 8
8 8
>
1 7
2 7
EOF

#2ord
psxy -JX -R -Sc0.2c -GBLUE -K -O >>${PS}<<EOF
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
14 1
3  2
4  2
5  2
6  2
7  2
8  2
9  2
10 2
11 2
12 2
13 2
14 2
4  3
5  3
6  3
7  3
8  3
9  3
10 3
11 3
12 3
13 3
14 3
5  4
6  4
7  4
8  4
9  4
10 4
11 4
12 4
13 4
14 4
6  5
7  5
8  5
9  5
10 5
11 5
12 5
13 5
14 5
7  6
8  6
9  6
10 6
11 6
12 6
13 6
14 6
10 8
11 8
12 8
13 8
14 8
#12 8
EOF
psxy -JX -R -Sc0.2c -GRED -K -O >>${PS}<<EOF
1  1
1  2
2  2
1  3
2  3
3  3
1  4
2  4
3  4
4  4
1  5
2  5
3  5
4  5
5  5
1  6
2  6
3  6
4  6
5  6
6  6
1  8
2  8
3  8
4  8
5  8
6  8
7  8
8  8
9  8
#12 7
EOF

pstext -JX -R -GRED -K -O >>${PS}<<EOF
0.5 1 8 0 1 CM 1
0.5 2 8 0 1 CM 2
0.5 3 8 0 1 CM 3
0.5 4 8 0 1 CM 4
0.5 5 8 0 1 CM 5
0.5 6 8 0 1 CM 6
0.5 8 8 0 1 CM i
EOF

pstext -JX -R -GRED -K -O >>${PS}<<EOF
1 1.3 7 0 6 CM 0
1 2.3 7 0 6 CM 0
2 2.3 7 0 6 CM 1
1 3.3 7 0 6 CM 0
2 3.3 7 0 6 CM 1
3 3.3 7 0 6 CM 2
1 4.3 7 0 6 CM 0
2 4.3 7 0 6 CM 1
3 4.3 7 0 6 CM 2
4 4.3 7 0 6 CM 3
1 5.3 7 0 6 CM 0
2 5.3 7 0 6 CM 1
3 5.3 7 0 6 CM 2
4 5.3 7 0 6 CM 3
5 5.3 7 0 6 CM 4
1 6.3 7 0 6 CM 0
2 6.3 7 0 6 CM 1
3 6.3 7 0 6 CM 2
4 6.3 7 0 6 CM 3
5 6.3 7 0 6 CM 4
6 6.3 7 0 6 CM 5
1 8.3 7 0 6 CM 0
2 8.3 7 0 6 CM 1
3 8.3 7 0 6 CM 2
4 8.3 7 0 6 CM 3
5 8.3 7 0 6 CM 4
6 8.3 7 0 6 CM 5
7 8.3 7 0 6 CM 6
8 8.3 7 0 6 CM i-2
9 8.3 7 0 6 CM i-1
EOF

pstext -JX -R -O >>${PS}<<EOF
14.5 1 8 0 1 LM 2nd  order
14.5 2 8 0 1 LM 4th  order
14.5 3 8 0 1 LM 6th  order
14.5 4 8 0 1 LM 8th  order
14.5 5 8 0 1 LM 10th order
14.5 6 8 0 1 LM 12th order
14.5 8 8 0 1 LM 2ith order
#12.5   7 8 0 1 LM asymmetric FD scheme
#12.5   8 8 0 1 LM symmetric FD scheme
EOF

ps2raster -Tj -A ${PS}