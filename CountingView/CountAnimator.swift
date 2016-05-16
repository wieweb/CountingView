//
//  CountAnimator.swift
//  CountingViews
//
//  Created by Stefan Wieland on 24/04/16.
//  Copyright © 2016 Stefan Wieland - WielandWeb. All rights reserved.
//

import Foundation

public class CountAnimator {
    
    private let startingValue: Double
    private let destinationValue: Double
    private let duration: NSTimeInterval
    private let updateMethod: CountAnimatorMethod
    
    private var timer: CADisplayLink? = nil
    private var progressValue: Double = 0
    private var lastUpdate: NSTimeInterval = 0
    
    private var completion: (() -> ())? = nil
    private var progress: ((value: Double) -> ())!
    
    public init(startValue: Double = 0.0, destinationValue: Double, duration: NSTimeInterval, method: CountAnimatorMethod = .Linear) {
        self.startingValue = startValue
        self.destinationValue = destinationValue
        self.duration = duration
        self.updateMethod = method
    }
    
    public func startCount(progress: (value: Double) -> (), completion: (() -> ())? = nil) {
        
        self.progress = progress
        self.completion = completion
        
        // remove any old timers
        if let timer = self.timer {
            timer.invalidate()
            self.timer = nil
        }
        
        if progressValue >= duration {
            // No animation
            progress(value: destinationValue)
            if let completion = completion {
                completion()
            }
            return
        }
        
        progressValue = 0
        lastUpdate = NSDate.timeIntervalSinceReferenceDate()
        
        let timer: CADisplayLink = CADisplayLink(target: self, selector: #selector(CountAnimator.updateProgress))
        
        timer.frameInterval = 2;
        timer.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        timer.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: UITrackingRunLoopMode)
        self.timer = timer;
        
    }
    
    @objc public func updateProgress() {
        
        // update progress
        let now: NSTimeInterval = NSDate.timeIntervalSinceReferenceDate()
        progressValue += now - lastUpdate;
        lastUpdate = now
        
        progress(value: currentValue(progressValue, duration: duration, start: startingValue, destination: destinationValue, method: updateMethod))
        
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
    
    private func currentValue(progress: Double, duration: NSTimeInterval, start: Double, destination: Double, method: CountAnimatorMethod) -> Double {
        if (progress >= duration) {
            return destination
        }
        let percent = progress / duration
        
        let updateVal = method.update(percent, rate: 3.0)
        
        return start + (updateVal * (destination - start))
    }
    
    
}

public enum CountAnimatorMethod {
    
    case Linear
    case EaseIn
    case EaseOut
    case EaseInOut
    
    private func update(value: Double, rate: Float) -> Double {
        switch self {
        case .Linear:
            return value
        case .EaseIn:
            return Double(powf(Float(value), rate))
        case .EaseOut:
            return Double(1.0 - powf((1.0 - Float(value)), rate))
        case .EaseInOut:
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
