#!/bin/bash

PS1="grid.ps"
LINE="0.5p,0"

ANGLE="-203/35"

GRID_X="tmp_x.txt"
GRID_Z="tmp_z.txt"

cat >${GRID_Z} <<EOF
>
0 0 0
0 0 8
>
0 2 0
0 2 8
>
0 4 0
0 4 8
>
0 6 0
0 6 8
>
0 8 0
0 8 8
EOF

cat >${GRID_X} <<EOF
>
0 0 0
0 8 0
>
0 0 2
0 8 2
>
0 0 4
0 8 4
>
0 0 6
0 8 6
>
0 0 8
0 8 8
EOF

psxyz -JX8c/8c -JZ8c -E${ANGLE} -R-1/9/-1/9/-1/9 -GBLUE -Su0.25c -P -K >${PS1}<<EOF
EOF

psxyz -JX -JZ -E${ANGLE} -R -W0.5p,0 -m -K -O >>${PS1}<<EOF
0 0 8
0 9 8
>
0 0 6
0 0 -1
>
EOF
psxyz -JX -JZ -E${ANGLE} -R -W0.5p,0,-  -m -K -O >>${PS1}<<EOF
0  8 8
10 8 8
>
0  0 0
10 0 0
>
0 8 0
10 8 0
EOF

psxyz -JX -JZ -L -E${ANGLE} -R -W1p,200/200/255 -G200/200/255 -P -K -O >> ${PS1}<<EOF
0 4 4
8 4 4
8 8 4
0 8 4
EOF
psxyz -JX -JZ -E${ANGLE} -R -m -W2p,BLUE -P -K -O >> ${PS1} <<EOF
0 6 4
8 6 4
>
4 4 4
4 8 4
EOF

psxyz -JX -JZ -L -E${ANGLE} -R -W1p,255/200/200 -G255/200/200 -P -K -O >> ${PS1}<<EOF
0 4 0
8 4 0
8 4 4
0 4 4
EOF

psxyz -JX -JZ -E${ANGLE} -m -R -W2p,RED -P -K -O >> ${PS1} <<EOF
0 4 2
8 4 2
>
4 4 0
4 4 4
EOF


for x in 0 4 8
do
	cat ${GRID_X} | awk -vx=${x} '$1==">"{print $0} $1!=">"{print x,$2,$3}' |
		psxyz -JX8c/8c -JZ8c -E${ANGLE} -R-1/9/-1/9/-1/9  -m -W${LINE} -P -K -O  >> ${PS1}
	cat ${GRID_Z} | awk -vz=${x} '$1==">"{print $0} $1!=">"{print z,$2,$3}' |
		psxyz -JX8c/8c -JZ8c -E${ANGLE} -R-1/9/-1/9/-1/9  -m -W${LINE} -P -K -O  >> ${PS1}

	if [[ $x == 4 ]] || [[ $x == 12 ]]; then
		echo $x
		#statements
		psxyz -JX -JZ -E${ANGLE} -R -GBLACK -Su0.25c -K -O >>${PS1}<<EOF
12 0 8
$x 0 8
$x 4 8
$x 8 8
$x 0 4
$x 4 4
$x 8 4
$x 0 0
$x 4 0
$x 8 0
EOF
		psxyz -JX -JZ -E${ANGLE} -R -G255/200/200 -Su0.25c -K -O >>${PS1}<<EOF
$x 0 6
$x 0 2
$x 4 6
$x 4 2
$x 8 6
$x 8 2
EOF

		psxyz -JX -JZ -E${ANGLE} -R -G200/200/255 -Su0.25c -K -O >>${PS1}<<EOF
$x 2 8
$x 6 8
$x 2 4
$x 6 4
$x 2 0
$x 6 0
EOF
	else
		psxyz -JX -JZ -E${ANGLE} -R -G200/200/200 -Su0.25c -K -O >>${PS1}<<EOF
$x 0 8
$x 4 8
$x 8 8
$x 0 4
$x 4 4
$x 8 4
$x 0 0
$x 4 0
$x 8 0
EOF
		psxyz -JX -JZ -E${ANGLE} -R -G100/0/0 -Su0.25c -K -O >>${PS1}<<EOF
