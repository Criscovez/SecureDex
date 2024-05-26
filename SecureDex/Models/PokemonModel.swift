//
//  PokemonModel.swift
//  SecureDex
//
//  Created by Cristian Contreras Velásquez on 18-05-24.
//

import Foundation

struct PokemonList: Decodable {
    let results: [Pokemon]
}

struct Pokemon: Identifiable, Decodable {
    let name: String
    let url: String
    
    var id: Int? {
        return Int(url.split(separator: "/").last?.description ?? "0")
    }
    
    var imageUrl: URL? {
        return URL(string: (Crypto().getDecryptedURL(URLString: endpoints.pokeImage.rawValue) ?? "") + "\(id ?? 0).png")
    }
}

struct PokemonDetail: Identifiable, Decodable {
    let abilities: [Ability]
    let id: Int

}

struct Ability: Codable {
    let ability: Species

}

struct Species: Codable, Hashable {
    let name: String
    let url: String
}
