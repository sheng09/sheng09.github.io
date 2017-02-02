#include "gsw_alloc.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#ifdef __cplusplus
extern "C" {
#endif
//alloc
void* gsw_alloc(size_t size)
{
    void *ptr = malloc(size);
    if(ptr == NULL)
    {
        //error processing
    }
    return ptr;
}

void gsw_free(void *ptr)
{
    if(ptr != NULL)
    {
        free(ptr);
        //*ptr = NULL;
    }
}

void* gsw_calloc(size_t len, size_t element_size)
{
    void *ptr = calloc(len , element_size);
    if(ptr == NULL)
    {
        //error processing
    }
    return ptr;
}

void*  gsw_memcpy(void* dest, void *src, size_t len)
{
    if(dest == NULL || src == NULL)
    {
        //error processing
    }
    memcpy(dest, src, len);
    return dest;
}

void* gsw_memset(void* src, int c, size_t n)
{
    if(src == NULL)
    {
        //error processing
    }
    memset(src, c, n);
    return src;
}
FILE* gsw_fopen(const char*name, const char *mode)
{
    FILE *fp = fopen(name, mode);
    if(fp == NULL)
    {
        //error processing
    }
    return fp;
}
int gsw_fclose(FILE *fp)
{
    int r;
    if( ! (r=fclose(fp)) )
    {
        //error processing
    }
    return r;
}
size_t gsw_fwrite(const void *ptr, size_t size, size_t len, FILE *fp )
{
    if(fp == NULL)
    {
        //error processing
    }
    fwrite(ptr, size, len, fp);
}

#ifdef __cplusplus
}
#endif
