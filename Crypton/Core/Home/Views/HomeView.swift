//
//  HomeView.swift
//  Crypton
//
//  Created by Daniil Antsyferov on 20/9/25.
//

import SwiftUI

struct HomeView: View {

    @State private var showPortfolio: Bool = false
    @State private var chevronRotation: Angle = .zero

    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea(edges: .all)

            VStack {
                homeHeader

                Spacer()
            }
        }
    }
}

#Preview {
    NavigationView {
        HomeView()
            .navigationBarHidden(true)
    }
}

extension HomeView {

    private var homeHeader: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .background {
                    CircleButtonAnimationView(animate: $showPortfolio)
                }

            Spacer()

            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)

            Spacer()

            CircleButtonView(iconName: "chevron.right")
                .onTapGesture {
                    showPortfolio.toggle()
                }
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .animation(.spring, value: showPortfolio)
        }
        .padding(.horizontal)
    }
}
