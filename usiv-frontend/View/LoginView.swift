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
                            //
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

                        NavigationLink(destination: ContentView(viewModel: viewModel), isActive: $viewModel.isLoggedIn) {
                            EmptyView()
                        }
                    }
                }.padding()
                    .background(Color(red: 77/255, green: 77/255, blue: 77/255))
                    .cornerRadius(20)
                    .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }.navigationBarHidden(true)
        .popup(isPresented: $showingLoginPopup) {
                // Popup view for login
            VStack {
                    Text("LOGIN")
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
                        .border(.red, width: CGFloat(viewModel.wrongUsername))
                    
                    SecureField("Password", text: $viewModel.password)
                        .font(Font.custom("BuckeyeSerif2-SemiBold", size: 16))
                        .padding()
                        .background(Color(red: 167/255, green: 177/255, blue: 178/255))
                        .cornerRadius(5)
                        .padding(.horizontal)
                        .border(.red, width: CGFloat(viewModel.wrongPassword))  
                    
                    Button(action: {
                        viewModel.authenticateUser { success in
                            if success {
                                showingLoginPopup = false
                            } else {
                                // Authentication failed, handle error or show appropriate message
                                // For example, display an alert or update error state
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
                .frame(maxWidth: 350)
                .frame(minHeight: 350)
                .background(Color(red: 77/255, green: 77/255, blue: 77/255))
                .cornerRadius(20)
            } customize: {
                $0.useKeyboardSafeArea(true)
                    .closeOnTap(false)
                    .dragToDismiss(true)
            }
         
    }
    
}
