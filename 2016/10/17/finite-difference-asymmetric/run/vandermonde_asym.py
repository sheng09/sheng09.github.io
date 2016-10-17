#!/usr/bin/env python3
import sys
import numpy as np
from scipy.linalg import solve
from fractions import Fraction as frac

class vander_asym:
	"""Calculate the solution of vandermonde equation for each boundary point for asymmetric finite difference
        Ax = b

        *---*---*---*-...-*---*---*---*
        0   1   2   3
	"""
	def __init__(self,order):
		self.order = order
		self.N = order
		self.nboundary = int(self.N/2)
		self.C = [0,] * int(self.nboundary)
	def matrix_b(self,k):
		""" Calculate the b matrix for boundary point k
		"""
		b = [1,]
		b = b + [0,]*(self.N-1)
		return np.array(b)
	def row_a(self,i,k):
		"""Calculate row[i] for A matrix for boundary point k
		"""
		row1 = [ j**i for j in range(-k,0) ]
		row2 = [ j**i for j in range(1,self.N-k+1)]
		return np.array( row1 + row2 )
	def matrix_A(self,k):
		"""Calculate the A matrix for boundary point k
		"""
		A = [self.row_a(i,k) for i in range(0,self.N)]
		return np.array(A)
	def value_k(self,k):
		"""Calculate the FD coefficients for boundary point k
		"""
		A = self.matrix_A(k)
		b = self.matrix_b(k)
		x = solve(A,b)
		return x
	def value_all(self):
		"""Calculate the FD coefficients for each boundary point
			For N order accuracy, the number of boundary points is N/2
		"""
		for i in range(0, int(self.N/2) ):
			self.C[i] = self.value_k(i)
		return self.C
	def __str__(self):
		mat = '%4s\n' % 'k'
		for irow,row in enumerate(self.C):
			line ='%4d' % irow
			for item in row:
				line = line + '%12f' %(item)
			mat = mat + line + '\n'
		return mat

class fd_asym_1(vander_asym):
	"""Generate the coefficients for 1st order symmetric FD
    """
	def __init__(self,order,dx,nx):
		vander_asym.__init__(self,order)
		self.value_all()
		"""coefficients
        """
		self.coef = {}
		for k in range(0, self.nboundary ):
			row1 = {}
			#row2 = {}
			for j in range(-k, 0):
				row1[j] = self.C[k][j+k] / dx / j
			for j in range(1, self.order-k+1):
				#print(len(self.C))
				row1[j] = self.C[k][j+k-1] /dx /j
			self.coef[k] = row1
			self.coef[nx-1-k] = row1
        #for item in self.coef:
        #	for 
		#for irow,row in enumerate(self.C):
		#	for j in range(-irow,0):
		#		self.C[irow][j+irow] = self.C[irow][j+irow] /dx/j
		#	for j in range(1,self.order-irow+1):
		#		self.C[irow][j+irow-1] = self.C[irow][j+irow-1]/dx/j
		#self.coef = self.C


class vander_asym_table(vander_asym):
	"""Generate the markdown table of FD coefficients for boundary points given order self.N
	"""
	def __init__(self,N):
		vander_asym.__init__(self,N)
		self.value_all()
	def markdown_table(self):
		"""Generate the table
		"""
		table = '|point k' + ' |'*(self.N+1) + '\n'
		table = table + '|' + '-|'*(self.N+1) + '\n'
		for row in range(0, int(self.N/2) ):
			table = table + self.markdown_row(row)
		return table
	def markdown_row(self,k):
		"""Generate the row(k) of table
		"""
		line = '| %d |' % (k)
		for j in range(-k,0,1):
			line = line + '$ C^%d_{(%d)(%d)} = %s  $|' %(k,self.N,j, ( self.C[k][j+k] ) )
		for j in range(1,self.N-k+1):
			line = line + '$ C^%d_{(%d)(%d)} = %s $|' %(k,self.N,j,  (self.C[k][j+k-1]) )
		line = line + '\n'
		return line


if __name__ == '__main__':
	N = eval(sys.argv[1])
	fd = vander_asym(N)
	fd.value_all()
	print(fd)

	table = vander_asym_table(N)
	print(table.markdown_table())
