#include "m.hh"
#include "gsw_alloc.h"
#include <utility>
int main(int ac, char ** av)
{
    std::pair<int, int> p(1,2);
    char *cs;
    MAT::alloc1d(10, cs);
    MAT::free1d(cs);

    float *pf;
    MAT::alloc1d(5, pf);
    MAT::free1d(pf);

    char s[] = "123456789";
    mat2d<char> ms(2,5,s);
    ms.display();
    file f("tmp", "wb");
    f << ms;

    float fs[4] = {1., 2., 3., 4.};
    mat2d<float> mf(2, 2, fs);
    mf.display();
    file f3("tmp3", "wb");
    f3<< mf;

    int is[12] = {1,2,3,4,5,6,7,8,9,10,11,12};
    mat2d<int> mi(3,4, is);
    mi.display();
    file f4("tmp4", "wb");
    f4 << mi;

    mi.reshape(3,4).transpose().display();

    //mi.scale(2).add(1).display();

    //mi.add(-1);
    mat2d<int> m1(mi), m2(mi);
    mat2d<int> res( mi.dimension().first, mi.dimension().first  );
    multi(m1, m2.transpose(), res);
    res.display();


    mat2d<float> n1(2,3);
    n1.setUnit(2.0).display2();
    n1.setZero().display2();
    n1.setIdentity().display2();

    mat2d<float> n2(n1), n3(2,2);
    multi(n1, n2.transpose(), n3).display2();

    mi.display2();
    std::size_t ix, iy;
    mi.findIter(mi.getLeft(2,2), ix, iy);
    std::cout << ix << " " << iy << "\n";
    return 0;
}
