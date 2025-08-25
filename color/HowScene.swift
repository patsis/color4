//
//  HowScene.swift
//  color4
//
//  Created by Harry Patsis on 20/10/15.
//  Copyright © 2015 Harry Patsis. All rights reserved.
//

import SpriteKit

class HowScene: SKScene {
   let appDelegate = UIApplication.shared.delegate as! AppDelegate
   var activeTouch:UITouch?
   var activeButton:SKNode?
   
   var scaleX:CGFloat = 1
   var stopped:Bool = false
   
   override init(size: CGSize) {
      super.init(size: size)
      scaleMode = .aspectFit
   }
   
   required init?(coder aDecoder: NSCoder) {
      fatalError("NSCoding not supported")
   }
   
   override func didMove(to view: SKView) {
      self.backgroundColor = UIColor(hue: 204/365, saturation: 1, brightness: 0.83, alpha: 1)
      
      addTitle()
      addGotIt()
      addStep1()
      DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(12 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) {
         if (!self.stopped) {
            self.addStep2()
         }
      }
      DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(28 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) {
         if (!self.stopped) {
            self.addStep3()
         }
      }
      DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(39 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) {
         if (!self.stopped) {
            self.addStep4()
         }
      }
   }
   
   func addTitle() {
      let label = SKLabelNode(fontNamed:"Avenir-Light")
      label.text = "HOW TO PLAY"
      label.fontSize = 48
      label.position = CGPoint(x: size.width/2, y: size.height - 80 - appDelegate.safeAreaInsets.top)
      label.fontColor = UIColor.white
      addChild(label)
   }
   
   func addGotIt() {
      let label = SKLabelNode(fontNamed:"Avenir-Light")
      label.text = "OK, GOT IT"
      label.fontSize = 40
      label.position = CGPoint(x: size.width/2, y: 80 + appDelegate.safeAreaInsets.bottom)
      label.fontColor = UIColor.white
      label.name = "gotit"
      addChild(label)
   }
   
