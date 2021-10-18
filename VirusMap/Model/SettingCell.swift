//
//  SettingCell.swift
//  VirusMap
//
//  Created by Angelina Rusinovich on 3.02.21.
//

import UIKit
import FirebaseAuth

enum SettingCellType: Int {
    case forwardable = 0, switchable, language, darkMode
}

struct SettingType {
    var name: String
    var type: SettingCellType
    
    mutating func changeName(to name: String) {
        self.name = name
    }
}

class SettingCell: UITableViewCell {
    
    @IBOutlet weak var menuParam: UILabel!
    @IBOutlet weak var switchControl: UISwitch!
    private var index: Int = 0
    var delegate: CallbackableSettings?
    
    override func awakeFromNib() {
        menuParam.textColor = .white
        tintColor = .white
        backgroundColor = Constants.backgroundColor
    }

    @objc func enableDarkMode() {
        self.window?.overrideUserInterfaceStyle = self.traitCollection.userInterfaceStyle == .dark ? .light : .dark
    }
    
    @objc func performNotification() {
        LocalizeUtils.defaultLocalizer.setSelectedLanguage(lang: switchControl.isOn ? "ru" : "Base")
        NotificationCenter.default.post(name: Notification.Name("ChangeLanguage"), object: nil)
    }
    
    @objc func callMethod() {
        delegate?.doCallback(i: index)
    }
    
    func setupCell(setting cell: SettingType, index: Int) {
        menuParam.text = cell.name
        self.index = index
        switch cell.type {
        case .forwardable:
            self.accessoryType = .disclosureIndicator
            let image = UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate)
            if let width = image?.size.width, let height = image?.size.height {
                let disclosureImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
                disclosureImageView.image = image
                accessoryView = disclosureImageView
            }
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(callMethod))
            addGestureRecognizer(tapGesture)
        case .language:
            switchControl.isHidden = false
            switchControl.addTarget(self, action: #selector(performNotification), for: .allEvents)
        default: break
        }
    }
}
