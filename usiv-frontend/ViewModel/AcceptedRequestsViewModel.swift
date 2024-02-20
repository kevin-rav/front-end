//
//  AvailableRequestsViewModel.swift
//  usiv-request
//
//  Created by Kevin Ravakhah on 2/15/24.
//

import SwiftUI

class AcceptedRequestsViewModel: ObservableObject {
    @Published var username: String
    @Published var password: String
    @Published var requests: [USIVRequest] = []
    
    private var timer: Timer?
       // initialize variables
       init(username: String, password: String) {
           self.username = username
           self.password = password
           startAutomaticRefresh()
       }
       
       deinit {
           stopAutomaticRefresh()
       }
       
       // Start automatic refresh
       private func startAutomaticRefresh() {
           // Invalidate existing timer if any
           timer?.invalidate()
           
           // Create a new timer that fires every second
           timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
               self?.fetchUserAcceptedRequests()
           }
       }
       
       // Stop automatic refresh
       private func stopAutomaticRefresh() {
           timer?.invalidate()
           timer = nil
       }
    
    // fetches all requests posted by user
    func fetchUserAcceptedRequests() {
        guard let url = URL(string: "\(LinkToDatabase.link)/requests/userAccepted") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        // Basic Authentication
        let loginString = "\(username):\(password)"
        guard let loginData = loginString.data(using: .utf8) else {
            print("Error encoding login credentials")
            return
        }
        let base64LoginString = loginData.base64EncodedString()
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        // handle errors
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode([USIVRequest].self, from: data)
                
                DispatchQueue.main.async {
                    self.requests = decodedData
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
    
    // allows user to unaccept a request
    func unacceptRequest(requestID: UUID) {
        guard let url = URL(string: "\(LinkToDatabase.link)/requests/unaccept/\(requestID.uuidString)") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        // Basic Authentication
        let loginString = "\(username):\(password)"
        guard let loginData = loginString.data(using: .utf8) else {
            print("Error encoding login credentials")
            return
        }
        let base64LoginString = loginData.base64EncodedString()
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        // Handle Errors
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            print("Response status code: \(httpResponse.statusCode)")
        }.resume()
        
        // Display pop up when button is pressed and display updated requests
        DispatchQueue.main.async {
               let alertController = UIAlertController(title: "Request Unaccepted", message: "\(self.username) unaccepted the request.", preferredStyle: .alert)
               alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                   // Refresh the page after dismissing the popup
                   self.fetchUserAcceptedRequests()
               })
               UIApplication.shared.windows.first?.rootViewController?.present(alertController, animated: true, completion: nil)
           }
    }
    
    // allows user to mark a request completed
    func markCompletedRequest(requestID: UUID) {
        guard let url = URL(string: "\(LinkToDatabase.link)/requests/markCompleted/\(requestID.uuidString)") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        // Basic Authentication
        let loginString = "\(username):\(password)"
        guard let loginData = loginString.data(using: .utf8) else {
            print("Error encoding login credentials")
            return
        }
        let base64LoginString = loginData.base64EncodedString()
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        // Handle Errors
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                return
            }
            
            print("Response status code: \(httpResponse.statusCode)")
        }.resume()
        
        // Display pop up when button is pressed and display updated requests
        DispatchQueue.main.async {
               let alertController = UIAlertController(title: "Request Marked as Completed", message: "\(self.username) completed the request.", preferredStyle: .alert)
               alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                   // Refresh the page after dismissing the popup
                   self.fetchUserAcceptedRequests()
               })
               UIApplication.shared.windows.first?.rootViewController?.present(alertController, animated: true, completion: nil)
           }
    }

}
