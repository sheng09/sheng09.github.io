#!/usr/bin/env python3
from fractions import Fraction as frac
import sys

def factorial( N ):
    """ Calculate N!
    """
    value = N;
    for i in range(1,N):
        value = value * i
    return value


class vander:
    """Calculate the solution of vandermonde equation for symmetric finite difference
        Ax = b
    """
    def __init__(self, N):
        self.N = N
        self.C = [0,] * (N+1)
        self.d1 = [0,] * (N+1)
        self.d2 = [0,] * (N+1)
        #self.all_c()
        #self.first_order()
        #self.second_order()
    def __str__(self):
        str = '\n  FD %dth order accuracy\n' % (2* self.N)
        str = str + '[i]: %8s, %8s, %8s \n' %('Ci', 'ci', 'fi')
        for i in range( 1, self.N+1):
            str = str + '[%d]: %8s, %8s, %8s \n' % (i, self.C[i], self.d1[i], self.d2[i])
        return str
    def b(self, i):
        """Calculate the b matrix"""
        if i == 1:
            return 1;
        numer = factorial( i-1 ) * factorial(i)
        denom = factorial(2*i-1)
        if (i-1)&1 == 1:
            numer = -numer
        return frac(numer, denom)
    def a(self, i, j):
        """Calculate the A matrix
        """
        numer = i * factorial(j+i-1)
        denom = j * factorial(2*i-1) * factorial(j-i)
        return frac(numer, denom)
    def c(self, i):
        """Calculate the C[i] value from C[i+1],C[i+2],...,C[N]
        """
        value = self.b(i)
        if i == self.N:
            return value
        else:
            for j in range(i+1, self.N+1):
                value = value - self.a(i,j) * self.C[j]
            return value
    def all_c(self):
        """Solve Ax = b to obtain C[i]
        """
        for i in range( self.N, 0, -1):
            self.C[i] = self.c(i)
        self.ok = True
    def first_order(self):
        """Calculate c[i], which is used for 1st order FD, from C[i]
        """
        for i in range(1,self.N+1):
            self.d1[i] = self.C[i] / 2 / i;
    def second_order(self):
        """Calculate f[i], which is used for 1st order FD, from C[i]
        """
        for i in range(1,self.N+1):
            self.d2[i] = self.C[i] / i / i;
    def markdown_row(self, ncol, which):
        """Generate the markdown table row for this order FD
        """
        if which == 'C':
            dat = self.C
        elif which == 'c':
            dat = self.d1
        elif which == 'f':
            dat = self.d2
        line = '|%d|' % (self.N*2)
        for i in range(1,self.N+1):
            line = line + ' $%s$ |' % (dat[i])
        for i in range(1,ncol - self.N+1):
            line = line + ' |'
        line = line + '\n'
        return line

class vander_table(object):
    """Generate markdown table given max FD order
    """
    def __init__(self, N):
        self.N   = N
        self.dat = [0,] * (self.N+1)
        for i in range(1, self.N+1):
            self.dat[i] = vander(i)
            self.dat[i].all_c()
            self.dat[i].first_order()
            self.dat[i].second_order()
    def markdown_table(self, which):
        """ for FD order of 1,2,3,...,self.N, generate the table.
        """
        if which == 'C':
            coef = 'C'
        elif which == 'c':
            coef = 'c'
        elif which == 'f':
            coef = 'f'
        str = '|order|'
        for i in range(1,N+1):
            str = str + '$%s_{%d}$ |' % (coef,i)
        str = str + '\n|'
        for i in range(1,N+1):
            str = str + '-|'
        str = str + '\n'
        for i in range(1,self.N+1):
            str = str + (self.dat[i]).markdown_row(self.N, which)
        return str

class fd_sym_1(vander):
    """Generate the coefficients for 1st order symmetric FD
    """
    def __init__(self, order,dx):
        N = int(order/2)
        vander.__init__(self,N)
        self.all_c()
        self.first_order()
        """coefficients
        """
        self.coef = [float(c)/dx for c in self.d1][1:]

class fd_sym_2(vander):
    """Generate the coefficients for 2st order symmetric FD
    """
    def __init__(self, order,dx):
        N = int(order/2)
        vander.__init__(self,N)
        self.all_c()
        self.second_order()
        """coefficients
        """
        dx2 = dx * dx
        self.coef = [float(c)/dx2 for c in self.d2][1:]


if __name__ == '__main__':
    if len(sys.argv) == 1:
        pass
    elif len(sys.argv) ==2:
        N = eval(sys.argv[1])
        v = vander(N);
        v.all_c()
        v.first_order()
        v.second_order()
        print(v)
    elif len(sys.argv) == 3:
        which = (sys.argv[2])
        N = eval(sys.argv[1])
        table = vander_table(N)
        print( table.markdown_table(which) )
