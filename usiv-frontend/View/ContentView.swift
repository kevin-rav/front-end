import SwiftUI
import PopupView

struct ContentView: View {
    @StateObject var viewModel: LoginViewModel
    @State private var showingHelpPopup = false

    init(viewModel: LoginViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            TabView {
                // Show PostedRequestsView if the user is a Requester (role == 0)
                if viewModel.role == 0 {
                    PostedRequestsView(viewModel: PostedRequestsViewModel(username: viewModel.username, password: viewModel.password))
                }

                // Show AvailableRequestsView and AcceptedRequestsView if the user is a Responder (role == 1)
                if viewModel.role == 1 {
                    AvailableRequestsView(viewModel: AvailableRequestsViewModel(username: viewModel.username, password: viewModel.password))
                        .tabItem {
                            Image(systemName: "list.dash")
                            Text("Available")
                        }
                        .tag(2)

                    AcceptedRequestsView(viewModel: AcceptedRequestsViewModel(username: viewModel.username, password: viewModel.password))
                        .tabItem {
                            Image(systemName: "checkmark")
                            Text("Accepted")
                        }
                        .tag(3)
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showingHelpPopup.toggle()
                    }) {
                        Image(systemName: "questionmark.circle")
                            .foregroundColor(Color(red: 186/255, green: 12/255, blue: 47/255))
                    }
                    .padding(.horizontal) // Add some padding to the button
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.logout()
                    }) {
                        Text("Logout")
                        .foregroundColor(Color(red: 186/255, green: 12/255, blue: 47/255))
                    }
                }
            }
        }.blur(radius: showingHelpPopup ? 10 : 0)
        .onReceive(viewModel.$isLoggedIn) { isLoggedIn in
            if !isLoggedIn {
                navigateToLoginView()
            }
        }
        .popup(isPresented: $showingHelpPopup) {
            VStack {
                Text("INSTRUCTIONS")
                    .font(Font.custom("BuckeyeSerif2-SemiBold", size: 20))
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                
                Text("Hello \(viewModel.username)!")
                    .font(Font.custom("BuckeyeSerif2-SemiBold", size: 16))
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                
                if (viewModel.role == 0) {
                    Text("You have identified yourself as a REQUESTOR")
                        .font(Font.custom("BuckeyeSerif2-SemiBold", size: 16))
                        .foregroundColor(.white)
                        .padding(.bottom, 6)
                    Text("Press CREATE to request an Ultrasound Guided IV Placement")
                        .font(Font.custom("BuckeyeSerif2-SemiBold", size: 16))
                        .foregroundColor(.white)
                        .padding(.bottom, 6)
                    Text("Input the patient's hospital, room number, callback number and any notes about the patient")
                        .font(Font.custom("BuckeyeSerif2-SemiBold", size: 16))
                        .foregroundColor(.white)
                        .padding(.bottom, 6)
                    Text("After you submit the request, it will be available for all RESPONDERS to pick up")
                        .font(Font.custom("BuckeyeSerif2-SemiBold", size: 16))
                        .foregroundColor(.white)
                        .padding(.bottom, 6)
                    Text("The request will also be displayed on the screen along with its status")
                        .font(Font.custom("BuckeyeSerif2-SemiBold", size: 16))
                        .foregroundColor(.white)
                        .padding(.bottom, 6)
                    Text("Press the CANCEL button to cancel an available or accepted request")
                        .font(Font.custom("BuckeyeSerif2-SemiBold", size: 16))
                        .foregroundColor(.white)
                        .padding(.bottom, 6)
                    Text("After a request is cancelled or completed, you will be given the option to DELETE the request from your list of posted requests")
                        .font(Font.custom("BuckeyeSerif2-SemiBold", size: 16))
                        .foregroundColor(.white)
                        .padding(.bottom, 6)
                } else {
                    Text("You have identified yourself as a RESPONDER")
                        .font(Font.custom("BuckeyeSerif2-SemiBold", size: 16))
                        .foregroundColor(.white)
                        .padding(.bottom, 10)
                    Text("The available tab shows you all requests for Ultrasound Guided IV Placement that are currently available ")
                        .font(Font.custom("BuckeyeSerif2-SemiBold", size: 16))
                        .foregroundColor(.white)
                        .padding(.bottom, 6)
                    Text("You can press the ACCEPT button on the request and it will move to your accepted requests tab")
                        .font(Font.custom("BuckeyeSerif2-SemiBold", size: 16))
                        .foregroundColor(.white)
                        .padding(.bottom, 6)
                    Text("In the accepted requests tab, you can press the UNACCEPT button to unaccept the request or press the COMPLETED button to mark the request as completed")
                        .font(Font.custom("BuckeyeSerif2-SemiBold", size: 16))
                        .foregroundColor(.white)
                        .padding(.bottom, 6)
                }

                Button(action: {
                    showingHelpPopup = false
                }) {
                    Text("Close")
                        .font(Font.custom("BuckeyeSerif2-SemiBold", size: 16))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color(red: 186/255, green: 12/255, blue: 47/255))
                        .cornerRadius(15.0)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding()
            .frame(maxWidth: 300)
            .background(Color(red: 77/255, green: 77/255, blue: 77/255))
            .cornerRadius(20)
        } customize: {
            $0.useKeyboardSafeArea(true)
                .closeOnTapOutside(false)
                .dragToDismiss(true)
        }

    }

    private func navigateToLoginView() {
        let loginView = LoginView(viewModel: viewModel)
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = UIHostingController(rootView: loginView)
            window.makeKeyAndVisible()
        }
    }

}
