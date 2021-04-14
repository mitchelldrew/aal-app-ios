//
//  HomeView.swift
//  app
//
//  Created by Mitchell Drew on 13/4/21.
//

import Foundation
import presenter
import CoreLocation
import UIKit
import GoogleMaps

class HomeView:UIViewController, IHomeView, CLLocationManagerDelegate, GMSMapViewDelegate{
    private let presenter:IHomePresenter
    private var locationManager:ILocationManager
    private let HOME_LAT = 37.79079080125669
    private let HOME_LNG = -122.4060422175774
    private var mapView: GMSMapView? = nil
    private var displayedItems = [RestaurantItem]()
    
    var collectionView:UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, RestaurantItem>!
    var snapshot: NSDiffableDataSourceSnapshot<Section, RestaurantItem>!
    
    enum Section{
        case main
    }
    
    init(presenter:IHomePresenter, locationManager:ILocationManager){
        self.presenter = presenter
        self.locationManager = locationManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestLocation()
        //addMapview()
        
        
        let layoutConfig = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: listLayout)
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 0.0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0),
        ])
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, RestaurantItem> { (cell, indexPath, item) in
            
            var content = cell.defaultContentConfiguration()
            content.image = item.image
            content.text = item.restaurant.name
            
            cell.contentConfiguration = content
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, RestaurantItem>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: RestaurantItem) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                    for: indexPath,
                                                                    item: identifier)
            
            cell.accessories = [.disclosureIndicator()]
            
            return cell
        }
        
        /*
        snapshot = NSDiffableDataSourceSnapshot<Section, RestaurantItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(dataItems, toSection: .main)

        dataSource.apply(snapshot, animatingDifferences: false)
        */
    }
    
    
    
    private func addMapview(){
        let camera = GMSCameraPosition.camera(withLatitude: HOME_LAT, longitude: HOME_LNG, zoom: 15.0)
        mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        //mapView?.addConstraint(NSLayoutConstraint)
        self.view.addSubview(mapView!)
        mapView?.delegate = self
    }
    
    private func requestLocation(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("hello")
        print(marker.infoWindowAnchor)
        return true
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.setView(view: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.shutdown()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        presenter.show(lat: locations[0].coordinate.latitude, lng: locations[0].coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func displayFavs(favs: [String]) {
        print("%%%%%%%%%%%%%%%")
        print(favs)
        print("%%%%%%%%%%%%%%%")
    }
    
    func displayImg(imgRef: String, imgBase64: String) {
        for item in displayedItems {
            if(imgRef == item.restaurant.iconRef){
                displayedItems.removeAll{item in return item.restaurant.iconRef == imgRef}
                let image = UIImage(data: Data(base64Encoded: imgBase64)!)
                let item = RestaurantItem(restaurant: item.restaurant, image: image)
            }
        }
    }
    
    func displayRests(rests: [ModelRestaurant]) {
        var items = [RestaurantItem]()
        for rest in rests {
            items.append(RestaurantItem(restaurant: rest, image: nil))
        }
        displayedItems = items
        
        snapshot = NSDiffableDataSourceSnapshot<Section, RestaurantItem>()
        snapshot.appendSections([.main])
        snapshot.appendItems(displayedItems, toSection: .main)

        dataSource.apply(snapshot, animatingDifferences: false)
        
    }
    
    func error(error: KotlinException) {
        print(error)
    }
    
    var headerView: UIView {
        var header = UIView()
        var filterButton = UIButton()
        var queryField = UIView()
        var searchField = UITextField()
        var searchButton = UIButton()
        
        queryField.addSubview(searchButton)
        queryField.addSubview(searchField)
        
        //header.addSubview()
        
        filterButton.addConstraint(
            NSLayoutConstraint(item: searchButton, attribute: .leading, relatedBy: .equal, toItem: view.window, attribute: .leading, multiplier: 1.0, constant: 20))
        
        return header
    }
}