   func addStep1() {
      let width = self.size.width/4
      let height = width * 0.9
      let x = self.size.width/2
      let y = self.size.height/2 + height/2
      
      let shp1 = SKShapeNode(rect: CGRect(x: x - width, y: y, width: width, height: height))
      shp1.fillColor = UIColor.gray
      shp1.strokeColor = SKColor.white
      shp1.isAntialiased = true
      shp1.lineWidth = 4
      shp1.alpha = 0
      addChild(shp1)
      
      let shp2 = SKShapeNode(rect: CGRect(x: x , y: y, width: width, height: height))
      shp2.fillColor = UIColor.gray
      shp2.strokeColor = SKColor.white
      shp2.isAntialiased = true
      shp2.lineWidth = 4
      shp2.alpha = 0
      addChild(shp2)
      
      let shp3 = SKShapeNode(rect: CGRect(x: x - width, y: y - height, width: width, height: height))
      shp3.fillColor = UIColor.gray
      shp3.strokeColor = SKColor.white
      shp3.isAntialiased = true
      shp3.lineWidth = 4
      shp3.alpha = 0
      addChild(shp3)
      
      let shp4 = SKShapeNode(rect: CGRect(x: x , y: y - height, width: width, height: height))
      shp4.fillColor = UIColor.gray
      shp4.strokeColor = SKColor.white
      shp4.isAntialiased = true
      shp4.lineWidth = 4
      shp4.alpha = 0
      addChild(shp4)
      
      
      let shape1 = SKShapeNode(rect: CGRect(x: x - width, y: y, width: width, height: height))
      shape1.fillColor = UIColor(hue: 204/365, saturation: 1, brightness: 0.83, alpha: 1)
      shape1.strokeColor = SKColor.white
      shape1.isAntialiased = true
      shape1.lineWidth = 4
      shape1.alpha = 0
      addChild(shape1)
      
      let shape2 = SKShapeNode(rect: CGRect(x: x , y: y, width: width, height: height))
      shape2.fillColor = UIColor(hue: 148/365, saturation: 1, brightness: 0.63, alpha: 1)
      shape2.strokeColor = SKColor.white
      shape2.isAntialiased = true
      shape2.lineWidth = 4
      shape2.alpha = 0
      addChild(shape2)
      
      let shape3 = SKShapeNode(rect: CGRect(x: x - width, y: y - height, width: width, height: height))
      shape3.fillColor = UIColor(hue: 19/365, saturation: 0.86, brightness: 0.96, alpha: 1)
      shape3.strokeColor = SKColor.white
      shape3.isAntialiased = true
      shape3.lineWidth = 4
      shape3.alpha = 0
      addChild(shape3)
      
      let shape4 = SKShapeNode(rect: CGRect(x: x , y: y - height, width: width, height: height))
      shape4.fillColor = UIColor(hue: 283/365, saturation: 0.59, brightness: 0.6, alpha: 1)
      shape4.strokeColor = SKColor.white
      shape4.isAntialiased = true
      shape4.lineWidth = 4
      shape4.alpha = 0
      addChild(shape4)
      
      let label = SKLabelNode(fontNamed:"Avenir-Light")
      label.text = "color all shapes..."
      label.fontSize = 48
      label.position = CGPoint(x: size.width/2, y: y - 1.6 * height)
      label.fontColor = UIColor.white
      label.alpha = 0
      addChild(label)
      
      let act1 = SKAction.sequence([SKAction.wait(forDuration: 0.5), SKAction.fadeIn(withDuration: 0.3), SKAction.wait(forDuration: 5), SKAction.removeFromParent()])
      let act2 = SKAction.sequence([SKAction.wait(forDuration: 0.6), SKAction.fadeIn(withDuration: 0.3), SKAction.wait(forDuration: 5), SKAction.removeFromParent()])
      let act3 = SKAction.sequence([SKAction.wait(forDuration: 0.7), SKAction.fadeIn(withDuration: 0.3), SKAction.wait(forDuration: 5), SKAction.removeFromParent()])
      let act4 = SKAction.sequence([SKAction.wait(forDuration: 0.8), SKAction.fadeIn(withDuration: 0.3), SKAction.wait(forDuration: 5), SKAction.removeFromParent()])
      shp1.run(act1)
      shp2.run(act2)
      shp3.run(act3)
      shp4.run(act4)
      
      
      let action1 = SKAction.sequence([SKAction.wait(forDuration: 3.5), SKAction.fadeIn(withDuration: 0.7), SKAction.wait(forDuration: 6.2), SKAction.fadeOut(withDuration: 1), SKAction.removeFromParent()])
      let action2 = SKAction.sequence([SKAction.wait(forDuration: 4.0), SKAction.fadeIn(withDuration: 0.7), SKAction.wait(forDuration: 5.8), SKAction.fadeOut(withDuration: 1), SKAction.removeFromParent()])
      let action3 = SKAction.sequence([SKAction.wait(forDuration: 4.5), SKAction.fadeIn(withDuration: 0.7), SKAction.wait(forDuration: 5.4), SKAction.fadeOut(withDuration: 1), SKAction.removeFromParent()])
      let action4 = SKAction.sequence([SKAction.wait(forDuration: 5.0), SKAction.fadeIn(withDuration: 0.7), SKAction.wait(forDuration: 5.0), SKAction.fadeOut(withDuration: 1), SKAction.removeFromParent()])
      let action5 = SKAction.sequence([SKAction.wait(forDuration: 0.7), SKAction.fadeIn(withDuration: 0.7), SKAction.wait(forDuration: 1.9), SKAction.scale(to: 1.1, duration: 0.1), SKAction.scale(to: 1, duration: 0.1), SKAction.wait(forDuration: 8.0), SKAction.fadeOut(withDuration: 1), SKAction.removeFromParent()])
      shape1.run(action1)
      shape2.run(action2)
      shape3.run(action3)
      shape4.run(action4)
      label.run(action5)
   }
   
   
   func addStep2() {
      let width = self.size.width/4
      let height = width * 0.8
      let x = self.size.width/2
      let y = self.size.height/2 + height * 0.7
      
      let shp1 = SKShapeNode(rect: CGRect(x: x - width, y: y, width: width, height: height))
      shp1.fillColor = UIColor.gray
      shp1.strokeColor = SKColor.white
      shp1.isAntialiased = true
      shp1.lineWidth = 4
      shp1.alpha = 0
      addChild(shp1)
      
      let shp2 = SKShapeNode(rect: CGRect(x: x , y: y, width: width, height: height))
      shp2.fillColor = UIColor.gray
      shp2.strokeColor = SKColor.white
      shp2.isAntialiased = true
      shp2.lineWidth = 4
      shp2.alpha = 0
      addChild(shp2)
      
      let shp11 = SKShapeNode(rect: CGRect(x: x - width, y: y, width: width, height: height))
      shp11.fillColor = UIColor(hue: 283/365, saturation: 0.59, brightness: 0.6, alpha: 1)
      shp11.strokeColor = UIColor.white
      shp11.isAntialiased = true
      shp11.lineWidth = 4
      shp11.alpha = 0
      addChild(shp11)
      
      let shp12 = SKShapeNode(rect: CGRect(x: x , y: y, width: width, height: height))
      shp12.fillColor = UIColor(hue: 283/365, saturation: 0.59, brightness: 0.6, alpha: 1)
      shp12.strokeColor = UIColor.white
      shp12.isAntialiased = true
      shp12.lineWidth = 4
      shp12.alpha = 0
      addChild(shp12)
      
      
      let label1 = SKLabelNode(fontNamed:"Avenir-Light")
      label1.text = "adjacent shapes..."
      label1.fontSize = 48
      label1.position = CGPoint(x: size.width/2, y: y + 1.25 * height)
      label1.fontColor = UIColor.white
      label1.alpha = 0
      addChild(label1)
      
      let shp3 = SKShapeNode(rect: CGRect(x: x - width, y: y - 1.8 * height, width: width, height: height))
      shp3.fillColor = UIColor.gray
      shp3.strokeColor = SKColor.white
      shp3.isAntialiased = true
      shp3.lineWidth = 4
      shp3.alpha = 0
      addChild(shp3)
      
      let shp4 = SKShapeNode(rect: CGRect(x: x , y: y - 1.8 * height, width: width, height: height))
      shp4.fillColor = UIColor.gray
      shp4.strokeColor = SKColor.white
      shp4.isAntialiased = true
      shp4.lineWidth = 4
      shp4.alpha = 0
      addChild(shp4)
      
      let shp13 = SKShapeNode(rect: CGRect(x: x - width, y: y - 1.8 * height, width: width, height: height))
      shp13.fillColor = UIColor(hue: 283/365, saturation: 0.59, brightness: 0.6, alpha: 1)
      shp13.strokeColor = UIColor.white
      shp13.isAntialiased = true
      shp13.lineWidth = 4
      shp13.alpha = 0
      addChild(shp13)
      
      let shp14 = SKShapeNode(rect: CGRect(x: x , y: y - 1.8 * height, width: width, height: height))
      shp14.fillColor = UIColor(hue: 19/365, saturation: 0.86, brightness: 0.96, alpha: 1)
      shp14.strokeColor = UIColor.white
      shp14.isAntialiased = true
      shp14.lineWidth = 4
      shp14.alpha = 0
      addChild(shp14)
      
      
      let label2 = SKLabelNode(fontNamed:"Avenir-Light")
      label2.text = "must have"
      label2.fontSize = 48
      label2.position = CGPoint(x: size.width/2, y: y - 0.45 * height)
      label2.fontColor = UIColor.white
      label2.alpha = 0
      addChild(label2)
      
      let label3 = SKLabelNode(fontNamed:"Avenir-Light")
      label3.text = "...different colors"
      label3.fontSize = 48
      label3.position = CGPoint(x: size.width/2, y: y - 2.25 * height)
      label3.fontColor = UIColor.white
      label3.alpha = 0
      addChild(label3)
      
      let act1 = SKAction.sequence([SKAction.wait(forDuration: 0.5), SKAction.fadeIn(withDuration: 0.3), SKAction.wait(forDuration: 5), SKAction.removeFromParent()])
      let act2 = SKAction.sequence([SKAction.wait(forDuration: 0.6), SKAction.fadeIn(withDuration: 0.3), SKAction.wait(forDuration: 5), SKAction.removeFromParent()])
      let act3 = SKAction.sequence([SKAction.wait(forDuration: 5.7), SKAction.fadeIn(withDuration: 0.3), SKAction.wait(forDuration: 5), SKAction.removeFromParent()])
      let act4 = SKAction.sequence([SKAction.wait(forDuration: 5.8), SKAction.fadeIn(withDuration: 0.3), SKAction.wait(forDuration: 5), SKAction.removeFromParent()])
      shp1.run(act1)
      shp2.run(act2)
      shp3.run(act3)
      shp4.run(act4)
      
      let act11 = SKAction.sequence([SKAction.wait(forDuration: 01.5), SKAction.fadeIn(withDuration: 0.3), SKAction.wait(forDuration: 11.7), SKAction.fadeOut(withDuration: 1), SKAction.removeFromParent()])
      let act12 = SKAction.sequence([SKAction.wait(forDuration: 02.0), SKAction.fadeIn(withDuration: 0.3), SKAction.wait(forDuration: 11.3), SKAction.fadeOut(withDuration: 1), SKAction.removeFromParent()])
      let act13 = SKAction.sequence([SKAction.wait(forDuration: 06.5), SKAction.fadeIn(withDuration: 0.3), SKAction.wait(forDuration: 06.8), SKAction.fadeOut(withDuration: 1), SKAction.removeFromParent()])
      let act14 = SKAction.sequence([SKAction.wait(forDuration: 07.0), SKAction.fadeIn(withDuration: 0.3), SKAction.wait(forDuration: 06.5), SKAction.fadeOut(withDuration: 1), SKAction.removeFromParent()])
      
      shp11.run(act11)
      shp12.run(act12)
      shp13.run(act13)
      shp14.run(act14)
      
      let act5 = SKAction.sequence([SKAction.wait(forDuration: 0.7), SKAction.fadeIn(withDuration: 0.3), SKAction.wait(forDuration: 12.5), SKAction.fadeOut(withDuration: 1), SKAction.removeFromParent()])
      label1.run(act5)
      
      let act6 = SKAction.sequence([SKAction.wait(forDuration: 3.7), SKAction.fadeIn(withDuration: 0.3), SKAction.wait(forDuration: 9.5), SKAction.fadeOut(withDuration: 1), SKAction.removeFromParent()])
      label2.run(act6)
      
      let act7 = SKAction.sequence([SKAction.wait(forDuration: 7.5), SKAction.fadeIn(withDuration: 0.3), SKAction.wait(forDuration: 5.6), SKAction.fadeOut(withDuration: 1), SKAction.removeFromParent()])
      label3.run(act7)
      
      
      let wrong = SKSpriteNode(imageNamed: "wrongHowTo")
      wrong.position = CGPoint(x: x, y: y + height * 0.5)
      wrong.alpha = 0
      addChild(wrong)
      
      let correct = SKSpriteNode(imageNamed: "correctHowTo")
      correct.position = CGPoint(x: x, y: y - height * 1.3)
      correct.alpha = 0
      addChild(correct)
      
      let zoom = SKAction.group([SKAction.fadeIn(withDuration: 0.2) ,SKAction.sequence([SKAction.scale(to: 1.1, duration: 0.1), SKAction.scale(to: 1, duration: 0.1)])])
      let actw = SKAction.sequence([SKAction.wait(forDuration: 09.0), zoom, SKAction.wait(forDuration: 4.3), SKAction.fadeOut(withDuration: 1), SKAction.removeFromParent()])
      let actc = SKAction.sequence([SKAction.wait(forDuration: 10.0), zoom, SKAction.wait(forDuration: 3.5), SKAction.fadeOut(withDuration: 1), SKAction.removeFromParent()])
      wrong.run(actw)
      correct.run(actc)
   }
   
