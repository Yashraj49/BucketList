import MapKit
import SwiftUI
import LocalAuthentication

struct ContentView: View {
    @State private var selectedPlace: Location?
    @State private var locations = [Location]()
    @State private var isUnlocked = false
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
    
    
    
    
    var body: some View {
        
        ZStack{
            Map(coordinateRegion: $mapRegion, annotationItems: locations) { location in
                MapAnnotation(coordinate: location.coordinate) {
                    VStack {
                        Image(systemName: "star.circle")
                            .resizable()
                            .foregroundColor(.red)
                            .frame(width: 44, height: 44)
                            .background(.white)
                            .clipShape(Circle())
                        
                        Text(location.name)
                            .fixedSize()
                    }
                    .onTapGesture {
                      selectedPlace = location
                    }
                 }
            }
            .ignoresSafeArea()
            Circle()
                .fill(.blue)
                .opacity(0.3)
                .frame(width: 32 , height: 32)
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    Button{
                        var newLocation = Location(id: UUID(), name: "New Location", description: "", latitude: mapRegion.center.latitude, longitude: mapRegion.center.longitude)
                        locations.append(newLocation)
                    } label: {
                        Image(systemName: "plus")
                    }
                    .padding()
                    .background(.black.opacity(0.75))
                    .foregroundColor(.white)
                    .font(.title)
                    .clipShape(Circle())
                    .padding(.trailing)
                    
                }
                
            }
            
        }
        .sheet(item: $selectedPlace) {place in
            Text(place.name)
            
             //MARK: - accepts the new location, then looks up where the current location is and replaces it in the array. This will cause our map to update immediately with the new data.
            
            EditView(location: place) { newLocation in
                if let index = locations.firstIndex(of: place) {
                    locations[index] = newLocation
                }
            }
        }
        
    }
    
}
        
//        func authenticate() {
//
//            let context = LAContext()
//            var error: NSError?
//
//            // check whether biometric authentication is possible
//            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
//                // it's possible, so go ahead and use it
//                let reason = "We need to unlock your data."
//
//                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
//
//                    // authentication has now completed
//
//                    if success {
//                        isUnlocked = true
//                    } else {
//                        // there was a problem
//                    }
//                }
//            } else {
//                // no biometrics
//            }
//        }





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
