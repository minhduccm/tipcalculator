//
//  PercentageSetting.swift
//  tips
//
//  Created by Duc Dinh on 9/23/16.
//  Copyright © 2016 Duc Dinh. All rights reserved.
//

import UIKit

struct Item {
    var label: String
    var key: String
    var value: Int
}

class SettingSection : NSObject {
    
    var sectionType: String
    var items: [Item]
    
    init?(sectionType: String, items: [Item]) {
        self.sectionType = sectionType
        self.items = items
        super.init()
    }
    
    static func loadSettingByKey(defaults: NSUserDefaults, key: String, defaultValue: Int) -> Int {
        let value = defaults.integerForKey(key)
        if value == 0 { // not found value
            defaults.setInteger(defaultValue, forKey: key)
            defaults.synchronize()
            return defaultValue
        }
        return value
    }
    
    static func saveSettingByKey(key: String, value: Int) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(value, forKey: key)
        defaults.synchronize()
    }
    
    static func loadSettingSections() -> [SettingSection]? {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let defaultPercentage = SettingSection.loadSettingByKey(defaults, key: "defaultPercentage", defaultValue: 5)
        let minPercentage = SettingSection.loadSettingByKey(defaults, key: "minPercentage", defaultValue: 2)
        let maxPercentage = SettingSection.loadSettingByKey(defaults, key: "maxPercentage", defaultValue: 100)
        let darkTheme = SettingSection.loadSettingByKey(defaults, key: "darkTheme", defaultValue: 0)
        
        let percentageItems = [
            Item(label: "Default", key: "defaultPercentage", value: defaultPercentage),
            Item(label: "Minimum", key: "minPercentage", value: minPercentage),
            Item(label: "Maximum", key: "maxPercentage", value: maxPercentage)
        ]
        let appearanceItems = [Item(label: "Dark Theme", key: "darkTheme", value: darkTheme)]
        
        return [
            SettingSection(sectionType: "Percentage", items: percentageItems)!,
            SettingSection(sectionType: "Appearance", items: appearanceItems)!
        ]
    }
    
    static func getSettingItemByKey(items: [Item], key: String) -> Int {
        let results = items.filter({
            $0.key == key
        })
        
        if results.count == 0 {
            return -1
        }
        return results[0].value
    }
}


