//
//	Question.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON


class Question : NSObject, NSCoding{

	var data : [Datum]!
	var status : Status!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		data = [Datum]()
		let dataArray = json["data"].arrayValue
		for dataJson in dataArray{
			let value = Datum(fromJson: dataJson)
			data.append(value)
		}
		let statusJson = json["status"]
		if !statusJson.isEmpty{
			status = Status(fromJson: statusJson)
		}
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if data != nil{
			var dictionaryElements = [[String:Any]]()
			for dataElement in data {
				dictionaryElements.append(dataElement.toDictionary())
			}
			dictionary["data"] = dictionaryElements
		}
		if status != nil{
			dictionary["status"] = status.toDictionary()
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         data = aDecoder.decodeObject(forKey: "data") as? [Datum]
         status = aDecoder.decodeObject(forKey: "status") as? Status

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if data != nil{
			aCoder.encode(data, forKey: "data")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}

	}

}
