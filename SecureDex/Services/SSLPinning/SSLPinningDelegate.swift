//
//  SSLPinningDelegate.swift
//  SecureDex
//
//  Created by Cristian Contreras Velásquez on 20-05-24.
//

import Foundation
import CommonCrypto
import CryptoKit

class SSLPinningDelegate: NSObject  {
 
}

//MARK: - URLPinningDelegate: functions

extension SSLPinningDelegate: URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
    // validación del servidor
        
    // Obtención del server trust
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            print("SSLPinning error: server didn't present trust")
            return
        }
        
        // Obtener el certificado
        let serverCertificates: [SecCertificate]?
        serverCertificates = SecTrustCopyCertificateChain(serverTrust) as? [SecCertificate]
        guard let serverCertificate = serverCertificates?.first else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            print("SSLPinning error: server certificate is nil")
            return
        }
        
    // Obtener la public key
        guard let serverPublicKey = SecCertificateCopyKey(serverCertificate) else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            print("SSLPinning error: server publik key is nil ")
            return
        }
        
    // Transformar la public key del servidor a data
        guard let serverPublicKeyRep = SecKeyCopyExternalRepresentation(serverPublicKey, nil) else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            print("SSLPinning error: unable to convert server public key to data")
            return
        }
        
        let serverPublicKeyData = serverPublicKeyRep as Data
        
    // Convertir la public key data a sha256 base64
        let serverHashbase64 = sha256CryptoKit(data: serverPublicKeyData)
        
    //Imprimir las claves
        print()
        print()
        print("Local crypto key is \(String(describing: Crypto().getDecryptedPublicKey()))")
        print("Server key is \(serverHashbase64)")
        
    // let crypto = Crypto()
        
    // Comprobar que la clave pública local es igual que la del servidor
        if serverHashbase64 == Crypto().getDecryptedPublicKey() {
    //if serverHashbase64 == serverHashbase64 {
            completionHandler(.useCredential, URLCredential(trust: serverTrust))
            print("SSLPining filter passed")
        } else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            print("SSLPinning error: server public key don't mach")
        }
        
        
        
    }
    
}

extension SSLPinningDelegate {
    
    func sha256(data : Data) -> String{
        
        //Copiar el parámetro a una variable dentro de la función
        let dataToHash = Data(data)
        
        //Creamos un array de bytes donde vamos a almacenar el hash
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        
        //Copiar los datos del parámetro en el array de bytes de hash convirtiéndolos a un sha256
        dataToHash.withUnsafeBytes { bufferPointer in
            _ = CC_SHA256(bufferPointer.baseAddress, CC_LONG(bufferPointer.count), &hash)
        }
        
    //Convertir el hash a un string de base 64
        let hashBase64 = Data(hash).base64EncodedString()
        
        return hashBase64
    }


    func sha256CryptoKit(data: Data) -> String {
        let hash = SHA256.hash(data: data)
        return Data(hash).base64EncodedString()
    }

}

