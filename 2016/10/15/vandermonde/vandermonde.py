#!/usr/bin/env python3
from fractions import Fraction as frac
import sys

def factorial( N ):
    value = N;
    for i in range(1,N):
        value = value * i
    return value

class vander:
    """Calculate the solution of vandermonde equation"""
    def __init__(self, N):
        self.N = N
        self.C = [0,] * (N+1)
        self.d1 = [0,] * (N+1)
        self.d2 = [0,] * (N+1)
        self.all_c()
        self.first_order()
        self.second_order()
    def __str__(self):
        str = '\n  FD %dth order accuracy\n' % (2* self.N)
        str = str + '[i]: %8s, %8s, %8s \n' %('Ci', 'ci', 'fi')
        for i in range( 1, self.N+1):
            str = str + '[%d]: %8s, %8s, %8s \n' % (i, self.C[i], self.d1[i], self.d2[i])
        return str
    def b(self, i):
        if i == 1:
            return 1;
        numer = factorial( i-1 ) * factorial(i)
        denom = factorial(2*i-1)
        if (i-1)&1 == 1:
            numer = -numer
        return frac(numer, denom)
    def a(self, i, j):
        numer = i * factorial(j+i-1)
        denom = j * factorial(2*i-1) * factorial(j-i)
        return frac(numer, denom)
    def c(self, i):
        value = self.b(i)
        if i == self.N:
            return value
        else:
            for j in range(i+1, self.N+1):
                value = value - self.a(i,j) * self.C[j]
            return value
    def all_c(self):
        for i in range( self.N, 0, -1):
            self.C[i] = self.c(i)
        self.ok = True
    def first_order(self):
        for i in range(1,self.N+1):
            self.d1[i] = self.C[i] / 2 / i;
    def second_order(self):
        for i in range(1,self.N+1):
            self.d2[i] = self.C[i] / i / i;
    def markdown_row(self, ncol, which):
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
    def __init__(self, N):
        self.N   = N
        self.dat = [0,] * (self.N+1)
        for i in range(1, self.N+1):
            self.dat[i] = vander(i)
    def markdown_table(self, which):
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


if __name__ == '__main__':
    if len(sys.argv) == 1:
        pass
    elif len(sys.argv) ==2:
        N = eval(sys.argv[1])
        v = vander(N);
        print(v)
    elif len(sys.argv) == 3:
        which = (sys.argv[2])
        N = eval(sys.argv[1])
        table = vander_table(N)
        print( table.markdown_table(which) )
