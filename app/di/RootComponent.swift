//
//  RootComponent.swift
//  app
//
//  Created by Mitchell Drew on 13/4/21.
//

import Foundation
import NeedleFoundation
import presenter
import provider
import CoreLocation

class RootComponent: BootstrapComponent {
    var homeComponent:HomeComponent {
        return HomeComponent(parent: self)
    }
    
    var restManager:IRestManager{
        return URLSession.shared
    }
    
    var userDefaults:IUserDefaults{
        return UserDefaults.standard
    }
    
    var mapper:IDataMapper<[ModelRestaurant]>{
        return PlacesRestaurantMapper()
    }
    
    var locationManager:ILocationManager{
        return CLLocationManager()
    }
    
    var apiKey:String{
        return "AIzaSyDIKzjfQQCahwJ9yEr8gBU9TqJ3MvbPXyY"
    }
    
    var searchRadius:Double{
        return 2000.0
    }
    
    var restProvider:IRestaurantProvider{
        return PlacesRestaurantProvider(restManager: restManager, mapper: mapper, apiKey: apiKey)
    }
    
    var favProvider:IFavProvider{
        return FavProvider(userDefaults: userDefaults)
    }
    
    var imgProvider:IImageProvider{
        return PlacesImageProvider(manager: restManager, apiKey: apiKey)
    }
    
    var freezer: IFreezer {
        return Freezer()
    }
}
