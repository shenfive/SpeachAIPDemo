//
//  SpeechRecognizer.swift
//  SpeachAIPDemo
//
//  Created by DannyShen on 2025/6/24.
//

import Foundation
import Speech
import AVFoundation

class SpeechRecognizer: NSObject, ObservableObject {
    private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "zh-TW"))
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private var request: SFSpeechAudioBufferRecognitionRequest?
    
    @Published var transcript = ""
    
    func setLanguage(identifier:String){
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: identifier))
    }
    
    func requestAuthorization() {
        SFSpeechRecognizer.requestAuthorization { _ in }
    }
    
    func startRecording() {
        request = SFSpeechAudioBufferRecognitionRequest()
        guard let request = request else { return }
        
        guard let recognizer = speechRecognizer, recognizer.isAvailable else { return }

        let node = audioEngine.inputNode
        let format = node.outputFormat(forBus: 0)

        node.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
            self.request?.append(buffer)
        }

        audioEngine.prepare()
        try? audioEngine.start()

        recognitionTask = recognizer.recognitionTask(with: request) { result, error in
            if let result = result {
                DispatchQueue.main.async {
                    self.transcript = result.bestTranscription.formattedString
                }
            }
            if error != nil {
                self.stopRecording()
            }
        }
    }

    func stopRecording() {
        request?.endAudio()
        request = nil
        recognitionTask?.cancel()
        recognitionTask = nil
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
}

