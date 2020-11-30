//
//  GameScene.swift
//  color
//
//  Created by Harry Patsis on 4/29/15.
//  Copyright (c) 2015 Harry Patsis. All rights reserved.
//

import SpriteKit
import StoreKit


class MainMenuScene: SKScene {
//  var adDelegate:ADSceneDelegate?
  let appDelegate = UIApplication.shared.delegate as! AppDelegate
  
  typealias RectTuple = (sprite:SKSpriteNode, size:Int, velocity:CGVector)
  
  var scaleX:CGFloat = 1
  var normal1Button:SKSpriteNode
  var normal2Button:SKSpriteNode
  var frenzyButton:SKSpriteNode
  var frenzyLocked:Bool = false
  var activeTouch:UITouch?
  var activeButton:SKSpriteNode?
  var rects:[RectTuple] = []
  var shakeSpeedX:CGFloat = 0
  var shakeSpeedY:CGFloat = 0
  
  //buttons
  var bottomButtons:[SKSpriteNode?] = []

  override init(size: CGSize) {
//    normalButton = SKSpriteNode(imageNamed: "normalButton")
//    frenzyButton = SKSpriteNode(imageNamed: "frenzyButton")
    normal1Button = SKSpriteNode(imageNamed: "normal1MenuButton")
    normal2Button = SKSpriteNode(imageNamed: "normal2MenuButton")
    frenzyButton = SKSpriteNode(imageNamed: "frenzyMenuButton")

    super.init(size: size)
//    adDelegate = appDelegate.controller
    self.scaleX = appDelegate.scaleX
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("NSCoding not supported")
  }
  
  override func didMove(to view: SKView) {
    self.backgroundColor = UIColor(hue: 0.0, saturation: 0, brightness: 0.8, alpha: 1)
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(1.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
      self.addRects()
    }
    addLogos()
    addButtons()
    addBottomButtons()
    appDelegate.playMusic1()
    
//preload fonts
    let label1 = SKLabelNode(fontNamed:"HelveticaNeue-CondensedBold")
    label1.text = "preload"
    let label2 = SKLabelNode(fontNamed:"Avenir-Light")
    label2.text = "preload"
    
    checkAndShowRatingAlert()
  }
  
  
  func checkAndShowRatingAlert() {
    if let lastAlertDate = UserDefaults.standard.object(forKey: "lastAlertDate") as? Date {
      if UserDefaults.standard.bool(forKey: "rateAlertOn") {
        let secondsFromLastAlert = Date().timeIntervalSince(lastAlertDate)
        let secondsGameSession = Date().timeIntervalSince(appDelegate.gameStartDate as Date)
        if secondsGameSession > 180 && secondsFromLastAlert > 86400 { // 60 * 60 * 24
          DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(2 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) {
            self.appDelegate.controller!.showRatingAlert()
          }
        }
      }
    }
  }
  
  func addLogos() {
    let logoNode1 = SKSpriteNode(imageNamed: "color4")
    logoNode1.position = CGPoint(x:self.size.width/2,y:0.85 * self.size.height)
    logoNode1.zPosition = 1
    addChild(logoNode1)
    
    let logos = [SKSpriteNode(imageNamed: "logo1"), SKSpriteNode(imageNamed: "logo2"), SKSpriteNode(imageNamed: "logo3"), SKSpriteNode(imageNamed: "logo4")]
    for (index, logo) in logos.enumerated() {
      if (appDelegate.appDidShowJustNow) {
        logo.alpha = 0
        let w = logo.size.width
        let h = logo.size.height
        logo.position = CGPoint(x:self.size.width - 20 - 0.7 * w, y:-40 + 0.8 * h )
        logo.setScale(2)
        logo.zPosition = 1
        addChild(logo)
        let wait = SKAction.wait(forDuration: 1.2 + 0.2 * Double(index))
        let fadein = SKAction.fadeIn(withDuration: 0.5)
        let move = SKAction.moveBy(x: 20, y: 40, duration: 0.5)
        let scale = SKAction.scale(to: 1, duration: 0.5)
        let group = SKAction.group([fadein, move, scale])
        let sequence = SKAction.sequence([wait, group])
        logo.run(sequence)
      } else {
        let w = logo.size.width
        let h = logo.size.height
        logo.position = CGPoint(x:self.size.width - 0.7 * w, y:0.8 * h )
        logo.zPosition = 1
        addChild(logo)
      }
    }
    appDelegate.appDidShowJustNow = false
  }
  
