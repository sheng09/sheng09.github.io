#!/bin/sh

#####
#    Compile the C program
#####
gcc RayPath.c -o RayPath -lm -O4

#####
#    compile the Fortran program
#####
gfortran mkgrad.f -o mkgrad

#####
#     definitions for the RFTN
#####
DT=0.025
NPTS=2048
ALP=2.5
#####
#    Clear
#####
rm -f DISP.PLT
rm RF.* -rf
rm RF.*.sac -rf
#####
#    Generate model
#####

#MODEL.01
#Simple Gradient
#ISOTROPIC
#KGS
#FLAT EARTH
#1-D
#CONSTANT VELOCITY
#LINE08
#LINE09
#LINE10
#LINE11
#      H(KM)   VP(KM/S)   VS(KM/S) RHO(GM/CC)     QP         QS       ETAP       ETAS      FREFP      FREFS
#    40.0000     6.0000     3.4265     2.6871   0.00       0.00       0.00       0.00       1.00       1.00
#    40.0000     8.0000     4.4509     3.2463   0.00       0.00       0.00       0.00       1.00       1.00

#####
#     Generate receiver functions given different incidence angle
#####
mkdir Grad_Intf_RFS 2>&-  || rm Grad_Intf_RFS/*  -rf 2>&-
mkdir models     2>&- || rm models/*     -rf 2>&-
RAYP=0.0618 #Cooresponsed to GCARC = 60.0
for i in 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20
do
  echo "Processing... Number of interfaces = $i"
        mkgrad -N ${i}
        mv model.out models/Grad_Intf_hrftn96_${i}.model
	hrftn96 -M models/Grad_Intf_hrftn96_${i}.model -D 10.0 -RAYP ${RAYP} -NPOTS ${NPTS} -DT ${DT} -2 -ALP ${ALP} 1>/dev/null
	mv hrftn96.sac Grad_Intf_RFS/RF.${RAYP}.${i}.sac

	sac > /dev/null << EOF
r Grad_Intf_RFS/RF.${RAYP}.${i}.sac
#ch t1  $tPS t2  $tPPPS t3  $tPPSS t4  $tPSSS
#ch kt1 Ps   kt2 PpPs   kt3 PpSs   kt4 PsSs
ch kstnm ${i}
ch user1 RAYP
ch user2 ${i}
wh
q
EOF
done

#####
#    Plot record section using gsac
#####

rm PRS001.PLT  PRS001.CLT -rf
	gsac > /dev/null << EOF
r Grad_Intf_RFS/RF.*.sac
sort up user2
#color on list black
color rainbow
bg plt
prs REVerse user2 relative tl -10 40 amp 2.5 vl -20 21 title "Model Num"

color rainbow
fileid name
p overlay on
q
EOF

plotnps -F7 -W10 -A4 -EPS -K < PRS001.PLT > rf_prf.eps
plotnps -F7 -W10 -A4 -EPS -K < P001.PLT >   rf_rainbow.eps

rm PRS001.PLT  PRS001.CTL P001.PLT -rf

ps2raster -Tj -E300 -A rf_prf.eps
ps2raster -Tj -E300 -A rf_rainbow.eps

#####
#    Plot using sac
#####
sac > /dev/null << EOF
qdp off
r Grad_Intf_RFS/RF.*.sac
sort user2
color on inc
xlim o -5 35
p2
saveimg rf_sac.ps
q
EOF

ps2raster -Tj -E300 -A rf_sac.ps

rm *tmp -rf
