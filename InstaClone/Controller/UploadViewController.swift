//
//  UploadViewController.swift
//  InstaClone
//
//  Created by Yasin Cengiz on 15.02.2020.
//  Copyright © 2020 MrYC. All rights reserved.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentText: UITextView!
    @IBOutlet weak var shareButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func shareButtonClicked(_ sender: Any) {
    
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let media = storageRef.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            
            let uuid = UUID().uuidString
            let imageRef = media.child("\(uuid).jpeg")
            imageRef.putData(data, metadata: nil) { (metadata, error) in
                if error != nil {
                    self.pushAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                } else {
                    imageRef.downloadURL { (url, error) in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                            // Database //
                            let firestoreDB = Firestore.firestore()
                            var firestoreRef : DocumentReference? = nil
                            let firestorePost = ["imageUrl":imageUrl!,
                                                 "postedBy":Auth.auth().currentUser!.email!,
                                                 "comment":self.commentText.text!,
                                                 "date":FieldValue.serverTimestamp(),
                                                 "likes":0] as [String : Any]
                            
                            firestoreRef = firestoreDB.collection("Posts").addDocument(data: firestorePost, completion: { (error) in
                                if error != nil {
                                    self.pushAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                                } else {
                                    self.imageView.image = UIImage(named: "tap.png")
                                    self.commentText.text = "comment..."
                                    self.tabBarController?.selectedIndex = 0
                                }
                            })
                            
                            
                            
                        }
                    }
                }
            }
            
        }
        
        
        
    }
    
    
    
    
    func pushAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okBtn)
        present(alert, animated: true, completion: nil)
    }
    
    
    @objc func chooseImage () {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
        
    }

    
    
    
    
    
    
}