   func addStep3() {
      let width = self.size.width/4
      let height = width * 0.8
      let x = self.size.width/2
      let y = self.size.height/2 + height * 0.7
      
      
      let label1 = SKLabelNode(fontNamed:"Avenir-Light")
      label1.text = "to win stars"
      label1.fontSize = 48
      label1.position = CGPoint(x: size.width/2, y: y - height * 0.1)
      label1.fontColor = UIColor.white
      label1.alpha = 0
      addChild(label1)
      
      let star = SKSpriteNode(imageNamed: "starBig")
      star.position = CGPoint(x: x, y: y + 1.0 * height)
      star.alpha = 0
      star.setScale(0.2)
      addChild(star)
      star.run(SKAction.sequence([SKAction.group([SKAction.fadeIn(withDuration: 0.3), SKAction.scale(to: 1, duration: 0.3)]), SKAction.wait(forDuration: 9), SKAction.fadeOut(withDuration: 0.3), SKAction.removeFromParent()]))
      
      let label2 = SKLabelNode(fontNamed:"Avenir-Light")
      label2.text = "solve puzzles..."
      label2.fontSize = 48
      label2.position = CGPoint(x: size.width/2, y: y - height * 0.7)
      label2.fontColor = UIColor.white
      label2.alpha = 0
      addChild(label2)
      
      let label3 = SKLabelNode(fontNamed:"Avenir-Light")
      label3.text = "...without mistakes"
      label3.fontSize = 48
      label3.position = CGPoint(x: size.width/2, y: y - height * 1.3)
      label3.fontColor = UIColor.white
      label3.alpha = 0
      addChild(label3)
      
      //    label1.runAction(SKAction.sequence([SKAction.waitForDuration(10), SKAction.fadeOutWithDuration(0.3), SKAction.removeFromParent()]))
      label1.run(SKAction.sequence([SKAction.wait(forDuration: 1), SKAction.group([SKAction.fadeIn(withDuration: 0.2)]), SKAction.wait(forDuration: 8.4), SKAction.fadeOut(withDuration: 0.3), SKAction.removeFromParent()]))
      label2.run(SKAction.sequence([SKAction.wait(forDuration: 2), SKAction.group([SKAction.fadeIn(withDuration: 0.2)]), SKAction.wait(forDuration: 7.8), SKAction.fadeOut(withDuration: 0.3), SKAction.removeFromParent()]))
      label3.run(SKAction.sequence([SKAction.wait(forDuration: 3), SKAction.group([SKAction.fadeIn(withDuration: 0.2)]), SKAction.wait(forDuration: 7.2), SKAction.fadeOut(withDuration: 0.3), SKAction.removeFromParent()]))
   }
   
