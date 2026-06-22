// SPDX-FileCopyrightText: 2026 Davide De Rosa
//
// SPDX-License-Identifier: MIT

package com.davidederosa.cps.simpleandroidapp

class SimpleLibraryWrapper {
    private external fun nativeGreeting(): String

    fun greeting(): String {
        return nativeGreeting()
    }

    companion object {
        init {
            System.loadLibrary("SimpleLibraryWrapper")
        }
    }
}
