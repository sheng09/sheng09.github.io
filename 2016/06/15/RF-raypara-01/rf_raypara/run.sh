#!/bin/sh

#####
#     Setting for the RF
#####
DT=0.05
NPTS=1024

#####
#    Clear
#####
rm -f DISP.PLT
rm RF.* -rf
rm RF.*.sac -rf
#####
#    Prepare your model
#####

#####
#     Generate receiver functions given different incidence angle
#####
mkdir RayPara_RFS 2>&- || rm RayPara_RFS/* -rf 2>&-

# Note: "theta" is the angle of incidence for ray-path, but not the great circle distance!
for theta in 0.01 0.1 0.5 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30\
        31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60
#0.01 1.0 2.0 3.0 4.0 5.0 7.5 10.0 12 15.0 17 20.0 23 \
# 25.0 28 30.0 32 35.0 37  40.0 43 45.0 48 50.0 52  55.0 57 60.0

do
	RAYP=` CalRayPara.py   $theta 6.3`
	tPS=`  CalTrvTPS.py    $theta 6.0 3.4265 40`
	tPPPS=`CalTrvTPPPS.py  $theta 6.0 3.4265 40`
	tPPSS=`CalTrvTPPSS.py  $theta 6.0 3.4265 40`
	tPSSS=`CalTrvTPSSS.py  $theta 6.0 3.4265 40`
  echo "Processing... RP=${RAYP}"
	ALP=1.0
	hrftn96 -M model.dat -D 10.0 -RAYP ${RAYP} -NPOTS ${NPTS} -DT ${DT} -2 -ALP ${ALP} 1>/dev/null
	mv hrftn96.sac RayPara_RFS/RF.${RAYP}.${theta}.sac

	sac > /dev/null << EOF
r RayPara_RFS/RF.${RAYP}.${theta}.sac
ch t1  $tPS t2  $tPPPS t3  $tPPSS t4  $tPSSS
ch kt1 Ps   kt2 PpPs   kt3 PpSs   kt4 PsSs
ch kstnm $theta
ch kevnm $RAYP
ch user1 $RAYP
ch user2 $theta
wh
q
EOF
done

#####
#    Plot record section using gsac
#####

rm PRS001.PLT  PRS001.CLT -rf
RAYPMIN=`CalRayPara.py  0.0000001  6.3`
RAYPMAX=`CalRayPara.py  89.999999  6.3`
	gsac > /dev/null << EOF
r RayPara_RFS/RF.*.sac
bg plt
sort up user1
prs user1 relative tl -10 40 amp 0.3 vl -0.01 0.14 title "Ray Parameter(s/km)" shd pos color 2
#sort up user2
#prs user2 relative tl -10 40 amp 0.3 vl -5 90 title "Ray Parameter(s/km)" shd pos color 2
q
EOF

plotnps -F7 -W10 -EPS -K < PRS001.PLT > rp_prf.eps
rm PRS001.PLT  PRS001.CTL -rf
ps2raster rp_prf.eps -A -Tj -E600
######
##    Plot using sac
######
#
#sac > /dev/null << EOF
#qdp off
#r RayPara_RFS/RF.*
#sort user1
#color on inc
#xlim o -5 35
#p1
#saveimg RayPara.ps
#q
#EOF

#> Deg-RP.list
#i=1
#const=`echo "scale=10;(6372.5*3.1415926535/180.0)" | bc `
##echo $const
##echo $const | awk '{ for(i=30;i<90;++i) {print "taup_time -ph P -deg "i" -rayp"}}' | sh > Deg-RP.list
#
#while [ $i -le 119 ]
#do
#	Deg=`echo "scale=10;($i * 0.5 + 30)" | bc`
#	RP=`taup_time -ph P -deg $Deg -rayp`
#	RP=`echo "scale=10;($RP / $const)" |bc `
#	echo $Deg $RP >> Deg-RP.list
#	echo $i $Deg $RP
#	#i=$i+1
#	i=$(($i+1))
#done

#psxy Deg-RP.list -JX15c/15c -R20/100/0.04/0.08 -Ba10f2:"Distance(Deg)":/a0.01f0.002:"Ray Parameter(s/km)": -Sc5p -Gred > Deg-RP.ps
