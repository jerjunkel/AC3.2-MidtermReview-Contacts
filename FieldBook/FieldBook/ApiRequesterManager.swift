//
//  ApiRequesterManager.swift
//  FieldBook
//
//  Created by Jermaine Kelly on 12/6/16.
//  Copyright © 2016 Jermaine Kelly. All rights reserved.
//

import Foundation
import UIKit

enum RequestMethod: String{
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
}

public let usersEndpoint: String = "https://api.fieldbook.com/v1/5846e949be3aad0300f65831/contacts/"

//Create Authentication base 64 encoding string
private let user: String = "key-1"
private let password: String = "ToFdux1mE7QhDPEOTO0F"
private let login: String = String(format: "%@:%@", user,password)
private let loginData = login.data(using: String.Encoding.utf8)!
private let base64LoginString = loginData.base64EncodedString()

class ApiRequestManager{
    static let manager: ApiRequestManager = ApiRequestManager()
    private init(){}
    
    let session: URLSession = URLSession(configuration: .default)
    
    func makeRequest(to endpoint: String, with method: RequestMethod = .get, body:Data? = nil, completion: @escaping (Data?, Error?)->()){
        
        guard let url: URL = URL(string: endpoint) else{ return }
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        switch method{
        case .get:
            request.setValue("application/json", forHTTPHeaderField: "Application")
        case .post:
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = body
        case .delete:
            request.setValue("application/json", forHTTPHeaderField: "Application")
        case .patch:
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = body
        case .put:
            print("Put method")
        }
        session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil{
                print("Error ===> \(error?.localizedDescription)")
                completion(nil, error)
            }
            
            if response != nil{
               // print("Response =>\(response)")
                if let responseCode = response as? HTTPURLResponse{
                    print(responseCode.statusCode)
                }
            }
            
            if let validData = data{
                print("We got data \(validData)")
                completion(validData,nil)
            }
            }.resume()
    }
    
    func getImage(from url: String, completion: @escaping (UIImage?)->()){
        guard let url: URL = URL(string: url) else { return }
        var image: UIImage? = UIImage()
        session.dataTask(with: url) { (data:Data?, response:URLResponse?, error:Error?) in
            if error != nil{
                print("Error ==> \(error?.localizedDescription)")
            }
            
            if let data = data{
                image = UIImage(data: data)
                completion(image)
            }
            }.resume()
    }
    
    func makeHTTPBody(from dict: [String:Any])->Data?{
        do{
            let body = try JSONSerialization.data(withJSONObject: dict, options: [])
            return body
        }catch{
            print(error.localizedDescription)
        }
        return nil
    }
    
}
