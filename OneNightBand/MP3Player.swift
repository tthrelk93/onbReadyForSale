//
//  MP3Player.swift
//  OneNightBand
//
//  Created by Thomas Threlkeld on 3/19/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import FirebaseStorage

class MP3Player: NSObject{
    
    var urls = [URL]()
    var localURLs = [URL]()
    var sessionID = String()
    var currentTrackIndex = 0
    var playerItem:AVPlayerItem?
    var player:AVPlayer?
    
    
    init(urlArray: [String], mp3Names: [String], sessionID: String){
        //tracks = FileReader.readFiles()
        super.init()
        //urlArray.first as StorageReference
        //print("urlArrayyy: \(urlArray)")
        for _ in urlArray{
            self.urls.append(URL(string: urlArray[currentTrackIndex])!)
            self.localURLs.append(URL(string: mp3Names[currentTrackIndex])!)
        }
        self.sessionID = sessionID
        
        if self.urls.count > 0{
            queueTrack();
        }
    }
    
    func queueTrack(){
        if (player != nil) {
            player = nil
        }
        
        //var error:NSError?
        let songRef = Storage.storage().reference(withPath: "session_audio").child(sessionID).child(String(describing: localURLs[currentTrackIndex]))
        /*songRef.downloadURL(completion: { (URL, error) -> Void in
         if(error != nil) {
         
         } else {
         print("URL: \(URL!)")
         do {
         print("in do")
         self.player?.delegate = self
         (print("delegateSet"))
         self.player?.prepareToPlay()
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SetTrackNameText"), object: nil)
         
         self.player = try AVAudioPlayer(contentsOf: URL!)
         
         } catch let error as NSError {
         //self.player = nil
         print(error.localizedDescription)
         } catch {
         print("AVAudioPlayer init failed")
         }
         
         }
         })*/
        /* songRef.data(withMaxSize: 20 * 1024 * 1024, completion: {data, error in
         if let error = error {
         
         } else {
         do {
         print("in do")
         self.player?.delegate = self
         (print("delegateSet"))
         self.player?.prepareToPlay()
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SetTrackNameText"), object: nil)
         print((data?.description)! as String)
         //var playerItem = AVPlayerItem(
         self.player = try AVAudioPlayer(data: data!)
         
         } catch let error as NSError {
         //self.player = nil
         print(error.localizedDescription)
         }
         
         }
         })*/
        
        let actualLocalURL = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent(String(describing: self.localURLs[currentTrackIndex]))
        let downloadTask = songRef.write(toFile: actualLocalURL) { (URL, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                // Local file URL for "images/island.jpg" is returned
                
                //let url =  URL
                print("URL: \(URL)")
                do {
                    print("in do")
                    //self.player?.delegate = self
                    //self.player?.prepareToPlay()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SetTrackNameText"), object: nil)
                    self.playerItem = AVPlayerItem(url: URL!)
                    print(self.playerItem)
                    //AVPlayerItem(
                    self.player = AVPlayer(playerItem: self.playerItem!)
                    //self.player?.play()
                    }
                /*try AVPlayer(playerItem: playerItem)
                } catch let error as NSError {
                    //self.player = nil
                    print(error.localizedDescription)
                } catch {
                    print("AVAudioPlayer init failed")
                }*/
                
            }
        }
        
        
        
        
        
        
        // url.standardizedFileURL
        //NSURL.fileURL(withPath: String(describing: urls[currentTrackIndex]))
        // NSURL(fileURLWithPath: String(describing: urls[currentTrackIndex]))
        /*player =   try AVAudioPlayer(contentsOf: url)
         if let hasError = error {
         //SHOW ALERT OR SOMETHING
         } else {
         player?.delegate = self
         player?.prepareToPlay()
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SetTrackNameText"), object: nil)
         }*/
        
        
        
    }
    
