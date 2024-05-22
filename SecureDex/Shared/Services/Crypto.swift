//
//  Crypto.swift
//  SecureDex
//
//  Created by Cristian Contreras Velásquez on 22-05-24.
//

import Foundation
import CryptoKit

/// Enum to define the size of the key to be used in AES encryption.
/// - bits128: 16 bytes long key.
/// - bits192: 24 bytes long key.
/// - bits256: 32 bytes long key.
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
        let keyData: [UInt8] = [0xB2-0x42,0x56+0x0B,0x5B+0x18,0x86-0x13]
        guard let unwrappedKey = String(data: Data(keyData), encoding: .utf8) else {
            print("SSLPinning error: unable to obtain local public key")
            return
        }
        self.key = unwrappedKey
    }
    
    // MARK: Functions
    /// Pads a given key to be used in AES encryption with 32 bytes long by default. It uses the PKCS7 standard padding.
    ///  - Parameters:
    ///  - key: The key to be padded.
    ///  - size: The size of the key to be padded. Default is 32 bytes.
    ///  - Returns: The padded key.
    ///
    private func paddedKey_PKCS7(from key: String, withSize size: AESKeySize = .bits256) -> Data {
        // Get the data from the key in Bytes
        guard let keyData = key.data(using: .utf8) else { return Data() }
        // If the key is already the right size, return it
        if(keyData.count == size.rawValue) {return keyData}
        // If the key is bigger, truncate it and return it
        if(keyData.count > size.rawValue) {return keyData.prefix(size.rawValue)}
        // If the key is smaller, pad it
        let paddingSize = size.rawValue - keyData.count % size.rawValue
        let paddingByte: UInt8 = UInt8(paddingSize)
        let padding = Data(repeating: paddingByte, count: paddingSize)
        return keyData + padding
    }
    //: ## Función de encriptación AES-GCM
    /// Encrypts a given data input using AES algorithm.
    /// Given the symmetric nature of the AES encryption, the key used for encryption has to be used for decryption.
    /// - Parameters:
    ///  - input: The data to be encrypted.
    ///  - key: The key to be used for encryption. If the key is 32 bytes long, it will be used directly. If the key is shorter than 32 bytes, it will be padded with zeros.
    private func encrypt(input: Data, key: String) -> Data {
        do {
            // Get the correct length key
            let keyData = paddedKey_PKCS7(from: key, withSize: .bits128) // 16, 24 OR 32 bytes long
            // Get the symmetric key from the key as a string
            let key = SymmetricKey(data: keyData)
            // Create the box containing the data with the key
            let sealed = try AES.GCM.seal(input, using: key)
            // Return the combination of the nonce, cypher text and tag
            return sealed.combined!
        } catch let er {
            return "Error while encryption".data(using: .utf8)!
        }
    }
    //: ## Función de desencriptación AES-GCM
    /// Decrypts a given data input using AES algorithm.
    /// Given the symmetric nature of the AES encryption, the key used for encryption has to be used for decryption.
    /// - Parameters:
    /// - input: The data to be decrypted.
    /// - key: The key to be used for decryption. If the key is 32 bytes long, it will be used directly. If the key is shorter than 32 bytes, it will be padded.
    private func decrypt(input: Data, key: String) -> Data {
        do {
            // Get the correct length key
            let keyData = paddedKey_PKCS7(from: key, withSize: .bits128)
            // Get the symmetric key from the key as a string
            let key = SymmetricKey(data: keyData)
            // Get box from the input, if the data is not a box then throw an error
            let box = try AES.GCM.SealedBox(combined: input)
            // Get the plaintext. If any error occurs during the opening process then throw exception
            let opened = try AES.GCM.open(box, using: key)
            // Return the cipher text
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
}
