#!/bin/bash

cat model.dat | awk 'NR>=13{ print $0}' > tmp

echo ">" > mode_Z_VS.tmp
> mod.xy.tmp
DEP=0.0
while read line;do
        H=`      echo ${line}  | awk '{print $1} '`
        VP=`     echo ${line}  | awk '{print $2} '`
        VS=`     echo ${line}  | awk '{print $3} '`

        TOP=${DEP}
        DEP=`echo "scale=10;(${DEP} + $H)" | bc`
        BOT=${DEP}

        echo ${TOP} ${VS} >> mode_Z_VS.tmp
        echo ${BOT} ${VS} >> mode_Z_VS.tmp

        echo ">"        >> mod.xy.tmp
        echo -10 ${TOP} >> mod.xy.tmp
        echo 200 ${TOP} >> mod.xy.tmp
done < tmp

gmtset ANNOT_FONT_SIZE_PRIMARY  = 12p
gmtset LABEL_FONT_SIZE          = 12p
gmtset HEADER_FONT_SIZE         = 12p
gmtset HEADER_OFFSET            = 0.1c
gmtset LABEL_OFFSET             = 0c
gmtset ANNOT_OFFSET_PRIMARY     = 0.2c
#####
#    Plot model Z-VS image
#####
PS_MODEL="model.ps"
MAXDEP=`echo "scale=1;(${TOP} + 10)" |bc`
psbasemap -JX2c/-6c -R2/6/0/${MAXDEP} -Ba2f1:"Vs(km/s)":/a10f10:"Depth(km)":WSne -K -X2c > ${PS_MODEL}
psxy  mode_Z_VS.tmp -: -JX -R -W2p -m -K -O >> ${PS_MODEL}

#####
#    Generate ray path for "Pp Ps PpPs PpSs PsSs"
#    and
#    Plot ray path for "Pp Ps PpPs PpSs PsSs"
#####
#gcc RayPath.c -lm -O4 -o RayPath -Wall

RP=`CalRayPara.py 30.0 6.0`
makecpt -Cseis -T-1/1/0.1 > cpt.tmp
psxy mod.xy.tmp -JX8/-6 -R-10/200/0/${MAXDEP} -m -K -O -X2.4c >> ${PS_MODEL}

RayPath -Mtmp -Rps -Oray.xy.tmp -P${RP}
psxy ray.xy.tmp    -W-1p  -Ccpt.tmp -JX -R -m -K -O >> ${PS_MODEL}

RayPath -Mtmp -Rpp -Oray.xy.tmp -P${RP}
psxy ray.xy.tmp   -W-1p  -Ccpt.tmp -JX -R -m -K -O >> ${PS_MODEL}

RayPath -Mtmp -RppPs -Oray.xy.tmp -P${RP}
psxy ray.xy.tmp   -W-1p  -Ccpt.tmp -JX -R -m -K -O >> ${PS_MODEL}

RayPath -Mtmp -RppSs -Oray.xy.tmp -P${RP}
psxy ray.xy.tmp   -W-1p  -Ccpt.tmp -JX -R -m -K -O >> ${PS_MODEL}

RayPath -Mtmp -RpsPs -Oray.xy.tmp -P${RP}
psxy ray.xy.tmp   -W-1p  -Ccpt.tmp -JX -R -m -K -O >> ${PS_MODEL}

RP=`echo ${RP} |awk '{printf( "%6.4f", $0 )}'`
#echo $RP
pstext -JX -R -O >> ${PS_MODEL} << EOF
200 0 12 0 1 RT Ray Parameter ${RP} (s/km)
EOF

ps2raster ${PS_MODEL} -A -Tj -E600 -P
rm *tmp -rf
