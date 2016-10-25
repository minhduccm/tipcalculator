//
//  PercentageSettingCellView.swift
//  tips
//
//  Created by Duc Dinh on 9/18/16.
//  Copyright © 2016 Duc Dinh. All rights reserved.
//

import UIKit

protocol PercentageSettingCellDelegate {
    func textFieldCellCurrentlyEditingDidEnd(editingCell: PercentageSettingCellView)
}

class PercentageSettingCellView: UITableViewCell {

    var percentageSettingCellDelegate: PercentageSettingCellDelegate?
    
    @IBOutlet weak var percentageLabel: UILabel!
    @IBOutlet weak var percentageTextField: UITextField!
    
    @IBAction func onPercentageEditingDidEnd(sender: AnyObject) {
        self.percentageSettingCellDelegate?.textFieldCellCurrentlyEditingDidEnd(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        percentageTextField.delegate = self
    }
}

extension PercentageSettingCellView: UITextFieldDelegate {
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
        case percentageTextField:
            let validateRes = TextFieldUtil.validateInputs(textField, range: range, replacementString: string, typeOfTextFieldValidation: "positiveIntegerPercentageTextField")
            return validateRes
        default:
            return true
        }
    }
}
