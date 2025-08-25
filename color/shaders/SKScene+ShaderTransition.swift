import Foundation
import SpriteKit

//private let totalAnimationDuration = 1.0
private let kNodeNameTransitionShaderNode = "kNodeNameTransitionShaderNode"
private let kNodeNameFadeColourOverlay = "kNodeNameFadeColourOverlay"
private var presentationStartTime: CFTimeInterval = -1
private var shaderChoice = -1
private var transitioningScene:SKScene?

extension SKScene {
   fileprivate var transitionShader: SKShader? {
      get {
         if let shaderContainerNode = self.childNode(withName: kNodeNameTransitionShaderNode) as? SKSpriteNode {
            return shaderContainerNode.shader
         }
         
         return nil
      }
      set {
         if let shaderContainerNode = self.childNode(withName: kNodeNameTransitionShaderNode) as? SKSpriteNode {
            shaderContainerNode.shader = newValue
         }
      }
   }
   
   fileprivate func createShader(_ shaderName: String, center:CGPoint, color:UIColor, transitionDuration: TimeInterval) -> SKShader {
      let shader = SKShader(fileNamed:shaderName)
      let scale:CGFloat = UIScreen.main.nativeBounds.width / size.width
      let u_size = SKUniform(name: "u_size", float: GLKVector3Make(Float(scale * size.width), Float(scale * size.height), 0))
      let u_center = SKUniform(name: "u_center", float: GLKVector3Make(Float(scale * center.x), Float(scale * center.y), 0))
      var red:CGFloat = 0, green:CGFloat = 0, blue:CGFloat = 0, alpha:CGFloat = 0
      color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
      let u_color = SKUniform(name: "u_color", float: GLKVector3Make(Float(red), Float(green) , Float(blue)))
      let u_total_animation_duration = SKUniform(name: "u_total_animation_duration", float: Float(transitionDuration))
      let u_elapsed_time = SKUniform(name: "u_elapsed_time", float: Float(0))
      shader.uniforms = [u_size, u_color, u_total_animation_duration, u_elapsed_time, u_center]
      return shader
   }
   
   func presentScene(_ scene: SKScene?, center:CGPoint, color:UIColor, transitionDuration: TimeInterval) {
      // Create shader and add it to the scene
      //		let shaderContainer = SKSpriteNode(imageNamed: "dummy")
      let shaderName = "circle.fsh"
      let shaderContainer = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 2, height: 2))
      shaderContainer.name = kNodeNameTransitionShaderNode
      shaderContainer.zPosition = 9999 // something arbitrarily large to ensure it's in the foreground
      shaderContainer.position = CGPoint(x: size.width / 2, y: size.height / 2)
      shaderContainer.size = CGSize(width: size.width, height: size.height)
      shaderContainer.shader = createShader(shaderName, center:center, color:color, transitionDuration:transitionDuration)
      self.addChild(shaderContainer)
      transitioningScene = scene
      // remove the shader from the scene after its animation has completed.
      let delayTime = DispatchTime.now() + Double(Int64(transitionDuration * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
      DispatchQueue.main.asyncAfter(deadline: delayTime, execute: { () -> Void in
         let fadeOverlay = SKSpriteNode(color: color, size: CGSize(width: self.size.width, height: self.size.height))
         fadeOverlay.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
         fadeOverlay.name = kNodeNameFadeColourOverlay
         fadeOverlay.zPosition = shaderContainer.zPosition
         fadeOverlay.run(SKAction.sequence([SKAction.fadeAlpha(to: 0, duration: 0.3), SKAction.removeFromParent()]))
         scene!.addChild(fadeOverlay)
         self.view!.presentScene(scene)
      })
      
      // Reset the time presentScene was called so that the elapsed time from now can
      // be calculated in updateShaderTransitions(currentTime:)
      presentationStartTime = -1
   }
   
   func updateShaderTransition(_ currentTime: CFTimeInterval) {
      if let shader = self.transitionShader {
         let elapsedTime = shader.uniformNamed("u_elapsed_time")!
         if (presentationStartTime < 0) {
            presentationStartTime = currentTime
         }
         elapsedTime.floatValue = Float(currentTime - presentationStartTime)
      }
   }
}
