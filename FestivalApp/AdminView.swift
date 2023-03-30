//
//  AdminView.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 22/03/2023.
//

import SwiftUI

struct AdminView: View {

    @ObservedObject var festivals: FestivalList
    @State var festivalIntent : FestivalListIntent
    @State private var action: Int? = 0
    @State var benevoles = BenevoleList()

    init(festivals: FestivalList) {
        self.festivals = festivals
        self.festivalIntent = FestivalListIntent(festivals: festivals)
        self.action = 0
    }
    
    
    
    
    var body: some View {
        NavigationStack{
            NavigationLink(destination: BenevolePanelView(benevoles: benevoles), tag: 1, selection: $action) {
                EmptyView()
            }
            NavigationLink(destination: FestivalListView(festivals: festivals), tag: 2, selection: $action) {
                EmptyView()
            }
            VStack{
                VStack{
                    Image(systemName: "person.3.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 50)
                    Text("Bénévoles")
                        .font(.system(size: 20))
                }
                .padding(.horizontal, 120)
                .padding(.vertical, 60)
                .border(.black)
                .onTapGesture {
                    self.action = 1
                }
                Spacer().frame(height: 40)
                VStack{
                    Image(systemName: "calendar")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 50)
                    Text("Affectations")
                        .font(.system(size: 20))
                }
                .padding(.horizontal, 120)
                .padding(.vertical, 60)
                .border(.black)
                .onTapGesture {
                    self.action = 2
                }
            }.onAppear{
                Task{
                    self.action = 0
                }
            }
        }

    }
}

