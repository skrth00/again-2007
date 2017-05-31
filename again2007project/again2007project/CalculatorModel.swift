//
//  CalculatorModel.swift
//  again2007project
//
//  Created by 윤민섭 on 2017. 5. 31..
//  Copyright © 2017년 윤민섭. All rights reserved.
//

import Foundation

class CalculatorModel {
    static let shared = CalculatorModel()
    
    private var calculatorDefaults = UserDefaults.standard
    
    private var accumulator = 0
    private var operation: String!
    
    func performOperation(ac: Int, op: String){
        accumulator = ac
        operation = op
        setCurrentState()
    }
    
    func performCalculate(res: Int){
        switch operation {
        case "+": accumulator = accumulator + res
        case "-": accumulator = accumulator - res
        case "x": accumulator = accumulator * res
        case "÷": accumulator = accumulator / res
        default : break
        }
        setCurrentState()
    }
    
    var result: Int{
        get{
            return accumulator
        }
    }
    
    func setCurrentState(){
        calculatorDefaults.set(accumulator, forKey: "accumulator")
    }
    
    func checkState() -> Int?{
        return calculatorDefaults.integer(forKey: "accumulator")
    }
}
