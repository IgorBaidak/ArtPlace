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
    @IBOutlet weak var viewArtist: UIImageView!
    
    var ref = Database.database().reference()
    var currentUserID = Auth.auth().currentUser?.uid
    
    let dj = PlaylistDJ.trackList
    let songer = PlaylistSonger.trackList
    let musician = PlaylistMusician.trackList
    
    var artist: String = ""
    
    var currentPlaylist: [String] = []
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadAvatar()
        // делаем круглым Blur Effect
        blurEffectView.clipsToBounds = true
        blurEffectView.layer.cornerRadius = 140
        blurEffectView.layer.maskedCorners = [.layerMaxXMaxYCorner,
                                              .layerMaxXMinYCorner,
                                              .layerMinXMaxYCorner,
                                              .layerMinXMinYCorner]
        
        // достаем необходимые значения из Realtime Database
        snapshot()
        currentPlaylistFunc()
    }
    
    // MARK: Action's
    
    // метод позволяющий выбрать картинку из локального хранилища (память телефона)
    @IBAction func addAvatar() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    @IBAction func allArtistButton() {
//        func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//            if let destVC = segue.destination as? AllArtistTVC {
//                destVC.typeArtist = DataSource.trackList[indexPath.row]
//            }
//        }
    }
    
    
    @IBAction func addAction() {
        
//        if let localAudioURL = Bundle.main.url(forResource: "Test", withExtension: "Audio") {
//            uploadAudio(localAudioURL: localAudioURL)
//        }
    }
    
    
    
    @IBAction func editAction(_ sender: UIBarButtonItem) {
        
    }
    
    
    @IBAction func exitAccountAction(_ sender: UIBarButtonItem) {
        ExitAccount().exit()
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
    
    
    
    
    private func currentPlaylistFunc() {
        if myContentView.text == "DJ" {
            currentPlaylist = PlaylistDJ.trackList
        } else if myContentView.text == "Songer" {
            currentPlaylist = PlaylistSonger.trackList
        } else {
            currentPlaylist = PlaylistMusician.trackList/
        }
        tableView.reloadData()
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let destVC = segue.destination as? AllArtistTVC {
        destVC.typeArtist = myContentView.text!
    }
}

}
    



    
    
    
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
// MARK: Create and Config CELL
extension AccountVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentPlaylist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        let nameTrack = currentPlaylist[indexPath.row]
        cell.textLabel?.text = nameTrack
        cell.imageView?.image = UIImage(named: artist)
                return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // здесь должна быть функция playCell
    }
}


