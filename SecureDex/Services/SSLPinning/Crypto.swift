//
//  Crypto.swift
//  SecureDex
//
//  Created by Cristian Contreras Velásquez on 22-05-24.
//

import Foundation
import CryptoKit


enum AESKeySize: Int {
    case bits128 = 16
    case bits192 = 24
    case bits256 = 32
}

class Crypto {
    // MARK: Properties
    private let sealedDataBox = "IuD2lynIbW98xnjHV9WzK+WPGHRshx/06/dH3897CiXP9pw3nbcjxZ7Jx0QvIA7jqzesoQcGmM4RrG5Mb1cJaam0qrD/ZfbZ"
    var key: String = ""
    
    // MARK: Init
    init() {

            guard let unwrappedKey = key("2*∑∑") else {
            print("SSLPinning error: unable to obtain local public key")
            return
        }
        self.key = unwrappedKey
    }

    private func paddedKey_PKCS7(from key: String, withSize size: AESKeySize = .bits256) -> Data {
        
        guard let keyData = key.data(using: .utf8) else { return Data() }
        
        if(keyData.count == size.rawValue) {return keyData}
        
        if(keyData.count > size.rawValue) {return keyData.prefix(size.rawValue)}
        
        let paddingSize = size.rawValue - keyData.count % size.rawValue
        let paddingByte: UInt8 = UInt8(paddingSize)
        let padding = Data(repeating: paddingByte, count: paddingSize)
        return keyData + padding
    }

    private func encrypt(input: Data, key: String) -> Data {
        do {
            
            let keyData = paddedKey_PKCS7(from: key, withSize: .bits128)
            
            let key = SymmetricKey(data: keyData)
            
            let sealed = try AES.GCM.seal(input, using: key)
            
            return sealed.combined!
        } catch let er {
            return "Error while encryption \(er)".data(using: .utf8)!
        }
    }

    private func decrypt(input: Data, key: String) -> Data {
        do {
            
            let keyData = paddedKey_PKCS7(from: key, withSize: .bits128)
            
            let key = SymmetricKey(data: keyData)
            
            let box = try AES.GCM.SealedBox(combined: input)
            
            let opened = try AES.GCM.open(box, using: key)
            
            return opened
        } catch {
            return "Error while decryption".data(using: .utf8)!
        }
    }
    
    public func getDecryptedPublicKey() -> String? {
        
        guard let sealedDataBoxData = Data(base64Encoded: self.sealedDataBox) else {
            print("Error while decrypting public key: sealed data box is not valid")
            return nil
        }
        let data = decrypt(input: sealedDataBoxData, key: self.key)
        return String(data: data, encoding: .utf8)
    }
    
    public func getDecryptedURL(URLString: String) -> String? {
        
        guard let sealedDataBoxData = Data(base64Encoded: URLString) else {
            print("Error while decrypting public key: sealed data box is not valid")
            return nil
        }
        let data = decrypt(input: sealedDataBoxData, key: self.key)
        return String(data: data, encoding: .utf8)
    }
    
    func key(_ texto: String) -> String? {
        let letras = Array("abcdefghijklmnopqrstuvwxyz")
        let numeros = Array("*?#!$_-+¨{}[];123@∑€®†¥¨ø")
        
        var mapaLetrasANumeros = [Character: Character]()
        
        for (numero, letra) in zip(numeros, letras) {
            mapaLetrasANumeros[numero] = letra
        }
        
        var textoNumeros = ""
        
        for caracter in texto.lowercased() {
            if let letra = mapaLetrasANumeros[caracter] {
                textoNumeros.append(String(letra))
            } else {
                textoNumeros.append(String(caracter))
            }
        }
        
        return textoNumeros
    }
}
