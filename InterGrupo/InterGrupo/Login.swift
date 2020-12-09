//
//  Login.swift
//  InterGrupo
//
//  Created by Jaime Lombana on 9/12/20.
//

import SwiftUI

struct Login: View {
    @State private var isActive: Bool = false
    @State private var showAlert: Bool = false
    @State private var username1 = UserDefaults.standard.string(forKey: "name")
    @State private var password1 = UserDefaults.standard.string(forKey: "password")
     
    @State var username: String = ""
    @State var password: String = ""
    
    @State
        var showsUp = false
   
    init() {
        UserDefaults.standard.set("Jaime", forKey: "name")
        UserDefaults.standard.set("123456", forKey: "password")
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
                
                
                
                VStack{
                    
                    NavigationLink(destination: Home(), isActive: self.$isActive) {
                        
                    }.navigationBarTitle(Text("Login"))
                    
                    Button(action: {
                        validationLogin()

                        }) {
                            LoginButtonContent()
                        }
                    
                    .alert(isPresented: $showAlert) {
                                Alert(
                                    title: Text("InterGrupo"),
                                    message: Text("Usuario no Registrado")
                                )
                            }

                }
                  
            }
            .padding()
        }
        
            
    }
    
    
    func validationLogin(){
    
        if(username == username1 && password == password1){
            print("Usuario Registrado")
            self.isActive = true
            self.showAlert = false
                  
        }else{
            print("Usuario NO Registrado")
            self.isActive = false
            self.showAlert = true
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

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
