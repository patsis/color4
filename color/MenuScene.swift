//
//  GameScene.swift
//  color
//
//  Created by Harry Patsis on 4/29/15.
//  Copyright (c) 2015 Harry Patsis. All rights reserved.
//

import SpriteKit
import UIKit

class MenuScene: SKScene {
  let appDelegate = UIApplication.shared.delegate as! AppDelegate
  var scaleX:CGFloat = 1
  var levelCount:Int = 0
  var levelSelected:Int = -1
  
  var backButton:SKSpriteNode
  weak var activeNode:SKNode?
  
  //scrolling menu
  let levelWidth:CGFloat = 350
  var levels:[SKSpriteNode] = []
  let container:SKNode = SKNode()
  var rightLimit:CGFloat = 0
  var leftLimit:CGFloat = 0
  var panVelocity:CGFloat = 0
  weak var activeTouch:UITouch?
  var isScrolling = false
  var lastTimestamp:CFTimeInterval = 0
  var lastUpdateTime:CFTimeInterval = 0
  
  //stars
  var stars:[Int] = []
  
  //textures
  let selectTexture = SKTexture(imageNamed:  "menuSelect")
  let hilightTexture = SKTexture(imageNamed: "menuSelectHilight")
  let grey4Texture = SKTexture(imageNamed: "grey4")

  var unlockedLevel = 0
  
