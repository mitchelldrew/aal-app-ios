

import CoreLocation
import Foundation
import NeedleFoundation
import presenter
import provider

// swiftlint:disable unused_declaration
private let needleDependenciesHash : String? = nil

// MARK: - Registration

public func registerProviderFactories() {
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponent") { component in
        return EmptyDependencyProvider(component: component)
    }
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: "^->RootComponent->HomeComponent") { component in
        return HomeDependencycad225e9266b3c9a56ddProvider(component: component)
    }
    
}

// MARK: - Providers

private class HomeDependencycad225e9266b3c9a56ddBaseProvider: HomeDependency {
    var freezer: IFreezer {
        return rootComponent.freezer
    }
    var restProvider: IRestaurantProvider {
        return rootComponent.restProvider
    }
    var favProvider: IFavProvider {
        return rootComponent.favProvider
    }
    var imgProvider: IImageProvider {
        return rootComponent.imgProvider
    }
    var searchRadius: Double {
        return rootComponent.searchRadius
    }
    var locationManager: ILocationManager {
        return rootComponent.locationManager
    }
    private let rootComponent: RootComponent
    init(rootComponent: RootComponent) {
        self.rootComponent = rootComponent
    }
}
/// ^->RootComponent->HomeComponent
private class HomeDependencycad225e9266b3c9a56ddProvider: HomeDependencycad225e9266b3c9a56ddBaseProvider {
    init(component: NeedleFoundation.Scope) {
        super.init(rootComponent: component.parent as! RootComponent)
    }
}
