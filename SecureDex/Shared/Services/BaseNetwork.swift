//
//  File.swift
//  SecureDex
//
//  Created by Cristian Contreras Velásquez on 18-05-24.
//

import Foundation

let host = "pokeapi.co"

struct HTTPMethods {
    static let get = "GET"
    static let content = "application/json"
}

enum endpoints: String {
    case pokemons = "/api/v2/pokemon"
}

//Server Response Codes
struct HTTPRresponseCodes {
    static let SUCESS = 200
    static let NOT_AUTHORIZED = 401
    static let ERROR = 502
}


struct BaseNetwork{
    
    var components = URLComponents()
    
    func getSessionPokemon() -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = endpoints.pokemons.rawValue
        
        components.queryItems = [
            URLQueryItem(name: "limit", value: "151")
        ]

        var request = URLRequest(url: URL(string: components.string!)!)
        
        request.httpMethod = HTTPMethods.get

        return request
    }
  
}
