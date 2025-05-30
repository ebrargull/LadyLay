import SwiftUI
import MapKit

struct MapScreenView: View {
    @EnvironmentObject var theme: ThemeViewModel
    @Binding var isLoggedIn: Bool
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7648, longitude: 30.5566),
        span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
    )

    @State private var locations: [MapPoint] = []
    @State private var newCoordinate: CLLocationCoordinate2D? = nil
    @State private var showAddLocationSheet = false

    @State private var newTitle: String = ""
    @State private var newDescription: String = ""
    @State private var isSafe: Bool = true

    let themeColor = Color.purple.opacity(0.7)

    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, annotationItems: locations) { location in
                MapAnnotation(coordinate: location.coordinate) {
                    VStack(spacing: 4) {
                        Image(systemName: location.isSafe ? "checkmark.shield.fill" : "exclamationmark.triangle.fill")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(location.isSafe ? Color.green : Color.pink)
                            .clipShape(Circle())
                            .shadow(radius: 4)

                        VStack(spacing: 2) {
                            Text(location.name)
                                .font(.footnote)
                                .bold()
                                .foregroundColor(.black)
                            Text(location.description)
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                        .padding(6)
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(8)
                        .shadow(radius: 2)
                    }
                }
            }
            .gesture(
                LongPressGesture(minimumDuration: 1.0)
                    .sequenced(before: DragGesture(minimumDistance: 0))
                    .onEnded { value in
                        switch value {
                        case .second(true, let drag?):
                            let location = drag.location
                            let coordinate = convertToCoordinate(from: location, in: region)
                            newCoordinate = coordinate
                            showAddLocationSheet = true
                        default:
                            break
                        }
                    }
            )
            .ignoresSafeArea()

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    VStack(spacing: 16) {
                        Button(action: {
                            region.span.latitudeDelta *= 0.5
                            region.span.longitudeDelta *= 0.5
                        }) {
                            Image(systemName: "plus.magnifyingglass")
                                .font(.title2)
                                .padding()
                                .foregroundColor(.white)
                                .background(theme.selectedColor)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }

                        Button(action: {
                            region.span.latitudeDelta *= 2
                            region.span.longitudeDelta *= 2
                        }) {
                            Image(systemName: "minus.magnifyingglass")
                                .font(.title2)
                                .padding()
                                .foregroundColor(.white)
                                .background(theme.selectedColor)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                    }
                    .padding()
                }
            }
        }
        .sheet(isPresented: $showAddLocationSheet) {
            VStack(spacing: 20) {
                Text("Yeni Konum Ekle")
                    .font(.title3)
                    .bold()
                    .foregroundColor(themeColor)

                TextField("Başlık", text: $newTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                TextField("Açıklama", text: $newDescription)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                Toggle("Güvenli Konum", isOn: $isSafe)
                    .padding(.horizontal)
                    .toggleStyle(SwitchToggleStyle(tint: themeColor))

                Button("Ekle") {
                    if let coordinate = newCoordinate {
                        let new = MapPoint(
                            id: UUID().hashValue,
                            name: newTitle.isEmpty ? "Yeni Konum" : newTitle,
                            description: newDescription,
                            coordinate: coordinate,
                            isSafe: isSafe
                        )
                        locations.append(new)
                    }
                    resetInput()
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(themeColor)
                .cornerRadius(12)
                .padding(.horizontal)

                Button("İptal", role: .cancel) {
                    resetInput()
                }
                .foregroundColor(.red)
            }
            .padding(.vertical)
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.white, themeColor.opacity(0.3)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        )
    }

    private func convertToCoordinate(from point: CGPoint, in region: MKCoordinateRegion) -> CLLocationCoordinate2D {
        let screenSize = UIScreen.main.bounds.size
        let mapWidth = screenSize.width
        let mapHeight = screenSize.height

        let latDelta = region.span.latitudeDelta
        let lonDelta = region.span.longitudeDelta

        let lat = region.center.latitude + (latDelta / 2) - (latDelta * Double(point.y / mapHeight))
        let lon = region.center.longitude - (lonDelta / 2) + (lonDelta * Double(point.x / mapWidth))

        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }

    private func resetInput() {
        newTitle = ""
        newDescription = ""
        isSafe = true
        newCoordinate = nil
        showAddLocationSheet = false
    }
}

struct MapPoint: Identifiable {
    let id: Int
    let name: String
    let description: String
    let coordinate: CLLocationCoordinate2D
    let isSafe: Bool
}
