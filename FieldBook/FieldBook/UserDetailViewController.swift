//
//  UserDetailViewController.swift
//  FieldBook
//
//  Created by Jermaine Kelly on 12/6/16.
//  Copyright © 2016 Jermaine Kelly. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController,UITextFieldDelegate{
    
    var user: User!
    var isEnabled: Bool = false
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
            makeTextFieldEditiable(state: isEnabled)
        }
    @IBAction func postNewUser(_ sender: UIButton) {
        removeUser()
        //addNewUser()
    }
    @IBAction func editFields(_ sender: UIBarButtonItem) {
        makeTextFieldEditiable(state: !isEnabled)
        
    }
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userCompanyTextField: UITextField!
    @IBOutlet weak var userEmailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userCompanyTextField.delegate = self
        userNameTextField.delegate = self
        userEmailTextField.delegate = self
        //setUpView()
        if user != nil{
            setUpViewWithUserInfo()
        }else{
            self.title = "Add New User"
           // self.doneBarButton.title = "Add User"
        }
    }

    
    func setUpViewWithUserInfo(){
        self.title =  ""
        self.userNameTextField.text = user.name
        self.userEmailTextField.text = user.email
        self.userCompanyTextField.text = user.company
        self.userPhoto.layer.cornerRadius = self.userPhoto.frame.width / 2
        self.userPhoto.layer.masksToBounds = true
        
        ApiRequestManager.manager.getImage(from: user.photo) { (image) in
            DispatchQueue.main.async {
                self.userPhoto.image = image
            }
        }
        
        makeTextFieldEditiable(state: isEnabled)
    }
    
    
    func makeTextFieldEditiable(state: Bool){
        self.userEmailTextField.isEnabled = state
        self.userNameTextField.isEnabled = state
        self.userCompanyTextField.isEnabled = state
    }
    
    func addNewUser(){
        let userName = userNameTextField.text
        let userCompany = userCompanyTextField.text
        let userEmail = userEmailTextField.text
        
        let body = ["name":userName!,
                    "company":userCompany!,
                    "email":userEmail!]
        print(body)
        let jsonbody = User.toData(dict: body)
        
        ApiRequestManager.manager.makeRequest(to: usersEndpoint, with: .post, body: jsonbody) { (data) in
            print("Post made")
        }
    }
    
    func removeUser(){
        ApiRequestManager.manager.makeRequest(to: usersEndpoint + String(user.userId), with: .delete) { (_) in
            print("User Deleted")
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return self.string(string, containsOnly: CharacterSet.letters.union(CharacterSet.whitespaces))
    }
    
    //MARK:- Utilites
    func string(_ string: String, containsOnly characterSet: CharacterSet) -> Bool {
        // fill in code
        for character in string.unicodeScalars{
            if characterSet.contains(character){
                return true
            }
        }
        return false
    }

  
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
