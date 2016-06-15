#!/bin/bash

rm models/*.ps models/*.eps -r 2>/dev/null
ls models/*.model > model.list.tmp
RP=0.0618
makecpt -Cseis -T-1/1/0.1 > cpt.tmp

gmtset ANNOT_FONT_SIZE_PRIMARY  = 12p
gmtset LABEL_FONT_SIZE          = 12p
gmtset HEADER_FONT_SIZE         = 12p
gmtset HEADER_OFFSET            = 0.1c
gmtset LABEL_OFFSET             = 0c
gmtset ANNOT_OFFSET_PRIMARY     = 0.2c
gmtset CHAR_ENCODING            = Standard+



makecpt -Crainbow -T0/20/1 -Z -I > tmp.cpt
IMGGlobal="models/VS.ps"
IMGGlobalVP="models/VP.ps"
IMGGlobalRHO="models/RHO.ps"
psbasemap -JX5/-10 -R3/5/0/65       -Ba0.5f0.1:"Vs(km/s)":/a10f2:"Depth(km)":WSne -K -X2c > ${IMGGlobal}
psbasemap -JX5/-10 -R5.5/8.5/0/65   -Ba0.5f0.1:"Vp(km/s)":/a10f2:"Depth(km)":WSne -K -X2c > ${IMGGlobalVP}
psbasemap -JX5/-10 -R2.5/3.5/0/65   -Ba0.5f0.1:"RHO(km/m^3)":/a10f2:"Depth(km)":WSne -K -X2c > ${IMGGlobalRHO}
while read  MODEL;do
        echo "Ploting ${MODEL}"
        cat ${MODEL} | awk 'NR>=13{ print $0}' > tmp
        i=` echo ${MODEL} | sed -e s'/[a-zA-Z/.]//g' | awk -F_ '{print $4}'`
        IMG=`echo ${MODEL} | awk -F. '{print $1}'`
        IMG=${IMG}.ps
        n=` echo "$i*4+1" | bc`
        #echo $i $n
        pup=`python << EOF
str='p'
print str * $n
EOF`
        pdw=`python << EOF
str='P'
print str * $n
EOF`
        sup=`python << EOF
str='s'
print str * $n
EOF`
        sdw=`python << EOF
str='S'
print str * $n
EOF`
        Pp=p${pup}
        Ps=p${sup}
        PpPs=p${pup}${pdw}${sup}
        PsPs=p${sup}${pdw}${sup}
        #echo $Pp $IMG $PpPs $PsPs
        #
        echo "> -Z${i}" > mode_Z_VS.tmp
        echo "> -Z${i}" > mode_Z_VP.tmp
        echo "> -Z${i}" > mode_Z_RHO.tmp
        > mod.xy.tmp
        DEP=0.0
        while read line;do
                H=`      echo ${line}  | awk '{print $1} '`
                VP=`     echo ${line}  | awk '{print $2} '`
                VS=`     echo ${line}  | awk '{print $3} '`
                RHO=`    echo ${line}  | awk '{print $4} '`

                TOP=${DEP}
                DEP=`echo "scale=10;(${DEP} + $H)" | bc`
                BOT=${DEP}

                echo ${TOP} ${VS} >> mode_Z_VS.tmp
                echo ${BOT} ${VS} >> mode_Z_VS.tmp

                echo ${TOP} ${VP} >> mode_Z_VP.tmp
                echo ${BOT} ${VP} >> mode_Z_VP.tmp

                echo ${TOP} ${RHO}>> mode_Z_RHO.tmp
                echo ${BOT} ${RHO}>> mode_Z_RHO.tmp


                echo ">"        >> mod.xy.tmp
                echo -10 ${TOP} >> mod.xy.tmp
                echo 200 ${TOP} >> mod.xy.tmp
        done < tmp

        #####
        #    Plot model Z-VS image
        #####
        MAXDEP=`echo "scale=1;(${TOP} + 10)" |bc`
        psbasemap -JX5/-10 -R2/6/0/${MAXDEP} -Ba2f0.2:"Vs(km/s)":/a10f2:"Depth(km)":WSne -K -X2c > ${IMG}
        psxy  mode_Z_VS.tmp -: -JX -R -W2p -m -K -O >> ${IMG}

        psxy  mode_Z_VS.tmp  -: -JX5/-10 -R3/5/0/65       -W-1p -Ctmp.cpt -m -K -O >> ${IMGGlobal}
        psxy  mode_Z_VP.tmp  -: -JX5/-10 -R5.5/8.5/0/65   -W-1p -Ctmp.cpt -m -K -O >> ${IMGGlobalVP}
        psxy  mode_Z_RHO.tmp -: -JX5/-10 -R2.5/3.5/0/65   -W-1p -Ctmp.cpt -m -K -O >> ${IMGGlobalRHO}

        #####
        #    Generate ray path for "Pp IMG PpPs PpSs PsSs"
        #    and
        #    Plot ray path for "Pp IMG PpPs PpSs PsSs"
        #####
        psxy mod.xy.tmp -JX15/-15 -R-10/80/0/${MAXDEP} -Ba10f2:"X(km)":NSwe -m -K -O -X6c >> ${IMG}

        RayPath -Mtmp -R${Ps} -Oray.xy.tmp -P${RP}
        psxy ray.xy.tmp      -Ccpt.tmp -JX -R -m -K -O >> ${IMG}

        RayPath -Mtmp -R${Pp} -Oray.xy.tmp -P${RP}
        psxy ray.xy.tmp     -Ccpt.tmp -JX -R -m -K -O >> ${IMG}

        RayPath -Mtmp -R${PpPs} -Oray.xy.tmp -P${RP}
        psxy ray.xy.tmp     -Ccpt.tmp -JX -R -m -K -O >> ${IMG}

        RayPath -Mtmp -R${PsPs} -Oray.xy.tmp -P${RP}
        psxy ray.xy.tmp     -Ccpt.tmp -JX -R -m -K -O >> ${IMG}

        RP=`echo ${RP} |awk '{printf( "%6.4f", $0 )}'`
        pstext -JX -R -O >> ${IMG} << EOF
80 1 12 0 1 RT Ray Parameter ${RP} (s/km)
80 3 12 0 1 RT GCARC 60\217
EOF

#        ps2eps ${IMG} -R + -f
done < model.list.tmp


pstext  -JX5/-10 -R3/5/0/65      -O >> ${IMGGlobal}<<EOF
EOF
pstext  -JX5/-10 -R5.5/8.5/0/65  -O >> ${IMGGlobalVP}<<EOF
EOF
pstext  -JX5/-10 -R2.5/3.5/0/65  -O >> ${IMGGlobalRHO}<<EOF
EOF

ps2raster ${IMGGlobal}     -A -Tj -E300 -P
ps2raster ${IMGGlobalVP}   -A -Tj -E300 -P
ps2raster ${IMGGlobalRHO}  -A -Tj -E300 -P
rm *tmp tmp.cpt -rf
