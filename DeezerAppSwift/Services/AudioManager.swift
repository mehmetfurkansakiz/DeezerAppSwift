//
//  AudioManager.swift
//  DeezerAppSwift
//
//  Created by furkan sakız on 26.08.2023.
//

import Foundation
import AVFoundation

class AudioManager {
    
    static let shared = AudioManager()
    
    private var audioPlayer: AVPlayer?
    
    private init() {}
    
    func playAudio(from url: URL) {
        audioPlayer = AVPlayer(url: url)
        audioPlayer?.play()
    }
    
    func stopAudio() {
        audioPlayer?.pause()
        audioPlayer = nil
    }
}
