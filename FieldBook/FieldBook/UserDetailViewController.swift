//
//  UserDetailViewController.swift
//  FieldBook
//
//  Created by Jermaine Kelly on 12/6/16.
//  Copyright © 2016 Jermaine Kelly. All rights reserved.
//

import UIKit

class UserDetailViewController: UIViewController,UITextFieldDelegate{
    
    enum UserViewState:String{
        case update, add, delete
    }
    
    var user: User!
    var isEnabled: Bool = false
    var userState: UserViewState? {
        didSet{
            userActionButton.setTitle(actionButtonText, for: .normal)
        }
    }
    
    //Sets the button title
    var actionButtonText: String{
        switch userState!{
        case .add: return "Add User"
        case .delete:
//            userActionButton.titleLabel?.textColor = .red
            userActionButton.setTitleColor(.red, for: .normal)
            return "Remove User"
        case .update: return "Update User"
        }
    }
    
    //Calculated property to get textfield inputs
    var userTexFieldInputs: [String:String]{
        let userName = userNameTextField.text
        let userCompany = userCompanyTextField.text
        let userEmail = userEmailTextField.text
        
        let body = ["name":userName!.trimmingCharacters(in: CharacterSet.whitespaces),
                    "company":userCompany!.trimmingCharacters(in: CharacterSet.whitespaces),
                    "email":userEmail!.trimmingCharacters(in: CharacterSet.whitespaces),
                    "picture_id":getRandomUserImage()]
        return body
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        makeTextFieldEditiable(state: isEnabled)
    }
    @IBAction func postNewUser(_ sender: UIButton) {
        switch userState!{
        case .add: addNewUser()
        case .update: updateUser()
        case .delete: removeUser()
        }
    }
    @IBAction func editFields(_ sender: UIBarButtonItem) {
        userState = .update
        makeTextFieldEditiable(state: !isEnabled)
    }
    
    @IBOutlet weak var userActionButton: UIButton!
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
        
        if user != nil{
            setUpViewWithUserInfo()
            userState = .delete
        }else{
            self.title = "Add New User"
            userState = .add
        }
        //userActionButton.titleLabel?.text = setActionButtonText()
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
        print(userTexFieldInputs)
        let jsonbody = ApiRequestManager.manager.makeHTTPBody(from: userTexFieldInputs)
        ApiRequestManager.manager.makeRequest(to: usersEndpoint, with: .post, body: jsonbody) { (data) in
            print("Post made")
        }
        self.showAlert(with: .add)
        
    }
    
    func updateUser(){
        let jsonbody = ApiRequestManager.manager.makeHTTPBody(from: userTexFieldInputs)
        ApiRequestManager.manager.makeRequest(to: usersEndpoint + String(user.userId), with: .patch, body: jsonbody) { (data) in
            print("Update made")
        }
        self.showAlert(with: .update)
    }
    
    func removeUser(){
        ApiRequestManager.manager.makeRequest(to: usersEndpoint + String(user.userId), with: .delete) { (_) in
            print("User Deleted")
        }
        self.showAlert(with: .delete)
    }
    
    func showAlert(with message: UserViewState){
        let alertController = UIAlertController(title: "Action", message: "User was \(message.rawValue)ed", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func getRandomUserImage()->String{
        let picNumber: Int = Int(arc4random_uniform(100))
        let gender: String = ["men","women"][Int(arc4random_uniform(2))]
        return "https://randomuser.me/api/portraits/\(gender)/\(picNumber).jpg"
    }
    //
    //    func setActionButtonText()-> String{
    //        switch userState!{
    //        case .add: return "Add User"
    //        case .delete: return "Remove User"
    //        case .update: return "Update User"
    //        }
    //    }
    
    //    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    //        return self.string(string, containsOnly: CharacterSet.letters.union(CharacterSet.whitespaces))
    //    }
    //
    //    //MARK:- Utilites
    //    func string(_ string: String, containsOnly characterSet: CharacterSet) -> Bool {
    //        // fill in code
    //        for character in string.unicodeScalars{
    //            if characterSet.contains(character){
    //                return true
    //            }
    //        }
    //        return false
    //    }
    //
    
}
