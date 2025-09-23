//
//  UIApplication.swift
//  Crypton
//
//  Created by Daniil Antsyferov on 23/9/25.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
