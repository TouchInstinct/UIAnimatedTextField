//
//  TIDateFormatter.swift
//  Pods
//
//  Created by Ivan Zinovyev on 12/19/16.
//
//

import Foundation

class TIDateFormatter {
    
    fileprivate static let dateLongFormat  = "dd/MM/YYYY"
    fileprivate static let dateShortFormat = "dd/MM/YY"
    fileprivate static let monthDayFormat = "MMMM d"
    
    fileprivate let longDateFormatter = DateFormatter()
    fileprivate let shortDateFormatter = DateFormatter()
    fileprivate let monthDayDateFormatter = DateFormatter()
    
    private static let shared = TIDateFormatter()
    
    // MARK: Init
    
    private init() {
        longDateFormatter.dateFormat = TIDateFormatter.dateLongFormat
        shortDateFormatter.dateFormat = TIDateFormatter.dateShortFormat
        monthDayDateFormatter.dateFormat = TIDateFormatter.monthDayFormat
    }
    
    // MARK: Public functions
    
    static func longDate(from date: Date) -> String {
        return shared.longDateFormatter.string(from: date)
    }
    
    static func shortDate(from date: Date) -> String {
        return shared.shortDateFormatter.string(from: date)
    }
    
    /// - Returns: example: "December 2"
    static func monthDay(from date: Date) -> String {
        return shared.monthDayDateFormatter.string(from: date)
    }
    
}
