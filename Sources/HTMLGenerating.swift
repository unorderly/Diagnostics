//
//  HTMLGenerating.swift
//  Diagnostics
//
//  Created by Antoine van der Lee on 02/12/2019.
//  Copyright © 2019 WeTransfer. All rights reserved.
//

import Foundation

public typealias HTML = String

public protocol HTMLGenerating {
    func html() -> HTML
}

public protocol HTMLFormatting {
    static func format(_ diagnostics: Diagnostics) -> HTML
}

extension Dictionary: HTMLGenerating where Key == String {
    public func html() -> HTML {
        var html = "<table>"

        for (key, value) in self.sorted(by: { $0.0 < $1.0 }) {
            html += "<tr><th>\(key.description)</th><td>\(value)</td></tr>"
        }

        html += "</table>"

        return html
    }
}

extension KeyValuePairs: HTMLGenerating where Key == String, Value == String {
    public func html() -> HTML {
        var html = "<table>"

        for (key, value) in self {
            html += "<tr><th>\(key)</th><td>\(value)</td></tr>"
        }

        html += "</table>"

        return html
    }
}

extension Array: HTMLGenerating where Element == String {
    public func html() -> HTML {
        var html = "<table>"

        for element in self {
            html += "<tr>\(element)</tr>"
        }

        html += "</table>"

        return html
    }
}

extension String: HTMLGenerating {
    public func html() -> HTML {
        return self
    }
}

extension DirectoryTreeNode: HTMLGenerating {
    public func html() -> HTML {
        return "<pre>\(self)</pre>"
    }
}

extension DiagnosticsChapter: HTMLGenerating {
    public func html() -> HTML {
        var html = "<div class=\"chapter\">"
        html += "<span class=\"anchor\" id=\"\(title.anchor)\"></span>"

        if shouldShowTitle {
            html += "<h3>\(title)</h3>"
        }

        html += "<div class=\"chapter-content\">"

        if let formatter = formatter {
            html += formatter.format(diagnostics)
        } else {
            html += diagnostics.html()
        }

        html += "</div></div>"
        return html
    }
}

public struct JSONFormatting: HTMLFormatting {
    public static func format(_ diagnostics: Diagnostics) -> HTML {
        guard let text = diagnostics as? String else { return diagnostics.html() }
        let id = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        return """
        <a id="download-\(id)">Download</a>
        <div id="content-\(id)">\(text)</div>
        <script src="https://cdn.jsdelivr.net/gh/pgrabovets/json-view@master/dist/jsonview.js"></script>
        <script>
            var a = document.getElementById("download-\(id)");
            a.download = "Export.json";
            a.href = "data:application/json," + document.getElementById("content-\(id)").textContent;
            const tree\(id) = jsonview.create(document.getElementById("content-\(id)").textContent);
            document.getElementById("content-\(id)").textContent = "";
            jsonview.render(tree\(id), document.getElementById("content-\(id)"));
            jsonview.expand(tree\(id));
        </script>
        """
    }
}
