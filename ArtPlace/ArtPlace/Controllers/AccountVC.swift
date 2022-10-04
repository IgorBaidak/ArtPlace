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

    @IBOutlet weak var blurAvatar: UIImageView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var blurEffectView: UIView!
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var surname: UILabel!
    @IBOutlet weak var myContentView: UILabel! { didSet{ myContentView.layer.cornerRadius = 15 } }

    var ref = Database.database().reference()
    var currentUserID = Auth.auth().currentUser?.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blurEffectView.layer.cornerRadius = blurEffectView.frame.size.width / 2
        
    }
    
    
    
    // MARK: Action's
    
    // метод позволяющий выбрать картинку из локального хранилища (память телефона)
    @IBAction func addAvatar() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        //imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
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
    func upload(currentUserID: String, photo: UIImage, complition: @escaping (Result<URL, Error>) -> Void) {
        
        let ref = Storage.storage().reference().child("avatars").child(currentUserID)
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
            print(info)
            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
            avatar.image = image
            blurAvatar.image = image
            upload(currentUserID: currentUserID!, photo: avatar.image!) { [self] (userResult) in
                switch userResult {
                case .success(let url):
                    Database.database().reference().child("users").child(currentUserID!).updateChildValues(["avatarURL" : url.absoluteString])
                case .failure(let error):
                    print(error)
                }
            }
        }
}


