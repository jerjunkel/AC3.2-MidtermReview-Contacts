//
//  User.swift
//  FieldBook
//
//  Created by Jermaine Kelly on 12/6/16.
//  Copyright © 2016 Jermaine Kelly. All rights reserved.
//

import Foundation

class User{
    let userId: Int
    let recordUrl: String
    let name: String
    let role: String
    let company: String
    let email: String
    let phone: String
    let photo: String
    
    
    
    
    init(with json:[String:Any]){
        //        if let ID = json["id"] as? Int,
        //            let url = json["record_url"] as? String,
        //            let name = json["name"] as? String,
        //            let company = json["company"] as? String,
        //            let email = json["email"] as? String,
        //            let phone = json["phone"] as? String,
        //            let photo = json["picture_id"] as? String,
        //            let role = json["role"] as? String{
        //
        //            self.userId = ID
        //            self.recordUrl = url
        //            self.name = name
        //            self.role = role
        //            self.company = company
        //            self.phone = phone
        //            self.email = email
        //            self.photo = photo
        //        }else{
        //            return nil
        //        }
        
        self.userId = json["id"] as? Int ?? 10
        self.recordUrl = json["record_url"] as? String ?? ""
        self.name = json["name"] as? String ?? ""
        self.role = json["role"] as? String ?? ""
        self.company = json["company"] as? String ?? ""
        self.phone = json["phone"] as? String ?? ""
        self.email = json["email"] as? String ?? ""
        self.photo = json["picture_id"] as? String ?? ""
        
    }
    
    static func toJson()->[String:Any]{
        let json: [String:Any] = [:]
        
        return json
    }
    
    static func toData(dict: [String:Any])->Data?{
        var bodyData: Data? = Data()
        
        do{
            let json = try JSONSerialization.data(withJSONObject: dict, options: [])
            bodyData = json
        }catch{
            print(error.localizedDescription)
        }
        
        return bodyData
    }
    
    static func makeUserObjs(from data: Data)->[User]{
        var users: [User] = []
        do{
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]]{
                for userDic in json{
                    //if let userObj = User(with: userDic){
                        users.append(User(with: userDic))
                   // }
                }
            }
            
        }catch{
            print(error.localizedDescription)
        }
        
        
        
        return users
    }
    
    
}
