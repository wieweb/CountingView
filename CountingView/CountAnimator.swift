//
//  CountAnimator.swift
//  CountingViews
//
//  Created by Stefan Wieland on 24/04/16.
//  Copyright © 2016 Stefan Wieland - WielandWeb. All rights reserved.
//

import Foundation

open class CountAnimator {
    
    fileprivate let startingValue: Double
    fileprivate let destinationValue: Double
    fileprivate let duration: TimeInterval
    fileprivate let updateMethod: CountAnimatorMethod
    
    fileprivate var timer: CADisplayLink? = nil
    fileprivate var progressValue: Double = 0
    fileprivate var lastUpdate: TimeInterval = 0
    
    fileprivate var completion: (() -> ())? = nil
    fileprivate var progress: ((_ value: Double) -> ())!
    
    public init(startValue: Double = 0.0, destinationValue: Double, duration: TimeInterval, method: CountAnimatorMethod = .linear) {
        self.startingValue = startValue
        self.destinationValue = destinationValue
        self.duration = duration
        self.updateMethod = method
    }
    
    open func startCount(_ progress: @escaping (_ value: Double) -> (), completion: (() -> ())? = nil) {
        
        self.progress = progress
        self.completion = completion
        
        // remove any old timers
        if let timer = self.timer {
            timer.invalidate()
            self.timer = nil
        }
        
        if progressValue >= duration {
            // No animation
            progress(destinationValue)
            if let completion = completion {
                completion()
            }
            return
        }
        
        progressValue = 0
        lastUpdate = Date.timeIntervalSinceReferenceDate
        
        let timer: CADisplayLink = CADisplayLink(target: self, selector: #selector(CountAnimator.updateProgress))
        
        timer.frameInterval = 2;
        timer.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
        timer.add(to: RunLoop.main, forMode: RunLoopMode.UITrackingRunLoopMode)
        self.timer = timer;
        
    }
    
    @objc open func updateProgress() {
        
        // update progress
        let now: TimeInterval = Date.timeIntervalSinceReferenceDate
        progressValue += now - lastUpdate;
        lastUpdate = now
        
        progress(currentValue(progressValue, duration: duration, start: startingValue, destination: destinationValue, method: updateMethod))
        
        if progressValue >= duration {
            progressValue = duration
            if let timer = self.timer {
                timer.invalidate()
                self.timer = nil
            }
        }
        
        if (progressValue == duration) {
            completion?()
        }
    }
    
    fileprivate func currentValue(_ progress: Double, duration: TimeInterval, start: Double, destination: Double, method: CountAnimatorMethod) -> Double {
        if (progress >= duration) {
            return destination
        }
        let percent = progress / duration
        
        let updateVal = method.update(percent, rate: 3.0)
        
        return start + (updateVal * (destination - start))
    }
    
    
}

public enum CountAnimatorMethod {
    
    case linear
    case easeIn
    case easeOut
    case easeInOut
    
    fileprivate func update(_ value: Double, rate: Float) -> Double {
        switch self {
        case .linear:
            return value
        case .easeIn:
            return Double(powf(Float(value), rate))
        case .easeOut:
            return Double(1.0 - powf((1.0 - Float(value)), rate))
        case .easeInOut:
            var sign: Int = 1
            let r: Int = Int(rate)
            if r % 2 == 0 {
                sign = -1
            }
            let newValue = value * 2
            if newValue < 1 {
                return Double(0.5 * powf(Float(newValue), rate))
            } else {
                let pow = powf(Float(newValue - 2), rate)
                return Double(Float(sign) * 0.5 * (pow + Float(sign) * 2.0))
            }
        }
    }
    
}
