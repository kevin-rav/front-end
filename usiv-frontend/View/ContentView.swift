import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 1
    @StateObject var viewModel: LoginViewModel

    init(viewModel: LoginViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {

        TabView(selection: $selectedTab) {
            AvailableRequestsView(viewModel: AvailableRequestsViewModel(username: viewModel.username, password: viewModel.password))
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("Available")
                }
                .tag(1)
            
            PostedRequestsView(viewModel: PostedRequestsViewModel(username: viewModel.username, password: viewModel.password))
                .tabItem {
                    Image(systemName: "plus")
                    Text("Posted")
                }
                .tag(2)
            
            AcceptedRequestsView(viewModel: AcceptedRequestsViewModel(username: viewModel.username, password: viewModel.password))
                .tabItem {
                    Image(systemName: "checkmark")
                    Text("Accepted")
                }
                .tag(3)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar { // Add a toolbar at the top
            ToolbarItem(placement: .navigationBarTrailing) { // Place the button on the trailing side of the navigation bar
                Button(action: {
                    viewModel.logout() // Call the logout function from the view model
                }) {
                    Text("Logout") // Display text for the button
                }
            }
        }
    }
}
