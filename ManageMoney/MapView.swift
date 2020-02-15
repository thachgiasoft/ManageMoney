//
//  MaoView.swift
//  ManageMoney
//
//  Created by Omar Serrah on 09/01/2020.
//  Copyright © 2020 Omar Serrah. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    
    @ObservedObject var locationManager = LocationManager()

    var userLatitude: Double {
        return (locationManager.lastLocation?.coordinate.latitude ?? 0)
     }

     var userLongitude: Double {
        return (locationManager.lastLocation?.coordinate.longitude ?? 0)
     }
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        MKMapView()
    }
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
        let coordinate = CLLocationCoordinate2D(latitude: userLatitude , longitude: userLongitude )
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        uiView.setRegion(region, animated: true)
        
      }
    
        
}


struct MaoView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}

