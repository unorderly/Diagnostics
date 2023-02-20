//
//  SmartInsightsProviding.swift
//
//  Created by Antoine van der Lee on 10/02/2022.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import Foundation

public protocol SmartInsightsProviding {

    /// Allows parsing the given chapter and read Smart Insights out of it.
    /// - Parameter `chapter`: The `DiagnosticsChapter` to use for reading out insights.
    /// - Returns: An collection of smart insights derived from the chapter.
    func smartInsights(for chapter: DiagnosticsChapter) async -> [SmartInsightProviding]
    
    /// Allows providing general smart insights, which don't depend on a specific chapter.
    /// - Returns: An collection of smart insights.
    func smartInsights() async -> [SmartInsightProviding]
}

extension SmartInsightsProviding {
    public func smartInsights(for chapter: DiagnosticsChapter) async -> [SmartInsightProviding] {
        return []
    }
    
    public func smartInsights() async -> [SmartInsightProviding] {
        return []
    }
}
