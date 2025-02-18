//
//  RestrictionUIView.swift
//  DeviceMonitorExtension
//
//  Created by Gabriel Bor on 04/09/2024.
//

import SwiftUI
import FamilyControls

struct RestrictionUIView: View {
    
    @StateObject var model = TimeLimitModel.shared
    @State var isPresented = false
    
    var body: some View {
        VStack(spacing: 40) {
            Button {
                isPresented = true
            } label: {
                CustomButton(buttonType: .full, text: "Select Apps to Limit", invertedColor: false)
            }
            .familyActivityPicker(isPresented: $isPresented, selection: $model.selectionToDiscourage)
        

            
            Toggle("Restrict App(s)", isOn: $model.isMonitoring)
                .foregroundColor(.accentColor)
                .onChange(of: model.isMonitoring, { oldValue, newValue in
                    model.isMonitoring = newValue
                    
                    if newValue {
                        model.initiateMonitoring(timeLimit: PublicVariable.timeLimit)
                        
                    } else {
                        model.stopMonitoring()
                    }
                })
                .padding()

            Button("Block the apps") {
                ManagedSettingsStoreHelper.shared.startApplicationsShielding()
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        
        .background(Color(red: 0.984313725490196, green: 0.9294117647058824, blue: 0.8470588235294118))
    }
}

#Preview {
    RestrictionUIView()
}
