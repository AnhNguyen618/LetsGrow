import SwiftUI

struct StoreView: View {
    struct StoreItem: Identifiable {
        var id = UUID()
        var price: Int
        var imageName: String
    }
    
    // Sample data with "pet_box" image for each item
    let items: [StoreItem] = [
        StoreItem(price: 30, imageName: "pet_box"),
        StoreItem(price: 40, imageName: "pet_box"),
        StoreItem(price: 50, imageName: "pet_box"),
        StoreItem(price: 60, imageName: "pet_box")
    ]
    
    @State private var userCoins: Int = 100
    @State private var navigateToHome = false // State to handle navigation

    var body: some View {
        ZStack {
            // Background Image
            Image("store_background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                            // Home Button and Coin Image
                            HStack {
                                VStack {
                                    Button(action: {
                                        navigateToHome = true
                                    }) {
                                        Image("home_button")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 80, height: 80)
                                    }
                                    .frame(width: 100, height: 100)
                                    .contentShape(Rectangle())
                                    
                                    HStack {
                                        Spacer()
                                            .frame(width: 20)
                                        
                                        Image("coin")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .padding(.top, 255)
                                        
                                        Text("\(userCoins)")
                                            .font(.largeTitle)
                                            .fontWeight(.heavy)
                                            .foregroundColor(.yellow)
                                            .padding(.top, 255)
                                    }

                                }

                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.top, 20)

                            Spacer()

                // ScrollView for Store Items
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                        ForEach(items) { item in
                            VStack {
                                ZStack {
                                    Image(item.imageName)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(height: 300) // Adjust image size
                                }
                                
                                HStack {
                                    Image("coin")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                    
                                    Text("\(userCoins)")
                                        .font(.headline)
                                        .foregroundColor(.yellow)
                                        
                                }
                                .padding(8)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 3)
                            }
                            .padding(10)
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(height: 300) // Adjust height of ScrollView
                .padding(.bottom, 20) // Space between ScrollView and bottom of the screen
            }
            .navigationBarHidden(true) // Hides default navigation bar
            .fullScreenCover(isPresented: $navigateToHome) {
                HomeView()
            }
        }
    }
}


struct StoreView_Previews: PreviewProvider {
    static var previews: some View {
        StoreView()
    }
}
