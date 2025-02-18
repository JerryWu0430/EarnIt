//
//  AuthenticationViewModel.swift
//  ios
//
//  Created by Jerry Wu on 08/01/25.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift
import UserNotifications

enum AuthenticationState {
  case unauthenticated
  case authenticating
  case authenticated
  case pendingVerification
}

enum AuthenticationFlow {
  case splash
  case login
  case register
}

enum StudyMode: String {
    case focus = "Focus Mode"
    case balanced = "Balanced Mode"
    case reward = "Reward Mode"
    
    var timeLimit: Int {
        switch self {
        case .focus:
            return 10 // 25 minutes
        case .balanced:
            return 15 // 25 minutes
        case .reward:
            return 30 // 10 minutes
        }
    }
}

@MainActor
class AuthenticationViewModel: ObservableObject {
  @Published var email: String = ""
  @Published var password: String = ""
  @Published var confirmPassword: String = ""
  @Published var userName: String = ""
  @Published var selectedSubjects: [String] = []
  @Published var selectedMode: StudyMode = .focus // Default mode
  @Published var selectedApps: [String] = []
  @Published var notificationsEnabled: Bool = false
  @Published var screenTimeEnabled: Bool = false

  @Published var flow: AuthenticationFlow = .splash {
    didSet {
      print("Flow changed to: \(flow)")
    }
  }

  @Published var isValid: Bool  = false
  @Published var authenticationState: AuthenticationState = .unauthenticated
  @Published var errorMessage: String = ""
  @Published var user: User?
  @Published var displayName: String = ""
  @Published var isEmailVerified = false
  @Published var showOnboarding = false

  var userEmail: String {
    return user?.email ?? email
  }

  init() {
    print("Initial flow: \(flow)")
    registerAuthStateHandler()

    $flow
      .combineLatest($email, $password, $confirmPassword)
      .map { flow, email, password, confirmPassword in
        flow == .login
        ? !(email.isEmpty || password.isEmpty)
        : !(email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
      }
      .assign(to: &$isValid)

    self.user = Auth.auth().currentUser
    if self.user != nil {
      // Check onboarding status for existing users
      checkOnboardingStatus()
    }
  }

  private var authStateHandler: AuthStateDidChangeListenerHandle?

  func registerAuthStateHandler() {
    if authStateHandler == nil {
      authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
        self.user = user
        if let user = user {
          if user.isEmailVerified || user.providerData.contains(where: { $0.providerID == "google.com" }) {
            self.authenticationState = .authenticated
          } else if self.authenticationState != .pendingVerification {
            self.authenticationState = .authenticating
          }
        } else {
          self.authenticationState = .unauthenticated
        }
        self.displayName = user?.email ?? ""
      }
    }
  }

  func switchFlow() {
    flow = flow == .login ? .register : .login
    errorMessage = ""
  }

  private func wait() async {
    do {
      print("Wait")
      try await Task.sleep(nanoseconds: 1_000_000_000)
      print("Done")
    }
    catch { }
  }

  func reset() {
    //flow = .login
    email = ""
    password = ""
    confirmPassword = ""
  }

  func checkEmailVerification() async {
    print("📧 Checking email verification...")
    do {
      try await Auth.auth().currentUser?.reload()
      if Auth.auth().currentUser?.isEmailVerified == true {
        print("✅ Email is verified")
        await MainActor.run {
          isEmailVerified = true
          authenticationState = .authenticated
          print("⚠️ Setting showOnboarding to true in checkEmailVerification")
          showOnboarding = true  // This might be the issue!
        }
      } else {
        print("❌ Email is not verified")
      }
    } catch {
      print("❌ Error reloading user: \(error)")
    }
  }

  func signIn(email: String, password: String) async -> Bool {
    do {
      let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
      self.user = authResult.user
      // Check if user needs onboarding
      checkOnboardingStatus()
      return true
    } catch {
      print(error)
      return false
    }
  }

  func signUp(email: String, password: String) async -> Bool {
    do {
      let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
      self.user = authResult.user
      // New users always need onboarding
      self.showOnboarding = true
      return true
    } catch {
      print(error)
      return false
    }
  }

  func signOut() {
    print("🚪 Starting sign out process...")
    do {
      try Auth.auth().signOut()
      print("✅ Firebase sign out successful")
      self.user = nil
      print("📱 Current UserDefaults username: \(UserDefaults.standard.string(forKey: "userName") ?? "nil")")
      self.showOnboarding = false  // Reset onboarding status
      self.authenticationState = .unauthenticated
      self.userName = ""  // Clear the temporary user name
      print("🎯 Final state - showOnboarding: \(showOnboarding), authState: \(authenticationState)")
    } catch {
      print("❌ Sign out error: \(error)")
    }
  }

  func checkOnboardingStatus() {
    print("🔍 Checking onboarding status...")
    // Load the user name if it exists
    loadUserName()
    
    print("📝 Current userName: \(userName)")
    print("🔑 UserDefaults userName: \(UserDefaults.standard.string(forKey: "userName") ?? "nil")")
    
    // Check if the user has completed onboarding by checking UserDefaults
    if let savedName = UserDefaults.standard.string(forKey: "userName") {
        print("✅ Found saved username: \(savedName), setting showOnboarding to false")
        self.showOnboarding = false
    } else {
        print("❌ No saved username found, setting showOnboarding to true")
        self.showOnboarding = true
    }
    print("🎯 Final showOnboarding state: \(showOnboarding)")
  }

  func updateUserName(_ name: String) {
    print("📝 Updating username to: \(name)")
    self.userName = name
    self.displayName = name  // Update display name to show in UI
    
    // Store the name in UserDefaults for persistence
    UserDefaults.standard.set(name, forKey: "userName")
    print("💾 Saved username to UserDefaults")
  }

