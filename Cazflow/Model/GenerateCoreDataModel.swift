//
//  GenerateBudget.swift
//  Cazflow
//
//  Created by Darindra R on 04/05/21.
//

import Foundation

struct GenerateBudget {
    var name: String
    var limit: Int64
    var budgetDescription: String
    var budget: Int64
    var balance: Int64
}

struct GenerateCashflow {
    var type: String
    var source: String?
    var note: String
    var nominal: Int64
    var image: String
    var date: Date

    init(type: String, note: String, nominal: Int64, image: String, date: Date, source: String? = nil) {
        self.type = type
        self.source = source
        self.note = note
        self.nominal = nominal
        self.image = image
        self.date = date
    }
}

struct GenerateUser {
    var balance: Int64
    var income: Int64
    var expense: Int64
}