  override init(size: CGSize) {
    backButton = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 60, height: 60))
    super.init(size: size)
    scaleMode = .aspectFit
    
    if let levels = appDelegate.jsonLevels {
      levelCount = levels.count
    }
    unlockedLevel = appDelegate.unlockedLevel
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("NSCoding not supported")
  }
  
  override func didMove(to view: SKView) {
    scaleMode = .aspectFit
    self.backgroundColor = UIColor(hue: 0.0, saturation: 0.0, brightness: 0.8, alpha: 1)

    self.addChild(container)
    loadScrollPosition()

    loadStars()
    createLevels()
    
    let bbb = SKSpriteNode(imageNamed: "backButton")
    backButton.addChild(bbb)
    backButton.position = CGPoint(x: backButton.size.width*0.5, y: self.size.height - backButton.size.height*0.5)
    self.addChild(backButton)

    
    let labelmode = SKLabelNode(fontNamed:"Avenir-Light")
    switch appDelegate.gameType {
      case 0: labelmode.text = "N O R M A L  I"
      case 1: labelmode.text = "N O R M A L  II"
      default: labelmode.text = "F R E N Z Y"
    }

    labelmode.fontSize = 50
    labelmode.position = CGPoint(x: size.width/2, y: 4.4 * size.height/5)
    self.addChild(labelmode)
    
    
    let label = SKLabelNode(fontNamed:"Avenir-Light")
    label.text = "Select level"
    label.fontSize = 58
    label.position = CGPoint(x: size.width/2, y: 3.7 * size.height/5)
    self.addChild(label)
    
//    checkInterstitialDate()
  }
  
  
  func spriteFromShapes(_ level:Int) -> SKSpriteNode {
    UIGraphicsBeginImageContextWithOptions(CGSize(width: 280, height: 280), true, 0)
    let context = UIGraphicsGetCurrentContext()
    context?.setFillColor(UIColor.gray.cgColor)
    context?.setStrokeColor(UIColor.white.cgColor)
    context?.setLineWidth(1)
    
    if (level > unlockedLevel) {
      let path = CGMutablePath()
      let menuScaleX = scaleX * 260.0 / self.size.width
      let mv:CGFloat = 10
      path.move(to: CGPoint(x: mv + menuScaleX * 0, y: mv + menuScaleX * 0)) //CGPathMoveToPoint(path, nil, mv + menuScaleX * 0, mv + menuScaleX * 0)
      path.addLine(to: CGPoint(x: mv + menuScaleX * 640, y: mv + menuScaleX * 0)) //CGPathAddLineToPoint(path, nil, mv + menuScaleX * 640, mv + menuScaleX * 0)
      path.addLine(to: CGPoint(x: mv + menuScaleX * 640, y: mv + menuScaleX * 640)) //CGPathAddLineToPoint(path, nil, mv + menuScaleX * 640, mv + menuScaleX * 640)
      path.addLine(to: CGPoint(x: mv + menuScaleX * 0, y: mv + menuScaleX * 640)) //CGPathAddLineToPoint(path, nil, mv + menuScaleX * 0, mv + menuScaleX * 640)
      path.addLine(to: CGPoint(x: mv + menuScaleX * 0, y: mv + menuScaleX * 0)) //CGPathAddLineToPoint(path, nil, mv + menuScaleX * 0, mv + menuScaleX * 0)
      path.closeSubpath()
      context?.addPath(path)
      context?.drawPath(using: .fillStroke);
    } else {
      if let levels = appDelegate.jsonLevels {
        if let shapes = levels[level]["shapes"] as? [[String: AnyObject]] {
          for shape in shapes {
            if let points = shape["points"] as? [Float] {
              let path = CGMutablePath()
              let menuScaleX = scaleX * 260.0 / self.size.width
              var idx:Int = 2
              let mv:CGFloat = 10
              path.move(to: CGPoint(x: mv + menuScaleX * CGFloat(points[0]),
                                    y: mv + menuScaleX * CGFloat(points[1])))
              while idx < points.count {
                path.addCurve(      to: CGPoint(x: mv + menuScaleX * CGFloat(points[idx+4]), y:mv + menuScaleX * CGFloat(points[idx+5])),
                              control1: CGPoint(x: mv + menuScaleX * CGFloat(points[idx+0]), y:mv + menuScaleX * CGFloat(points[idx+1])),
                              control2: CGPoint(x: mv + menuScaleX * CGFloat(points[idx+2]), y:mv + menuScaleX * CGFloat(points[idx+3])))
                idx+=6
              }
              path.closeSubpath()
              context?.addPath(path)
              context?.drawPath(using: CGPathDrawingMode.fillStroke);
            }
          }
        }
      }
    }
// mx, my, c1x, c1y, c2x, x2t, px, py, 
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    let texture = SKTexture(image: image!)
    let sprite = SKSpriteNode(texture: texture)
    sprite.position = CGPoint(x: 0, y: 0)
    
    
    if (level > unlockedLevel) {
      let grey4 = SKSpriteNode(texture: grey4Texture)
      grey4.position = CGPoint(x: -10, y: 0)
      grey4.alpha = 0.5
      sprite.addChild(grey4)
    }
    return sprite
  }
  
  func loadStars() {
    let name = appDelegate.getStarsName()
    stars = (UserDefaults.standard.object(forKey: name) ?? []) as! [Int]
  }
  
  func createLevels() {
    let levelsAllowed = min(levelCount, unlockedLevel+3)
    rightLimit = self.size.width / 2 - self.levelWidth / 3
    leftLimit = self.size.width / 2 - CGFloat(levelsAllowed) * self.levelWidth + self.levelWidth / 3

    for index in 0...(self.levelCount-1) {
      let levelNode = SKSpriteNode(texture: self.selectTexture)
      levelNode.zPosition = 0
      let xPos = self.levelWidth / 2 + CGFloat(index) * self.levelWidth
      levelNode.position = CGPoint(x:xPos, y:self.size.height/2)

      let glow = SKSpriteNode(texture: self.hilightTexture)
      glow.zPosition = 2
      glow.position = CGPoint(x: -5, y: 5)
      levelNode.addChild(glow)
      
      let label = SKLabelNode(fontNamed:"HelveticaNeue-CondensedBold")
      label.text = String(index+1)
      label.fontSize = 36
      label.position = CGPoint(x: -105, y: 90)
      label.alpha = 0.75
      label.zPosition = 10
      levelNode.addChild(label)
      
      self.container.addChild(levelNode)
      self.levels.append(levelNode)
    }
    
    
//    let priority = DispatchQueue.GlobalQueuePriority.default
//    DispatchQueue.global(priority: priority).async {
    DispatchQueue.global().async {
      for index in 0...(self.levelCount-1) {
        let levelNode = self.levels[index]
        let sprite = self.spriteFromShapes(index)
        
        sprite.zPosition = 1
        sprite.position = CGPoint(x: -5, y: 5)
        sprite.alpha = 0
        sprite.run(SKAction.fadeAlpha(to: 1, duration: 0.2))
        levelNode.addChild(sprite)
        
        if index <= self.unlockedLevel {
          let star = SKSpriteNode(imageNamed: "smallStar")
          star.colorBlendFactor = 1
          if self.stars.contains(index) {
            star.color = UIColor(hue: 49.0 / 360.0, saturation: 1, brightness: 1, alpha: 1)
          } else {
            star.color = UIColor(hue: 0.0, saturation: 0, brightness: 0.4, alpha: 1)
          }
          star.alpha = 0
          star.position = CGPoint(x: -100, y: -90)
          star.zPosition = 9
          star.run(SKAction.fadeAlpha(to: 1, duration: 0.2))
          levelNode.addChild(star)
        }
      }
    }
  }
  
  func touchedButton(_ point:CGPoint)->SKNode? {
    var node:SKNode?
    var maxz:CGFloat = -1
    for button:SKNode in [backButton] {
      let rect = button.frame
      if rect.contains(point) {
        if (maxz < button.zPosition) {
          node = button
          maxz = button.zPosition
        }
      }
    }
    return node
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    /* Called when a touch begins */
    if (activeTouch == nil) {
      activeTouch = touches.first
      if (activeNode == nil) {
        let point = activeTouch!.location(in: self)
        if let button = touchedButton(point) {
          activeNode = button
          let scale = SKAction.scale(to: 1.3, duration: 0.1);
          activeNode!.run(scale);
          return
        }
      }
      lastTimestamp = event!.timestamp
      lastUpdateTime = event!.timestamp
    }
  }

  
  func distance(_ first: CGPoint, second: CGPoint) -> CGFloat{
    return CGFloat(hypotf(Float(second.x - first.x), Float(second.y - first.y)));
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    if (touches.contains(activeTouch!)) {
      if let touch = activeTouch {
        let point = touch.location(in: self)
        if activeNode != nil {
          let newActiveNode = touchedButton(point)
          if (newActiveNode != activeNode) {
            activeNode?.run(SKAction.scale(to: 1.0, duration: 0.1))
          } else {
            activeNode?.run(SKAction.scale(to: 1.3, duration: 0.1))
          }
          return
        }
      }
    }
    
    for touch in (touches ) {
      let newPos = touch.location(in: self)
      let oldPos = touch.previousLocation(in: self)
      let dist = distance(newPos, second: oldPos)
      if (dist > 0) {
        let timestamp = event!.timestamp
        panVelocity = (newPos.x - oldPos.x) / CGFloat(timestamp - lastTimestamp)
        lastTimestamp = timestamp
        isScrolling = true
      }
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    if (touches.contains(activeTouch!)) {
      if let touch = activeTouch {
        let point = touch.location(in: self)
        if activeNode != nil {
          let newActiveNode = touchedButton(point)
          if (newActiveNode == activeNode) {
            activeNode?.setScale(1.3)
            activeNode?.run(SKAction.scale(to: 1.0, duration: 0.1))
            self.run(appDelegate.clickSoundAction)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
              self.showMainMenu()
            }
          }
          activeTouch = nil
          activeNode = nil
          return
        }
      }
      
      if (isScrolling) {
        isScrolling = false
      } else {
        let point = activeTouch!.location(in: container)
        for i in 0...unlockedLevel {
          let level = levels[i]
          if (level.contains(point)) {
            if (levelSelected != i) {
              levelSelected = i
              hilightLevel(levelSelected)
              self.run(appDelegate.clickSoundAction)
              DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(1 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) {
                self.showLevel(self.levelSelected)
              }
            }
            break
          }
        }
      }
      activeTouch = nil
    }
  }
  
  func showMainMenu() {
    saveScrollPosition()
    let scene = MainMenuScene(size: self.size)
    scene.scaleX = scaleX
    scene.scaleMode = .aspectFit
    let transition:SKTransition = SKTransition.crossFade(withDuration: 1)
//    scene.adDelegate = self.adDelegate
    self.view?.presentScene(scene, transition: transition)
  }
  
  
  func showLevel(_ index:Int) {
    saveScrollPosition()
    let scene = GameScene(index: index, size: self.size)
    scene.scaleX = scaleX
    scene.scaleMode = .aspectFit
    let transition:SKTransition = SKTransition.crossFade(withDuration: 1)
//    scene.adDelegate = self.adDelegate
    self.view?.presentScene(scene, transition: transition)
  }
  
  func hilightLevel(_ i:Int) {
    let level = levels[i]
    var size = level.size
    size.width -= 10
    size.height -= 10
    let whiteNode = SKSpriteNode(color: UIColor.white, size: size)
    whiteNode.alpha = 0
    whiteNode.zPosition = 100
    whiteNode.position = CGPoint(x: -5, y: 5)
    level.addChild(whiteNode)
    
    whiteNode.run(SKAction.sequence([
      SKAction.fadeIn(withDuration: 0.3),
      SKAction.wait(forDuration: 0.1),
      SKAction.fadeOut(withDuration: 0.5),
      SKAction.removeFromParent()
      ]))
  }
  
  func loadScrollPosition() {
    container.position.x = appDelegate.scrollPosition
  }
  
  func saveScrollPosition() {
    appDelegate.scrollPosition = container.position.x
  }
  
  func moveLevels(_ translation:CGFloat) {
    if (container.position.x + translation > rightLimit) {
      container.position.x = rightLimit
      panVelocity = -0.15 * panVelocity
    } else if (container.position.x + translation < leftLimit) {
      container.position.x = leftLimit
      panVelocity = -0.5 * panVelocity
    } else {
      container.position.x += translation
    }
  }
  
  override func update(_ currentTime: TimeInterval) {
    /* Called before each frame is rendered */
    //scroll
    if panVelocity != 0 {
      let translation = panVelocity * CGFloat(currentTime - lastUpdateTime)
      self.moveLevels(translation)
      panVelocity = panVelocity * 0.8
      if (abs(panVelocity) < 0.0001) {
        panVelocity = 0
      }
    }
      lastUpdateTime = currentTime
  }
}
