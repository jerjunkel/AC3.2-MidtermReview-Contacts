//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport


// MARK: Model
struct PlaceholderPost {
  let userID: Int
  let id: Int
  let title: String
  let body: String
}

let userPostsURL = URL(string: "https://jsonplaceholder.typicode.com/posts")!


func getRequestWithURLSession() {
  
  
  let session = URLSession(configuration: .default)
  session.dataTask(with: userPostsURL) { (data: Data?, response: URLResponse?, error: Error?) in
    
    if error != nil {
      print("error: \(error!)")
    }
    
    if response != nil {
      let httpResponse = (response! as! HTTPURLResponse)
      print("Response status code: \(httpResponse.statusCode)")
    }
    
    if data != nil {
      
      // option 1: Any?
      let jsonNil = try? JSONSerialization.jsonObject(with: data!, options: [])
      
      // option 2: Any
      if let jsonBound = try? JSONSerialization.jsonObject(with: data!, options: [] ) {
        print("bound")
      }
      
      // option 3: Any w/ Exception Handling
      do {
        let jsonThrowing = try JSONSerialization.jsonObject(with: data!, options: []) as? [[String:Any]]
        
//        if let jsonThrowingArray = jsonThrowing as? [[String:Any]] {
//          print("JSON ARRAY: \(jsonThrowingArray)")
        
          var postsArray: [PlaceholderPost] = []
          for jsonThrowingElement in jsonThrowing! {
            guard let userID: Int = jsonThrowingElement["userId"] as? Int,
              let id: Int = jsonThrowingElement["id"] as? Int,
              let title: String = jsonThrowingElement["title"] as? String,
              let body: String = jsonThrowingElement["body"] as? String else {
                continue
            }
            postsArray.append( PlaceholderPost(userID: userID, id: id, title: title, body: body) )
            
//          }
          
          print("Posts: \(postsArray)")
          
        }
      }
      catch {
        print("Error serializing: \(error)")
      }
      
    }
    
    }.resume() // kicks the request
  
}

func getRequestWithURLRequest() {
  
  var request: URLRequest = URLRequest(url: userPostsURL)
  request.httpMethod = "GET"
  request.addValue("application/json", forHTTPHeaderField: "Accept")
  
  let session: URLSession = URLSession(configuration: .default)
  session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
    if error != nil {
      print("error: \(error!)")
    }
    
    if response != nil {
      let httpResponse = (response! as! HTTPURLResponse)
      print("Response status code: \(httpResponse.statusCode)")
    }
    
    if data != nil {
      
      // option 1: Any?
      let jsonNil = try? JSONSerialization.jsonObject(with: data!, options: [])
      
      // option 2: Any
      if let jsonBound = try? JSONSerialization.jsonObject(with: data!, options: [] ) {
        print("bound")
      }
      
      // option 3: Any w/ Exception Handling
      do {
        let jsonThrowing = try JSONSerialization.jsonObject(with: data!, options: []) as? [[String:Any]]
        
        //        if let jsonThrowingArray = jsonThrowing as? [[String:Any]] {
        //          print("JSON ARRAY: \(jsonThrowingArray)")
        
        var postsArray: [PlaceholderPost] = []
        for jsonThrowingElement in jsonThrowing! {
          guard let userID: Int = jsonThrowingElement["userId"] as? Int,
            let id: Int = jsonThrowingElement["id"] as? Int,
            let title: String = jsonThrowingElement["title"] as? String,
            let body: String = jsonThrowingElement["body"] as? String else {
              continue
          }
          postsArray.append( PlaceholderPost(userID: userID, id: id, title: title, body: body) )
          
          //          }
          
          print("Posts: \(postsArray)")
          
        }
      }
      catch {
        print("Error serializing: \(error)")
      }
      
    }
    
  }.resume()
  
}

func postRequestWithURLRequest() {
  
  var request: URLRequest = URLRequest(url: userPostsURL)
  request.addValue("application/json", forHTTPHeaderField: "Accept")
  request.httpMethod = "POST"
  
  let bodyDict: [String : Any] = [
    "userId" : 10,
    "title" : "New Post Title",
    "body" : "New Post Body"
  ]
  
  do {
    let bodyData: Data = try JSONSerialization.data(withJSONObject: bodyDict, options: [])
    
    request.httpBody = bodyData
  }
  catch {
    print("Error converting to data: \(error)")
  }

  let session: URLSession = URLSession(configuration: .default)
  session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
    
    if error != nil {
      print(error!)
    }
    
    if data != nil {
      
      do {
        let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]
        
        guard
          let userId = json!["userId"] as? Int,
          let id = json!["id"] as? Int,
          let title = json!["title"] as? String,
          let body = json!["body"] as? String else {
            return
        }
        
        let createdPost = PlaceholderPost(userID: userId, id: id, title: title, body: body)
        print(createdPost)
        
      }
      catch {
        print("Error serializing: \(error)")
      }
      
      
    }
    
    }.resume()
  
}

//getRequestWithURLSession()
//getRequestWithURLRequest()
postRequestWithURLRequest()

PlaygroundPage.current.needsIndefiniteExecution = true
