#ifndef GSW_ALLOC
#define GSW_ALLOC
#ifdef __cplusplus
extern "C" {

#include <stdlib.h>
#include <stdio.h>
#endif

    void* gsw_alloc(size_t size);
    void  gsw_free(void *ptr);
    void* gsw_calloc(size_t len, size_t element_size);
    void* gsw_memcpy(void* dest, void *src, size_t len);
    void* gsw_memset(void* src, int c, size_t n);
    size_t gsw_fwrite(         const void *ptr, size_t size, size_t len, FILE *stream );

FILE* gsw_fopen(const char*name, const char *mode);


int gsw_fclose(FILE *fp);
#ifdef __cplusplus
}
#endif

#endif
