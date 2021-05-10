//
//  String.swift
//  Cazflow
//
//  Created by Darindra R on 08/05/21.
//

import Foundation

extension String {
    func currencyInputFormatting() -> String {

        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "Rp"
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0

        var amountWithPrefix = self

        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")

        let double = (amountWithPrefix as NSString).intValue
        number = NSNumber(value: (double))
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }

        return formatter.string(from: number)!
    }

    func removeFormatAmount() -> Int64 {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "Rp"
        formatter.decimalSeparator = ","

        return formatter.number(from: self)!.int64Value
    }
}
