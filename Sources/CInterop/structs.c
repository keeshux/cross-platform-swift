// SPDX-FileCopyrightText: 2026 Davide De Rosa
//
// SPDX-License-Identifier: MIT

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "structs.h"

// prints the title followed by the result of the func applied
// to the nums vector
const char *cps_complex_accumulate_string(const cps_complex_struct *ptr) {
    const int result = ptr->fun(ptr->nums, sizeof(ptr->nums) / sizeof(int));

    // we return a fixed-size string for the sole purpose
    // of the tutorial, but this is POOR practice
    char *buf = (char *)calloc(1, 100);
    snprintf(buf, 100, "%s: %d", ptr->title, result);
    return buf;
}

// MARK: -

// opaque struct, hidden from Swift
typedef struct {
    const char *title;
    int nums[8];
    int (*fun)(const int *, size_t);
} _cps_opaque_complex_struct;

cps_opaque_struct cps_opaque_create(const char *title,
                                    const int *nums,
                                    size_t nums_n,
                                    int (*fun)(const int *, size_t)) {

    _cps_opaque_complex_struct *ptr = malloc(sizeof(_cps_opaque_complex_struct));
    ptr->title = strdup(title);
    if (nums_n > 8) {
        nums_n = 8;
    }
    memcpy(ptr->nums, nums, sizeof(int) * nums_n);
    ptr->fun = fun;
    return (cps_opaque_struct)ptr;
}

void cps_opaque_destroy(cps_opaque_struct ptr) {
    _cps_opaque_complex_struct *c_ptr = (_cps_opaque_complex_struct *)ptr;
    free((char *)c_ptr->title);
    free(c_ptr);
}

// same logic
const char *cps_opaque_accumulate_string(const cps_opaque_struct ptr) {
    return cps_complex_accumulate_string((const cps_complex_struct *)ptr);
}
