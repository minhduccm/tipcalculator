//
//  ViewController.swift
//  tips
//
//  Created by Duc Dinh on 6/19/16.
//  Copyright © 2016 Duc Dinh. All rights reserved.
//

import UIKit


class TipsViewController: UIViewController {
    
    let REMEMBER_DURATION = 600 // 10 mins
    
    var controlsDisplayed = false
    var isFirstLoad = true
    var isLoadFromRememberedState = false
    let fmt = NSNumberFormatter()

    // IBOutlets
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipAmountLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var minTipLabel: UILabel!
    @IBOutlet weak var maxTipLabel: UILabel!
    @IBOutlet weak var tipSlider: UISlider!
    @IBOutlet weak var equalSignLabel: UILabel!
    @IBOutlet weak var plusSignLabel: UILabel!
    
    // IBActions
    @IBAction func onBillFieldEditingChanged(sender: AnyObject) {
        displayControls()
        updateValues()
    }
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    @IBAction func onTipSliderValueChanged(sender: AnyObject) {
        updateValues()
    }
    
    func setControlsVisibility(hidden: Bool) {
        let alpha = hidden ? 0 : 1
        self.tipAmountLabel.alpha = CGFloat(alpha)
        self.totalLabel.alpha = CGFloat(alpha)
        self.minTipLabel.alpha = CGFloat(alpha)
        self.maxTipLabel.alpha = CGFloat(alpha)
        self.tipSlider.alpha = CGFloat(alpha)
        self.equalSignLabel.alpha = CGFloat(alpha)
        self.plusSignLabel.alpha = CGFloat(alpha)
    }

    func hideControls() {
        self.setControlsVisibility(true)
        UIView.animateWithDuration(1, animations: {
            self.billField.frame.origin.y += 120
        })
    }

    func displayControls() {
        if !controlsDisplayed {
            UIView.animateWithDuration(0.5, animations: {
                self.billField.frame.origin.y -= 120
            })
            UIView.animateWithDuration(2, animations: {
                self.setControlsVisibility(false)
            })
            controlsDisplayed = true
        }
    }
    
    func updateValues() {
        let convertedAmount = NSNumberFormatter().numberFromString(billField.text!)
        if convertedAmount != nil {
            let tipPercentage = floor(tipSlider.value) // floor it because value of tipSlider could be double value with some decimal places
            
            let billAmount = Double(convertedAmount!)
            let tip = billAmount * Double(tipPercentage / 100)
            let total = billAmount + tip
            tipAmountLabel.text = fmt.stringFromNumber(tip)
            totalLabel.text = fmt.stringFromNumber(total)
            
        } else { // reset tipAmountLabel & totalLabel to zero
            tipAmountLabel.text = fmt.stringFromNumber(0)
            totalLabel.text = fmt.stringFromNumber(0)
        }
    }
    
    
    func changeTheme(isDark: Bool) {
        self.view.backgroundColor = isDark ? UIColor.darkGrayColor() : UIColor.lightGrayColor()
        billField.textColor = isDark ? UIColor.whiteColor() : UIColor.blackColor()
        billField.attributedPlaceholder = isDark ? NSAttributedString(string: fmt.currencySymbol, attributes: [NSForegroundColorAttributeName : UIColor(white: 1, alpha: 0.2)]) :
            NSAttributedString(string: fmt.currencySymbol, attributes: [NSForegroundColorAttributeName : UIColor(white: 0, alpha: 0.2)])
        maxTipLabel.textColor = isDark ? UIColor.whiteColor() : UIColor.blackColor()
        minTipLabel.textColor = isDark ? UIColor.whiteColor() : UIColor.blackColor()
        tipAmountLabel.textColor = isDark ? UIColor.whiteColor() : UIColor.blackColor()
        totalLabel.textColor = isDark ? UIColor.whiteColor() : UIColor.blackColor()
        tipSlider.thumbTintColor = isDark ? UIColor.whiteColor() : UIColor.blackColor()
        tipSlider.tintColor = isDark ? UIColor.whiteColor() : UIColor.blackColor()
        plusSignLabel.textColor = isDark ? UIColor.whiteColor() : UIColor.blackColor()
        equalSignLabel.textColor = isDark ? UIColor.whiteColor() : UIColor.blackColor()
    }
    
