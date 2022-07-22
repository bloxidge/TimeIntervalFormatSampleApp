//
//  TimeIntervalFormatter.swift
//  TimeIntervalFormatSampleApp
//
//  Created by Peter Bloxidge on 12/07/2022.
//

import Foundation

enum TimeIntervalFormat: CaseIterable {

    case one, two, three, four, five, six, seven, eight, nine, ten, eleven, twelve

    static var gmtTimeZone = TimeZone(identifier: "GMT")!

    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = Self.gmtTimeZone
        return formatter
    }()

    func accessibilityString(for timeInterval: TimeInterval) -> String {
        switch self {
        case .one:
            return dateFormat(timeInterval, format: "H, mm, s")
                .withSecondsSuffix()
        case .two:
            return dateFormat(timeInterval, format: "HH, mm, ss")
                .withSecondsSuffix()
        case .three:
            return dateFormat(timeInterval, format: "HH mm ss")
                .withSecondsSuffix()
        case .four:
            return dateFormat(timeInterval, format: "H mm s")
                .withDoubleToSingleZeros()
                .withSecondsSuffix()
        case .five:
            return dateFormat(timeInterval, format: "H:mm s")
                .withSecondsSuffix()
        case .six:
            return dateFormat(timeInterval, format: "H:m s")
                .withSecondsSuffix()
        case .seven:
            return dateFormat(timeInterval, format: "h:mma s")
                .withSecondsSuffix()
        case .eight:
            return dateFormat(timeInterval, format: "hh:mma 'and' s")
                .withSecondsSuffix()
        case .nine:
            return dateFormat(timeInterval, format: "hh:mma, s")
                .withSecondsSuffix()
        case .ten:
            return dateFormat(timeInterval, format: "HH:mm.s")
                .withSecondsSuffix()
        case .eleven:
            return dateFormat(timeInterval, format: "HH:mm:s")
        case .twelve:
            return dateFormatOther(timeInterval)
        }
    }

    private func dateComponentFormat(_ timeInterval: TimeInterval) -> String {
        let timeIntervalAsDate = Date(timeIntervalSince1970: timeInterval)
        var calendar = Calendar.current
        calendar.timeZone = Self.gmtTimeZone
        let dateComponents = calendar.dateComponents([.hour, .minute, .second], from: timeIntervalAsDate)

        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        formatter.calendar = calendar
        return formatter.string(from: dateComponents)?
            .replacingOccurrences(of: " hours", with: "")
            .replacingOccurrences(of: " hour", with: "")
            .replacingOccurrences(of: " minutes", with: "")
            .replacingOccurrences(of: " minute", with: "")
//            .replacingOccurrences(of: " , ", with: " ")
            .replacingOccurrences(of: " 0", with: " 0 ") ?? ""
    }

    private func dateFormat(_ timeInterval: TimeInterval, format: String) -> String {
        Self.dateFormatter.dateFormat = format
        return Self.dateFormatter.string(from: Date(timeIntervalSince1970: timeInterval))
    }

    private func dateFormatOther(_ timeInterval: TimeInterval) -> String {
        Self.dateFormatter.dateStyle = .none
        Self.dateFormatter.timeStyle = .medium
        return Self.dateFormatter.string(from: Date(timeIntervalSince1970: timeInterval))
    }
}

private extension String {
    func withDoubleToSingleZeros() -> String {
        return replacingOccurrences(of: "00", with: "0")
    }

    func withSecondsSuffix() -> String {
        if self.hasSuffix(" 01") || hasSuffix(" 1") || hasSuffix(":1") {
            return "\(self) second"
        } else {
            return "\(self) seconds"
        }
    }
}
