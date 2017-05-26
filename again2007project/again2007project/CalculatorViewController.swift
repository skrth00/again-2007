//
//  CalculatorViewController.swift
//  again2007project
//
//  Created by 이승희 on 26/05/2017.
//  Copyright © 2017 윤민섭. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    @IBOutlet weak var display: UILabel!
    var userIsInTheMiddleOfTypingANumber:Bool = false
    
    var operation:String = ""
    var accumulator = 0
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.titleLabel?.text
        if userIsInTheMiddleOfTypingANumber {
            let currentText = display.text
            display.text = currentText?.appending(digit!)
        } else {
            display.text = digit
        }
        userIsInTheMiddleOfTypingANumber = true;
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            userIsInTheMiddleOfTypingANumber = false
        }
        
        accumulator = Int(display.text!)!
        operation = sender.currentTitle!
    }
    
    @IBAction func getResult(_ sender: UIButton) {
        userIsInTheMiddleOfTypingANumber = false
        var result = Int(display.text!)!
        
        if operation == "+" {
            result = accumulator + result
        } else if operation == "-" {
            result = accumulator - result
        } else if operation == "×" {
            result = accumulator * result
        } else if operation == "÷" {
            result = accumulator / result
        }
        
        display.text = "\(result)"
    }
    
    @IBAction func clear(_ sender: UIButton) {
        accumulator = 0
        operation = ""
        display.text = "0"
    }
    
}
