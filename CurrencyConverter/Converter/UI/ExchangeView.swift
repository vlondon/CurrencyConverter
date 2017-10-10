//
//  ExchangeViewCell.swift
//  CurrencyConverter
//
//  Created by Vladimirs Matusevics on 08/10/2017.
//  Copyright © 2017 vmatusevic. All rights reserved.
//

import UIKit
import SnapKit

class ExchangeView: UIView {
    
    private var scrollView: ScrollView = {
        let view = ScrollView()
        view.backgroundColor = .clear
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.addSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var hasUpdatedConstraints = false
    override func updateConstraints() {
        if !self.hasUpdatedConstraints {

            self.scrollView.snp.makeConstraints({ (make) in
                make.edges.equalToSuperview()
            })
            
            self.hasUpdatedConstraints = true
        }
        super.updateConstraints()
    }
    
    private func addSubviews() {
        self.addSubview(self.scrollView)
    }
    
    func update(exchangeActionsEventHandler: ExchangeActionsEventHandler) {
        self.scrollView.eventHandler = exchangeActionsEventHandler
    }
    
    func updateCell(with rates: [RatesDisplayable]) {
        self.scrollView.data = rates
    }
    
}
