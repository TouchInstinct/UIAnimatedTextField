//
//  String+Extensions.swift
//  Pods
//
//  Created by Ivan Zinovyev on 12/19/16.
//
//

import Foundation

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    var isMultiline: Bool {
        return range(of: "\n") != nil
    }
    
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        let emailPredicat = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicat.evaluate(with: self)
    }
    
}
