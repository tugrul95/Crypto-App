//
//  String.swift
//  Crypto
//
//  Created by Macbook on 18.01.2022.
//

import Foundation

extension String {
    /// Removes HTML code in a String
    var removeHTMLOccurrences: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
