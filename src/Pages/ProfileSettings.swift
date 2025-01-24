import SwiftUI

struct ProfileSettings: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    @State private var isEditingName = false
    @State private var isEditingSubjects = false
    @State private var isEditingMode = false
    @State private var tempName = ""
    @State private var tempSubjects: [String] = []
    @State private var tempMode = ""
    
    private let subjects = ["Maths", "Biology", "Physics", "Chemistry"]
    private let modes = ["Focus Mode", "Balanced Mode", "Reward Mode"]
    
    var body: some View {
        Form {
            Section(header: Text("Personal Information")) {
                if isEditingName {
                    TextField("Name", text: $tempName)
                        .onSubmit {
                            if !tempName.isEmpty {
                                viewModel.updateUserProfile(name: tempName)
                            }
                            isEditingName = false
                        }
                } else {
                    HStack {
                        Text("Name")
                        Spacer()
                        Text(viewModel.userName)
                            .foregroundColor(.gray)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        tempName = viewModel.userName
                        isEditingName = true
                    }
                }
                
                HStack {
                    Text("Email")
                    Spacer()
                    Text(viewModel.userEmail)
                        .foregroundColor(.gray)
                }
            }
            
            Section(header: Text("Study Preferences")) {
                if isEditingSubjects {
                    ForEach(subjects, id: \.self) { subject in
                        Toggle(subject, isOn: Binding(
                            get: { tempSubjects.contains(subject) },
                            set: { isSelected in
                                if isSelected {
                                    tempSubjects.append(subject)
                                } else {
                                    tempSubjects.removeAll { $0 == subject }
                                }
                            }
                        ))
                    }
                    Button("Save") {
                        viewModel.updateUserProfile(subjects: tempSubjects)
                        isEditingSubjects = false
                    }
                } else {
                    HStack {
                        Text("Subjects")
                        Spacer()
                        Text(viewModel.selectedSubjects.isEmpty ? "None" : viewModel.selectedSubjects.joined(separator: ", "))
                            .foregroundColor(.gray)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        tempSubjects = viewModel.selectedSubjects
                        isEditingSubjects = true
                    }
                }
                
                if isEditingMode {
                    Picker("Mode", selection: $tempMode) {
                        ForEach(modes, id: \.self) { mode in
                            Text(mode).tag(mode)
                        }
                    }
                    .pickerStyle(.wheel)
                    .onAppear {
                        tempMode = viewModel.selectedMode
                    }
                    Button("Save") {
                        viewModel.updateUserProfile(mode: tempMode)
                        isEditingMode = false
                    }
                } else {
                    HStack {
                        Text("Study Mode")
                        Spacer()
                        Text(viewModel.selectedMode)
                            .foregroundColor(.gray)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        isEditingMode = true
                    }
                }
            }
            
            Section(header: Text("Connected Apps")) {
                if viewModel.selectedApps.isEmpty {
                    Text("No apps connected")
                        .foregroundColor(.gray)
                } else {
                    ForEach(viewModel.selectedApps, id: \.self) { app in
                        Text(app)
                    }
                }
                
                Button(action: {
                    // This will be implemented in a separate view
                    // For now, just add some example apps
                    viewModel.updateUserProfile(apps: ["Instagram", "TikTok", "YouTube"])
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Apps")
                    }
                }
            }
        }
        .navigationTitle("Profile Settings")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: { dismiss() }) {
            CustomButton(buttonType: .arrow, arrowDirection: .left, variant: .small)
        })
        .onAppear {
            viewModel.loadUserProfile()
        }
    }
}

#Preview {
    NavigationView {
        ProfileSettings()
            .environmentObject(AuthenticationViewModel())
    }
} 