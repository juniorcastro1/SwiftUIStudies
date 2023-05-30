//
//  ExpenseItem.swift
//  iExpense
//
//  Created by user on 09/03/23.
//

import Foundation

//Creates an item with an value
struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}
