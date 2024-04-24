#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

int64_t mdiv(int64_t *x, size_t n, int64_t y){
    bool negative = ((x[--n] >= 0) ^ (y >= 0)) ? true : false;
    int64_t buf = (x[n] % y + y) % y;
    x[n] = (x[n] - buf) / y;
    while(n > 0){
        n--;
        for(int j = 63; j >= 0; j--){
            buf = (buf << 1) + ((((uint64_t) x[n]) >> j) & 1ULL);
            if(buf / y)
                x[n] |= (1ULL << j);
            else
                x[n] &= ~(1ULL << j);
            buf %= y;
        }
    }
    if(negative){
        int n = 0;
        buf -= y;
        while(true){
            x[n]++;
            if(x[n] != 0)
                break;
        }
    }
    return buf;
}
