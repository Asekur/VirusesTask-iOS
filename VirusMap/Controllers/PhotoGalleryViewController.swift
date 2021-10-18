//
//  PhotoGalleryViewController.swift
//  VirusMap
//
//  Created by Angelina Rusinovich on 21.02.21.
//

import UIKit
import FirebaseAuth

class PhotoGalleryViewController: UIViewController, LocalizableApp {
    //  MARK: - Vars
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let imageName = Array.init(repeating: "", count: 20)
    private let squareBorder = UIScreen.main.bounds.width / 3 - 1
    private var imageUrls = [String]()
    var virus: Virus?
    
    //  MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
        fetchGallery()
        validateGallery()
        collectionView.backgroundColor = Constants.backgroundColor
        view.backgroundColor = Constants.backgroundColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        changeLanguage()
    }
    
    //  MARK: - Functions
    @IBAction func addPhotoTapped(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    @objc func changeLanguage() {
        navigationItem.title = LocalizeUtils.defaultLocalizer.stringForKey(key: navigationItem.title ?? "")
        navigationItem.leftBarButtonItem?.title = LocalizeUtils.defaultLocalizer.stringForKey(key: navigationItem.leftBarButtonItem?.title ?? "")
    }
    
    @objc private func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {

        UIView.transition(with: self.view, duration: 0.5, options: [.curveEaseInOut], animations: {
                            self.navigationController?.isNavigationBarHidden = false
                            sender.view?.removeFromSuperview() }, completion: nil)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @objc private func startZooming(_ sender: UIPinchGestureRecognizer) {
      let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
      guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
      sender.view?.transform = scale
      sender.scale = 1
    }
    
    private func validateGallery() {
        guard let uid = virus?.uid,
              let currentUID = CurrentVirus.shared.virus?.uid,
              uid == currentUID else {
            navigationItem.rightBarButtonItem?.tintColor = .clear
            navigationItem.rightBarButtonItem?.isEnabled = false
            return
        }
        navigationItem.rightBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    private func fetchGallery() {
        guard let uid = virus?.uid else { return }
        let ref = Ref().databaseSpecificGallery(uid: uid)
        ref.observe(.childAdded, with: { (snapshot) in
            guard let url = snapshot.value as? String else { return }
            self.imageUrls.append(url)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })
    }
}
//  MARK: - Extension
extension PhotoGalleryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCollectionViewCell
        
        cell.setupCell(url: imageUrls[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: squareBorder, height: squareBorder)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        func createImageView(image: UIImage) -> UIImageView {
            let imageView = UIImageView(image: image)
            imageView.frame = UIScreen.main.bounds
            imageView.backgroundColor = .black
            imageView.contentMode = .scaleAspectFit
            imageView.isUserInteractionEnabled = true
            return imageView
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as! PhotoCollectionViewCell
        guard let image = cell.cellImage.image else { return }
        let newImageView = createImageView(image: image)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming(_:)))
        newImageView.addGestureRecognizer(tap)
        newImageView.addGestureRecognizer(pinchGesture)
        
        UIView.transition(with: self.view, duration: 0.5, options: [.curveEaseIn], animations: {
                            self.navigationController?.isNavigationBarHidden = true
                            self.tabBarController?.tabBar.isHidden = true
                            self.view.addSubview(newImageView) }, completion: nil)
    }
}
//  MARK: - Extension for UIImagePickerController
extension PhotoGalleryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage,
           let uid = virus?.uid {
            StorageService.savePhotoToGallery(image: imageSelected, uid: uid)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