   func addStep4() {
      
      let move = SKAction.moveBy(x: 0, y: 30, duration: 8)
      let action = SKAction.sequence([
         SKAction.fadeIn(withDuration: 1),
         SKAction.wait(forDuration: 6),
         SKAction.fadeOut(withDuration: 1),
         SKAction.removeFromParent()
      ])
      
      
      let texts = [
         "The four color theorem is",
         "a theorem of mathematics.",
         "It says that in any plane",
         "surface with regions in it",
         "the regions can be colored",
         "with no more than four colors.",
         "Two regions that have a common",
         "border must not get the same",
         "color. They are called adjacent",
         "(next to each other) if they",
         "share a segment of the border,",
         "not just a point."]
      for (index, element) in texts.enumerated()  {
         let wait = SKAction.wait(forDuration: 8.5 * Double(index/6))
         let label1 = SKLabelNode(fontNamed:"Avenir-Light")
         label1.alpha = 0
         label1.text = element
         label1.fontSize = 42
         if index % 6 == 0 {
            label1.position = CGPoint(x: size.width/2, y: size.height/2 + 150)
         } else if index % 6 == 1 {
            label1.position = CGPoint(x: size.width/2, y: size.height/2 + 90)
         } else if index % 6 == 2 {
            label1.position = CGPoint(x: size.width/2, y: size.height/2 + 30)
         } else if index % 6 == 3 {
            label1.position = CGPoint(x: size.width/2, y: size.height/2 - 30)
         } else if index % 6 == 4 {
            label1.position = CGPoint(x: size.width/2, y: size.height/2 - 90)
         } else if index % 6 == 5 {
            label1.position = CGPoint(x: size.width/2, y: size.height/2 - 150)
         }
         
         label1.fontColor = UIColor.white
         label1.run(SKAction.sequence([wait, SKAction.group([move, action])]))
         addChild(label1)
      }
      
      DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double((Int64)(17 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) {
         if (!self.stopped) {
            self.backToMenu(CGPoint(x:self.size.width/2, y:self.size.height/2))
         }
      }
      
      
   }
   
   func touchedButton(_ touch:UITouch, buttons:[SKNode?])->SKNode? {
      var node:SKNode?
      var maxz:CGFloat = -1
      for button:SKNode? in buttons {
         if (button != nil) {
            var rect = button!.frame
            let point = touch.location(in: button!.parent!)
            rect = rect.insetBy(dx: 0, dy: -rect.height)
            if rect.contains(point) {
               if (maxz < button!.zPosition) {
                  node = button
                  maxz = button!.zPosition
               }
            }
         }
      }
      return node
   }
   
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      if (activeTouch == nil) {
         if let touch = touches.first {
            let gotit = childNode(withName: "gotit")
            if let button = touchedButton(touch, buttons: [gotit]) {
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
         let gotit = childNode(withName: "gotit")
         let newActiveNode = touchedButton(touch, buttons: [gotit])
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
   
   
   override func update(_ currentTime: TimeInterval) {
      updateShaderTransition(currentTime)
   }
   
   func backToMenu(_ pos: CGPoint) {
      self.isUserInteractionEnabled = false
      let scene = MainMenuScene(size: self.size)
      let color = UIColor(hue: 0.0, saturation: 0, brightness: 0.8, alpha: 1)
      self.stopped = true
      self.presentScene(scene, center:pos, color:color, transitionDuration: 0.6)
   }
   
   override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
      defer {
         activeTouch = nil
         activeButton = nil
      }
      guard let touch = activeTouch, touches.contains(touch) else {
         return
      }
      guard let _ = activeButton else {
         return
      }
      
      let gotit = childNode(withName: "gotit")
      guard let touchedButton = touchedButton(touch, buttons: [gotit]) else {
         return
      }
      if touchedButton == activeButton {
         //button touched
         if activeButton == gotit {
            let pos = touch.location(in: self)
            backToMenu(pos)
         }
      }
      touchedButton.run(SKAction.sequence([SKAction.wait(forDuration: 0.1), SKAction.scale(to: 1.0, duration: 0.1)]))
   }
}
