#include <stdio.h>
#define ISODD(x) ((x)&1)
typedef struct
{
    int denom;
    int numer;
}fraction;
int prod(int b, int e) {
    int val = e;
    for( int i = b; i < e; ++i )
        val *= i;
    return val;
}
fraction vander_b(int N) {
    fraction val;
    val.numer = prod(1,N-1);
    val.denom = prod(N+1,2*N-1);
    if( ISODD(N-1) )
        val.numer = -val.numer;
    return val;
}
void print(fraction v) {
    printf("%d / %d \n", v.numer, v.denom );
}
fraction vander(int k, int N) {
    fraction b_k = vander_b(N);
    fraction b_
}
int main(int argc, char const *argv[]) {

    return 0;
}
