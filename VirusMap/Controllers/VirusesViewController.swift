//
//  VirusesController.swift
//  VirusMap
//
//  Created by Angelina Rusinovich on 3.02.21.
//

import UIKit
import FirebaseAuth

protocol NotifyChange {
    func performRefreshControl()
}

protocol FilterApply {
    func clearFilters()
    func setFilters(year: Int, domain: String, mortality: Int)
}

class VirusesViewController: UIViewController, NotifyChange, LocalizableApp, FilterApply {
    
    //  MARK: - Vars
    @IBOutlet weak var filterButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var textField = UITextField()
    
    private var searchEnabled = false
    private var viruses = [Virus]()
    private var resultViruses = [Virus]()
    private var selectedVirus: Virus?
    private var refreshControl: UIRefreshControl!
    
    //  MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        addRefreshControl()
        self.hideKeyboardWhenTappedAround()
        fetchViruses()
 
        view.backgroundColor = Constants.backgroundColor
        tableView.backgroundColor = Constants.backgroundColor
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .white
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showFilters))
        tableView.separatorColor = .gray
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        changeLanguage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? VirusDetailsViewController, segue.identifier == "virusSegue" {
            vc.virus = selectedVirus
        } else if let vc = segue.destination as? EditVirusProfileViewController, segue.identifier == "showMyPage" {
            vc.delegate = self
        }
    }

    //  MARK: - Functions
    @IBAction func EditingTapped(_ sender: Any) {
        performSegue(withIdentifier: "showMyPage", sender: nil)
    }

    @objc func showFilters() {

        // Load and configure your view controller.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let optionsVC = storyboard.instantiateViewController(
                   withIdentifier: "popoverFilter") as! FilterViewController
        optionsVC.delegate = self
        present(optionsVC, animated: true, completion: nil)
    }
    
    @objc func changeLanguage() {
        navigationItem.title = LocalizeUtils.defaultLocalizer.stringForKey(key: navigationItem.title ?? "")
    }
    
    @objc func refreshTable() {
        viruses.removeAll()
        fetchViruses()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }

    private func addRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.tintColor = .gray
        refreshControl?.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    private func fetchViruses() {
        Ref().databaseViruses().observe(.childAdded, with: { (snapshot) in
            guard let dict = snapshot.value as? Dictionary<String, Any> else { return }
            let student = Virus(dictionary: dict)
            self.viruses.append(student)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    func clearFilters() {
        searchEnabled = false
        tableView.reloadData()
    }
    
    func setFilters(year: Int, domain: String, mortality: Int) {
        searchEnabled = true
        resultViruses = viruses.filter({ $0.year <= year && $0.domain == domain && $0.mortality <= mortality})
        tableView.reloadData()
    }
    
    func performRefreshControl() {
        refreshTable()
    }
}

//  MARK: - Extension Table View
extension VirusesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchEnabled ? resultViruses.count : viruses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "virusCell") as! VirusCell
        let virus = searchEnabled ? resultViruses[indexPath.row] : viruses[indexPath.row]
        cell.setupCell(virus: virus)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedVirus = searchEnabled ? resultViruses[indexPath.row] : viruses[indexPath.row]
        performSegue(withIdentifier: "virusSegue", sender: nil)
    }
}

extension ViewController: UIPopoverPresentationControllerDelegate {

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
