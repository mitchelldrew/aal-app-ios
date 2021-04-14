//
//  Extension.swift
//  app
//
//  Created by Mitchell Drew on 13/4/21.
//

import Foundation
import CoreLocation

protocol ILocationManager{
    var delegate:CLLocationManagerDelegate? { get set }
    func requestWhenInUseAuthorization()
    func requestLocation()
}

extension CLLocationManager:ILocationManager{}
