//
//  MP3PlayerViewController.swift
//  OneNightBand
//
//  Created by Thomas Threlkeld on 3/19/17.
//  Copyright © 2017 Thomas Threlkeld. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import MediaPlayer
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

//import DropDown

class MP3PlayerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate {
    var mp3Player:MP3Player?
    var artistID = String()
    var timer:Timer?
    var sessionID:String?
    var BandID: String?
    var mp3Names = [String]()
    var mediaItems = [MPMediaItem]()
    //var dropDown = DropDown()
    @IBOutlet weak var addPicAndVid: UIButton!
   
    @IBAction func addPicAndVidPressed(_ sender: Any) {
        performSegue(withIdentifier: "SessionToAddMedia", sender: self)
    }
    @IBOutlet weak var viewsLabel: UILabel!
    @IBOutlet weak var sessionDateLabel: UILabel!
    @IBOutlet weak var sessionCityLabel: UILabel!
    @IBOutlet weak var mp3Picker: UITableView!
    //now known as ShowMedia
    @IBOutlet weak var addMP3: UIButton!
    @IBAction func showSongsPressed(_ sender: Any) {
        addMP3.isHidden = true
        closeMP3Button.isHidden = false
        mp3Picker.isHidden = false
        //if mp3URLArray.count > 0{
            self.mediaItems = MPMediaQuery.songs().items!
        
        // Or you can filter on various property
        // Like the Genre for example here
        /*var query = MPMediaQuery.songs()
        let predicateByGenre = MPMediaPropertyPredicate(value: "Rock", forProperty: MPMediaItemPropertyTitle )//MPMediaItemPropertyGenre)
        query.filterPredicates = NSSet(object: predicateByGenre) as! Set<MPMediaPredicate>*/
        for song in mediaItems{
           // print(song.assetURL!)
            print(song.value(forProperty: MPMediaItemPropertyAssetURL))
            let cellNib = UINib(nibName: "songCell", bundle: nil)
            self.mp3Picker.register(cellNib, forCellReuseIdentifier: "SongCell")
            self.mp3Picker.delegate = self
            self.mp3Picker.dataSource = self
            mp3Names.append(song.title!)
        }
        for song in mediaItems{
            //print(song.albumArtist!)
            
        }
        //}
        /*let mediaCollection = MPMediaItemCollection(items: mediaItems!)
       
        
        let player = MPMusicPlayerController.systemMusicPlayer()
        player.setQueue(with: mediaCollection)
        
        player.play()*/
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SessionToAddMedia"{
        
            if let vc = segue.destination as? AddMediaToSession
            {
                vc.sessionID = self.sessionID!
                vc.bandID = self.BandID!
                vc.senderView = "session"
                vc.artistID = self.artistID
            }
        }
        if segue.identifier == "MP3ToBand"{
            if let vc = segue.destination as? SessionMakerViewController
            {
                
                vc.sessionID = self.BandID
                vc.sender = self.sender
                vc.artistID = self.artistID
                
            }
        }
    }
    

    func handleBack(){
        //self.performSegue(withIdentifier: "MP3ToBand", sender: self)
        self.navigationController?.popViewController(animated: true)
    }
    var sender = String()
    var viewerInBand = Bool()
    @IBOutlet weak var sessionBio: UITextView!
    @IBOutlet weak var sessionVidCollect: UICollectionView!
    @IBOutlet weak var sessionImagesCollect: UICollectionView!
    @IBOutlet weak var sessionNameLabel: UILabel!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var trackTime: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    var mp3URLArray = [URL]()
    var picArray = [UIImage]()
    var destArray = [URL]()
    var mp3Dict = [String: Any]()
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var addSessionToFavorites: UIButton!
    
    @IBAction func addSessToFavoritesPressed(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        backButton.layer.cornerRadius = 10
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back" , style: .plain, target: self, action: #selector(handleBack))
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white], for: UIControlState.normal)

        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        layout.minimumInteritemSpacing = 20
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        sessionImagesCollect.collectionViewLayout = layout
        if self.viewerInBand == true{
            addMP3.isHidden = false
            addPicAndVid.isHidden = false
           // addSessionToFavorites.isHidden = true
        } else {
            addMP3.isHidden = true
            addPicAndVid.isHidden = true
            //addSessionToFavorites.isHidden = false
        }
        
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.isHidden = false
        //self.navigationItem.hidesBackButton = false
        
        Database.database().reference().child("sessions").child(sessionID!).observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                //fill datasources for collectionViews
                
                
                
                    for snap in snapshots{
                        if snap.key == "mp3StorageNames"{
                            if let mp3Snapshots = snap.children.allObjects as? [DataSnapshot]{
                                for mp3Name in mp3Snapshots{
                                    if (mp3Name.value as! String) != ""{
                                        self.mp3StorageNames.append(mp3Name.value as! String)
                                    }
                                }
                                
                            }
                            
                        }
                        if snap.key == "mp3URLs"{
                           /* let mp3URLArray = snap.value as! [String:String]
                            let tmpDir = FileManager.default.urls(for: .musicDirectory , in: .userDomainMask).first
                            for (storageURL, sourceURL) in mp3URLArray{
                                let fileName = NSURL(string: sourceURL)?.lastPathComponent!
                                let destinationURL = tmpDir!.appendingPathComponent(fileName!)
                                if let fileData = NSData(contentsOf: NSURL(string: storageURL) as! URL){
                                    fileData.write(to: destinationURL, atomically: =)
                                    self.destArray.append(destinationURL)
                                    }
                            
                            }*/
                            //var tempDict = [String:Any]()
                            
                           if let mp3Snapshot = snap.children.allObjects as? [DataSnapshot]{
                                for mp3 in mp3Snapshot{
                                    if (mp3.value as! String) != ""{
                                        //let fileName = sourceUrl.lastPathComponent!
                                        self.mp3URLString.append(mp3.value as! String)
                                        
                                       /*let httpsReference = Storage.storage().reference(forURL: mp3.value as! Sting)
                                        //print(httpsReference)
                                        httpsReference.downloadURL(completion: {url, error in
                                            if let error = error{
                                                print(error)
                                            } else {*/
                                        //self.mp3URLArray.append()
                                           // }
                                        //})
                                        //Bundle.main.te
                                    
                                        //httpsReference.downloadURL(completion: <#T##(URL?, Error?) -> Void#>)
                                        //self.mp3URLArray.append(URL(string: (mp3.value as! String))!)
                                    }
                            }
                            }
                            
                            
                        }
                        else if snap.key == "sessionName"{
                            self.navigationItem.title = (snap.value as! String)
                            
                            self.sessionNameLabel.text = ""
                        }
                        else if snap.key == "sessionBio"{
                            self.sessionBio.text = snap.value as! String
                        }
                        else if snap.key == "sessionDate"{
                            self.sessionDateLabel.text = (snap.value as! String)
                        }
                        else if snap.key == "sessionPictureURL"{
                            if let snapshots = snap.children.allObjects as? [DataSnapshot]{
                                for p_snap in snapshots{
                                    if let url = NSURL(string: p_snap.value as! String){
                                        if let data = NSData(contentsOf: url as URL){
                                            self.picArray.append(UIImage(data: data as Data)!)
                                        }
                                    }
                                }
                            }
                            
                        }
                        else if snap.key == "views"{
                            
                            self.viewsLabel.text = String(describing: (snap.value as! Int))
                        }
                        else if snap.key == "sessionMedia"{
                            let mediaSnaps = snap.value as! [String]
                            for m_snap in mediaSnaps{
                                //fill youtubeArray
                                //self.youtubeArray.append(NSURL(string: m_snap)!)
                                if m_snap.contains("yout"){
                                    self.nsurlDict[NSURL(string: m_snap)!] = "y"
                                } else {
                                    self.nsurlDict[NSURL(string: m_snap)!] = "v"
                                }
                                self.nsurlArray.append(NSURL(string: m_snap)!)
                                
                            }
                        }
                }
            }
                                    //fill vidsFromPhone array
                        
                       
    
                if self.nsurlArray.count == 0{
                    self.currentCollect = "youtube"
                    
                    self.tempLink = nil
                    
                    let cellNib = UINib(nibName: "VideoCollectionViewCell", bundle: nil)
                    self.sessionVidCollect.register(cellNib, forCellWithReuseIdentifier: "VideoCollectionViewCell")
                    self.sizingCell2 = ((cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! VideoCollectionViewCell?)!
                    //self.sessionVidCollect.backgroundColor = UIColor.clear
                    self.sessionVidCollect.dataSource = self
                    self.sessionVidCollect.delegate = self
                    
                }else{
                    //for vid in self.nsurlArray{
                    
                    // Put your code which should be executed with a delay here
                        self.currentCollect = "youtube"
                    
                        //self.tempLink = vid
                    
                        let cellNib = UINib(nibName: "VideoCollectionViewCell", bundle: nil)
                        self.sessionVidCollect.register(cellNib, forCellWithReuseIdentifier: "VideoCollectionViewCell")
                        self.sizingCell2 = ((cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! VideoCollectionViewCell?)!
                        //self.sessionVidCollect.backgroundColor = UIColor.clear
                        self.sessionVidCollect.dataSource = self
                        self.sessionVidCollect.delegate = self
                   // }
                }
                
            
                
                print("urlArray:\(self.mp3URLString)")
            print("mp3Names: \(self.mp3StorageNames)")
            self.mp3Player = MP3Player(urlArray: self.mp3URLString, mp3Names: self.mp3StorageNames, sessionID: self.sessionID!)
            
                if self.mp3URLArray.count > 0{
                    self.setupNotificationCenter()
                    self.setTrackName()
                    self.updateViews()
                }
                //self.mp3Player?.urls = self.mp3URLArray
            DispatchQueue.main.async{
               // for _ in self.picArray{
                    self.currentCollect = "pic"
                    //self.tempLink = NSURL(string: (snap.value as? String)!)
                    
                    //self.YoutubeArray.append(snap.value as! String)
                    
                    let cellNib = UINib(nibName: "PictureCollectionViewCell", bundle: nil)
                    self.sessionImagesCollect.register(cellNib, forCellWithReuseIdentifier: "PictureCollectionViewCell")
                    
                    self.sizingCell = ((cellNib.instantiate(withOwner: nil, options: nil) as NSArray).firstObject as! PictureCollectionViewCell?)!
                    self.sessionImagesCollect.backgroundColor = UIColor.clear
                    self.sessionImagesCollect.dataSource = self
                    self.sessionImagesCollect.delegate = self
                    
              //  }
                

            }
        })

        /*dropDown.selectionBackgroundColor = UIColor.orange.withAlphaComponent(0.4)
        dropDown.anchorView = self.view//collectionView.cellForItem(at: indexPath)
        dropDown.dataSource = ["beginner","intermediate","advanced","expert"]
        dropDown.selectionAction = {[unowned self] (index: Int, item: String) in
            self.mp3Player.qu
        }
        dropDown.direction = .top
        //dropDown.selectRow(at: 1)
        dropDown.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        dropDown.textColor = UIColor.white.withAlphaComponent(0.8)*/
        
    }
    var nsurlArray = [NSURL]()
    var nsurlDict = [NSURL: String]()
    var youtubeArray = [NSURL]()
    var vidFromPhoneArray = [NSURL]()
    var sizingCell2 = VideoCollectionViewCell()
    var tempLink: NSURL?
    var sizingCell = PictureCollectionViewCell()
    var currentCollect = String()
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        //SwiftOverlays.removeAllBlockingOverlays()
    }
    
    
    
    
    @IBAction func playSong(_ sender: Any) {
        if mp3URLString.count > 0{
            print("play")
        mp3Player?.player?.play()
           
        startTimer()
        }
    }
   
    @IBAction func stopSong(_ sender: Any) {
        if mp3URLString.count > 0{
        mp3Player?.pause()
            mp3Player?.player?.seek(to: kCMTimeZero)
            //mp3Player?.
        updateViews()
        timer?.invalidate()
        }
    }
    
    
    @IBAction func pauseSong(_ sender: Any) {
        if mp3URLString.count > 0{
        mp3Player?.pause()
        timer?.invalidate()
        }
    }
   
    @IBAction func playNextSong(_ sender: Any) {
        if mp3URLString.count > 0{
        mp3Player?.nextSong(songFinishedPlaying: false)
        startTimer()
        }
    }
    
    
    
    @IBAction func setVolume(_ sender: Any) {
         mp3Player?.setVolume(volume: (sender as AnyObject).value)
    }
    
    
    @IBAction func playPreviousSong(_ sender: Any) {
        if mp3URLString.count > 0{
        mp3Player?.previousSong()
        startTimer()
        }
    }
   
    
    func setTrackName(){
        if mp3URLString.count > 0{
        trackName.text = (mp3Player?.getCurrentTrackName())!
        }
    }
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(MP3PlayerViewController.updateViews), userInfo: nil, repeats: true)
    }
    
    func updateViewsWithTimer(theTimer: Timer){
        updateViews()
    }
    
    func updateViews(){
        trackTime.text = mp3Player?.getCurrentTimeAsString()
        if let progress = mp3Player?.getProgress() {
            progressBar.progress = progress
        }
    }
    
    func setupNotificationCenter(){
        NotificationCenter.default.addObserver(self,
                                                         selector:#selector(MP3PlayerViewController.setTrackName),
                                                         name:NSNotification.Name(rawValue: "SetTrackNameText"),
                                                         object:nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.superview?.reloadInputViews()
                self.view.removeFromSuperview()
                
            }
        });
    }

    @IBAction func backPressed(_ sender: Any) {
        performSegue(withIdentifier: "MP3ToBand", sender: self)
    }
    
    @IBOutlet weak var closeMP3Button: UIButton!
    @IBAction func closeMP3Touched(_ sender: Any) {
        addMP3.isHidden = false
        closeMP3Button.isHidden = true
        mp3Picker.isHidden = true
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        //print((self.thisSession.sessionArtists?.count)!)
        return self.mp3Names.count
    }
    //var mp3PlayerDict = [String: Any]()
    var mp3StorageNames = [String]()
    var mp3URLString = [String]()
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        //(tableView.cellForRow(at: indexPath) as ArtistCell).artistUID
        //self.cellTouchedArtistUID = (tableView.cellForRow(at: indexPath) as! ArtistCell).artistUID
        //performSegue(withIdentifier: "ArtistCellTouched", sender: self)
        //print(mediaItems[indexPath.row].assetURL)
        let mp3Name = NSUUID().uuidString
        var storageName = "\(mp3Name).m4a"
        let storageRef = Storage.storage().reference(withPath: "session_audio").child(sessionID!).child(storageName)
        let uploadMetadata = StorageMetadata()
        uploadMetadata.contentType = "audio/m4a" //might need to be mp4
       
        var item = mediaItems[indexPath.row]
        
        
        
        if let assetURL = item.assetURL {
            export(assetURL) { fileURL, error in
                guard let fileURL = fileURL, error == nil else {
                    print("export failed: \(error)")
                    return
                }
                print(fileURL)
               // print(Storage.storage().reference(forURL: <#T##String#>))
                
                // use fileURL of temporary file here
                _ = storageRef.putFile(from: fileURL, metadata: uploadMetadata){(metadata, error) in
                    
                    if(error != nil){
                        print("got an error: \(error)")
                        let alert = UIAlertController(title: "Error", message: "inside putfile error.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "okay", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    print((metadata?.downloadURL()?.absoluteString)!)
                    self.mp3URLString.append((metadata?.downloadURL()?.absoluteString)!)
                    self.mp3StorageNames.append(storageName)
                    //self.mp3URLString.append(String(describing: fileURL))
                    var values2 = [String: Any]()
                    values2["mp3URLs"] = self.mp3URLString
                    values2["mp3StorageNames"] = self.mp3StorageNames
                    Database.database().reference().child("sessions").child(self.sessionID!).updateChildValues(values2, withCompletionBlock: {(err, ref) in
                        if err != nil {
                            print(err!)
                            return
                        }
                    })
                    
                
                }
                self.mp3URLArray.append(fileURL)
                
                
            }
        }

        
        
        
        //print(item.mediaType.)
        
        /*for url in mp3URLArray{
            mp3URLString.append(String(describing: url))
        }*/
        
        
    }
    
    /// Export MPMediaItem to temporary file.
    ///
    /// - Parameters:
    ///   - assetURL: The `assetURL` of the `MPMediaItem`.
    ///   - completionHandler: Closure to be called when the export is done. The parameters are a boolean `success`, the `URL` of the temporary file, and an optional `Error` if there was any problem. The parameters of the closure are:
    ///
    ///   - fileURL: The `URL` of the temporary file created for the exported results.
    ///   - error: The `Error`, if any, of the asynchronous export process.
    
    func export(_ assetURL: URL, completionHandler: @escaping (_ fileURL: URL?, _ error: Error?) -> ()) {
        let asset = AVURLAsset(url: assetURL)
        guard let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A) else {
            completionHandler(nil, ExportError.unableToCreateExporter)
            return
        }
        
        let fileURL = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent(NSUUID().uuidString)
            .appendingPathExtension("m4a")
        
        exporter.outputURL = fileURL
        exporter.outputFileType = "com.apple.m4a-audio"
        
        exporter.exportAsynchronously {
            if exporter.status == .completed {
                completionHandler(fileURL, nil)
            } else {
                completionHandler(nil, exporter.error)
            }
        }
    }
    
    
    enum ExportError: Error {
        case unableToCreateExporter
    }
    
    
    
    


    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath as IndexPath) as! songCell
        var artwork = mediaItems[indexPath.row].artwork
        var artworkImage = artwork?.image(at: cell.albumCoverImageView.frame.size)
        cell.nameLabel.text = mp3Names[indexPath.row]
        
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        if collectionView == sessionImagesCollect{
            return self.picArray.count
        }else{
            if self.nsurlArray.count == 0{
                return 1
            }else{
                return self.nsurlArray.count
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("cell4Item: \(self.currentCollect)")
        if collectionView != sessionImagesCollect{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCollectionViewCell", for: indexPath as IndexPath) as! VideoCollectionViewCell
            self.configureVidCell(cell, forIndexPath: indexPath as NSIndexPath)
            cell.indexPath = indexPath
            
            //self.curIndexPath.append(indexPath)
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PictureCollectionViewCell", for: indexPath as IndexPath) as! PictureCollectionViewCell
            self.configureCell(cell, forIndexPath: indexPath as NSIndexPath)
            
            
            //self.curIndexPath.append(indexPath)
            
            return cell
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView != self.sessionImagesCollect{
            if (self.sessionVidCollect.cellForItem(at: indexPath) as! VideoCollectionViewCell).videoURL?.absoluteString?.contains("youtube") == false {
                if (self.sessionVidCollect.cellForItem(at: indexPath) as! VideoCollectionViewCell).player?.playbackState == .playing {
                    (self.sessionVidCollect.cellForItem(at: indexPath) as! VideoCollectionViewCell).player?.stop()
                    
                }else{
                    (self.sessionVidCollect.cellForItem(at: indexPath) as! VideoCollectionViewCell).player?.playFromBeginning()
                }
                
            }
        }
        
        
        
    }
    func configureVidCell(_ cell: VideoCollectionViewCell, forIndexPath indexPath: NSIndexPath){
        
        
        if self.nsurlArray.count == 0{
            cell.layer.borderColor = UIColor.white.cgColor
            cell.layer.borderWidth = 2
            cell.removeVideoButton.isHidden = true
            cell.videoURL = nil
            cell.player?.view.isHidden = true
            cell.youtubePlayerView.isHidden = true
            //cell.youtubePlayerView.loadVideoURL(videoURL: self.youtubeArray[indexPath.row])
            cell.removeVideoButton.isHidden = true
            cell.noVideosLabel.isHidden = false
        }else {
            
            cell.layer.borderColor = UIColor.clear.cgColor
            cell.layer.borderWidth = 0
            
            //cell.youtubePlayerView.isHidden = true
            cell.removeVideoButton.isHidden = true
            cell.noVideosLabel.isHidden = true
            
            
            
            cell.videoURL =  self.nsurlArray[indexPath.row] as NSURL?
            if(String(describing: cell.videoURL).contains("youtube") || String(describing: cell.videoURL).contains("youtu.be")){
                cell.youtubePlayerView.loadVideoURL(cell.videoURL as! URL)
                cell.youtubePlayerView.isHidden = false
                cell.player?.view.isHidden = true
                cell.isYoutube = true
            }else{
                cell.player?.setUrl(cell.videoURL as! URL)
                cell.player?.view.isHidden = false
                cell.youtubePlayerView.isHidden = true
                cell.isYoutube = false
            }
            //print(self.vidArray[indexPath.row])
            //cell.youtubePlayerView.loadVideoURL(self.vidArray[indexPath.row] as URL)
            //self.group.leave()
        }
        
        
        
    }
    func configureCell(_ cell: PictureCollectionViewCell, forIndexPath indexPath: NSIndexPath) {
        
        cell.picImageView.image = self.picArray[indexPath.row]
        cell.deleteButton.isHidden = true
        /* switch UIScreen.main.bounds.width{
         case 320:
         
         cell.frame = CGRect(x: cell.frame.origin.x, y: cell.frame.origin.y, width:320, height:267)
         
         case 375:
         cell.frame = CGRect(x: cell.frame.origin.x,y: cell.frame.origin.y,width:375,height:267)
         
         
         case 414:
         cell.frame = CGRect(x: cell.frame.origin.x,y: cell.frame.origin.y,width:414,height:267)
         
         default:
         cell.frame = CGRect(x: cell.frame.origin.x,y: cell.frame.origin.y,width:414,height:267)
         
         
         
         }*/
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        if currentCollect == "pic"{
            print("picINset")
            return UIEdgeInsetsMake(0, 0, 0, 0)
            /*}else{
             let totalCellWidth = (self.sizingCell?.frame.width)! * CGFloat(self.picArray.count)
             let totalSpacingWidth = 10 * (self.picArray.count - 1)
             
             let leftInset = (collectionView.frame.width - CGFloat(totalCellWidth + CGFloat(totalSpacingWidth))) / 2
             let rightInset = leftInset
             return UIEdgeInsetsMake(0, leftInset, 0, rightInset)
             }*/
        } else{
            return UIEdgeInsetsMake(0, collectionView.contentInset.left, 0, collectionView.contentInset.right)
        }
    }

    



}
