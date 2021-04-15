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

class HomeView:UIViewController, IHomeView, CLLocationManagerDelegate, GMSMapViewDelegate, UICollectionViewDelegate{
    private let presenter:IHomePresenter
    private var locationManager:ILocationManager
    private var displayedItems = [RestaurantItem]()
    private var restaurants = [ModelRestaurant]()
    private var favs = [String]()
    
    var collectionView:UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, RestaurantItem>!
    var snapshot: NSDiffableDataSourceSnapshot<Section, RestaurantItem>!
    
    private var button:UIButton?
    private var header:UIView?
    private var textField:UITextField?
    
    private var mapView: GMSMapView? = nil
    private var bounds = GMSCoordinateBounds()
    private var isShowingList = true
    
    private let HOME_LAT = 37.79079080125669
    private let HOME_LNG = -122.4060422175774
    
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
        view.backgroundColor = .white
        addHeader()
        addMapview()
        addCollectionView()
        addButton()
        requestLocation()
    }
    
    private func addHeader(){
        header = UIView()
        let queryView = UIView()
        textField = UITextField()
        let searchButton = UIButton(type: .roundedRect)
                
        searchButton.layer.cornerRadius = 8
        searchButton.backgroundColor = .systemGreen
        searchButton.setTitle("Search", for: .normal)
        searchButton.setTitleColor(.white, for: .normal)
        
        
        queryView.addSubview(textField!)
        queryView.layer.cornerRadius = 8
        textField?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField!.centerYAnchor.constraint(equalTo: queryView.centerYAnchor),
            textField!.leadingAnchor.constraint(equalTo: queryView.leadingAnchor),
            textField!.topAnchor.constraint(equalTo: queryView.topAnchor),
            textField!.widthAnchor.constraint(equalToConstant: 250)
        ])
        
        queryView.addSubview(searchButton)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.addTarget(self, action: #selector(pressedSearch(_:)), for: .touchUpInside)
        NSLayoutConstraint.activate([
            searchButton.heightAnchor.constraint(equalToConstant: 40.0),
            searchButton.trailingAnchor.constraint(equalTo: queryView.trailingAnchor),
            searchButton.topAnchor.constraint(equalTo: queryView.topAnchor, constant: 0.0),
            searchButton.widthAnchor.constraint(equalToConstant: 50)
        ])

        textField?.text = "Search for a restaurant"
        header?.addSubview(queryView)
        queryView.backgroundColor = .systemGray3
        queryView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            queryView.heightAnchor.constraint(equalTo: searchButton.heightAnchor),
            queryView.widthAnchor.constraint(equalTo: textField!.widthAnchor, constant: 75.0),
            queryView.centerYAnchor.constraint(equalTo: header!.centerYAnchor),
            queryView.centerXAnchor.constraint(equalTo: header!.centerXAnchor)
        ])
        
        view.addSubview(header!)
        header?.backgroundColor = .white
        header?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            header!.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 0.0),
            header!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header!.heightAnchor.constraint(equalToConstant: 100.0)
        ])
        
        header?.bringSubviewToFront(searchButton)
    }
    
    private func addButton(){
        button = UIButton(type: .roundedRect)
        if let uButton = button {
            
            uButton.layer.cornerRadius = 10.0
            uButton.layer.shadowColor = UIColor.gray.cgColor
            uButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            uButton.layer.shadowRadius = 6.0
            uButton.layer.shadowOpacity = 1
            
            uButton.layer.cornerRadius = 5
            uButton.backgroundColor = .systemGreen
            uButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .black)
            uButton.setTitle("Map", for: .normal)
            uButton.setTitleColor(.white, for: .normal)
            view.addSubview(uButton)
            uButton.translatesAutoresizingMaskIntoConstraints = false
            uButton.addTarget(self, action: #selector(pressedToggle(_:)), for: .touchUpInside)
            NSLayoutConstraint.activate([
                uButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0.0),
                uButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50.0),
                uButton.widthAnchor.constraint(equalToConstant: 100),
                uButton.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
    }
    
    private func addCollectionView(){
        var layoutConfig = UICollectionLayoutListConfiguration(appearance: .plain)
        layoutConfig.showsSeparators = false
        let listLayout = UICollectionViewCompositionalLayout.list(using: layoutConfig)
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: listLayout)
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: header!.bottomAnchor, constant: 0.0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0),
        ])
        let cellRegistration = UICollectionView.CellRegistration<RestaurantItemListCell, RestaurantItem> { [self] (cell, indexPath, item) in
            cell.item = item
            cell.switchClosure = getSwitchClosure()
            cell.isFavorite = favs.contains(item.restaurant.name)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, RestaurantItem>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: RestaurantItem) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                    for: indexPath,
                                                                    item: identifier)
            
            cell.accessories = [.disclosureIndicator()]
            
            return cell
        }
        collectionView.alpha = 100
    }
    
    private func addMapview(){
        let camera = GMSCameraPosition.camera(withLatitude: HOME_LAT, longitude: HOME_LNG, zoom: 15.0)
        mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.view.addSubview(mapView!)
        mapView?.delegate = self
        mapView?.alpha = 100
        
        mapView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView!.topAnchor.constraint(equalTo: header!.bottomAnchor, constant: 0.0),
            mapView!.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0),
            mapView!.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0),
            mapView!.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0),
        ])
    }
    
    private func getSwitchClosure() -> (String,Bool) -> Void {
        return { [self]restaurantName, switchValue in
            if(switchValue){
                presenter.saveFav(name: restaurantName)
            }
            else {
                presenter.deleteFav(name: restaurantName)
            }
        }
    }
    
    @objc private func pressedSearch(_ sender: UIButton){
        displayedItems.removeAll()
        restaurants.removeAll()
        mapView?.clear()
        presenter.query(name: (textField?.text)!)
        textField?.resignFirstResponder()
    }
    
    @objc private func pressedToggle(_ sender: UIButton){
        if(isShowingList){
            isShowingList = false
            collectionView.alpha = 0
            mapView?.alpha = 100
            button?.setTitle("List", for: .normal)
            if let uMapView = mapView {
            view.bringSubviewToFront(uMapView)}
            if let uButton = button {view.bringSubviewToFront(uButton)}
        }
        else{
            isShowingList = true
            collectionView.alpha = 100
            mapView?.alpha = 0
            button?.setTitle("Map", for: .normal)
            view.bringSubviewToFront(collectionView)
            if let uButton = button {view.bringSubviewToFront(uButton)}
        }
    }
    
    private func requestLocation(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.setView(view: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.shutdown()
    }
    
    func displayFavs(favs: [String]) {
        self.favs = favs
    }
    
    func displayImg(imgRef: String, imgBase64: String) {
        for rest in restaurants {
            if(imgRef == rest.iconRef){
                let image = UIImage(data: Data(base64Encoded: imgBase64)!)
                let item = RestaurantItem(restaurant: rest, image: image)
                snapshot.appendItems([RestaurantItem](arrayLiteral: item), toSection: .main)
                displayedItems.append(item)
                DispatchQueue.main.async { [unowned self] in
                    let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: rest.lat, longitude: rest.lng))
                    marker.title = rest.name
                    marker.map = mapView
                    bounds = bounds.includingCoordinate(CLLocationCoordinate2D(latitude: rest.lat, longitude: rest.lng))
                }
            }
        }
        DispatchQueue.main.async { [unowned self] in
            mapView?.animate(with: .fit(bounds, withPadding: 30.0))
        }
        dataSource.apply(snapshot, animatingDifferences: true)
        
    }
    
    func displayRests(rests: [ModelRestaurant]) {
        restaurants = rests
        bounds = GMSCoordinateBounds()
        snapshot = NSDiffableDataSourceSnapshot<Section, RestaurantItem>()
        snapshot.appendSections([.main])
    }
    
    func error(error: KotlinException) {
        print(error)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus){
        if(status == CLAuthorizationStatus.denied){
            presenter.show(lat: HOME_LAT, lng: HOME_LNG)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        presenter.show(lat: locations[0].coordinate.latitude, lng: locations[0].coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let rest = displayedItems[indexPath.item].restaurant
        let alert = UIAlertController(title: "\(rest.name)", message: "Located at \(rest.formattedAddress), \(rest.numReviews) reviewers have given this restaurant an averaged score of \(rest.score) with price range \(rest.price) of 5.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: {_ in }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        return getInfoWindow(marker: marker)
    }
    
    
    private func getRestaurantItem(name:String?) -> RestaurantItem? {
        for item in displayedItems {
            if(item.restaurant.name == name) { return item }
        }
        return nil
    }
    
    private func getInfoWindow(marker:GMSMarker) -> UIView {
        let infoWindow = UIStackView()
        if let item = getRestaurantItem(name: marker.title) {
            infoWindow.backgroundColor = .white
            infoWindow.layer.cornerRadius = 10.0
            infoWindow.layer.shadowColor = UIColor.gray.cgColor
            infoWindow.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
            infoWindow.layer.shadowRadius = 6.0
            infoWindow.layer.shadowOpacity = 0.7
            infoWindow.axis = .horizontal
            infoWindow.alignment = .center
            infoWindow.distribution = .fill
        
            let imageview = UIImageView(image: item.image)
        
            infoWindow.addArrangedSubview(imageview)
            infoWindow.translatesAutoresizingMaskIntoConstraints = false
            infoWindow.frame = CGRect(origin: marker.infoWindowAnchor, size: CGSize(width: 100, height: 50))
            
        
            
            let score = UIStackView()
            if(item.restaurant.score >= 1){
                for _ in 1 ... Int(item.restaurant.score) {
                        let imgView = UIImageView(image: UIImage(named: "star"))
                        imgView.translatesAutoresizingMaskIntoConstraints = false
                        let spacer = UIView()
                        NSLayoutConstraint.activate([
                            imgView.heightAnchor.constraint(equalToConstant: CGFloat(20)),
                            imgView.widthAnchor.constraint(equalToConstant: CGFloat(20)),
                            spacer.widthAnchor.constraint(equalToConstant: 5)
                        ])
                        score.addArrangedSubview(imgView)
                        score.addArrangedSubview(spacer)
                    }
                }
            
            
            let numReviewsLabel = UITextField()
            numReviewsLabel.textColor = .systemGray
            numReviewsLabel.font = UIFont.systemFont(ofSize: 14)
            numReviewsLabel.text = "(\(item.restaurant.numReviews))"
            
            let addressLabel = UITextField()
            addressLabel.textColor = .systemGray
            
            let secondaryStack = UIStackView()
            secondaryStack.axis = .horizontal
            secondaryStack.addArrangedSubview(score)
            secondaryStack.addArrangedSubview(numReviewsLabel)
            NSLayoutConstraint.activate([
                score.leadingAnchor.constraint(equalTo: secondaryStack.leadingAnchor),
                numReviewsLabel.leadingAnchor.constraint(equalTo: score.trailingAnchor)
            ])
            
            var priceString = ""
                if(item.restaurant.price >= 1){
                    for _ in 1 ... item.restaurant.price {
                        priceString.append("$")
                    }
            }
            if(priceString == ""){
                addressLabel.text = item.restaurant.formattedAddress
            }
            else{
                addressLabel.text = "\(priceString) - \(item.restaurant.formattedAddress)"
            }
            if let truncMe = addressLabel.text {
                if(truncMe.count > 25){
                    addressLabel.text = String(truncMe.prefix(25) + "...")
                }
            }
            
            let textStack = UIStackView()
            textStack.axis = .vertical
            infoWindow.addArrangedSubview(textStack)
            textStack.translatesAutoresizingMaskIntoConstraints = false
        
            let nameLabel = UITextField()
            nameLabel.textAlignment = .left
            nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
            nameLabel.textColor = .systemGray
            nameLabel.text = item.restaurant.name
        
            textStack.addArrangedSubview(nameLabel)
            textStack.addArrangedSubview(secondaryStack)
            textStack.addArrangedSubview(addressLabel)
            }
        return infoWindow
    }
    
}