  func addButtons() {
    let buttonHeight = normal1Button.size.height + 10
    let space:CGFloat = 20.0
    normal1Button.position = CGPoint(x: -normal1Button.size.width, y: self.size.height/2 + buttonHeight * 1.2)
    normal1Button.zPosition = 1
    addChild(normal1Button)

    normal2Button.position = CGPoint(x: -normal2Button.size.width, y: self.size.height/2)
    normal2Button.zPosition = 1
    addChild(normal2Button)

    
    frenzyButton.position = CGPoint(x: -frenzyButton.size.width, y: self.size.height/2 - buttonHeight * 1.2)
    frenzyButton.zPosition = 1
    addChild(frenzyButton)
    
    //show frenzy lock?

    let stars:[Int] = (UserDefaults.standard.object(forKey: "normalstars") ?? []) as! [Int]
    let starsNeeded = max(20 - stars.count,0)
    if (starsNeeded>0) {
      let locked = SKSpriteNode(imageNamed: "frenzyLocked")
      locked.name = "frenzylock"
      locked.position = CGPoint(x: 2, y: 11 + (locked.size.height - frenzyButton.size.height) / 2)
      frenzyButton.addChild(locked)
      let labelLock = SKLabelNode(fontNamed:"Avenir-HeavyOblique")
      labelLock.text = String(starsNeeded)
      labelLock.verticalAlignmentMode = .center
      labelLock.position = CGPoint(x: -55, y: 10 + (locked.size.height - frenzyButton.size.height) / 2)
      frenzyButton.addChild(labelLock)
      labelLock.name = "frenzylabel"
      frenzyLocked = true
    } else  {
      let frenzyUnlocked = UserDefaults.standard.bool(forKey: "frenzyunlocked")
      if (!frenzyUnlocked) {
        let locked = SKSpriteNode(imageNamed: "frenzyLocked")
        locked.name = "frenzylock"
        locked.position = CGPoint(x: 2, y: 11 + (locked.size.height - frenzyButton.size.height) / 2)
        frenzyButton.addChild(locked)
        let labelLock = SKLabelNode(fontNamed:"Avenir-HeavyOblique")
        labelLock.text = String(starsNeeded)
        labelLock.verticalAlignmentMode = .center
        labelLock.position = CGPoint(x: -55, y: 10 + (locked.size.height - frenzyButton.size.height) / 2)
        frenzyButton.addChild(labelLock)
        labelLock.name = "frenzylabel"
        
        let star = SKSpriteNode(imageNamed: "smallStar")
        star.colorBlendFactor = 1
        star.color = UIColor(hue: 49.0 / 360.0, saturation: 1, brightness: 1, alpha: 1)
        star.position = CGPoint(x: -97, y: 12+(locked.size.height - frenzyButton.size.height) / 2)
        star.setScale(0.3)
        star.alpha = 0.7
        star.run(SKAction.sequence([SKAction.wait(forDuration: 1), SKAction.fadeOut(withDuration: 2)]))
        star.run(SKAction.sequence([SKAction.scale(to: 1.5, duration: 3), SKAction.removeFromParent()]))
        frenzyButton.addChild(star)
        let action = SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: 2), SKAction.removeFromParent()])
        locked.run(action)
        labelLock.run(action)
        UserDefaults.standard.set(true, forKey: "frenzyunlocked")
      }
      frenzyLocked = false
    }
    
    let actionNormal1 = SKAction.moveTo(x: space + normal1Button.size.width/2, duration: 0.6)
    actionNormal1.timingMode = SKActionTimingMode.easeInEaseOut
    normal1Button.run(actionNormal1)

    let actionNormal2 = SKAction.moveTo(x: self.size.width/2, duration: 0.8)
    actionNormal2.timingMode = SKActionTimingMode.easeInEaseOut
    normal2Button.run(actionNormal2)

    let actionFrenzy = SKAction.moveTo(x: self.size.width - frenzyButton.size.width/2 - space, duration: 1)
    actionFrenzy.timingMode = SKActionTimingMode.easeInEaseOut
    frenzyButton.run(actionFrenzy)
  }
  
  
  func updateButtons() {
    for case let button? in bottomButtons {
      button.run(SKAction.sequence([SKAction.scale(to: 0, duration: 0.1), SKAction.removeFromParent()]))
    }
    addBottomButtons()
  }
  
  
  func addBottomButtons() {
    bottomButtons = []
    var pos:CGFloat = 1
    let delay:Double = 0.5
    let wait:Double = 0.1

    addBottomButton("howToPlay", delay:delay, pos: pos)
//    pos+=1
//    addBottomButton("removeAds", delay: delay + wait * Double(pos), pos: pos)
    pos+=1
    addBottomButton("rateApp", delay: delay + wait * Double(pos), pos: pos)
    pos+=1
    addBottomButton("contactUs", delay: delay + wait * Double(pos), pos: pos)
    pos+=1
    addBottomButton(appDelegate.musicDisabled ? "musicOff" : "musicOn", delay: delay + wait * Double(pos), pos: pos)
    pos+=1
  }
  
  func disableScene() {
    self.isUserInteractionEnabled = false
  }

  func enableScene() {
    self.isUserInteractionEnabled = true
  }
  
  
  func addBottomButton(_ name:String, delay:TimeInterval, pos:CGFloat) {
    let button = SKSpriteNode(imageNamed: name)
    button.position = CGPoint(x: 60 + (pos-1) * 100, y: 60)
    button.setScale(0.2)
    button.alpha = 0
    button.name = name
    button.zPosition = 1
    addChild(button)
    let wait = SKAction.wait(forDuration: delay)
    let scale1 = SKAction.scale(to: 1.3, duration: 0.2)
    let scale2 = SKAction.scale(to: 1.0, duration: 0.1)
    let alpha = SKAction.fadeAlpha(to: 1, duration: 0.05)
    button.run(SKAction.sequence([wait, SKAction.group([alpha, SKAction.sequence([scale1, scale2])])]))
    bottomButtons.append(button)
  }
  
  
  func addRects() {
    for _ in 0 ..< 16 {
      let r = CGFloat(arc4random_uniform(360)) * CGFloat(Double.pi) / 180.0
      let color = UIColor(white: 1, alpha: 0.1 + CGFloat(arc4random_uniform(20))/100.0)
      let size = Int(arc4random_uniform(50) + 75)
      let sprite:SKSpriteNode = SKSpriteNode(color: color, size: CGSize(width: size, height: size))
      sprite.position = CGPoint(x: cos(r) * 100 + self.size.width/2, y: sin(r) * 100 + self.size.height/2)
      rects.append((sprite: sprite, size: size, velocity:CGVector(dx: 0,dy: 0)))
      sprite.alpha = 0
      sprite.zPosition = 0
      let duration = 0.0//Double(arc4random_uniform(50)/100) + 0.1
      sprite.run(SKAction.sequence([SKAction.wait(forDuration: duration), SKAction.fadeIn(withDuration: 0.2)]))
      addChild(sprite)
    }
  }
  
  
