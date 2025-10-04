//
//  String.swift
//  Crypton
//
//  Created by Daniil Antsyferov on 4/10/25.
//

import Foundation

extension String {

    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
    }
}
