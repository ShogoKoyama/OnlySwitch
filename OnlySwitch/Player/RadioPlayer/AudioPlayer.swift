//
//  AudioPlayer.swift
//  SpringRadio
//
//  Created by jack on 2020/4/7.
//  Copyright © 2020 jack. All rights reserved.
//
import AppKit
import MediaPlayer

protocol AudioPlayer {
    var currentAudioStation:RadioPlayerItem? {get set}
    var analyzer:RealtimeAnalyzer {get set}
    var bufferring : Bool {get set}
    func play(stream item: RadioPlayerItem)
    func stop()
}

extension AudioPlayer {
    func setupNowPlaying() {
        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = self.currentAudioStation?.title
        let image = NSImage(named: "AppIcon")!
        let newImage = image.resize(withSize: NSSize(width: 100, height: 100))!
        nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: CGSize(width: 100, height: 100), requestHandler: { _ in
            newImage
        })

        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        MPNowPlayingInfoCenter.default().playbackState = .playing
    }

    func setupRemoteCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared();
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { event in
            let station = self.currentAudioStation
            station?.isPlaying = true
            MPNowPlayingInfoCenter.default().playbackState = .playing
            return .success
        }
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget {event in
            let station = self.currentAudioStation
            station?.isPlaying = false
            MPNowPlayingInfoCenter.default().playbackState = .paused
            return .success
        }
        
        commandCenter.togglePlayPauseCommand.addTarget{ event in
            guard let station = self.currentAudioStation else {return .commandFailed}
            station.isPlaying = !station.isPlaying
            if MPNowPlayingInfoCenter.default().playbackState == .playing {
                MPNowPlayingInfoCenter.default().playbackState = .paused
            } else {
                MPNowPlayingInfoCenter.default().playbackState = .playing
            }
           
            return .success
        }
//        commandCenter.nextTrackCommand.isEnabled = self.currentAudioStation?.itemStatesInList == .Last ? false : true
//        commandCenter.nextTrackCommand.addTarget { event in
//            self.currentAudioStation?.nextStation()
//            return .success
//        }
//
//        commandCenter.previousTrackCommand.isEnabled = self.currentAudioStation?.itemStatesInList == .First ? false : true
//        commandCenter.previousTrackCommand.addTarget { event in
//            self.currentAudioStation?.previousStation()
//            return .success
//
//        }
    }
    
    func pauseCommandCenter() {
        MPNowPlayingInfoCenter.default().playbackState = .paused
    }
    
}



