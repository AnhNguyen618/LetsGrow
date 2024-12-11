import SwiftUI

struct ProfileView: View {
    @State private var isLoggedIn = false // Tracks if the user is logged in
    @State private var navigateToHome = false // State to handle navigation
    @State private var navigateToLogin = false // State to handle navigation LoginView
    var body: some View {
        ZStack {
            // Background image or color
            Image("profile_background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            // Main content
            VStack(alignment: .leading, spacing: 15) {
                // Home Button at the Top Left
                HStack {
                    Button(action: {
                        navigateToHome = true // Trigger navigation
                    }) {
                        Image("home_button")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80) // Adjust size of the home button
                            .padding()
                    }
                    .frame(width: 100, height: 100) // Encloses the button in a larger touchable area
                    .contentShape(Rectangle()) // Ensures the touchable area matches the frame
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                // Profile Info Section
                HStack {
                    Image("profile")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.orange)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Username: abc")
                            .font(.custom("Noteworthy", size: 20))
                            .foregroundColor(Color(red: 126 / 255, green: 182 / 255, blue: 247 / 255))
                        
                        Text("Email: abc@gmail.com")
                            .font(.custom("Noteworthy", size: 20))
                            .foregroundColor(Color(red: 126 / 255, green: 182 / 255, blue: 247 / 255))
                        
                        Text("Your Pets: 7")
                            .font(.custom("Noteworthy", size: 20))
                            .foregroundColor(Color(red: 126 / 255, green: 182 / 255, blue: 247 / 255))
                        
                        Text("Total Grow Time: 32 hours")
                            .font(.custom("Noteworthy", size: 20))
                            .foregroundColor(Color(red: 126 / 255, green: 182 / 255, blue: 247 / 255))
                    }
                    .padding(.leading, 10)
                }
                .padding(.bottom, 20)
                
                // Session Statistics Section
                VStack(alignment: .leading, spacing: 10) {
                    Text("Focus Timer Stats")
                        .font(.custom("Noteworthy", size: 20))
                        .foregroundColor(Color(red: 254 / 255, green: 161 / 255, blue: 192 / 255))
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Total Sessions Completed:")
                                .font(.custom("Noteworthy", size: 20))
                                .foregroundColor(Color(red: 126 / 255, green: 182 / 255, blue: 247 / 255))
                            Text("45")
                                .font(.custom("Noteworthy", size: 20))
                                .fontWeight(.bold)
                                .foregroundColor(Color(red: 22 / 255, green: 98 / 255, blue: 205 / 255))
                        }
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            Text("Total Focus Time:")
                                .font(.custom("Noteworthy", size: 20))
                                .foregroundColor(Color(red: 126 / 255, green: 182 / 255, blue: 247 / 255))
                            Text("32 hours")
                                .font(.custom("Noteworthy", size: 20))
                                .fontWeight(.bold)
                                .foregroundColor(Color(red: 22 / 255, green: 98 / 255, blue: 205 / 255))
                        }
                    }
                    .padding()
                    .background(Color(red: 126 / 255, green: 182 / 255, blue: 247 / 255).opacity(0.1))
                    .cornerRadius(10)
                }
                .padding(.bottom, 30)
                // Change Institution Button
                Button(action: {
                    // Navigate to the password change section
                }) {
                    Text("Link your Institution")
                        .font(.custom("Noteworthy", size: 20))
                        .padding()
                        .background(Color(red: 126 / 255, green: 182 / 255, blue: 247 / 255))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.bottom, 30)
                
                // Login/Logout Button
                Button(action: {
                    if isLoggedIn {
                        isLoggedIn = false // Log out
                    } else {
                        navigateToLogin = true // Navigate to LoginView
                    }
                }) {
                    Text(isLoggedIn ? "Log Out" : "Log In")
                        .font(.custom("Noteworthy", size: 20))
                        .padding()
                        .background(isLoggedIn ? Color.red : Color(red: 255 / 255, green: 184 / 255, blue: 195 / 255))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.bottom, 30)
                
                Spacer()
            }
            .padding()
            .fullScreenCover(isPresented: $navigateToHome) {
                // Navigate to the Home View
                HomeView()
            }
            .fullScreenCover(isPresented: $navigateToLogin) {
                // Navigate to the Login View
                LoginView()
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
