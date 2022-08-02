//
//  UploadViewController.swift
//  InstaClone
//
//  Created by Macbook on 30.06.2022.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var commentText: UITextField!
    
    @IBOutlet weak var uploadButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
        imageView.isUserInteractionEnabled = true
        let sss = UITapGestureRecognizer(target: self, action: #selector(chooseImage))
        imageView.addGestureRecognizer(sss)
        
        
    }

    @objc func chooseImage(){
        //kullanıcı kütüphanesine ulaşmak
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        //datayı alma
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
                
    }
    
    func makeAlert(titleInput: String, messageInput: String){
        
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle:UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
        
    }
    
     
    //kullanıcı seçitiğinde ne olacağı
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
      
    }
    
    @IBAction func actionButtonClicked(_ sender: Any) {
        
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let mediaFolder = storageReference.child("media")
               

        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            //her kaydedilennin ismi farklı olsun
            let uuid = UUID().uuidString
            
            //uuid-dms dosyasını jpg çevirme
            let imageReference = mediaFolder.child("(\(uuid).jpg")
            imageReference.putData(data, metadata: nil) { [self] (metadata, error) in
                
                if error != nil {
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                }else{
                    
                    imageReference.downloadURL { (url, error) in
                        
                        if error == nil {
                            
                            //url string çevir
                            let imageUrl = url?.absoluteString

                            //Data Base işlemleri
                            let firestoreDatabase = Firestore.firestore()
                            
                            
                            var firestoreReference : DocumentReference? = nil
                            //Tarih ve Saati anlık yazma
                            let firestorePost = ["imageUrl" : imageUrl!, "postedBy" : Auth.auth().currentUser!.email!, "postCommet" : self.commentText.text!, "date" : FieldValue.serverTimestamp(), "likes" : 0] as [String : Any]
                            
                            
                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { (error) in
                                if error != nil {
                                    
                                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                                    
                                }else {
                                    self.imageView.image = UIImage(named: "select.png")
                                    self.commentText.text = ""
                                    self.tabBarController?.selectedIndex = 0
                                    
                                }
                            
                           
                                
                        })
                            
                      }
                 
                   }
                    
                }
                
            }
                
        }
            
    }
        
}
    

