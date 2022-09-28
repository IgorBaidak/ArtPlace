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

class AccountVC: UIViewController {

    @IBOutlet weak var blurAvatar: UIImageView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var surname: UILabel!
    
    let storage = Storage.storage()
    let storageRef = Storage.storage().reference()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    // MARK: Action's
    @IBAction func addAvatar() {
        
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
