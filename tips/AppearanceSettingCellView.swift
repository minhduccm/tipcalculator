//
//  AppearanceSettingCellView.swift
//  tips
//
//  Created by Duc Dinh on 9/18/16.
//  Copyright © 2016 Duc Dinh. All rights reserved.
//

import UIKit

protocol AppearanceSettingCellDelegate {
    func switchCellCurrentlyEditing(editingCell: UITableViewCell) -> String
}

class AppearanceSettingCellView: UITableViewCell {
    
    var appearanceSettingCellDelegate: AppearanceSettingCellDelegate?
    
    @IBOutlet weak var themeLabel: UILabel!
    @IBOutlet weak var themeSwitch: UISwitch!
    
    @IBAction func onThemeValueChanged(sender: AnyObject) {
        let editingKey = self.appearanceSettingCellDelegate?.switchCellCurrentlyEditing(self)
        let editingValue = Int(themeSwitch.on)
        SettingSection.saveSettingByKey(editingKey!, value: editingValue)
    }
}
