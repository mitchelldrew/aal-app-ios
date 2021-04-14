//
//  RestaurantItem.swift
//  app
//
//  Created by Mitchell Drew on 14/4/21.
//

import Foundation
import presenter
import UIKit

struct RestaurantItem: Hashable {
    var image:UIImage?
    let restaurant:ModelRestaurant
    
    init(restaurant:ModelRestaurant, image:UIImage?){
        self.image = image
        self.restaurant = restaurant
    }
}

struct SFSymbolItem: Hashable {
    let name: String
    let image: UIImage
    
    init(name: String) {
        self.name = name
        self.image = UIImage(systemName: name)!
    }
}

let dataItems = [
    SFSymbolItem(name: "mic"),
    SFSymbolItem(name: "mic.fill"),
    SFSymbolItem(name: "message"),
    SFSymbolItem(name: "message.fill"),
    SFSymbolItem(name: "sun.min"),
    SFSymbolItem(name: "sun.min.fill"),
    SFSymbolItem(name: "sunset"),
    SFSymbolItem(name: "sunset.fill"),
    SFSymbolItem(name: "pencil"),
    SFSymbolItem(name: "pencil.circle"),
    SFSymbolItem(name: "highlighter"),
    SFSymbolItem(name: "pencil.and.outline"),
    SFSymbolItem(name: "personalhotspot"),
    SFSymbolItem(name: "network"),
    SFSymbolItem(name: "icloud"),
    SFSymbolItem(name: "icloud.fill"),
    SFSymbolItem(name: "car"),
    SFSymbolItem(name: "car.fill"),
    SFSymbolItem(name: "bus"),
    SFSymbolItem(name: "bus.fill"),
    SFSymbolItem(name: "flame"),
    SFSymbolItem(name: "flame.fill"),
    SFSymbolItem(name: "bolt"),
    SFSymbolItem(name: "bolt.fill")
]



