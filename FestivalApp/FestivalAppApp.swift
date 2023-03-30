//
//  FestivalAppApp.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 21/02/2023.
//

import SwiftUI
import FirebaseCore

@main
struct FestivalAppApp: App {
    // Faire une gestion d'erreur avec une variable globale et un component erreur qui s'affiche sur la racine
    // Faire une structure de données en mode : String : definition de l'erreur et Bool : erreur ou pas ? (ternaire dessus)
    @StateObject var user : Benevole = Benevole()
    @StateObject var festivals : FestivalList = FestivalList()
    @StateObject var error : ErrorObject = ErrorObject()
    @State var userIntent : BenevoleIntent? = nil
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(festivals: festivals)
                .environmentObject(user)
                .environmentObject(festivals)
                .environmentObject(error)
                .onAppear{
                    self.userIntent = BenevoleIntent(benevole : user)
                    self.userIntent!.disconnectUser()
                }
        }
    }
}
