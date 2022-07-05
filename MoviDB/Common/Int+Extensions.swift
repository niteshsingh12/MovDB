//
//  Int+Extensions.swift
//  MoviDB
//
//  Created by Nitesh Singh on 01/07/22.
//

import Foundation

extension Int {
    
    var runTimeString: String {
        return "\(self / 60)h \(self % 60)m"
    }
    
    var currency: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        let number = NSNumber(value: self)
        return formatter.string(from: number)!
    }
    
    func currencyInUSD() -> String {
        let numFormatter = NumberFormatter()
        
        typealias Abbrevation = (threshold:Double, divisor:Double, suffix:String)
        let abbreviations:[Abbrevation] = [(0, 1, ""),
                                           (100_000.0, 100_000.0, "K"),
                                           (1_000_000.0, 1_000_000.0, "M"),
                                           (1_000_000_000.0, 1_000_000_000.0, "B")]
        
        let startValue = Double (abs(self))
        let abbreviation:Abbrevation = {
            var prevAbbreviation = abbreviations[0]
            for tmpAbbreviation in abbreviations {
                if (startValue < tmpAbbreviation.threshold) {
                    break
                }
                prevAbbreviation = tmpAbbreviation
            }
            return prevAbbreviation
        } ()
        
        let value = Double(self) / abbreviation.divisor
        numFormatter.positiveSuffix = abbreviation.suffix
        numFormatter.negativeSuffix = abbreviation.suffix
        numFormatter.allowsFloats = true
        numFormatter.minimumIntegerDigits = 1
        numFormatter.minimumFractionDigits = 0
        numFormatter.maximumFractionDigits = 1
        
        return "$" + numFormatter.string(from: NSNumber (value:value))!
    }
    
}
