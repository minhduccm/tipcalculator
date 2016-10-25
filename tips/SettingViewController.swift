//
//  SettingViewController.swift
//  tips
//
//  Created by Duc Dinh on 9/19/16.
//  Copyright © 2016 Duc Dinh. All rights reserved.
//

import UIKit

class SettingViewController: UITableViewController {
    
    let appearanceSettingIdentifier = "AppearanceSetting"
    let percentageSettingIdentifier = "PercentageSetting"
    var settingSections: [SettingSection] = []
    
    func hideKeyboard() {
        self.tableView.endEditing(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.clearsSelectionOnViewWillAppear = false

        // add tap gesture to hide keyboard when tapping outside row's textfield
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SettingViewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        self.tableView.addGestureRecognizer(tapGesture)
        
        // register cell for setting table
        self.tableView.registerNib(UINib(nibName: "AppearanceSettingCell", bundle: nil), forCellReuseIdentifier: appearanceSettingIdentifier)
        self.tableView.registerNib(UINib(nibName: "PercentageSettingCell", bundle: nil), forCellReuseIdentifier: percentageSettingIdentifier)
        
        // load setting sections
        self.settingSections = SettingSection.loadSettingSections()!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return settingSections.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settingSections[section].items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch self.settingSections[indexPath.section].sectionType {
        case "Percentage":
            let cell = self.tableView.dequeueReusableCellWithIdentifier(percentageSettingIdentifier, forIndexPath: indexPath) as! PercentageSettingCellView
            let item = self.settingSections[indexPath.section].items[indexPath.row]
            cell.percentageLabel.text = item.label
            cell.percentageTextField.text = String(format: "%d", item.value)
            cell.percentageSettingCellDelegate = self
            cell.contentView.userInteractionEnabled = false
            return cell
            
        case "Appearance":
            let cell = self.tableView.dequeueReusableCellWithIdentifier(appearanceSettingIdentifier, forIndexPath: indexPath) as! AppearanceSettingCellView
            let item = self.settingSections[indexPath.section].items[indexPath.row]
            cell.themeLabel.text = item.label
            cell.themeSwitch.on = Bool(item.value)
            cell.appearanceSettingCellDelegate = self
            cell.contentView.userInteractionEnabled = false
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.settingSections[section].sectionType
    }
}

extension SettingViewController : PercentageSettingCellDelegate {
    
    func textFieldCellCurrentlyEditingDidEnd(editingCell: PercentageSettingCellView) {
        
        let percentageSettings = self.settingSections[0].items
        let minPercentage = SettingSection.getSettingItemByKey(percentageSettings, key: "minPercentage")
        let maxPercentage = SettingSection.getSettingItemByKey(percentageSettings, key: "maxPercentage")
        let defaultPercentage = SettingSection.getSettingItemByKey(percentageSettings, key: "defaultPercentage")
        
        let currentIdxPath: NSIndexPath = tableView.indexPathForCell(editingCell)!
        let changingValue = Int(NSString(string: editingCell.percentageTextField.text!).intValue)
        let percentageLabel = editingCell.percentageLabel.text
        
        if percentageLabel == "Default" {
            if changingValue > maxPercentage {
                editingCell.percentageTextField.text = String(maxPercentage)
                SettingSection.saveSettingByKey("defaultPercentage", value: maxPercentage)
                
            } else if changingValue < minPercentage {
                editingCell.percentageTextField.text = String(minPercentage)
                SettingSection.saveSettingByKey("defaultPercentage", value: minPercentage)
                
            } else if changingValue > minPercentage && changingValue < maxPercentage {
                editingCell.percentageTextField.text = String(changingValue)
                SettingSection.saveSettingByKey("defaultPercentage", value: changingValue)
            }
            
        } else if percentageLabel == "Minimum" {
            if changingValue > maxPercentage {
                let defaultIndexPath: NSIndexPath = NSIndexPath(forRow: currentIdxPath.row - 1, inSection: currentIdxPath.section)
                let defaultItemCell = tableView.cellForRowAtIndexPath(defaultIndexPath) as! PercentageSettingCellView
                
                editingCell.percentageTextField.text = String(maxPercentage)
                defaultItemCell.percentageTextField.text = String(maxPercentage)
                SettingSection.saveSettingByKey("defaultPercentage", value: maxPercentage)
                SettingSection.saveSettingByKey("minPercentage", value: maxPercentage)
                
            } else if changingValue > defaultPercentage && changingValue < maxPercentage {
                let defaultIndexPath: NSIndexPath = NSIndexPath(forRow: currentIdxPath.row - 1, inSection: currentIdxPath.section)
                let defaultItemCell = tableView.cellForRowAtIndexPath(defaultIndexPath) as! PercentageSettingCellView
                
                editingCell.percentageTextField.text = String(changingValue)
                defaultItemCell.percentageTextField.text = String(changingValue)
                SettingSection.saveSettingByKey("defaultPercentage", value: changingValue)
                SettingSection.saveSettingByKey("minPercentage", value: changingValue)
                
            } else if changingValue < defaultPercentage {
                editingCell.percentageTextField.text = String(changingValue)
                SettingSection.saveSettingByKey("minPercentage", value: changingValue)
            }
            
        } else if percentageLabel == "Maximum" {
            if changingValue > 100 {
                editingCell.percentageTextField.text = "100"
                SettingSection.saveSettingByKey("maxPercentage", value: 100)
                
            } else if changingValue > defaultPercentage && changingValue <= 100 {
                editingCell.percentageTextField.text = String(changingValue)
                SettingSection.saveSettingByKey("maxPercentage", value: changingValue)
                
            } else if changingValue > minPercentage && changingValue < defaultPercentage {
                let defaultIndexPath: NSIndexPath = NSIndexPath(forRow: currentIdxPath.row - 2, inSection: currentIdxPath.section)
                let defaultItemCell = tableView.cellForRowAtIndexPath(defaultIndexPath) as! PercentageSettingCellView
                
                editingCell.percentageTextField.text = String(changingValue)
                defaultItemCell.percentageTextField.text = String(changingValue)
                SettingSection.saveSettingByKey("defaultPercentage", value: changingValue)
                SettingSection.saveSettingByKey("maxPercentage", value: changingValue)
                
            } else if changingValue < minPercentage {
                let defaultIndexPath: NSIndexPath = NSIndexPath(forRow: currentIdxPath.row - 2, inSection: currentIdxPath.section)
                let defaultItemCell = tableView.cellForRowAtIndexPath(defaultIndexPath) as! PercentageSettingCellView
                let minIndexPath: NSIndexPath = NSIndexPath(forRow: currentIdxPath.row - 1, inSection: currentIdxPath.section)
                let minItemCell = tableView.cellForRowAtIndexPath(minIndexPath) as! PercentageSettingCellView
                
                editingCell.percentageTextField.text = String(changingValue)
                defaultItemCell.percentageTextField.text = String(changingValue)
                minItemCell.percentageTextField.text = String(changingValue)
                SettingSection.saveSettingByKey("defaultPercentage", value: changingValue)
                SettingSection.saveSettingByKey("minPercentage", value: changingValue)
                SettingSection.saveSettingByKey("maxPercentage", value: changingValue)
            }
        }
        
        // reload setting sections
        self.settingSections = SettingSection.loadSettingSections()!
    }
}

extension SettingViewController : AppearanceSettingCellDelegate {
    
    func switchCellCurrentlyEditing(editingCell: UITableViewCell) -> String {
        let idxPath: NSIndexPath = tableView.indexPathForCell(editingCell)!
        return self.settingSections[idxPath.section].items[idxPath.row].key
    }
}