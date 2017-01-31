#include "m.hh"
#include <cmath>
#include <iostream>
#include <vector>

int main(int ac, char **av) {
    PT2 po(0.0 ,0.0);
    PT2 ps(10.0, 0.0);
    RAY sr(po, ps, 400);
    sr.rt(50, 0.000001, 0.0);
    return 0;
}
