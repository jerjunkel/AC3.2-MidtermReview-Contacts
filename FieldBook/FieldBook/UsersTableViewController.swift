//
//  UsersTableViewController.swift
//  FieldBook
//
//  Created by Jermaine Kelly on 12/6/16.
//  Copyright © 2016 Jermaine Kelly. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 200
        self.refreshControl?.addTarget(self, action: #selector(self.fetchUsers), for: .valueChanged)
        fetchUsers()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "usersCell", for: indexPath) as! UserTableViewCell
        
        cell.user = users[indexPath.row]
        return cell
    }
    
    //MARK:- Pull to Refresh Utilities
    func handleRefresh(){
        self.refreshControl?.beginRefreshing()
        fetchUsers()
    }
    
    func fetchUsers(){
        ApiRequestManager.manager.makeRequest(to: usersEndpoint) { (data,_) in
            if let data = data{
                self.users = User.makeUserObjs(from: data)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let userVC = segue.destination as? UserDetailViewController {
            if segue.identifier == "showUserDetail"{
                if let index = tableView.indexPathForSelectedRow{
                    userVC.user = users[index.row]
                }
            }
        }
        
        
        
        
    }
    
}
