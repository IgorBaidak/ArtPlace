//
//  AuthRegVC.swift
//  ArtPlace
//
//  Created by Igor Baidak on 20.09.22.
//

import UIKit

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

        // Do any additional setup after loading the view.
    }
    
    @IBAction func notAccountAction() {
        registrationButton.isEnabled = true
        signInButton.isEnabled = false
        nickNameTF.isHidden = false
        nameTF.isHidden = false
        surnameTF.isHidden = false
        statusAccountAction.isEnabled = false
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
