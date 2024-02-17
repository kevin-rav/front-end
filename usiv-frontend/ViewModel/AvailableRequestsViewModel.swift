//
//  AvailableRequestsViewModel.swift
//  usiv-request
//
//  Created by Kevin Ravakhah on 2/12/24.
//

import SwiftUI

class AvailableRequestsViewModel: ObservableObject {
    @Published var username: String
    @Published var password: String
    @Published var requests: [USIVRequest] = []
    
    // initialize variables
    init(username: String, password: String) {
        self.username = username
        self.password = password
        fetchRequests()
    }
    
    // fetches all available requests
    func fetchRequests() {
        guard let url = URL(string: "\(LinkToDatabase.link)/requests/available") else {
            print("Invalid URL")
            return
        }
        
        // handle errors
        URLSession.shared.dataTask(with: url) { data, response, error in
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
    
    // allows user to accept a request
    func acceptRequest(requestID: UUID) {
        guard let url = URL(string: "\(LinkToDatabase.link)/requests/accept/\(requestID.uuidString)") else {
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
               let alertController = UIAlertController(title: "Request Accepted", message: "\(self.username) accepted the request.", preferredStyle: .alert)
               alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                   // Refresh the page after dismissing the popup
                   self.fetchRequests()
               })
               UIApplication.shared.windows.first?.rootViewController?.present(alertController, animated: true, completion: nil)
           }
    }
    
}
