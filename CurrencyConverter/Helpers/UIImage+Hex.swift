//
//  UIImage+Hex.swift
//  CurrencyConverter
//
//  Created by Vladimirs Matusevics on 09/10/2017.
//  Copyright © 2017 vmatusevic. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hex hexString: String) {
        let r, g, b: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            let hexColor = String(hexString.suffix(from: start))
            
            if hexColor.characters.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat((hexNumber & 0x0000ff) >> 0) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: 1.0)
                    return
                }
            }
        }
        
        self.init(red: 0, green: 0, blue: 0, alpha: 1.0)
        return
    }
}
