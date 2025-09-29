//
//  HapticManager.swift
//  Crypton
//
//  Created by Daniil Antsyferov on 28/9/25.
//

import Foundation
import SwiftUI

class HapticManager {
    private static let generator = UINotificationFeedbackGenerator()

    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
}