  func loadUserName() {
    print("📥 Loading username from UserDefaults...")
    if let savedName = UserDefaults.standard.string(forKey: "userName") {
      print("✅ Found saved username: \(savedName)")
      self.userName = savedName
      self.displayName = savedName
    } else {
      print("❌ No username found in UserDefaults")
    }
  }

  func updateUserProfile(name: String? = nil, subjects: [String]? = nil, mode: StudyMode? = nil, apps: [String]? = nil, notifications: Bool? = nil, screenTime: Bool? = nil) {
    if let name = name {
      updateUserName(name)
    }
    if let subjects = subjects {
      selectedSubjects = subjects
      UserDefaults.standard.set(subjects, forKey: "userSubjects")
    }
    if let mode = mode {
      selectedMode = mode
      UserDefaults.standard.set(mode.rawValue, forKey: "userMode")
    }
    if let apps = apps {
      selectedApps = apps
      UserDefaults.standard.set(apps, forKey: "userApps")
    }
    if let notifications = notifications {
      notificationsEnabled = notifications
      UserDefaults.standard.set(notifications, forKey: "notificationsEnabled")
    }
    if let screenTime = screenTime {
      screenTimeEnabled = screenTime
      UserDefaults.standard.set(screenTime, forKey: "screenTimeEnabled")
    }
  }

  func loadUserProfile() {
    loadUserName()
    selectedSubjects = UserDefaults.standard.stringArray(forKey: "userSubjects") ?? []
    if let savedMode = UserDefaults.standard.string(forKey: "userMode"),
       let mode = StudyMode(rawValue: savedMode) {
      selectedMode = mode
    }
    selectedApps = UserDefaults.standard.stringArray(forKey: "userApps") ?? []
    notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
    screenTimeEnabled = UserDefaults.standard.bool(forKey: "screenTimeEnabled")
  }

  func requestNotificationPermission() async -> Bool {
    let center = UNUserNotificationCenter.current()
    do {
      let settings = await center.notificationSettings()
      if settings.authorizationStatus == .authorized {
        return true
      }
      let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
      await MainActor.run {
        updateUserProfile(notifications: granted)
      }
      return granted
    } catch {
      print("❌ Notification permission error: \(error)")
      return false
    }
  }
}

extension AuthenticationViewModel {
  func signInWithEmailPassword() async -> Bool {
    print("🔑 Starting email/password sign in...")
    authenticationState = .authenticating
    do {
        let result = try await Auth.auth().signIn(withEmail: self.email, password: self.password)
        self.user = result.user
        self.email = result.user.email ?? ""
        authenticationState = .authenticated
        print("✅ Sign in successful, checking onboarding status...")
        checkOnboardingStatus()
        print("🎯 Final state after sign in - showOnboarding: \(showOnboarding), authState: \(authenticationState)")
        return true
    }
    catch {
        print("❌ Sign in error: \(error)")
        errorMessage = error.localizedDescription
        authenticationState = .unauthenticated
        return false
    }
  }

  func signUpWithEmailPassword() async -> Bool {
    authenticationState = .authenticating
    do {
      let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
      self.user = authResult.user
      try await authResult.user.sendEmailVerification()
      // Set state to pendingVerification
      self.authenticationState = .pendingVerification
      return true
    } catch {
      print(error)
      errorMessage = error.localizedDescription
      authenticationState = .unauthenticated
      return false
    }
  }

  func deleteAccount() async -> Bool {
    do {
      try await user?.delete()
      return true
    }
    catch {
      errorMessage = error.localizedDescription
      return false
    }
  }
}

enum AuthenticationError: Error {
  case tokenError(message: String)
}

extension AuthenticationViewModel {
  func signInWithGoogle() async -> Bool {
    authenticationState = .authenticating  // Set state to authenticating at start
    
    guard let clientID = FirebaseApp.app()?.options.clientID else {
        print("Error: No client ID found in Firebase configuration")
        authenticationState = .unauthenticated
        errorMessage = "Firebase configuration error"
        return false
    }
    
    let config = GIDConfiguration(clientID: clientID)
    GIDSignIn.sharedInstance.configuration = config

    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let window = windowScene.windows.first,
          let rootViewController = window.rootViewController else {
        print("Error: No root view controller found")
        authenticationState = .unauthenticated
        errorMessage = "Internal error: Cannot present sign-in screen"
        return false
    }

    do {
        print("Starting Google sign in flow...")
        let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
        print("Got Google authentication response")
        
        guard let idToken = userAuthentication.user.idToken?.tokenString else {
            print("Error: ID token missing from Google response")
            throw AuthenticationError.tokenError(message: "ID token missing")
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                     accessToken: userAuthentication.user.accessToken.tokenString)
        
        print("Authenticating with Firebase...")
        let result = try await Auth.auth().signIn(with: credential)
        print("Successfully signed in with Firebase")
        
        await MainActor.run {
            self.user = result.user
            self.email = result.user.email ?? ""
            self.displayName = result.user.displayName ?? ""
            self.authenticationState = .authenticated
            self.errorMessage = ""
            checkOnboardingStatus()
        }
        return true
    } catch {
        print("Google sign in error: \(error)")
        await MainActor.run {
            self.errorMessage = error.localizedDescription
            self.authenticationState = .unauthenticated
        }
        return false
    }
  }
}

extension AuthenticationViewModel {
  func resetPassword() async -> Bool {
    do {
      try await Auth.auth().sendPasswordReset(withEmail: email)
      errorMessage = "Password reset email sent. Please check your inbox."
      return true
    } catch {
      print(error)
      errorMessage = error.localizedDescription
      return false
    }
  }
}