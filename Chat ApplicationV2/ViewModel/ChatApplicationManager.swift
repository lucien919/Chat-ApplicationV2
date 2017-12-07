//
//  ChatApplicationManager.swift
//  Chat ApplicationV2
//
//  Created by Mac on 12/6/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ChatApplicationManager{
    static let shared = ChatApplicationManager()
    var ref:DatabaseReference = Database.database().reference()
    var user:String?
    
    var differentChats:[String]? = []
    var currentChat:[Message]? = []
    var currentUsers:[Info]? = []
    
    func getCurrentUserID()->String?{
        return self.user ?? nil
    }
    
    func getSpecificMessage(_ index:Int)->String?{
        return currentChat?[index].text ?? nil
    }
    
    func getSpecificMessageUser(_ index:Int)->String?{
        return currentChat?[index].user ?? nil
    }
    
    func getSpecificMessageDate(_ index:Int)->String?{
        return currentChat?[index].date ?? nil
    }
    
    func getChatName(_ index:Int)->String?{
        return self.differentChats?[index] ?? nil
    }
    
    func getUserName(_ index:Int)->String?{
        return self.currentUsers?[index].name ?? nil
    }
    
    func getChatCount()->Int{
        return self.differentChats?.count ?? 0
    }
    
    func getChatMessageCount()->Int{
        return self.currentChat?.count ?? 0
    }
    
    func getUserCount()->Int{
        return self.currentUsers?.count ?? 0
    }
    
    func getOtherUserName(_ index:Int)->String{
        let message = currentChat?[index]
        
        var name:String = ""
        self.currentUsers?.forEach{
            if($0.id == message?.user){name = $0.name}
        }
        
        return name
    }
    
    func addMessage(_ text:String){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy,MM,dd,HH,mm,ss"
        let dateKey = dateFormatter.string(from: Date())
        
        let message = ["Message":text, "Sender":self.user]
        
        self.ref.child("Groups").child("Chat1").child("Messages").child(dateKey).setValue(message)
        
    }
    
    func downloadCurrentChat(completion:@escaping()->()){
        self.ref.child("Groups").child("Chat1").child("Messages").observe(.value){
            (snapshot) in
            var chat:[Message] = []
            if let data = snapshot.value as? Dictionary<String,[String:String]> {
                for dict in data {
                    guard let user = dict.value["Sender"] else{return}
                    guard let text = dict.value["Message"] else{return}
                    let time = dict.key
                    
                    chat.append(Message(date: time, text: text, user: user))                    
                }
                self.currentChat = chat.sorted{$0.date < $1.date}
                completion()
            }
        }
    }
    
    func downloadDifferentChats(completion:@escaping()->()){
        self.ref.child("Groups").observe(.value){
            (snapshot) in
            var chatNames:[String] = []
            if let data = snapshot.value as? Dictionary<String,Any> {
                for dict in data {
                    chatNames.append(dict.key)
                }
            self.differentChats = chatNames
            completion()
            }
        }
    }
    
    func downloadDifferentUsers(completion:@escaping()->()){
        self.ref.child("Users").observe(.value){
            (snapshot) in
            var userNames:[Info] = []
            if let data = snapshot.value as? Dictionary<String,[String:String]> {
                for dict in data {
                    guard let firstName = dict.value["First"] else{return}
                    guard let lastName = dict.value["Last"] else{return}
                    let id = dict.key
                    
                    userNames.append(Info(name: "\(firstName) \(lastName)", id: id))
                }
                self.currentUsers = userNames
                completion()
            }
        }
    }
    
    func loginToFirebase(_ email:String,_ password:String){
        LoginInfo.shared.sharedAuth.signIn(withEmail: email, password: password){
            (user, error) in
            guard error == nil else{return}
            guard let user = user else{return}
            guard let email = user.email else{return}
            LoginInfo.shared.user = User(email: email, uid: user.uid)
            let userDefaults = UserDefaults.standard
            userDefaults.set(email, forKey: Constants.kUserNameKey)
            
        }
    }
    
    func isLoggedin()->Bool{
        self.user = LoginInfo.shared.user?.uid
        return LoginInfo.shared.isLoggedIn
    }
    
    
}
