import SwiftUI

struct SJSUStoreView: View {
    struct StoreItem: Identifiable {
        var id = UUID()
        var price: Int
        var imageName: String
    }
    
    let items: [StoreItem] = [
        StoreItem(price: 30, imageName: "hat_box"),
        StoreItem(price: 30, imageName: "hat_box"),
        StoreItem(price: 30, imageName: "hat_box"),
        StoreItem(price: 30, imageName: "hat_box")
    ]
    
    @State private var userCoins: Int = 100 // Example coin balance
    @State private var navigateToHome = false // State variable to control navigation

    var body: some View {
        NavigationStack {
            ZStack {
                Image("sjsu_store_background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
    
                VStack {
                    HStack {
                        VStack {
                            // Home Button
                            Button(action: {
                                navigateToHome = true // Set to true to activate navigation
                            }) {
                                Image("home_button")
                                    .resizable() // Allows resizing the image
                                    .scaledToFit() // Maintains the aspect ratio
                                    .frame(width: 80, height: 80)
                            }
                            .frame(width: 100, height: 100)
                            
                            // Coin Image and Text
                            HStack {
                                Spacer()
                                    .frame(width: 20)
                                Image("coin")
                                    .resizable()
                                    .frame(width: 45, height: 45)
                                
                                Text("\(userCoins)")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.yellow)
                            }
                            .padding(.top, 255) // Vertical offset below the home button
                        }
                        
                        Spacer()
                        
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    Spacer()
                    
                    // Item Grid
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                            ForEach(items) { item in
                                VStack(spacing: 5) {
                                    ZStack {
                                        Image(item.imageName)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 300, height: 300)
                                    }
                                    
                                    HStack {
                                        Image("coin")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 20, height: 20)
                                        
                                        Text("\(item.price)")
                                            .font(.headline)
                                            .foregroundColor(.yellow)
                                    }
                                    .padding(10)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                                }
                                .onTapGesture {
                                    if userCoins >= item.price {
                                        userCoins -= item.price
                                        print("Purchased item for \(item.price) coins")
                                    }
                                }
                            }
                        }
        
                    }
                    .frame(height: 300)
                    .padding(.bottom, 20)
                }
                .navigationDestination(isPresented: $navigateToHome) {
                    HomeView()
                }
            }
        }
    }
}

// Preview
struct SJSUStoreView_Previews: PreviewProvider {
    static var previews: some View {
        SJSUStoreView()
    }
}
