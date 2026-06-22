# Cross-platform Swift

These are excerpts from my (ongoing) series about cross-platform Swift:

https://davidederosa.com/cross-platform-swift/

The series revolves around how I'm porting [Passepartout][github-passepartout], my Swift/SwiftUI VPN client, beyond the Apple ecosystem.

## Simple apps

The simple applications are the final outcome of the series: native frontends with a shared, cross-platform Swift library.

- [simple-apple-app][simple-apple-app] is a SwiftUI app built with SwiftPM.
- [simple-android-app][simple-android-app] is an Android app (Jetpack Compose + Swift) that runs from Android Studio without any additional tools. It relies on my [CMake tools for Swift][swift-cmake-toolchains].

All apps share the [simple-library][simple-library] target.

## Samples

### [SubjectStreams][samples-subject-streams]

Simple replacements for Combine subjects with AsyncStream and Swift 6 Concurrency. The motivations are described in [this article][blog-combine].

### [C Interoperability][samples-c-interop]

Examples of typical situations involved in Swift/C interop. Showcase the use of opaque pointers. Read [these articles][blog-c-interop] for more insights.

### [Simple ABI][samples-simple-abi]

Patterns to expose a C ABI from a Swift library to a non-Swift application. Read [the articles about integration][blog-integration].

[github-passepartout]: https://github.com/partout-io/passepartout

[blog-combine]: https://davidederosa.com/cross-platform-swift/combine/
[blog-c-interop]: https://davidederosa.com/cross-platform-swift/c-interop-part-one/
[blog-integration]: https://davidederosa.com/cross-platform-swift/integration-part-two/

[simple-apple-app]: https://github.com/keeshux/cross-platform-swift/tree/master/simple-apple-app
[simple-android-app]: https://github.com/keeshux/cross-platform-swift/tree/master/simple-android-app
[simple-library]: https://github.com/keeshux/cross-platform-swift/tree/master/simple-library
[swift-cmake-toolchains]: http://github.com/keeshux/swift-cmake-toolchains

[samples-subject-streams]: https://github.com/keeshux/cross-platform-swift/tree/master/Sources/SubjectStreams
[samples-c-interop]: https://github.com/keeshux/cross-platform-swift/tree/master/Sources/CInterop
[samples-simple-abi]: https://github.com/keeshux/cross-platform-swift/tree/master/Sources/SimpleABIConsumer_C
