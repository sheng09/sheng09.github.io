#!/usr/bin/env python3
import sys
from fractions import Fraction as frac
class vander_stagger_sym:
	"""Calculate the FD coefficients of symmetric scheme for staggered grid
		by solving Ax = b
	"""
	def __init__(self, order):
		self.order = order
		self.N = int(self.order/2)
		self.b = [0,] * (self.N+1)
		self.x = [0,] * (self.N+1)
	def matrix_a(self, i, j):
		"""Calculate the a(i,j) of matrix A
		"""
		#For numerator
		numer = 1
		j1 = (2*j-1)**2
		for i1 in range(2*i-3, -1, -2):
			numer = numer * (j1 - i1**2)
		#For denominator
		denom = 1
		i2 = (2*i-1)**2
		for i3 in range(2*i-3, -1, -2):
			denom = denom * (i2- i3**2)
		#print( frac(numer, denom) )
		return frac(numer, denom)
	def matrix_b(self,i):
		"""Calculate the b(i) of matrix b
		"""
		#For numerator
		numer = (-1)**(i-1)
		for i1 in range(2*i-3, 1, -2):
			numer = numer * i1**2
		#For denominator
		denom = 1
		i2 = (2*i-1)**2
		for i3 in range(2*i-3, -1, -2):
			denom = denom * (i2- i3**2)
		b = frac(numer, denom)
		return b
	def matrix_x(self,i):
		"""Calculate the x(i) of Ax = b
		"""
		if i == self.N:
			self.b[i] = self.matrix_b(i)
			self.x[i] = self.b[i]
		else:
			self.x[i] = self.matrix_b(i)
			for j in range(i+1, self.N+1):
				self.x[i] = self.x[i] - self.matrix_a(i,j) * self.x[j]
		#print( 'b[%d] = %s' %(i, self.b[i]) )
		#print( 'x[%d]=%s'   %(i, self.x[i]) )
		return self.x[i]
	def all_x(self):
		"""Calculate all the x(i) for (i = N, N-1, N-2,...,1)
		"""
		for i in range(self.N, 0, -1):
			self.matrix_x(i)
			self.C = self.x
			#print(self.C)
		self.all_c()
	def all_c(self):
		self.c = [0] + [c/(2*ic+1) for ic,c in enumerate(self.C[1:])]
		#print(self.C)
		#print(self.c)
	def __str__(self):
		C_str = ''
		for i in range(1,self.N+1):
			C_str = C_str + 'C%-11s ' %(2*i-1)
		C_str = C_str + '\n'
		for i in range(1,self.N+1):
			C_str = C_str + '%-12s ' %(self.x[i])
		C_str = C_str + '\n'
		return C_str
	def markdown_row(self, N):
		row_str = '| %d |' % self.order
		for i in range(1,self.N+1):
			#print(self.C[i])
			row_str = row_str + ' $\\frac{%d}{%d}$ |' %(self.c[i].numerator,self.c[i].denominator )
		for i in range(0,N-i):
			row_str = row_str + '|'
		row_str = row_str + '\n'
		return row_str

class coef_staggered_sym_1(vander_stagger_sym):
	"""Generate the FD coefficients for staggered grid of symmetric scheme
	"""
	def __init__(self, order, dx):
		vander_stagger_sym.__init__(self, order)
		self.dx = dx
		self.all_x()
		self.coef = [ float(c/dx) for c in self.c ][1:]
		#self.coef = [float(c)/dx/(2*ic+1) for ic,c in enumerate(self.C[1:])]
	def __str__(self):
		C_str = ''
		for c in self.coef:
			C_str = C_str + ' %12f' % c
		C_str = C_str + '\n'
		return C_str

class vander_stagger_sym_table:
	"""Generate markdown table given max FD order
	"""
	def __init__(self, maxorder):
		self.maxorder = maxorder
		self.maxN = int(maxorder/2)
		self.dat = []
		#str = ''
		for order in range(2, maxorder+2, 2):
			v = vander_stagger_sym( order )
			v.all_x()
			self.dat = self.dat + [v]
			#str = str + v.markdown_row()
	def markdown_table(self):
		table = '| order |'
		for col in range(1,self.maxN+1):
			table = table + ' $c_%d$ |' %col
		table = table + '\n|'
		for cor in range(1,self.maxN+1):
			table = table + '-|'
		table = table + '\n'
		for row in self.dat:
			table = table + row.markdown_row(self.maxN)
		return table


if __name__ == '__main__':
	order = int( sys.argv[1] )
	fd = vander_stagger_sym(order)
	fd.all_x()
	print( fd )
	coef = coef_staggered_sym_1(order, 1.0)
	print(coef)
	table = vander_stagger_sym_table(order)
	print( table.markdown_table() )


