//
//  CalculatorViewController.swift
//  TipsCalculator
//
//  Created by Arturo Fernandez on 9/11/16.
//  Copyright © 2016 Arturo Fernandez. All rights reserved.
//

import Foundation
import UIKit

let numberOfPeopleKey = "numberOfPeople"
let tipPercentageKey = "tipPercentage"
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
    
    var currentTotal: Double = 0.00
    var currentNumberOfPeople: Int = 1
    var currentAmountPerPerson: Double = 0.00
    var currentTipPercentage: Int = 0
    var currentTipTotal: Double = 0.00
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(totalUpdatedWithValue(notification:)), name: NSNotification.Name(rawValue: notificationTotalUpdated), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initializeUIElements()
        updateValuesForUIEvent()
        
        self.view.backgroundColor = Theme.tipControlsBackgroundColor
        tipTotalLabel?.textColor = Theme.tipControlsFontColor
        tipAmountTitle?.textColor = Theme.tipControlsFontColor
        tipPercentageTitle?.textColor = Theme.tipControlsFontColor
        numberOfPeopleLabel?.textColor = Theme.tipControlsFontColor
        numberOfPeopleTitle?.textColor = Theme.tipControlsFontColor
        amountPerPersonTitle?.textColor = Theme.tipControlsFontColor
        paymentPerPersonLabel?.textColor = Theme.tipControlsFontColor
        percentageLabel?.textColor = Theme.tipControlsFontColor
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}

//UI Events
extension CalculatorViewController {
    @IBAction func increaseNumberOfPeople(sender: UIButton) {
        currentNumberOfPeople += 1
        updateCalculatorValues()
        updateValuesForUIEvent()
        UserDefaults.standard.set(currentNumberOfPeople, forKey: numberOfPeopleKey)
    }
    
    @IBAction func decreaseNumberOfPeople(sender: UIButton) {
        if ( currentNumberOfPeople > 1 ) {
            currentNumberOfPeople = currentNumberOfPeople - 1
            updateCalculatorValues()
            updateValuesForUIEvent()
            UserDefaults.standard.set(currentNumberOfPeople, forKey: numberOfPeopleKey)
        }
    }
    
    @IBAction func increaseTipPercentage(sender: UIButton) {
        currentTipPercentage += 1
        updateCalculatorValues()
        updateValuesForUIEvent()
        UserDefaults.standard.set(currentTipPercentage, forKey: tipPercentageKey)
    }
    
    @IBAction func decreaseTipPercentage(sender: UIButton) {
        
        if  ( currentTipPercentage > 0 ) {
            currentTipPercentage = currentTipPercentage - 1
            updateCalculatorValues()
            updateValuesForUIEvent()
            UserDefaults.standard.set(currentTipPercentage, forKey: tipPercentageKey)
        }
    }
}

extension CalculatorViewController {
    func updateValuesForUIEvent() {
        numberOfPeopleLabel?.text = "\(currentNumberOfPeople)"
        percentageLabel?.text = "\(currentTipPercentage)"
        tipTotalLabel?.text = LocaleManager.formatLocale(value: currentTipTotal, locale: Locale.availableIdentifiers[selectedLocale])
        paymentPerPersonLabel?.text = LocaleManager.formatLocale(value: currentAmountPerPerson, locale: Locale.availableIdentifiers[selectedLocale])
    }
}

extension CalculatorViewController {
    func updateCalculatorValues() {
        currentTipTotal = TipCalculatorManager.calculateTotalTip(total: currentTotal, percentage: currentTipPercentage)
        currentAmountPerPerson = TipCalculatorManager.calculateIndividualPayment(total: currentTotal, percentage: currentTipPercentage, people: currentNumberOfPeople)
    }
    
    func totalUpdatedWithValue(notification: Notification) {
        currentTotal = notification.object as! Double
        updateValuesForUIEvent()
    }
    
    func initializeUIElements() {
        numberOfPeopleLabel?.text = UserDefaults.standard.object(forKey: numberOfPeopleKey) != nil ? String(describing: UserDefaults.standard.object(forKey: numberOfPeopleKey)!) : "1"
        percentageLabel?.text = UserDefaults.standard.object(forKey: tipPercentageKey) != nil ? "\(String(describing: UserDefaults.standard.object(forKey: tipPercentageKey)!))%" : "0%"
        
        paymentPerPersonLabel?.text = LocaleManager.formatLocale(value: currentAmountPerPerson, locale: Locale.availableIdentifiers[self.selectedLocale])
        tipTotalLabel?.text = LocaleManager.formatLocale(value: currentTipTotal, locale: Locale.availableIdentifiers[self.selectedLocale])
    }
}

extension CalculatorViewController: SettingsProtocol {
    var selectedLocale: Int {
        if UserDefaults.standard.object(forKey: selectedLocaleKey) != nil {
            return UserDefaults.standard.object(forKey: selectedLocaleKey) as! Int
        }
        
        return 0
    }
}
