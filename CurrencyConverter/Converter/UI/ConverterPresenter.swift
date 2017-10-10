//
//  ConverterPresenter.swift
//  CurrencyConverter
//
//  Created by Vladimirs Matusevics on 08/10/2017.
//  Copyright © 2017 vmatusevic. All rights reserved.
//

import Foundation
import RxSwift

typealias ExchangeMoney = (
    currency: Currency,
    value: Double,
    rate: Double,
    source: ExchangeSource,
    active: Bool
)

struct RatesDisplayable {
    let page: Int
    let currency: Currency
    let rate: Double
    let money: Double
    let source: ExchangeSource
    let exchange: ExchangeMoney
    
    func isActive() -> Bool {
        return source == exchange.source && self.currency == exchange.currency && exchange.active
    }
    
    func canExchange() -> Bool {
        return self.money >= self.exchange.value * self.exchange.rate
    }
    
    func exchangeEnabled() -> Bool {
        return self.exchange.value > 0 && self.canExchange()
    }
    
    func getDisplayableExchangeValue() -> String {
        let value = self.exchange.value * self.rate
        return String(format: "%.2f", value)
    }
}

enum ExchangeSource {
    case from
    case to
}

class ConverterPresenter {
    
    weak var view: ConverterView?
    
    fileprivate var interactorInput: ConverterInteractorInput
    
    fileprivate var exchangeValue: (from: Variable<ExchangeMoney>, to: Variable<ExchangeMoney>) = (
        Variable<ExchangeMoney>((.EUR, 0, 1, .from, true)),
        Variable<ExchangeMoney>((.EUR, 0, 1, .to, false))
    )
    
    init(interactorInput: ConverterInteractorInput) {
        self.interactorInput = interactorInput
    }
    
    fileprivate func getRates(from info: RatesMoneyInfo, source: ExchangeSource, exchangeValue: ExchangeMoney) -> [RatesDisplayable] {
        var page = -1
        return info.rates.flatMap({ (rateDTO) in
            guard let currency = rateDTO.currency,
                let rate = rateDTO.rate,
                let money = info.money[currency] else {
                    return nil
            }
            
            page += 1
            return RatesDisplayable(
                page: page,
                currency: currency,
                rate: rate,
                money: money,
                source: source,
                exchange: (
                    currency: exchangeValue.currency,
                    value: exchangeValue.value,
                    rate: exchangeValue.rate,
                    source: exchangeValue.source,
                    active: exchangeValue.active
                )
            )
        })
    }
    
}

extension ConverterPresenter: ConverterInteractorOutput {
    
    func didRequestRates() {
        self.view?.displayLoading()
    }
    
    func didReceive(status: Observable<RatesMoneyInfo>) {
        let valuesObservable = Observable.zip(self.exchangeValue.from.asObservable(), self.exchangeValue.to.asObservable())
        let statusRates = Observable
            .combineLatest(status, valuesObservable) { ($0, $1) }
            .flatMap({ [unowned self] (info, exchangeValues) -> Observable<([[RatesDisplayable]], Double)> in
                let (exchangeValueFrom, exchangeValueTo) = exchangeValues
                let exchangeValue = exchangeValueTo.active ? exchangeValueTo : exchangeValueFrom
                let ratesFrom = self.getRates(from: info, source: .from, exchangeValue: exchangeValue)
                let ratesTo = self.getRates(from: info, source: .to, exchangeValue: exchangeValue)
                let currentRate = 1 / exchangeValueFrom.rate * exchangeValueTo.rate
                return .just(([ratesFrom, ratesTo], currentRate))
            })
        
        self.view?.display(status: statusRates)
    }
    
}

extension ConverterPresenter: ConverterEventHandler {
    
    func viewDidLoad() {
        self.interactorInput.moduleDidLoad()
        self.view?.update(exchangeActionsEventHandler: self)
    }
    
    func exchange() {
        self.interactorInput.exchangeRequested(from: exchangeValue.from.value, to: exchangeValue.to.value)
    }
    
}

extension ConverterPresenter: ExchangeActionsEventHandler {
    
    func changeActive(currency: Currency, rate: Double, value: Double, source: ExchangeSource, isActive: Bool) {
        switch source {
        case .from:
            let active = self.exchangeValue.from.value.active || isActive
            self.exchangeValue.from.value = (
                currency: currency,
                value: value,
                rate: rate,
                source: source,
                active: active)
            
            var valueTo = self.exchangeValue.to.value
            if active {
                valueTo.active = false
                valueTo.value = value * valueTo.rate
            }
            self.exchangeValue.to.value = valueTo
            
        case .to:
            let active = self.exchangeValue.to.value.active || isActive
            self.exchangeValue.to.value = (
                currency: currency,
                value: value,
                rate: rate,
                source: source,
                active: active)
            
            var valueFrom = self.exchangeValue.from.value
            if active {
                valueFrom.active = false
                valueFrom.value = value * valueFrom.rate
            }
            self.exchangeValue.from.value = valueFrom
        }
    }
    
}
