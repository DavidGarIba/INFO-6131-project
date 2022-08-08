//
//  LoginViewController.swift
//  INFO-6131-project
//
//  Created by Anh Dinh Le on 2022-08-08.
//

import UIKit
import Firebase

let notificationKey3 = "removewords"

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    private let welcomeSegue: String = "goToNextPage"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self,selector: #selector(removeWords(_:)),name:Notification.Name(rawValue: notificationKey3),object:nil)

    }
    deinit{
            NotificationCenter.default.removeObserver(self)
        }
    
    @objc func removeWords(_ notfication:NSNotification){
        emailTextField.text = nil
        passwordTextField.text = nil
    }
    
    func showUIAlert(setence: String){
        let alert = UIAlertController(title: "Notification", message: setence, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {_ in
                        print("Ok")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
                
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                                  guard let strongSelf = self else { return }
            if let error = error, let errorCode = AuthErrorCode.Code(rawValue: error._code)
                                    {
                                        switch errorCode
                                        {
                                            case .userNotFound:
                                                strongSelf.showUIAlert(setence: "user doesn't exit")
                                            case .wrongPassword:
                                                strongSelf.showUIAlert(setence: "incorrect password")
                                            default:
                                                strongSelf.showUIAlert(setence:"error authentication user")
                                        }
                                            return
                                    }
                                        strongSelf.performSegue(withIdentifier: strongSelf.welcomeSegue, sender: strongSelf)
                                }

    }
}
