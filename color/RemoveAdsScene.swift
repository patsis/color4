//
//  RemoveAdsScene.swift
//  color4
//
//  Created by Harry Patsis on 29/10/15.
//  Copyright © 2015 Harry Patsis. All rights reserved.
//

import SpriteKit

class RemoveAdsScene: SKScene {
  override init(size: CGSize) {
    super.init(size: size)
    scaleMode = .aspectFit
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("NSCoding not supported")
  }
  
  override func didMove(to view: SKView) {
    self.backgroundColor = UIColor(hue: 148/365, saturation: 1, brightness: 0.63, alpha: 1)

  }

  func backToMainMenu() {
    self.isUserInteractionEnabled = false
    let scene = MainMenuScene(size: self.size)
    let color = UIColor(hue: 0.0, saturation: 0, brightness: 0.8, alpha: 1)
    let pos = CGPoint(x: self.size.width/2, y: self.size.height/2)//touch.locationInNode(self)
    self.presentScene(scene, center:pos, color:color, transitionDuration: 0.6)
  }
  
  override func update(_ currentTime: TimeInterval) {
    updateShaderTransition(currentTime)
  }
  
  
}
