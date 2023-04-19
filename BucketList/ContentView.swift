//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by Yashraj jadhav on 16/04/23.


// it’s the view model for ContentView.

/// We’re going to use this to create a new class that manages our data, and manipulates it on behalf of the ContentView struct so that our view doesn’t really care how the underlying data system works.
import UIKit
import Foundation
import MapKit
import LocalAuthentication
import SwiftUI
///The main actor is responsible for running all user interface updates, and adding that attribute to the class means we want all its code – any time it runs anything, unless we specifically ask otherwise – to run on that main actor. This is important because it’s responsible for making UI updates, and those must happen on the main actor.

extension ContentView {
    @MainActor class ViewModel : ObservableObject {
        let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedPlaces")
        
        
        
        @Published  var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
        @Published  private(set) var locations : [Location] = []
        @Published var selectedPlace: Location?
     //   @Published var errorTitle : String
        @Published var isUnlocked = false
        @Published var ShowingNotAlert = false
     //   @Published var errorMessage : String
      //  @Published var hasError = false
        @Published var errorTitle: String = ""
        @Published var errorMessage: String = ""
        @Published var hasError: Bool = false

        init() {
            if let data = try? Data(contentsOf: savePath),
               let decodedLocations = try? JSONDecoder().decode([Location].self, from: data) {
                locations = decodedLocations
            } else {
                locations = []
            }
        }

        
        func addLocation() {
            let newLocation = Location(id: UUID(), name: "New Location", description: " ", latitude: mapRegion.center.latitude, longitude: mapRegion.center.longitude)
            locations.append(newLocation)
            save()
        }
        
        func update(location: Location) {
            guard let selectedPlace = selectedPlace else { return }
            
            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = location
            }
            save()  }
        
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomic, .completeFileProtection])
            } catch {                print("Unable to save data.")
            }
        }
        func authenticate() {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please authenticate yourself to unlock your places." //Reason for TouchId here. Reason for FaceId in Info.plist
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    if success {
                        Task {
                            await MainActor.run{
                                self.isUnlocked = true
                            }
                        }
                    } else {
                        Task {
                            await MainActor.run{
                                self.errorTitle = "Authentication failed"
                                self.errorMessage = "Authentication with Face ID or Touch ID failed. Please try again."
                                self.hasError = true
                            }
                        }
                    }
                }
            } else {
                errorTitle = "Authentication failed"
                errorMessage = "Biometric authentication is not supported on your device."
            }
            print("Has error 6: \(self.hasError)")
        }

    }
}



















