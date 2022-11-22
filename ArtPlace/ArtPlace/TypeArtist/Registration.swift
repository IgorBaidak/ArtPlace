//
//  Registration.swift
//  ArtPlace
//
//  Created by Igor Baidak on 22.11.22.
//

import UIKit
import FirebaseCore
import Firebase
import SwiftUI


class Registration {
    
    func registration(email: String, password: String) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (result, error)  in
            if error == nil {
                if let result = result {
                    print (result.user.uid)
                    let dataBase = Database.database().reference().child("users")
                    dataBase.child(result.user.uid).updateChildValues(["nick" : String(), "name" : String(), "surname" : String(), "avatarURL": String(), "audioURL": String(), "email" : String(), "typeArtist" : "\(TypeArtist.self)"])
                }
            }
        }
    }
}
