//
//  Cell.swift
//  tictactoe
//
//  Created by luke ludlow on 2020-11-27.
//

import Foundation
import FirebaseDatabase

struct Cell: Identifiable, Hashable {
    var ref: DatabaseReference?
    var id = UUID()
    var row: Int
    var col: Int
    var value: XO
    
    init(row: Int, col: Int, value: XO) {
        self.row = row
        self.col = col
        self.value = value
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let row = value["row"] as? Int,
            let col = value["col"] as? Int,
            let cellValue = XO(rawValue: value["value"] as! String)
            else {
                return nil
            }
        self.ref = snapshot.ref
        self.row = row
        self.col = col
        self.value = cellValue
    }
    
    init?(anyObject: AnyObject) {
        guard
            let row = anyObject["row"] as? Int,
            let col = anyObject["col"] as? Int,
            let value = XO(rawValue: anyObject["value"] as! String)
            else {
                return nil
            }
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
    
    func toAnyObject() -> Any {
        return [
            "row": row,
            "col": col,
            "value": value.rawValue
        ]
    }
}
