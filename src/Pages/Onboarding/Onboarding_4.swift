//
//  Onboarding_2.swift
//  ios
//
//  Created by Teodor Calin on 18/11/24.
//

import SwiftUI
import FamilyControls
import ManagedSettings
import DeviceActivity

struct Onboarding_4: View {
    @State var name: String = ""
    @Binding var currentStep: Int
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @State private var showingAppSelection = false
    @StateObject private var model = TimeLimitModel.shared
    
    var body: some View {
        VStack {
            // Header Section
            HeaderSection()
            
            // Title Section
            Text("Select Your Apps\n")
                .multilineTextAlignment(.center)
                .font(.title3)
                .fontWeight(.bold)
                .padding(.top)
                .foregroundStyle(.white)
            
            // Apps List Section
            AppListSection(model: model)
            
            // Selection Button
            SelectionButton(showingAppSelection: $showingAppSelection, model: model)
            
            Spacer()
            
            // Navigation Section
            NavigationSection(currentStep: $currentStep)
        }
        .background(Color.earnitAccent)
        .onAppear {
            Task {
                try? await AuthorizationCenter.shared.requestAuthorization(for: .individual)
            }
        }
    }
}

// Break down into smaller components
private struct HeaderSection: View {
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 302, height: 302)
                .foregroundStyle(Color.black.opacity(0.2))
            VStack {
                Spacer()
                Image("o4")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .frame(width: 302, height: 302)
        }
        .padding(.top, 100)
    }
}

private struct AppListSection: View {
    @ObservedObject var model: TimeLimitModel
    
    var body: some View {
        ScrollView {
            if !model.selectionToDiscourage.applicationTokens.isEmpty {
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
                    .frame(maxHeight: 150)
                    .background(Color.black.opacity(0.2))
                    .cornerRadius(10)
            }
        }
    }
}

private struct SelectionButton: View {
    @Binding var showingAppSelection: Bool
    @ObservedObject var model: TimeLimitModel
    
    var body: some View {
        Button(action: {
            showingAppSelection = true
        }) {
            CustomButton(buttonType: .full, text: "Select Apps to Monitor", invertedColor: true)
        }
        .padding([.horizontal, .top])
        .familyActivityPicker(isPresented: $showingAppSelection, selection: $model.selectionToDiscourage)
    }
}

private struct NavigationSection: View {
    @Binding var currentStep: Int
    
    var body: some View {
        HStack {
            Paginations(totalCount: 5, currentIndex: .constant(3), paginationType: .onboarding, invertedColor: true)
            Spacer()
            Button(action: { currentStep += 1 }) {
                CustomButton(buttonType: .arrow, arrowDirection: .right, invertedColor: true)
            }
        }
        .padding(.bottom)
        .padding(.horizontal)
    }
}

#Preview {
    Onboarding_4(currentStep: .constant(3))
        .environmentObject(AuthenticationViewModel())
}
