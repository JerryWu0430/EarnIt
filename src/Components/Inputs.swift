//
//  Inputs.swift
//  ios
//
//  Created by Teodor Calin on 13/11/24.
//

import SwiftUI

struct CustomTextInput: View {
    @Binding var text: String
    @FocusState private var isFocused: Bool
    @State private var isPasswordVisible: Bool = false
    var label: String
    var protected: Bool = false
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 10)
                .stroke(isFocused ? Color.blue : Color.gray, lineWidth: 0.5)
                .frame(height: 50)
            
            if text.isEmpty && !isFocused {
                Text(label)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 10)
                    .background(Color.white)
                    .offset(x: 10, y: -25)
            }
            
            HStack {
                if protected {
                    if isPasswordVisible {
                        TextField("", text: $text)
                            .padding(.horizontal, 10)
                            .frame(height: 50)
                            .focused($isFocused)
                    } else {
                        SecureField("", text: $text)
                            .padding(.horizontal, 10)
                            .frame(height: 50)
                            .focused($isFocused)
                    }
                    
                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 10)
                } else {
                    TextField("", text: $text)
                        .padding(.horizontal, 10)
                        .frame(height: 50)
                        .focused($isFocused)
                }
            }
        }
        .padding(.horizontal)
    }//TODO: add transition
}

struct PinInput: View {
    @Binding var pin: [String]
    @FocusState private var focusedField: Int?
    
    var body: some View {
        HStack(spacing: 15) {
            ForEach(0..<4, id: \.self) { index in
                ZStack {
                    
                    
                    if !pin[index].isEmpty {
                        Circle()
                            .stroke(Color.earnitAccent, lineWidth: 1)
                            .frame(width: 50, height: 50)
                        
                        Circle()
                            .fill(Color.earnitAccent)
                            .frame(width: 20, height: 20)
                    }
                    
                    else{
                        Circle()
                            .stroke(Color.gray, lineWidth: 1)
                            .frame(width: 50, height: 50)
                    }
                    
                    TextField("", text: $pin[index])
                        .frame(width: 50, height: 50)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .focused($focusedField, equals: index)
                        .opacity(0) // Hide the text field
                        .onChange(of: pin[index]) { newValue in
                            if newValue.count == 1 {
                                if index < 3 {
                                    focusedField = index + 1
                                } else {
                                    focusedField = nil
                                }
                            } else if newValue.count > 1 {
                                pin[index] = String(newValue.prefix(1))
                            }
                        }
                }
            }
        }
        .padding()
        .onAppear {
            focusedField = 0
        }
    }
}

struct OptionSelector: View {
    @Binding var selectedOption: String
    var options: [String]
    var label: String
    var whiteBackground: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.caption)
                .foregroundColor(whiteBackground ? .white : .gray)
                .padding(.horizontal, 10)
                .fontWeight(.bold)
            
            Picker(selection: $selectedOption, label: Text("")) {
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding(.horizontal, 10)
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(
                ZStack {
                    if whiteBackground {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                    }
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 0.5)
                }
            )
            
        }
        .padding(.horizontal)
    }
}


#Preview {
    VStack(spacing: 50) {
        PinInput(pin: .constant(["", "", "", ""]))
        CustomTextInput(text: .constant(""), label: "Username")
        CustomTextInput(text: .constant(""), label: "Password", protected: true)
        OptionSelector(selectedOption: .constant("Option 1"), options: ["Option 1", "Option 2", "Option 3"], label: "Select an Option")
    }
}
