//
//  LocaleManager.swift
//  TipsCalculator
//
//  Created by Arturo Fernandez on 9/19/16.
//  Copyright © 2016 Arturo Fernandez. All rights reserved.
//

import Foundation
import UIKit

class LocaleManager {
    
    class func formatLocale(value: Double, locale: String) -> String {
        let formatter: NumberFormatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.currency
        formatter.locale = Locale(identifier: locale)

        return formatter.string(from: NSNumber(value: value))!
    }
    
    class func constructLocale() -> [String: String] {
        let locale = NSLocale(localeIdentifier: "en_US")
        let identifiers = NSLocale.availableLocaleIdentifiers
        var localeDictionary: [String: String] = [String: String]()
        for identifier in identifiers {
            let name: String = locale.displayName(forKey: NSLocale.Key.identifier, value: identifier)!
            localeDictionary[identifier] = name
        }
        
        return localeDictionary
    }
}


