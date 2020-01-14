//
//  AppDelegate.swift
//  color
//
//  Created by Harry Patsis on 4/29/15.
//  Copyright (c) 2015 Harry Patsis. All rights reserved.
// $(inherited) $(PROJECT_DIR)/admob $(PROJECT_DIR)/Chartboost

import UIKit
import SpriteKit
import AVFoundation


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var appDidShowJustNow:Bool = true
  var levelsSolved:Int = 0
  var levelsPlayed:Int = 0
  var gameSceneDelegate:GameScene?
  
  var gameStartDate = Date()
  
  var audioPlayer1:AVAudioPlayer?
  var audioPlayer2:AVAudioPlayer?
  var activeAudioPlayer:AVAudioPlayer?
  let maxAudioPlayerVolume:Float = 0.5
  
  var window: UIWindow?
  var scaleX:CGFloat = 1
  var viewSize:CGSize = CGSize()
  var controller:GameViewController?
  
  var successSoundIndex = 0
  var clickSoundIndex = 0
  
  var isNormalGame:Bool = true
  var jsonNormalLevels:[[String: AnyObject]]?
  var jsonFrenzyLevels:[[String: AnyObject]]?
  
  var musicDisabled:Bool {
    get {
      return UserDefaults.standard.bool(forKey: "musicDisabled")
    }
    set {
      UserDefaults.standard.set(newValue, forKey: "musicDisabled")
      newValue ? pauseAudio() : resumeAudio()
    }
  }
  
  var clickSoundAction:SKAction {
    get {
      clickSoundIndex += 1
      switch clickSoundIndex % 2 {
      case 0:return SKAction.playSoundFileNamed("select2.mp3", waitForCompletion: false)
      default:return SKAction.playSoundFileNamed("select1.mp3", waitForCompletion: false)
      }
    }
  }
  
  var successSoundAction:SKAction {
    get {
      successSoundIndex += 1
      let wait = SKAction.wait(forDuration: 0.5)
      switch successSoundIndex % 2 {
      case 0:return SKAction.sequence([wait,SKAction.playSoundFileNamed("success1.mp3", waitForCompletion: false)])
      default:return SKAction.sequence([wait,SKAction.playSoundFileNamed("success2.mp3", waitForCompletion: false)])
      }
    }
  }
  
  var jsonLevels:[[String: AnyObject]]? {
    get {
      return isNormalGame ? jsonNormalLevels : jsonFrenzyLevels
    }
  }
  
  var unlockedLevel:Int {
    get {
      let key = isNormalGame ? "unlockedNormalLevel" : "unlockedFrenzyLevel"
      return UserDefaults.standard.integer(forKey: key)
    }
    set {
      let value = min((jsonLevels?.count)!-1, newValue)
      let key = isNormalGame ? "unlockedNormalLevel" : "unlockedFrenzyLevel"
      UserDefaults.standard.set(value, forKey: key)
    }
  }
  
  fileprivate var normalScrollPosition:CGFloat = 0
  fileprivate var frenzyScrollPosition:CGFloat = 0
  var scrollPosition:CGFloat {
    get {
      return  isNormalGame ? normalScrollPosition : frenzyScrollPosition
    }
    set {
      if isNormalGame {
        normalScrollPosition = newValue
      } else {
        frenzyScrollPosition = newValue
      }
    }
  }
  
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    
    viewSize = UIScreen.main.bounds.size
    if UIDevice.current.userInterfaceIdiom == .phone {
      viewSize.height = (640.0) * (viewSize.height / viewSize.width)
      viewSize.width = 640
    } else {
      viewSize.height = (768.0) * (viewSize.height / viewSize.width)
      viewSize.width = 768
    }
    
    scaleX = viewSize.width/640.0
    //initialize music
    loadMusic1()
    loadMusic2()
    //intialize levels
    jsonNormalLoad()
    jsonFrenzyLoad()
    
    return true
  }
  
  
  func applicationWillResignActive(_ application: UIApplication) {
    pauseAudio()
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    //    pauseAudio()
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    resumeAudio()
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
  
  // MARK: - JSON
  
  func jsonNormalLoad() {
    if let path = Bundle.main.path(forResource: "normal", ofType: "json") {
      if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
        do {
          let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
          jsonNormalLevels = json["levels"] as? [[String:AnyObject]]
        } catch let error as NSError {
          print("Failed to load: \(error.localizedDescription)")
        }
      }
    }
  }
  
  func jsonFrenzyLoad() {
    if let path = Bundle.main.path(forResource: "frenzy", ofType: "json") {
      if let data = try? Data(contentsOf: URL(fileURLWithPath: path)) {
        do {
          let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: AnyObject]
          jsonFrenzyLevels = json["levels"] as? [[String:AnyObject]]
        } catch let error as NSError {
          print("Failed to load: \(error.localizedDescription)")
        }
      }
    }
  }
  
  
  func setupAudioPlayerWithFile(_ file:NSString, type:NSString) -> AVAudioPlayer?  {
    let path = Bundle.main.path(forResource: file as String, ofType: type as String)
    let url = URL(fileURLWithPath: path!)
    var audioPlayer:AVAudioPlayer?
    do {
      try audioPlayer = AVAudioPlayer(contentsOf: url)
      
    } catch {
      print("Player not available")
    }
    return audioPlayer
  }
  
  func fadeAudioTo(toVolume endVolume : Float, overTime time : Float) {
    activeAudioPlayer?.fade(toVolume: endVolume, overTime: time)
  }
  
  func resumeAudio() {
    if !musicDisabled {
      if let audioPlayer = activeAudioPlayer {
        audioPlayer.play()
        fadeAudioTo(toVolume: maxAudioPlayerVolume, overTime: 1.0)
      } else {
       playMusic1()
      }
    }
  }
  
  //  func lateResumeAudio() {
  //    if !musicDisabled {
  //      let delay = dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Float(NSEC_PER_SEC)))
  //      dispatch_after(delay, dispatch_get_main_queue()) {
  //        self.audioPlayer?.play()
  //        self.fadeAudioTo(toVolume: self.maxAudioPlayerVolume, overTime: 1.0)
  //      }
  //    }
  //  }
  
  func pauseAudio() {
    if let audioPlayer = activeAudioPlayer {
      fadeAudioTo(toVolume: 0, overTime: 1.0)
      let delay = DispatchTime.now() + Double(Int64(1.0 * Float(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
      DispatchQueue.main.asyncAfter(deadline: delay) {
        audioPlayer.stop()
      }
    }
  }
  
  func loadMusic1() {
    audioPlayer1 = setupAudioPlayerWithFile("retreat", type: "mp3")
    audioPlayer1?.volume = 0.2
    audioPlayer1?.numberOfLoops = -1
    audioPlayer1?.volume = 0
  }
  
  func loadMusic2() {
    audioPlayer2 = setupAudioPlayerWithFile("microchip", type: "mp3")
    audioPlayer2?.volume = 0.2
    audioPlayer2?.numberOfLoops = -1
    audioPlayer2?.volume = 0
  }
  
  func playMusic1() {
    if !musicDisabled && activeAudioPlayer != audioPlayer1 {
      pauseAudio()
      activeAudioPlayer = audioPlayer1
      resumeAudio()
    }
  }
  
  func playMusic2() {
    if !musicDisabled && activeAudioPlayer != audioPlayer2 {
      pauseAudio()
      activeAudioPlayer = audioPlayer2
      resumeAudio()
    }
  }
  
}

extension AVAudioPlayer {
  func fade(toVolume endVolume : Float, overTime time : Float) {
    if endVolume == self.volume {
      return
    }
    // Update the volume every 1/100 of a second
    let fadeSteps:Int = Int(100 * time)
    // Work out how much time each step will take
    let timePerStep:Float = 1 / 100.0
    let startVolume = self.volume
    // Schedule a number of volume changes
    for step in 0...fadeSteps {
      let delayInSeconds:Float = Float(step) * timePerStep
      let popTime = DispatchTime.now() + Double(Int64(delayInSeconds * Float(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
      DispatchQueue.main.asyncAfter(deadline: popTime) {
        let fraction = (Float(step) / Float(fadeSteps))
        self.volume = startVolume + (endVolume - startVolume) * fraction
      }
    }
  }
}

func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
  //  Swift.print(items[0], separator:separator, terminator: terminator)
}

