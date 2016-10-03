//
//  ViewController.swift
//  TipsCalculator
//
//  Created by Arturo Fernandez on 9/10/16.
//  Copyright © 2016 Arturo Fernandez. All rights reserved.
//

import UIKit
import Foundation

let notificationTotalUpdated: String = "totalUpdatedNotification"

//View Controller Life Cycle and Initialization Methods
class ViewController: UIViewController {
    @IBOutlet weak var totalConsumeLabel: UITextView?
    @IBOutlet var verticalConstraintConsumeLabel: NSLayoutConstraint?
    @IBOutlet weak var containerView: UIView?
    weak var calculatorVC: CalculatorViewController?
    weak var settingsVC: SettingsViewController?
    var currentTotal: Double = 0.00
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector:#selector(formatLocale) , name: NSNotification.Name(rawValue: notificationUpdatedLocale), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(makeTextViewFirstResponder), name: NSNotification.Name.UIApplicationDidBecomeActive , object: nil)
        self.calculatorVC = self.storyboard?.instantiateViewController(withIdentifier: "calculatorFrame") as? CalculatorViewController
        self.calculatorVC?.view.translatesAutoresizingMaskIntoConstraints = false
        self.addChildViewController(self.calculatorVC!)
        self.containerView!.addSubView(subView: (self.calculatorVC?.view)!)
        
        let doneSelector = #selector(ViewController.donePressed)
        ToolBarBuilder.addToolBar(textView: self.totalConsumeLabel!, tempSelector: doneSelector, title: "Done", responder: self)
        
        super.viewDidLoad()
        totalConsumeLabel?.textContainer.maximumNumberOfLines = 1
        totalConsumeLabel?.textContainer.lineBreakMode = NSLineBreakMode.byTruncatingTail
        totalConsumeLabel?.keyboardType = UIKeyboardType.decimalPad
        totalConsumeLabel?.delegate = self
        totalConsumeLabel?.textColor = Theme.calculatorFontColor
        totalConsumeLabel?.text = LocaleManager.formatLocale(value: currentTotal, locale: Locale.availableIdentifiers[self.selectedLocale])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        totalConsumeLabel?.becomeFirstResponder()
        totalConsumeLabel?.textColor = Theme.calculatorFontColor
        self.view.backgroundColor = Theme.calculatorBackgroundColor
        self.navigationController?.navigationBar.tintColor = Theme.toolBarButtonTintColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

extension ViewController: SettingsProtocol {
    var selectedLocale: Int {
        if (UserDefaults.standard.object(forKey: selectedLocaleKey) != nil) {
            return UserDefaults.standard.object(forKey: selectedLocaleKey) as! Int
        }
        
        return 0
    }
}

//UITextView Delegate Methods
extension ViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.view.layoutIfNeeded()
        textView.text = ""
        let padding: CGFloat = CGFloat(30.0)
        self.verticalConstraintConsumeLabel?.constant = -1 * (((self.totalConsumeLabel?.frame.minY)! - (self.navigationController?.navigationBar.frame.height)!) - padding)
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
            }, completion: { (completed: Bool) in
                
        })
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.view.layoutIfNeeded()
        self.verticalConstraintConsumeLabel?.constant = 0
        currentTotal = Double((totalConsumeLabel?.text!)!)!
        NotificationCenter.default.post(Notification(name: Notification.Name(notificationTotalUpdated), object: currentTotal, userInfo: nil))
        totalConsumeLabel?.text = LocaleManager.formatLocale(value: currentTotal, locale: Locale.availableIdentifiers[self.selectedLocale])
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
            }, completion: { (completed: Bool) in
                
        })
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        return true
    }
    
    func makeTextViewFirstResponder() {
        totalConsumeLabel?.becomeFirstResponder()
    }
}

//Custom UI Methods
extension ViewController {
    func donePressed() {
        self.totalConsumeLabel?.resignFirstResponder()
    }
}

//Convenience methods
extension ViewController {
    func formatLocale() {
        totalConsumeLabel?.text = LocaleManager.formatLocale(value: currentTotal, locale: Locale.availableIdentifiers[self.selectedLocale])
    }
}

