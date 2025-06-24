//
//  ContentView.swift
//  SpeachAIPDemo
//
//  Created by DannyShen on 2025/6/24.
//

import SwiftUI
import Speech

enum RecognitionLanguage: String, CaseIterable, Identifiable {
    case mandarinTW = "zh-TW"
    case mandarinCN = "zh-CN"
    case korean     = "ko-KR"
    case japanese   = "ja-JP"
    case english    = "en-US"

    var id: String { self.rawValue }

    var displayName: String {
        switch self {
        case .mandarinTW: return "國語"
        case .mandarinCN: return "普通话"
        case .korean:     return "한국어"
        case .japanese:   return "日本語"
        case .english:    return "English"
        }
    }
}

struct ContentView: View {
    @StateObject private var speechRecognizer = SpeechRecognizer()
    @State private var isRecording = false
    @State private var selectedLanguage: RecognitionLanguage = .mandarinTW

    var body: some View {
        VStack(spacing: 16) {
            Picker("語音語言", selection: $selectedLanguage) {
                ForEach(RecognitionLanguage.allCases) { language in
                    Text(language.displayName).tag(language)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            .onChange(of: selectedLanguage) { newLang in
                $speechRecognizer.localeIdentifier = newLang.rawValue
            }

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
            speechRecognizer.localeIdentifier = selectedLanguage.rawValue
        }
    }
}



#Preview {
    ContentView()
}
