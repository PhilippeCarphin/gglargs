#include <stdio.h>


int main(void){
    int a[] = {0,11,22,33,44,55,66,77,88,99};

    int *a_ptr = &a[9];
    printf("==== Initial situation\n");
    printf("a[9] = %d\n", a[9]);
    printf("a[8] = %d\n", a[8]);
    printf("a[7] = %d\n", a[7]);
    printf("a_ptr = &a[9] = %p -> %d\n", a_ptr, *a_ptr);

    printf("====  *a_ptr-- reduces the pointer and looks at the value\n");
    *a_ptr--;
    printf("a_ptr=%p -> (*a_ptr)=%d\n", a_ptr, *a_ptr);

    printf("====  (*a_ptr)-- reduces the value in the array and does not reduce the pointer further\n");
    (*a_ptr)--;
    printf("a_ptr=%p -> (*a_ptr)=%d\n", a_ptr, *a_ptr);

    printf("a[9] = %d\n", a[9]);
    printf("a[8] = %d\n", a[8]);
    printf("a[7] = %d\n", a[7]);

    return 0;
}
