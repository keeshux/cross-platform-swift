// SPDX-FileCopyrightText: 2026 Davide De Rosa
//
// SPDX-License-Identifier: MIT

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include "simple_abi.h"

/* Initialized elsewhere. */
typedef struct {
    int initial_value;
    void (*perform)(int);
    void (*report_failure)(slow_error);
} complex_object;

static void my_result_callback(void *ctx, int result, slow_error error_code) {
    complex_object *obj = (complex_object *)ctx;
    if (error_code != slow_error_none) {
        printf("Error: %d\n", error_code);
        obj->report_failure(error_code);
        return;
    }
    const int compound_result = obj->initial_value + result;
    /* Expect initial value (50) + Swift value (100) = 150. */
    assert(compound_result == 150);
    printf("Compound result: %d\n", compound_result);
    /* Move on with our lives. */
    obj->perform(compound_result);
}

/* We assume `obj` to be the context to act upon, and we expect it
 * to survive the synchronous function call. A pointer to a local
 * variable cannot be the context of an async function, because
 * the callback would eventually refer to a dangling pointer.
 */
void invoke_swift_async_function(complex_object *obj) {
    swift_slow_result(slow_error_none, obj, my_result_callback);
    /* Use first argument to simulate failure behavior. */
//    swift_slow_result(slow_error_foo, obj, my_result_callback);
}

void perform(int result) {
    printf("Perform operation with result %d\n", result);
}

void report_failure(slow_error error_code) {
    fprintf(stderr, "Report failure with code %d\n", error_code);
}

int main() {
    /* Malloc to survive async function. */
    complex_object *obj = malloc(sizeof(complex_object));
    obj->initial_value = 50;
    obj->perform = perform;
    obj->report_failure = report_failure;
    invoke_swift_async_function(obj);
    /* Yield for async callback to trigger. */
    sleep(1);
    return 0;
}
