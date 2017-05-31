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
    
    private var accumulator = 0
    private var operation: String!
    
    func performOperation(ac: Int, op: String){
        accumulator = ac
        operation = op
    }
    
    func performCalculate(res: Int){
        switch operation {
        case "+": accumulator = accumulator + res
        case "-": accumulator = accumulator - res
        case "x": accumulator = accumulator * res
        case "÷": accumulator = accumulator / res
        default : break
        }
    }
    
    var result: Int{
        get{
            return accumulator
        }
    }
}
