//
//	Datum.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import SwiftyJSON


class Datum : NSObject, NSCoding{

	var id : String!
	var createdAt : String!
	var deletedOn : String!
	var family : String!
	var isDeleted : Int!
	var key : String!
	var listType : String!
	var nextQuestion : NextQuestion!
	var option : Option!
	var questionId : Int!
	var questionText : String!
	var showList : Int!
	var status : Int!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		id = json["_id"].stringValue
		createdAt = json["createdAt"].stringValue
		deletedOn = json["deletedOn"].stringValue
		family = json["family"].stringValue
		isDeleted = json["isDeleted"].intValue
		key = json["key"].stringValue
		listType = json["listType"].stringValue
		let nextQuestionJson = json["nextQuestion"]
		if !nextQuestionJson.isEmpty{
			nextQuestion = NextQuestion(fromJson: nextQuestionJson)
		}
		let optionJson = json["option"]
		if !optionJson.isEmpty{
			option = Option(fromJson: optionJson)
		}
		questionId = json["questionId"].intValue
		questionText = json["questionText"].stringValue
		showList = json["showList"].intValue
		status = json["status"].intValue
	}

	/**
	 * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> [String:Any]
	{
		var dictionary = [String:Any]()
		if id != nil{
			dictionary["_id"] = id
		}
		if createdAt != nil{
			dictionary["createdAt"] = createdAt
		}
		if deletedOn != nil{
			dictionary["deletedOn"] = deletedOn
		}
		if family != nil{
			dictionary["family"] = family
		}
		if isDeleted != nil{
			dictionary["isDeleted"] = isDeleted
		}
		if key != nil{
			dictionary["key"] = key
		}
		if listType != nil{
			dictionary["listType"] = listType
		}
		if nextQuestion != nil{
			dictionary["nextQuestion"] = nextQuestion.toDictionary()
		}
		if option != nil{
			dictionary["option"] = option.toDictionary()
		}
		if questionId != nil{
			dictionary["questionId"] = questionId
		}
		if questionText != nil{
			dictionary["questionText"] = questionText
		}
		if showList != nil{
			dictionary["showList"] = showList
		}
		if status != nil{
			dictionary["status"] = status
		}
		return dictionary
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         id = aDecoder.decodeObject(forKey: "_id") as? String
         createdAt = aDecoder.decodeObject(forKey: "createdAt") as? String
         deletedOn = aDecoder.decodeObject(forKey: "deletedOn") as? String
         family = aDecoder.decodeObject(forKey: "family") as? String
         isDeleted = aDecoder.decodeObject(forKey: "isDeleted") as? Int
         key = aDecoder.decodeObject(forKey: "key") as? String
         listType = aDecoder.decodeObject(forKey: "listType") as? String
         nextQuestion = aDecoder.decodeObject(forKey: "nextQuestion") as? NextQuestion
         option = aDecoder.decodeObject(forKey: "option") as? Option
         questionId = aDecoder.decodeObject(forKey: "questionId") as? Int
         questionText = aDecoder.decodeObject(forKey: "questionText") as? String
         showList = aDecoder.decodeObject(forKey: "showList") as? Int
         status = aDecoder.decodeObject(forKey: "status") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    func encode(with aCoder: NSCoder)
	{
		if id != nil{
			aCoder.encode(id, forKey: "_id")
		}
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "createdAt")
		}
		if deletedOn != nil{
			aCoder.encode(deletedOn, forKey: "deletedOn")
		}
		if family != nil{
			aCoder.encode(family, forKey: "family")
		}
		if isDeleted != nil{
			aCoder.encode(isDeleted, forKey: "isDeleted")
		}
		if key != nil{
			aCoder.encode(key, forKey: "key")
		}
		if listType != nil{
			aCoder.encode(listType, forKey: "listType")
		}
		if nextQuestion != nil{
			aCoder.encode(nextQuestion, forKey: "nextQuestion")
		}
		if option != nil{
			aCoder.encode(option, forKey: "option")
		}
		if questionId != nil{
			aCoder.encode(questionId, forKey: "questionId")
		}
		if questionText != nil{
			aCoder.encode(questionText, forKey: "questionText")
		}
		if showList != nil{
			aCoder.encode(showList, forKey: "showList")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}

	}

}
