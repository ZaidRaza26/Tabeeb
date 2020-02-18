//
//  ChatViewController.swift
//  Tabeeb
//
//  Created by macbook on 29/10/2019.
//  Copyright © 2019 SZABIST. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import Firebase

class ChatViewController: MessagesViewController, MessagesDataSource {
    
    var messages:[Message] = []
    var conversation : Conversation!
    @IBOutlet var chooseBuuton: UIButton!
    var imagePicker = UIImagePickerController()
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Call", style: .plain, target: self, action: #selector(callButtonTapped))
        
        configureMessageCollectionView()
        configureMessageInputBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getMessages()
        
    }
    
    func configureMessageCollectionView() {
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout{
            layout.setMessageIncomingAvatarSize(.zero)
            layout.setMessageOutgoingAvatarSize(.zero)
            
            layout.setMessageIncomingMessageBottomLabelAlignment(.init(textAlignment: .left, textInsets: .init(top: 0, left: 8, bottom: 0, right: 0)))
            layout.setMessageOutgoingMessageBottomLabelAlignment(LabelAlignment.init(textAlignment: .right, textInsets: .init(top: 0, left: 0, bottom: 0, right: 8)))
        }
        scrollsToBottomOnKeyboardBeginsEditing = true // default false
        maintainPositionOnKeyboardFrameChanged = true // default false
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
    
    func configureMessageInputBar() {
        messageInputBar.delegate = self
        
        let image = UIImage(named: "plus")!
        let button = InputBarButtonItem(frame: CGRect(origin: .init(x: 2, y: -5), size: CGSize(width: image.size.width, height: image.size.height)))
        button.image = image
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.setStackViewItems([button], forStack: .left, animated: false)
        
        button.addTarget(self, action:#selector(handleRegister), for: .touchUpInside)
        
        
    }
    
    
    
    @objc func handleRegister(){
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = true
            
            present(imagePicker, animated: true, completion: nil)
        }
        
        
    }
    

    
  
    
    func isLastSectionVisible() -> Bool {
        
        guard !messages.isEmpty else { return false }
        
        let lastIndexPath = IndexPath(item: 0, section: messages.count - 1)
        
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
    
    public func currentSender() -> SenderType {
        return CurrentUser.shared
    }
    
    public func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    public func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    public func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.section % 3 == 0 {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
        return nil
    }
    
    public func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        return nil
    }
    
    public func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let dateString = message.sentDate.timeAgo(numericDates: true)
        return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }
    
}

// MARK: - MessageInputBarDelegate
extension ChatViewController: InputBarAccessoryViewDelegate {
    public func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        for component in inputBar.inputTextView.components {
            if let str = component as? String {
                sendMessage(text: str,type: 0)
                inputBar.inputTextView.text = ""
            }
        }
    }
    
    func sendMessage(text : String, type:Int){
        Firestore.firestore().collection("conversations").document(conversation.id).collection("messages").addDocument(data: ["text" :text,
                                                                                                                              "type" : type,
                                                                                                                              "senderID" : CurrentUser.shared.id,
                                                                                                                              "timestamp" : Date().timeIntervalSince1970])
        Firestore.firestore().collection("conversations").document(conversation.id).updateData(["lastMessage": text,
                                                                                                "timestamp": Date().timeIntervalSince1970])
    }
    
    func getMessages(){
        Firestore.firestore().collection("conversations").document(conversation.id).collection("messages").order(by: "timestamp", descending: false).addSnapshotListener { (snapshot, error) in
            for change in snapshot?.documentChanges ?? []{
                if change.type == DocumentChangeType.added{
                    let id = change.document.documentID
                    var dict = change.document.data()
                    dict["id"] = id
                    let message:Message = try! decode(with: dict)
                    self.messages.append(message)
                    self.messagesCollectionView.reloadData()
                    self.messagesCollectionView.scrollToBottom()
                }
                
            }
            
        }
        
    }
}


// MARK: - MessagesDisplayDelegate
extension ChatViewController: MessagesDisplayDelegate {
    
    public func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : .darkText
    }
    
    public func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedString.Key: Any] {
        return MessageLabel.defaultAttributes
    }
    
    public func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
        return [.url, .address, .phoneNumber, .date, .transitInformation]
    }
    
    public func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .blue : UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    }
    
    public func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        return MessageStyle.bubble
    }
}

// MARK: - MessagesLayoutDelegate
extension ChatViewController: MessagesLayoutDelegate {
    
    public func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return indexPath.section % 3 == 0 ? 18 : 0
    }
    
    public func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }
    
    public func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
}

extension CurrentUser: SenderType{
    var senderId: String {
        return CurrentUser.shared.id
    }
    
    var displayName: String {
        return CurrentUser.shared.name
    }
}

extension Doctor: SenderType{
    var senderId: String {
        return id
    }
    
    var displayName: String {
        return name
    }
}

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage{
            let base64String = image.jpegData(compressionQuality: 0.1)!.base64EncodedString()
            sendMessage(text: base64String, type: 1)
            
        }
        dismiss(animated: true, completion: nil)
        self.messagesCollectionView.reloadData()
        self.messagesCollectionView.scrollToBottom()

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
    
    @objc func callButtonTapped(){
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Video") as? VideoCallViewController {
        navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    
}
