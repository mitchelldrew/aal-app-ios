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
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        var newConfiguration = RestaurantItemContentConfiguration().updated(for: state)
            
        newConfiguration.name = item?.restaurant.name
        newConfiguration.address = item?.restaurant.formattedAddress
        
        contentConfiguration = newConfiguration
        }
}
