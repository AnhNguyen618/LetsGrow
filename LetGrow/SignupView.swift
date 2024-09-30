import SwiftUI

struct SignupView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                // Logo
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .foregroundColor(.blue)
                    .padding(.bottom, 20)
                
                
                // Name Field
                TextField("Name:", text: $name)
                    .font(.custom("Noteworthy", size: 16)) // Input field font size
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(8)
                    .padding(.horizontal, 40)
                
                // Email Field
                TextField("Email:", text: $email)
                    .font(.custom("Noteworthy", size: 16)) // Input field font size
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(8)
                    .padding(.horizontal, 40)
                
                // Password Field
                SecureField("Password:", text: $password)
                    .font(.custom("Noteworthy", size: 16)) // Input field font size
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(8)
                    .padding(.horizontal, 40)
                
                // Confirm Password Field
                SecureField("Confirm Password:", text: $confirmPassword)
                    .font(.custom("Noteworthy", size: 16)) // Input field font size
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(8)
                    .padding(.horizontal, 40)
                    .padding(.bottom, 10)
                
                // Signup Button
                Button(action: {
                    // Handle signup action
                }) {
                    Text("Signup")
                        .font(.custom("Noteworthy", size: 18)) // Button font size
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(red: 45/255, green: 140/255, blue: 251/255)) 
                        .cornerRadius(8)
                        .padding(.horizontal, 40)
                }
                .padding(.bottom, 10)
                
                // Link to Login
                HStack {
                    Text("Already have an account?")
                        .font(.custom("Noteworthy", size: 14)) // Small text font size
                    
                    NavigationLink(destination: LoginView()) {
                        Text("Log In")
                            .font(.custom("Noteworthy", size: 14)) // Small text font size
                            .foregroundColor(.blue)
                    }
                }
                .padding(.top, 5)
                
                Spacer()
            }
            .background(Color(red: 252/255, green: 245/255, blue: 234/255))
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
