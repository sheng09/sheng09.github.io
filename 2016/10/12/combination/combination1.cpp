#include <iostream>
#include <string>
static int count = 0;
static int n    ;
static int npick;
static int *mem = new int [npick+2] {-1 };
static int *sol = mem+1;
void print()
{
    for(int i = 0; i < npick; ++i)
        std::cout << sol[i] << ' ';
    std::cout << ";" << count+1 << '\n';
}
void combination(int i)
{
    for( int pos = sol[i-1]+1 ; pos < n; ++pos)
    {
        sol[i] = pos;
        if( i == npick - 1) {
            //print();
            ++count;
        }
        else
            combination(i+1);
    }
}
long factorial(int n) {
    if( n == 0)
        return 1;
    if( n < 0)
        exit(1);
    long v = n;
    for(int i = 2; i < n ; ++i) v*= i;
    return v;
}
long n_comb(int n, int m) {
    long v = n-m+1;
    for(int i = n; i > n-m+1; --i ) v*=i;
    for(int i = 1; i <= m; ++i) v/=i;
    return v;
}
int main(int argc, char const *argv[]) {
    n = std::stoi(argv[1]);
    npick = std::stoi(argv[2]);
    combination(0);
    std::cout << "Number of Solution:" << count << "; Correct Value:" << n_comb(n, npick) << ";" << factorial(n)/factorial(npick)/factorial(n-npick) << "\n";
    return 0;
}
