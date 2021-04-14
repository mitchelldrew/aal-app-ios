//
//  ViewController.swift
//  app
//
//  Created by Mitchell Drew on 13/4/21.
//

import UIKit
import presenter
import provider

class MyListener: IRestaurantProviderListener {
    func onError(error: KotlinException) {
        print("error")
        print(error)
    }
    
    func onReceive(query: String, elements: [ModelRestaurant]) {
        print("onReceive query")
    }
    
    func onReceive(elements: [ModelRestaurant]) {
        print("onReceive elements")
        print(elements)
    }
    
    
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemRed
        
        let provider = PlacesRestaurantProvider(restManager: URLSession.shared, mapper: PlacesRestaurantMapper(), apiKey: "AIzaSyDibnvC-mTYs4RK_eIuzdPRuaxhAjYGT7g")
        provider.addListener(restListener: MyListener())
        provider.get(lat: -33.8670522, lng: 151.1957362, rad: 2000)
    }


}

