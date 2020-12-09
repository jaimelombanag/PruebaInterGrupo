//
//  ContentView.swift
//  InterGrupo
//
//  Created by Jaime Lombana on 7/12/20.
//
import SwiftUI
import MapKit

struct ContentView: View {
    
    
    @State var animate = false
    @State var endSplash = false
    
    
    var body: some View {
     
        ZStack{
            Login()
            ZStack{
                Image("logo")
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: animate ? .fill : .fit)
                    .frame(width: animate ? nil : 100, height: animate ? nil : 100)
                
                    .scaleEffect(animate ? 3 : 1)
                    .frame(width : UIScreen.main.bounds.width)
            
            }
            .ignoresSafeArea(.all, edges: .all)
            .onAppear(perform: animateSplash)
            .opacity(endSplash ? 0 : 1)
        }
        
    }
    
    func animateSplash(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25){
            withAnimation(Animation.easeOut(duration: 0.45)) {
                animate.toggle()
            }
            withAnimation(Animation.linear(duration: 0.35)) {
                endSplash.toggle()
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}










struct MapView: UIViewRepresentable {

    var latitude = 0.0
    var longitude = 0.0
    var pais = ""
    var capital = ""
    
    
    func makeUIView(context: Context) -> MKMapView {
            MKMapView(frame: .zero)
        }

        func updateUIView(_ view: MKMapView, context: Context) {
    
            view.mapType = MKMapType.standard 

            let mylocation = CLLocationCoordinate2D(latitude: latitude,longitude: longitude)

            let coordinate = CLLocationCoordinate2D(
                latitude: latitude, longitude: longitude)
            let span = MKCoordinateSpan(latitudeDelta: 3, longitudeDelta: 3)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            view.setRegion(region, animated: true)

            let annotation = MKPointAnnotation()
            annotation.coordinate = mylocation

            annotation.title = pais
            annotation.subtitle = capital
            view.addAnnotation(annotation)
        }
}





