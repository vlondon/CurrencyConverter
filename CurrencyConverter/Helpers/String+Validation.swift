//
//  String+Validation.swift
//  CurrencyConverter
//
//  Created by Vladimirs Matusevics on 09/10/2017.
//  Copyright © 2017 vmatusevic. All rights reserved.
//

import Foundation

extension String {
    
    func isValidDouble(maxDecimalPlaces: Int) -> Bool {
        let formatter = NumberFormatter()
        formatter.allowsFloats = true
        let decimalSeparator = formatter.decimalSeparator ?? "."
        
        if formatter.number(from: self) != nil {
            let split = self.components(separatedBy: decimalSeparator)
            let digits = split.count == 2 ? split.last ?? "" : ""
            return digits.count <= maxDecimalPlaces
        }
        
        return false
    }
    
}
