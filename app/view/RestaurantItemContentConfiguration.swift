//
//  RestaurantItemContentConfiguration.swift
//  app
//
//  Created by Mitchell Drew on 14/4/21.
//

import Foundation
import UIKit

struct RestaurantItemContentConfiguration: UIContentConfiguration, Equatable {
    
    var name:String?
    var address:String?
    var image:UIImage?
    var price:Int32?
    var score:Double?
    var numReviews:Int32?
    var isFav:Bool?
    var switchClosure: ((String, Bool) -> Void)?
    
    func makeContentView() -> UIView & UIContentView {
        return RestaurantItemContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> RestaurantItemContentConfiguration {
        guard state is UICellConfigurationState else {
                return self
            }
            let updatedConfiguration = self
            return updatedConfiguration
    }
    
    
    static func == (lhs: RestaurantItemContentConfiguration, rhs: RestaurantItemContentConfiguration) -> Bool {
        return lhs.name == rhs.name
    }
}
