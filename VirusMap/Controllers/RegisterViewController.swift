//
//  RegisterViewController.swift
//  VirusMap
//
//  Created by Angelina Rusinovich on 5.02.21.
//

import UIKit
import JGProgressHUD

class RegisterViewController: UIViewController, LocalizableApp {
    //  MARK: - Vars

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var mortalityTextField: UITextField!
    @IBOutlet weak var domainTextField: UITextField!
    @IBOutlet weak var continentTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var createAccountBtn: UIButton!
    
    let randomImageName = String(Int.random(in: 1...8)) // [1..8]
    
    private var image: UIImage? = nil
    
    //  MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
        imageView.image = UIImage(named: randomImageName)
        addObservers()
        contentView.backgroundColor = Constants.backgroundColor
        view.backgroundColor = Constants.backgroundColor
        setupButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        changeLanguage()
        navigationController?.navigationBar.tintColor = .white
        setupGrayTextField(textFields: [fullNameTextField, passwordTextField, nickNameTextField, yearTextField, mortalityTextField, domainTextField, continentTextField, countryTextField])
        fullNameTextField.setIcon(named: "name")
        passwordTextField.setIcon(named: "lock")
        nickNameTextField.setIcon(named: "nickname")
        yearTextField.setIcon(named: "days")
        mortalityTextField.setIcon(named: "analytics")
        domainTextField.setIcon(named: "color-wheel")
        continentTextField.setIcon(named: "worldwide")
        countryTextField.setIcon(named: "placeholder")
    }
    
    //  MARK: - Functions
    @IBAction func registerTapped(_ sender: Any) {
        
        guard let fullname = fullNameTextField.text,
              let password = passwordTextField.text,
              let nickname = nickNameTextField.text,
              let year = yearTextField.text,
              let mortality = mortalityTextField.text,
              let domain = domainTextField.text,
              let continent = continentTextField.text,
              let country = countryTextField.text,
              validateFieldsLength(fields: [fullname, password, nickname, year, mortality, domain, continent, country])  else { return }
        
        let hud = setupSimpleProgressHUD()
        
        UserApi().signUp(fullName: fullname, password: password, nickName: nickname, year: year, image: randomImageName, mortality: mortality, domain: domain, continent: continent, country: country, onSuccess: {
            self.showSucess(hud: hud)
        }, onError: { error in
            self.showError(hud: hud, error: error)
        })
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func changeLanguage() {
        fullNameTextField.placeholder = LocalizeUtils.defaultLocalizer.stringForKey(key: fullNameTextField.placeholder ?? "")
        nickNameTextField.placeholder = LocalizeUtils.defaultLocalizer.stringForKey(key: nickNameTextField.placeholder ?? "")
        yearTextField.placeholder = LocalizeUtils.defaultLocalizer.stringForKey(key: yearTextField.placeholder ?? "")
        mortalityTextField.placeholder = LocalizeUtils.defaultLocalizer.stringForKey(key: mortalityTextField.placeholder ?? "")
        domainTextField.placeholder = LocalizeUtils.defaultLocalizer.stringForKey(key: domainTextField.placeholder ?? "")
        continentTextField.placeholder = LocalizeUtils.defaultLocalizer.stringForKey(key: continentTextField.placeholder ?? "")
        countryTextField.placeholder = LocalizeUtils.defaultLocalizer.stringForKey(key: countryTextField.placeholder ?? "")
        passwordTextField.placeholder = LocalizeUtils.defaultLocalizer.stringForKey(key: passwordTextField.placeholder ?? "")
        createAccountBtn.setTitle(LocalizeUtils.defaultLocalizer.stringForKey(key: createAccountBtn.title(for: .normal) ?? ""), for: .normal)
        navigationItem.leftBarButtonItem?.title = LocalizeUtils.defaultLocalizer.stringForKey(key: navigationItem.leftBarButtonItem?.title ?? "")
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        view.frame.origin.y = (notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification) ? -keyboardRect.height + 200 : 0
    }
    
    private func setupButton() {
        createAccountBtn.layer.borderWidth = 2.5
        createAccountBtn.layer.borderColor = CGColor(red: 0 / 255, green: 230 / 255, blue: 0 / 255, alpha: 1.0)
        createAccountBtn.layer.cornerRadius = createAccountBtn.layer.frame.height / 2
        createAccountBtn.tintColor = .green
    }
}
