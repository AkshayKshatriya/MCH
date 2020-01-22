//
//  NetworkLayer.swift
//  Mutterfly
//
//  Created by Akshay Gawade on 02/08/17.
//  Copyright © 2017 Mutterfly. All rights reserved.
//

import UIKit
import Alamofire
import SwiftKeychainWrapper
import SwiftyJSON


class NetworkLayer: NSObject {
    
    static let shared = NetworkLayer()
    var request : DataRequest?
    
    func getRequestWith(_ parameters: [String: Any]?,_ url: String,completionHandler : @escaping (JSON?, Error?, DataRequest?) -> Void)  -> DataRequest {
        debugPrint("url = \(url)")
        self.request = Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil ).responseJSON
            { response in
                debugPrint(response.result)
                
                switch response.result{
                case .success:
                    do
                    {
                        let json = try JSON(data: response.data!)
                        completionHandler(json, nil, self.request)
                    }
                    catch let error {
                        debugPrint(error)
                        completionHandler(nil, response.error, self.request)
                    }
                case .failure(_):
                    completionHandler(nil, response.error, self.request)
                }
        }
        return request!
    }
    
}
