// SPDX-FileCopyrightText: 2026 Davide De Rosa
//
// SPDX-License-Identifier: MIT

#include <stdio.h>

typedef enum {
    slow_error_none = 0,
    slow_error_foo = 10,
    slow_error_bar = 20,
    slow_error_unknown = 1000
} slow_error;

void swift_slow_result(slow_error sim_error, void *ctx, void (*completion)(void *, int, slow_error));
