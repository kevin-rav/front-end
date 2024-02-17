import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var username = ""
    @Published var password = ""
    @Published var userID: UUID?
    @Published var isLoggedIn = false
    @Published var wrongUsername: Float = 0
    @Published var wrongPassword: Float = 0
    
    // allow users to login
    func authenticateUser(completion: @escaping (Bool) -> Void) {
        
        guard let url = URL(string: "\(LinkToDatabase.link)/users/login") else {
            print("Invalid URL")
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Basic Authentication
        let loginString = "\(username):\(password)"
        guard let loginData = loginString.data(using: .utf8) else {
            print("Error encoding login credentials")
            completion(false)
            return
        }
        let base64LoginString = loginData.base64EncodedString()
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        // handle errors
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    print("Login successful!")
                    
                    // Parse user object from response data
                    if let data = data {
                        do {
                            let decoder = JSONDecoder()
                            let user = try decoder.decode(User.self, from: data) // Assuming User is your user models
                            self.userID = user.id // Assuming `id` is the property that stores the user's ID
                            print("User ID: \(user.id)")
                        } catch {
                            print("Error decoding user object: \(error)")
                            completion(false)
                            return
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.isLoggedIn = true
                        self.wrongPassword = 0
                        self.wrongUsername = 0
                        completion(true) // Call completion handler after setting isLoggedIn to true
                    }
                } else if httpResponse.statusCode == 401 {
                    print("Wrong password")
                    DispatchQueue.main.async {
                        self.wrongPassword = 2
                        self.wrongUsername = 2
                    }
                    completion(false)
                } else {
                    print("Login failed with status code \(httpResponse.statusCode)")
                    DispatchQueue.main.async {
                        self.isLoggedIn = false
                        completion(false) // Call completion handler on failed login
                    }
                }
            }
        }.resume()
    }
    
    func logout() {
        self.isLoggedIn = false
        self.username = ""
        self.password = ""
    }

}
