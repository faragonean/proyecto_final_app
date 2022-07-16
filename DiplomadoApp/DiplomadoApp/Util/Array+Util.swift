//
//  Array+Util.swift
//  DiplomadoApp
//
//  Created by Felipe Aragon on 13/07/22.
//

import Foundation

extension Collection where Indices.Iterator.Element == Index {

    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension NSSet {
  func toArray<T>() -> [T] {
    let array = self.map({ $0 as! T})
    return array
  }
}
