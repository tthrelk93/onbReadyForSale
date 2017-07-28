//
//  VideoCollectionViewCell.swift
//  OneNightBand
//
//  Created by Thomas Threlkeld on 12/5/16.
//  Copyright © 2016 Thomas Threlkeld. All rights reserved.
//

import UIKit
import YouTubePlayer




class VideoCollectionViewCell: UICollectionViewCell, RemoveVideoData {
    
    weak var removeVideoDelegate: RemoveVideoDelegate?
   
    @IBAction func removeVideoPressed(_ sender: AnyObject) {
        print("remove Pressed: \(self.videoURL)")
        removeVideoDelegate?.removeVideo(removalVid: self.videoURL!, isYoutube: self.isYoutube!)
        
    }
    
    @IBOutlet weak var touchBlockingView: UIView!
    
    @IBOutlet weak var noVideosLabel: UILabel!
    
    @IBOutlet weak var removeVideoButton: UIButton!
    @IBOutlet weak var youtubePlayerView: YouTubePlayerView!
    var player: Player?
    //var player:Player?
    @IBOutlet weak var playPauseButton: UIButton!
    @IBAction func playPauseTouched(_ sender: AnyObject) {
        if youtubePlayerView.ready {
            if youtubePlayerView.playerState != YouTubePlayerState.Playing {
                youtubePlayerView.play()
                playPauseButton.setTitle("Pause", for: .normal)
            } else {
                youtubePlayerView.pause()
                playPauseButton.setTitle("Play", for: .normal)
            }
        }
    }
    var cellSelected = false
    var videoIndex: Int?
    var videoURL: NSURL?
    var indexPath: IndexPath?
    var indexPathRow: Int?
    var isYoutube: Bool?
    //var isPlaying = Bool()
    //var isPaused = Bool()
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.player = Player()
        self.addSubview((self.player?.view)!)
         self.youtubePlayerView.frame = self.frame//CGRect(x: 0,y:0,width:103,height:103)
        self.player?.view.frame = self.youtubePlayerView.frame
        self.bringSubview(toFront: self.removeVideoButton)
        self.sendSubview(toBack: (self.player?.view)!)
        
        if isYoutube == true{
            self.youtubePlayerView.isHidden = false
            self.player?.view.isHidden = true
        }else{
            self.youtubePlayerView.isHidden = true
            self.player?.view.isHidden = false
        }
            if self.videoURL == nil{
                self.noVideosLabel.isHidden = false
            }else{
                self.noVideosLabel.isHidden = true
            }
        //self.removeVideoButton.isHidden = true
         //isPlaying = false
        //isPaused = true
       /* var currentVideoURL: URL?
        self.player = Player()
        switch UIScreen.main.bounds.width{
        case 320:
            self.player?.view.frame = CGRect(x: 35,y:50,width:250,height:130)
            
        case 375:
            self.player?.view.frame = CGRect(x: 40,y:85,width:300,height:200)
            
            
        case 414:
            self.player?.view.frame = CGRect(x: 33,y:100,width:350,height:250)
            
        default:
            self.player?.view.frame = CGRect(x: 60,y:140,width:350,height:250)
            
            
            
        }
        
        self.videoCellView.autoresizesSubviews = true
        
        self.videoCellView.addChildViewController(self.player!)
        sessionInfoView.addSubview((self.player?.view)!)*/
        
    }

}
