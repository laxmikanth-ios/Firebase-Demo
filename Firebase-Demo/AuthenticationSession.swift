//
//  AuthenticationSession.swift
//  Firebase-Demo
//
//  Created by Laxmikanth Reddy on 07/12/22.
//

import Foundation
import FirebaseAuth


class AuthenticationSession {
    
    public func createNewUser(email: String, password: String, completion: @escaping(Result<AuthDataResult, Error>) -> ()) {
        Auth.auth().createUser(withEmail: email, password: password) { authDataResult, error in
            if let error = error {
                completion(.failure(error))
            }else if let authDataResult = authDataResult{
                completion(.success(authDataResult))
            }
        }
    }
    
    public func createExistingUser(email: String, password: String, completion: @escaping(Result<AuthDataResult,Error>) -> ()) {
        Auth.auth().signIn(withEmail: email, password: password){ authDataResult, error in
            
            if let error = error {
                completion(.failure(error))
            }else if let authDataResult = authDataResult{
                completion(.success(authDataResult))
            }
        }
    }
    
}
