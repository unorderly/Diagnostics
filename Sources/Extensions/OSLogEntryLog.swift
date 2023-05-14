//
//  OSLogEntryLog.swift
//  
//
//  Created by Kanishka on 10/05/23.
//

import Foundation
import OSLog

@available(iOS 15.0, *)
extension OSLogEntryLog {
    var message: String {
        return "[\(self.level)] \(DateFormatter.current.string(from: self.date)): \(self.subsystem)-\(self.category): \(self.composedMessage)"
    }
}
