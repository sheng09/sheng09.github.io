#!/usr/bin/python
from math import *
import sys
theta = sys.argv[1]
vp    = sys.argv[2]
rp    = sin((1.0/180.0*pi*float(theta)))/float(vp)
print rp