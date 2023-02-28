//
//  SignUpView.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 27/02/2023.
//

import SwiftUI
import FirebaseAuth

struct SignUpView : View {
    @State private var email : String = ""
    @State private var password : String = ""
    @Binding var currentViewShowing : String
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
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack{
                HStack{
                    Text("Créer ton compte !")
                        .foregroundColor(.white)
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
                .foregroundColor(.white)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.white)
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
                .foregroundColor(.white)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .foregroundColor(.white)
                )
                .padding()
                
                Button(action: {
                    withAnimation{
                        self.currentViewShowing = "login"
                    }
                }){
                    Text("Vous avez déjà un compte ?")
                        .foregroundColor(.gray)
                }
                Spacer()
                Spacer()
                
                Button{
                    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                        if let error = error {
                            //error
                            print(error)
                            return
                        }
                        
                        if let authResult = authResult {
                            //print(authResult.user.uid)
                            //inscrit et connecté
                            withAnimation{
                                authResult.user.getIDTokenResult(completion: { (result, error) in
                                                guard error == nil else {
                                                    print(error!.localizedDescription)
                                                    return
                                                }

                                                if let token = result?.token {
                                                    TokenManager.shared.setToken(token: token)
                                                    user.user = User(email: authResult.user.email!, uid: authResult.user.uid)
                                                }
                                            })
                            }
                            
                        }
                    }
                } label : {
                    Text("S'inscrire")
                        .foregroundColor(.black)
                        .font(.title)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.white)
                        )
                        .padding(.horizontal)
                }
            }
        }
    }
}

