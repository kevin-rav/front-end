//
//  PostedRequestsView.swift
//  usiv-frontend
//
//  Created by Kevin Ravakhah on 2/15/24.
//

import SwiftUI
import PopupView

struct PostedRequestsView: View {
    @StateObject var viewModel: PostedRequestsViewModel
    @State private var showingCreateRequestPopup = false
    
    // State variables to hold input values for creating a request
    @State private var hospital = ""
    @State private var roomNumber = ""
    @State private var callbackNumber = ""
    @State private var notes = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(red: 167/255, green: 177/255, blue: 178/255, opacity: 1.5), // Red with opacity
                                                            // Green with opacity
                                                           Color(red: 186/255, green: 12/255, blue: 47/255, opacity: 0.3)]), // Blue with opacity
                               startPoint: .top,
                               endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Title
                    Text("\(viewModel.username.uppercased()) POSTED REQUESTS:")
                        .font(Font.custom("BuckeyeSerif2-Bold", size: 25))
                        .foregroundColor(.black)
                        .opacity(0.7)
                        .padding(.bottom, 20)
                        .padding(.horizontal, 20)
                    
                    // Box holding the requests
                    VStack {
                        ScrollView {
                            ForEach(viewModel.requests) { request in
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        Text("\(request.hospital), rm \(request.roomNumber)\nCB#: \(request.callBackNumber)")
                                            .font(Font.custom("BuckeyeSerif2-SemiBold", size: 16))
                                            .fixedSize(horizontal: false, vertical: true)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .foregroundColor(.white)
                                        Spacer() // Pushes the cancel button to the right corner
                                        if (request.status == 0 || request.status == 1) {
                                            Button("Cancel") {
                                                viewModel.cancelRequest(requestID: request.id)
                                            }
                                            .font(Font.custom("BuckeyeSerif2-SemiBold", size: 16))
                                            .foregroundColor(.white)
                                            .padding()
                                            .background(Color(red: 186/255, green: 12/255, blue: 47/255))
                                            .cornerRadius(5)
                                        } else {
                                            Button("Delete") {
                                                viewModel.deleteRequest(requestID: request.id)
                                            }
                                            .font(Font.custom("BuckeyeSerif2-SemiBold", size: 16))
                                            .foregroundColor(.white)
                                            .padding()
                                            .background(Color(red: 186/255, green: 12/255, blue: 47/255))
                                            .cornerRadius(5)
                                        }
                                        // Button to view the chat
                                        NavigationLink(destination: ChatView(requestID: request.id, userName: viewModel.username)) {
                                            Text("Chat")
                                                .font(Font.custom("BuckeyeSerif2-SemiBold", size: 16))
                                                .foregroundColor(.white)
                                                .padding()
                                                .background(Color(red: 186/255, green: 12/255, blue: 47/255))
                                                .cornerRadius(5)
                                        }
                            
                                    }
                                    
                                    Text("Notes: \(request.notes)\nStatus: \(statusText(for: request.status))")
                                        .font(Font.custom("BuckeyeSerif2-SemiBold", size: 16))
                                        .fixedSize(horizontal: false, vertical: true)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .foregroundColor(.white)
                                }
                                .padding(15)
                                .background(Color(red: 77/255, green: 77/255, blue: 77/255))
                                .cornerRadius(10)
                                .padding(.horizontal, 20)
                                .padding(.bottom, 10)
                            }
                            
                        }
                        .frame(height: 500)
                        .padding(.bottom, 20)
                        
                        Button("Create Request") {
                            showingCreateRequestPopup = true
                        }
                        .font(Font.custom("BuckeyeSerif2-SemiBold", size: 16))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color(red: 186/255, green: 12/255, blue: 47/255))
                        .cornerRadius(5)
                    }
                }
            }.blur(radius: showingCreateRequestPopup ? 10 : 0)
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                viewModel.fetchUserPostedRequests()
            }
        }
        .navigationBarBackButtonHidden(true) // Hide the back button
        .popup(isPresented: $showingCreateRequestPopup) {
            VStack {
                Text("CREATE REQUEST")
                    .font(Font.custom("BuckeyeSerif2-SemiBold", size: 30))
                    .foregroundColor(.white)
                    .opacity(0.7)
                    .padding(.bottom, 10)
                
                TextField("Hospital", text: $hospital)
                    .font(Font.custom("BuckeyeSerif2-SemiBold", size: 16))
                    .padding()
                    .background(Color(red: 167/255, green: 177/255, blue: 178/255))
                    .cornerRadius(5)
                    .padding(.horizontal)
                
                TextField("Room Number", text: $roomNumber)
                    .font(Font.custom("BuckeyeSerif2-SemiBold", size: 16))
                    .padding()
                    .background(Color(red: 167/255, green: 177/255, blue: 178/255))
                    .cornerRadius(5)
                    .padding(.horizontal)
                    .keyboardType(.numberPad)
                
                TextField("Callback Number", text: $callbackNumber)
                    .font(Font.custom("BuckeyeSerif2-SemiBold", size: 16))
                    .padding()
                    .background(Color(red: 167/255, green: 177/255, blue: 178/255))
                    .cornerRadius(5)
                    .padding(.horizontal)
                    .keyboardType(.phonePad)
                
                TextField("Notes", text: $notes)
                    .font(Font.custom("BuckeyeSerif2-SemiBold", size: 16))
                    .padding()
                    .background(Color(red: 167/255, green: 177/255, blue: 178/255))
                    .cornerRadius(5)
                    .padding(.horizontal)
                
                Button(action: {
                    viewModel.createRequest(hospital: hospital, roomNumber: Int(roomNumber) ?? 0, callbackNumber: callbackNumber, notes: notes)
                    
                    showingCreateRequestPopup = false
                    hospital = ""
                    roomNumber = ""
                    callbackNumber = ""
                    notes = ""
                    
                }) {
                    Text("Create")
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
    }
    
    func statusText(for status: Int) -> String {
        switch status {
        case 0:
            return "Available"
        case 1:
            return "Accepted"
        case 2:
            return "Cancelled"
        case 3:
            return "Completed"
        default:
            return "Unknown"
        }
    }
}
