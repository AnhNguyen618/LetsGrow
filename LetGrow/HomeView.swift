import SwiftUI
import WebKit

struct HomeView: View {
    // MARK: - State Variables
    @State private var selectedModeForPicker: String = "" // Mode selected for the time picker
    @State private var selectedMode: String = "Regular Mode" // Currently selected timer mode
    @State private var isMenuOpen: Bool = false // Toggles the side menu visibility
    @State private var remainingTime: Int = 30 * 60 // Default timer duration in seconds (30 minutes)
    @State private var isTimerRunning: Bool = false // Toggles the timer's running state
    @State private var isFocusTime: Bool = true // Tracks if it's focus time in Pomodoro mode
    @State private var showingTimePicker: Bool = false // Toggles the time picker modal
    @State private var selectedMinutes: Int = 30 // Default minutes for the regular mode timer
    @State private var pomodoroFocusTime: Int = 25 // Default focus time for Pomodoro mode (in minutes)
    @State private var pomodoroBreakTime: Int = 5  // Default break time for Pomodoro mode (in minutes)
    @State private var missionName: String = "Your Mission" // The mission name displayed on the screen
    @State private var isEditingMission: Bool = false // Toggles the mission name edit field
    @State private var showingMoodInput: Bool = false // Toggles the mood input modal
    @State private var showingCalendarView: Bool = false
    @State private var selectedMood: String = "" // Tracks the selected mood
    @State private var isStreakWindowOpen: Bool = false
    @State private var isLockdownActive = false
    @State private var missionImageWidth: CGFloat = 50
    @State private var totalTime: Int = 30 * 60 // Total timer duration (used for resetting)
    @State private var currentImageIndex: Int = 0 // Current image index
    @State private var circleProgress: CGFloat = 0.0 // Circular progress (0 to 1)
    @State private var showingLockdownPopup: Bool = false
    @State private var showingLockdownDeactivationPopup: Bool = false
    @State private var showingSpotifyPopup: Bool = false
    @State private var isSpotifyConnected: Bool = false // Track Spotify connection status
    @State private var userCoins: Int = 100 // User Coin
    @State private var showingPauseConfirmation: Bool = false
    @State private var showCompletionNotification: Bool = false
    @State private var showFailedNotification: Bool = false
    @State private var completionMessage: String = ""
    @State private var hasLoggedMood: Bool = false // variable to track mood logging
    // Array of images for the timer
    let imageStages = ["egg_timer", "egg_cracking", "half_egg", "pet_crack", "pet_egg", "pet_done"]
    // Timer that updates every second
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationView {
            ZStack {
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .opacity(isMenuOpen ? 0.5 : 1)


                // Side menu overlay
                if isMenuOpen {
                    HStack {
                        SideMenuView()
                        Spacer()
                    }
                }

                ScrollView {
                    VStack(spacing: 20) {
                        // MARK: - Top Bar with Menu, Coin, and Profile Icon
                        HStack {
                            // Hamburger menu button
                            Button(action: {
                                withAnimation {
                                    isMenuOpen.toggle()
                                }
                            }) {
                                Image(systemName: isMenuOpen ? "xmark" : "line.horizontal.3")
                                    .resizable()
                                    .frame(width: 30, height: 20)
                                    .padding(.leading)
                            }
                            
                            Spacer()
                            
                            // Coin and profile icons on the top right
                            HStack(spacing: 6) {
                                // Coin icon
                                Image("coin")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                Text("\(userCoins)")
                                    .font(.system(size: 24, weight: .bold, design: .rounded))
                                    .foregroundColor(.yellow) // Yellow text
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        Color.white.opacity(0.7)
                                    )
                                    .cornerRadius(12)
                                    .shadow(color: Color.gray.opacity(0.3), radius: 4, x: 0, y: 2)
                                
                                // Profile icon with navigation link
                                NavigationLink(destination: ProfileView()) {
                                    Image("profile")
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top, 10)
                        }
                        .padding(.horizontal)
                        .padding(.top, 30)
                        
                        // MARK: - Music and Lockdown and Calendar Buttons
                        HStack {
                            // Music Button
                            Button(action: {
                                showingSpotifyPopup = true
                            }) {
                                Image("music")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                            }
                            
                            // Lockdown Mode Button
                            Button(action: {
                                withAnimation {
                                    isLockdownActive.toggle()
                                    if isLockdownActive {
                                        showingLockdownPopup = true
                                        let generator = UIImpactFeedbackGenerator(style: .medium)
                                        generator.impactOccurred()
                                    } else {
                                        showingLockdownDeactivationPopup = true
                                        let generator = UINotificationFeedbackGenerator()
                                        generator.notificationOccurred(.success)
                                    }
                                }
                            }) {
                                Image(isLockdownActive ? "lock_on" : "lock_off")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                            }
                            
                            
                            
                            // Calendar Button
                            Button {
                                showingCalendarView.toggle()
                                print(showingCalendarView)
                            } label: {
                                Image("calendar")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                            }
                            
                        }
                        
                        // MARK: - Timer Display and Mission
                        // Inside the Timer Display and Mission Section
                        VStack {
                            ZStack {
                                // Timer Image
                                Image(imageStages[currentImageIndex])
                                    .resizable()
                                    .scaledToFit()
                                    .scaleEffect(x: 1, y: 1) // Ensures the image orientation is correct
                                    .frame(width: 220, height: 220)
                                
                                // Circular Progress Bar Background
                                Circle()
                                    .stroke(
                                        Color.gray.opacity(0.3),
                                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                                    )
                                    .frame(width: 260, height: 260)
                                
                                // Circular Progress Bar Foreground
                                Circle()
                                    .trim(from: 0, to: circleProgress)
                                    .stroke(
                                        Color(red: 126 / 255, green: 182 / 255, blue: 247 / 255),
                                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                                    )
                                    .rotationEffect(.degrees(-90)) // Start from the top
                                    .frame(width: 260, height: 260)
                                
                                // Draggable Knob
                                Circle()
                                    .fill(Color(red: 126 / 255, green: 182 / 255, blue: 247 / 255))
                                    .frame(width: 20, height: 20)
                                    .offset(y: -130) // Position knob at the top of the circle
                                    .rotationEffect(.degrees(Double(circleProgress) * 360)) // Rotate based on progress
                                    .gesture(
                                        DragGesture()
                                            .onChanged { value in
                                                updateProgress(from: value)
                                            }
                                    )
                            }
                            .padding(.bottom, 30)
                        }
                        
                        
                        
                        Button(action: {
                            withAnimation {
                                isEditingMission.toggle() // Toggles editing mode
                            }
                        }) {
                            ZStack {
                                GeometryReader { geometry in
                                    // Calculate the width of the text dynamically
                                    let textWidth = calculateTextWidth(text: missionName, font: UIFont(name: "Noteworthy", size: 16) ?? UIFont.systemFont(ofSize: 16))
                                    
                                    Image("mission_holder")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: max(textWidth + 20, 160), height: 160, alignment: .trailing) // Fix height and dynamically adjust width
                                        .clipped() // Ensure no overflow beyond bounds
                                        .padding(.top, 10) // Vertical spacing if needed
                                        .frame(maxWidth: .infinity, alignment: .leading) // Align to the left within the available space
                                    
                                    
                                }
                                .frame(height: 160) // Keep consistent height
                                
                                Text(missionName)
                                    .foregroundColor(.yellow)
                                    .font(.custom("Noteworthy", size: missionName.count > 20 ? 12 : 16)) // Adjust font size dynamically
                                    .fontWeight(.semibold)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2) // Restrict text to 2 lines
                                    .minimumScaleFactor(0.7) // Ensure text shrinks only up to 70% of the font size
                                    .padding(.horizontal, 10)
                                    .frame(maxWidth: 300, maxHeight: 80, alignment: .center) // Limit the text container size
                                
                                
                            }
                        }
                        .frame(height: 10)
                        .padding(.horizontal, 120)
                        if isEditingMission {
                            TextField("Enter mission name", text: $missionName)
                                .onChange(of: missionName) { _, _ in
                                    if missionName.count > 30 {
                                        missionName = String(missionName.prefix(30))
                                    }
                                }
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                            
                        }
                        
                        VStack(spacing: 0) {
                            
                            // MARK: - Timer Display with Tap to Edit
                              Text(timeString(from: remainingTime))
                                .font(.system(size: 48, weight: .bold, design: .rounded)) // Large, rounded font
                                .foregroundColor(Color(red: 33 / 255, green: 105 / 255, blue: 208 / 255)) // Custom blue color
                                .shadow(color: Color.black.opacity(0.3), radius: 4, x: 0, y: 2) // Subtle shadow for depth
                                .padding(.horizontal, 30)
                                .onTapGesture {
                                    showingTimePicker.toggle() // Opens time picker
                                }
                                .padding(.top,5)
                            
                            // MARK: - Start/Pause Timer Button and Mood Icon Button
                            HStack(spacing: 10) {
                                
                                // Mood Icon Button
                                Button(action: {
                                    showingMoodInput = true // Opens mood input modal
                                }) {
                                    Image("mood_icon")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                }
                                // Start/Pause Timer Button
                                Button(action: {
                                    if isTimerRunning {
                                        showingPauseConfirmation = true // Show confirmation popup
                                    } else {
                                        // Start the timer directly
                                        remainingTime = selectedMode == "Pomodoro Mode" ? pomodoroFocusTime * 60 : selectedMinutes * 60
                                        isTimerRunning = true
                                    }
                                }) {
                                    Image(isTimerRunning ? "pause_button" : "grow_button") // Use custom images
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                }

                            }
                            
                            // MARK: - Timer Mode Selection Buttons
                            timerModeSelectors
                            
                            Spacer()
                        }
                        .padding(.vertical)
                    }
                }
                .opacity(isMenuOpen ? 0.1 : 1)
                .navigationBarTitleDisplayMode(.inline)
                .sheet(isPresented: $showingTimePicker) {
                    ZStack {
                        Color(red: 250 / 255, green: 245 / 255, blue: 234 / 255)
                            .edgesIgnoringSafeArea(.all) // Background color for the sheet
                        
                        VStack {
                            Text("Select Time for \(selectedModeForPicker)")
                                .font(.headline)
                                .padding()
                            
                            if selectedModeForPicker == "Pomodoro Mode" {
                                HStack {
                                    // Focus Time Picker for Pomodoro Mode
                                    VStack {
                                        Text("Focus Time")
                                            .font(.headline)
                                        Picker("Select Focus Time", selection: $pomodoroFocusTime) {
                                            ForEach(10...60, id: \.self) { minute in
                                                Text("\(minute) minutes").tag(minute)
                                            }
                                        }
                                        .labelsHidden()
                                        .pickerStyle(WheelPickerStyle())
                                        .frame(height: 150)
                                    }

                                    // Break Time Picker for Pomodoro Mode
                                    VStack {
                                        Text("Break Time")
                                            .font(.headline)
                                        Picker("Select Break Time", selection: $pomodoroBreakTime) {
                                            ForEach(1...30, id: \.self) { minute in
                                                Text("\(minute) minutes").tag(minute)
                                            }
                                        }
                                        .labelsHidden()
                                        .pickerStyle(WheelPickerStyle())
                                        .frame(height: 150)
                                    }
                                }
                                .padding()
                            } else {
                                // Regular Mode Picker
                                Picker("Select Minutes", selection: $selectedMinutes) {
                                    ForEach(1...120, id: \.self) { minute in
                                        Text("\(minute) minutes").tag(minute)
                                    }
                                }
                                .labelsHidden()
                                .pickerStyle(WheelPickerStyle())
                                .frame(height: 150)
                            }

                            // Set Time Button
                            Button(action: {
                                remainingTime = selectedModeForPicker == "Pomodoro Mode" ? pomodoroFocusTime * 60 : selectedMinutes * 60
                                selectedMode = selectedModeForPicker
                                showingTimePicker = false
                            }) {
                                Text("Set Time")
                                    .font(.title2)
                                    .padding()
                                    .background(Color(red: 255 / 255, green: 184 / 255, blue: 195 / 255))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
                .sheet(isPresented: $showingMoodInput) {
                    MoodInputView(selectedMood: $selectedMood)
                        .presentationDetents([.height(330)])
                        .presentationBackground(.clear)
                }
                .sheet(isPresented: $showingCalendarView) {
                    StreakView()
                        .presentationDetents([
                            .custom(CustomDetent.self) // or .fraction(0.999)
                        ])
                        .presentationBackground(.clear)
                }
                
                
                // LOCKDOWN ON WINDOW
                if showingLockdownPopup {
                    ZStack {
                        Color.black.opacity(0.6)
                            .edgesIgnoringSafeArea(.all)

                        VStack(spacing: 20) {
                            Image("lock_on")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.red)

                            Text("Lockdown Mode Activated")
                                .font(.headline)
                                .foregroundColor(Color(red: 255 / 255, green: 184 / 255, blue: 195 / 255))
                                .font(.custom("Noteworthy", size: 16))
                                .fontWeight(.bold)

                            Text("Focus on your tasks. Distractions are locked away!")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .font(.custom("Noteworthy", size: 16))
                                .padding(.horizontal)
                                .foregroundColor(Color(red: 255 / 255, green: 184 / 255, blue: 195 / 255).opacity(0.8))

                            Button("Got it!") {
                                withAnimation {
                                    showingLockdownPopup = false
                                }
                            }
                            .padding()
                            .background(Color(red: 255 / 255, green: 184 / 255, blue: 195 / 255))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .font(.custom("Noteworthy", size: 16))
                            .fontWeight(.semibold)
                        }
                        .padding() //49/74/103
                        .background(Color(red: 49 / 255, green: 74 / 255, blue: 103 / 255).opacity(0.9))
                        .cornerRadius(20)
                        .shadow(radius: 10)
                        .transition(.opacity) // Smooth fade-out
                        .animation(.easeInOut, value: showingLockdownPopup)
                    }
                }
                // LOCKDOWN OFF WINDOW
                if showingLockdownDeactivationPopup {
                    ZStack {
                        Color.black.opacity(0.6) // Dimmed background
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                withAnimation {
                                    showingLockdownDeactivationPopup = false
                                }
                            }

                        VStack(spacing: 20) {
                            Image("lock_off")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                                .foregroundColor(.green)

                            Text("Lockdown Mode Deactivated")
                                .font(.headline)
                                .font(.custom("Noteworthy", size: 16))
                                .fontWeight(.bold)
                                .foregroundColor(Color(red: 126 / 255, green: 182 / 255, blue: 247 / 255))
                            

                            Text("Feel free to explore other tasks!")
                                .font(.custom("Noteworthy", size: 16))
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                                .foregroundColor(Color(red: 126 / 255, green: 182 / 255, blue: 247 / 255))

                            Button("Got it!") {
                                withAnimation {
                                    showingLockdownDeactivationPopup = false
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(red: 126 / 255, green: 182 / 255, blue: 247 / 255))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .font(.custom("Noteworthy", size: 16))
                            .fontWeight(.semibold)
                        }
                        .padding()
                        .background(Color(red: 79 / 255, green: 104 / 255, blue: 133 / 255).opacity(0.9))
                        .cornerRadius(20)
                        .shadow(radius: 10)
                        .frame(maxWidth: 300) // Ensures consistent size
                    }
                    .transition(.opacity) // Smooth fade-in/out
                    .animation(.easeInOut, value: showingLockdownDeactivationPopup)
                }

                // SPOTIFY WINDOW
                if showingSpotifyPopup {
                    ZStack {
                        Color.black.opacity(0.6) // Dimmed background
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                withAnimation {
                                    showingSpotifyPopup = false
                                }
                            }

                        VStack(spacing: 20) {
                            Image("spotify_logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)

                            Text("Connect to Spotify")
                                .font(.headline)
                                .foregroundColor(.green)
                                .font(.custom("Noteworthy", size: 16))
                                .fontWeight(.bold)
                            
                            Text("Play your favorite focus playlists from Spotify !")
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.green.opacity(0.8))
                                .padding(.horizontal)
                                .font(.custom("Noteworthy", size: 16))
                                .fontWeight(.semibold)

                            Button(action: {
                                connectToSpotify()
                            }) {
                                Text("Open Spotify")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .font(.custom("Noteworthy", size: 16))
                                    .fontWeight(.bold)
                            }
                            .padding(.horizontal)

                            Button("Dismiss") {
                                withAnimation {
                                    showingSpotifyPopup = false
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .foregroundColor(.green)
                            .cornerRadius(10)
                            .font(.custom("Noteworthy", size: 16))
                            .fontWeight(.semibold)
                        }
                        .padding()
                        .background(Color(red: 252 / 255, green: 245 / 255, blue: 234 / 255).opacity(0.9))
                        .cornerRadius(20)
                        .shadow(radius: 10)
                        .frame(maxWidth: 300) // Ensures consistent size
                    }
                    .transition(.opacity) // Smooth fade-in/out
                    .animation(.easeInOut, value: showingSpotifyPopup)
                }

                // Stop Timer Confirmation Popup
                if showingPauseConfirmation {
                    ZStack {
                        // Dimmed background
                        Color.black.opacity(0.6)
                            .edgesIgnoringSafeArea(.all)

                        VStack(spacing: 20) {
                            Image("mission_icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .padding(.top,20)

                            Text("Your pet believes in you!")
                                .font(.custom("Noteworthy", size: 16))
                                .fontWeight(.bold)
                                .foregroundColor(.white)

                            Text("Stopping now will reset your progress, but your pet believes in you to stay focused!")
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white.opacity(0.8))
                                .padding(.horizontal)
                                .font(.custom("Noteworthy", size: 16))
                                .fontWeight(.semibold)

                            HStack(spacing: 20) {
                                // Cancel Button
                                Button(action: {
                                    withAnimation {
                                        showingPauseConfirmation = false // Close popup
                                    }
                                }) {
                                    Text("Stay")
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(width: 120)
                                        .background(Color.green)
                                        .cornerRadius(10)
                                        .font(.custom("Noteworthy", size: 16))
                                        .fontWeight(.semibold)
                                }

                                // Confirm Button
                                Button(action: {
                                    withAnimation {
                                        // Reset timer and progress
                                        remainingTime = selectedMode == "Pomodoro Mode" ? pomodoroFocusTime * 60 : selectedMinutes * 60
                                        isTimerRunning = false // Ensure timer is stopped
                                        circleProgress = 0.0 // Reset progress bar
                                        currentImageIndex = 0 // Reset pet's growth
                                        showingPauseConfirmation = false // Close popup
                                        showFailedNotification = true    // Show failed mission window
                                    }
                                }) {
                                
                                    Text("Leave")
                                    .foregroundColor(Color(red: 235 / 255, green: 85 / 255, blue: 135 / 255))
                                    .padding()
                                    .frame(width: 120)
                                    .background(Color(red: 255 / 255, green: 184 / 255, blue: 195 / 255))
                                    .cornerRadius(10)
                                    .font(.custom("Noteworthy", size: 16))
                                    .fontWeight(.semibold)
                                }
                            }
                        }
                        .padding()
                        .background(Color(red: 235 / 255, green: 85 / 255, blue: 135 / 255).opacity(0.8))
                        .cornerRadius(20)
                        .shadow(radius: 10)
                        .frame(maxWidth: 300) // Ensures consistent size
                    }
                    .transition(.opacity) // Smooth fade-in/out
                    .animation(.easeInOut, value: showingPauseConfirmation)
                }
                


                // Reward Information Window
                if showCompletionNotification {
                    ZStack {
                        // Dimmed background
                        Color.black.opacity(0.6)
                            .edgesIgnoringSafeArea(.all)
                            .onTapGesture {
                                withAnimation {
                                    showCompletionNotification = false
                                }
                            }
                        
                        VStack(spacing: 20) {
                            // Reward Info Box
                            VStack(spacing: 15) {
                                
                                Text("Welcome Your New Pet!")
                                    .foregroundColor(Color.yellow)
                                    .fontWeight(.bold)
                                    .font(.custom("Noteworthy", size: 20))
                                
                                Image("pet_complete")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 200, height: 100)

                                    Text("Log your mood to claim your reward!")
                                        .foregroundColor(Color.yellow)
                                        .fontWeight(.bold)
                                        .font(.custom("Noteworthy", size: 16))
                                   
                                .frame(maxWidth: .infinity)
                                
                                // Mood Input Button
                                if !hasLoggedMood {
                                    Button(action: {
                                        showingMoodInput = true
                                    }) {
                                        Text("Log Mood")
                                            .foregroundColor(Color(red: 0 / 255, green: 140 / 255, blue: 89 / 255))
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .background(Color(red: 212 / 255, green: 249 / 255, blue: 204 / 255))
                                            .cornerRadius(12)
                                            .font(.custom("Noteworthy", size: 16))
                                           
                                    }
                                }
                                
                                // Collect Reward Button
                                Button(action: {
                                    if hasLoggedMood {
                                        withAnimation {
                                            showCompletionNotification = false
                                        }
                                    }
                                }) {
                                    HStack(spacing: 5) {
                                        Image("coin")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 30, height: 30)
                                        Text("50") // Number of coins earned
                                            .font(.custom("Noteworthy", size: 16))
                                            .foregroundColor(.yellow)
                                            .fontWeight(.heavy)
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(hasLoggedMood ? Color.yellow : Color.gray)
                                    .cornerRadius(12)
                                }
                                .disabled(!hasLoggedMood) // Disable the button until mood is logged

                            }
                            .padding()
                            .frame(width: 300, height: 400) // Adjust box size
                            .background(Color(red: 0 / 255, green: 140 / 255, blue: 89 / 255).opacity(0.9))
                            .cornerRadius(20)
                            .shadow(radius: 10)
                        }
                    }
                }

                // Mission Failed
                if showFailedNotification {
                    ZStack {
                        // Dimmed background
                        Color.black.opacity(0.6)
                            .edgesIgnoringSafeArea(.all)

                        VStack(spacing: 20) {
                            // Mission Failed Title
                            Text("Mission Failed")
                                .foregroundColor(Color(red: 245 / 255, green: 245 / 255, blue: 245 / 255))
                                .fontWeight(.bold)
                                .font(.custom("Noteworthy", size: 20))

                            // GIF Display (WebView for pet_rip.gif)
                            WebViewGIF(gifName: "pet_rip")
                                .frame(width: 150, height: 150)

                            // Mission Failed Message
                            Text("Your pet couldn't survive this time...")
                                .foregroundColor(Color(red: 245 / 255, green: 245 / 255, blue: 245 / 255))
                                .fontWeight(.bold)
                                .font(.custom("Noteworthy", size: 16))
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity)

                            // Retry Button
                            Button(action: {
                                withAnimation {
                                    showFailedNotification = false
                                    // Logic for retrying the mission
                                }
                            }) {
                                Text("Retry")
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color(red: 171 / 255, green: 48 / 255, blue: 255 / 255))
                                    .cornerRadius(12)
                                    .font(.custom("Noteworthy", size: 16))
                                    .fontWeight(.bold)
                            }

                            // Dismiss Button
                            Button(action: {
                                withAnimation {
                                    showFailedNotification = false
                                }
                            }) {
                                Text("Dismiss")
                                    .foregroundColor(Color(red: 51 / 255, green: 51 / 255, blue: 51 / 255))
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.gray)
                                    .cornerRadius(12)
                                    .font(.custom("Noteworthy", size: 16))
                                    .fontWeight(.bold)
                            }
                        }
                        .padding()
                        .frame(width: 300, height: 450)
                        .background(Color(red: 136 / 255, green: 77 / 255, blue: 179 / 255).opacity(0.9))
                        .cornerRadius(20)
                        .shadow(radius: 10)
                    }
                }


