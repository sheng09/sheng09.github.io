#include <iostream>
#include <string>
template <typename T> std::string getBits(T _x)
{
  long len   = sizeof(T) * 8 - 1;
  std::string str = '['+std::to_string(len+1)+"bits]";
  long x = *( (long*)(&_x) );
  #ifdef DEBUG
    std::cout << x <<'\n';
  #endif
  while( len-- != 0 )
  {
    if( (x >> len) & 1 )
      str+= '1';
    else
      str+= '0';
  }
  return str;
}

int main(int argc, char const *argv[]) {
  char a = 95;
  char index = 1;
  std::cout << "a:" << getBits(a) << "\n";
  std::cout << "a & 00000001:" << getBits( (char)( a & index   ) ) << "\n";
  std::cout << "a & 11111110:" << getBits( (char)( a & (~index)) ) << "\n";
  std::cout << "a | 00000001:" << getBits( (char)( a | index   ) ) << "\n";
  std::cout << "a ^ a       :" << getBits( (char)( a ^ a   ) ) << "\n";
  std::cout << "a &-a       :" << getBits( (char)( a &-a   ) ) << "\n";

  a = 90;
  std::cout << "a:" << getBits(a) << "\n";
  std::cout << "a & 00000001:" << getBits( (char)( a & index   ) ) << "\n";
  std::cout << "a & 11111110:" << getBits( (char)( a & (~index)) ) << "\n";
  std::cout << "a | 00000001:" << getBits( (char)( a | index   ) ) << "\n";
  std::cout << "a ^ a       :" << getBits( (char)( a ^ a   ) ) << "\n";
  std::cout << "a &-a       :" << getBits( (char)( a &-a   ) ) << "\n";
  return 0;
}
