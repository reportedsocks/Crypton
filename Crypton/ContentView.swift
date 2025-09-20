//
//  ContentView.swift
//  Crypton
//
//  Created by Daniil Antsyferov on 20/9/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {

            Color.theme.background
                .ignoresSafeArea(edges: .all)

            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Accent")
                    .foregroundColor(Color.theme.accent)

                Text("Secondary")
                    .foregroundColor(Color.theme.secondaryText)

                Text("Green")
                    .foregroundColor(Color.theme.green)

                Text("Red")
                    .foregroundColor(Color.theme.red)
            }
            .font(.title)
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
