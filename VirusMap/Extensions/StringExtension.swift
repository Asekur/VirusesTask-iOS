//
//  StringExtension.swift
//  VirusMap
//
//  Created by Angelina Rusinovich on 6.02.21.
//

import Foundation

extension String {
    func concatWithSeparator(value: String?, separator: String) -> String {
        guard let secondString = value else { return self }
        return self + separator + secondString
    }
    
    func lengthGreater(than len: Int) -> Bool {
        return self.count > len
    }
}
