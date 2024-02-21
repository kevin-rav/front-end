import SwiftUI
import UserNotifications

@main
struct usiv_frontendApp: App {
    // Initialize your view model here if needed
    @StateObject var viewModel = LoginViewModel()

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            // Pass your view model to the view
            LoginView(viewModel: viewModel)
                .onAppear {
                    registerForPushNotifications()
                }
                .onReceive(viewModel.$isLoggedIn) { isLoggedIn in
                    if isLoggedIn {
                        if let deviceToken = appDelegate.deviceToken {
                            // Pass username and password to the sendDeviceTokenToBackend method
                            appDelegate.sendDeviceTokenToBackend(deviceToken, username: viewModel.username, password: viewModel.password)
                            print((viewModel.username))
                        } else {
                            print("Device token not available")
                        }
                    }
                }

        }
    }

    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Push notification permission granted")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("Push notification permission denied")
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {

    @StateObject var viewModel = LoginViewModel()
    var deviceToken: String?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Your initialization code
        return true
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("Device token received: \(tokenString)")
        self.deviceToken = tokenString
        
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error.localizedDescription)")
    }
    
    // Method to send device token to backend
    public func sendDeviceTokenToBackend(_ token: String, username: String, password: String) {
        guard let url = URL(string: "\(LinkToDatabase.link)/users/registerDeviceToken") else {
            print("Invalid backend URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Basic Authentication
        let loginString = "\(username):\(password)"
        guard let loginData = loginString.data(using: .utf8) else {
            print("Error encoding login credentials")
            return
        }
        let base64LoginString = loginData.base64EncodedString()
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")

        let requestBody: [String: Any] = ["token": token]

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            request.httpBody = jsonData

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error sending device token to backend: \(error.localizedDescription)")
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    print("Invalid response from server")
                    return
                }

                if (200...299).contains(httpResponse.statusCode) {
                    print("Device token sent to backend successfully")
                } else {
                    if let responseData = data,
                       let responseString = String(data: responseData, encoding: .utf8) {
                        print("Failed to send device token to backend: \(responseString)")
                    } else {
                        print("Failed to send device token to backend: Status code \(httpResponse.statusCode)")
                    }
                }
            }

            task.resume()
        } catch {
            print("Error encoding request body: \(error.localizedDescription)")
        }
    }

}