//  func touchedButton(touch:UITouch, buttons:[SKSpriteNode?])->SKSpriteNode? {
//    var node:SKSpriteNode?
//    var maxz:CGFloat = -1
//    for button:SKSpriteNode? in buttons {
//      if (button != nil ) {
//        let rect = button!.frame
//        let point = touch.locationInNode(button!.parent!)
//        
//        if CGRectContainsPoint(rect, point) {
//          if (maxz < button!.zPosition) {
//            node = button
//            maxz = button!.zPosition
//          }
//        }
//      }
//    }
//    return node
//  }

  func touchedButton(_ touch:UITouch, buttons:[SKSpriteNode?])->SKSpriteNode? {
    var node:SKSpriteNode?
    var maxz:CGFloat = -1
    for btn in buttons {
      if let button = btn {
        let rect = button.frame
        let point = touch.location(in: button.parent!)
        
        if rect.contains(point) {
          if (maxz < button.zPosition) {
            node = button
            maxz = button.zPosition
          }
        }
      }
    }
    return node
  }
  
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    /* Called when a touch begins */
    if (activeTouch == nil) {
      if let touch = touches.first{
        let pos = touch.location(in: self)
        if (self.atPoint(pos) == normal1Button) {
          activeButton = normal1Button
          activeTouch = touch
          return
        } else if (self.atPoint(pos) == normal2Button) {
          activeButton = normal2Button
          activeTouch = touch
          return
        } else if (self.atPoint(pos) == frenzyButton) {
          activeButton = frenzyButton
          activeTouch = touch
          return
        }
        if let button = touchedButton(touch, buttons: bottomButtons) {
          button.run(SKAction.scale(to: 1.3, duration: 0.1))
          activeButton = button
          activeTouch = touch
          return
        }
      }
    }
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = activeTouch {
      let newActiveNode = touchedButton(touch, buttons: bottomButtons)
      if (newActiveNode != activeButton) {
        if (activeButton!.xScale>1.0) {
          activeButton!.run(SKAction.scale(to: 1.0, duration: 0.1))
        }
      } else {
        activeButton!.run(SKAction.scale(to: 1.3, duration: 0.1))
      }
      return
    }
  }
  


  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    defer {
      activeTouch = nil
      activeButton = nil
    }
    guard let touch = activeTouch, touches.contains(touch) else {
      return
    }
    guard let button = activeButton else {
      return
    }
    
    if ([normal1Button, normal2Button, frenzyButton].contains(button)) {
      let pos = touch.location(in: self)
      if (self.atPoint(pos) == activeButton) {
        if frenzyLocked  == true && activeButton == frenzyButton {
          let action1 = SKAction.scale(to: 1.5, duration: 0.15)
          let action2 = SKAction.scale(to: 1, duration: 0.15)
          if let spr2 = frenzyButton.childNode(withName: "frenzylabel") {
            spr2.run(SKAction.sequence([action1, action2]))
          }
        } else {
          self.run(appDelegate.clickSoundAction)
//          let whiteNode = activeButton == frenzyButton ? SKSpriteNode(imageNamed: "frenzyButtonWhite") : SKSpriteNode(imageNamed: "normalButtonWhite")
          let whiteNode = SKSpriteNode(imageNamed: "whiteMenuButton")
          whiteNode.alpha = 0
          whiteNode.position = activeButton!.position
          whiteNode.zPosition = 1
          addChild(whiteNode)
          
          whiteNode.run(SKAction.sequence([
            SKAction.fadeIn(withDuration: 0.3),
            SKAction.wait(forDuration: 0.1),
            SKAction.fadeOut(withDuration: 0.5),
            SKAction.removeFromParent()
            ]))
          
          DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(1 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) {
            if button == self.normal1Button {
              self.appDelegate.setGameType(type: 0)
            } else if button == self.normal2Button {
              self.appDelegate.setGameType(type: 1)
            } else {
              self.appDelegate.setGameType(type: 2)
            }
            self.showMenuScene()
          }
        }
      }
    }
    let buttons = bottomButtons
    let flatbuttons = buttons.compactMap{$0}
    if (flatbuttons.contains(button)) {
      guard let touchedButton = touchedButton(touch, buttons: buttons) else {
        return
      }

      if touchedButton == activeButton {
        //button touched
        if (activeButton?.name == "howToPlay") {
          self.run(appDelegate.clickSoundAction)
          self.isUserInteractionEnabled = false
          let scene = HowScene(size: self.size)
          let color = UIColor(hue: 204/365, saturation: 1, brightness: 0.83, alpha: 1)
          self.presentScene(scene, center:activeButton!.position, color:color, transitionDuration: 0.6)
        } else if (activeButton?.name == "rateApp") {
          self.run(appDelegate.clickSoundAction)
          appDelegate.controller?.rateApp()
        } else if activeButton?.name == "contactUs" {
          self.run(appDelegate.clickSoundAction)
          appDelegate.controller?.sendEmail()
        } else if activeButton?.name == "musicOff" {
          appDelegate.musicDisabled = false
          activeButton?.texture = SKTexture(imageNamed: "musicOn")
          activeButton?.name = "musicOn"
        } else if activeButton?.name == "musicOn" {
          appDelegate.musicDisabled = true
          activeButton?.texture = SKTexture(imageNamed: "musicOff")
          activeButton?.name = "musicOff"
        }
      }
      touchedButton.run(SKAction.sequence([SKAction.wait(forDuration: 0.1), SKAction.scale(to: 1.0, duration: 0.1)]))
    }
  }
  
  func showMenuScene() {
    let scene = MenuScene(size: self.size)
    scene.scaleMode = .aspectFit    
    scene.scaleX = scaleX

    let transition:SKTransition = SKTransition.crossFade(withDuration: 1)
//    scene.adDelegate = self.adDelegate
    self.view?.presentScene(scene, transition: transition)
  }
  
  
  func shakeScene() {
    shakeSpeedX = 3
    shakeSpeedY = 3
  }
  
  override func update(_ currentTime: TimeInterval) {
    updateShaderTransition(currentTime)

    //rects
    let factor:CGFloat = 1
    let factorC:CGFloat = -80
    let center:CGVector = CGVector(dx: self.size.width/2, dy: self.size.height/2)
    for (i, irect): (Int, RectTuple) in rects.enumerated() {
      let dx = irect.sprite.position.x - center.dx;
      let dy = irect.sprite.position.y - center.dy;
      let angle = atan2(dy,dx)
      let dist = sqrt(dx * dx + dy * dy)
      let iv = CGVector(dx: cos(angle)  * dist / (factorC), dy: sin(angle) * dist / (factorC))
      rects[i].velocity = CGVector(dx:irect.velocity.dx + iv.dx + shakeSpeedX*dx/100, dy:irect.velocity.dy + iv.dy * 0.6 + shakeSpeedY*dy/200)
    }
    shakeSpeedX = shakeSpeedX * 0.75
    shakeSpeedY = shakeSpeedY * 0.75
    for (i, irect): (Int, RectTuple) in rects.enumerated() {
      for (j, jrect): (Int, RectTuple) in rects.enumerated() {
        if (i != j) {
          let dx = irect.sprite.position.x - jrect.sprite.position.x;
          let dy = irect.sprite.position.y - jrect.sprite.position.y;
          let angle = atan2(dy,dx)
          let dist = sqrt(dx * dx + dy * dy)
          let iv = CGVector(dx: CGFloat(jrect.size) * cos(angle) / (factor * dist), dy: CGFloat(jrect.size) * sin(angle) / (factor * dist))
          let jv = CGVector(dx: CGFloat(irect.size) * cos(angle) / (factor * dist), dy: CGFloat(irect.size) * sin(angle) / (factor * dist))
          rects[i].velocity = CGVector(dx:irect.velocity.dx + iv.dx, dy:irect.velocity.dy + iv.dy)
          rects[j].velocity = CGVector(dx:jrect.velocity.dx - jv.dx, dy:jrect.velocity.dy - jv.dy)
        }
      }
    }
    
    for (_, irect): (Int, RectTuple) in rects.enumerated() {
      irect.sprite.position = CGPoint(x: irect.sprite.position.x + irect.velocity.dx, y: irect.sprite.position.y + irect.velocity.dy)
    }
    
    for (i, irect): (Int, RectTuple) in rects.enumerated() {
      rects[i].velocity = CGVector(dx:irect.velocity.dx * 0.33, dy:irect.velocity.dy * 0.33)
    }
  }

  
  
}
