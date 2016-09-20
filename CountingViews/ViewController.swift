//
//  ViewController.swift
//  CountingViews
//
//  Created by Stefan Wieland on 24/04/16.
//  Copyright © 2016 Stefan Wieland - WielandWeb. All rights reserved.
//

import UIKit
import CountingView

class ViewController: UIViewController {

    @IBOutlet weak var linealLabel: CountingLabel!
    @IBOutlet weak var easeInLabel: CountingLabel!
    @IBOutlet weak var easeOutLabel: CountingLabel!
    @IBOutlet weak var easeInOutLabel: CountingLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        easeInLabel.startCounting(destinationValue: 500, duration: 0.0)
    }
    
    @IBAction func startCounting(_ sender: AnyObject) {
        
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0;
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        
        linealLabel.format = "%@ Value"
        linealLabel.numberFormatter = formatter
        linealLabel.startCounting(0,
                                  destinationValue: 1000,
                                  duration: 3,
                                  method: .linear,
                                  progress: { value in
                                    print(value)
                                    },
                                  completion: {
                                    print("complete")
        })
        
        easeInLabel.numberFormatter = formatter
        easeInLabel.startCounting(0.0, destinationValue: 1505, duration: 3.0, method: .easeIn, progress: { value in print(value) })
        
        easeOutLabel.numberFormatter = formatter
        easeOutLabel.startCounting(destinationValue: 10000, duration: 3.0, method: .easeOut)
        
        easeInOutLabel.numberFormatter = formatter
        easeInOutLabel.startCounting(10000, destinationValue: 0, duration: 3.0, method: .easeInOut)
        
    }
    
    
}

