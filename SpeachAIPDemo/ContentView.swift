//
//  ContentView.swift
//  SpeachAIPDemo
//
//  Created by DannyShen on 2025/6/24.
//

import SwiftUI

import SwiftUI
import Speech


struct ContentView: View {
    @StateObject private var speechRecognizer = SpeechRecognizer()
    @State private var isRecording = false

    var body: some View {
        VStack {
            Toggle("啟用語音輸入", isOn: $isRecording)
                .padding()
                .onChange(of: isRecording) { value in
                    if value {
                        speechRecognizer.startRecording()
                    } else {
                        speechRecognizer.stopRecording()
                    }
                }

            ScrollView {
                Text(speechRecognizer.transcript)
                    .padding()
            }
        }
        .onAppear {
            speechRecognizer.requestAuthorization()
        }
    }
}


#Preview {
    ContentView()
}