$x 0 6
$x 0 2
$x 4 6
$x 4 2
$x 8 6
$x 8 2
EOF

		psxyz -JX -JZ -E${ANGLE} -R -G0/0/100 -Su0.25c -K -O >>${PS1}<<EOF
$x 2 8
$x 6 8
$x 2 4
$x 6 4
$x 2 0
$x 6 0
EOF
	fi
done


psxyz -JX -JZ -E${ANGLE} -R -GBLUE -Su0.25c -K -O >>${PS1}<<EOF

EOF

pstext -JX13c/13c -R0/13/0/13  -G50/50/000 -O >>${PS1}<<EOF
5.83 7.05 7 0 0 CM A
2.91 7.78 7 0 0 CM C
8.78 6.32 7 0 0 CM D
5.2  6.23 7 0 0 CM E
6.45 7.9  7 0 0 CM F
5.2  4.95 7 0 0 CM B
5.2  3.62 7 0 0 CM G
2.25 5.62 7 0 0 CM H
8.15 4.17 7 0 0 CM J
EOF


ps2raster -Tj -E600 -A ${PS1}



PS2="p.ps"

psxyz -JX8c/8c -JZ8c -E${ANGLE} -R-1/9/-1/9/-1/9 -m -P -K >${PS2}<<EOF
0 6 4
8 6 4
>
4 6 6
4 6 2
>
4 8 4
4 4 4
EOF

psxyz -JX8c/8c -JZ8c -E${ANGLE} -R-1/9/-1/9/-1/9 -GBLACK -Su0.25c -P -K -O >>${PS2}<<EOF
0 6 4
8 6 4
EOF

psxyz -JX8c/8c -JZ8c -E${ANGLE} -R-1/9/-1/9/-1/9 -G100/0/0 -Su0.25c -P -K -O >>${PS2}<<EOF
4 6 6
4 6 2
EOF

psxyz -JX8c/8c -JZ8c -E${ANGLE} -R-1/9/-1/9/-1/9 -G0/0/100 -Su0.25c -P -K -O >>${PS2}<<EOF
4 8 4
4 4 4
EOF


psxyz -JX8c/8c -JZ8c -E${ANGLE} -R-1/9/-1/9/-1/9 -G200/200/200 -Su0.25c -P -O >>${PS2}<<EOF
4 6 4
EOF

ps2raster -Tj -E600 -A ${PS2}



PS3="q_x.ps"

psxyz -JX8c/8c -JZ8c -E${ANGLE} -R-1/9/-1/9/-1/9 -m -P -K >${PS3}<<EOF
4 0 0
4 4 0
>
0 2 0
8 2 0
EOF

psxyz -JX8c/8c -JZ8c -E${ANGLE} -R-1/9/-1/9/-1/9 -GBLACK -Su0.25c -P -K -O >>${PS3}<<EOF
4 0 0
4 4 0
EOF

psxyz -JX8c/8c -JZ8c -E${ANGLE} -R-1/9/-1/9/-1/9 -G0/0/100 -Su0.25c -P -K -O >>${PS3}<<EOF
0 2 0
8 2 0
EOF

psxyz -JX8c/8c -JZ8c -E${ANGLE} -R-1/9/-1/9/-1/9 -G200/200/255 -Su0.25c -P -O >>${PS3}<<EOF
4 2 0
EOF

ps2raster -Tj -E600 -A ${PS3}


PS4="q_z.ps"

psxyz -JX8c/8c -JZ8c -E${ANGLE} -R-1/9/-1/9/-1/9 -m -P -K >${PS4}<<EOF
4 0 0
4 0 4
>
0 0 2
8 0 2
EOF

psxyz -JX8c/8c -JZ8c -E${ANGLE} -R-1/9/-1/9/-1/9 -GBLACK -Su0.25c -P -K -O >>${PS4}<<EOF
4 0 0
4 0 4
EOF

psxyz -JX8c/8c -JZ8c -E${ANGLE} -R-1/9/-1/9/-1/9 -G100/0/0 -Su0.25c -P -K -O >>${PS4}<<EOF
0 0 2
8 0 2
EOF

psxyz -JX8c/8c -JZ8c -E${ANGLE} -R-1/9/-1/9/-1/9 -G255/200/200 -Su0.25c -P -O >>${PS4}<<EOF
4 0 2
EOF

ps2raster -Tj -E600 -A ${PS4}