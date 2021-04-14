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

class RootComponent: BootstrapComponent {
    var restManager:IRestManager{
        return URLSession.shared
    }
    
    var userDefaults:IUserDefaults{
        return UserDefaults.standard
    }
    
    var mapper:IDataMapper<[ModelRestaurant]>{
        return PlacesRestaurantMapper()
    }
    
    var apiKey:String{
        return "AIzaSyDibnvC-mTYs4RK_eIuzdPRuaxhAjYGT7g"
    }
    
    var restProvider:IRestaurantProvider{
        return PlacesRestaurantProvider(restManager: restManager, mapper: mapper, apiKey: apiKey)
    }
    
    var favsProvider:IFavProvider{
        return FavProvider(userDefaults: userDefaults)
    }
    
    var imageProvider:IImageProvider{
        return PlacesImageProvider(manager: restManager, apiKey: apiKey)
    }

    var presenter:IHomePresenter{
        return HomePresenter(restProvider: restProvider, favoritesProvider: favsProvider, imageProvider: imageProvider, searchRadius: 2000.0)
    }
}
