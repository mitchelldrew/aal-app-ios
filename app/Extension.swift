//
//  Extension.swift
//  app
//
//  Created by Mitchell Drew on 13/4/21.
//

import Foundation
import CoreLocation
import UIKit

protocol ILocationManager{
    var delegate:CLLocationManagerDelegate? { get set }
    func requestWhenInUseAuthorization()
    func requestLocation()
}

extension CLLocationManager:ILocationManager{}

extension UIStackView {

    func removeFully(view: UIView) {
        removeArrangedSubview(view)
        view.removeFromSuperview()
    }

    func removeFullyAllArrangedSubviews() {
        arrangedSubviews.forEach { (view) in
            removeFully(view: view)
        }
    }

}
