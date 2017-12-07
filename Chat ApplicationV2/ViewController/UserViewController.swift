//
//  UserViewController.swift
//  Chat ApplicationV2
//
//  Created by Mac on 12/6/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    
    @IBOutlet weak var userTableView:UITableView!
    
    var userNames:[String] = ["user1","user2","user3"]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.userTableView.delegate = self
        self.userTableView.dataSource = self
        
        self.aesthetics()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ChatApplicationManager.shared.downloadDifferentUsers {
            DispatchQueue.main.async {
                self.userTableView.reloadData()
            }
        }
    }
    
    func aesthetics(){
        self.userTableView.backgroundColor = UIColor.black
        self.view.backgroundColor = UIColor.black
    }

}

typealias UserTableViewFunctions = UserViewController
extension UserTableViewFunctions: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChatApplicationManager.shared.getUserCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") else{fatalError("Death")}
        
        cell.textLabel?.text = ChatApplicationManager.shared.getUserName(indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor.magenta
        cell.selectedBackgroundView = UIView()
        cell.selectedBackgroundView?.backgroundColor = UIColor.magenta
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
