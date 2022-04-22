//
//  ViewController.swift
//  facebookKiller
//
//  Created by Valeriy Trusov on 12.03.2022.
//

import UIKit
import CoreData



class  FriendsController : UICollectionViewController, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {

   private let cellId = "cellId"
    
    
    lazy var fetchResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
         
         let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Friend")
         fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastMessage.date", ascending: false)]
         fetchRequest.predicate = NSPredicate(format: "lastMessage != nil")
         let delegate = UIApplication.shared.delegate as! AppDelegate
         let context = delegate.persistentContainer.viewContext
         let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
         return frc
     }()
    
    var blockOperations = [BlockOperation]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Recent"
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: cellId)
        
        setupData()
        
        do {
            
           try fetchResultsController.performFetch()

        }catch let err {
            
            print(err)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "add Mark", style: .plain, target: self, action: #selector(addMark))
    }
    
    @objc private func addMark() {
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        createMorfMessagesWith(context: context)
    }
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
        collectionView.reloadData()
    }

    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let count = fetchResultsController.sections?[0].numberOfObjects {
            
            return count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MessageCell
        
        let friend = fetchResultsController.object(at: indexPath) as! Friend
        
        cell.message = friend.lastMessage
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let layout = UICollectionViewFlowLayout()
        let vc = ChatLogController(collectionViewLayout: layout)
        let friend = fetchResultsController.object(at: indexPath) as! Friend
        vc.friend = friend
        navigationController?.pushViewController(vc, animated: true)
    }
}



