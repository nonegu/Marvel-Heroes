//
//  Date+Extensions.swift
//  Marvel Heroes
//
//  Created by Ender on 26.09.2020.
//

import Foundation

extension Date {
    func string(with formatter: DateFormatter = .longFormatter) -> String {
        formatter.string(from: self)
    }
}

extension DateFormatter {
    /// Example: 2020-11-02T13:25:12.000+0300
    static let longFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000ZZZ"
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    static let shortFormatter: DateFormatter = {
        return formatter()
    }()
    
    static func formatter(with formatString: String = "yyyy-MM-dd") -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = formatString
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        return formatter
    }
}
