//
//  UserDefaultsReporter.swift
//  Diagnostics
//
//  Created by Antoine van der Lee on 02/12/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import Foundation

/// Generates a report from all the registered UserDefault keys.
public final class UserDefaultsReporter: DiagnosticsReporting {

    /// Defaults to `standard`. Can be used to override and return a different user defaults.
    public var userDefaults: [UserDefaults]
    
    public init(userDefaults: [UserDefaults] = [.standard]) {
        self.userDefaults = userDefaults
    }
    
    public func report() -> DiagnosticsChapter {
        let userDefaults = Dictionary(self.userDefaults.flatMap({ defaults in
            Array(defaults.dictionaryRepresentation())
        }), uniquingKeysWith: { $1 }).jsonRepresentation ?? ""
        return DiagnosticsChapter(title: "UserDefaults", diagnostics: userDefaults, formatter: JSONFormatting.self)
    }
}

private extension Dictionary where Key == String, Value == Any {
    var jsonRepresentation: String? {
        let options: JSONSerialization.WritingOptions
        if #available(iOS 11.0, *) {
            options = [.prettyPrinted, .sortedKeys, .fragmentsAllowed]
        } else {
            options = [.prettyPrinted, .fragmentsAllowed]
        }
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonCompatible, options: options) else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }

    var jsonCompatible: [String: Any] {
        return mapValues { value -> Any in
            if let dict = value as? [String: Any] {
                return dict.jsonCompatible
            } else if let array = value as? [Any] {
                return array.map { "\($0)" }
            }

            return "\(value)"
        }
    }
}
