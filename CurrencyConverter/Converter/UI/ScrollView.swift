//
//  ScrollView.swift
//  CurrencyConverter
//
//  Created by Vladimirs Matusevics on 08/10/2017.
//  Copyright © 2017 vmatusevic. All rights reserved.
//

import UIKit
import VMScrollView

class ScrollView: VMScrollView {
    
    weak var eventHandler: ExchangeActionsEventHandler?
    
    override func cellClass() -> UICollectionViewCell.Type {
        return ScrollViewCell.self
    }
    
    override func configureCollectionCell(_ cell: UICollectionViewCell, data: Any) -> UICollectionViewCell {
        let cell = cell as! ScrollViewCell
        
        if let data = data as? RatesDisplayable {
            cell.update(with: data, eventHandler: eventHandler)
        }
        
        return cell
    }
    
    private func activateVisibleCell() {
        var scrollViewCell: ScrollViewCell?
        self.collectionView.visibleCells.forEach({ (cell) in
            guard let cell = cell as? ScrollViewCell else { return }
            if cell.data?.page == self.pageControl.currentPage {
                scrollViewCell = cell
            }
        })
        
        scrollViewCell?.activate()
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        super.scrollViewDidEndDragging(scrollView, willDecelerate: decelerate)
        if decelerate { return }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            self.activateVisibleCell()
        }
    }

    override open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        super.scrollViewDidEndDecelerating(scrollView)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            self.activateVisibleCell()
        }
    }
    
    override open func refresh() {
        super.refresh()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            guard let cell = self.collectionView.visibleCells.first as? ScrollViewCell else { return }
            cell.activate()
        }
    }
    
}
