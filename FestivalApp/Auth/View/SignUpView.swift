//
//  SignUpView.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 27/02/2023.
//

import SwiftUI
import FirebaseAuth

struct SignUpView : View {
    
    @EnvironmentObject var error : ErrorObject
    @State private var nom : String = ""
    @State private var prenom : String = ""
    @State private var email : String = ""
    @State private var password : String = ""
    @State private var benevoleDAO : BenevoleDAO = BenevoleDAO()
    @Binding var currentViewShowing : String
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
                    TextField("Nom", text: $nom)
                    Spacer()
                    
                    if (nom.count > 0){
                        
                        Image(systemName: nom.count > 0 ? "checkmark" : "xmark")
                            .fontWeight(.bold)
                            .foregroundColor(nom.count > 0 ? .green : .red)
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
                    TextField("Prénom", text: $prenom)
                    Spacer()
                    
                    if (prenom.count > 0){
                        
                        Image(systemName: prenom.count > 0 ? "checkmark" : "xmark")
                            .fontWeight(.bold)
                            .foregroundColor(prenom.count > 0 ? .green : .red)
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
                            self.error.message = error.localizedDescription
                            self.error.isPresented = true
                            return
                        }
                        
                        if let authResult = authResult {
                            //print(authResult.user.uid)
                            //inscrit et connecté
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
                                            DispatchQueue.main.async {
                                                user.state = .isLoading
                                            }
                                            await benevoleDAO.createBenevole(nom: nom, prenom: prenom, email: email) { result in
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

