//
//  PokemonDelatilView.swift
//  SecureDex
//
//  Created by Cristian Contreras Velásquez on 25-05-24.
//

import Foundation

final class PokemonDelatilViewModel: ObservableObject {
    
    @Published var abilities: [Ability] = []
    
    
    func getAbilities(IDPokemon: String) async {
        
        
        do {

            print(BaseNetwork().getSessionAbilities(id: IDPokemon))
            let (data, response) = try await URLSession.shared.data(for: BaseNetwork().getSessionAbilities(id: IDPokemon))
            
            if let resp = response as? HTTPURLResponse {
                if resp.statusCode == HTTPRresponseCodes.SUCESS {
                    let modelReturn = try JSONDecoder().decode(PokemonDetail.self, from: data)
                    Task{@MainActor in
                        abilities = modelReturn.abilities
                        //print(abilities)
                    }
                }
            }
            
        } catch {
            
            print("---> error: \(error)")
            
        }
    }
}
