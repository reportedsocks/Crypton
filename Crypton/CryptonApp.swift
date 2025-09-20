//
//  CryptonApp.swift
//  Crypton
//
//  Created by Daniil Antsyferov on 20/9/25.
//

import SwiftUI

@main
struct CryptonApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
            }
        }
    }
}
