//
//  BenevoleListIntent.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 23/02/2023.
//

import Foundation
import SwiftUI


struct FestivalListIntent {
    
    private var festivals : FestivalList
    private var dao : FestivalDAO = FestivalDAO()
    
    init(festivals: FestivalList) {
        self.festivals = festivals
    }
    
    func loadFestivals() async {
        do {
            DispatchQueue.main.async {
                self.festivals.state = .isLoading
            }
            let newFestivals : [Festival] = try await dao.getAllFestivals()!
            print("j'ai fetcthc les festivals")
            print(newFestivals)
            DispatchQueue.main.async {
                self.festivals.state = .load(newFestivals)
                self.festivals.state = .ready
            }
        }
        catch {
            print(error)
            DispatchQueue.main.async {
                self.festivals.state = .error
            }
        }
    }
    
    func remove(index : IndexSet) async {
        do {
            DispatchQueue.main.async {
                self.festivals.state = .removing
            }
            await dao.removeFestivalById(id: self.festivals.festivals[index.first!].id) { result in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self.festivals.state = .error
                }
            case .success():
                DispatchQueue.main.async {
                    self.festivals.state = .remove(index)
                    self.festivals.state = .ready
                    print("Le festival a été supprimé avec succès !")
                }
            }
        }
        }
    }
    
    func add(nom : String, dateDebut : Date, nbJours : Int) async {
        do {
            let creneau : (Date, Date) = Tools.getStartAndEndDates(forDay: dateDebut, startHour: 0, endHour: 23)!
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let startDateString = dateFormatter.string(from: creneau.0)
            await dao.createFestival(nom: nom, dateDebut: startDateString, nbJours: nbJours) { result in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        self.festivals.state = .error
                    }
                case .success(let festival):
                    DispatchQueue.main.async {
                        self.festivals.state = .add(festival)
                        self.festivals.state = .ready
                    }
                }
                
            }
        }
    }
    
}
