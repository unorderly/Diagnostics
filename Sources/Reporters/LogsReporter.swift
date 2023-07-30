//
//  LogsReporter.swift
//  Diagnostics
//
//  Created by Antoine van der Lee on 02/12/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import Foundation

/// Creates a report chapter for all system and custom logs captured with the `DiagnosticsLogger`.
struct LogsReporter: DiagnosticsReporting {

    let title: String = "Session Logs"

    func diagnostics() async -> String {
        guard let data = await DiagnosticsLogger.standard.readLog(), let logs = String(data: data, encoding: .utf8) else {
            return "Parsing the log failed"
        }

        let sessions = logs.components(separatedBy: "\n\n---\n\n").reversed()
        var diagnostics = ""
        if #available(iOS 15.0, *), let systemLogs = DiagnosticsLogger.standard.systemLogs() {
            diagnostics += """
                <div class="collapsible-session"><details><summary><div class="session-header"><p><span><b>System Logs</b></p></div></summary>
                \(systemLogs)
                </details></div>
                """
        }
        sessions.forEach { session in
            guard !session.isEmpty else { return }

            diagnostics += "<div class=\"collapsible-session\">"
            diagnostics += "<details>"
            diagnostics += session
            diagnostics += "</details>"
            diagnostics += "</div>"
        }
        return diagnostics
    }

    func report() async -> DiagnosticsChapter {
        let diagnostics = await self.diagnostics()
        return DiagnosticsChapter(title: title, diagnostics: diagnostics, formatter: Self.self)
    }
}

extension LogsReporter: HTMLFormatting {
    static func format(_ diagnostics: Diagnostics) -> HTML {
        return "<div id=\"log-sessions\">\(diagnostics)</div>"
    }
}

private extension String {
    var isOldStyleSession: Bool {
        !contains("class=\"session-header")
    }
}
