#!/usr/bin/env python3
#

import numpy as np
from scipy.linalg import solve


class vander_stagger_asym:
	"""Calculate the FD coefficients of asymmetric scheme for staggered grid
		by solving Ax = b
	"""
	def __init__(self, order):
		self.order = order
		self.N = int(self.order/2)
		self.b = np.array( [1.0] + ( [0.0,] * self.order ))
		self.C = [0.0,]* self.N
	def row_a(self, i, k):
		"""Calculate the row[i] for matrix A for boundary point k
			i=0,1,2,...,(2N+1)
		"""
		if i == 0:
			row = [1,] * (self.N*2 + 1)
		elif i == 1:
			row = [-1.0/item for item in range(1-2*k, 4*self.N-2*k+3, 2)]
		else:
			row = [item**(i-1) for item in range(1-2*k, 4*self.N-2*k+3, 2)]
		return np.array( row )
	def matrox_A(self, k):
		"""Calculate the A matrix for bound point k
		"""
		A = [self.row_a(i, k) for i in range(0, self.order+1 )]
		return np.array(A)
	def value_k(self,k):
		"""Calculate the FD coefficients for boundary point k
		"""
		A = self.matrox_A(k)
		#print(A)
		x = solve(A, self.b)
		return x
	def value_all(self):
		"""Calculate all the FD coefficients for boundary points
			For 2N order accuracy, the number of boundary points is N
		"""
		for pos in range(0, self.N):
			self.C[pos] = self.value_k(pos)
		return self.C
	def value_all_c(self, dx):
		self.c = self.C
		for k in range(0, self.N):
			for l in range(1-2*k, 4*self.N-2*k+3,2):
				index = int( ( l+(2*k-1) ) /2 )
				self.c[k][index] = self.c[k][index] / l * 2 / dx
		return self.c
	def __str__(self):
		mat = '%4s\n' % 'point(k)'
		for irow, row in enumerate(self.C):
			line = '%d ' % irow
			for item in row:
				line = line + '%12f ' %(item)
			mat = mat + line + '\n'
		return mat

class coef_staggered_asym_1(vander_stagger_asym):
	def __init__(self, order, dx):
		vander_stagger_asym.__init__(self, order)
		self.value_all()
		self.value_all_c(dx)
		self.coef = self.c


if __name__ == '__main__':
	van = vander_stagger_asym(4)
	van.value_all()
	print(van)
	pass
