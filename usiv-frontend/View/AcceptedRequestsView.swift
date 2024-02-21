//
//  PostedRequestsView.swift
//  usiv-frontend
//
//  Created by Kevin Ravakhah on 2/15/24.
//

import SwiftUI

struct AcceptedRequestsView: View {
    @StateObject var viewModel: AcceptedRequestsViewModel
    
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
                    Text("\(viewModel.username.uppercased()) ACCEPTED REQUESTS:")
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
                                        Text("\(request.hospital), rm \(request.roomNumber)\nCB#: \(request.callBackNumber)\nNotes: \(request.notes)")
                                            .font(Font.custom("BuckeyeSerif2-SemiBold", size: 16))
                                            .fixedSize(horizontal: false, vertical: true)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .foregroundColor(.white)
                                        Spacer() // Pushes the cancel button to the right corner
                                        VStack {
                                            Button("Unaccept") {
                                                viewModel.unacceptRequest(requestID: request.id)
                                            }
                                            .font(Font.custom("BuckeyeSerif2-SemiBold", size: 16))
                                            .frame(width: 75)
                                            .foregroundColor(.white)
                                            .padding()
                                            .background(Color(red: 186/255, green: 12/255, blue: 47/255))
                                            .cornerRadius(5)
                                            Button("Completed") {
                                                viewModel.markCompletedRequest(requestID: request.id)
                                            }
                                            .font(Font.custom("BuckeyeSerif2-SemiBold", size: 16))
                                            .frame(width: 85)
                                            .foregroundColor(.white)
                                            .padding()
                                            .background(Color(red: 186/255, green: 12/255, blue: 47/255))
                                            .cornerRadius(5)
                                            
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
                                    }
                                }
                                .padding(15)
                                .background(Color(red: 77/255, green: 77/255, blue: 77/255))
                                .cornerRadius(10)
                                .padding(.horizontal, 20)
                                .padding(.bottom, 10)
                            }

                        }
                        .frame(height: 580)
                    
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                viewModel.fetchUserAcceptedRequests()
            }
        }.navigationBarBackButtonHidden(true) // Hide the back button
    }
}





