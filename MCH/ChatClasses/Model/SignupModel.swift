//
//  SignupModel.swift
//  MCH
//
//  Created by Akshay Gawade on 25/11/19.
//  Copyright © 2019 Akshay Gawade. All rights reserved.
//

import Foundation

let signupMessage = [
    "Hello Great to see you",
    "I am Anaha and I am here to guide you through the registration process",
    "What is your name?"
]


struct UserRegistration {
    var name : String?
    var surname : String?
    var mobileNo : String?
    var partnerName : String?
    var partnerMobileNo : String?
    var dateOfBirth : String?
    var numberOfChildren : Int?
    var isSecondPregnancy : Bool?
    var isMiscariage : Bool?
    var numberOfMiscariage : Int?
    var medicalHistory : [String]?
    var isSergicalHistory : Bool?
    var familyMedicalHistory : [String]?
}
