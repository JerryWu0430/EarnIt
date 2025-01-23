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

enum AuthenticationState {
  case unauthenticated
  case authenticating
  case authenticated
}

enum AuthenticationFlow {
  case splash
  case login
  case register
}

@MainActor
class AuthenticationViewModel: ObservableObject {
  @Published var email: String = ""
  @Published var password: String = ""
  @Published var confirmPassword: String = ""
  @Published var userName: String = ""

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
        self.authenticationState = user == nil ? .unauthenticated : .authenticated
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
    do {
      try await Auth.auth().currentUser?.reload()
      if Auth.auth().currentUser?.isEmailVerified == true {
        await MainActor.run {
          isEmailVerified = true
        }
      }
    } catch {
      print("Error reloading user: \(error)")
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
    do {
      try Auth.auth().signOut()
      self.user = nil
      self.showOnboarding = false  // Reset onboarding status
      self.authenticationState = .unauthenticated
      self.userName = ""  // Clear the user name
      UserDefaults.standard.removeObject(forKey: "userName")  // Clear stored name
    } catch {
      print(error)
    }
  }

  func checkOnboardingStatus() {
    // Load the user name if it exists
    loadUserName()
    
    // TODO: Replace with actual check from your backend/Firestore
    // For now, we'll assume all users need onboarding if they don't have a name
    self.showOnboarding = userName.isEmpty
  }

  func updateUserName(_ name: String) {
    self.userName = name
    self.displayName = name  // Update display name to show in UI
    
    // Store the name in UserDefaults for persistence
    UserDefaults.standard.set(name, forKey: "userName")
  }

  func loadUserName() {
    if let savedName = UserDefaults.standard.string(forKey: "userName") {
      self.userName = savedName
      self.displayName = savedName
    }
  }
}

extension AuthenticationViewModel {
  func signInWithEmailPassword() async -> Bool {
    authenticationState = .authenticating
    do {
        try await Auth.auth().signIn(withEmail: self.email, password: self.password)
        self.user = Auth.auth().currentUser
        authenticationState = .authenticated
        checkOnboardingStatus()
        print("User signed in with email/password. State: \(authenticationState)")
        return true
    }
    catch {
        print(error)
        errorMessage = error.localizedDescription
        authenticationState = .unauthenticated
        return false
    }
  }

  func signUpWithEmailPassword() async -> Bool {
    authenticationState = .authenticating
    do {
      let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
      try await authResult.user.sendEmailVerification()
      authenticationState = .authenticated
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
    guard let clientID = FirebaseApp.app()?.options.clientID else {
        fatalError("No client ID found in Firebase configuration")
    }
    let config = GIDConfiguration(clientID: clientID)
    GIDSignIn.sharedInstance.configuration = config

    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let window = windowScene.windows.first,
          let rootViewController = window.rootViewController else {
        print("There is no root view controller!")
        return false
    }

    do {
        authenticationState = .authenticating
        let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)

        let user = userAuthentication.user
        guard let idToken = user.idToken else { throw AuthenticationError.tokenError(message: "ID token missing") }
        let accessToken = user.accessToken

        let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                   accessToken: accessToken.tokenString)

        let result = try await Auth.auth().signIn(with: credential)
        await MainActor.run {
            self.user = result.user
            self.email = result.user.email ?? ""
            self.displayName = result.user.displayName ?? ""
            self.authenticationState = .authenticated
            self.errorMessage = ""
            checkOnboardingStatus()
        }
        return true
    }
    catch {
        print(error.localizedDescription)
        self.errorMessage = error.localizedDescription
        authenticationState = .unauthenticated
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