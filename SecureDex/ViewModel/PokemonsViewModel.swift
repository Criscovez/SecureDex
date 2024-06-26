//
//  PokemonsViewModel.swift
//  SecureDex
//
//  Created by Cristian Contreras Velásquez on 18-05-24.
//

import Foundation

final class PokemonsViewModel: ObservableObject {
    
    @Published var pokemons: [Pokemon] = []
    
    
    func getPokemons() async {
        
        
        do {

            print(BaseNetwork().getSessionPokemon())
            let (data, response) = try await URLSession.shared.data(for: BaseNetwork().getSessionPokemon())
            
            if let resp = response as? HTTPURLResponse {
                if resp.statusCode == HTTPRresponseCodes.SUCESS {
                    let modelReturn = try JSONDecoder().decode(PokemonList.self, from: data)
                    Task{@MainActor in
                        pokemons = modelReturn.results
                    }
                }
            }
            
        } catch {
            
            print("---> error: \(error)")
            
        }
    }
}
