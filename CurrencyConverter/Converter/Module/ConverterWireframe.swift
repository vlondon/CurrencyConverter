//
//  ConverterWireframe.swift
//  CurrencyConverter
//
//  Created by Vladimirs Matusevics on 08/10/2017.
//  Copyright © 2017 vmatusevic. All rights reserved.
//

import UIKit

class ConverterWireframe: ConverterDisplayable {
    
    let exchangeRateFetcher: ExchangeRateFetcher
    let moneyProvider: MoneyProvider
    
    init(with dependencies: DependencyFetcher) {
        self.exchangeRateFetcher = dependencies.exchangeRateFetcher
        self.moneyProvider = dependencies.moneyProvider
    }
    
    func display(in window: UIWindow) {
        
        let interactor = ConverterInteractor(
            exchangeRateFetcher: exchangeRateFetcher,
            moneyProvider: moneyProvider
        )
        
        let presenter = ConverterPresenter(interactorInput: interactor)
        interactor.output = presenter
        
        let converterViewController = ConverterViewController(eventHandler: presenter)
        presenter.view = converterViewController
        
        window.rootViewController = converterViewController
    }
    
}
