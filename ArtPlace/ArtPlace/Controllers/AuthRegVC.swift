//
//  AuthRegVC.swift
//  ArtPlace
//
//  Created by Igor Baidak on 20.09.22.
//

import UIKit
import FirebaseCore
import Firebase
import SwiftUI

class AuthRegVC: UIViewController {
    
    
    @IBOutlet weak var nickNameTF: UITextField! { didSet { nickNameTF.isHidden = true }}
    @IBOutlet weak var nameTF: UITextField! { didSet { nameTF.isHidden = true }}
    @IBOutlet weak var surnameTF: UITextField! { didSet { surnameTF.isHidden = true }}
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var statusAccountAction: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var registrationButton: UIButton! { didSet { registrationButton.isEnabled = false }}
    

    override func viewDidLoad() {
        super.viewDidLoad()
//        nickNameTF.delegate = self
//        nameTF.delegate = self
//        surnameTF.delegate = self
//        passwordTF.delegate = self
    }
    
    @IBAction func notAccountAction() {
        registrationButton.isEnabled = true
        signInButton.isEnabled = false
        nickNameTF.isHidden = false
        nameTF.isHidden = false
        surnameTF.isHidden = false
        title = "Registration"
        statusAccountAction.isEnabled = false
    }
    
    @IBAction func registrationButtonAction() {
//        if let nick = nickNameTF.text?.isEmpty,
//           let name = nameTF.text?.isEmpty,
//           let surname = surnameTF.text?.isEmpty,
//           let email = emailTF.text?.isEmpty,
//           let password = passwordTF.text?.isEmpty {
//               showAlert()
//        } else {
//            Auth.auth().createUser(withEmail: emailTF.text!, password: passwordTF.text!) { [self] (result, error) in
//                if error == nil {
//                    if let result = result {
//                    print (result.user.uid)
//                    let dataBase = Database.database().reference().child("users")
//                        dataBase.child(result.user.uid).updateChildValues(["nick" : nickNameTF, "name" : nameTF, "surname" : surnameTF, "email" : emailTF])
//            }
//        }
//    }
//}
        
       
        if let nick = nickNameTF.text, !nick.isEmpty,
           let name = nameTF.text, !name.isEmpty,
           let surname = surnameTF.text, !surname.isEmpty,
           let email = emailTF.text, !email.isEmpty,
           let password = passwordTF.text, !password.isEmpty
        {
            Auth.auth().createUser(withEmail: email, password: password) { (result, error)  in
                if error == nil {
                    if let result = result {
                        print (result.user.uid)
                        let dataBase = Database.database().reference().child("users")
                        dataBase.child(result.user.uid).updateChildValues(["nick" : nick, "name" : name, "surname" : surname, "email" : email])
                        DispatchQueue.main.async {
                            //self.performSegue(withIdentifier: "goToAccount", sender: nil)
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "AccountVC") as! AccountVC
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
            }
        } else {
            self.showAlert()
        }
        
    }
    
    @IBAction func signInButtonAction() {
        
    }
    
    
    
    
    // MARK: - Navigation

    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? AccountVC else { return }
    }
     */
    
    func showAlert() {
        let alert = UIAlertController(title: "Error", message: "Please, fill in all fields!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}


