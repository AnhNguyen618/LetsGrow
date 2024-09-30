import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var navigateToHome = false // State to handle navigation
    
    var body: some View {
        NavigationView{
            VStack {
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
                Spacer()
                
                // Logo
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .foregroundColor(.blue)
                    .padding(.bottom, 20)
                
                
                // Email Field
                TextField("Email:", text: $email)
                    .font(.custom("Noteworthy", size: 20))
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(8)
                    .padding(.horizontal, 40)
                
                // Password Field
                SecureField("Password:", text: $password)
                    .font(.custom("Noteworthy", size: 20))
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(8)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 10)
                
                // Login Button
                Button(action: {
                    // Handle login action
                }) {
                    Text("Login")
                        .font(.custom("Noteworthy", size: 20)) // Ensure a size is specified for the custom font
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 45/255, green: 140/255, blue: 251/255)) // RGB(45, 140, 251)
                        .cornerRadius(8)
                        .padding(.horizontal, 40)
                }
                .padding(.bottom, 10)
                
                
                // Links for Signup
                HStack {
                    NavigationLink(destination: SignupView()){
                        Text("Signup!")
                            .font(.custom("Noteworthy", size: 20))
                            .font(.footnote)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.top, 5)
                
                Spacer()
            }
            .background(Color(red: 252/255, green: 245/255, blue: 234/255))
            .edgesIgnoringSafeArea(.all)
            .fullScreenCover(isPresented: $navigateToHome) {
                // Navigate to the Home View
                HomeView()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
