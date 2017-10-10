//
//  ConverterInteractor.swift
//  CurrencyConverter
//
//  Created by Vladimirs Matusevics on 08/10/2017.
//  Copyright © 2017 vmatusevic. All rights reserved.
//

import Foundation
import RxSwift

typealias RatesMoneyInfo = (rates: Rates, money: Money)


class ConverterInteractor {
    
    weak var output: ConverterInteractorOutput?
    
    private var exchangeRateFetcher: ExchangeRateFetcher
    private var moneyProvider: MoneyProvider
    
    init(exchangeRateFetcher: ExchangeRateFetcher, moneyProvider: MoneyProvider) {
        self.exchangeRateFetcher = exchangeRateFetcher
        self.moneyProvider = moneyProvider
    }
    
    fileprivate func getRates() {
        self.output?.didRequestRates()
        
        let timerObservable = Observable<Int>.interval(30, scheduler: MainScheduler.instance).startWith(0)
        let ratesObservable = self.exchangeRateFetcher.getRates()
            
        let statusObservable = Observable.combineLatest(ratesObservable, timerObservable)
            .flatMap({ [unowned self] (rates, timer) -> Observable<RatesMoneyInfo> in
                self.moneyProvider.getMoney().flatMap({ (money) -> Observable<RatesMoneyInfo> in
                    .just((rates, money))
                })
            })
        
        self.output?.didReceive(status: statusObservable)
    }
    
}

extension ConverterInteractor: ConverterInteractorInput {
    
    func moduleDidLoad() {
        self.getRates()
    }
    
    func exchangeRequested(from: ExchangeMoney, to: ExchangeMoney) {
        let exchangeRequest = ExchangeRequest(from: from.currency, to: to.currency, value: from.value, rateFrom: from.rate, rateTo: to.rate)
        self.moneyProvider.process(request: exchangeRequest)
    }
    
}
