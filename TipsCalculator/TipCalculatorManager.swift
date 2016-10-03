//
//  TipCalculatorManager.swift
//  TipsCalculator
//
//  Created by Arturo Fernandez on 9/19/16.
//  Copyright © 2016 Arturo Fernandez. All rights reserved.
//

import Foundation

class TipCalculatorManager {
    class func calculateIndividualPayment(total: Double, percentage: Int, people: Int) -> Double {
        let percentageFraction: Double = Double(Double(percentage) / 100.0)
        return Double((total * percentageFraction) / Double(people))
    }
    
    class func calculateTotalTip(total: Double, percentage: Int) -> Double {
        return Double(total * Double(Double(percentage) / 100.0))
    }
}
