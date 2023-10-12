//
//  Logger.swift
//  ClassFaceAttendance
//
//  Created by Huy Pham on 12/10/2023.
//

import Foundation

private enum LogEvent: String {
    case error = "❌"
    case info = "💬"
    case warning = "⚠️"

    func getInfo(withData data: Any, filePath: String, line: Int, column: Int) -> String {
        let filePathComponents = filePath.components(separatedBy: "/")
        let fileName = filePathComponents.isEmpty ? "" : filePathComponents.last!
        let classInfo = "[\(fileName)] [\(line) - \(column)]"

        let dateString = "[\(Date().toString(withFormat: "dd-MM-yyyy hh:mm:ssSSS"))]"
        let logEventInfo = "[\(rawValue)]"

        return "➤ \(dateString) \(classInfo) \(logEventInfo) \(data)"
    }
}

class Log {
    class func info(
        _ data: Any,
        filePath: String = #file,
        line: Int = #line,
        column: Int = #column
    ) {
        let logInfo = LogEvent.info.getInfo(withData: data, filePath: filePath, line: line, column: column)
        #if DEBUG
            print(logInfo)
        #endif
    }

    class func error(
        _ data: Any,
        filePath: String = #file,
        line: Int = #line,
        column: Int = #column
    ) {
        let logInfo = LogEvent.error.getInfo(withData: data, filePath: filePath, line: line, column: column)
        #if DEBUG
            print(logInfo)
        #endif
    }

    class func warning(
        _ data: Any,
        filePath: String = #file,
        line: Int = #line,
        column: Int = #column
    ) {
        let logInfo = LogEvent.warning.getInfo(withData: data, filePath: filePath, line: line, column: column)
        #if DEBUG
            print(logInfo)
        #endif
    }
}
