#ifndef MAT_H
#define MAT_H
#include "gsw_alloc.h"
#include <iostream>
#include <string>
#include <utility>
//template must be placed in the header file
namespace MAT {
    template <class T> T*  alloc1d(std::size_t len, T* &p)
        {
            p = (T*)gsw_alloc(len*sizeof(T));
            return p;
        }
    template <class T>
        T** alloc2d(std::size_t nx, std::size_t ny, T** &ptr)
        {
            //n1 = std::max(nx, ny)
            ptr = (T**)gsw_alloc(nx* ny* sizeof(T) + nx* sizeof(T*));
            T*  dat = (T*)(ptr + nx);
            for(std::size_t ix = 0; ix < nx; ++ix)
                ptr[ix] = dat + ix * ny;
            return ptr;
        }
    template <class T>
        T*** alloc3d(std::size_t nx, std::size_t ny, std::size_t nz, T*** &ptr)
        {
            ptr = (T***)gsw_alloc(nx*ny*nz*sizeof(T) + nx*ny*sizeof(T*) + nx*sizeof(T**));
            T**  p2  = (T**)(ptr + nx);
            T*   dat = (T* )(p2 + nx*ny);
            std::size_t nyz = ny*nz;
            for(std::size_t ix = 0; ix < nx; ++ix)
            {
                ptr[ix] = p2 + ix*nyz;
                T* d0 = dat + ix*nyz;
                for(std::size_t iy =0; iy < ny; ++iy)
                    ptr[ix][iy] = d0 + iy * nz;
            }
            return ptr;
        }
    template <class T>
        void free1d(T*   ptr) { gsw_free( (void*) ptr); }
    template <class T>
        void free2d(T**  ptr) { gsw_free( (void*) ptr); }
    template <class T>
        void free3d(T*** ptr) { gsw_free( (void*) ptr); }

    template <class T>
        T* memcpy(T* dest, T* src, std::size_t l)
        {
            gsw_memcpy(dest, src, l);
            return dest;
        }
    template <class T>
        T* setZero(T* src, std::size_t len) { gsw_memset(src, 0, len*sizeof(T)); }
    template <class T>
        void add(T* s1, T* s2, T* result, std::size_t len) {for(std::size_t i=0; i<len; ++i) result[i] = s1[i] + s2[i]; }
};

template <class T> class mat2d;
class file {
public:
    file(std::string filename, std::string mode)
        : d_filename(filename)
    {
        d_fp = gsw_fopen(filename.c_str(), mode.c_str() );
    }
    ~file() { gsw_fclose(d_fp); }
    template<class U>
        friend file& operator<<(file& f, mat2d<U>& m);
private:
    std::string d_filename;
    FILE *d_fp;
};

template <class T>
class mat2d{
public:
    mat2d()            : d_state(VOID)    {}
    mat2d(mat2d<T> &m) : d_state(VALUED)  { init(m.d_nx, m.d_ny); MAT::memcpy(d_dat, m.d_dat, d_nxy*sizeof(T)); }
    mat2d(std::size_t nx, std::size_t ny) { init(nx, ny); }
    mat2d(std::size_t nx, std::size_t ny, T* dat) : mat2d(nx, ny) { d_state = VALUED; MAT::memcpy(d_dat, dat, d_nxy*sizeof(T)); }
    ~mat2d() { MAT::free2d(d_ptr); }
    mat2d<T>& resize(size_t nx, size_t ny) { init(nx, ny); }
    mat2d<T>& operator=(mat2d<T>& m) = delete;
    T* operator[](std::size_t ix) { return d_ptr[ix]; }
    T* getDat1d() { return d_dat; }
    mat2d<T>& reshape(std::size_t nx, std::size_t ny)
    {
        T** ptr = d_ptr; T* dat = d_dat;
        init(nx, ny);
        MAT::memcpy(d_dat, dat, d_nxy*sizeof(T));
        MAT::free2d(ptr);
        return *this;
    }

    mat2d<T>& transpose()
    { // note, for complex number!
        T** ptr = d_ptr; T* dat = d_dat;
        init(d_ny, d_nx);
        for(std::size_t iy = 0; iy < d_ny; ++iy)
            for(std::size_t ix = 0; ix < d_nx; ++ix)
                d_ptr[ix][iy] = ptr[iy][ix];
        MAT::free2d(ptr);
        return *this;
    }
    
    std::size_t size_x() {return d_nx; }
    std::size_t size_y() {return d_ny; }
    std::pair<std::size_t, std::size_t> dimension() { return std::pair<std::size_t, std::size_t> (d_nx, d_ny); }
    std::size_t size()  { return d_nxy; }
    typedef T* iterator;
    iterator begin() { return d_dat;}
    iterator end()   { return d_dat+d_nxy;}
    
    mat2d<T>& setIdentity(T value = (T)(1)) {setZero(); for(std::size_t i=0; i<std::min(d_nx, d_ny); ++i) d_ptr[i][i] = value; return *this; }
    mat2d<T>& setUnit(T value){ for(iterator mit = begin(); mit!=end(); ++mit)  *mit=value; return *this; }
    mat2d<T>& setZero()    { MAT::setZero(d_dat, d_nxy);  return *this;}
    mat2d<T>& scale(T val) { for(iterator it = begin(); it != end(); ++it) *it *= val; return *this; }
    mat2d<T>& add(T val)   { for(iterator it = begin(); it != end(); ++it) *it += val; return *this; }

