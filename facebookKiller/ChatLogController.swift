//
//  ChatLogController.swift
//  facebookKiller
//
//  Created by Valeriy Trusov on 15.03.2022.
//

import UIKit
import CoreData

class ChatLogController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {
   
   private var cellId = "cellId"
    var friend: Friend? {
        
        didSet{
            
            navigationItem.title = friend?.name

        }
    }
    
  
    
    let messageInputContainerView: UIView = {
        
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let inputTextField: UITextField = {
        
        let textField = UITextField()
        textField.placeholder = "Enter message"
        textField.autocorrectionType = .no
        textField.keyboardType = .emailAddress
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
   lazy var sendButton: UIButton = {
        
        let button = UIButton(type: .system)
        
        button.setTitle("Send", for: .normal)
        button.setTitleColor(UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1.0), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()
    
   lazy var fetchResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Message")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "friend.name = %@", self.friend!.name!)
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
       frc.delegate = self
        return frc
    }()
    
    var blockOperations = [BlockOperation]()
   
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        if type == .insert {
            blockOperations.append(BlockOperation(block: {
                self.collectionView.insertItems(at: [newIndexPath!])
            }))
            
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView.performBatchUpdates {
            
            for operation in blockOperations {
                
                operation.start()
            }
            
        } completion: { (completed) in
            
            let lastItemParametr = self.fetchResultsController.sections![0].numberOfObjects - 1
            let indexPath = IndexPath(item: lastItemParametr, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
        }

    }
    
    var bottomContraint: NSLayoutConstraint?
    var collectionViewBottomContraint: NSLayoutConstraint?
    
    @objc private func simulate() {
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
         FriendsController.createMessageWithText(text: "Here's a text message that was send a few minutes ago...", friend: friend!, minutesAgo: 2, context: context)
        
        FriendsController.createMessageWithText(text: "Here's a text message that was send a few minutes ago...", friend: friend!, minutesAgo: 2, context: context)
        do {
            
            try (context.save())
            
            
        }catch let err {
            
            print(err)
        }
    }
    
   @objc private func handleSend() {
        
       let delegate = UIApplication.shared.delegate as! AppDelegate
       let context = delegate.persistentContainer.viewContext
       
        FriendsController.createMessageWithText(text: inputTextField.text!, friend: friend!, minutesAgo: 0, context: context, isSender: true)
       
       do {
           
           try (context.save())
           inputTextField.text = nil


           
       }catch let err {
           
           print(err)
       }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            
            try  fetchResultsController.performFetch()

        }catch let err{
            
           print(err)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Simulate", style: .plain, target: self, action: #selector(simulate))
        
        tabBarController?.tabBar.isHidden = true
        
        collectionView.backgroundColor = .white
        collectionView.register(ChatLogCell.self, forCellWithReuseIdentifier: cellId)
        
        view.addSubview(messageInputContainerView)
        NSLayoutConstraint.activate([
            messageInputContainerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            messageInputContainerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            messageInputContainerView.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        bottomContraint = NSLayoutConstraint(item: messageInputContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomContraint!)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: messageInputContainerView.topAnchor)
        ])
        
        setupInputComponents()
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIWindow.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIWindow.keyboardWillHideNotification, object: nil)
        
        
    }
    
    @objc func handleKeyboardNotification(notification: Notification) {
        
        if let userInfo = notification.userInfo {
            
           if let keyboard: NSValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                
               let isKeyboardShowing = notification.name == UIWindow.keyboardWillShowNotification
               
               bottomContraint?.constant = isKeyboardShowing ? -keyboard.cgRectValue.height: 0
               
               UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut) { [unowned self] in
                   
                   self.view.layoutIfNeeded()
                   
               } completion: { [unowned self] (complited) in
                   
                   if isKeyboardShowing {
                       
                       let lastItemParametr = self.fetchResultsController.sections![0].numberOfObjects - 1
                       let indexPath = IndexPath(item: lastItemParametr, section: 0)
                       self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
                       
                   }
                   
               }
            }
        }
    }
    
    private func setupInputComponents() {
        
        let topBorderView = UIView()
        topBorderView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        topBorderView.translatesAutoresizingMaskIntoConstraints = false
        
        messageInputContainerView.addSubview(inputTextField)
        NSLayoutConstraint.activate([
        
            inputTextField.topAnchor.constraint(equalTo: messageInputContainerView.topAnchor),
            inputTextField.bottomAnchor.constraint(equalTo: messageInputContainerView.bottomAnchor),
            inputTextField.leadingAnchor.constraint(equalTo: messageInputContainerView.leadingAnchor, constant: 10),
            inputTextField.trailingAnchor.constraint(equalTo: messageInputContainerView.trailingAnchor)
        ])
        
        messageInputContainerView.addSubview(sendButton)
        NSLayoutConstraint.activate([
        
            sendButton.centerYAnchor.constraint(equalTo: messageInputContainerView.centerYAnchor),
            sendButton.trailingAnchor.constraint(equalTo: messageInputContainerView.trailingAnchor, constant: -10),
            sendButton.heightAnchor.constraint(equalToConstant: 20),
            sendButton.widthAnchor.constraint(equalToConstant: 60)
        ])
        
        messageInputContainerView.addSubview(topBorderView)
        NSLayoutConstraint.activate([
        
            topBorderView.topAnchor.constraint(equalTo: messageInputContainerView.topAnchor),
            topBorderView.heightAnchor.constraint(equalToConstant: 0.5),
            topBorderView.leadingAnchor.constraint(equalTo: messageInputContainerView.leadingAnchor),
            topBorderView.trailingAnchor.constraint(equalTo: messageInputContainerView.trailingAnchor)
        ])
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        inputTextField.endEditing(true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let count = fetchResultsController.sections?[0].numberOfObjects {
            
            return count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatLogCell
        
        let message = fetchResultsController.object(at: indexPath) as! Message
        
        cell.messageTextView.text = message.text
        
        if  let messageText = message.text, let profileImageName = message.friend?.profileImageName {
            
            cell.profileImageView.image = UIImage(named: profileImageName)
            
            let size = CGSize(width: 290, height: 1000)
            let option = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: option, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
            
            if !message.isSender!.boolValue {
                
                cell.messageTextView.frame = CGRect(x: 48 + 5, y: 0, width: estimatedFrame.width + 20, height: estimatedFrame.height + 20)
                cell.textBubbleView.frame = CGRect(x: 48 - 10 - 4, y: 0, width: estimatedFrame.width + 20 + 10 + 15, height: estimatedFrame.height + 20)
                cell.profileImageView.isHidden = false
                //cell.textBubbleView.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
                cell.bubbleImageView.tintColor = UIColor(white: 0.9, alpha: 1.0)
                cell.messageTextView.textColor = UIColor.black
                cell.bubbleImageView.image = ChatLogCell.grayBubbleImage

            }else {
                
                cell.messageTextView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 20 - 16, y: 0, width: estimatedFrame.width + 20, height: estimatedFrame.height + 20)
                
                cell.textBubbleView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 20 - 16 - 10, y: 0, width: estimatedFrame.width + 20 + 20, height: estimatedFrame.height + 20)
                
                cell.profileImageView.isHidden = true
                cell.bubbleImageView.tintColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1.0)
                cell.messageTextView.textColor = UIColor.white
                cell.bubbleImageView.image = ChatLogCell.blueBubbleImage
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let message = fetchResultsController.object(at: indexPath) as! Message
        if let messageText = message.text {
            
            let size = CGSize(width: 290, height: 1000)
            let option = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: option, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
            
            
            return CGSize(width: view.frame.width, height: estimatedFrame.height + 20)
        }
        
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    }
    
    //MARK: deinit
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
        print("deinit")
    }
}

