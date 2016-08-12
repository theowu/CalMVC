//
//  ViewController.swift
//  CalMVC
//
//  Created by Theo WU on 14/07/2016.
//  Copyright © 2016 Theo WU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    var userIsInTheMiddleOfTypingANumber = false
    let myCalculator = CalculatorBrain()
    var displayValue: Double {
        get {
            return (display.text! as NSString).doubleValue
        }
        set {
            display.text = "\(newValue)"
        }
    }

    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if let result = myCalculator.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0
        }
    }
    
    @IBAction func performOperation(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operatorSymbol = sender.currentTitle {
            if let result = myCalculator.performOperation(operatorSymbol) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
    }
    
    @IBAction func reset() {
        display.text = "0"
        myCalculator.reset()
        userIsInTheMiddleOfTypingANumber = false
    }

}

