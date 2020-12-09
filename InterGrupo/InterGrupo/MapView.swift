//
//  MapView.swift
//  InterGrupo
//
//  Created by Jaime Lombana on 9/12/20.
//

import SwiftUI
import MapKit

struct MapView: View {
    var latitude = 0.0
    var longitude = 0.0
    var pais = ""
    var capital = ""
    
    
    func makeUIView(context: Context) -> MKMapView {
            MKMapView(frame: .zero)
        }

        func updateUIView(_ view: MKMapView, context: Context) {


            // 1
            view.mapType = MKMapType.standard // (satellite)

            // 2
            let mylocation = CLLocationCoordinate2D(latitude: latitude,longitude: longitude)

            // 3
            let coordinate = CLLocationCoordinate2D(
                latitude: latitude, longitude: longitude)
            let span = MKCoordinateSpan(latitudeDelta: 3, longitudeDelta: 3)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            view.setRegion(region, animated: true)

            // 4
            let annotation = MKPointAnnotation()
            annotation.coordinate = mylocation

            annotation.title = pais
            annotation.subtitle = capital
            view.addAnnotation(annotation)


        }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
