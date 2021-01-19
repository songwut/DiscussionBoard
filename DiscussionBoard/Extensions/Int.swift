//
//  Int.swift
//  DiscussionBoard
//
//  Created by Songwut Maneefun on 19/1/2564 BE.
//

import UIKit

extension Int {
    var priority: UILayoutPriority {
        return UILayoutPriority(rawValue: Float(self))
    }
    
    func durationText(completion: @escaping (_ text: String)->()) {
        let hours = self / 3600
        let minutes = (self % 3600) / 60
        let seconds = (self % 3600) % 60
        completion("\(hours):\(minutes):\(seconds)")
    }
    
    var secStringFrom: String {
        return self < 10 ? "0\(self)" : "\(self)"
    }
    
    var seconds: Int {
        return self
    }
    
    var isEvenNumber: Bool {
        return Double(self % 2) == 0.0
    }
    
    var minutes: Int {
        return self.seconds * 60
    }
    
    var hours: Int {
        return self.minutes * 60
    }
    
    var days: Int {
        return self.hours * 24
    }
    
    var weeks: Int {
        return self.days * 7
    }
    
    var months: Int {
        return self.weeks * 4
    }
    
    var years: Int {
        return self.months * 12
    }
    
    var sec: Int {
        return Int((self % 3600) % 60)
    }
    var dayFromSec: Int {
        return Int(self / 86400)
    }
    
    var minsFromSec: Int {
        return (Int(self % 3600) / 60)
    }
    
    var hoursFromSec: Int {
        return (Int(self % 86400) / 3600)
    }
    
    private func stringToReturn(flag:Bool, strings: (String, String)) -> String {
        if (flag){
            return strings.0
        } else {
            return strings.1
        }
    }
    
    
    var textDays: String {
        let day = self.dayFromSec
        return day.textNumber(many: "days")
    }
    
    var textRemainingDays: String {
        let day = self.dayFromSec
        if day == 0, self > 0 {
            return 1.textNumber(many: "days")
        }
        return day.textNumber(many: "days")
    }
    
    var stringFromSec: String {
        
        let sec = self.sec
        let mins = self.minsFromSec
        let hours = self.hoursFromSec
        let day = self.dayFromSec
        print("stringFromSec d\(day) \(hours)h \(mins)m \(sec)s \(seconds)seconds")
        var strList = [String]()
        
        if day >= 1 {
            strList.append(day.textNumber(many: "days"))
        }
        
        if hours >= 1 {
            strList.append(hours.textNumber(many: "hrs"))
        }
        
        if mins >= 1 {
            strList.append(mins.textNumber(many: "mins".localized()))
        }
        var str = ""
        for text in strList {
            if str == "" {
                str = text
            } else {
                str = str + " " + text
            }
        }
        return str
    }
    
    var stringFromMin: String {
        
        let sec = self.sec
        let mins = self.minsFromSec
        let hours = self.hoursFromSec
        let day = self.dayFromSec
        print("stringFromSec d\(day) \(hours)h \(mins)m \(sec)s \(seconds)seconds")
        
        var str = ""
        var unit = "full_min".localized()
        
        if hours >= 1 {
            str = str + String(format: "%02d:", hours)
            unit = hours.unit("hrs")
        }
        
        if mins >= 1 || sec >= 1 {
            str = str + String(format: "%02d:%02d", mins, sec)
            unit = mins.unit("mins")
            
        } else {
            str = "00:00"
            unit = mins.unit("mins")
        }
        
        return str + " " + unit
    }
    
    func unit(_ unitString: String) -> String {
        let textArray = unitString.localized().components(separatedBy: " | ")
        if textArray.count == 1 {
            return "\(textArray[0])"
            
        } else if textArray.count == 2 {
            let oneText = textArray[0]
            let manyText = textArray[1]
            if self == 1 {
                return "\(oneText)"
            } else {
                return "\(manyText)"
            }
        } else {
            return "\(unitString.localized())"
        }
    }
    
    func textNumber(one:String = "", many:String, noString:String = "") -> String {
        let unit = self.unit(many)
        if self == 0, noString.count > 0 {
            return "\(noString.localized())"
        } else {
            if self.isValueInside(unit: unit) {
                return String(format: "\(unit)", self)// view_unit = %@ View | %@ Views
            } else {
                return "\(self) \(unit)" // view_unit = View | Views
            }
        }
    }
    
    func textNumberWithComma(one:String = "", many:String, noString:String = "") -> String {
        let unit = self.unit(many)
        if self == 0, noString.count > 0 {
            return "\(noString.localized())"
        } else {
            if self.isValueInside(unit: unit) {
                return String(format: "\(unit)", self)
            } else {
                return "\(self.withCommas()) \(unit)"
            }
        }
    }
    
    func isValueInside(unit: String) -> Bool {
        return unit.range(of: "%@") != nil
    }
    
    func string() -> String? {
        return "\(self)"
    }
    
    func bool() -> Bool {
        switch self {
        case 0:
            return false
        case 1:
            return true
        default:
            return false
        }
    }
    
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value:self))
        return formattedNumber ?? String(self)
    }
}
