//
//  DataFormatter.swift
//  OnlabCryptoApp
//
//  Created by Kosztolánczi Dominik on 2022. 02. 26..
//

import Foundation

extension Double {
    
    private var formattercurrency6digits: NumberFormatter{
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        return formatter
    }
    func formatcurrency6digits() -> String {
        let number = NSNumber(value: self)
        return formattercurrency6digits.string(from: number) ?? "$0.00"

    }
    
    private var formattercurrency4digits: NumberFormatter{
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 4
        return formatter
    }
    func formatcurrency4digits() -> String {
        let number = NSNumber(value: self)
        return formattercurrency4digits.string(from: number) ?? "$0.00"
    }
    
    private var formattercurrency0digits: NumberFormatter{
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        return formatter
    }
    func formatcurrency0digits() -> String {
        let number = NSNumber(value: self)
        return formattercurrency0digits.string(from: number) ?? "$0"
    }
    
    func formatintstring() -> String{
        return (String(Int(self)))
    }
    
    func formatpercent() -> String {
        return (String(format: "%.2f", self) + "%")
    }
    
    private var formatter2digits: NumberFormatter{
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter
    }
    func format2digits() -> String {
        let number = NSNumber(value: self)
        return formatter2digits.string(from: number) ?? "0.00"
    }

}
