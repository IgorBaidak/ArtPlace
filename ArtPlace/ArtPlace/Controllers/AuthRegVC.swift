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
    
    // MARK: Outlet's
    
    @IBOutlet weak var nickNameTF: UITextField! { didSet { nickNameTF.isHidden = true }}
    @IBOutlet weak var nameTF: UITextField! { didSet { nameTF.isHidden = true }}
    @IBOutlet weak var surnameTF: UITextField! { didSet { surnameTF.isHidden = true }}
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var typeArtist: UISegmentedControl! { didSet { typeArtist.isHidden = true }}
    @IBOutlet weak var statusAccountAction: UIButton!
    @IBOutlet weak var haveAccount: UIButton! { didSet { haveAccount.isHidden = true }}
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var registrationButton: UIButton! { didSet { registrationButton.isHidden = true }}
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AccountVC") as! AccountVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: Action's
    
    @IBAction func notAccountAction() {
        registrationButton.isHidden = false
        signInButton.isHidden = true
        nickNameTF.isHidden = false
        nameTF.isHidden = false
        surnameTF.isHidden = false
        emailTF.text = ""
        passwordTF.text = ""
        title = "Registration"
        typeArtist.isHidden = false
        statusAccountAction.isHidden = true
        haveAccount.isHidden = false
    }
    @IBAction func haveAccountAction() {
        registrationButton.isHidden = true
        signInButton.isHidden = false
        nickNameTF.isHidden = true
        nameTF.isHidden = true
        surnameTF.isHidden = true
        emailTF.text = ""
        passwordTF.text = ""
        title = "Login"
        typeArtist.isHidden = true
        statusAccountAction.isHidden = false
        haveAccount.isHidden = true
    }
    
    @IBAction func registrationButtonAction() {

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
                        dataBase.child(result.user.uid).updateChildValues(["nick" : nick, "name" : name, "surname" : surname, "avatarURL": String(), "email" : email])
                        DispatchQueue.main.async {
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
        Auth.auth().signIn(withEmail: emailTF.text!, password: passwordTF.text!) { (result, error)  in
            if error == nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "AccountVC") as! AccountVC
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                self.showAlert()
            }
        }
    }
    
    
    
    
    // MARK: - Navigation

    /*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? AccountVC else { return }
    }
     */
    
    // MARK: Alert
    
    func showAlert() {
        let alert = UIAlertController(title: "Error", message: "Please, fill in all fields!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}


