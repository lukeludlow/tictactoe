//
//  Cell.swift
//  tictactoe
//
//  Created by luke ludlow on 2020-11-27.
//

import Foundation

struct Cell: Identifiable, Hashable {
    var id = UUID()
    var row: Int
    var col: Int
    var value: XO
    
    init(row: Int, col: Int, value: XO) {
        self.row = row
        self.col = col
        self.value = value
    }
    
    static func == (lhs: Cell, rhs: Cell) -> Bool {
        return lhs.id == rhs.id && lhs.row == rhs.row && lhs.col == rhs.col && lhs.value == rhs.value
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(row)
        hasher.combine(col)
        hasher.combine(value)
    }
}
