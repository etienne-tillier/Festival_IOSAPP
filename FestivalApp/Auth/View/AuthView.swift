//
//  AuthView.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 27/02/2023.
//

import SwiftUI


struct AuthView: View {
    
    @State private var currentViewShowing : String = "login" // login or signup
    @EnvironmentObject var error : ErrorObject
    
    
    var body: some View {
        if (currentViewShowing == "login"){
            LoginView(currentViewShowing: $currentViewShowing)
                .preferredColorScheme(.light)
        }
        else {
            SignUpView(currentViewShowing: $currentViewShowing)
                .preferredColorScheme(.dark)
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
