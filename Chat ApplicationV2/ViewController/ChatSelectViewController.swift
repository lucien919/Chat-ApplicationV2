//
//  ChatSelectViewController.swift
//  Chat ApplicationV2
//
//  Created by Mac on 12/5/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class ChatSelectViewController: UIViewController {
    
    @IBOutlet weak var chatSelectTableView:UITableView!
    var mainViewController:UIViewController!
    
    var chatNames:[String] = ["chat1","chat2","chat3","chat4","chat5"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.chatSelectTableView.delegate = self
        self.chatSelectTableView.dataSource = self
        
        self.aesthetics()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ChatApplicationManager.shared.downloadDifferentChats{
            DispatchQueue.main.async {
                self.chatSelectTableView.reloadData()
            }
        }
    }
    
    func aesthetics(){
        self.chatSelectTableView.backgroundColor = UIColor.black
        self.view.backgroundColor = UIColor.black
    }
}

typealias ChatSelectTableViewFunctions = ChatSelectViewController
extension ChatSelectTableViewFunctions: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChatApplicationManager.shared.getChatCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatSelectCell") else{fatalError("Death")}
        
        cell.textLabel?.text = ChatApplicationManager.shared.getChatName(indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor.cyan
        cell.selectedBackgroundView = UIView()
        cell.selectedBackgroundView?.backgroundColor = UIColor.cyan
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