                // Zstack end here
            }
        }
        .onReceive(timer) { _ in
            if isTimerRunning && remainingTime > 0 {
                remainingTime -= 1
                updateProgressBar()
                updateImage()
            } else if remainingTime == 0 {
                // When the timer completes
                isTimerRunning = false // Stop the timer
                showCompletionNotification = true // Trigger the notification
                completionMessage = "Well done! Your pet is growing stronger!" // Set the message

                // Reward coins or progress
                userCoins += 5 // Reward the user with coins
            }
        }


    }
    
    
    
    struct CustomDetent: CustomPresentationDetent {
        static func height(in context: Context) -> CGFloat? {
            return context.maxDetentValue - 1
        }
    }
    
    var timerModeSelectors: some View {
        HStack(spacing: 30) {
            regularModeButton
            
            pomodoroModeButton
            
            moodModeButton
        }
        .padding()
        .cornerRadius(10)
    }
    
    var regularModeButton: some View {
        Button(action: {
            selectedModeForPicker = "Regular Mode"
            showingTimePicker = true
        }) {
            VStack {
                Image("regular_mode_icon")
                    .resizable()
                    .frame(width: 60, height: 60)
                Text("Regular")
                    .font(.caption)
                    .foregroundColor(selectedMode == "Regular Mode" ? .blue : .gray)
            }
        }
    }
    
    var pomodoroModeButton: some View {
        Button(action: {
            selectedModeForPicker = "Pomodoro Mode"
            showingTimePicker = true
        }) {
            VStack {
                Image("pomodoro_mode_icon")
                    .resizable()
                    .frame(width: 60, height: 60)
                Text("Pomodoro")
                    .font(.caption)
                    .foregroundColor(selectedMode == "Pomodoro Mode" ? .blue : .gray)
            }
        }
    }
    
    var moodModeButton: some View {
        Button(action: {
            selectedMode = "Mood Mode"
            remainingTime = 60 // Set a default time for Mood Mode
            isTimerRunning = false
        }) {
            VStack {
                Image("mood_mode_icon")
                    .resizable()
                    .frame(width: 60, height: 60)
                Text("Mood")
                    .font(.caption)
                    .foregroundColor(selectedMode == "Mood Mode" ? .blue : .gray)
            }
        }
    }

    struct SideMenuView: View {
        var body: some View {
            VStack(alignment: .leading, spacing: 20) {
                // Spacer to create space above the menu
                Spacer()
                .frame(height: 20) // Adjust this value to control the vertical position


                NavigationLink(destination: StoreView()) {
                    Text("LetGrow Store")
                        .font(.headline)
                        .padding(.top, 20)
                }
                
                NavigationLink(destination: SJSUStoreView()){
                    Text("School Store")
                        .font(.headline)
                        .padding(.top,20)
                }
                
                
                NavigationLink(destination: SignupView()) {
                    Text("Sign Up")
                        .font(.headline)
                        .padding(.top, 20)
                }
                
                Spacer()
            }
            .frame(maxWidth: 150)
            .padding(.top,40)
            .padding()
            .background(Color.white)
            .edgesIgnoringSafeArea(.all)
        }
        
    }
    // Helper function to calculate text width dynamically
    private func calculateTextWidth(text: String, font: UIFont) -> CGFloat {
        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let textSize = text.size(withAttributes: attributes)
        return textSize.width
    }
    // Spotify Connection Simulation
    func connectToSpotify() {
        // Add Spotify connection logic here
        isSpotifyConnected = true
        showingSpotifyPopup = false // Close pop-up after connection
    }

    func disconnectFromSpotify() {
        // Add Spotify disconnection logic here
        isSpotifyConnected = false
    }

    // MARK: - Helper Functions
        func timeString(from seconds: Int) -> String {
            let minutes = seconds / 60
            let seconds = seconds % 60
            return String(format: "%02d:%02d", minutes, seconds)
        }

    func updateImage() {
        let totalStages = imageStages.count
        let stageDuration = totalTime / totalStages // Time each stage lasts

        // Calculate the current stage index based on elapsed time
        let elapsedStages = (totalTime - remainingTime) / stageDuration

        // Ensure the index stays within bounds
        currentImageIndex = min(elapsedStages, totalStages - 1) // Last stage at completion
    }



    func updateProgressBar() {
        circleProgress = CGFloat(totalTime - remainingTime) / CGFloat(totalTime)
    }


    func updateProgress(from value: DragGesture.Value) {
        let center = CGPoint(x: 135, y: 135) // Center of the circle
        let vector = CGVector(dx: value.location.x - center.x, dy: value.location.y - center.y)
        let angle = atan2(vector.dy, vector.dx) + .pi / 2 // Calculate angle in radians
        let fixedAngle = angle < 0 ? angle + 2 * .pi : angle // Ensure angle is positive

        // Update circle progress (0 to 1)
        circleProgress = fixedAngle / (2 * .pi)

        // Update current image index based on circle progress
        let totalStages = imageStages.count
        let stageIndex = Int(circleProgress * CGFloat(totalStages))
        currentImageIndex = min(max(0, stageIndex), totalStages - 1) // Keep index within bounds
    }

    }

