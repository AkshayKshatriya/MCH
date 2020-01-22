//
//	NextQuestion.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON


class NextQuestion : NSObject, NSCoding{

	var defaultField : Int!
	var no : Int!
	var yes : Int!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		defaultField = json["default"].intValue
		no = json["no"].intValue
		yes = json["yes"].intValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if defaultField != nil{
			dictionary["default"] = defaultField
		}
		if no != nil{
			dictionary["no"] = no
		}
		if yes != nil{
			dictionary["yes"] = yes
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         defaultField = aDecoder.decodeObject(forKey: "default") as? Int
         no = aDecoder.decodeObject(forKey: "no") as? Int
         yes = aDecoder.decodeObject(forKey: "yes") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if defaultField != nil{
			aCoder.encode(defaultField, forKey: "default")
		}
		if no != nil{
			aCoder.encode(no, forKey: "no")
		}
		if yes != nil{
			aCoder.encode(yes, forKey: "yes")
		}

	}

}