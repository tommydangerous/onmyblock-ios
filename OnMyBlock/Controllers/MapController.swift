//
//  MapController.swift
//  OnMyBlock
//
//  Created by Tommy DANGerous on 10/24/14.
//  Copyright (c) 2014 OnMyBlock. All rights reserved.
//

import Foundation
import MapKit

class MapController: Object {
  var delegate: AnyObject?

  // Methods
  // Public methods

  // Instance methods
  func boundsString(mapView: MKMapView) -> String {
    let region: MKCoordinateRegion = mapView.region
    // Northwest: maxLatitude, minLongitude
    let maxLatitude  = region.center.latitude + 
      (region.span.latitudeDelta * 0.5)
    let minLongitude = region.center.longitude - 
      (region.span.longitudeDelta * 0.5)
    // Southeast: minLatitude, maxLongitude
    let minLatitude  = region.center.latitude - 
      (region.span.latitudeDelta * 0.5)
    let maxLongitude = region.center.longitude + 
      (region.span.longitudeDelta * 0.5)
    
    return "[\(minLongitude),\(maxLatitude),\(maxLongitude),\(minLatitude)]"
  }
}
