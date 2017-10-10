//
//  ExchangeRateService.swift
//  CurrencyConverter
//
//  Created by Vladimirs Matusevics on 08/10/2017.
//  Copyright © 2017 vmatusevic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import EVReflection

class ExchangeRateService {
    fileprivate let session = URLSession.shared
}

extension ExchangeRateService: ExchangeRateFetcher {
    
    func getRates() -> Observable<Rates> {
        
        guard let url = URL(string: "http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml") else {
            fatalError("Should be able to create url")
        }
        let request = URLRequest(url: url)
        
        let fetchObservable = self.session.rx.data(request: request)
            .flatMap({ (data) -> Observable<Rates> in
                let eurRate = RateDTO()
                eurRate.currency = .EUR
                eurRate.rate = 1
                let rates: Rates = [eurRate]
                
                let ratesAll = rates + (RatesDTO(xmlData: data)?.getRates() ?? []).filter({ (rate) -> Bool in
                    return rate.currency != nil && rate.rate != nil
                })
                
                return .just(ratesAll)
            })
        
        return fetchObservable
    }
    
}
