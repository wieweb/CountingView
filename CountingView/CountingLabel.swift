//
//  CountingLabel.swift
//  CountingViews
//
//  Created by Stefan Wieland on 24/04/16.
//  Copyright © 2016 Stefan Wieland - WielandWeb. All rights reserved.
//

import UIKit

open class CountingLabel: UILabel {
    
    open var numberFormatter: NumberFormatter = NumberFormatter()
    open var format: String = "%@"
    open var currentValue: Double = 0.0
    
    open func startCounting(_ startValue: Double = 0, destinationValue: Double, duration: TimeInterval = 1.0, method: CountAnimatorMethod = .linear, progress: ((Double) -> ())? = nil, completion: (() -> ())? = nil) {
        
        currentValue = startValue
        let animator = CountAnimator(startValue: startValue, destinationValue: destinationValue, duration: duration, method: method)
        animator.startCount({ value in
            if let formatedValue = self.numberFormatter.string(for: value) {
                self.text = String.localizedStringWithFormat(self.format, formatedValue)
                self.currentValue = value
                if let progress = progress {
                    progress(value)
                }
            }
        }, completion: {
            self.currentValue = destinationValue
            if let completion = completion {
                completion()
            }
        })
    }
    
}
