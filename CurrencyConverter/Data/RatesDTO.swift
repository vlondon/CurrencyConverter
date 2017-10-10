//
//  RatesDTO.swift
//  CurrencyConverter
//
//  Created by Vladimirs Matusevics on 08/10/2017.
//  Copyright © 2017 vmatusevic. All rights reserved.
//

import Foundation
import EVReflection

typealias Rates = [RateDTO]

enum MyValidationError: Error {
    case TypeError,
    ConvertingFailed
}

final class RateDTO: EVObject {
    var currency: Currency?
    var rate: Double?
    
    override public func setValue(_ value: Any!, forUndefinedKey key: String) {
        if key == "_rate", let value = value as? String {
            rate = Double(value)
        } else if key == "_currency", let value = value as? String {
            currency = Currency(rawValue: value)
        }
    }
}

final class CubeDTO: EVObject {
    var Cube: [RateDTO]?
    var time: String?
    
    override public func setValue(_ value: Any!, forUndefinedKey key: String) {
        if key == "Cube",  let value = value as? [RateDTO] {
            Cube = value
        }
    }
}

final class CubeTimedDTO: EVObject {
    var Cube: CubeDTO?
    
    override public func setValue(_ value: Any!, forUndefinedKey key: String) {
        if key == "Cube", let value = value as? CubeDTO {
            self.Cube = value
        }
    }
}

final class RatesDTO: EVObject {
    private var Cube: CubeTimedDTO?
    
    override public func setValue(_ value: Any!, forUndefinedKey key: String) {
        if key == "Cube", let value = value as? CubeTimedDTO {
            Cube = value
        }
    }
    
    func getRates() -> [RateDTO]? {
        return self.Cube?.Cube?.Cube
    }
    
}
