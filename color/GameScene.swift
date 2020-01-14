//
//  GameScene.swift
//  color
//
//  Created by Harry Patsis on 4/29/15.
//  Copyright (c) 2015 Harry Patsis. All rights reserved.
//

import SpriteKit

//extension Array {
//  func forEach(doThis: (element: Element) -> Void) {
//    for e in self {
//      doThis(element: e)
//    }
//  }
//}

//protocol ADSceneDelegate {
//  func bannerHeight()->CGFloat
//  func showAds()
//  func hideAds()
//  func showInterstitial()
//  func purchased()->Bool
//}

class GameScene: SKScene {
  let appDelegate = UIApplication.shared.delegate as! AppDelegate
//  var adDelegate:ADSceneDelegate?
  
  //properties
  var scaleX:CGFloat = 1
  var scaleXiPad:CGFloat = 1
  
  var unlockCount = 1
  var levelIndex:Int = -1
  
  //menu
  var blurredNode:SKSpriteNode?
  var menuShowing:Bool = false
  var menuButton:SKSpriteNode?
  var mainMenuButton:SKSpriteNode?
  var continueButton:SKSpriteNode?
  var restartButton:SKSpriteNode?
  var nextLevelButton:SKSpriteNode?
  var starOutline:SKSpriteNode?
  
  //nodes
  var backgroundNode:SKSpriteNode
  var container:SKSpriteNode
  let levelWidth:CGFloat = 350
  var shapes = [SKShapeNode:(id:Int,colorIndex:Int, prevColorIndex:Int)]()
  var activeTouch:UITouch?
  var activeShape:SKShapeNode?
  var pauseButton:SKSpriteNode
  
  //color buttons
  var blueButton:SKSpriteNode
  var greenButton:SKSpriteNode
  var purpleButton:SKSpriteNode
  var orangeButton:SKSpriteNode
  
  //UIColors
  let grayColor = UIColor(hue: 0.0, saturation: 0.0, brightness: 0.5, alpha: 1)
  let blueColor = UIColor(hue: 204/365, saturation: 1, brightness: 0.83, alpha: 1)
  let greenColor = UIColor(hue: 148/365, saturation: 1, brightness: 0.63, alpha: 1)
  let orangeColor = UIColor(hue: 19/365, saturation: 0.86, brightness: 0.96, alpha: 1)
  let purpleColor =  UIColor(hue: 283/365, saturation: 0.59, brightness: 0.6, alpha: 1)
  
  //
  weak var activeColorButton:SKNode?
  weak var activeNode:SKNode?
  
  //star collect

  var colorUndone:Bool = false
  let successMessage = ["Success!", "Well done!", "Good job!", "Job done!", "Great job!", "Nice!", "Bravo!", "You won!", "Nice work!"]
  
