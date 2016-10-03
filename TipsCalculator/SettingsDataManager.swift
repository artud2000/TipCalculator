//
//  SettingsDataManager.swift
//  TipsCalculator
//
//  Created by Arturo Fernandez on 9/25/16.
//  Copyright © 2016 Arturo Fernandez. All rights reserved.
//

import Foundation
import UIKit

enum ThemeEnum {
    case Light
    case Dark
}


class SettingsDataManager: NSObject, UITableViewDelegate, UITableViewDataSource {
    var themes: [String] = ["Light", "Dark"]
    var localeDictionary: [String: String] = LocaleManager.constructLocale()
    
    @objc(tableView:heightForRowAtIndexPath:) func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Country"
        }
        return "Color Preference"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let onDemandCell: UITableViewCell = UITableViewCell()
        onDemandCell.backgroundColor = Theme.settingsTableBackgroundColor
        onDemandCell.textLabel?.textColor = Theme.settingsTableFontColor
        
        if ( indexPath.section == 1 ) {
            let selectedLocale: Int
            if UserDefaults.standard.object(forKey: selectedLocaleKey) != nil {
                selectedLocale = UserDefaults.standard.object(forKey: selectedLocaleKey) as! Int
            } else {
                selectedLocale = 0
            }
            
            if indexPath.row == selectedLocale {
                onDemandCell.accessoryType = UITableViewCellAccessoryType.checkmark
            } else {
                onDemandCell.accessoryType = UITableViewCellAccessoryType.none
            }
            
            
            let localeName: String = NSLocale.availableLocaleIdentifiers[indexPath.row]
            onDemandCell.textLabel?.text = localeDictionary[localeName]
            
        
            return onDemandCell
        }
        
        if indexPath.row == Theme.themeValue {
            onDemandCell.accessoryType = UITableViewCellAccessoryType.checkmark
        } else {
            onDemandCell.accessoryType = UITableViewCellAccessoryType.none
        }
        
        onDemandCell.textLabel?.text = themes[indexPath.row]
        return onDemandCell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return NSLocale.availableLocaleIdentifiers.count
        }
        
        return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell: UITableViewCell = tableView.cellForRow(at: indexPath)!
        selectedCell.setSelected(true, animated: true)
        selectedCell.accessoryType = UITableViewCellAccessoryType.checkmark
        
        if indexPath.section == 1 {
            let selectedLocale: Int
            if UserDefaults.standard.object(forKey: selectedLocaleKey) != nil {
                selectedLocale = UserDefaults.standard.object(forKey: selectedLocaleKey) as! Int
            } else {
                selectedLocale = 0
            }
            
            let tempIndexPath: IndexPath = IndexPath(row: selectedLocale , section: 1)
            if let unselectedCell: UITableViewCell = tableView.cellForRow(at: tempIndexPath) {
                unselectedCell.accessoryType = UITableViewCellAccessoryType.none
            }
            
            UserDefaults.standard.set(indexPath.row, forKey: selectedLocaleKey)
            
            NotificationCenter.default.post(Notification(name: Notification.Name(notificationUpdatedLocale), object: Int(indexPath.row)))
            return
        }
        
        let themeValue: ThemeEnum = indexPath.row == 0 ? ThemeEnum.Light : ThemeEnum.Dark
        var row: Int = 1
        switch themeValue {
            case ThemeEnum.Light:
                Theme.themeLight()
            case ThemeEnum.Dark:
                Theme.themeDark()
                row = 0
        }
        let tempIndexPath = IndexPath(row: row, section: 0)
        let unselectedCell = tableView.cellForRow(at: tempIndexPath)
        unselectedCell?.accessoryType = UITableViewCellAccessoryType.none
        NotificationCenter.default.post(Notification(name: Notification.Name(notificationUpdateUIColors), object: Int(indexPath.row)))
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = Theme.settingsHeaderBackgroundColor
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = Theme.settingsHeaderFontColor
    }
}
