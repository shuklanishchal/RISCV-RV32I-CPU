/*

Test RISC-V CPU with Fibonacci Sequence

*/

#include <stdio.h>

int fib(int n) {
	if (n < 2)
		return 1;
	return fib(n - 1) + fib(n - 2);
}
int main() {
    return fib(15);
}

