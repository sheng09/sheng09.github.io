#!/usr/bin/env python3
from coef_staggeredGrid_sym import coef_staggered_sym_1 as coef
import math as m
import numpy as np
import matplotlib.pyplot as plt
import sys

class fd1_stagger:
	def __init__(self, order, dx = 0.1, nx = 200):
		self.order = order
		self.N     = int(self.order/2)
		self.dx    = dx
		self.dx_half = dx/2.0
		self.nx   = nx
		self.x    = [ ix * self.dx for ix in range(0,self.nx) ]
		self.x_s  = [ _x - self.dx_half for _x in self.x[1:] ]
		self.y    = [ m.sin( _x ) for _x in self.x ]
		self.y_s  = [ m.sin( _x ) for _x in self.x_s]
		self.z1   = [ m.cos( _x ) for _x in self.x ]
		self.z1_s = [ m.cos( _x ) for _x in self.x_s]
		self.v1   = [0.0,] * self.nx
		self.v1_s = [0.0,] * (self.nx-1)
		self.zero_s = [0.0,] * (self.nx-1)
		self.err1_s = [0.0,] * (self.nx-1)
		self.f_sym = coef(order, self.dx)
		self.coef_sym = self.f_sym.coef
	def fd_psym(self, pos):
		value = 0.0
		y = self.y
		for i in range(1, self.N+1):
			value = value + ( y[pos+i] - y[pos-i+1] ) * self.coef_sym[i-1]
		return value
	def fd_all(self):
		for pos in range(self.N-1 , self.nx-self.N):
			self.v1_s[pos] = self.fd_psym(pos)
			#print( fd_psym[pos] )
			self.err1_s[pos] = self.v1_s[pos] - self.z1_s[pos]
	def fdplot(self):
		plt.figure()
		ax1 = plt.subplot(211)
		ax2 = plt.subplot(212)
		plt.sca(ax1)
		plt.plot(self.x_s, self.z1_s)
		plt.plot(self.x_s, self.v1_s, marker='x', ls = 'dotted')
		plt.grid()
		plt.title('%d order FD of stagger grid (boundary points not processed) ' % self.order)
		plt.sca(ax2)
		err_max = max( max(self.err1_s), -min(self.err1_s) ) * 1.5
		plt.plot(self.x_s, self.err1_s )
		plt.ylim( -err_max, err_max )
		plt.title('error')
		plt.grid()
		plt.show()
		pass

class compare:
	def __init__(self, maxorder):
		self.maxorder = maxorder
		order = list( range(2,maxorder+2,2) )
		fd = [fd1_stagger(o) for o in order]
		for f in fd:
			f.fd_all()
		#map( fd1_stagger.fd_all ,fd )

		col = 2
		row = int( (int(self.maxorder/2) + 1) / col) + 1
		print(row)
		ax_index = [ i+3+ row*100+col*10 for i in range(0,len(order)) ]
		plt.figure()
		plt.subplots_adjust(wspace=0.3, hspace=0.4)
		axs = map( plt.subplot, ax_index )
		ax_total = plt.subplot( row*100+11 )

		width = 4.0
		for f,ax in zip(fd, axs):
			plt.sca(ax)
			maxerr = max( max(f.err1_s), -min(f.err1_s) ) * 1.5
			plt.plot(f.x_s, f.err1_s, linewidth = 2, color = 'red')
			plt.plot(f.x_s, f.zero_s)
			plt.xlim( f.x_s[0] - fd[0].dx*self.maxorder, f.x_s[-1] + fd[0].dx*self.maxorder )
			plt.ylim( -maxerr, maxerr )
			plt.title('%d order error' % f.order)
			plt.grid()
			plt.sca(ax_total)
			plt.plot(f.x_s, f.v1_s, linewidth = width)
			width = width - 0.5

		plt.sca(ax_total)
		plt.title('compare (boundary points not processed)')
		plt.xlim( fd[0].x_s[0] - fd[0].dx*self.maxorder, fd[0].x_s[-1] + fd[0].dx*self.maxorder )
		plt.grid()
		plt.show()

if __name__ == '__main__':
	order = eval(sys.argv[1])
	#fd = fd1_stagger(order)
	#fd.fd_all()
	#fd.fdplot()

	compare(order)

