//
//  ContentView.swift
//  InterGrupo
//
//  Created by Jaime Lombana on 7/12/20.
//
import SwiftUI
import Alamofire
import SwiftyJSON
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


struct Login: View {
    @State private var username1 = UserDefaults.standard.string(forKey: "name")
     
    @State var username: String = ""
    @State var password: String = ""
    
    @State
        var showsUp = false
   
    init() {
        UserDefaults.standard.set("Valerie", forKey: "name")
    }
    
    var body: some View {
        
        NavigationView {
            VStack {
                WelcomeText()
                UserImage()

                TextField("Username", text: $username)
                        .padding()
                    .background(Color.gray)
                        .cornerRadius(5.0)
                        .padding(.bottom, 20)
                SecureField("Password", text: $password)
                        .padding()
                        .background(Color.gray)
                        .cornerRadius(5.0)
                        .padding(.bottom, 20)
                
                
                
                NavigationLink(destination: Home()) {
                                Text("View 2")
                                    .font(.headline)
                            }
                
                
                Button(action: {
                        
                    validationLogin()
                        
                    }) {
                        LoginButtonContent()
                    }
               
                        
            }
            .padding()
        }
        
            
    }
    
    
    func validationLogin(){
        if(username == username1){
            print("Usuario Registrado")
           
                        
        }else{
            print("Usuario NO Registrado")
        }
    }
    
    
}

struct WelcomeText : View {
    var body: some View {
        return Text("Bienvenido...")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.bottom, 20)
    }
}

struct UserImage : View {
    var body: some View {
        return Image("logo")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 100, height: 100)
            .clipped()
            .cornerRadius(150)
            .padding(.bottom, 75)
    }
}

struct LoginButtonContent : View {
    var body: some View {
        return Text("LOGIN")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 220, height: 60)
            .background(Color.blue)
            .cornerRadius(15.0)
    }
}



struct Home : View {
    
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
                    .navigationBarTitle(Text("Search"))
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
            
           /* AnimatedImage(url: URL(string: url)!).resizable()
                .frame(width: 60, height: 60)
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/).shadow(radius: 20)
            */
            
            
            
            
            NavigationLink(destination: MapView(latitude: latitude, longitude: longitude, pais: name, capital: capital)) {
            //NavigationLink(destination: MapView()) {
                //ButtonView()
                
                VStack{
                    
                    Text("GO").font(.custom("Helvetica Neue", size: 25))
                        .foregroundColor(.orange)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        //.frame(alignment: .center)
                        //.padding()
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
          
            
            
            /*
            Button(action: {
                        print(latitude)
                
               
                
                    }) {
                        Text("GO").font(.custom("Helvetica Neue", size: 28))
                            .foregroundColor(.orange)
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        Image(systemName: "location")
                           
                        
                    }
                    .foregroundColor(.orange)
                    .padding(.all)
                    .background(Color.black)
                    .cornerRadius(10)
            .padding()
 */
        
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



struct MapView: UIViewRepresentable {

    
    /*
    var latitude = 0.0
    var longitude = 0.0
  
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }
        
    func updateUIView(_ view: MKMapView, context: Context) {
        let coordinate = CLLocationCoordinate2D(
                latitude: latitude, longitude: longitude)
        let span = MKCoordinateSpan(latitudeDelta: 3, longitudeDelta: 3)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        view.setRegion(region, animated: true)
    }
 */
    
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






//struct MapCountry: View {

/*
    var latitude = 0.0
    var longitude: Double = 0.0
    

    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 4.323232, longitude: 0.0) , span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    
    var body: some View{
        Map(coordinateRegion: $region)
                    .edgesIgnoringSafeArea(.all)
  }
 
 */
    
    
   
    
    
// }


struct Place: Identifiable {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}



struct SearchBar: UIViewRepresentable {

    @Binding var text: String
    var placeholder: String

    class Coordinator: NSObject, UISearchBarDelegate {

        @Binding var text: String

        init(text: Binding<String>) {
            _text = text
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }

    func makeCoordinator() -> SearchBar.Coordinator {
        return Coordinator(text: $text)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.placeholder = placeholder
        searchBar.searchBarStyle = .minimal
        searchBar.autocapitalizationType = .none
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}

