# Ultrasound Guided IV Request iOS App - Frontend 

## Requirements
To deploy the application to an iPhone, you will need to run this application on MacOS with XCode. Before running, edit the "LinkToDatabase.swift" file with proper server link. 

## Architecture
- This app is structured with Model View View Model architecture
- The app initially opens in the Login View where a user can Login or Create an account.
- Once successfully logged in the application moves to the ContentView.
- If the user selected requestor when registering, they see a tab view with the Posted Requests View.
- If the user selected responder when registering, they see a tab view with the Available Requests and Accepted Request Views. 

## Languages, Tools, and Graphics
- The application is written entirely in XCode
- The [PopupView Library](https://github.com/exyte/PopupView) was utilized for aesthetic popups
- The Ohio State University [BuckeyeSerif fonts and Scarlett Grey color palette](https://brand.ehe.osu.edu/graphics/) were utilized for theme

## Backend Integration
- This application requires a backend to create an account, log in, and post and accept requests
- The backend is also written in Swift with the Vapor framework alongside an SQL database
- To run the backend, check out [usiv-backend](https://github.com/kevin-rav/usiv-backend)

