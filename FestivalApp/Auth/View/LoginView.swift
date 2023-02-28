//
//  LoginView.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 27/02/2023.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var email : String = ""
    @State private var password : String = ""
    @Binding var currentViewShowing : String
    @AppStorage("userID") var userID : String = ""
    @EnvironmentObject var user : UserSettings
    
    private func isValidPassword(_ password: String) -> Bool {
        //minimum 6 lettres
        //1 majuscule
        //1 caractère spécial
        
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{6,}$")

        return passwordRegex.evaluate(with: password)
    }
    
    var body: some View {
        ZStack{
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack{
                HStack{
                    Text("Content de te revoir !")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                   
                }
                .padding()
                .padding(.top)
                
                Spacer()
                
                HStack{
                    Image(systemName: "mail")
                    TextField("Email", text: $email)
                    Spacer()
                    
                    if (email.count > 0){
                        
                        Image(systemName: email.isValidEmail() ? "checkmark" : "xmark")
                            .fontWeight(.bold)
                            .foregroundColor(email.isValidEmail() ? .green : .red)
                    }
  
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.black)
                )
                .padding()
                
                HStack{
                    Image(systemName: "lock")
                    SecureField("Password", text: $password)
                    Spacer()
                    
                    if (password.count > 0){
                        Image(systemName: isValidPassword(password) ? "checkmark" : "xmark")
                            .fontWeight(.bold)
                            .foregroundColor(isValidPassword(password) ? .green : .red)
                    }
                    
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.black)
                )
                .padding()
                
                Button(action: {
                    withAnimation{
                        self.currentViewShowing = "signup"
                    }
                }){
                    Text("Vous n'avez pas de compte ?")
                        .foregroundColor(.black.opacity(0.7))
                }
                Spacer()
                Spacer()
                
                Button{
                    Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                        
                        if let error = error {
                            //error
                            print(error)
                        }
                        
                        if let authResult = authResult {
                            //connecté
                            user.user = User(email: authResult.user.email!, uid: authResult.user.uid)
                            print(user.user!.email)
                            
                        }
                    }
                    
                } label : {
                    Text("Se connecter")
                        .foregroundColor(.white)
                        .font(.title)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.black)
                        )
                        .padding(.horizontal)
                }
            }
        }
    }
}

