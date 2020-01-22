//
//	Option.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON


class Option : NSObject, NSCoding{

	var userInput : Bool!
	var yesNo : Bool!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		userInput = json["userInput"].boolValue
		yesNo = json["yesNo"].boolValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if userInput != nil{
			dictionary["userInput"] = userInput
		}
		if yesNo != nil{
			dictionary["yesNo"] = yesNo
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         userInput = aDecoder.decodeObject(forKey: "userInput") as? Bool
         yesNo = aDecoder.decodeObject(forKey: "yesNo") as? Bool

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if userInput != nil{
			aCoder.encode(userInput, forKey: "userInput")
		}
		if yesNo != nil{
			aCoder.encode(yesNo, forKey: "yesNo")
		}

	}

}