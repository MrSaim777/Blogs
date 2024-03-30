//
//  AuthViewModel.swift
//  Blogs
//
//  Created by Usama Sultan on 30/03/2024.
//

import Foundation
import LocalAuthentication

class AuthViewModel: ObservableObject {
    
    @Published var isAuthenticated = false
    @Published var isInitialized = false
    

    func isBiometricAvailable() -> Bool {
        let context = LAContext()
        var error: NSError?

        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            // Biometric authentication is not available
            return false
        }

        // Biometric authentication is available
        return true
    }

    func authenticateUser(completion: @escaping (Bool, Error?) -> Void) {
        let context = LAContext()
        var error: NSError?

        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            // Biometric authentication is not available
            completion(false, error)
            return
        }

        let reason = "Log in to your app"

        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
            DispatchQueue.main.async {
                if success {
                    // User authenticated successfully
                    completion(true, nil)
                    print("Success")
                } else {
                    // Authentication failed
                    completion(false, authenticationError)
                }
            }
        }
    }
    
    func authenticate() {
        authenticateUser { success, error in
            if success {
                self.isAuthenticated = true
                self.isInitialized = true
                print("Authentication succeeded")
            } else {
                self.isAuthenticated = false
                self.isInitialized = true
                if let error = error {
                    print("Authentication failed with error: \(error.localizedDescription)")
                } else {
                    print("Authentication failed")
                }
            }
        }
    }
}
