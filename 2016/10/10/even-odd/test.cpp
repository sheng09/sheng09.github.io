#define ISODD(x) ((x)&1)
#include <iostream>
int main(int argc, char** argv)
{
  int    x[5] = {0, 10, 11, -10, -13};
  long   l[4] = {10, 11, -10, -13};
  short  s[4] = {10, 11, -120, -17};
  for(int i = 0; i < 5; ++i)
  {
    if( ISODD(x[i]) )
      std::cout << "int:" << x[i] << ": odd\n";
    else
      std::cout << "int:" << x[i] << ": even\n";
  }
  for(int i = 0; i < 4; ++i)
  {
    if( ISODD(l[i]) )
      std::cout << "long:" << l[i] << ": odd\n";
    else
      std::cout << "long:" << l[i] << ": even\n";
  }
  for(int i = 0; i < 4; ++i)
  {
    if( ISODD(s[i]) )
      std::cout << "short:" << s[i] << ": odd\n";
    else
      std::cout << "short:" << s[i] << ": even\n";
  }
}
