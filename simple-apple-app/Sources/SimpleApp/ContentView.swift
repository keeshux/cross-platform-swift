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
                greeting = Greeting.shared.json()
            }
    }
}
