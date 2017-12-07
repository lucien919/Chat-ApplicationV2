//
//  ViewController.swift
//  Chat ApplicationV2
//
//  Created by Mac on 12/3/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {
    @IBOutlet weak var chatTableView:UITableView!
    @IBOutlet weak var userInput: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var toolBarBottomConstraint:NSLayoutConstraint!
    
    var toolbarOriginalConstraints:CGFloat?
    var messages:[String]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.chatTableView.delegate = self
        self.chatTableView.dataSource = self
        self.userInput.delegate = self
        self.chatTableView.register(ChatBubble.nib, forCellReuseIdentifier: "ChatBubbleUser")
        self.chatTableView.register(ChatBubbleOther.nib, forCellReuseIdentifier: "ChatBubbleOther")
        
        self.toolbarOriginalConstraints = toolBarBottomConstraint.constant
        
        self.aesthetics()
        
        self.notificationSetup()
    }
    
    func aesthetics(){
        self.chatTableView.backgroundColor = UIColor.black
        self.view.backgroundColor = UIColor.black
        self.toolBar.barTintColor = UIColor.darkGray
        self.userInput.backgroundColor = UIColor.black
        self.userInput.textColor = UIColor.magenta
        self.userInput.layer.borderWidth = 1.0
        self.userInput.layer.borderColor = UIColor.magenta.cgColor
    }
    
    func notificationSetup(){
        let appearNotification = Notification(name: NSNotification.Name(rawValue: "keyboardWillAppear"), object: nil)
        NotificationCenter.default.post(appearNotification)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: .UIKeyboardWillShow , object: nil)
        
        let disappearNotification = Notification(name: NSNotification.Name(rawValue: "keyboardWillDisappear"), object: nil)
        NotificationCenter.default.post(disappearNotification)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ChatApplicationManager.shared.downloadCurrentChat{
            DispatchQueue.main.async {
                self.chatTableView.reloadData()
                self.scrollToBottom()
            }
        }
        self.setNavigationBarItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func clickSend(_ sender:AnyObject) {
        guard let input = self.userInput.text else{return}
        guard input.count > 0 else{return}
        ChatApplicationManager.shared.addMessage(input)
        self.userInput.text = ""
        self.chatTableView.reloadData()
        self.scrollToBottom()
    }
    
    
}

typealias KBAnimationFunctions = ChatViewController
extension KBAnimationFunctions{
    
    @objc func keyboardWillAppear(_ sender:AnyObject){
        guard let notificationInfo = (sender as? NSNotification)?.userInfo else{return}
        guard let duration = notificationInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double else{return}
        guard let keyboardFrame = (notificationInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{return}
        
        animateTheConstraintUp(keyboardFrame.height, duration)
    }
    
    func animateTheConstraintUp(_ height:CGFloat,_ duration:Double){
        UIView.animate(withDuration: duration){
            self.toolBarBottomConstraint.constant = -height
            self.view.layoutIfNeeded()
            //let offset = CGPoint(x: 0, y: height)
            //self.chatTableView.setContentOffset(offset, animated: false)
            self.scrollToBottom()
        }
    }
    
    @objc func keyboardWillDisappear(_ sender:AnyObject){
        guard let notificationInfo = (sender as? NSNotification)?.userInfo else{return}
        guard let duration = notificationInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double else{return}
        guard let keyboardFrame = (notificationInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{return}
        
        animateTheConstraintDown(keyboardFrame.height, duration)
    }
    
    func animateTheConstraintDown(_ height:CGFloat,_ duration:Double){
        UIView.animate(withDuration: duration){
            guard let constraints = self.toolbarOriginalConstraints else{return}
            self.toolBarBottomConstraint.constant = constraints
            self.view.layoutIfNeeded()
            self.scrollToBottom()
        }
    }
}

typealias ChatTableFunctions = ChatViewController
extension ChatTableFunctions: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ChatApplicationManager.shared.getChatMessageCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = ChatApplicationManager.shared.getSpecificMessageUser(indexPath.row)
        guard user == ChatApplicationManager.shared.getCurrentUserID() else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatBubbleOther") as? ChatBubbleOther else{fatalError("Death")}
            
            guard let message = ChatApplicationManager.shared.getSpecificMessage(indexPath.row) else{return cell}
            cell.label.text = message
            cell.name.text = ChatApplicationManager.shared.getOtherUserName(indexPath.row)
            
            return cell
            
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatBubbleUser") as? ChatBubble else{fatalError("Death")}
        
        guard let message = ChatApplicationManager.shared.getSpecificMessage(indexPath.row) else{return cell}
        cell.label.text = message
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = UIView()
        if(cell.reuseIdentifier=="ChatBubbleUser"){
            cell.selectedBackgroundView?.backgroundColor = UIColor.magenta
        }else{
            cell.selectedBackgroundView?.backgroundColor = UIColor.cyan
        }
        
    }
    
    func scrollToBottom(){
        DispatchQueue.global(qos: .background).async {
            let count = ChatApplicationManager.shared.getChatMessageCount()
            guard count > 0 else{return}
            let indexPath = IndexPath(row: count-1, section: 0)
            DispatchQueue.main.async {
                self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

typealias TextFieldFunctions = ChatViewController
extension TextFieldFunctions: UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if userInput.text != nil{
            guard string != "\n" else{
                //textField.resignFirstResponder()
                self.clickSend(self)
                return false
            }
            return true
        }
        return false
    }
    
}

