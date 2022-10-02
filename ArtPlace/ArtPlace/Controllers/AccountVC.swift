//
//  UserVC.swift
//  ArtPlace
//
//  Created by Igor Baidak on 20.09.22.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseStorage
import FirebaseFirestore

class AccountVC: UIViewController//, UIImagePickerControllerDelegate & UINavigationControllerDelegate
{

    @IBOutlet weak var blurAvatar: UIImageView! { didSet { blurAvatar.layer.cornerRadius = 125 } }
    @IBOutlet weak var avatar: UIImageView! { didSet { avatar.layer.cornerRadius = 110 } }
    @IBOutlet weak var blurEffectView: UIView! { didSet { blurEffectView.layer.cornerRadius = 125 } }
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var surname: UILabel!
    @IBOutlet weak var myContentView: UILabel! { didSet{ myContentView.layer.cornerRadius = 15 } }
    
//    let storage = Storage.storage()
//    let storageRef = Storage.storage().reference()

    var ref = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    // MARK: Action's
    
    // метод позволяющий выбрать картинку из локального хранилища (память телефона)
    @IBAction func addAvatar() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        //imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
        func upload(currentUserId: String, photo: UIImage, complition: @escaping (Result<URL, Error>) -> Void) {
            let ref = Storage.storage().reference().child("avatars").child("userId")
            
            guard let imageData = avatar.image?.jpegData(compressionQuality: 0.4) else { return }
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            ref.putData(imageData, metadata: metadata) { (metadata, error) in
                guard let _ = metadata else {
                    complition(.failure(error!))
                    return
                }
                ref.downloadURL { (url, error) in
                    guard let url = url else {
                        complition(.failure(error!))
                        return
                }
                    complition(.success(url))
        }
                
            }
        }
        
    }
    
    
    @IBAction func addAction(_ sender: UIBarButtonItem) {
        
    }
    
    
    
    @IBAction func editAction(_ sender: UIBarButtonItem) {
        
    }
    
    
    @IBAction func exitAccountAction(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let _ = storyboard.instantiateInitialViewController()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBAction func infoAction() {
        
    }
    
    
    @IBAction func messageUserAction() {
        
    }
    
    // MARK: Func's
    
//    private func upload(currentUserId: String, photo: UIImage, complition: @escaping (Result<URL, Error>) -> Void) {
//        let ref = Storage.storage().reference().child("avatars").child("userId")
//
//        guard let imageData = avatar.image?.jpegData(compressionQuality: 0.4) else { return }
//        let metadata = StorageMetadata()
//        metadata.contentType = "image/jpeg"
//
//        ref.putData(imageData, metadata: metadata) { (metadata, error) in
//            guard let _ = metadata else {
//                complition(.failure(error!))
//                return
//            }
//            ref.downloadURL { (url, error) in
//                guard let url = url else {
//                    complition(.failure(error!))
//                    return
//            }
//                complition(.success(url))
//    }
//
//        }
//    }
}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    

    extension AccountVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            picker.dismiss(animated: true)
            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
            avatar.image = image
            blurAvatar.image = image
        }
}


