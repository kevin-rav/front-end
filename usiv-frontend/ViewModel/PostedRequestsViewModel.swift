//
//  AvailableRequestsViewModel.swift
//  usiv-request
//
//  Created by Kevin Ravakhah on 2/15/24.
//

import SwiftUI

class PostedRequestsViewModel: ObservableObject {
    @Published var username: String
    @Published var password: String
    @Published var requests: [USIVRequest] = []
    
    // initialize variables
    init(username: String, password: String) {
        self.username = username
        self.password = password
        fetchUserPostedRequests()
    }
    
    // fetches all requests posted by user
    func fetchUserPostedRequests() {
        guard let url = URL(string: "\(LinkToDatabase.link)/requests/userPosted") else {
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
    
    // allows user to mark a request completed
    func cancelRequest(requestID: UUID) {
        guard let url = URL(string: "\(LinkToDatabase.link)/requests/cancel/\(requestID.uuidString)") else {
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
            let alertController = UIAlertController(title: "Request Cancelled", message: "\(self.username) cancelled the request.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                // Refresh the page after dismissing the popup
                self.fetchUserPostedRequests()
            })
            UIApplication.shared.windows.first?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    // allows user to mark a request completed
    func deleteRequest(requestID: UUID) {
        guard let url = URL(string: "\(LinkToDatabase.link)/requests/\(requestID.uuidString)") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
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
            let alertController = UIAlertController(title: "Request Deleted", message: "\(self.username) deleted the request.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                // Refresh the page after dismissing the popup
                self.fetchUserPostedRequests()
            })
            UIApplication.shared.windows.first?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    func createRequest(hospital: String, roomNumber: Int, callbackNumber: String, notes: String) {
        // Construct JSON payload
        let json: [String: Any] = [
            "hospital": hospital,
            "roomNumber": roomNumber,
            "callBackNumber": callbackNumber,
            "notes": notes
        ]
        
        // Convert JSON to Data
        guard let jsonData = try? JSONSerialization.data(withJSONObject: json) else {
            print("Error encoding JSON")
            return
        }
        
        // Create URL and URLRequest
        guard let url = URL(string: "\(LinkToDatabase.link)/requests") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        // Add Basic Authentication
        let loginString = "\(username):\(password)"
        guard let loginData = loginString.data(using: .utf8) else {
            print("Error encoding login credentials")
            return
        }
        let base64LoginString = loginData.base64EncodedString()
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        // Send POST request with basic authentication
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            // Handle response
            // This closure is executed when the request completes
            self.fetchUserPostedRequests()
        }.resume()
    }
}
