#include <stdint.h>
#include <stddef.h>
#include <signal.h>

int64_t mdiv(int64_t *x, size_t n, int64_t y){
    int64_t sign = x[--n] ^ y;
    int64_t buf;
    if(x[n] == INT64_MIN && y == -1){
        buf = -1;
        x[n] = INT64_MAX;
    } else {
        buf = (x[n] % y + y) % y;
        x[n] = (x[n] - buf) / y;
    }
    while(n > 0){
        n--;
        for(int64_t j = 8 * sizeof(int64_t) - 1; j >= 0; j--){
            buf = (buf << 1) + ((((uint64_t) x[n]) >> j) & 1ULL);
            if((buf ^ (buf - y)) < 0 && buf != y ){
                x[n] &= ~(1ULL << j);
            } else {
                x[n] |= (1ULL << j);
                buf -= y;
            }
        }
    }
    if(sign < 0 && buf != 0){
        buf -= y;
        do{
            x[n]++;
        }while(x[n++] == 0);
    }
    if(buf == y)
        raise(SIGFPE);

    return buf;
}
