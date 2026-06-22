# SPDX-FileCopyrightText: 2026 Davide De Rosa
#
# SPDX-License-Identifier: MIT

cmake_minimum_required(VERSION 3.28)
if(POLICY CMP0157)
    cmake_policy(SET CMP0157 NEW)
endif()
project(SimpleLibraryProject LANGUAGES Swift)
set(SRCROOT Sources/SimpleLibrary)
add_library(SimpleLibrary SHARED
    ${SRCROOT}/Greeting.swift
    ${SRCROOT}/Greeting_C.swift
    ${SRCROOT}/SimpleLibrary.swift
)
target_compile_options(SimpleLibrary PRIVATE
    -language-mode 6
)
