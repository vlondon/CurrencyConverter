//
//  ScrollViewCell.swift
//  CurrencyConverter
//
//  Created by Vladimirs Matusevics on 08/10/2017.
//  Copyright © 2017 vmatusevic. All rights reserved.
//

import UIKit
import VMScrollView

class ScrollViewCell: UICollectionViewCell {
    
    var data: RatesDisplayable?
    private var subviewsDidLayout = false
    
    private lazy var currencyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .title1), size: 0)
        label.textColor = .white
        return label
    }()
    
    private lazy var moneyAvailableLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .body), size: 0)
        label.textColor = .white
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.keyboardType = .decimalPad
        textField.backgroundColor = .clear
        textField.textColor = .white
        textField.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .title2), size: 0)
        textField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .clear
        
        self.addSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        contentView.frame = bounds
        
        if !self.subviewsDidLayout {
            
            self.currencyLabel.snp.makeConstraints({ (make) in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().offset(20)
            })
            
            self.moneyAvailableLabel.snp.makeConstraints({ (make) in
                make.left.equalTo(self.currencyLabel)
                make.top.equalTo(self.currencyLabel.snp.bottom).offset(5)
            })
            
            self.textField.snp.makeConstraints({ (make) in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(-10)
                make.left.equalTo(self.currencyLabel.snp.right).offset(10)
            })
            
            self.subviewsDidLayout = true
        }
        
        super.layoutSubviews()
    }
    
    private func addSubviews() {
        self.contentView.addSubview(self.currencyLabel)
        self.contentView.addSubview(self.moneyAvailableLabel)
        self.contentView.addSubview(self.textField)
    }
    
    weak var eventHandler: ExchangeActionsEventHandler?
    func update(with data: RatesDisplayable, eventHandler: ExchangeActionsEventHandler?) {
        self.data = data
        self.eventHandler = eventHandler
        self.currencyLabel.text = data.currency.rawValue
        self.moneyAvailableLabel.text = String(format: "You have \(data.currency.getSign())%.2f", data.money)
        self.moneyAvailableLabel.textColor = data.source == .from && !data.canExchange() ? .red : .white
    }
    
    fileprivate func refreshValues() {
        guard let data = self.data else { return }
        
        if data.isActive() {
            self.textField.becomeFirstResponder()
            return
        }
        
        self.textField.text = data.getDisplayableExchangeValue()
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        guard let data = self.data else { return }
        var value = 0.0
        if let text = textField.text {
            value = Double(text) ?? 0
        }
        
        self.eventHandler?.changeActive(
            currency: data.currency,
            rate: data.rate,
            value: value / data.rate,
            source: data.source,
            isActive: true
        )
    }
    
    func activate() {
        guard let data = self.data else { return }
        
        self.eventHandler?.changeActive(
            currency: data.currency,
            rate: data.rate,
            value: data.exchange.value,
            source: data.source,
            isActive: false
        )
    }
}

extension ScrollViewCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty { return true }
        
        let currentText = textField.text ?? ""
        let replacementText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        return replacementText.isValidDouble(maxDecimalPlaces: 2)
    }
    
}

extension ScrollViewCell: VMScrollViewCell {

    func updateParallax(for contentOffsetX: CGFloat) {
        self.alpha = 1 - abs(contentOffsetX * 0.002)
    }

    func refresh() {
        self.refreshValues()
    }
}

