//
//  ProfileResult.swift
//  DiscussionBoard
//
//  Created by Songwut Maneefun on 24/1/2564 BE.
//

import Foundation
import ObjectMapper

class ProfileResult: Mappable {
    var image = ""
    var desc = ""
    var firstName = ""
    var lastName = ""
    var tel = ""
    var id = 0
    var gender = 0
    var email = ""
    var birthday = ""
    var identifier = NSNumber(value: 0)
    var isResetPassword = NSNumber(value: 0)
    var position = ""
    var organization = ""
    var employeeId:String = ""
    var isSuperuser = false
    var isActive = true
    var isAcceptedActiveConsent = true
    var department = ""
    
    var dateJoined = ""
    var dateStart = ""
    var language = ""
    
    var username = ""
    var password = ""
    
    lazy var name: String = { [unowned self] in
        return "\(self.firstName) \(self.lastName)"
        }()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        username                    <- map["username"]
        password                    <- map["password"]
        id                          <- map["id"]
        desc                        <- map["desc"]
        image                       <- map["image"]
        firstName                   <- map["first_name"]
        lastName                    <- map["last_name"]
        tel                         <- map["tel"]
        gender                      <- map["gender"]
        email                       <- map["email"]
        birthday                    <- map["birthday"]
        identifier                  <- map["id"]
        language                    <- map["language"]
        isResetPassword             <- map["is_reset_password"]
        position                    <- map["position"]
        organization                <- map["organization"]
        employeeId                  <- map["employee_id"]
        isSuperuser                 <- map["is_superuser"]
        isActive                    <- map["is_active"]
        isAcceptedActiveConsent     <- map["is_accepted_active_consent"]
        department                  <- map["department"]
        dateStart                   <- map["date_start"]
        dateJoined                  <- map["date_joined"]
    }
    
    class func with(_ dict: [String : Any]) -> ProfileResult? {
        let item = Mapper<ProfileResult>().map(JSON: dict)
        return item
    }
}
