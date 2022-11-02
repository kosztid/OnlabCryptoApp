import Foundation

extension Double {
    private var formattercurrency6digits: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        return formatter
    }

    private var formattercurrency4digits: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 4
        return formatter
    }

    private var formattercurrency0digits: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        return formatter
    }

    private var formatter2digits: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter
    }

    func formatcurrency0digits() -> String {
        let number = NSNumber(value: self)
        return formattercurrency0digits.string(from: number) ?? "$0"
    }

    func formatintstring() -> String {
        (String(Int(self)))
    }

    func formatpercent() -> String {
        (String(format: "%.2f", self) + "%")
    }

    func formatcurrency4digits() -> String {
        let number = NSNumber(value: self)
        return formattercurrency4digits.string(from: number) ?? "$0.00"
    }

    func format2digits() -> String {
        let number = NSNumber(value: self)
        return formatter2digits.string(from: number) ?? "0.00"
    }

    func formatcurrency6digits() -> String {
        let number = NSNumber(value: self)
        return formattercurrency6digits.string(from: number) ?? "$0.00"
    }
}
