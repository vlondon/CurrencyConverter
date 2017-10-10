//
//  ConverterProtocols.swift
//  CurrencyConverter
//
//  Created by Vladimirs Matusevics on 08/10/2017.
//  Copyright © 2017 vmatusevic. All rights reserved.
//

import UIKit
import RxSwift

protocol ConverterDisplayable {
    func display(in window: UIWindow)
}

protocol ExchangeRateFetcher {
    func getRates() -> Observable<Rates>
}

protocol MoneyProvider {
    func getMoney() -> Observable<Money>
    func process(request: ExchangeRequest) 
}

protocol ConverterInteractorInput {
    func moduleDidLoad()
    func exchangeRequested(from: ExchangeMoney, to: ExchangeMoney)
}

protocol ConverterInteractorOutput: class {
    func didRequestRates()
    func didReceive(status: Observable<RatesMoneyInfo>)
}

protocol ConverterEventHandler {
    func viewDidLoad()
    func exchange()
}

protocol ConverterView: class {
    func displayLoading()
    func update(exchangeActionsEventHandler: ExchangeActionsEventHandler)
    func display(status: Observable<([[RatesDisplayable]], Double)>)
}

protocol ExchangeActionsEventHandler: class {
    func changeActive(currency: Currency, rate: Double, value: Double, source: ExchangeSource, isActive: Bool)
}
