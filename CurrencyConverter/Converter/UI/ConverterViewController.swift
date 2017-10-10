//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Vladimirs Matusevics on 08/10/2017.
//  Copyright © 2017 vmatusevic. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

class ConverterViewController: UIViewController {
    
    fileprivate let eventHandler: ConverterEventHandler
    
    fileprivate var keyboardHeightLayoutConstraint: Constraint?
    fileprivate var bag = DisposeBag()
    
    fileprivate lazy var loadingSpinner: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
        return activityIndicator
    }()
    
    fileprivate lazy var wrapperView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = UIColor(hex: "#0548a9")
        
        var gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        let color1 = UIColor(hex: "#af37b1").cgColor
        let color2 = UIColor(hex: "#3f5dbc").cgColor
        let color3 = UIColor.clear.cgColor
        let color4 = UIColor(white: 0.0, alpha: 0.7).cgColor
        gradientLayer.colors = [color1, color2, color3, color4]
        gradientLayer.locations = [0.0, 0.25, 0.75, 1.0]
        
        view.layer.addSublayer(gradientLayer)
        
        return view
    }()
    
    private lazy var controlsView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var rateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .subheadline), size: 0)
        label.textColor = .white
        return label
    }()
    
    fileprivate lazy var exchangeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("Exchange", for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(exchange(_:)), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.8), for: .highlighted)
        button.setTitleColor(UIColor.white.withAlphaComponent(0.2), for: .disabled)
        return button
    }()
    
    fileprivate lazy var exchangerWrapperView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    fileprivate lazy var exchangFromView: ExchangeView = {
        let view = ExchangeView()
        view.backgroundColor = .clear
        return view
    }()
    
    fileprivate lazy var exchangToView: ExchangeView = {
        let view = ExchangeView()
        view.backgroundColor = .clear
        return view
    }()
    
    init(eventHandler: ConverterEventHandler) {
        self.eventHandler = eventHandler
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardNotification(notification:)),
            name: NSNotification.Name.UIKeyboardWillChangeFrame,
            object: nil
        )
        
        self.addSubviews()
        self.eventHandler.viewDidLoad()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func addSubviews() {
        self.view.addSubview(self.loadingSpinner)
        self.view.addSubview(self.wrapperView)
        self.wrapperView.addSubview(self.controlsView)
        self.controlsView.addSubview(self.rateLabel)
        self.controlsView.addSubview(self.exchangeButton)
        self.wrapperView.addSubview(self.exchangerWrapperView)
        self.exchangerWrapperView.addSubview(self.exchangFromView)
        self.exchangerWrapperView.addSubview(self.exchangToView)
    }
    
    private var hasUpdatedConstraints = false
    override func updateViewConstraints() {
        if !self.hasUpdatedConstraints {
            
            self.loadingSpinner.snp.makeConstraints({ (make) in
                make.center.equalToSuperview()
            })
            
            self.wrapperView.snp.makeConstraints({ (make) in
                make.top.left.right.equalToSuperview()
                self.keyboardHeightLayoutConstraint = make.bottom.equalToSuperview().constraint
            })
            
            self.controlsView.snp.makeConstraints({ (make) in
                make.top.left.right.equalToSuperview()
                make.height.equalTo(60)
            })
            
            self.rateLabel.snp.makeConstraints({ (make) in
                make.bottom.centerX.equalToSuperview()
            })
            
            self.exchangeButton.snp.makeConstraints({ (make) in
                make.bottom.equalToSuperview()
                make.right.equalToSuperview().offset(-5)
            })
            
            self.exchangerWrapperView.snp.makeConstraints({ (make) in
                make.bottom.left.right.equalToSuperview()
                make.top.equalTo(self.controlsView.snp.bottom)
            })
            
            self.exchangFromView.snp.makeConstraints({ (make) in
                make.top.left.right.equalToSuperview()
            })
            
            self.exchangToView.snp.makeConstraints({ (make) in
                make.bottom.left.right.equalToSuperview()
                make.top.equalTo(self.exchangFromView.snp.bottom)
                make.height.equalTo(self.exchangFromView)
            })
            
            self.hasUpdatedConstraints = true
        }
        super.updateViewConstraints()
    }
    
    @objc private func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                self.keyboardHeightLayoutConstraint?.update(inset: 0)
            } else {
                self.keyboardHeightLayoutConstraint?.update(inset: endFrame?.size.height ?? 0)
            }
            UIView.performWithoutAnimation {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func exchange(_ sender: UIButton?) {
        self.eventHandler.exchange()
    }
}

extension ConverterViewController: ConverterView {
    
    func displayLoading() {
        self.wrapperView.isHidden = true
        self.loadingSpinner.startAnimating()
    }
    
    func update(exchangeActionsEventHandler: ExchangeActionsEventHandler) {
        self.exchangFromView.update(exchangeActionsEventHandler: exchangeActionsEventHandler)
        self.exchangToView.update(exchangeActionsEventHandler: exchangeActionsEventHandler)
    }
    
    func display(status: Observable<([[RatesDisplayable]], Double)>) {
        status.observeOn(MainScheduler.instance)
            .do(onNext: { [unowned self] (rates, currentRate) in
                guard let arr = rates.first, arr.count > 1 else { return }
                
                self.wrapperView.isHidden = false
                self.loadingSpinner.stopAnimating()
                
                guard let ratesDisplayable = arr.first(where: { $0.isActive() }) else { return }
                self.exchangeButton.isEnabled = ratesDisplayable.exchangeEnabled()
                self.rateLabel.text = String(format: "%.4f", currentRate)
            })
            .subscribe(onNext: { (rates, _) in
                self.exchangFromView.updateCell(with: rates[0])
                self.exchangToView.updateCell(with: rates[1])
            }).addDisposableTo(self.bag)
    }
}
