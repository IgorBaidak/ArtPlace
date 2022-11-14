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
import AVFoundation

class AccountVC: UIViewController {
    
    // MARK: Outlet's
    @IBOutlet weak var blurAvatar: UIImageView!
    @IBOutlet weak var avatar: UIImageView! { didSet { avatar.layer.borderWidth = 0.5
        avatar.layer.borderColor = .init(red: 255, green: 255, blue: 255, alpha: 1
    )}}
    @IBOutlet weak var blurEffectView: UIView! { didSet { blurEffectView.layer.borderWidth = 4
        blurEffectView.layer.borderColor = .init(red: 255, green: 255, blue: 255, alpha: 1)
    }}
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var surname: UILabel!
    @IBOutlet weak var myContentView: UILabel! { didSet{ myContentView.layer.cornerRadius = 15 } }
    @IBOutlet weak var addAvatarButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var ref = Database.database().reference()
    var currentUserID = Auth.auth().currentUser?.uid
    
    let dj = PlaylistDJ.trackList
    let songer = PlaylistSonger.trackList
    let musician = PlaylistMusician.trackList
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        playCell()
        downloadAvatar()
        // делаем круглым Blur Effect
        blurEffectView.clipsToBounds = true
        blurEffectView.layer.cornerRadius = 140
        blurEffectView.layer.maskedCorners = [.layerMaxXMaxYCorner,
                                              .layerMaxXMinYCorner,
                                              .layerMinXMaxYCorner,
                                              .layerMinXMinYCorner]
        
        // достаем необходимые значения из Realtime Database
        ref.child("users").child(currentUserID!).child("name").observeSingleEvent(of: .value) { (snapshot) in
            guard snapshot != nil else { return }
            print(snapshot)
            let userName = snapshot.value as? String ?? "name"
            DispatchQueue.main.async {
                self.name.text = userName
            }
        }
        ref.child("users").child(currentUserID!).child("surname").observeSingleEvent(of: .value) { (snapshot) in
            guard snapshot != nil else { return }
            print(snapshot)
            let userSurname = snapshot.value as? String ?? "surname"
            self.surname.text = userSurname
        }
        ref.child("users").child(currentUserID!).child("nick").observeSingleEvent(of: .value) { (snapshot) in
            guard snapshot != nil else { return }
            print(snapshot)
            let userNick = snapshot.value as? String ?? "nick"
            self.nickName.text = userNick
        }
        ref.child("users").child(currentUserID!).child("typeArtist").observeSingleEvent(of: .value) { (snapshot) in
            guard snapshot != nil else { return }
            print(snapshot)
            let artist = snapshot.value as? String ?? "typeArtist"
            self.title = artist
        }
    }
    
    
    // MARK: - Table view data source

    
    
    // MARK: Action's
    
    // метод позволяющий выбрать картинку из локального хранилища (память телефона)
    @IBAction func addAvatar() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    @IBAction func addAction() {
        
//        if let localAudioURL = Bundle.main.url(forResource: "Test", withExtension: "Audio") {
//            uploadAudio(localAudioURL: localAudioURL)
//        }
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
    // загружаем аватарку в Storage Database
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
    
    func downloadAvatar() {
        let avatarRef = Storage.storage().reference().child("avatars").child(currentUserID!)
        avatarRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
          } else {
            let image = UIImage(data: data!)
              self.avatar.image = image
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
    
    // MARK: Extension's
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

extension AccountVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
                return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // здесь должна быть функция playCell
    }
    
    private func playCell() {
                 let audioRef = Storage.storage().reference().child("audio").child("RASA - Погудим.mp3")
                    audioRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
    
                    let player = AVPlayer()
                        player.play()
        }
    }
    
}


