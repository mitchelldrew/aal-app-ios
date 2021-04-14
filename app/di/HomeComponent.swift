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

protocol HomeDependency: Dependency {
    
}

class HomeComponent: Component<HomeDependency>, HomeViewBuilder {
    
    
    
}

protocol HomeViewBuilder {
//    func homeView() -> UIViewController
}
