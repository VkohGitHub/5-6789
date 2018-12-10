//
//  ViewController.swift
//  Flash Chat
//
//  Created by Angela Yu on 29/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import Firebase


class ChatViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // Declare instance variables here
    var messageArray : [Message] = [Message]()
    
    
    // We've pre-linked the IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Set yourself as the delegate and datasource here:
            messageTableView.delegate = self
            messageTableView.dataSource = self
        
        
        //TODO: Set yourself as the delegate of the text field here:
            messageTextfield.delegate = self
        
      
        //TODO: Set the tapGesture here:
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
            messageTableView.addGestureRecognizer(tapGesture)

 
        //TODO: Register your MessageCell.xib file here:
        
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCell")
        
        configureTableView()
      
       
       retrieveMessages()
        
    }
    
    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    
    
    //TODO: Declare cellForRowAtIndexPath here:
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! CustomMessageCell
        
      //  let messageArray = ["First Message", "Second Message", "Third Message"]
        
        // cell.messageBody.text = messageArray[indexPath.row]
        
        //cell.avatarImageView.image = UIImage(name :"egg")
        
        
        return cell
    }
    
    
    //TODO: Declare numberOfRowsInSection here:
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 3
        
        return messageArray.count
    }
    
    //TODO: Declare tableViewTapped here:
    
    func tableViewTapped(){
        
        messageTextfield.endEditing(true)
    }
    
    
    //TODO: Declare configureTableView here:
    
    func configureTableView(){
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 120.0
    }
    
    
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods
   
    //TODO: Declare textFieldDidBeginEditing here:
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        heightConstraint.constant = 308 // textfield is 50pts and keyboard is 258 pts
        view.layoutIfNeeded()
        
    UIView.animate(withDuration: 0.5) {
        self.heightConstraint.constant = 308
        self.view.layoutIfNeeded()
        }
    }
 
   
    //TODO: Declare textFieldDidEndEditing here:
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    
        UIView.animate(withDuration: 0.5) {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        }
    // these lines of codes will still result in nothing because the compiler needs to know when does the user tab away from the text field.
    // This action is indicated in the section "Set the tapGesture here."
    }
    
    
    
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        messageTextfield.endEditing(true)
        
    //TODO: Send the message to Firebase and save it in our database
        
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
        
        let messagesDB = Database.database().reference().child("messages")
        
        let messageDictionary = ["Sender" : Auth.auth().currentUser!.email,
                                 "MessageBody" : messageTextfield.text!]
        
        messagesDB.childByAutoId().setValue(messageDictionary) {
            
            (error , reference) in
            
            if error != nil {
                print(error)
            } else {
                
                print("Message saved successfully!")
                
                    self.messageTextfield.isEnabled =  true
                    self.sendButton.isEnabled = true
                    self.messageTextfield.text = ""
            }
        }
    }
    
    //TODO: Create the retrieveMessages method here:
    func retrieveMessages(){

       let messageDB = Database.database().reference().child("Messages")
    
        //have to observe this database to act when new messages are added
        
    
       //messageDB.observe(.childAdded) { (snapshot) in
        messageDB.observe(.childAdded, with: { (snapshot) in
           
           let snapshotValue = snapshot.value as! Dictionary<String,String>
            
                let text = snapshotValue["MessageBody"]!
                let sender = snapshotValue["Sender"]!
            
           print(text, sender)
          print("printing")
        /*

            let message = Message()
                message.messageBody =  text
                message.sender = sender
            
            self.messageArray.append(message)
            
            self.configureTableView()
            self.messageTableView.reloadData()
  */
            
        })
 
   }
  
  
 /*
    func retrieveMessages() {
        
        let messageDB = Database.database().reference().child("Messages")
        
        messageDB.observe(.childAdded) { (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            let text = snapshotValue["MessageBody"]!
            let sender = snapshotValue["Sender"]!
            
            let message = Message()
            message.messageBody = text
            message.sender = sender
            
            self.messageArray.append(message)
            
            
            self.configureTableView()
            self.messageTableView.reloadData()
            
            
            
        }
        
    }
    
 */
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        //TODO: Log out the user and send them back to WelcomeViewController
        
        do{
            try Auth.auth().signOut()
            
            navigationController?.popToRootViewController(animated: true)// back to WelcomeViewController which is the root view controller.
        }
        catch {
            print("error, there was a problem signing out.")
        }
        
        
        
        
    }
    


}
