//
//  CountingLabel.swift
//  CountingViews
//
//  Created by Stefan Wieland on 24/04/16.
//  Copyright © 2016 Stefan Wieland - WielandWeb. All rights reserved.
//

import UIKit

public class CountingLabel: UILabel {
    
    public var numberFormatter: NSNumberFormatter = NSNumberFormatter()
    public var format: String = "%@"
    public var currentValue: Double = 0.0
    
    public func startCounting(startValue: Double = 0, destinationValue: Double, duration: NSTimeInterval = 1.0, method: CountAnimatorMethod = .Linear, progress: ((value: Double) -> ())? = nil, completion: (() -> ())? = nil) {
        
        currentValue = startValue
        let animator = CountAnimator(startValue: startValue, destinationValue: destinationValue, duration: duration, method: method)
        animator.startCount({ value in
            if let formatedValue = self.numberFormatter.stringFromNumber(value) {
                self.text = String.localizedStringWithFormat(self.format, formatedValue)
                self.currentValue = value
                if let progress = progress {
                    progress(value: value)
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
