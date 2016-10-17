#!/usr/bin/env python3
#
from vandermonde import fd_sym_1
from vandermonde_asym import fd_asym_1
import math as m
import sys
import numpy as np
import matplotlib.pyplot as plt

class fd_1d:
	def __init__(self, order, nx = 100, dx = 0.1):
		self.order = order
		self.N = int(order/2)
		self.nx = nx
		self.dx = dx
		self.x  = [self.dx * i for i in range(0,self.nx)]
		self.y  = [m.sin(v) for v in self.x ]
		self.z1 = [m.cos(v) for v in self.x]
		self.v1 = [0.0,] * self.nx
		self.zero = [0.0,] * self.nx
		#self.err1 = [0.0,] * self.nx
		self.f_sym = fd_sym_1(order, self.dx)
		self.coef_sym = self.f_sym.coef
		self.f_asym = fd_asym_1(order, self.dx, self.nx)
		self.coef_asym = self.f_asym.coef
	def fd_psym(self, pos):
		"""Calculte the FD value of point[pos], in which symmetric FD scheme is used
		"""
		value = 0.0
		y = self.y
		for k in range(1,self.N+1):
			value = value + (y[pos+k] - y[pos-k]) * self.coef_sym[k-1]
		return value
	def fd_pasym_head(self,pos):
		"""Calculte the FD value of point[pos] in left boundary, in which asymmetric FD scheme is used
		"""
		value = 0.0
		y = self.y
		#print('point:%d' % pos)
		for j in range(-pos, 0):
			#print( "	y[%d] - y[%d] * c[%d][%d] " % (pos+j, pos, pos, j) )
			value = value + ( y[pos+j] - y[pos] ) * self.coef_asym[pos][j]
		for j in range(1,self.order - pos+1):
			#print( "	y[%d] - y[%d] * c[%d][%d] " % (pos+j, pos, pos, j) )
			value = value + ( y[pos+j] - y[pos] ) * self.coef_asym[pos][j]
		return value
	def fd_pasym_tail(self,pos):
		"""Calculte the FD value of point[pos] in right boundary, in which asymmetric FD scheme is used
		"""
		value = 0.0
		y = self.y
		k = self.nx-1-pos
		#print( 'point:%d, eqauls to point %d' % (pos, k))
		for j in range(-k,0):
			#print( '	y[%d] - y[%d] * c[%d][%d] ' %( pos , pos-j, pos, j) )
			value = value + ( y[pos] - y[pos-j] ) * self.coef_asym[pos][j]
		for j in range(1,self.order-k+1):
			#print( '	y[%d] - y[%d] * c[%d][%d] ' %( pos , pos-j, pos, j) )
			value = value + ( y[pos] - y[pos-j] ) * self.coef_asym[pos][j]
		return value
	def fd_all(self):
		n_boundary = self.N
		for pos in range(0,n_boundary):
			self.v1[pos] = self.fd_pasym_head(pos)
		for pos in range(n_boundary, self.nx - n_boundary):
			self.v1[pos] = self.fd_psym(pos)
		for pos in range(self.nx- n_boundary, self.nx):
			self.v1[pos] = self.fd_pasym_tail(pos)

		self.err1 = list( map( lambda x:x[0]-x[1], zip(self.v1, self.z1) ) )
	def fd_plot(self):
		plt.figure() # 创建图表1
		ax1 = plt.subplot(211) # 在图表2中创建子图1
		ax2 = plt.subplot(212) # 在图表2中创建子图2
		plt.sca(ax1)   #❷ # 选择图表2的子图1
		plt.plot(self.x, self.z1)
		plt.plot(self.x, self.v1, ls = 'dotted', marker = 'x')
		plt.xlim( min(self.x) -self.dx*5, max(self.x)+self.dx*5 )
		plt.grid()
		plt.title('%d order accuracy for f\'(x)' % self.order)


		plt.sca(ax2)  # 选择图表2的子图2
		plt.plot(self.x, self.err1)
		plt.xlim( min(self.x) -self.dx*5, max(self.x)+self.dx*5 )
		plt.grid()
		plt.title('error')
		plt.show()
		#pass

if __name__ == '__main__':
	str_orders = sys.argv[1:]
	order = [eval(ch) for ch in str_orders]
	
	col = 2
	row = int( (1 + len(order)) /col ) + 1
	index = [i+ 3 +col*10+row*100 for i in range(0, len(order) )]
	print(index)

	plt.figure()
	axs = [ plt.subplot(i) for i in index ]
	total = row*100+11
	ax_total = plt.subplot(total)
	plt.subplots_adjust(wspace=0.3, hspace=0.4)
	for o,a in zip(order,axs):
		fd = fd_1d(o,nx=200,dx=0.1)
		fd.fd_all()
		plt.sca(a)
		plt.plot(fd.x, fd.err1)
		plt.plot(fd.x, fd.zero)
		plt.xlim( min(fd.x) -fd.dx*5, max(fd.x)+fd.dx*5 )
		err_max = max( max(fd.err1) , -min(fd.err1) ) * 1.5
		plt.ylim( -err_max, err_max )

		plt.grid()
		plt.title('%d order accuracy error' % o )
		plt.sca(ax_total)
		plt.plot(fd.x, fd.v1) #, ls = 'dotted', marker = 'x')
	plt.sca(ax_total)
	plt.grid()
	plt.title('FD [ f\'(x) ]')
	plt.show()