    func play() {
        
        //print(player?.url?.lastPathComponent)
        if player?.rate == 0 {
            player?.play()
        }
    }
    /*func stop(){
        if player?.isPlaying == true {
            player?.stop()
            player?.currentTime = 0
        }
    }*/
    func pause(){
        if player?.rate != 0{
            player?.pause()
        }
    }
    func nextSong(songFinishedPlaying:Bool){
        var playerWasPlaying = false
        if player?.rate != 0 {
            player?.pause()
            playerWasPlaying = true
        }
        
        currentTrackIndex += 1
        if currentTrackIndex >= urls.count {
            currentTrackIndex = 0
        }
        queueTrack()
        if playerWasPlaying || songFinishedPlaying {
            player?.play()
        }
    }
    func previousSong(){
        var playerWasPlaying = false
        if player?.rate != 0 {
            player?.pause()
            playerWasPlaying = true
        }
        currentTrackIndex -= 1
        if currentTrackIndex < 0 {
            currentTrackIndex = urls.count - 1
        }
        
        queueTrack()
        if playerWasPlaying {
            player?.play()
        }
    }
    func getCurrentTrackName() -> String {
        let trackName = String(describing: urls[currentTrackIndex]).stringByDeletingLastPathComponent
        return (trackName)
    }
    func getCurrentTimeAsString() -> String {
        var seconds = 0
        var minutes = 0
        if let time = player?.currentTime {
            
            seconds = Int(time().seconds)
            minutes = Int(seconds % 60)
        }
        return String(format: "%0.2d:%0.2d",minutes,seconds)
    }
    func getProgress()->Float{
        var theCurrentTime = 0.0
        var theCurrentDuration = 0.0
        if let currentTime = player?.currentTime, let duration = player?.currentItem?.duration {
            theCurrentTime = currentTime().seconds
            
            theCurrentDuration = duration.seconds
        }
        return Float(theCurrentTime / theCurrentDuration)
    }
    func setVolume(volume:Float){
        player?.volume = volume
    }
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool){
        if flag == true {
            nextSong(songFinishedPlaying: true)
        }
    }
}
extension String {
    public var url: NSURL { return NSURL(fileURLWithPath:self) }
    public var stringByDeletingLastPathComponent: String { return String(describing: url.lastPathComponent)}
}
    