    iterator findIter(iterator it, std::size_t &ix, std::size_t &iy)
    {
        iterator mit;
        for(mit = begin(); mit != end(); ++mit)
            if(mit == it) break;
        if( mit != end() )
        {
            std::size_t index = mit-begin();
            ix = index / d_ny;
            iy = index - ix*d_ny;
            return mit;
        }
        else
            return end();
    }
    iterator getLeft(std::size_t ix, std::size_t iy)
    { 
        if(ix>1) return (T*)&(d_ptr[ix][iy]) - 1; else  exit(-1);//error processing
    }
    iterator getRight(std::size_t ix, std::size_t iy)
    {
        if(ix<d_ny-1) return (T*)&(d_ptr[ix][iy]+1); else exit(-1); //error processing
    }
    iterator getTop(std::size_t ix, std::size_t iy)
    {
        if(iy>1) return (T*)&(d_ptr[ix][iy]-d_ny); else exit(-1); //error processing
    }
    iterator getBottom(std::size_t ix, std::size_t iy)
    {
        if(iy<d_ny-1) return (T*)&(d_ptr[ix][iy]+d_ny); else  exit(-1); //error processing
    }

    bool isSquqre() { return d_nx == d_ny; }
    bool isValued() { return d_state == VALUED;} // whether mat2d is alloced with value
    bool isVoid()   { return !VOID; }            // whether mat2d is void
    bool isAlloced(){ return d_state; }          // whether mat2d is alloced, value is not considered
    
    template <class U>
        friend mat2d<U>& add(mat2d<U> &m1, mat2d<U> &m2, mat2d<U> &result);
    template <class U>
        friend mat2d<U>& multi(mat2d<U> &m1, mat2d<U> &m2, mat2d<U> &result);
    template <class U>
        friend bool sameDimension(mat2d<U> &m1, mat2d<U> &m2);
    template<class U>
        friend file& operator<<(file& f, mat2d<U>& m);

    void display2(std::ostream &o=std::cout)
    {
        o << "\n";
        for(std::size_t ix = 0; ix < d_nx; ++ix)
        {
            o << "[ ";
            for(std::size_t iy = 0; iy < d_ny; ++iy)
                o << d_ptr[ix][iy] << ", ";
            o << "]\n";
        }
        o << "\n";
    }
    void display(std::ostream &o = std::cout)
    {
        o << "\nmat2d instace @ " << (void*) this << "\n";
        o << "element size: " << sizeof(T) << " bytes\n";
        o << "nx= "<< d_nx <<"; ny= "<<d_ny << "\n";
        o << "heap memory scope: " <<(void*)&d_ptr <<" ==> ["  << (void*)d_ptr << ", " << (void*) ( ((char*)d_ptr) + d_memSize) << ")\n";
        o << "heap data scope:   " <<(void*)&d_dat <<" ==> ["  << (void*)d_dat << ", " << (void*) (d_dat + d_nxy) << ")\n";
        for(std::size_t ix = 0; ix < d_nx; ++ix)
        {
            o << "mat["<< ix << "] @ " <<(void*)&( d_ptr[ix] ) << " ==> " << (void*) (d_ptr[ix]) << "\n";
            for(std::size_t iy = 0; iy < d_ny; ++iy)
                o << "\tmat[" << ix << "][" << iy << "] @ " << (void*) &(d_ptr[ix][iy]) << " = " << d_ptr[ix][iy] << "\n";
        }
    }
private:
    void init(std::size_t nx, std::size_t ny)
    {
        if (nx>0 && ny>0 )
        {
            d_state = ALLOCED;
            d_nx = nx; d_ny = ny;
            d_nxy = nx * ny;
            MAT::alloc2d(nx, ny, d_ptr);
            d_dat = (T*) (d_ptr + nx);
            pp = (void*) pp;
            d_memSize = sizeof(T*) * nx + sizeof(T) * nx*ny;
        }
        else
        {/*error processing*/ exit(-1);}
    }
private:
    enum : std::size_t { VOID = 0, ALLOCED = 1, VALUED = 2  };
    std::size_t d_state;
    std::size_t d_nx, d_ny;
    std::size_t d_nxy;
    std::size_t d_memSize;
    void *pp;
    T** d_ptr;
    T*  d_dat;
};

template <class T>
    file& operator<<(file& f, mat2d<T>& m)
{ gsw_fwrite(m.d_dat, sizeof(T), m.d_nxy, f.d_fp); }

template <class T>
    mat2d<T>& add(mat2d<T> &m1, mat2d<T> &m2, mat2d<T> &result)
{
    if ( sameDimension(m1, m2) && sameDimension(m1, result) )
    {
        MAT::add(m1.d_dat, m2.d_dat, result.d_dat, result.d_nxy);
        result.d_state = mat2d<T>::VALUED;
    }
    else
    {/*error processing*/;}
    return result;
}
template <class U>
    bool sameDimension(mat2d<U> &m1, mat2d<U> &m2) { return (m1.d_nx == m2.d_nx && m1.d_ny == m2.d_ny); }
template <class U>
    mat2d<U>& multi(mat2d<U> &m1, mat2d<U> &m2, mat2d<U> &result)
{
    if (m1.d_ny == m2.d_nx && m1.d_nx == result.d_nx && m2.d_ny == result.d_ny)
    {
        for(std::size_t ix = 0; ix < result.d_nx; ++ix)
            for(std::size_t iy =0; iy < result.d_ny; ++iy)
            {
                result[ix][iy] = (U)(0);
                for(std::size_t index =0; index < m1.d_ny; ++index)
                    result[ix][iy] += m1[ix][index] * m2[index][iy];
            }
        result.d_state = mat2d<U>::VALUED;
    }
    else
    {/*error processing*/;}
    return result;
}
#endif

















