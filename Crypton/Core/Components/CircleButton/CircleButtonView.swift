//
//  CircleButtonView.swift
//  Crypton
//
//  Created by Daniil Antsyferov on 20/9/25.
//

import SwiftUI

struct CircleButtonView: View {

    let iconName: String

    var body: some View {
        Image(systemName: iconName)
            .font(.headline)
            .foregroundColor(Color.theme.accent)
            .frame(width: 50, height: 50)
            .background {
                Circle()
                    .foregroundColor(Color.theme.background)
            }
            .shadow(
                color: Color.theme.accent.opacity(0.5),
                radius: 10, x: 0, y: 0
            )
            .padding()

    }
}

#Preview(traits: .sizeThatFitsLayout) {
    Group {
        CircleButtonView(iconName: "info")
        CircleButtonView(iconName: "plus")
            .colorScheme(.dark)
    }

}
