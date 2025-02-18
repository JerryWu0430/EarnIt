import SwiftUI
import FamilyControls
import ManagedSettings
import DeviceActivity

// Or if AuthenticationViewModel is in the same module
// import "Auth/AuthenticationViewModel"

struct ProfileSettings: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Environment(\.dismiss) var dismiss
    @StateObject private var model = TimeLimitModel.shared
    @State private var showingAppSelection = false
    
    var body: some View {
        Form {
            // Personal Information Section
            PersonalInfoSection(viewModel: viewModel)
            
            // Study Preferences Section
            StudyPreferencesSection(viewModel: viewModel)
            
            // Connected Apps Section
            ConnectedAppsSection(model: model, showingAppSelection: $showingAppSelection)
        }
        .navigationTitle("Profile Settings")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton(dismiss: dismiss))
        .onAppear {
            viewModel.loadUserProfile()
            Task {
                try? await AuthorizationCenter.shared.requestAuthorization(for: .individual)
            }
        }
    }
}

private struct BackButton: View {
    let dismiss: DismissAction
    
    var body: some View {
        Button(action: { dismiss() }) {
            CustomButton(buttonType: .arrow, arrowDirection: .left, variant: .small)
        }
    }
}

private struct PersonalInfoSection: View {
    @ObservedObject var viewModel: AuthenticationViewModel
    @State private var isEditingName = false
    @State private var tempName = ""
    
    var body: some View {
        Section(header: Text("Personal Information")) {
            NameField(
                isEditing: $isEditingName,
                tempName: $tempName,
                userName: viewModel.userName,
                updateName: { viewModel.updateUserProfile(name: tempName) }
            )
            
            EmailField(userEmail: viewModel.userEmail)
        }
    }
}

private struct NameField: View {
    @Binding var isEditing: Bool
    @Binding var tempName: String
    let userName: String
    let updateName: () -> Void
    
    var body: some View {
        if isEditing {
            TextField("Name", text: $tempName)
                .onSubmit {
                    if !tempName.isEmpty {
                        updateName()
                    }
                    isEditing = false
                }
        } else {
            HStack {
                Text("Name")
                Spacer()
                Text(userName)
                    .foregroundColor(.gray)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                tempName = userName
                isEditing = true
            }
        }
    }
}

private struct EmailField: View {
    let userEmail: String
    
    var body: some View {
        HStack {
            Text("Email")
            Spacer()
            Text(userEmail)
                .foregroundColor(.gray)
        }
    }
}

private struct StudyPreferencesSection: View {
    @ObservedObject var viewModel: AuthenticationViewModel
    @State private var isEditingSubjects = false
    @State private var isEditingMode = false
    @State private var tempSubjects: [String] = []
    @State private var tempMode = ""
    
    private let subjects = ["Maths", "Biology", "Physics", "Chemistry"]
    private let modes = ["Focus Mode", "Balanced Mode", "Reward Mode"]
    
    var body: some View {
        Section(header: Text("Study Preferences")) {
            SubjectsField(
                isEditing: $isEditingSubjects,
                tempSubjects: $tempSubjects,
                subjects: subjects,
                selectedSubjects: viewModel.selectedSubjects,
                updateSubjects: { viewModel.updateUserProfile(subjects: tempSubjects) }
            )
            
            StudyModeField(
                isEditing: $isEditingMode,
                tempMode: $tempMode,
                modes: modes,
                selectedMode: viewModel.selectedMode,
                updateMode: { viewModel.updateUserProfile(mode: tempMode) }
            )
        }
    }
}

private struct SubjectsField: View {
    @Binding var isEditing: Bool
    @Binding var tempSubjects: [String]
    let subjects: [String]
    let selectedSubjects: [String]
    let updateSubjects: () -> Void
    
    var body: some View {
        if isEditing {
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
                updateSubjects()
                isEditing = false
            }
        } else {
            HStack {
                Text("Subjects")
                Spacer()
                Text(selectedSubjects.isEmpty ? "None" : selectedSubjects.joined(separator: ", "))
                    .foregroundColor(.gray)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                tempSubjects = selectedSubjects
                isEditing = true
            }
        }
    }
}

private struct StudyModeField: View {
    @Binding var isEditing: Bool
    @Binding var tempMode: String
    let modes: [String]
    let selectedMode: String
    let updateMode: () -> Void
    
    var body: some View {
        if isEditing {
            Picker("Mode", selection: $tempMode) {
                ForEach(modes, id: \.self) { mode in
                    Text(mode).tag(mode)
                }
            }
            .pickerStyle(.wheel)
            .onAppear {
                tempMode = selectedMode
            }
            Button("Save") {
                updateMode()
                isEditing = false
            }
        } else {
            HStack {
                Text("Study Mode")
                Spacer()
                Text(selectedMode)
                    .foregroundColor(.gray)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                tempMode = selectedMode
                isEditing = true
            }
        }
    }
}

private struct ConnectedAppsSection: View {
    @ObservedObject var model: TimeLimitModel
    @Binding var showingAppSelection: Bool
    
    var body: some View {
        Section(header: Text("Connected Apps")) {
            if model.selectionToDiscourage.applicationTokens.isEmpty {
                Text("No apps connected")
                    .foregroundColor(.gray)
            } else {
                let filter = DeviceActivityFilter(
                    segment: .daily(
                        during: Calendar.current.dateInterval(of: .day, for: .now)!
                    ),
                    users: .all,
                    devices: .init([.iPhone, .iPad]),
                    applications: model.selectionToDiscourage.applicationTokens,
                    categories: model.selectionToDiscourage.categoryTokens,
                    webDomains: model.selectionToDiscourage.webDomainTokens
                )
                
                let context = DeviceActivityReport.Context(rawValue: "Total Activity")
                
                DeviceActivityReport(context, filter: filter)
                    .frame(height: 150)
            }
            
            AddAppsButton(showingAppSelection: $showingAppSelection, model: model)
            
        }
    }
}

private struct AppList: View {
    let tokens: [ApplicationToken]
    
    var body: some View {
        ForEach(tokens, id: \.self) { token in
            HStack {
                Image(systemName: "app.fill")
                    .foregroundColor(.blue)
                Text("App Selected")
                Spacer()
            }
            .padding(.vertical, 4)
        }
    }
}

private struct AddAppsButton: View {
    @Binding var showingAppSelection: Bool
    @ObservedObject var model: TimeLimitModel
    
    var body: some View {
        Button(action: {
            showingAppSelection = true
        }) {
            HStack {
                Image(systemName: "plus.circle.fill")
                Text("Add Apps")
            }
        }
        .familyActivityPicker(isPresented: $showingAppSelection, selection: $model.selectionToDiscourage)
    }
}

#Preview {
    NavigationView {
        ProfileSettings()
            .environmentObject(AuthenticationViewModel())
    }
} 