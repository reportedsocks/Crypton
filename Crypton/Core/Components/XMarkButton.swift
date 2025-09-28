//
//  XMarkButton.swift
//  Crypton
//
//  Created by Daniil Antsyferov on 27/9/25.
//

import SwiftUI

struct XMarkButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action, label: {
            Image(systemName: "xmark")
                .font(.headline)
        })
    }
}

#Preview {
    XMarkButton(action: {})
}
