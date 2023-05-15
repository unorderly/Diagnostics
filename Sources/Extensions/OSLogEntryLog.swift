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
    var formattedMessage: String {
        """
        <p class="debug"><span class="log-date">\(DateFormatter.current.string(from: self.date))</span><span class="log-separator"> | </span><span class="log-prefix">\(self.subsystem)-\(self.category)</span><span class="log-separator"> | </span><span class="log-message">\(self.composedMessage)</span></p>
        """
    }
}
