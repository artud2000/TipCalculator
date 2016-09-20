//
//  CalculatorViewController.swift
//  TipsCalculator
//
//  Created by Arturo Fernandez on 9/11/16.
//  Copyright © 2016 Arturo Fernandez. All rights reserved.
//

import Foundation
import UIKit


//Initialization and ViewController Life Cycle Methods
class CalculatorViewController: UIViewController {
    @IBOutlet weak var percentageLabel: UILabel?
    @IBOutlet weak var numberOfPeopleLabel: UILabel?
    @IBOutlet weak var paymentPerPersonLabel: UILabel?
    @IBOutlet weak var tipTotalLabel: UILabel?
    @IBOutlet weak var tipPercentageTitle: UILabel?
    @IBOutlet weak var tipAmountTitle: UILabel?
    @IBOutlet weak var amountPerPersonTitle: UILabel?
    @IBOutlet weak var numberOfPeopleTitle: UILabel?
    
    var currentTotalValue: String = "0.00"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        paymentPerPersonLabel?.text = LocaleManager.sharedInstace.formatLocale(value: (paymentPerPersonLabel?.text)!, locale: self.selectedLocale)
        tipTotalLabel?.text = LocaleManager.sharedInstace.formatLocale(value: (tipTotalLabel?.text)!, locale: self.selectedLocale)
        
        NotificationCenter.default.addObserver(self, selector: #selector(formatLocale), name: NSNotification.Name(rawValue: notificationUpdatedLocale), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(totalUpdatedWithValue(notification:)), name: NSNotification.Name(rawValue: notificationTotalUpdated), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
}

//UI Events
extension CalculatorViewController {
    @IBAction func increaseNumberOfPeople(sender: UIButton) {
        var numberOfPeople: Int = Int((numberOfPeopleLabel?.text)!)!
        numberOfPeople = numberOfPeople + 1
        numberOfPeopleLabel?.text = "\(numberOfPeople)"
        self.updateValuesForUIEvent(totalString: self.currentTotalValue)
    }
    
    @IBAction func decreaseNumberOfPeople(sender: UIButton) {
        var numberOfPeople: Int = Int((numberOfPeopleLabel?.text)!)!
        if (numberOfPeople > 1) {
            numberOfPeople = numberOfPeople - 1
            numberOfPeopleLabel?.text = "\(numberOfPeople)"
            self.updateValuesForUIEvent(totalString: self.currentTotalValue)
        }
    }
    
    @IBAction func increaseTipPercentage(sender: UIButton) {
        let tipPercentStrippedString: String = (percentageLabel?.text?.replacingOccurrences(of: "%", with: ""))!
        var tipPercent: Int = Int(tipPercentStrippedString)!
        tipPercent = tipPercent + 1
        percentageLabel?.text = "%\(tipPercent)"
        self.updateValuesForUIEvent(totalString: self.currentTotalValue)
    }
    
    @IBAction func decreaseTipPercentage(sender: UIButton) {
        let tipPercentStrippedString: String = (percentageLabel?.text?.replacingOccurrences(of: "%", with: ""))!
        var tipPercent: Int = Int(tipPercentStrippedString)!
        if  (tipPercent > 0) {
            tipPercent = tipPercent - 1
            percentageLabel?.text = "%\(tipPercent)"
            self.updateValuesForUIEvent(totalString: self.currentTotalValue)
        }
    }
}

extension CalculatorViewController {
    func updateValuesForUIEvent(totalString: String) {
        self.currentTotalValue = totalString
        let totalNumeric: Float = LocaleManager.sharedInstace.returnDecimalWithoutLocale(value: totalString, locale: selectedLocale)
        let percentageNumeric: Int = Int((percentageLabel?.text?.replacingOccurrences(of: "%", with: ""))!)!
        let totalTipFloat: Float = TipCalculatorManager.sharedInstance.calculateIndividualPayment(total: totalNumeric, percentage: percentageNumeric, people:Int( (numberOfPeopleLabel?.text)!)!)
        let perPersonTipFloat: Float = TipCalculatorManager.sharedInstance.calculateTotalTip(total: totalNumeric, percentage: percentageNumeric)
        tipTotalLabel?.text = String(format: "%.2f", perPersonTipFloat)
        paymentPerPersonLabel?.text = String(format: "%.2f", totalTipFloat)  
    }
}

//Notifications observers
extension CalculatorViewController {
    func totalUpdatedWithValue(notification: Notification) {
        let totalString: String = notification.object as! String
        self.updateValuesForUIEvent(totalString: totalString)
    }
    
    func formatLocale() {
        paymentPerPersonLabel?.text = LocaleManager.sharedInstace.formatLocale(value: (paymentPerPersonLabel?.text)!, locale: self.selectedLocale)
        tipTotalLabel?.text = LocaleManager.sharedInstace.formatLocale(value: (tipTotalLabel?.text)!, locale: self.selectedLocale)
    }
}

extension CalculatorViewController: SettingsProtocol {
    var selectedLocale: Int {
        return UserDefaults.standard.object(forKey: selectedLocaleKey) as! Int
    }
}