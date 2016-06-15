#!/usr/bin/python
from math import *
import sys
theta = sys.argv[1]
vp    = sys.argv[2]
vs    = sys.argv[3]
H     = sys.argv[4]

ang   = 1.0/180.0*pi*float(theta)
rp    = sin(ang)/float(vp)

yts   = sqrt( 1.0/(float(vs))/(float(vs)) - float(rp)*float(rp) )
ytp   = sqrt( 1.0/(float(vp))/(float(vp)) - float(rp)*float(rp) )
tPPPS = float(H) * (yts + ytp )

print tPPPS