//
//  MapViewController.swift
//  VirusMap
//
//  Created by Angelina Rusinovich on 3.02.21.
//

import UIKit
import GoogleMaps
import FirebaseDatabase

class MapViewController: UIViewController, CLLocationManagerDelegate {
    //  MARK: - Vars
    @IBOutlet weak var mapView: UIView!
    
    private var totalViruses: UInt = 0
    private var fetchedViruses: UInt = 0 {
        willSet {
            if newValue == totalViruses {
                setupMap()
            }
        }
    }
    private var places = [String]()
    private var viruses = [Virus]()
    
    //  MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchedViruses = 0
        places.removeAll()
        viruses.removeAll()
        setupMarkers()
    }
    
    private func setupMap() {
        let camera = GMSCameraPosition.camera(withLatitude: 53.9006, longitude: 27.5590, zoom: 1.0)
        let mapView = GMSMapView.map(withFrame: self.mapView.frame, camera: camera)
        self.view.addSubview(mapView)
        for place in places {
            let virusesWithTheSamePoints = self.viruses.filter({ $0.country == place})
            let address = place
            var snippet = ""
            for virus in virusesWithTheSamePoints {
                snippet += virus.nickName + "\n"
            }
            self.getCoordinateFrom(address: address, completion: { coordinate, error in
                guard let coordinate = coordinate, error == nil else { return }
                 DispatchQueue.main.async {
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
                    marker.appearAnimation = .pop
                    marker.title = address
                    marker.snippet = snippet
                    marker.map = mapView
                 }
            })
        }
    }
    
    private func setupMarkers() {
        Ref().databaseViruses().observe(.value, with: { (snapshot) in
            self.totalViruses = snapshot.childrenCount
            Ref().databaseViruses().observe(.childAdded, with: {(snapshot) in
                guard let dict = snapshot.value as? Dictionary<String, Any> else { return }
                let virus = Virus(dictionary: dict)
                if !self.places.contains(virus.country) {
                    self.places.append(virus.country)
                }
                self.viruses.append(virus)
                self.fetchedViruses += 1
            })
        })
    }
    
    private func getCoordinateFrom(address: String, completion: @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?) -> () ) {
        CLGeocoder().geocodeAddressString(address) { completion($0?.first?.location?.coordinate, $1) }
    }
}
