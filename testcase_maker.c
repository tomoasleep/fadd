#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <time.h>
#include <float.h>


typedef union floatint{
    struct{
        unsigned int ex : 23;
        unsigned int fr :  8;
        unsigned int si :  1;
    };
    uint32_t u;
    float f;
}ufi;

void fprint_bit(ufi u32, FILE *fp){//bit情報の表示
    int i;
    for (i = 31; i >= 0; i--) {
        fprintf(fp, "%d",((u32.u >> (i)) & 0x00000001));
    }
}

int do_gen_random() {
    return rand() | ((rand() < rand() ? 0x0 : 0x1) << 31);
}

int get_exp(int value) {
    return (value & 0x7f800000) >> 23;
}

int remove_nan(int value) {
    int exp = get_exp(value);
    return (exp == 0xff || exp == 0x00) ? (value & 0x7f800000) : value;
}

float gen_random() {
    int random_value = remove_nan(do_gen_random());
    return *(float*)&random_value;
}

int main(int argc, char *argv[]){
    int test_length; int i = 0;
    float sign_random;
    ufi a; ufi b; ufi r;

    if (argc <= 1) {
        printf("usage: %s TEST_LENGTH\n", argv[0]);
        exit(1);
    }
    srand((unsigned) time(NULL));

    test_length = (atoi(argv[1]));
    for (i = 0; i < test_length; i++) {
        a.f= gen_random(); b.f= gen_random();
        r.f = a.f + b.f;
        fprint_bit(a, stdout);
        fprintf(stdout, ", ");
        fprint_bit(b, stdout);
        fprintf(stdout, ", ");
        fprint_bit(r, stdout);
        fprintf(stdout, "\n");
    }
    return(0);
}
