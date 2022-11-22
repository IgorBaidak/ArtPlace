//
//  Snapshot.swift
//  ArtPlace
//
//  Created by Igor Baidak on 22.11.22.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseStorage
import FirebaseFirestore

extension AccountVC {
    func snapshot() {
        ref.child("users").child(currentUserID!).child("name").observeSingleEvent(of: .value) { [weak self] (snapshot) in
            guard snapshot != nil else { return }
            print(snapshot)
            let userName = snapshot.value as? String ?? "name"
            DispatchQueue.main.async {
                self?.name.text = userName
            }
        }
        ref.child("users").child(currentUserID!).child("surname").observeSingleEvent(of: .value) { [weak self] (snapshot) in
            guard snapshot != nil else { return }
            print(snapshot)
            let userSurname = snapshot.value as? String ?? "surname"
            self?.surname.text = userSurname
        }
        ref.child("users").child(currentUserID!).child("nick").observeSingleEvent(of: .value) { [weak self] (snapshot) in
            guard snapshot != nil else { return }
            print(snapshot)
            let userNick = snapshot.value as? String ?? "nick"
            self?.nickName.text = userNick
        }
        ref.child("users").child(currentUserID!).child("typeArtist").observeSingleEvent(of: .value) { [weak self] (snapshot) in
            guard snapshot != nil else { return }
            print(snapshot)
            let artist = snapshot.value as? String ?? "typeArtist"
            self?.artist = artist
            self?.myContentView.text = artist
        }
    }
}
