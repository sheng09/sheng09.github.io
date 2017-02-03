#!/usr/bin/env python3
from coef_staggeredGrid_asym import coef_staggered_asym_1
from coef_staggeredGrid_sym  import coef_staggered_sym_1
import math as m
import numpy as np
import matplotlib.pyplot as plt
import sys


class fd1_stagger_asym:
	def __init__(self, order, dx = 0.1, nx = 200):
		self.order = order
		self.N = int( self.order/2 )
		self.dx = dx
		self.nx = nx
		self.dx_half = self.dx / 2.0
		self.x      = [ix*self.dx for ix in range(0,self.nx)]
		self.x_s    = [-self.dx_half] + [ v + self.dx_half for v in self.x ]
		self.y      = [m.sin(v) for v in self.x]
		self.y_s    = [m.sin(v) for v in self.x_s]
		self.z1     = [m.cos(v) for v in self.x]
		self.z1_s   = [m.cos(v) for v in self.x_s]
		self.v1_s   = [0.0,] * (self.nx+1)
		self.zero   = [0.0,] * self.nx
		self.zero_s = [0.0,] * (self.nx+1)
		self.err1_s = [0.0,] * (self.nx+1)
		self.coef_asym = coef_staggered_asym_1(order, self.dx)
		self.coef   = self.coef_asym.coef
		self.coef_sym =  coef_staggered_sym_1(order, self.dx)
		self.coef2 = self.coef_sym.coef
	def fd_psym(self,k):
		y = self.y
		value = 0.0
		for l in range(1,self.N+1):
			#print(l-1, len(self.coef), k+l, k-l, len(y))
			value = value + (y[k+l-1] - y[k-l]) * self.coef2[l-1]
		return value
	def fd_pasym_head(self, k):
		#k = self.nx+1 -k
		value = 0.0
		y = self.y
		for l in range( 0, self.order+1):
			#print( k, l )
			value = value + y[l] * self.coef[k][l]
		return value
	def fd_boundary_head(self):
		for k in range(0,self.N):
			self.v1_s[k] = self.fd_pasym_head(k)
			self.err1_s[k] = self.v1_s[k] - self.z1_s[k]
			######################################
	def fd_pasym_tail(self, k):
		value = 0.0
		y = self.y
		for l in range( 0, self.order+1):
			#print( 'value[%d] += y[%d] * c[%d][%d]' %( k, self.nx-l-1, self.nx-k, l) )
			value = value - y[self.nx-l-1] * self.coef[self.nx-k][l]
		return value
	def fd_boundary_tail(self):
		for k in range(self.nx -self.N+1 ,self.nx+1):
			self.v1_s[k] = self.fd_pasym_tail(k)
			self.err1_s[k] = self.v1_s[k] - self.z1_s[k]
			######################################
	def fd_all(self):
		self.fd_boundary_head()
		self.fd_boundary_tail()
		self.fd_mid()
	
	def fd_mid(self):
		for k in range(self.N, self.nx - self.N+1):
			#print(k)
			self.v1_s[k] = self.fd_psym(k)
			self.err1_s[k] = self.v1_s[k] - self.v1_s[k]


	def fd_plot(self):
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

class compare:
	def __init__(self, order):
		self.maxorder = max(order)
		self.order = order
		fd = [fd1_stagger_asym(o) for o in order]
		for f in fd:
			f.fd_all()
		#map( fd1_stagger.fd_all ,fd )

		col = 2
		row = int( (int(len(order)) + 1) / col) + 1
		#print(row)
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
		plt.title('compare (boundary points processed well)')
		plt.xlim( fd[0].x_s[0] - fd[0].dx*self.maxorder, fd[0].x_s[-1] + fd[0].dx*self.maxorder )
		plt.grid()
		plt.show()




if __name__ == '__main__':
	order = [eval(o) for o in sys.argv[1:] ]
	compare(order)
	pass