//
//  File.swift
//  SecureDex
//
//  Created by Cristian Contreras Velásquez on 18-05-24.
//

import Foundation

let host = "fwG6cq2JANAR6IgG95pgpNWPEcFfaddyufIJ6FR9CP9Yzgxebao="

struct HTTPMethods {
    static let get = "GET"
    static let content = "application/json"
}

enum endpoints: String {
    case pokemons = "Sw+ubCULe5r7OC5dB0NzP4Rvy0Q8Qj8bzhE0V3MpVdAH/LYYWdpvvmyMOw=="
    case pokeImage = "kAqCbffySlx1Ogjocx40SMnncR6xuqsQRYA/pPCa5PbdA/8UwHq8SIcaFNjvlH9xYULQMKtkkVhflXqnqFjaIYCbGN8RvDjEP5rzE8/uJc3En/aYqulHZ+W+HXCMaIZHEWwBkQk="
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
        let decryptedHost = Crypto().getDecryptedURL(URLString: host)
        components.host = decryptedHost
        components.path = Crypto().getDecryptedURL(URLString: endpoints.pokemons.rawValue) ?? ""
        
        components.queryItems = [
            URLQueryItem(name: "limit", value: "151")
        ]

        var request = URLRequest(url: URL(string: components.string!)!)
        
        request.httpMethod = HTTPMethods.get

        return request
    }
  
}
