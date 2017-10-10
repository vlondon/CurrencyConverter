//
//  MoneyService.swift
//  CurrencyConverter
//
//  Created by Vladimirs Matusevics on 08/10/2017.
//  Copyright © 2017 vmatusevic. All rights reserved.
//

import Foundation
import RxSwift

enum Currency: String {
    case EUR
    case USD
    case GBP
    
    func getSign() -> String {
        switch self {
        case .EUR:
            return "€"
        case .USD:
            return "$"
        case .GBP:
            return "£"
        }
    }
}

typealias Money = [Currency: Double]

struct ExchangeRequest {
    let from: Currency
    let to: Currency
    let value: Double
    let rateFrom: Double
    let rateTo: Double
}

class MoneyService {
    
    fileprivate var money = Variable<[Currency: Double]>([:])
    
    init() {
        self.money.value = [
            .EUR: 100,
            .USD: 100,
            .GBP: 100
        ]
    }
    
    fileprivate func increase(value: Double, for currency: Currency) {
        guard let currentValue = self.money.value[currency] else { return }
        let newValue = currentValue + value
        self.money.value[currency] = newValue
    }
    
    fileprivate func decrease(value: Double, for currency: Currency) {
        guard let currentValue = self.money.value[currency] else { return }
        let newValue = currentValue - value
        self.money.value[currency] = newValue
    }
    
}

extension MoneyService: MoneyProvider {
    
    func getMoney() -> Observable<Money> {
        return self.money.asObservable()
    }
    
    func process(request: ExchangeRequest) {
        let increaseValue = request.value * request.rateTo
        let decreaseValue = request.value * request.rateFrom
        
        self.increase(value: increaseValue, for: request.to)
        self.decrease(value: decreaseValue, for: request.from)
    }
    
}