    func loadRememberedTipState() {
        let lastTipState = TipState.loadTipState()
        if lastTipState == nil {
            return
        }
        
        let lastSeen = lastTipState!.lastSeen
        let elapsedTime = NSDate().timeIntervalSinceDate(lastSeen)
        let duration = Int(elapsedTime)
        if duration < REMEMBER_DURATION {
            isLoadFromRememberedState = true
            billField.text = lastTipState!.lastBillAmount
            tipSlider.minimumValue = lastTipState!.lastMinTipPercent
            tipSlider.maximumValue = lastTipState!.lastMaxTipPercent
            tipSlider.value = lastTipState!.lastSelectedTipPercent
            minTipLabel.text = String(format: "%d", Int(lastTipState!.lastMinTipPercent)) + "%"
            maxTipLabel.text = String(format: "%d", Int(lastTipState!.lastMaxTipPercent)) + "%"
        }
    }
    
    // life cycle functions
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let settingSections = SettingSection.loadSettingSections()
        let appearanceSettings = settingSections![1].items
        if appearanceSettings.count > 0 && appearanceSettings[0].value == 1 { // change to dark theme
            changeTheme(true)
        } else {
            changeTheme(false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.applicationWillTerminateDelegate = self
        billField.delegate = self
        
        fmt.numberStyle = .CurrencyStyle
        fmt.groupingSeparator = ","
        billField.keyboardType = UIKeyboardType.DecimalPad
        
        loadRememberedTipState()
        if !isLoadFromRememberedState {
            hideControls()
        } else {
            controlsDisplayed = true // load controls' value from remembered state => controls already displayed & had values
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // focus to billField
        billField.becomeFirstResponder()
        
        let settingSections = SettingSection.loadSettingSections()
        let percentageSettings = settingSections![0].items
        
        let minPercentage = SettingSection.getSettingItemByKey(percentageSettings, key: "minPercentage")
        let maxPercentage = SettingSection.getSettingItemByKey(percentageSettings, key: "maxPercentage")
        tipSlider.minimumValue = Float(minPercentage)
        tipSlider.maximumValue = Float(maxPercentage)
        if isFirstLoad && !isLoadFromRememberedState { // setting slider's value always comes after min & max
            let selectedPercentage = SettingSection.getSettingItemByKey(percentageSettings, key: "defaultPercentage")
            tipSlider.value = Float(selectedPercentage)
            isFirstLoad = false
        }
        minTipLabel.text = String(format: "%d", minPercentage) + "%"
        maxTipLabel.text = String(format: "%d", maxPercentage) + "%"
        updateValues()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension TipsViewController : UITextFieldDelegate {
    func textField(textField: UITextField,
        shouldChangeCharactersInRange range: NSRange,
        replacementString string: String) -> Bool {
        
        switch textField {
        case billField:
            let validateRes = TextFieldUtil.validateInputs(textField, range: range, replacementString: string, typeOfTextFieldValidation: "positiveNumericOnlyTextField")
            return validateRes
        default:
            return true
        }
    }
}

extension TipsViewController : ApplicationWillTerminateDelegate {
    func saveStateBeforeTerminating() {
        let lastSeen = NSDate()
        let tipState = TipState(
            lastSeen: lastSeen,
            lastBillAmount: billField.text!,
            lastSelectedTipPercent: tipSlider.value,
            lastMinTipPercent: tipSlider.minimumValue,
            lastMaxTipPercent: tipSlider.maximumValue)
        tipState?.storeTipState(tipState!)
    }
}

