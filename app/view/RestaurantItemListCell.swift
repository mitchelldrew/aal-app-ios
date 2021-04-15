//
//  RestaurantItemListCell.swift
//  app
//
//  Created by Mitchell Drew on 14/4/21.
//

import Foundation
import UIKit

class RestaurantItemListCell: UICollectionViewListCell {
    var item: RestaurantItem?
    var isFavorite:Bool = false
    var switchClosure: ((String, Bool) -> Void)?
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        var newConfiguration = RestaurantItemContentConfiguration().updated(for: state)
            
        newConfiguration.name = item?.restaurant.name
        newConfiguration.address = item?.restaurant.formattedAddress
        newConfiguration.image = item?.image
        newConfiguration.numReviews = item?.restaurant.numReviews
        newConfiguration.score = item?.restaurant.score
        newConfiguration.price = item?.restaurant.price
        newConfiguration.isFav = isFavorite
        newConfiguration.switchClosure = switchClosure
        
        contentConfiguration = newConfiguration
        }
}