  override init(size: CGSize) {
    backgroundNode = SKSpriteNode(color: UIColor(hue: 0.0, saturation: 0.0, brightness: 0.6, alpha: 1), size: size)
    container = SKSpriteNode(imageNamed: "levelBackground")
    pauseButton = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 60, height: 60))//SKSpriteNode(imageNamed: "pauseButton")
    blueButton = SKSpriteNode(imageNamed: "blue1")
    greenButton = SKSpriteNode(imageNamed: "green1")
    orangeButton = SKSpriteNode(imageNamed: "orange1")
    purpleButton = SKSpriteNode(imageNamed: "purple1")
    super.init(size: size)
    scaleMode = .aspectFit
  }
  
  convenience init(index:Int, size:CGSize) {
    self.init(size: size)
    levelIndex = index
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("NSCoding not supported")
  }
  
  
  override func didMove(to view: SKView) {
    appDelegate.gameSceneDelegate = self
    self.backgroundColor = grayColor
    if UIDevice.current.userInterfaceIdiom == .pad {
      scaleXiPad = 0.9
    }
//    appDelegate.pauseAudio()
    appDelegate.playMusic2()
//    appDelegate.lateResumeAudio()
    backgroundNode.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
    addChild(backgroundNode)
    addChild(container)
    addBackButton()
    showLevel()
    showButtons()
    selectColorButton(blueButton)
    showLevelNumber()
    showStarOutline()
  }
  
  func addBackButton() {
    let bbb = SKSpriteNode(imageNamed: "pauseButton")
    pauseButton.addChild(bbb)
    pauseButton.position = CGPoint(x: pauseButton.size.width*0.5, y: self.size.height - pauseButton.size.height*0.5)
    self.addChild(pauseButton)
  }
  
  func showStarOutline() {
    starOutline = SKSpriteNode(imageNamed: "starOutline")
    starOutline?.position = CGPoint(x: 10 + self.size.width -  130 , y: 10 + self.size.height - 31)
    starOutline?.setScale(1.6)
    starOutline?.alpha = 0
    addChild(starOutline!)
    
    let duration = 1.0
    let action = SKAction.group([SKAction.fadeIn(withDuration: duration), SKAction.scale(to: 1, duration: duration), SKAction.move(by: CGVector(dx: -10, dy: -10), duration: duration)])
    starOutline?.run(SKAction.sequence([SKAction.wait(forDuration: 0.5), action]))
  }
  
  func hideStarOutline() {
    if starOutline != nil {
      let duration = 1.0
      let action = SKAction.group([SKAction.fadeOut(withDuration: duration), SKAction.scale(to: 1.6, duration: duration), SKAction.move(by: CGVector(dx: 10, dy: 10), duration: duration)])
      starOutline?.run(SKAction.sequence([SKAction.wait(forDuration: 0.5), action, SKAction.removeFromParent()]))
      starOutline = nil
    }
  }

  func showLevelNumber() {
    let str = String(format: "%02d", levelIndex+1)
    let label1 = SKLabelNode(fontNamed:"Avenir-Light")
    label1.name = "label1"
    label1.text = String(str.prefix(1))
    label1.fontSize = 44
    label1.fontColor = UIColor.white
    label1.alpha = 0
    label1.horizontalAlignmentMode = .right

    let label2 = SKLabelNode(fontNamed:"Avenir-Light")
    label2.name = "label2"
    label2.text = String(str.suffix(1))
    label2.fontSize = 44
    label2.fontColor = UIColor.white
    label2.alpha = 0
    label2.horizontalAlignmentMode = .left

    let space2 = (label2.frame.size.width )
    label1.position = CGPoint(x: 10 + self.size.width -  30 - space2 , y: 10 + self.size.height - 48)
    addChild(label1)
    
    label2.position = CGPoint(x: 10 + self.size.width - 28 - space2, y: 10 + self.size.height - 48)
    addChild(label2)
    
    label1.setScale(1.6)
    label2.setScale(1.6)
    
    let duration = 1.0
    let action = SKAction.group([SKAction.fadeIn(withDuration: duration), SKAction.scale(to: 1, duration: duration), SKAction.move(by: CGVector(dx: -10, dy: -10), duration: duration)])
    label1.run(SKAction.sequence([SKAction.wait(forDuration: 1.0), action]))
    label2.run(SKAction.sequence([SKAction.wait(forDuration: 1.4), action]))
    
  }
  
  func showButtons() {
    if (!appDelegate.isNormalGame) {
      blueButton.isHidden = true
      greenButton.isHidden = true
      orangeButton.isHidden = true
      purpleButton.isHidden = true
    }
    let x:CGFloat = (self.size.width / 2.0) - 268 + 70
//    let bh = appDelegate.controller?.bannerHeight()
    let y:CGFloat = (container.frame.minY) / 2
    
    blueButton.position = CGPoint(x:x, y:y)
    addChild(blueButton)
    
    greenButton.position = CGPoint(x:x + 132 * 1, y:y)
    addChild(greenButton)
    
    orangeButton.position = CGPoint(x:x + 132 * 2, y:y)
    addChild(orangeButton)
    
    purpleButton.position = CGPoint(x:x + 132 * 3, y:y)
    addChild(purpleButton)
  }
  
  
  func getBluredScreenshot(_ radius:CGFloat)->UIImage {
    let frame = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
    UIGraphicsBeginImageContextWithOptions(frame.size, false, 1)
    self.view?.drawHierarchy(in: frame, afterScreenUpdates: true)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext();
    let finalImage = image?.applyBlurWithRadius(radius, tintColor: UIColor(white: 0.5, alpha: 0.2), saturationDeltaFactor: 1)
    return finalImage!
  }
  
  func pause() {
    guard let _ = blurredNode else {return}
    
    let image = getBluredScreenshot(3)
    let texture = SKTexture(image: image)
    
    blurredNode = SKSpriteNode(texture: texture)
    blurredNode!.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
    blurredNode!.alpha = 0
    blurredNode!.zPosition = 100
    self.addChild(blurredNode!)
    blurredNode!.run(SKAction.fadeAlpha(to: 1, duration: 0.3))
  }
  
  func setBlur(_ radius:CGFloat) {
    if (radius>0) {
      
      if (blurredNode != nil) {
        return
      }
      
      let image = getBluredScreenshot(radius)
      let texture = SKTexture(image: image)
      
      blurredNode = SKSpriteNode(texture: texture)
      blurredNode!.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
      blurredNode!.alpha = 0
      blurredNode!.zPosition = 100
      self.addChild(blurredNode!)
      blurredNode!.run(SKAction.fadeAlpha(to: 1, duration: 0.5))
      
    } else {
      guard let blur = blurredNode else {return}
      blur.run(SKAction.fadeAlpha(to: 0, duration: 0.3),completion: {
        blur.removeFromParent()
        self.blurredNode = nil
      })
      
    }
  }
  
  func touchingShapesforShape(_ id:Int) ->[Int] {
    if let levels = appDelegate.jsonLevels {
      if let shapes = levels[levelIndex]["shapes"] as? [[String: AnyObject]] {
        for shape in shapes {
          if let shapeID = shape["id"] as? Int {
            if (shapeID == id) {
              if let shapeTouchArray = shape["touches"] as? [Int] {
                return shapeTouchArray
              }
            }
          }
        }
      }
    }
    return []
  }
  
  
  func addLevelShapesToNode(_ node:SKSpriteNode) {
    if let levels = appDelegate.jsonLevels {
      if let shapes = levels[levelIndex]["shapes"] as? [[String: AnyObject]] {
        for shape in shapes {
          let shapeID = shape["id"] as! Int
          if let points = shape["points"] as? [Float] {
            addLevelShapeToNode(node, id:shapeID, points: points)
          }
        }
      }
    }
  }
  
  
  func addLevelShapeToNode(_ node:SKSpriteNode, id:Int, points:[Float]) {
    let path = CGMutablePath()
    
    let menuScaleX = scaleX  * (622) / self.size.width
    path.move(to: CGPoint(x: menuScaleX * CGFloat(points[0]), y: menuScaleX * CGFloat(640-points[1]))) //CGPathMoveToPoint(path, nil,menuScaleX * CGFloat(points[0]),menuScaleX * CGFloat(640-points[1]))
    var idx:Int = 2
    while idx < points.count {
      path.addCurve(      to: CGPoint(x: menuScaleX * CGFloat(points[idx+4]), y: menuScaleX * CGFloat(640-points[idx+5])),
                    control1: CGPoint(x: menuScaleX * CGFloat(points[idx+0]), y: menuScaleX * CGFloat(640-points[idx+1])),
                    control2: CGPoint(x: menuScaleX * CGFloat(points[idx+2]), y: menuScaleX * CGFloat(640-points[idx+3])))
//      CGPathAddCurveToPoint(path, nil,  menuScaleX * CGFloat(points[idx+0]), menuScaleX * CGFloat(640-points[idx+1]),
//        menuScaleX * CGFloat(points[idx+2]), menuScaleX * CGFloat(640-points[idx+3]),
//        menuScaleX * CGFloat(points[idx+4]), menuScaleX * CGFloat(640-points[idx+5]))
      idx += 6
    }
    let sh = SKShapeNode()
    sh.path = path
    sh.fillColor = SKColor.gray
    sh.strokeColor = SKColor.white
    sh.position = CGPoint(x: -311, y: -311)
    sh.isAntialiased = true
    sh.lineWidth = 1
    shapes[sh] = (id:id, colorIndex:0, prevColorIndex:0)
    node.addChild(sh)
  }
  
  func showLevel() {
    container.position = CGPoint(x:(self.size.width)/2.0, y:(self.size.height + self.size.height/5)/2.0)
    container.setScale(scaleX * scaleXiPad)
    
    addLevelShapesToNode(container)
    
    let hilight = SKSpriteNode(imageNamed: "levelHilight")
    hilight.zPosition = 100
    hilight.alpha = 0.7
    container.addChild(hilight)
  }
  
  func shapeColorIndex(_ shape:SKShapeNode)->Int {
    return shapes[shape]!.colorIndex
  }
  
  func shapeColor(_ shape:SKShapeNode)->UIColor {
    let index = shapes[shape]!.colorIndex
    switch index {
    case 1: return blueColor
    case 2: return greenColor
    case 3: return orangeColor
    case 4: return purpleColor
    default: return grayColor
    }
  }
  
  func shapeTouched(_ touch:UITouch?) -> (shape:SKShapeNode?, id:Int?) {
    var point = touch!.location(in: container)
    point.x += 311
    point.y += 311
    for (shape, value) in shapes {
      if shape.path!.contains(point, using: .evenOdd) {
//      if (CGPathContainsPoint(shape.path, nil, point, true)) {
        return (shape, value.id)
      }
    }
    return (nil, nil)
  }
  
  func restartLevel() {
    if (menuShowing) {
      menuShowing = false
      let sprite = childNode(withName: "menu") as! SKSpriteNode
      sprite.run(SKAction.sequence([SKAction.moveTo(x: container.position.x + sprite.size.width, duration: 0.2), SKAction.removeFromParent()]))
      setBlur(0)
      
      //clear shapes
      for (shape, value) in shapes {
        let newColor = 0
        let prevColor = 0
        shapes[shape] = (value.id, newColor, prevColor)
        let color = colorForColorIndex(newColor)
        colorizeShape(shape, color: color)
      }
      selectColorButton(blueButton)
      colorUndone = false
    }
    if (starOutline == nil) {
      showStarOutline()
    }
  }
  
  func disableScene() {
    self.isUserInteractionEnabled = false
  }
  
  func enableScene() {
    self.isUserInteractionEnabled = true
  }
  
  
  func hideMenu() {
    if (menuShowing) {
      menuShowing = false
      let sprite = childNode(withName: "menu") as! SKSpriteNode
      sprite.run(SKAction.sequence([SKAction.moveTo(x: container.position.x + sprite.size.width, duration: 0.2), SKAction.removeFromParent()]))
      setBlur(0)
    }
  }
  

  func showMenu(_ success:Bool) {
    self.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),SKAction.playSoundFileNamed("showmenu.mp3", waitForCompletion: false)]))
    enableScene() //in case of disabled
    if (menuShowing) {
      return
    }
    menuShowing = true
    setBlur(10)
    
    let height:CGFloat = success ? 360:180
    
    let shadow = SKSpriteNode(color: UIColor(white: 0.0, alpha: 0.2), size: CGSize(width: self.size.width, height: 8))
    shadow.anchorPoint = CGPoint(x: 0.5, y: 1)
    shadow.position = CGPoint(x: 0, y: -height)
    
    let sprite = SKSpriteNode(color: UIColor(white: 0.3, alpha: 0.8), size: CGSize(width:self.size.width, height: height))
    sprite.anchorPoint = CGPoint(x: 0.5, y: 1)
    sprite.name = "menu"
    sprite.position = CGPoint(x: container.position.x - sprite.size.width, y: container.position.y+160)
    addChild(sprite)
    sprite.addChild(shadow)

    let label = SKLabelNode(fontNamed:"Avenir-Light")
    if (success) {
      let r = Int(arc4random_uniform(UInt32(successMessage.count)))
      label.text = successMessage[r]
    } else {
      label.text = "Paused"
    }    
    label.fontSize = 58
    label.fontColor = UIColor.white
    label.position = CGPoint(x: 0, y: 80)
    sprite.addChild(label)
    
    let w:CGFloat = sprite.size.width/4
    var x = -w
    let y:CGFloat = -90
    menuButton = SKSpriteNode(imageNamed: "menuButton")

    
    if (success) {
      if levelIndex == (appDelegate.jsonLevels?.count)!-1 {
        mainMenuButton = SKSpriteNode(imageNamed: "mainMenuButton")
        nextLevelButton = nil
      } else {
        mainMenuButton = nil
        nextLevelButton = SKSpriteNode(imageNamed: "nextLevelButton")
      }
      continueButton = nil
    } else {
      nextLevelButton = nil
      mainMenuButton = nil
      continueButton = SKSpriteNode(imageNamed: "continueButton")
    }
    
    restartButton = SKSpriteNode(imageNamed: "restartButton")
    menuButton?.position = CGPoint(x: x, y: y)
    sprite.zPosition = 200
    sprite.addChild(menuButton!)
    if let _ = continueButton {
      x+=w
      continueButton?.position = CGPoint(x: x, y: y)
      sprite.addChild(continueButton!)
    }
    x+=w
    restartButton?.position = CGPoint(x: x, y: y)
    sprite.addChild(restartButton!)
    if let _ = nextLevelButton {
      x+=w
      nextLevelButton?.position = CGPoint(x: x, y: y)
      sprite.addChild(nextLevelButton!)
    } else if let _ = mainMenuButton {
      x+=w
      mainMenuButton?.position = CGPoint(x: x, y: y)
      sprite.addChild(mainMenuButton!)
    }
    
    if success {
      appDelegate.levelsSolved += 1
      self.run(appDelegate.successSoundAction)

      if (colorUndone == false) {
        let name = appDelegate.isNormalGame ? "normalstars" : "frenzystars"
        var stars:[Int] = (UserDefaults.standard.object(forKey: name) ?? []) as! [Int]
        if !stars.contains(levelIndex) {
          stars.append(levelIndex)
          UserDefaults.standard.set(stars, forKey: name)
        }
      }
      
      for i in 0...1 {
        let star = SKSpriteNode(imageNamed: "largeStar")
        star.position = CGPoint(x: 0, y: -240)
        sprite.addChild(star)
        star.colorBlendFactor = 1
        if colorUndone == false {
          star.color = UIColor(hue: 49.0 / 360.0, saturation: 1, brightness: 1, alpha: 1)
          star.alpha = 0
          star.setScale(2.5)
          let wait = SKAction.wait(forDuration: 1.0 + Double(i) * 0.5)
          let fadein = SKAction.fadeAlpha(to: 0.5 ,duration: 1.0)
          fadein.timingMode = .easeOut
          let scale = SKAction.scale(to: 1, duration: 1.0)
          scale.timingMode = .easeOut
          let group = SKAction.group([fadein, scale])
          let sequence = SKAction.sequence([wait, group])
          star.run(sequence)
        } else {
          star.color = UIColor(hue: 0.0, saturation: 0, brightness: 0.3, alpha: 1)
        }
      }
    }
    
    sprite.run(SKAction.sequence([SKAction.wait(forDuration: 0.3), SKAction.moveTo(x: container.position.x, duration: 0.2)]))
  }
  
  func cleanLevel() {
    container.removeAllChildren()
    childNode(withName: "label1")?.removeFromParent()
    childNode(withName: "label2")?.removeFromParent()
    starOutline?.removeFromParent()
    colorUndone = false
    if (menuShowing) {
      menuShowing = false
      let sprite = childNode(withName: "menu") as! SKSpriteNode
      sprite.run(SKAction.sequence([SKAction.moveTo(x: container.position.x + sprite.size.width, duration: 0.2), SKAction.removeFromParent()]))
      setBlur(0)
    }
    shapes.removeAll()
  }
  
  func showNextLevel() {
    cleanLevel()
    levelIndex += 1
    showLevel()
    selectColorButton(blueButton)
    showLevelNumber()
    showStarOutline()

//    let scene = GameScene(index: levelIndex+1, size: self.size)
//    scene.scaleX = scaleX
//    scene.scaleMode = .AspectFit
//    let transition:SKTransition = SKTransition.crossFadeWithDuration(1)
//    self.view?.presentScene(scene, transition: transition)    
  }
  
  func showMainMenu() {
    appDelegate.gameSceneDelegate = nil
    let scene = MainMenuScene(size: self.size)
    scene.scaleX = scaleX
    scene.scaleMode = .aspectFit
    let transition:SKTransition = SKTransition.crossFade(withDuration: 1)
    self.view?.presentScene(scene, transition: transition)
  }
  
  func leaveGame() {
    appDelegate.gameSceneDelegate = nil
    let scene = MenuScene(size: self.size)
    scene.scaleX = scaleX
    scene.scaleMode = .aspectFit
    let transition:SKTransition = SKTransition.crossFade(withDuration: 1)
    self.view?.presentScene(scene, transition: transition)
  }
  
  func colorForButton(_ colorButton:SKNode?)->UIColor {
    var color:UIColor = self.grayColor
    if let button = colorButton {
      color = {
        switch button {
        case blueButton: return blueColor
        case greenButton: return greenColor
        case orangeButton: return orangeColor
        case purpleButton: return purpleColor
        default: return self.grayColor
        }
      }()
    }
    return color
  }
  
  func colorForColorIndex(_ index:Int)->UIColor {
    switch index {
    case 1: return blueColor
    case 2: return greenColor
    case 3: return orangeColor
    case 4: return purpleColor
    default: return grayColor
    }
  }
  
  func colorIndexForColorButton(_ colorButton:SKNode?)->Int {
    if let button = colorButton {
      switch button {
      case blueButton: return 1
      case greenButton: return 2
      case orangeButton: return 3
      case purpleButton: return 4
      default: return 0
      }
    }
    return 0
  }
  
  func colorizeBackground(_ colorButton:SKNode?, duration:Double = 0.4) {
    let color = colorForButton(colorButton)
    backgroundNode.removeAllActions()
    if (duration>0) {
      let action = SKAction.colorize(with: color, colorBlendFactor: 1, duration: duration)
      backgroundNode.run(action)
    } else {
      backgroundNode.colorBlendFactor = 1
      backgroundNode.color = color
    }
  }
  
  
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
  
  func touchedColorButton(_ point:CGPoint)->SKNode? {
    var node:SKNode?
    var maxz:CGFloat = -1
    for button:SKNode in [blueButton, greenButton, orangeButton, purpleButton] {
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
  
  
  override func update(_ currentTime: TimeInterval) {
    for mnode:SKSpriteNode in [blueButton, greenButton, orangeButton, purpleButton] {
      mnode.zPosition = mnode.xScale * 10
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if (activeTouch == nil) {
      activeTouch = touches.first
      
      if (activeNode == nil) {
        let point = activeTouch!.location(in: self)        
        if let node = touchedButton(activeTouch!, buttons: (menuShowing ? [menuButton, continueButton, restartButton, nextLevelButton, mainMenuButton] : [pauseButton])) {
          node.run(SKAction.scale(to: 1.3, duration: 0.1))
          activeNode = node
          return
        } else if (!menuShowing) {
          if let node = touchedColorButton(point) {
            let scale = SKAction.scale(to: 1.3, duration: 0.1);
            activeNode = node
            for mnode in [blueButton, greenButton, orangeButton, purpleButton] {
              if mnode == activeNode {
                continue
              } else if mnode == activeColorButton {
                continue
              }
            }
            colorizeBackground(node)
            activeNode!.run(scale);
            return
          }
        }
      }
      
      let (shape, _) = shapeTouched(activeTouch)
      activeShape = shape
      if let touchedShape = activeShape {
        let color = colorForButton(activeColorButton)
        colorizeShape(touchedShape, color:color)
      }
    }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = activeTouch {
      let point = touch.location(in: self)
      if let node = activeNode {
        if (!menuShowing && [blueButton, greenButton, orangeButton, purpleButton].contains(node)) {
          let node = touchedColorButton(point)
          if (node != activeNode) {
            if activeColorButton == activeNode {
              activeNode!.run(SKAction.scale(to: 1.1, duration: 0.1))
            } else {
              activeNode!.run(SKAction.scale(to: 1.0, duration: 0.1))
            }
          } else {
            activeNode!.run(SKAction.scale(to: 1.3, duration: 0.1))
          }
          return
        }
        
        let newActiveNode = self.touchedButton(touch, buttons: (menuShowing ? [menuButton, continueButton, restartButton, nextLevelButton, mainMenuButton] : [pauseButton]))
        if (newActiveNode != activeNode) {
          if (activeNode!.xScale>1.0) {
            activeNode?.run(SKAction.scale(to: 1.0, duration: 0.1))
          }
        } else {
          activeNode?.run(SKAction.scale(to: 1.3, duration: 0.1))
        }
        
        return
      }
      
      if (touches.contains(touch)) {
        let (shape, _) = shapeTouched(activeTouch)
        if shape != activeShape {
          if let touchedShape = activeShape {
            colorizeShape(touchedShape, color:shapeColor(touchedShape))
          }
          activeShape = shape
          if let touchedShape = activeShape {
            let color = colorForButton(activeColorButton)
            colorizeShape(touchedShape, color:color)
          }
        }
      }
    }
  }
  
  
  func colorizeShape(_ shape:SKShapeNode, color:UIColor) {
    let duration:CGFloat = 0.4
    let originalColor = shape.fillColor
    var fred:CGFloat = 0, fgreen:CGFloat = 0, fblue:CGFloat = 0, falpha: CGFloat = 0
    originalColor.getRed(&fred, green: &fgreen, blue: &fblue, alpha: &falpha)
    let startRGBA:[CGFloat] = [fred, fgreen, fblue, falpha]//[CGFloat](repeating: 0.0, count: 4)
    color.getRed(&fred, green: &fgreen, blue: &fblue, alpha: &falpha)
    let finalRGBA:[CGFloat] = [fred, fgreen, fblue, falpha]//[CGFloat](repeating: 0.0, count: 4)
    let action = SKAction.customAction(withDuration: Double(duration), actionBlock: { (node: SKNode, elapsedTime: CGFloat) -> Void in
      let shapeNode:SKShapeNode = node as! SKShapeNode
      let step:CGFloat = elapsedTime / duration;
      var stepRGBA = [CGFloat](repeating: 0.0, count: 4)
      for i in 0...3 {
        stepRGBA[i] = startRGBA[i] - (startRGBA[i] - finalRGBA[i])*step;
      }
      shapeNode.fillColor = UIColor(red: stepRGBA[0], green: stepRGBA[1], blue: stepRGBA[2], alpha: stepRGBA[3])
    })
    shape.run(action)
  }
  
  func selectColorButton(_ node:SKSpriteNode) {
    if activeColorButton == node {
      return
    }
    activeColorButton?.run(SKAction.scale(to: 1.0, duration: 0.1))
    if ([blueButton, greenButton, purpleButton, orangeButton].contains(node)) {
      activeColorButton = node
      node.run(SKAction.sequence([SKAction.scale(to: 1.3, duration: 0.2), SKAction.wait(forDuration: 0.1), SKAction.scale(to: 1.1, duration: 0.2)]))
      colorizeBackground(node, duration:0.6)
    }
  }
  
  func selectNextColorButton() {
    if (activeColorButton == nil) {
      activeColorButton = blueButton
    } else if (activeColorButton == blueButton) {
      activeColorButton = greenButton
    } else if (activeColorButton == greenButton) {
      activeColorButton = orangeButton
    } else if (activeColorButton == orangeButton) {
      activeColorButton = purpleButton
    } else if (activeColorButton == purpleButton) {
      activeColorButton = blueButton
    }
    colorizeBackground(activeColorButton, duration:0.6)
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = activeTouch {
      activeTouch = nil
      let point = touch.location(in: self)
      if let activeNodeUnwrapped = activeNode {
        if ([blueButton, greenButton, purpleButton, orangeButton].contains(activeNodeUnwrapped)) {
          //active node is one of color buttons
          if let touchedButton = touchedColorButton(point) {
            if (touchedButton == activeNode) {
              //touchesEnded inside activeNode, so we got to make it active
              if (activeColorButton == activeNode) {
                //same button - nothing changed
                activeColorButton!.removeAllActions()
                activeColorButton!.run(SKAction.scale(to: 1.1, duration: 0.1))
                activeNode = nil
              } else {
                //touches ended inside a color button (not currently active) and we have to make it active
                activeColorButton!.removeAllActions()
                activeColorButton!.run(SKAction.scale(to: 1.0, duration: 0.1))
                activeColorButton = activeNode
                activeColorButton!.run(SKAction.scale(to: 1.1, duration: 0.1))
                colorizeBackground(activeColorButton)
                activeNode = nil
              }
              return
            }
          }
          //touchesEnded outside of activeNode, so we got to cancel
          if (activeColorButton == activeNodeUnwrapped) {
            activeNodeUnwrapped.removeAllActions()
            activeNode = nil
          } else {
            activeNodeUnwrapped.removeAllActions()
            activeNodeUnwrapped.run(SKAction.scale(to: 1.0, duration: 0.1))
            activeColorButton!.run(SKAction.scale(to: 1.1, duration: 0.1))
            colorizeBackground(activeColorButton)
            activeNode = nil
          }
          return
        }
        
        let newActiveNode = self.touchedButton(touch, buttons: (menuShowing ? [menuButton, continueButton, restartButton, nextLevelButton, mainMenuButton] : [pauseButton]))
        if (newActiveNode == activeNode) {
          activeNodeUnwrapped.setScale(1.3)
          activeNodeUnwrapped.run(SKAction.scale(to: 1.0, duration: 0.1))
          if (activeNode == pauseButton) {
            showMenu(false)
          } else if (activeNode == menuButton) {
            leaveGame()
          } else if activeNode == continueButton {
            hideMenu()
          } else if activeNode == restartButton {
            restartLevel()
          } else if activeNode == nextLevelButton {
            showNextLevel()
          } else if activeNode == mainMenuButton {
            showMainMenu()
          }
          activeNode = nil
          return
        }
        activeNode = nil
      }
      
      if (menuShowing) {
        return
      }
      
      if (touches.contains(touch)) {        
        var point = touch.location(in: container)
        point.x += 311
        point.y += 311
        for (shape, value) in shapes {
//          if (CGPathContainsPoint(shape.path, nil, point, true)) {
          if shape.path!.contains(point, using: .evenOdd) {
            #if false //true for debug levels
              dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(3 * NSEC_PER_SEC)), dispatch_get_main_queue()) {
                self.colorizeShape(shape, color: UIColor(hue: 0.0, saturation: 0.0, brightness: 0.5, alpha: 1))
              }
              
              let touches = touchingShapesforShape(value.id)
              for touchId in touches {
                for (touchShape, value) in shapes {
                  if (value.id == touchId) {
                    colorizeShape(touchShape, color: UIColor.greenColor())
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(3 * NSEC_PER_SEC)), dispatch_get_main_queue()) {
                      self.colorizeShape(touchShape, color: UIColor(hue: 0.0, saturation: 0.0, brightness: 0.5, alpha: 1))
                    }
                  }
                }
              }
            #else
              let prevColor = shapes[shape]!.prevColorIndex
              let currentColor = shapes[shape]!.colorIndex
              if (currentColor > 0) {
                colorUndone = true
                hideStarOutline()
              }
              var newColor = colorIndexForColorButton(activeColorButton)
              if newColor == currentColor {
                newColor = prevColor
              }
              shapes[shape] = (value.id, newColor, currentColor)
              let color = colorForColorIndex(newColor)
              colorizeShape(shape, color: color)
              
              if (!appDelegate.isNormalGame) {
                selectNextColorButton()
              }
              activeShape = nil
              checkLevelFinished()
            #endif
          }
        }
      }
    }
  }
  
  func shapeForShapeID(_ id:Int)->SKShapeNode? {
    for (shape, value) in shapes {
      if (value.id == id) {
        return shape
      }
    }
    return nil
  }
  
  func colorIndexForShapeID(_ id:Int)->Int? {
    for (_, value) in shapes {
      if (value.id == id) {
        return value.colorIndex
      }
    }
    return nil
  }
  
  func checkLevelFinished() {
//    var incorrect = false
    var incorrectShapes:[SKShapeNode] = []
    for (shape, value) in shapes {
      if value.colorIndex == 0 {
        NSLog("INCOMPLETE")
        return
      }
      let touches = touchingShapesforShape(value.id)
      for touchId in touches {
        if let colorIndex = colorIndexForShapeID(touchId) {
          if colorIndex == value.colorIndex {
            if let otherShape = shapeForShapeID(touchId) {
              if !incorrectShapes.contains(shape) {
                incorrectShapes.append(shape)
              }
              
              if !incorrectShapes.contains(otherShape) {
                incorrectShapes.append(otherShape)
              }
            }
//            incorrect = true
          }
        }
      }
    }
    if (incorrectShapes.count > 0) {
      NSLog("INCORRECT")
      for shape in incorrectShapes {
        colorizeShape(shape, color: UIColor(hue: 0.0, saturation: 0.0, brightness: 1, alpha: 0.75))
      }
      DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(0.3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
        for shape in incorrectShapes {
          self.colorizeShape(shape, color:self.shapeColor(shape))
        }
      }
      return
    }
    disableScene()
    appDelegate.unlockedLevel = max(levelIndex+1, appDelegate.unlockedLevel)
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(1 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) {
      self.showMenu(true)
    }
    
  }
}
