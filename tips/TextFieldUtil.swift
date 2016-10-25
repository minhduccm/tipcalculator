//
//  TextField.swift
//  tips
//
//  Created by Duc Dinh on 6/28/16.
//  Copyright © 2016 Duc Dinh. All rights reserved.
//

import UIKit

class TextFieldUtil: NSObject {

    static func validateInputs(textField: UITextField, range: NSRange, replacementString: String, typeOfTextFieldValidation: String) -> Bool {
        
        if replacementString.characters.count == 0 {
            return true
        }
        
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).stringByReplacingCharactersInRange(range, withString: replacementString)
        
        switch typeOfTextFieldValidation {
            
        case "positiveNumericOnlyTextField":
            return prospectiveText.isNumeric()
                && prospectiveText.doesNotContainCharactersIn("-e")
                && !prospectiveText.isContainsRedundantLeadingZerosInFloatNum()
            
        case "positiveIntegerPercentageTextField":
            let decimalSeparator = NSLocale.currentLocale().objectForKey(NSLocaleDecimalSeparator) as! String
            return prospectiveText.isNumeric()
                && prospectiveText.doesNotContainCharactersIn("-e" + decimalSeparator)
                && Int(prospectiveText) >= 0 && Int(prospectiveText) <= 100
                && !prospectiveText.isContainsLeadingZerosInIntNum()
            
        default:
            return true
        }
    }
}
