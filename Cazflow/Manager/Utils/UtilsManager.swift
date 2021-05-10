//
//  GroupBy.swift
//  Cazflow
//
//  Created by Darindra R on 08/05/21.
//

import Foundation
import CoreData

class Utils {
    static var shared = Utils()
    private init() { }

    func formatRupiah(_ nominal: Int64) -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "id_ID")
        formatter.groupingSeparator = "."
        formatter.numberStyle = .decimal
        guard let formattedTipAmount = formatter.string(from: nominal as NSNumber) else { return "" }

        return "Rp " + formattedTipAmount
    }
}
