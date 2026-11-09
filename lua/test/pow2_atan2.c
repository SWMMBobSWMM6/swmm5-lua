/* pow2_atan2.c - why the Lua port does not use Lua's x ^ 2 or math.atan: on 20,000,000 arguments (half any bit pattern,
   half moderate magnitudes), how often glibc's pow(x, 2) differs from x * x (what Lua 5.4's luai_numpow computes
   when the exponent is 2) and atan(x) from atan2(x, 1) (what Lua's math.atan(x) calls). Written by Claude
   (Anthropic) for Robert Dickinson; see ../README.md.  gcc -O2 -o pow2_atan2 pow2_atan2.c -lm && ./pow2_atan2 */
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <math.h>
static uint64_t s = 0x9E3779B97F4A7C15ull;
static uint64_t xr(void){ s ^= s<<13; s ^= s>>7; s ^= s<<17; return s; }
static double asd(uint64_t u){ double d; memcpy(&d,&u,8); return d; }
static uint64_t bits(double d){ uint64_t u; memcpy(&u,&d,8); return u; }
int main(void) {
  long n = 0, diff = 0, adiff = 0; volatile double two = 2.0;
  for (long i = 0; i < 20000000; i++) {
    double x;
    if (i % 2) x = asd(xr());                                   /* any bit pattern */
    else x = ldexp(1.0 + (double)(xr() >> 12) / 4503599627370496.0, (int)(xr() % 200) - 100);   /* moderate */
    if (xr() & 1) x = -x;
    double p = pow(x, two), q = x * x;
    n++;
    if (bits(p) != bits(q)) { if (diff < 5) printf("pow(%a,2)=%a  x*x=%a\n", x, p, q); diff++; }
    double a = atan(x), b = atan2(x, 1.0);
    if (bits(a) != bits(b)) { if (adiff < 5) printf("atan(%a)=%a atan2(x,1)=%a\n", x, a, b); adiff++; }
  }
  printf("%ld args: pow(x,2) != x*x in %ld; atan(x) != atan2(x,1) in %ld\n", n, diff, adiff);
  return 0;
}
