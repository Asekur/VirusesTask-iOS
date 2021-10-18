//
//  EditVirusProfileViewController.swift
//  VirusMap
//
//  Created by Angelina Rusinovich on 21.02.21.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class EditVirusProfileViewController: UIViewController, LocalizableApp {
    
    //  MARK: - Vars
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var mortalityTextField: UITextField!
    @IBOutlet weak var domainTextField: UITextField!
    @IBOutlet weak var continentTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var videoLinkTextField: UITextField!
    @IBOutlet weak var galleryBtn: UIButton!
    @IBOutlet weak var contentView: UIView!
    
    private var image: UIImage?
    var virus: Virus?
    var delegate: NotifyChange?
    
    //  MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        virus = CurrentVirus.shared.virus
        self.hideKeyboardWhenTappedAround()
        setupFields()
        setupButton()
        contentView.backgroundColor = Constants.backgroundColor
        view.backgroundColor = Constants.backgroundColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        changeLanguage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PhotoGalleryViewController, segue.identifier == "toGallery" {
            vc.virus = virus
        }
    }
    
    //  MARK: - Functions
    @objc func changeLanguage() {
        galleryBtn.setTitle(LocalizeUtils.defaultLocalizer.stringForKey(key: galleryBtn.title(for: .normal) ?? ""), for: .normal)
        navigationItem.rightBarButtonItem?.title = LocalizeUtils.defaultLocalizer.stringForKey(key:  navigationItem.rightBarButtonItem?.title ?? "")
        navigationItem.title = LocalizeUtils.defaultLocalizer.stringForKey(key:  navigationItem.title ?? "")
    }
    
    @objc func keyboardWillChange(notification: Notification) {
        
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        view.frame.origin.y = (notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification) ? -keyboardRect.height + 200 : 0
    }
    
    private func setupFields() {
        imageView.image = UIImage(named: virus?.image ?? "1")
        fullNameTextField.text = virus?.fullName  ?? ""
        nickNameTextField.text = virus?.nickName  ?? ""
        yearTextField.text = "\(virus?.year ?? 0)"
        mortalityTextField.text = "\(virus?.mortality ?? 0)%"
        domainTextField.text = virus?.domain  ?? ""
        continentTextField.text = virus?.continent  ?? ""
        countryTextField.text = virus?.country  ?? ""
        videoLinkTextField.text = virus?.link  ?? ""
        setupGrayTextField(textFields: [fullNameTextField, nickNameTextField, yearTextField, mortalityTextField, domainTextField, continentTextField, countryTextField, videoLinkTextField])
        
        fullNameTextField.setIcon(named: "name")
        nickNameTextField.setIcon(named: "nickname")
        yearTextField.setIcon(named: "days")
        mortalityTextField.setIcon(named: "analytics")
        domainTextField.setIcon(named: "color-wheel")
        continentTextField.setIcon(named: "worldwide")
        countryTextField.setIcon(named: "placeholder")
        videoLinkTextField.setIcon(named: "play-button")
    }
    
    @IBAction func saveDataTapped(_ sender: Any) {
        
        guard let uid = virus?.uid,
              let image = virus?.image,
              let password = virus?.password,
              let fullname = fullNameTextField.text,
              let nickname = nickNameTextField.text,
              let year = yearTextField.text,
              let mortality = mortalityTextField.text,
              let domain = domainTextField.text,
              let continent = continentTextField.text,
              let country = countryTextField.text,
              let videoLink = videoLinkTextField.text,
              validateFieldsLength(fields: [fullname, nickname, year, mortality, domain, continent, country, videoLink])  else { return }

        let hud = setupSimpleProgressHUD()
        let dict: Dictionary<String, Any> = [
            UID: uid,
            FULL_NAME: fullname,
            NICKNAME: nickname,
            PASSWORD: password,
            YEAR: year,
            MORTALITY: mortality,
            MYDOMAIN: domain,
            PROFILE_IMAGE_URL: image,
            COUNTRY: country,
            CONTINENT: continent,
            VIDEO_LINK: videoLink
        ]

        StorageService.saveInfo(uid: uid, dict: dict, onSuccess: { [weak self] in
            CurrentVirus.shared.virus = Virus(dictionary: dict)
            self?.showSucess(hud: hud)
        }, onError: { [weak self] (error) in
            self?.showError(hud: hud, error: error)
        })
        
        dismissKeyboard()
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    private func setupButton() {
        galleryBtn.layer.borderWidth = 2.5
        galleryBtn.layer.borderColor = CGColor(red: 0 / 255, green: 230 / 255, blue: 0 / 255, alpha: 1.0)
        galleryBtn.layer.cornerRadius = galleryBtn.layer.frame.height / 2
        galleryBtn.tintColor = .green
    }
}
