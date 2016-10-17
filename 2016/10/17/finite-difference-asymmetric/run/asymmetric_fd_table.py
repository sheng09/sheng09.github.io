#!/usr/bin/env python3
import sys
class asymm_fd:
	def __init__(self,N):
		self.N = N
	def markdown_table(self):
		table = '|point k' + ' |'*(self.N+1) + '\n'
		table = table + '|' + '-|'*(self.N+1) + '\n'
		for row in range(0, int(self.N/2) ):
			table = table + self.markdown_row(row)
		return table
	def markdown_row(self,k):
		line = '| %d |' % (k)
		for j in range(-k,0,1):
			line = line + '$ C^%d_{(%d)(%d)}  $|' %(k,self.N,j)
		for j in range(1,self.N-k+1):
			line = line + '$ C^%d_{(%d)(%d)}  $|' %(k,self.N,j)
		line = line + '\n'
		return line

if __name__ == '__main__':
	N = int(sys.argv[1])
	fd = asymm_fd(N)
	print( fd.markdown_table() )
