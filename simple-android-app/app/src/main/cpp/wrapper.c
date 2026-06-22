/*
 * SPDX-FileCopyrightText: 2026 Davide De Rosa
 *
 * SPDX-License-Identifier: MIT
 */

#include <jni.h>
#include <stdlib.h>
#include "simple-library/simple-library.h"

JNIEXPORT jstring JNICALL
Java_com_davidederosa_cps_simpleandroidapp_SimpleLibraryWrapper_nativeGreeting(JNIEnv *env, jobject thiz) {
    (void)thiz;
    char *greeting = simple_greeting();
    jstring j_greeting = (*env)->NewStringUTF(env, greeting);
    free(greeting);
    return j_greeting;
}
