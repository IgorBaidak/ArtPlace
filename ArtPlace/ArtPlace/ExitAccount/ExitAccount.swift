//
//  DownloadAvatar.swift
//  ArtPlace
//
//  Created by Igor Baidak on 15.11.22.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseStorage
import FirebaseFirestore
import AVFoundation

class ExitAccount {
    
    func exit () {
            do {
                try Auth.auth().signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let _ = storyboard.instantiateInitialViewController()
        }
    }
