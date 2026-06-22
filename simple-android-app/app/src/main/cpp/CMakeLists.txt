# SPDX-FileCopyrightText: 2026 Davide De Rosa
#
# SPDX-License-Identifier: MIT

cmake_minimum_required(VERSION 3.22.1)
project(SimpleLibrary LANGUAGES C)
set(CMAKE_C_FLAGS "-W -Wall -Werror -pedantic")

# Define the Swift library
include("${CMAKE_CURRENT_SOURCE_DIR}/swift-cmake-toolchains/swift-android-env.cmake")
add_swift_target(SimpleLibrary ${CMAKE_CURRENT_SOURCE_DIR}/simple-library)

# Embed in wrapper
add_library(SimpleLibraryWrapper SHARED wrapper.c)
target_include_directories(SimpleLibraryWrapper PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
target_link_libraries(SimpleLibraryWrapper PRIVATE SimpleLibrary)

# Strip then copy to destination
add_custom_command(TARGET SimpleLibraryWrapper POST_BUILD
        COMMAND ${CMAKE_STRIP} "$<TARGET_FILE:SimpleLibrary>"
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
            "$<TARGET_FILE:SimpleLibrary>"
            "$<TARGET_FILE_DIR:SimpleLibraryWrapper>/$<TARGET_FILE_NAME:SimpleLibrary>"
        COMMAND ${CMAKE_COMMAND} -E copy_if_different
            "$<TARGET_FILE:${SWIFT_ANDROID_CXX_SHARED_TARGET}>"
            "$<TARGET_FILE_DIR:SimpleLibraryWrapper>/$<TARGET_FILE_NAME:${SWIFT_ANDROID_CXX_SHARED_TARGET}>"
)
