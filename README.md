# Cross-platform Swift

These are excerpts from my (ongoing) series about cross-platform Swift:

https://davidederosa.com/cross-platform-swift/

The series is about how I'm porting [Passepartout](https://github.com/passepartoutvpn/passepartout), my Swift/SwiftUI VPN client, beyond the Apple ecosystem.

## Samples

### [SubjectStreams][samples-subject-streams]

Simple replacements for Combine subjects with AsyncStream and Swift 6 Concurrency. The motivations are described in [this article][blog-combine].

### [C Interoperability][samples-c-interop]

Examples of typical situations involved in Swift/C interop. Showcase the use of opaque pointers. Read [these articles][blog-c-interop] for more insights.

[blog-combine]: https://davidederosa.com/cross-platform-swift/combine/
[blog-c-interop]: https://davidederosa.com/cross-platform-swift/c-interop-part-one/

### [Simple ABI][samples-simple-abi]

Patterns to expose a C ABI from a Swift library to a non-Swift application.

[samples-subject-streams]: https://github.com/keeshux/cross-platform-swift/tree/master/Sources/SubjectStreams
[samples-c-interop]: https://github.com/keeshux/cross-platform-swift/tree/master/Sources/CInterop
[samples-simple-abi]: https://github.com/keeshux/cross-platform-swift/tree/master/Sources/SimpleABIConsumer_C
