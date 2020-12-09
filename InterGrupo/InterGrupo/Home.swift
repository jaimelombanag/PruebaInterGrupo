//
//  Home.swift
//  InterGrupo
//
//  Created by Jaime Lombana on 9/12/20.
//

import SwiftUI
import Alamofire
import SwiftyJSON

struct Home: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var obs = observer()
    @State private var searchText : String = ""
    
 
    init() {
        self.presentationMode.wrappedValue.dismiss()
       
    }
    
    
    var body: some View {
        
        NavigationView{
            VStack{
                List{
                    TextField("Type your search",text: $searchText).textFieldStyle(RoundedBorderTextFieldStyle())

                    ForEach(obs.getListPaises().filter{$0.hasPrefix(searchText) || searchText == ""}, id:\.self){searchText in
                                   
                        card(name: searchText, capital: obs.getCapita(pais: searchText), region: obs.getRegion(pais: searchText), latitude: obs.getLatitud(pais: searchText), longitude: obs.getLongitud(pais: searchText))
                        
                        }
                    }
                    .navigationBarTitle(Text("Buscar pais"))
            }
        }
    }
}




class observer: ObservableObject {
    
    @Published var datas = [dataType]()
    var lstPaises = [String]()
    
    let url: String = "https://restcountries-v1.p.rapidapi.com/all"
    let headers: HTTPHeaders = [
        "X-RapidAPI-Key": "97c89c5cb5mshc73d0c89c3c72d8p12b0d4jsn0aac3b88c286"
      ]
    
    init() {
        AF.request(url, method: .get, headers: headers).responseData { [self] (data) in
            
            let json = try! JSON(data: data.data!)
                 
            for i in json{
                lstPaises.append(i.1["name"].stringValue)

                self.datas.append(dataType(id: i.1["name"].stringValue, capital: i.1["capital"].stringValue, region: i.1["region"].stringValue, latitude: i.1["latlng"][0].doubleValue, longitude: i.1["latlng"][1].doubleValue ))
            }
        }
    }
    
    
    
    func getListaObjeto() -> Array<dataType>{
        return datas
    
    }
    
   
    func getListPaises() -> Array<String>{
        return lstPaises
    }
    
    
    func getCapita(pais: String) -> String {
        var capital = ""
        for name in getListaObjeto() {
            if(pais == name.id){
                capital = name.capital
            }
        }
        return capital
    }
    
    
    func getRegion(pais: String) -> String {
        var region = ""
        for name in getListaObjeto() {
            if(pais == name.id){
                region = name.region
            }
        }
        return region
    }
    
    func getLatitud(pais: String) -> Double {
        var latitud = 0.0
        for name in getListaObjeto() {
            if(pais == name.id){
                latitud = name.latitude
            }
        }
        return latitud
    }
    
    func getLongitud(pais: String) -> Double {
        var longitud = 0.0
        for name in getListaObjeto() {
            if(pais == name.id){
                longitud = name.longitude
            }
        }
        return longitud
    }
    
}

// 0 representa nimero de index
// 1 la data del json
struct dataType: Identifiable{
    
    var id: String
    var capital: String
    var region : String
    var latitude: Double
    var longitude: Double
   
}

struct card : View {
    var name = ""
    var capital = ""
    var region = ""
    var latitude = 0.0
    var longitude = 0.0

    
    var body: some View{
        
        HStack{
            NavigationLink(destination: MapView(latitude: latitude, longitude: longitude, pais: name, capital: capital)) {
                VStack{
                    
                    Text("GO").font(.custom("Helvetica Neue", size: 25))
                        .foregroundColor(.orange)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    
                        Image(systemName: "location")
                            .padding(.vertical, -5)
                    
                }.padding(.all, 5)
                .frame(width:75, height: 60, alignment: .center)

            }
            .navigationBarTitle(Text("Lista de Paises"))
            .frame(width: 80, height: 60)
            .foregroundColor(.orange)
            
            .background(Color.black)
            .cornerRadius(10)
            .padding(.horizontal, 5)
          

            VStack(alignment: .leading){
                
                Text(name).font(.custom("Helvetica Neue", size: 28))
                    .foregroundColor(.blue)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .textCase(/*@START_MENU_TOKEN@*/.uppercase/*@END_MENU_TOKEN@*/)
                    .padding(.bottom, 5)
                    
                Text(capital).font(.custom("Helvetica Neue", size: 20))
                    .foregroundColor(.gray)
                    .fontWeight(.heavy)
                    .padding(.bottom, 5)
                    
                Text(region).font(.custom("Helvetica Neue", size: 25))
                    .foregroundColor(.black)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .textCase(/*@START_MENU_TOKEN@*/.uppercase/*@END_MENU_TOKEN@*/)
                    
            }
            
            Spacer()
            
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .background(Color(red: 255/255, green: 255/255, blue: 243/255))
        .modifier(CardModifier())
        .padding(.all, 10)
        
    }
}


struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 0)
    }
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
