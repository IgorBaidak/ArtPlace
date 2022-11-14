//
//  SnapshotData.swift
//  ArtPlace
//
//  Created by Igor Baidak on 8.10.22.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
//

//
//
class SnapshotData {

    static func snapshotData() {
        let ref = Database.database().reference()
        let currentUserID = Auth.auth().currentUser?.uid
ref.child("users").child(currentUserID!).child("name").observeSingleEvent(of: .value) { snapshot, error  in
        guard snapshot != nil else { return }
        print(snapshot)
        let userName = snapshot.value as? String ?? "name"
        }
    }
}
