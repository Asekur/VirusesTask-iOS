//
//  SettingViewController.swift
//  VirusMap
//
//  Created by Angelina Rusinovich on 3.02.21.
//

import UIKit
import FirebaseAuth

protocol CallbackableSettings {
    func doCallback(i: Int)
}

class SettingViewController: UIViewController, CallbackableSettings, LocalizableApp {
    //  MARK: - Vars
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var header: UINavigationBar!
    
    private var settingMenu = [SettingType(name: "Font", type: .forwardable), SettingType(name: "Change language", type: .language), SettingType(name: "Log out", type: .forwardable)]
    
    private var callbacks: [(() -> ())?] = []
    
    //  MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initializeCallbacks()
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        header.backgroundColor = Constants.backgroundColor
        header.setBackgroundImage(UIImage(), for: .default)
        header.shadowImage = UIImage()
        header.isTranslucent = true
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        header.titleTextAttributes = textAttributes
        view.backgroundColor = Constants.backgroundColor
        tableView.backgroundColor = Constants.backgroundColor
        tableView.separatorColor = .clear
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: Notification.Name("ChangeLanguage"), object: nil)
    }
    
    @objc func changeLanguage() {
        header.topItem?.title = LocalizeUtils.defaultLocalizer.stringForKey(key: header.topItem?.title ?? "")
        for (index, setting) in settingMenu.enumerated() {
            var temp = settingMenu[index]
            temp.changeName(to: LocalizeUtils.defaultLocalizer.stringForKey(key: setting.name))
            settingMenu[index] = temp
        }
        tableView.reloadData()
    }
    
    private func initializeCallbacks() {
        callbacks.append({
            let fontConfig = UIFontPickerViewController.Configuration()
            fontConfig.includeFaces = true
            let fontPicker = UIFontPickerViewController(configuration: fontConfig)
            fontPicker.delegate = self
            self.present(fontPicker, animated: true, completion: nil)
        })
        callbacks.append(nil)
        callbacks.append({
            ControllerHelper().changeVC(identifier: "loginPage")
            CurrentVirus.shared.virus = nil
        })
    }
    
    func doCallback(i: Int) {
        guard let method = callbacks[i] else {
            return
        }
        method()
    }
}

//  MARK: - Extension
extension SettingViewController: UITableViewDelegate, UITableViewDataSource, UIFontPickerViewControllerDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell") as! SettingCell
        cell.delegate = self
        cell.setupCell(setting: settingMenu[indexPath.row], index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func fontPickerViewControllerDidPickFont(_ viewController: UIFontPickerViewController) {
        guard let descriptor = viewController.selectedFontDescriptor else { return }
        UILabel.appearance().font = UIFont(descriptor: descriptor, size: 18.0)
        UITextField.appearance().font = UIFont(descriptor: descriptor, size: 18.0)
        ControllerHelper().changeVC(identifier: "tabID")
    }
}
