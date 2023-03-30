//
//  LoginView.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 27/02/2023.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    
    @EnvironmentObject var error : ErrorObject
    @State private var email : String = ""
    @State private var password : String = ""
    @Binding var currentViewShowing : String
    @AppStorage("userID") var userID : String = ""
    @EnvironmentObject var user : Benevole
    @State var dao : UserDAO = UserDAO()
    
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
                            self.error.message = error.localizedDescription
                            self.error.isPresented = true
                        }
                        
                        if let authResult = authResult {
                            //connecté
                            withAnimation{
                                authResult.user.getIDTokenResult(completion: { (result, error) in
                                                guard error == nil else {
                                                    self.error.message = error!.localizedDescription
                                                    self.error.isPresented = true
                                                    return
                                                }

                                                if let token = result?.token {
                                                    TokenManager.shared.setToken(token: token)
                                                    Task {
                                                        print(authResult.user.uid)
                                                        DispatchQueue.main.async {
                                                            user.state = .isLoading
                                                        }
                                                        await dao.getLoggedBenevole(uid: authResult.user.uid) { result in
                                                            switch result {
                                                            case .failure(let error):
                                                                DispatchQueue.main.async {
                                                                    self.error.message = error.localizedDescription
                                                                    self.error.isPresented = true
                                                                    user.state = .error
                                                                }
                                                            case .success(let benevole):
                                                                DispatchQueue.main.async {
                                                                    user.state = .load(benevole)
                                                                    user.state = .ready
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                                //error
                                            })
                                
                                

                            }
                            
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

