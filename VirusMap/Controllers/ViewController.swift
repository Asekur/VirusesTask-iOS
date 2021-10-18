//
//  ViewController.swift
//  VirusMap
//
//  Created by Angelina Rusinovich on 3.02.21.
//

import UIKit
import JGProgressHUD

protocol LocalizableApp {
    func changeLanguage()
}

class ViewController: UIViewController, LocalizableApp {
    
    //  MARK: - Vars
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var enterBtn: UIButton!
    @IBOutlet weak var createNewAccBtn: UIButton!
    
    var viruses = [Virus]()
    
    //  MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupButton()
        self.hideKeyboardWhenTappedAround()
        view.backgroundColor = Constants.backgroundColor
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        setupGrayTextField(textFields: [emailTextField, passwordTextField])
        emailTextField.setIcon(named: "name")
        passwordTextField.setIcon(named: "lock")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        changeLanguage()
        viruses.removeAll()
        getViruses()
    }
    
    //  MARK: - Functions
    @IBAction func signInTapped(_ sender: Any) {
        guard let fullname = emailTextField.text,
              let password = passwordTextField.text else {
            return
        }
    
        
        let hud = setupSimpleProgressHUD()
        if let virus = viruses.first(where: { $0.fullName == fullname && $0.password == password}) {
            ControllerHelper().changeVC(identifier: "tabID")
            CurrentVirus.shared.virus = virus
            showSucess(hud: hud)
        } else {
            showError(hud: hud, error: "Wrong data.")
        }
    }
    
    @objc func changeLanguage() {
        passwordTextField.placeholder = LocalizeUtils.defaultLocalizer.stringForKey(key: passwordTextField.placeholder ?? "")
        emailTextField.placeholder = LocalizeUtils.defaultLocalizer.stringForKey(key: emailTextField.placeholder ?? "")
        enterBtn.setTitle(LocalizeUtils.defaultLocalizer.stringForKey(key: enterBtn.title(for: .normal) ?? ""), for: .normal)
        createNewAccBtn.setTitle(LocalizeUtils.defaultLocalizer.stringForKey(key: createNewAccBtn.title(for: .normal) ?? ""), for: .normal)
    }
    
    private func getViruses() {
        Ref().databaseViruses().observe(.childAdded, with: { (snapshot) in
            guard let dict = snapshot.value as? Dictionary<String, Any> else { return }
            let student = Virus(dictionary: dict)
            self.viruses.append(student)
        })
    }
    
    private func setupButton() {
        enterBtn.layer.borderWidth = 2.5
        enterBtn.layer.borderColor = CGColor(red: 0 / 255, green: 230 / 255, blue: 0 / 255, alpha: 1.0)
        enterBtn.layer.cornerRadius = enterBtn.layer.frame.height / 2
        enterBtn.tintColor = .green
    }
}
