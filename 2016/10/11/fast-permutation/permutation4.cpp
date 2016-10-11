#include <iostream>
#include <ctime>
#include <string>
static int n;
static int end;
static int count = 0;
static int  *sol  = new int  [n] {};
static int avai = 0;
void print() {
    for(int i =0; i < n; ++i) std::cout << sol[i];
    std::cout << ";" << count << "\n";
}
void permutation( int pos ) {
    int empty =  ((1<<n)-1) & ~avai;
    while( empty != 0 ) {
        int p = empty & (-empty);
        empty ^= p;
        if (pos == end) {
            count++;
        }
        else {
            avai ^= p;
            permutation(pos+1);
            avai ^= p;
        }
    }
}

int main(int argc, char const *argv[]) {
    n = std::stoi(argv[1]);
    if( argc == 3)
        end = std::stoi(argv[2]) - 1;
    else
        end = n - 1;
    std::clock_t tic = std::clock();
    permutation(0);
    std::clock_t toc = std::clock();
    std::cout << "Solution: " << count << " " << float(toc - tic) / CLOCKS_PER_SEC << "s\n";
    return 0;
}
