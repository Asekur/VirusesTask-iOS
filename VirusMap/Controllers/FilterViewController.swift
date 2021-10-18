//
//  FilterViewController.swift
//  VirusMap
//
//  Created by Angelina Rusinovich on 20.03.21.
//

import UIKit

enum VirusType: String {
    case bacteria = "Bacteria"
    case virus = "Virus"
        
    static subscript(_ i: Int) -> String {
        return i == 1 ? bacteria.rawValue : virus.rawValue
    }
}

class FilterViewController: UIViewController {
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var yearSlider: UISlider!
    @IBOutlet weak var damainLabel: UILabel!
    @IBOutlet weak var domainSlider: UISlider!
    @IBOutlet weak var mortalityLabel: UILabel!
    @IBOutlet weak var mortalitySlider: UISlider!
    @IBOutlet weak var useFiltersButton: UIButton!
    @IBOutlet weak var showAllButton: UIButton!
    @IBOutlet weak var yearNameLabel: UILabel!
    @IBOutlet weak var mortalityNameLabel: UILabel!
    @IBOutlet weak var domainNameLabel: UILabel!
    
    var delegate: FilterApply?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Constants.backgroundColor
        setupButton(btn: useFiltersButton)
        setupButton(btn: showAllButton)
        mortalitySlider.addTarget(self, action: #selector(changeValueForMortality), for: .allTouchEvents)
        yearSlider.addTarget(self, action: #selector(changeValueForYear), for: .allTouchEvents)
        domainSlider.addTarget(self, action: #selector(changeValueForDomain), for: .allTouchEvents)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        changeLanguage()
    }
    
    @objc func changeLanguage() {
        useFiltersButton.setTitle(LocalizeUtils.defaultLocalizer.stringForKey(key: useFiltersButton.title(for: .normal) ?? ""), for: .normal)
        showAllButton.setTitle(LocalizeUtils.defaultLocalizer.stringForKey(key: showAllButton.title(for: .normal) ?? ""), for: .normal)
        damainLabel.text = LocalizeUtils.defaultLocalizer.stringForKey(key: damainLabel.text ?? "")
        domainNameLabel.text = LocalizeUtils.defaultLocalizer.stringForKey(key: domainNameLabel.text ?? "")
        yearNameLabel.text = LocalizeUtils.defaultLocalizer.stringForKey(key: yearNameLabel.text ?? "")
        mortalityNameLabel.text = LocalizeUtils.defaultLocalizer.stringForKey(key: mortalityNameLabel.text ?? "")
    }
    
    @IBAction func useFilters(_ sender: Any) {
        delegate?.setFilters(year: Int(yearSlider.value), domain: VirusType[Int(domainSlider.value.rounded())], mortality: Int(mortalitySlider.value))
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clearFilters(_ sender: Any) {
        delegate?.clearFilters()
        dismiss(animated: true, completion: nil)
    }
    
    @objc func changeValueForMortality() {
        mortalityLabel.text = "\(Int(mortalitySlider.value))"
    }
    
    @objc func changeValueForDomain() {
        damainLabel.text = VirusType[Int(domainSlider.value.rounded())]
        damainLabel.text = LocalizeUtils.defaultLocalizer.stringForKey(key: damainLabel.text ?? "")
    }
    
    @objc func changeValueForYear() {
        yearLabel.text = "\(Int(yearSlider.value))"
    }
    
    private func setupButton(btn: UIButton) {
        btn.layer.borderWidth = 2.5
        btn.layer.borderColor = CGColor(red: 0 / 255, green: 230 / 255, blue: 0 / 255, alpha: 1.0)
        btn.layer.cornerRadius = btn.layer.frame.height / 2
        btn.tintColor = .green
    }
}

