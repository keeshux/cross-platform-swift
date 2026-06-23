// SPDX-FileCopyrightText: 2026 Davide De Rosa
//
// SPDX-License-Identifier: MIT

@c
public func simple_greeting() -> UnsafeMutablePointer<CChar> {
    let value: String
    do {
        value = try Greeting.shared.json()
    } catch {
        value = "Encoding failed"
    }
    let bytes = value.utf8CString
    let pointer = UnsafeMutablePointer<CChar>.allocate(capacity: bytes.count)
    bytes.withUnsafeBufferPointer { buffer in
        pointer.initialize(from: buffer.baseAddress!, count: bytes.count)
    }
    return pointer
}
