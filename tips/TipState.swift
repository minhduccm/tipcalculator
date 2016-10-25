//
//  TipState.swift
//  tips
//
//  Created by Duc Dinh on 10/3/16.
//  Copyright © 2016 Duc Dinh. All rights reserved.
//

import UIKit

class TipState : NSObject, NSCoding {
    
    var lastSeen: NSDate
    var lastBillAmount: String
    var lastSelectedTipPercent: Float
    var lastMinTipPercent: Float
    var lastMaxTipPercent: Float
    
    init?(lastSeen: NSDate, lastBillAmount: String, lastSelectedTipPercent: Float, lastMinTipPercent: Float, lastMaxTipPercent: Float) {
        self.lastSeen = lastSeen
        self.lastBillAmount = lastBillAmount
        self.lastSelectedTipPercent = lastSelectedTipPercent
        self.lastMinTipPercent = lastMinTipPercent
        self.lastMaxTipPercent = lastMaxTipPercent
        
        super.init()
    }
    
    required convenience init?(coder decoder: NSCoder) {
        
        let lastSeen = decoder.decodeObjectForKey("lastSeen") as! NSDate
        let lastBillAmount = decoder.decodeObjectForKey("lastBillAmount") as! String
        let lastSelectedTipPercent = decoder.decodeObjectForKey("lastSelectedTipPercent") as! Float
        let lastMinTipPercent = decoder.decodeObjectForKey("lastMinTipPercent") as! Float
        let lastMaxTipPercent = decoder.decodeObjectForKey("lastMaxTipPercent") as! Float
        
        self.init(
            lastSeen: lastSeen,
            lastBillAmount: lastBillAmount,
            lastSelectedTipPercent: lastSelectedTipPercent,
            lastMinTipPercent: lastMinTipPercent,
            lastMaxTipPercent: lastMaxTipPercent
        )
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(lastSeen, forKey: "lastSeen")
        coder.encodeObject(lastBillAmount, forKey: "lastBillAmount")
        coder.encodeObject(lastSelectedTipPercent, forKey: "lastSelectedTipPercent")
        coder.encodeObject(lastMinTipPercent, forKey: "lastMinTipPercent")
        coder.encodeObject(lastMaxTipPercent, forKey: "lastMaxTipPercent")
    }
    
    func storeTipState(tipState: TipState) {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let tipStateEncodedObj: NSData = NSKeyedArchiver.archivedDataWithRootObject(tipState)
        defaults.setObject(tipStateEncodedObj, forKey: "tipState")
        defaults.synchronize()
    }
    
    static func loadTipState() -> TipState? {
        let defaults = NSUserDefaults.standardUserDefaults()
        let tipStateEncodedObj = defaults.objectForKey("tipState") as? NSData
        if tipStateEncodedObj == nil {
            return nil
        }
        
        return NSKeyedUnarchiver.unarchiveObjectWithData(tipStateEncodedObj!) as? TipState
    }
}