// MARK: - Mood Input View
struct MoodInputView: View {
    @Binding var selectedMood: String

    let moodImages = Array(["mood_1", "mood_2", "mood_3", "mood_4", "mood_5"].reversed())
    let moodNames = ["Supercharged", "Energetic", "Neutral", "Distracted", "Exhausted"]

    var body: some View {
        let halfSize = (moodImages.count / 2) + 1
        
        VStack(spacing: 40) {
            Spacer()
            moodRow(from: 0, to: halfSize)
            moodRow(from: halfSize, to: moodImages.count)
                .padding(.bottom)
        }
        .background(imageBackground)

    }
    
    var imageBackground: some View {
        Image("mood_back")
            .resizable()
            .scaledToFill()
            .frame(width: 400, height: 500, alignment: .top)
            .clipped()
    }
    
    func moodRow(from: Int, to: Int) -> some View {
        HStack {
            ForEach(from..<to, id: \.self) { index in
                buttonIcon(imageIndex: index)
            }
        }
        .frame(height: 50)
    }
    
    func buttonIcon(imageIndex: Int) -> some View {
        Button(action: {
            selectedMood = moodImages[imageIndex] // Update selected mood
        }) {
            ZStack {
                Image(moodImages[imageIndex]) // Mood image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .background {
                        Circle().fill(selectedMood == moodImages[imageIndex]
                          ? Color.green.opacity(0.3)
                          : Color.clear
                        )
                    }
                Text(moodNames[imageIndex])
                    .padding(.top, 80)
                    .font(.custom("Noteworthy", size: 16))
                    .fontWeight(.semibold)
            }
        }
    }
}

struct WebViewGIF: UIViewRepresentable {
    let gifName: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.isOpaque = false
        webView.backgroundColor = .clear
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        if let path = Bundle.main.path(forResource: gifName, ofType: "gif") {
            let url = URL(fileURLWithPath: path)
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
