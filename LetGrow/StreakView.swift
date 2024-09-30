import SwiftUI

struct StreakView: View {
    let columns = [GridItem(.fixed(70)), GridItem(.fixed(70)), GridItem(.fixed(70))] // Adjust columns for layout
    @State private var navigateToHome = false // State for navigation
    @State private var isCollected = false // Tracks whether the reward has been collected

    var body: some View {
        VStack {
            Spacer()
            // Middle Section: Paw Grid
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(0..<9) { index in
                    VStack(spacing: 5) {
                        // Paw Icon
                        Image(index < 7 ? "paw_filled" : "paw_empty")
                            .resizable()
                            .frame(width: 50, height: 50)

                        // Reward below the paw
                        HStack(spacing: 5) {
                            Image("coin")
                                .resizable()
                                .frame(width: 15, height: 15)
                            Text("x\(20 + index * 10)")
                                .font(.caption)
                                .foregroundColor(.orange)
                        }
                    }
                }
            }
            .padding(.bottom, 20)
            
            // Bottom Section: "Collect" Button
            Button(action: {
                isCollected = true // Mark reward as collected
            }) {
                Text(isCollected ? "Collected" : "Collect")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .padding(10)
                    .frame(width: 120)
                    .background(isCollected ? Color.gray : Color(red: 255 / 255, green: 184 / 255, blue: 195 / 255))
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(isCollected)
            .padding(.bottom, 20)


            Spacer() // Pushes content upward to avoid crowding the bottom
        }
        .padding(.bottom, 120)
        .background(imageBackground)
    }
    
    var imageBackground: some View {
        Image("streak_background")
            .resizable()
            .scaledToFill()
    }
}

struct StreakView_Previews: PreviewProvider {
    static var previews: some View {
        StreakView()
    }
}
