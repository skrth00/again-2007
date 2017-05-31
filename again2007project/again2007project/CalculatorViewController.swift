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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.titleLabel?.text
        if userIsInTheMiddleOfTypingANumber {
            let currentText = display.text
            display.text = currentText?.appending(digit!)
        } else {
            display.text = digit
        }
        userIsInTheMiddleOfTypingANumber = true
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            userIsInTheMiddleOfTypingANumber = false
        }
        
        CalculatorModel.shared.performOperation(ac: Int(display.text!)!, op: sender.currentTitle!)
    }
    
    @IBAction func getResult(_ sender: UIButton) {
        userIsInTheMiddleOfTypingANumber = false
        let result = Int(display.text!)!
        CalculatorModel.shared.performCalculate(res: result)
        
        display.text = "\(CalculatorModel.shared.result)"
    }
    
    @IBAction func clear(_ sender: UIButton) {
        CalculatorModel.shared.performOperation(ac: 0, op: "")
        display.text = "0"
    }
}
