//
//  LoadView.swift
//  
//
//  Created by Vitaliy Stepanenko on 04.08.2021.
//

import UIKit

class LoadingView: UIView {
    fileprivate var currentLoadingValue = 0
    fileprivate weak var activityIndicatorView: UIActivityIndicatorView? = nil
    
    func showLoading(color: UIColor = .black) {
        currentLoadingValue += 1
        if activityIndicatorView == nil {
            addActivityIndicatorView(color: color)
        }
        activityIndicatorView?.color = color
        if activityIndicatorView != nil {
            self.bringSubviewToFront(activityIndicatorView!)
        }
    }
    
    func hideLoading() {
        currentLoadingValue -= 1
        if currentLoadingValue <= 0 {
            removeActivityIndicatorView()
        }
    }
    
    private func addActivityIndicatorView(color: UIColor) {
        let indicatorView = UIActivityIndicatorView(style: .medium)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.color = color
        self.addSubview(indicatorView)
        NSLayoutConstraint(item: indicatorView, attribute: .centerX, relatedBy: .equal, toItem: indicatorView.superview, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: indicatorView, attribute: .centerY, relatedBy: .equal, toItem: indicatorView.superview, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true
        indicatorView.startAnimating()
        self.activityIndicatorView = indicatorView
    }
    
    private func removeActivityIndicatorView() {
        activityIndicatorView?.stopAnimating()
        activityIndicatorView?.removeFromSuperview()
        activityIndicatorView = nil
        currentLoadingValue = 0
    }
}
