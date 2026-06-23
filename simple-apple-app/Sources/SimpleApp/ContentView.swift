// SPDX-FileCopyrightText: 2026 Davide De Rosa
//
// SPDX-License-Identifier: MIT

import SimpleLibrary
import SwiftUI

struct ContentView: View {
    @State
    private var greeting = ""

    var body: some View {
        Text(greeting)
            .task {
                do {
                    greeting = try Greeting.shared.json()
                } catch {
                    greeting = error.localizedDescription
                }
            }
    }
}
