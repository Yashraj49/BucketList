import MapKit
import SwiftUI
import LocalAuthentication

struct ContentView: View {
    @State private var isUnlocked = false
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        if viewModel.isUnlocked {
        ZStack{
            Map(coordinateRegion: $viewModel.mapRegion, annotationItems: viewModel.locations) { location in
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
                        viewModel.selectedPlace = location
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
                    Button {
                        viewModel.addLocation()
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
            
            
            
            
            //MARK: - accepts the new location, then looks up where the current location is and replaces it in the array. This will cause our map to update immediately with the new data.
        }
        .sheet(item: $viewModel.selectedPlace) {place in
            EditView(location: place) {
                viewModel.update(location: $0)
            }
            }
        } else {
             //button here
            Button("Unlock Places") {
                viewModel.authenticate()
            }
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
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
















