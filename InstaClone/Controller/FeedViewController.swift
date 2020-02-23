//
//  FeedViewController.swift
//  InstaClone
//
//  Created by Yasin Cengiz on 15.02.2020.
//  Copyright © 2020 MrYC. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var likeArray = [Int]()
    var userImageArray = [String]()
    var documentIDArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromFirestore()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        
        cell.emailLabel.text = userEmailArray[indexPath.row]
        cell.likesLabel.text = "\(likeArray[indexPath.row])"
        cell.commentLabel.text = userCommentArray[indexPath.row]
        cell.imageView?.sd_setImage(with: URL(string: self.userImageArray[indexPath.row]))
        cell.documentIDLabel.text = documentIDArray[indexPath.row]
        
        return cell
        
    }

    
    func getDataFromFirestore() {
        
        let fireStoreDatabase = Firestore.firestore()
        fireStoreDatabase.collection("Posts")
            .order(by: "date", descending: true)
            .addSnapshotListener { (snapshot, error) in
            if error != nil {
                print(error?.localizedDescription)
            } else{
                if snapshot?.isEmpty != true && snapshot != nil {
                    self.userImageArray.removeAll(keepingCapacity: false)
                    self.userEmailArray.removeAll(keepingCapacity: false)
                    self.userCommentArray.removeAll(keepingCapacity: false)
                    self.likeArray.removeAll(keepingCapacity: false)
                    self.documentIDArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        let documentID = document.documentID
                        self.documentIDArray.append(documentID)
                        
                        if let postedBy = document.get("postedBy") as? String {
                            self.userEmailArray.append(postedBy)
                            if let comment = document.get("comment") as? String {
                                self.userCommentArray.append(comment)
                                if let likes = document.get("likes") as? Int {
                                    self.likeArray.append(likes)
                                    if let imageUrl = document.get("imageUrl") as? String {
                                        self.userImageArray.append(imageUrl)
                                    }
                                }
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
        
        
    }
    
    

}
