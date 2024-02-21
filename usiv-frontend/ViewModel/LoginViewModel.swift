import SwiftUI
import Combine

class LoginViewModel: ObservableObject {
    // Login properties
    @Published var username = ""
    @Published var password = ""
    @Published var userID: UUID?
    @Published var isLoggedIn = false
    
    // Registration properties
    @Published var registerUsername = ""
    @Published var registerPassword = ""
    @Published var confirmPassword = ""
    @Published var role = 0

    // Errors
    @Published var loginError = false
    @Published var registerError = false

    
    // allow users to login
    func authenticateUser(completion: @escaping (Bool) -> Void) {
        
        if isLoggedIn {
            completion(true) // Return true immediately if already logged in
            return
        }
        
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
                            self.role = user.role
                            print("User ID: \(user.id)")
                        } catch {
                            print("Error decoding user object: \(error)")
                            completion(false)
                            return
                        }
                    }
                    
                    DispatchQueue.main.async {
                        self.isLoggedIn = true
                        completion(true) // Call completion handler after setting isLoggedIn to true
                    }
                } else if httpResponse.statusCode == 401 {
                        print("Wrong credentials")
                        DispatchQueue.main.async {
                            self.loginError = true
                            self.username = ""
                            self.password = ""
                            completion(false)
                        }
                } else {
                    print("Login failed with status code \(httpResponse.statusCode)")
                    DispatchQueue.main.async {
                        completion(false) // Call completion handler on failed login
                    }
                }
            }
        }.resume()
    }
    
    
    
    // User registration
    func registerUser(completion: @escaping (Bool) -> Void) {
        
        if isLoggedIn {
            completion(true) // Return true immediately if already logged in
            return
        }
        
        guard let url = URL(string: "\(LinkToDatabase.link)/users") else {
            print("Invalid URL")
            completion(false)
            return
        }
        
        // Create registration request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create registration data
        let registrationData: [String: Any] = [
            "userName": registerUsername,
            "password": registerPassword,
            "confirmPassword": confirmPassword,
            "role": role
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: registrationData, options: [])
        } catch {
            print("Error encoding registration data: \(error)")
            completion(false)
            return
        }
        
        // Send registration request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    print("Registration successful!")
                    
                    DispatchQueue.main.async {
                        let alertController = UIAlertController(title: "Registration Successful", message: "Please log in.", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                        })
                        UIApplication.shared.windows.first?.rootViewController?.present(alertController, animated: true, completion: nil)
                        self.registerPassword = ""
                        self.confirmPassword = ""
                        self.registerUsername = ""
                        completion(true)
                    }
                } else if httpResponse.statusCode == 400 {
                    // Username already taken
                    self.registerError = true
                    self.registerPassword = ""
                    self.confirmPassword = ""
                    self.registerUsername = ""
                    completion(false)
                } else {
                    print("Registration failed with status code \(httpResponse.statusCode)")
                    completion(false)
                }
            }
        }.resume()
    }
    
    func logout() {
        self.isLoggedIn = false
        self.username = ""
        self.password = ""
    }
    
    func errorMessage() -> String {
        if loginError {
                return "Make sure the username and password match."
        } else if registerError {
                return "Make sure username isn't taken and the password is atleast 8 characters."
        } else {
                return "An unknown error occured"
        }
    }

    func resetErrors() {
        loginError = false
        registerError = false
    }

}
 
