//
//  VirusDetailsViewController.swift
//  VirusMap
//
//  Created by Angelina Rusinovich on 9.02.21.
//

import UIKit
import AVKit

class VirusDetailsViewController: UIViewController, LocalizableApp {
    
    //  MARK: - Vars
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var domainLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var mortalityLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var photoGalleryButton: UIButton!
    
    private var player: AVPlayer = AVPlayer()
    private var playerViewController = AVPlayerViewController()
    
    var virus: Virus?
    
    //  MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        changeLanguage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PhotoGalleryViewController, segue.identifier == "toGalleryFromDetails" {
            vc.virus = virus
        }
    }
    
    //  MARK: - Functions
    @objc func changeLanguage() {
        navigationController?.title = LocalizeUtils.defaultLocalizer.stringForKey(key: navigationController?.title ?? "")
        navigationItem.rightBarButtonItem?.title = LocalizeUtils.defaultLocalizer.stringForKey(key: navigationItem.rightBarButtonItem?.title ?? "")
        photoGalleryButton.setTitle(LocalizeUtils.defaultLocalizer.stringForKey(key: photoGalleryButton.title(for: .normal) ?? ""), for: .normal)
    }
    
    private func setupUI() {
        view.backgroundColor = Constants.backgroundColor
        contentView.backgroundColor = Constants.backgroundColor
        setupVideoPlayer()
        setupButton()
        guard let virus = virus else { return }
        imageView.image = UIImage(named: virus.image)
        fullnameLabel.text = virus.fullName
        nicknameLabel.text = virus.nickName
        locationLabel.text = virus.continent.concatWithSeparator(value: virus.country, separator: ", ")
        yearLabel.text = "\(virus.year)"
        domainLabel.text = virus.domain
        mortalityLabel.text = "\(virus.mortality)%"
    }
    
    private func setupButton() {
        photoGalleryButton.layer.borderWidth = 2.5
        photoGalleryButton.layer.borderColor = CGColor(red: 0 / 255, green: 230 / 255, blue: 0 / 255, alpha: 1.0)
        photoGalleryButton.layer.cornerRadius = photoGalleryButton.layer.frame.height / 2
        photoGalleryButton.tintColor = .green
    }
    
    private func setupVideoPlayer() {
        guard let videoUrl = URL(string: virus?.link ?? "") else {
            let playerViewFrame = playerView.frame
            let label = UILabel(frame: CGRect(x: playerViewFrame.width / 2 - 80, y: playerViewFrame.height / 2 - 20, width: 140, height: 50))
            label.text = "No data for player."
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
            playerView.addSubview(label)
            return
        }
        player = AVPlayer(url: videoUrl)
        playerViewController.player = player
        playerViewController.view.frame.size.height = playerView.frame.size.height
        playerViewController.view.frame.size.width = playerView.frame.size.width
        self.playerView.addSubview(playerViewController.view)
        playerViewController.player?.play()
    }
}
