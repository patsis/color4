//
//  GameViewController.swift
//  color
//
//  Created by Harry Patsis on 4/29/15.
//  Copyright (c) 2015 Harry Patsis. All rights reserved.
//

import UIKit
import SpriteKit
import MessageUI
import StoreKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}




class GameViewController: UIViewController, MFMailComposeViewControllerDelegate, SKStoreProductViewControllerDelegate {
  
  let appDelegate = UIApplication.shared.delegate as! AppDelegate
  var ScreenHeight = UIScreen.main.bounds.height
  
// MARK: - Initialization

  required  init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    appDelegate.controller = self
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //INITIALIZATION FOR RATE ALERT
    //initialize lastAlertDate
    let lastAlertDate = UserDefaults.standard.object(forKey: "lastAlertDate") as? Date
    if lastAlertDate == nil {
      UserDefaults.standard.set(Date(), forKey: "lastAlertDate")
    }
    
    let currentAppVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
    let appVersion = UserDefaults.standard.string(forKey: "appVersion")
    if (appVersion != currentAppVersion) {
      UserDefaults.standard.set(true, forKey: "rateAlertOn")
      UserDefaults.standard.set(currentAppVersion, forKey: "appVersion")
    }
    
    let scene = MainMenuScene(size: appDelegate.viewSize)
    scene.scaleX = appDelegate.scaleX

    
    scene.scaleMode = .aspectFit
    let skView = self.view as! SKView
    skView.ignoresSiblingOrder = false
//    skView.showsFPS = true
    skView.presentScene(scene)
  }

  
  // MARK: - UIControlView
  override func viewWillAppear(_ animated: Bool) {
  }
  
  override func viewWillDisappear(_ animated: Bool) {
//    if let ads = iADBanner {
//      ads.delegate = nil
//      ads.removeFromSuperview()
//    }
  }
  
  override var shouldAutorotate : Bool {
    return true
  }
  
  override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
    if UIDevice.current.userInterfaceIdiom == .phone {
      return UIInterfaceOrientationMask.allButUpsideDown
    } else {
      return UIInterfaceOrientationMask.all
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Release any cached data, images, etc that aren't in use.
  }
  
  override var prefersStatusBarHidden : Bool {
    return true
  }
  
  override var canBecomeFirstResponder : Bool {
    return true
  }
  
  
  
  //MARK: - Motion gesture
  
  override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
    if motion == .motionShake {
      let skView = self.view as! SKView
      if let mainMenuScene:MainMenuScene = skView.scene as? MainMenuScene {
        mainMenuScene.shakeScene()
      }
    }
  }
  

  func dontRate() {
    UserDefaults.standard.set(false, forKey: "rateAlertOn")
  }
  
  func remindMeLater() {
    
  }
  
  func rateApp() {
    UserDefaults.standard.set(false, forKey: "rateAlertOn")
    let systemVersion = Float(UIDevice.current.systemVersion)
    if systemVersion >= 8 {
      let storeViewController = SKStoreProductViewController()
      let params = [
        SKStoreProductParameterITunesItemIdentifier:1014131791,
      ]
      storeViewController.delegate = self
      storeViewController.loadProduct(withParameters: params, completionBlock: nil)
      present(storeViewController, animated: true) { () -> Void in }
      //Use the standard openUrl method
    } else {
      UIApplication.shared.openURL(URL(string: "itms-apps://itunes.apple.com/app/id1014131791")!)
    }
  }

  func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
    viewController.dismiss(animated: true, completion: nil)
  }
  
  
  func showRatingAlert() {
    UserDefaults.standard.set(Date(), forKey: "lastAlertDate")
    let title = "We need your help"
    let message = "If you enjoy using color4, would you mind taking a moment to rate it? It won't take more than a minute. Thanks for your support!"

    let alertView : UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    let cancelAction = UIAlertAction(title: "No, Thanks", style:.cancel, handler: {(alert: UIAlertAction!) in
      self.dontRate()
    })
    let laterAction = UIAlertAction(title: "Remind me later", style:.default, handler: {(alert: UIAlertAction!) in
      self.remindMeLater()
    })
    let rateAction = UIAlertAction(title: "Rate Color4", style:.default, handler: {(alert: UIAlertAction!) in
      self.rateApp()
    })
    alertView.addAction(cancelAction)
    alertView.addAction(rateAction)
    alertView.addAction(laterAction)
    
    // get the top most controller (= the StoreKit Controller) and dismiss it
    present(alertView, animated: true) { () -> Void in}
  }
  

// MARK: - MAIL
  func sendEmail() {
    if MFMailComposeViewController.canSendMail() {
      let mail = MFMailComposeViewController()
      mail.mailComposeDelegate = self
      mail.setToRecipients(["hpappinfo@gmail.com"])
      present(mail, animated: true, completion: nil)
    } else {
      // show failure alert
    }
  }
  
  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    controller.dismiss(animated: true, completion: nil)
  }
}


