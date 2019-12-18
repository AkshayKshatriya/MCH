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
    "What is your first name?",
    "Hey {fname}, May I know your mobile number?",
    "Thank you {fname}, We are verifying your mobile number by sending OTP. Let me know OTP once you receive it?",
    "Thank you {fname}, , we have verified your mobile number.\n{fname}, may I know your surname?",
    "Thank you {fname} {lname}, May I know your partner’s first name?",
    "May I know your partner’s last name?",
    "And {partner_fname}’s mobile number?",
    "Thank you {fname} {lname}, I understand you are here for a pregnancy consultation. May I know your Date of birth?",
    "{fname}, how many children(s) do you have?",
    "So, is this your second pregnancy?",
    "So, have you had any miscarriage or abortion, that you are aware about?",
    "How many miscarriage/s?",
    "{fname}, do you have any major medical history, If yes, please select from the list",
    "{fname}, do you have any major surgical history, If yes, please select from the list",
    "Does your family have any major medical history, If yes, please select from the list",
    "{fname}, do you have any allergies, Please select from the list",
    "medications for long time (more than 4 months), if yes please select from the list",
    "{fnme}, are you currently taking any medications?, if yes please select from the list",
    "Thank you Priya, may I know date of your last menstrual period?",
    "Does your home pregnancy test shows you’re pregnant?",
    "Do you know your blood group?",
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
