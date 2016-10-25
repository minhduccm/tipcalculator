//
//  StringUtil.swift
//  tips
//
//  Created by Duc Dinh on 6/28/16.
//  Copyright © 2016 Duc Dinh. All rights reserved.
//

import Foundation

extension String {
    
    func containsCharactersIn(matchCharacters: String) -> Bool {
        let characterSet = NSCharacterSet(charactersInString: matchCharacters)
        return self.rangeOfCharacterFromSet(characterSet) != nil
    }
    
    func containsOnlyCharactersIn(matchCharacters: String) -> Bool {
        let disallowedCharacterSet = NSCharacterSet(charactersInString: matchCharacters).invertedSet
        return self.rangeOfCharacterFromSet(disallowedCharacterSet) == nil
    }
    
    func doesNotContainCharactersIn(matchCharacters: String) -> Bool {
        
        let characterSet = NSCharacterSet(charactersInString: matchCharacters)
        return self.rangeOfCharacterFromSet(characterSet) == nil
    }
    
    func isNumeric() -> Bool {

        let scanner = NSScanner(string: self)
        scanner.locale = NSLocale.currentLocale()
        return scanner.scanDecimal(nil) && scanner.atEnd
    }
    
    func isContainsRedundantLeadingZerosInFloatNum() -> Bool {
        
        if self.characters.count == 2 {
            let firstChar = self[self.startIndex.advancedBy(0)]
            let secondChar = self[self.startIndex.advancedBy(1)]
            
            if firstChar == "0" && secondChar != "." {
                return true
            }
        }
        return false
    }
    
    func isContainsLeadingZerosInIntNum() -> Bool {
        
        let firstChar = self[self.startIndex.advancedBy(0)]
        
        if self.characters.count == 2 && firstChar == "0" {
            return true
        }
        return false
    }
}

extension Bool {
    init<T : IntegerType>(_ integer: T){
        self.init(integer != 0)
    }
}