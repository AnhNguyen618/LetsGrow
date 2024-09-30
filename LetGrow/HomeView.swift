import SwiftUI

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

    
    // Array of images for the timer
    let imageStages = ["egg_timer", "egg_cracking", "half_egg", "pet_crack", "pet_egg", "pet_done"]
    // Timer that updates every second
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationView {
            ZStack {
                // Background image for the home screen
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all) // Extends image to cover the entire screen
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
                                Text("100") // Replace "100" with your dynamic coin count variable
                                    .font(.system(size: 24, weight: .bold, design: .rounded)) // Bigger, bolder font
                                    .foregroundColor(.yellow) // Yellow text
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        Color.white.opacity(0.7) // White background with 70% opacity
                                    )
                                    .cornerRadius(12) // Rounded edges for a polished look
                                    .shadow(color: Color.gray.opacity(0.3), radius: 4, x: 0, y: 2) // Subtle shadow for highlighting

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
                        .padding(.top, 10)

                        // MARK: - Music and Calendar Buttons
                        HStack {
                            // Music Button
                            Button(action: {
                                // Action for music
                            }) {
                                Image("music")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                            }
                            // Lockdown Mode Button
                            Button(action: {
                                // Toggle lockdown mode
                                isLockdownActive.toggle()
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
                            Text(missionName)
                                .foregroundColor(.yellow)
                                .font(.custom("Noteworthy", size: 16)) // Font size
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .lineLimit(2) // Limit to 2 lines
                                .minimumScaleFactor(300) // Shrinks the font size down
                                .padding(.horizontal, 1) // Minimize padding
                                .padding(.bottom, 15) // Adjust bottom padding
                                .frame(width: 400, height: 160)
                                .background(
                                    Image("mission_holder")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: CGFloat(missionName.count), height: 160)
                                )
                        }
                        .frame(height: 20)


                        // Editable Text Field for Mission Name
                        if isEditingMission {
                            TextField("Enter new mission name", text: $missionName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding()
                        }

                        // MARK: - Timer Display with Tap to Edit
                        Text(timeString(from: remainingTime))
                            .font(.largeTitle)
                            .foregroundColor(Color(red: 33 / 255, green: 105 / 255, blue: 208 / 255))
                            .onTapGesture {
                                showingTimePicker.toggle() // Opens time picker
                            }
                        // MARK: - Start/Pause Timer Button and Mood Icon Button
                        HStack(spacing: 10) {
                            
                            // Mood Icon Button
                            Button(action: {
                                showingMoodInput = true // Opens mood input modal
                            }) {
                                Image("mood_icon") // Replace with your mood icon
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                            }
                            // Start/Pause Timer Button
                            Button(action: {
                                if !isTimerRunning {
                                    // Set time based on selected mode
                                    remainingTime = selectedMode == "Pomodoro Mode" ? pomodoroFocusTime * 60 : selectedMinutes * 60
                                }
                                isTimerRunning.toggle() // Toggles timer state
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

            }
        }
        .onReceive(timer) { _ in
            if isTimerRunning && remainingTime > 0 {
                remainingTime -= 1
                updateProgressBar()
                updateImage()
            } else if remainingTime == 0 && selectedMode == "Pomodoro Mode" {
                remainingTime = isFocusTime ? pomodoroBreakTime * 60 : pomodoroFocusTime * 60
                isFocusTime.toggle()
                updateProgressBar()
                updateImage()
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
                Button("Home") { /* Action */ }
                .font(.headline)
                .padding(.top, 50)
                
                Button("Tasks") { /* Action */ }
                .font(.headline)
                .padding(.top, 20)
                                               
                Button("LetGrow Store") { /* Action */ }
                .font(.headline)
                .padding(.top, 20)
                                               
                 Button("School Store") { /* Action */ }
                 .font(.headline)
                 .padding(.top, 20)
                                               
                Button("Setting") { /* Action */ }
                 .font(.headline)
                 .padding(.top, 20)
                Spacer()
            }
            .frame(maxWidth: 150)
            .padding()
            .background(Color.white)
            .edgesIgnoringSafeArea(.all)
        }
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
