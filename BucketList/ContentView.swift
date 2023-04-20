import MapKit
import SwiftUI
import LocalAuthentication



struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    @State private var showingAuthenticationAlert = false
    @State private var authenticationError = ""
    @State private var isUnlocked = true
    
    var body: some View {
        ZStack {
            Image("travel-bg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .opacity(0.6)
            
            if viewModel.isUnlocked {
                Map(coordinateRegion: $viewModel.mapRegion, annotationItems: viewModel.locations) { location in
                    MapAnnotation(coordinate: location.coordinate) {
                        VStack {
                            MapPin()
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
                    .frame(width: 32, height: 32)
                
                VStack {
                    Spacer(minLength: .zero)
                    
                    HStack {
                        
                        
                        GeometryReader { geometry in
                            Button(action: {
                                viewModel.addLocation()
                            }, label: {
                                Image(systemName: "plus")
                                    .padding()
                                    .background(.black.opacity(0.75))
                                    .foregroundColor(.white)
                                    .font(.title)
                                    .clipShape(Circle())
                                    .padding(.trailing)
                            })
                            .position(x: geometry.size.height / 2, y : geometry.size.width / 1.2)
                        }
                    }
                }
            } else {
                Button("Unlock Places") {
                    viewModel.authenticate()
                }
                .padding()
                .background(.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
                .alert(viewModel.errorTitle,isPresented: $viewModel.hasError) {
                    Button("OK"){}
                }
            }
        }
        .sheet(item: $viewModel.selectedPlace) { place in
            EditView(location: place) { newLocation in
                viewModel.update(location: newLocation)
            }
        }
    }
}


struct MapPin: View {
    @State private var isAnimating = false
    
    var body: some View {
        Image(systemName: "mappin.circle.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(.white)
            .frame(width: 30, height: 30)
            .scaleEffect(isAnimating ? 1.2 : 1)
            .opacity(isAnimating ? 0.8 : 1)
            .animation(
                Animation.easeInOut(duration: 1.5)
                    .repeatForever(autoreverses: true)
            )
            .onAppear {
                isAnimating = true
            }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
}





















