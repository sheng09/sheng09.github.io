

#include <iostream>
void add(int **mat, int ncol, int nrow) {
	int (*m)[ncol] = (int (*)[ncol] ) mat;
	for(int nr = 0; nr<nrow; ++nr)
	{
		for(int nc = 0; nc<ncol; ++nc)
		{
			std::cout << m[nr][nc] << " ";
		}
		std::cout << "\n";
	}	
	return;
}

int main(int ac, char **av) {
	int m[2][2] = { {1,2},{3,4} };
	int **c = (int **)m;
	add( c, 2, 2);
	return 0;
}
