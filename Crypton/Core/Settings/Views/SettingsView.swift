//
//  SettingsView.swift
//  Crypton
//
//  Created by Daniil Antsyferov on 4/10/25.
//

import SwiftUI

struct SettingsView: View {

    @Environment(\.dismiss) var dismiss

    let defaultURL = URL(string: "https://www.google.com")!
    let youtubeURL = URL(string: "https://www.youtube/c/swiftfulthinking.com")!
    let coffeURL = URL(string: "https://www.buymeacoffee.com/nicksarno")!
    let coingeckoURL = URL(string: "https://www.coingecko.com")!
    let personalURL = URL(string: "https://github.com/reportedsocks")!

    var body: some View {
        NavigationView {
            List {
                switfulSection

                coinGeckoSection

                developerSection

                applicationSection
            }
            .accentColor(.blue)
            .font(.headline)
            .listStyle(.grouped)
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton(action: { dismiss() })
                }
            }

        }
    }
}

extension SettingsView {
    private var switfulSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("App created by following a SwiftUI course on YouTube by Nick Sarno!")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)

            }
            .padding(.vertical)

            Link("Subscribe on YouTube!", destination: youtubeURL)
            Link("Support his coffee addiction :)", destination: coffeURL)
        } header: {
            Text("Swiftful Thinking")
        }
    }

    private var coinGeckoSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("The cryptocurrency market data provider.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)

            }
            .padding(.vertical)

            Link("Visit website!", destination: coingeckoURL)
        } header: {
            Text("CoinGecko")
        }
    }

    private var developerSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("gojo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("Yep, that's totally me!")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)

            }
            .padding(.vertical)

            Link("Github", destination: personalURL)
        } header: {
            Text("Daniil Antsyferov")
        }
    }

    private var applicationSection: some View {
        Section {

            Link("Terms of Service", destination: defaultURL)
            Link("Privacy Policy", destination: defaultURL)
            Link("Company Website", destination: defaultURL)
        } header: {
            Text("Application")
        }
    }
}


#Preview {
    SettingsView()
}
