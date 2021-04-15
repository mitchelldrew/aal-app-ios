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
