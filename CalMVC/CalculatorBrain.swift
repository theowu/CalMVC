//
//  CalculatorBrain.swift
//  CalMVC
//
//  Created by Theo WU on 14/07/2016.
//  Copyright © 2016 Theo WU. All rights reserved.
//

import Foundation
//Model
class CalculatorBrain {
    
    private enum Op: CustomStringConvertible {
        case Operand(Double)
        case UnaryOperation(String, Double->Double)
        case BinaryOperation(String, (Double,Double)->Double)
        
        var description: String {
            get {
                switch self {
                case Op.Operand(let operand):
                    return String(operand)
                case Op.BinaryOperation(let symbol, _):
                    return symbol
                case Op.UnaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
    }
    
    private var opStack = Array<Op>()
    private var knownOps = Dictionary<String,Op>()
    
    init() {
        func learnOp(op:Op) {
            knownOps[op.description] = op
        }
        
        learnOp(Op.BinaryOperation("+", +))
        learnOp(Op.BinaryOperation("×", *))
        learnOp(Op.BinaryOperation("−", {$1-$0}))
        learnOp(Op.BinaryOperation("÷", {$1/$0}))
        learnOp(Op.UnaryOperation("√", sqrt))
        learnOp(Op.UnaryOperation("sin", sin))
        learnOp(Op.UnaryOperation("cos", cos))
        learnOp(Op.UnaryOperation("tan", tan))
        learnOp(Op.UnaryOperation("pow2", {$0*$0}))
    }
    
    func pushOperand(operand:Double) -> Double? {
        opStack.append(Op.Operand(operand))

        return evaluate()
    }
    
    func performOperation(symbol:String) -> Double? {
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    
    private func evaluate(ops:Array<Op>) -> (result: Double?, remainingOps: Array<Op>) {
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op {
            case .Operand(let operand):
                return (operand, remainingOps)
            case .UnaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result {
                    return (operation(operand), operandEvaluation.remainingOps)
                }
            case .BinaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let op1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let op2 = op2Evaluation.result {
                        return (operation(op1,op2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        print(opStack)
        let (result,_) = evaluate(opStack)
        return result
    }
    
    func reset() {
        opStack = Array<Op>()
    }
}