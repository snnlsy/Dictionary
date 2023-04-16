//
//  DataContainer.swift
//  Dictionary
//
//  Created by Sinan Ulusoy on 26.03.2023.
//

import Foundation

struct DataContainer<Element> {
    
    private var array: [Element] = []

    var limit: Int?

    var isEmpty: Bool {
        return array.isEmpty
    }

    var count: Int {
        return array.count
    }

    func getArray() -> [Element] {
        return array
    }
    
    mutating func push(_ element: Element) {
        if let limit = self.limit {
            if self.count >= limit {
                _ = self.pop()
            }
        }
        array.insert(element, at: 0)
    }
    
    mutating func append(_ elementArray: [Element]) {
        for element in elementArray {
            self.push(element)
        }
    }

    mutating func pop() -> Element? {
        return array.popLast()
    }
}
