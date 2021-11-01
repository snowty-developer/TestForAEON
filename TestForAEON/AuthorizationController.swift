//
//  ViewController.swift
//  TestForAEON
//
//  Created by Александр Зубарев on 30.10.2021.
//

import UIKit

class AuthorizationController: UIViewController {

    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var incorrectMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        incorrectMessage.isHidden = true
        
        let login = UserDefaults.standard.string(forKey: "login")
        let password = UserDefaults.standard.string(forKey: "password")
        
        if (login != nil && password != nil) {
            self.login.text = login!
            self.pass.text = password!
            self.signInButton.setTitle("My payments", for: .normal)
            signOutButton.isHidden = false
        }
        else { signOutButton.isHidden = true }
    }

    @IBAction func LoginClean(_ sender: UITextField) {
        if (sender.text! == "") {sender.text = "Login"}
    }
    
    @IBAction func LoginTapped(_ sender: UITextField) {
        if (sender.text! == "Login") {sender.text = ""}
    }
    
    @IBAction func PasswordClean(_ sender: UITextField) {
        if (sender.text! == "") {sender.text = "Password"}
    }
    
    @IBAction func PasswordTapped(_ sender: UITextField) {
        if (sender.text! == "Password") {sender.text = ""}
    }
    
    @IBAction func SignOutTapped(_ sender: UIButton) {
        sender.isHidden = true
        self.login.text = "Login"
        self.pass.text = "Password"
        self.signInButton.setTitle("Sign In", for: .normal)
        
        UserDefaults.standard.removeObject(forKey: "token")
        UserDefaults.standard.removeObject(forKey: "login")
        UserDefaults.standard.removeObject(forKey: "password")
    }
    
    @IBAction func SignInTapped(_ sender: UIButton) {
        let token = UserDefaults.standard.string(forKey: "token")
        if (token != nil) {
            DataLoadingFunction().LoadPayments(token: token!) { (result) in
                switch result {
                case .success(let payments):
                    let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "Payments") as! PaymentsController
                    vc.payments = payments
                    self.present(vc, animated: true, completion: nil)
                case .failure(let error):
                    print(error)
                }
            }
        }
        else {
            DataLoadingFunction().SignIn(login: login.text!, password: pass.text!) { (result) in
                switch result {
                case .success(let tokenResult):
                    if (tokenResult.success == "true") {
                        UserDefaults.standard.set(tokenResult.response!.token, forKey: "token")
                        UserDefaults.standard.set(self.login.text!, forKey: "login")
                        UserDefaults.standard.set(self.pass.text!, forKey: "password")
                        
                        sender.setTitle("My payments", for: .normal)
                        self.incorrectMessage.isHidden = true
                        self.signOutButton.isHidden = false
                        
                        DataLoadingFunction().LoadPayments(token: tokenResult.response!.token) { (result) in
                            switch result {
                            case .success(let payments):
                                let vc = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "Payments") as! PaymentsController
                                vc.payments = payments
                                self.present(vc, animated: true, completion: nil)
                            case .failure(let error):
                                print(error)
                            }
                        }
                        
                    }
                    else { self.incorrectMessage.isHidden = false }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
}