/*class MP3Player: NSObject, AVAudioPlayerDelegate {
    var player:AVAudioPlayer?
    var currentTrackIndex = 0
    //var tracks:[String] = [String]()
    var urls = [URL]()
    var localURLs = [URL]()
    var sessionID = String()
 
    init(urlArray: [String], mp3Names: [String], sessionID: String){
        //tracks = FileReader.readFiles()
        super.init()
        //urlArray.first as StorageReference
        print("urlArrayyy: \(urlArray)")
        for _ in urlArray{
            self.urls.append(URL(string: urlArray[currentTrackIndex])!)
            self.localURLs.append(URL(string: mp3Names[currentTrackIndex])!)
        }
        self.sessionID = sessionID
        
        if self.urls.count > 0{
            queueTrack();
        }
    }
    
    func queueTrack(){
        if (player != nil) {
            player = nil
        }
        
        //var error:NSError?
        let songRef = Storage.storage().reference(withPath: "session_audio").child(sessionID).child(String(describing: localURLs[currentTrackIndex]))
        /*songRef.downloadURL(completion: { (URL, error) -> Void in
            if(error != nil) {
        
            } else {
                print("URL: \(URL!)")
                do {
                    print("in do")
                    self.player?.delegate = self
                    (print("delegateSet"))
                    self.player?.prepareToPlay()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SetTrackNameText"), object: nil)
                    
                    self.player = try AVAudioPlayer(contentsOf: URL!)
                    
                } catch let error as NSError {
                    //self.player = nil
                    print(error.localizedDescription)
                } catch {
                    print("AVAudioPlayer init failed")
                }
                
            }
    })*/
       /* songRef.data(withMaxSize: 20 * 1024 * 1024, completion: {data, error in
            if let error = error {
                
            } else {
                do {
                    print("in do")
                    self.player?.delegate = self
                    (print("delegateSet"))
                    self.player?.prepareToPlay()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SetTrackNameText"), object: nil)
                    print((data?.description)! as String)
                    //var playerItem = AVPlayerItem(
                 self.player = try AVAudioPlayer(data: data!)
                    
                } catch let error as NSError {
                    //self.player = nil
                    print(error.localizedDescription)
                } 

            }
        })*/
    
        let actualLocalURL = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent(String(describing: self.localURLs[currentTrackIndex]))
        let downloadTask = songRef.write(toFile: actualLocalURL) { (URL, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                // Local file URL for "images/island.jpg" is returned
                
                let url =  URL
                print("URL: \(URL)")
                do {
                    print("in do")
                    self.player?.delegate = self
                    self.player?.prepareToPlay()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SetTrackNameText"), object: nil)
                    var playerItem = AVPlayerItem(url: URL!)
                    self.player = try AVPlayer(playerItem: playerItem)
                    
                } catch let error as NSError {
                    //self.player = nil
                    print(error.localizedDescription)
                } catch {
                    print("AVAudioPlayer init failed")
                }

            }
        }
        

        
        
        
        
       // url.standardizedFileURL
 //NSURL.fileURL(withPath: String(describing: urls[currentTrackIndex]))
       // NSURL(fileURLWithPath: String(describing: urls[currentTrackIndex]))
        /*player =   try AVAudioPlayer(contentsOf: url)
       if let hasError = error {
            //SHOW ALERT OR SOMETHING
        } else {
            player?.delegate = self
            player?.prepareToPlay()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SetTrackNameText"), object: nil)
        }*/
        
        
        
    }
    
    func play() {
        
        //print(player?.url?.lastPathComponent)
        if player?.isPlaying == false {
            player?.play()
        }
    }
    func stop(){
        if player?.isPlaying == true {
            player?.stop()
            player?.currentTime = 0
        }
    }
    func pause(){
        if player?.isPlaying == true{
            player?.pause()
        }
    }
    func nextSong(songFinishedPlaying:Bool){
        var playerWasPlaying = false
        if player?.isPlaying == true {
            player?.stop()
            playerWasPlaying = true
        }
        
        currentTrackIndex += 1
        if currentTrackIndex >= urls.count {
            currentTrackIndex = 0
        }
        queueTrack()
        if playerWasPlaying || songFinishedPlaying {
            player?.play()
        }
    }
    func previousSong(){
        var playerWasPlaying = false
        if player?.isPlaying == true {
            player?.stop()
            playerWasPlaying = true
        }
        currentTrackIndex -= 1
        if currentTrackIndex < 0 {
            currentTrackIndex = urls.count - 1
        }
        
        queueTrack()
        if playerWasPlaying {
            player?.play()
        }
    }
    func getCurrentTrackName() -> String {
        let trackName = String(describing: urls[currentTrackIndex]).stringByDeletingLastPathComponent
        return (trackName)
    }
    func getCurrentTimeAsString() -> String {
        var seconds = 0
        var minutes = 0
        if let time = player?.currentTime {
            seconds = Int(time) % 60
            minutes = (Int(time) / 60) % 60
        }
        return String(format: "%0.2d:%0.2d",minutes,seconds)
    }
    func getProgress()->Float{
        var theCurrentTime = 0.0
        var theCurrentDuration = 0.0
        if let currentTime = player?.currentTime, let duration = player?.duration {
            theCurrentTime = currentTime
            theCurrentDuration = duration
        }
        return Float(theCurrentTime / theCurrentDuration)
    }
    func setVolume(volume:Float){
        player?.volume = volume
    }
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool){
        if flag == true {
            nextSong(songFinishedPlaying: true)
        }
    }
}
extension String {
    public var url: NSURL { return NSURL(fileURLWithPath:self) }
    public var stringByDeletingLastPathComponent: String { return String(describing: url.lastPathComponent)}
}*/
