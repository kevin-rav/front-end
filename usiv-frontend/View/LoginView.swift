//
//  LoginView.swift
//  usiv-request
//
//  Created by Kevin Ravakhah on 2/12/24.
//

import SwiftUI
import PopupView

struct LoginView: View {
    
    @ObservedObject var viewModel: LoginViewModel
    
    @State private var showingLoginPopup = false
    @State private var showingRegisterPopup = false
    
    @State private var showingErrorAlert = false
    @State private var navigateToContent = false
    
    var body: some View {
        NavigationView {
            ZStack {
                HStack(spacing: 20) {
                    Color(red: 186/255, green: 12/255, blue: 47/255)
                        .frame(maxWidth: .infinity)
                    
                    Color(red: 167/255, green: 177/255, blue: 178/255)
                        .frame(maxWidth: .infinity)
                }
                .frame(height: 1000)
                .edgesIgnoringSafeArea(.vertical)
                .background(Color(red: 77/255, green: 77/255, blue: 77/255))
                
                VStack {
                    
                    Image("osulogowhite")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 2)
                    
                    Text("ULTRASOUND GUIDED IV REQUESTS")
                        .font(Font.custom("BuckeyeSerif2-Bold", size: 32, relativeTo: .title))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .opacity(0.7)
                        .padding(.bottom, 10)
                        .frame(height: 100)
                    
                    VStack(spacing: 20) {
                        Button(action: {
                            showingLoginPopup = true
                        }) {
                            Text("Sign In")
                                .font(Font.custom("BuckeyeSerif2-SemiBold", size: 16))
                                .foregroundColor(.white)
                                .opacity(0.7)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(red: 186/255, green: 12/255, blue: 47/255))
                                .cornerRadius(15.0)
                        }
                        
                        Button(action: {
                            showingRegisterPopup = true
                        }) {
                            Text("Register")
                                .font(Font.custom("BuckeyeSerif2-SemiBold", size: 16))
                                .foregroundColor(.white)
                                .opacity(0.7)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(red: 186/255, green: 12/255, blue: 47/255))
                                .cornerRadius(15.0)
                        }
                    }
                }.padding()
                    .background(Color(red: 77/255, green: 77/255, blue: 77/255))
                    .cornerRadius(20)
                    .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } .blur(radius: showingLoginPopup || showingRegisterPopup ? 10 : 0)
            .onReceive(viewModel.$isLoggedIn) { isLoggedIn in
                if isLoggedIn { // Ensure navigation occurs only once
                    navigateToContentView()
                }
            }
            .popup(isPresented: $showingLoginPopup) {
                // Popup view for login
                VStack {
                    Text("SIGN IN")
                        .font(Font.custom("BuckeyeSerif2-SemiBold", size: 30))
                        .foregroundColor(.white)
                        .opacity(0.7)
                        .padding(.bottom, 10)
                    
                    TextField("Username", text: $viewModel.username)
                        .font(Font.custom("BuckeyeSerif2-SemiBold", size: 16))
                        .padding()
                        .background(Color(red: 167/255, green: 177/255, blue: 178/255))
                        .cornerRadius(5)
                        .padding(.horizontal)
                    
                    SecureField("Password", text: $viewModel.password)
                        .font(Font.custom("BuckeyeSerif2-SemiBold", size: 16))
                        .padding()
                        .background(Color(red: 167/255, green: 177/255, blue: 178/255))
                        .cornerRadius(5)
                        .padding(.horizontal)
                    
                    Button(action: {
                        viewModel.authenticateUser { success in
                            if success {
                                showingLoginPopup = false
                            } else {
                                showingErrorAlert = true
                            }
                        }
                    }) {
                        Text("Submit")
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
                .frame(maxWidth: 360)
                .frame(minHeight: 350)
                .background(Color(red: 77/255, green: 77/255, blue: 77/255))
                .cornerRadius(20)
            } customize: {
                $0.useKeyboardSafeArea(true)
                    .closeOnTap(false)
                    .dragToDismiss(true)
            }
        
            .popup(isPresented: $showingRegisterPopup) {
                VStack {
                    Text("REGISTER")
                        .font(Font.custom("BuckeyeSerif2-SemiBold", size: 30))
                        .foregroundColor(.white)
                        .opacity(0.7)
                        .padding(.bottom, 10)
                    
                    TextField("Username", text: $viewModel.registerUsername)
                        .font(Font.custom("BuckeyeSerif2-SemiBold", size: 16))
                        .padding()
                        .background(Color(red: 167/255, green: 177/255, blue: 178/255))
                        .cornerRadius(5)
                        .padding(.horizontal)
                    
                    SecureField("Password", text: $viewModel.registerPassword)
                        .font(Font.custom("BuckeyeSerif2-SemiBold", size: 16))
                        .padding()
                        .background(Color(red: 167/255, green: 177/255, blue: 178/255))
                        .cornerRadius(5)
                        .padding(.horizontal)
                    
                    SecureField("Confirm Password", text: $viewModel.confirmPassword)
                        .font(Font.custom("BuckeyeSerif2-SemiBold", size: 16))
                        .padding()
                        .background(Color(red: 167/255, green: 177/255, blue: 178/255))
                        .cornerRadius(5)
                        .padding(.horizontal)
                    
                    Picker(selection: $viewModel.role, label: Text("User Role")) {
                        Text("Requester").tag(0)
                        Text("Responder").tag(1)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    Button(action: {
                        viewModel.registerUser { success in
                            if success {
                                showingRegisterPopup = false
                            } else {
                                showingErrorAlert = true
                            }
                        }
                    }) {
                        Text("Register")
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
                .frame(maxWidth: 360)
                .frame(minHeight: 400)
                .background(Color(red: 77/255, green: 77/255, blue: 77/255))
                .cornerRadius(20)
            } customize: {
                $0.useKeyboardSafeArea(true)
                    .closeOnTap(false)
                    .dragToDismiss(true)
            }
         
            // Error alert
            .alert(isPresented: $showingErrorAlert) {
                let errorMessage = viewModel.errorMessage()
                return Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")) {
                    // Reset ViewModel properties
                    viewModel.resetErrors()
                })
            }
    }
    
    private func navigateToContentView() {
        let contentView = ContentView(viewModel: viewModel)
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = UIHostingController(rootView: contentView)
            window.makeKeyAndVisible()
        }
    }

}
