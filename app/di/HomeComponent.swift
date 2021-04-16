//
//  HomeComponent.swift
//  app
//
//  Created by Mitchell Drew on 13/4/21.
//

import Foundation
import NeedleFoundation
import presenter
import provider
import CoreLocation

protocol HomeDependency: Dependency {
    var freezer:IFreezer {get}
    var restProvider:IRestaurantProvider {get}
    var favProvider:IFavProvider {get}
    var imgProvider:IImageProvider {get}
    var searchRadius:Double {get}
    var locationManager:ILocationManager {get}
}

class HomeComponent: Component<HomeDependency>, HomeViewBuilder {
    var presenter: IHomePresenter {
        return HomePresenter(freezer: dependency.freezer, restProvider: dependency.restProvider, favoritesProvider: dependency.favProvider, imageProvider: dependency.imgProvider, searchRadius: dependency.searchRadius)
    }
    
    func homeView() -> UIViewController {
        return HomeView(presenter: presenter, locationManager: dependency.locationManager)
    }
}

protocol HomeViewBuilder {
    func homeView() -> UIViewController
}
