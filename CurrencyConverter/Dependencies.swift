//
//  Dependencies.swift
//  CurrencyConverter
//
//  Created by Vladimirs Matusevics on 03/10/2017.
//  Copyright © 2017 vmatusevic. All rights reserved.
//

import UIKit
import Swinject

protocol DependencyFetcher {
    var converterDisplayable: ConverterDisplayable { get }
    var exchangeRateFetcher: ExchangeRateFetcher { get }
    var moneyProvider: MoneyProvider { get }
}

class DependencyResolver: DependencyFetcher {
    
    fileprivate var container: Container
    
    init() {
        self.container = Container()
    }
    
    var converterDisplayable: ConverterDisplayable {
        return self.container.resolve(ConverterDisplayable.self)!
    }
    
    var exchangeRateFetcher: ExchangeRateFetcher {
        return self.container.resolve(ExchangeRateFetcher.self)!
    }
    
    var moneyProvider: MoneyProvider {
        return self.container.resolve(MoneyProvider.self)!
    }
}

class Dependencies {
    
    class func createContainers() -> DependencyFetcher {
        
        let dependencies = DependencyResolver()
        
        dependencies.container.register(ConverterDisplayable.self) { _ in
            ConverterWireframe(with: dependencies)
        }
        
        dependencies.container.register(ExchangeRateFetcher.self) { _ in
            ExchangeRateService()
        }.inObjectScope(.container)
        
        dependencies.container.register(MoneyProvider.self) { _ in
            MoneyService()
        }.inObjectScope(.container)
        
        return dependencies
    }
    
}
