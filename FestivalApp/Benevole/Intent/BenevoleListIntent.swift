//
//  BenevoleListIntent.swift
//  FestivalApp
//
//  Created by Etienne Tillier on 23/02/2023.
//

import Foundation
import SwiftUI


struct BenevoleListIntent {
    
    private var benevoles : BenevoleList
    private var dao : BenevoleDAO = BenevoleDAO()
    
    init(benevoles: BenevoleList) {
        self.benevoles = benevoles
    }
    
    func loadBenevoles() async {
        do {
            DispatchQueue.main.async {
                self.benevoles.state = .isLoading
            }
            let newBenevoles : [Benevole] = try await dao.getAllBenevole()!
            DispatchQueue.main.async {
                self.benevoles.state = .load(newBenevoles)
                self.benevoles.state = .ready
            }
        }
        catch {
            DispatchQueue.main.async {
                self.benevoles.state = .error
            }
        }
    }
    
    func remove(index : IndexSet) async {
        do {
            DispatchQueue.main.async {
                self.benevoles.state = .removing
            }
            await dao.removeBenevoleById(id: self.benevoles.benevoles[index.first!].id) { result in
            switch result {
            case .failure(_):
                DispatchQueue.main.async {
                    self.benevoles.state = .error
                }
            case .success():
                DispatchQueue.main.async {
                    self.benevoles.state = .remove(index)
                    self.benevoles.state = .ready
                }
            }
        }
        }
    }
    
    func add(nom : String, prenom : String, email : String) async {
        do {
            await dao.createBenevole(nom: nom, prenom: prenom, email: email) { result in
                switch result {
                case .failure(_):
                    DispatchQueue.main.async {
                        self.benevoles.state = .error
                    }
                case .success(let benevole):
                    DispatchQueue.main.async {
                        self.benevoles.state = .add(benevole)
                        self.benevoles.state = .ready
                    }
                }
                
            }
        }
    }
    
    func getBenevolesAvailableForCreneau(date : Date, startHour : Int, endHour : Int) async {
        DispatchQueue.main.async {
            self.benevoles.state = .isLoading
        }
        let creneau : (Date, Date) = Tools.getStartAndEndDates(forDay: date, startHour: startHour, endHour: endHour)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let startDateString = dateFormatter.string(from: creneau.0)
        let endDateString = dateFormatter.string(from: creneau.1)
        await self.dao.getBenevoleAvailableForCreneau(startDate: startDateString, endDate: endDateString) { result in
            switch result {
            case .failure(_):
                DispatchQueue.main.async {
                    self.benevoles.state = .error
                }
            case .success(let benevoles):
                DispatchQueue.main.async {
                    self.benevoles.state = .load(benevoles)
                    self.benevoles.state = .ready
                }
            }
        }
    }
    
}
