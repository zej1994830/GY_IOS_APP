/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import GameplayKit
import SceneKit
import SpriteKit

class GameViewController: UIViewController {
  
  let helper = GameHelper()
  
  // Scene properties
  var menuScene = SCNScene(named: "resources.scnassets/Menu.scn")!
  var levelScene = SCNScene(named: "resources.scnassets/Level.scn")!
  
  // Node properties
  var cameraNode: SCNNode!
  var shelfNode: SCNNode!
  var baseCanNode: SCNNode!
  
  var currentBallNode: SCNNode?
  
  // Ball throwing mechanics
  var startTouchTime: TimeInterval!
  var endTouchTime: TimeInterval!
  var startTouch: UITouch?
  var endTouch: UITouch?
  
  var bashedCanNames: [String] = []
  
  // Node that intercept touches in the scene
  lazy var touchCatchingPlaneNode: SCNNode = {
    let node = SCNNode(geometry: SCNPlane(width: 40, height: 40))
    node.opacity = 0.001
    node.castsShadow = false
    return node
  }()
  
  // Accessor for the SCNView
  var scnView: SCNView {
    let scnView = view as! SCNView
    
    scnView.backgroundColor = UIColor.black
    
    return scnView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    presentMenu()
    createScene()
  }
  
  // MARK: - Helpers
  func presentMenu() {
    let hudNode = menuScene.rootNode.childNode(withName: "hud", recursively: true)!
    hudNode.geometry?.materials = [helper.menuHUDMaterial]
    hudNode.rotation = SCNVector4(x: 1, y: 0, z: 0, w: Float(M_PI))
    
    helper.state = .tapToPlay
    helper.menuLabelNode.text = "Highscore: \(helper.highScore)"
    
    let transition = SKTransition.crossFade(withDuration: 1.0)
    scnView.present(
      menuScene,
      with: transition,
      incomingPointOfView: nil,
      completionHandler: nil
    )
  }
  
  func presentLevel() {
    resetLevel()
    setupNextLevel()
    helper.state = .playing
    
    let transition = SKTransition.crossFade(withDuration: 1.0)
    scnView.present(
      levelScene,
      with: transition,
      incomingPointOfView: nil,
      completionHandler: nil
    )
  }
  
  func resetLevel() {
    currentBallNode?.removeFromParentNode()
    
    bashedCanNames.removeAll()
    
    for canNode in helper.canNodes {
      canNode.removeFromParentNode()
    }
    helper.canNodes.removeAll()
    
    for ballNode in helper.ballNodes {
      ballNode.removeFromParentNode()
    }
  }
  
  func setupNextLevel() {
    if helper.ballNodes.count > 0 {
      helper.ballNodes.removeLast()
    }
    
    let level = helper.levels[helper.currentLevel]
    for idx in 0..<level.canPositions.count {
      let canNode = baseCanNode.clone()
      canNode.geometry = baseCanNode.geometry?.copy() as? SCNGeometry
      canNode.geometry?.firstMaterial = baseCanNode.geometry?.firstMaterial?.copy() as? SCNMaterial
      
      let shouldCreateBaseVariation = GKRandomSource.sharedRandom().nextInt() % 2 == 0
      
      canNode.eulerAngles = SCNVector3(x: 0, y: shouldCreateBaseVariation ? -110 : 55, z: 0)
      canNode.name = "Can #\(idx)"
      
      if let materials = canNode.geometry?.materials {
        for material in materials where material.multiply.contents != nil {
          if shouldCreateBaseVariation {
            material.multiply.contents = "resources.scnassets/Can_Diffuse-2.png"
          } else {
            material.multiply.contents = "resources.scnassets/Can_Diffuse-1.png"
          }
        }
      }
      
      let canPhysicsBody = SCNPhysicsBody(
        type: .dynamic,
        shape: SCNPhysicsShape(geometry: SCNCylinder(radius: 0.33, height: 1.125), options: nil)
      )
      canPhysicsBody.mass = 0.75
      canPhysicsBody.contactTestBitMask = 1
      canNode.physicsBody = canPhysicsBody
      canNode.position = level.canPositions[idx]
      
      levelScene.rootNode.addChildNode(canNode)
      helper.canNodes.append(canNode)
    }
    
    let waitAction = SCNAction.wait(duration: 1.0)
    let blockAction = SCNAction.run { _ in
      self.dispenseNewBall()
    }
    let sequenceAction = SCNAction.sequence([waitAction, blockAction])
    levelScene.rootNode.runAction(sequenceAction)
  }
  
  func createLevelsFrom(baseNode: SCNNode) {
    // Level 1
    let levelOneCanOne = SCNVector3(
      x: baseNode.position.x - 0.5,
      y: baseNode.position.y + 0.62,
      z: baseNode.position.z
    )
    let levelOneCanTwo = SCNVector3(
      x: baseNode.position.x + 0.5,
      y: baseNode.position.y + 0.62,
      z: baseNode.position.z
    )
    let levelOneCanThree = SCNVector3(
      x: baseNode.position.x,
      y: baseNode.position.y + 1.75,
      z: baseNode.position.z
    )
    let levelOne = GameLevel(
      canPositions: [
        levelOneCanOne,
        levelOneCanTwo,
        levelOneCanThree
      ]
    )
    
    // Level 2
    let levelTwoCanOne = SCNVector3(
      x: baseNode.position.x - 0.65,
      y: baseNode.position.y + 0.62,
      z: baseNode.position.z
    )
    let levelTwoCanTwo = SCNVector3(
      x: baseNode.position.x - 0.65,
      y: baseNode.position.y + 1.75,
      z: baseNode.position.z
    )
    let levelTwoCanThree = SCNVector3(
      x: baseNode.position.x + 0.65,
      y: baseNode.position.y + 0.62,
      z: baseNode.position.z
    )
    let levelTwoCanFour = SCNVector3(
      x: baseNode.position.x + 0.65,
      y: baseNode.position.y + 1.75,
      z: baseNode.position.z
    )
    let levelTwo = GameLevel(
      canPositions: [
        levelTwoCanOne,
        levelTwoCanTwo,
        levelTwoCanThree,
        levelTwoCanFour
      ]
    )
    
    helper.levels = [levelOne, levelTwo]
  }
  
  func dispenseNewBall() {
    let ballScene = SCNScene(named: "resources.scnassets/Ball.scn")!
    
    let ballNode = ballScene.rootNode.childNode(withName: "sphere", recursively: true)!
    ballNode.name = "ball"
    let ballPhysicsBody = SCNPhysicsBody(
      type: .dynamic,
      shape: SCNPhysicsShape(geometry: SCNSphere(radius: 0.35))
    )
    ballPhysicsBody.mass = 3
    ballPhysicsBody.friction = 2
    ballPhysicsBody.contactTestBitMask = 1
    ballNode.physicsBody = ballPhysicsBody
    ballNode.position = SCNVector3(x: -1.75, y: 1.75, z: 8.0)
    ballNode.physicsBody?.applyForce(SCNVector3(x: 0.825, y: 0, z: 0), asImpulse: true)
    
    currentBallNode = ballNode
    levelScene.rootNode.addChildNode(ballNode)
  }
  
  func throwBall() {
    guard let ballNode = currentBallNode else { return }
    guard let endingTouch = endTouch else { return }
    
    let firstTouchResult = scnView.hitTest(
      endingTouch.location(in: view),
      options: nil
      ).filter({
        $0.node == touchCatchingPlaneNode
    }).first
    
    guard let touchResult = firstTouchResult else { return }
    
    levelScene.rootNode.runAction(
      SCNAction.playAudio(
        helper.whooshAudioSource,
        waitForCompletion: false
      )
    )
    
    let timeDifference = endTouchTime - startTouchTime
    let velocityComponent = Float(min(max(1 - timeDifference, 0.1), 1.0))
    
    let impulseVector = SCNVector3(
      x: touchResult.localCoordinates.x,
      y: touchResult.localCoordinates.y * velocityComponent * 3,
      z: shelfNode.position.z * velocityComponent * 15
    )
    
    ballNode.physicsBody?.applyForce(impulseVector, asImpulse: true)
    helper.ballNodes.append(ballNode)
    
    currentBallNode = nil
    startTouchTime = nil
    endTouchTime = nil
    startTouch = nil
    endTouch = nil
    
    if helper.ballNodes.count == GameHelper.maxBallNodes {
      let waitAction = SCNAction.wait(duration: 3)
      let blockAction = SCNAction.run { _ in
        self.resetLevel()
        self.helper.ballNodes.removeAll()
        self.helper.currentLevel = 0
        self.helper.score = 0
        self.presentMenu()
      }
      let sequenceAction = SCNAction.sequence([waitAction, blockAction])
      levelScene.rootNode.runAction(sequenceAction, forKey: GameHelper.gameEndActionKey)
    } else {
      let waitAction = SCNAction.wait(duration: 0.5)
      let blockAction = SCNAction.run { _ in
        self.dispenseNewBall()
      }
      let sequenceAction = SCNAction.sequence([waitAction, blockAction])
      levelScene.rootNode.runAction(sequenceAction)
    }
  }
  
  // MARK: - Creation
  func createScene() {
    levelScene.physicsWorld.contactDelegate = self
    
    cameraNode = levelScene.rootNode.childNode(withName: "camera", recursively: true)!
    shelfNode = levelScene.rootNode.childNode(withName: "shelf", recursively: true)!
    
    guard let canScene = SCNScene(named: "resources.scnassets/Can.scn") else { return }
    baseCanNode = canScene.rootNode.childNode(withName: "can", recursively: true)!
    
    let shelfPhysicsBody = SCNPhysicsBody(
      type: .static,
      shape: SCNPhysicsShape(geometry: shelfNode.geometry!)
    )
    shelfPhysicsBody.isAffectedByGravity = false
    shelfNode.physicsBody = shelfPhysicsBody
    
    levelScene.rootNode.addChildNode(touchCatchingPlaneNode)
    touchCatchingPlaneNode.position = SCNVector3(x: 0, y: 0, z: shelfNode.position.z)
    touchCatchingPlaneNode.eulerAngles = cameraNode.eulerAngles
    
    createLevelsFrom(baseNode: shelfNode)
    levelScene.rootNode.addChildNode(helper.hudNode)
  }
  
  // MARK: - Touches
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    
    if helper.state == .tapToPlay {
      presentLevel()
    } else {
      guard let firstTouch = touches.first else { return }
      
      let point = firstTouch.location(in: scnView)
      let hitResults = scnView.hitTest(point, options: [:])
      
      if hitResults.first?.node == currentBallNode {
        startTouch = touches.first
        startTouchTime = Date().timeIntervalSince1970
      }
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    
    guard startTouch != nil else { return }
    
    endTouch = touches.first
    endTouchTime = Date().timeIntervalSince1970
    throwBall()
  }
  
  // MARK: - ViewController Overrides
  override var prefersStatusBarHidden : Bool {
    return true
  }
  
  override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
    return UIDevice.current.userInterfaceIdiom == .phone ? .portrait : .all
  }
  
}

extension GameViewController: SCNPhysicsContactDelegate {
  
  // MARK: SCNPhysicsContactDelegate
  func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
    guard let nodeNameA = contact.nodeA.name else { return }
    guard let nodeNameB = contact.nodeB.name else { return }
    
    var ballFloorContactNode: SCNNode?
    if nodeNameA == "ball" && nodeNameB == "floor" {
      ballFloorContactNode = contact.nodeA
    } else if nodeNameB == "ball" && nodeNameA == "floor" {
      ballFloorContactNode = contact.nodeB
    }
    
    if let ballNode = ballFloorContactNode {
      guard ballNode.action(forKey: GameHelper.ballFloorCollisionAudioKey) == nil else { return }
      
      ballNode.runAction(
        SCNAction.playAudio(
          helper.ballFloorAudioSource,
          waitForCompletion: true
        ),
        forKey: GameHelper.ballFloorCollisionAudioKey
      )
      return
    }
    
    var ballCanContactNode: SCNNode?
    if nodeNameA.contains("Can") && nodeNameB == "ball" {
      ballCanContactNode = contact.nodeA
    } else if nodeNameB.contains("Can") && nodeNameA == "ball" {
      ballCanContactNode = contact.nodeB
    }
    
    if let canNode = ballCanContactNode {
      guard canNode.action(forKey: GameHelper.ballCanCollisionAudioKey) == nil else {
        return
      }
      
      canNode.runAction(
        SCNAction.playAudio(
          helper.ballCanAudioSource,
          waitForCompletion: true
        ),
        forKey: GameHelper.ballCanCollisionAudioKey
      )
      return
    }
    
    if bashedCanNames.contains(nodeNameA) || bashedCanNames.contains(nodeNameB) { return }
    
    var canNodeWithContact: SCNNode?
    if nodeNameA.contains("Can") && nodeNameB == "floor" {
      canNodeWithContact = contact.nodeA
    } else if nodeNameB.contains("Can") && nodeNameA == "floor" {
      canNodeWithContact = contact.nodeB
    }
    
    if let bashedCan = canNodeWithContact {
      bashedCan.runAction(
        SCNAction.playAudio(
          helper.canFloorAudioSource,
          waitForCompletion: false
        )
      )
      bashedCanNames.append(bashedCan.name!)
      helper.score += 1
    }
    
    if bashedCanNames.count == helper.canNodes.count {
      if levelScene.rootNode.action(forKey: GameHelper.gameEndActionKey) != nil {
        levelScene.rootNode.removeAction(forKey: GameHelper.gameEndActionKey)
      }
      
      let maxLevelIndex = helper.levels.count - 1
      
      if helper.currentLevel == maxLevelIndex {
        helper.currentLevel = 0
      } else {
        helper.currentLevel += 1
      }
      
      let waitAction = SCNAction.wait(duration: 1.0)
      let blockAction = SCNAction.run { _ in
        self.resetLevel()
        self.setupNextLevel()
      }
      let sequenceAction = SCNAction.sequence([waitAction, blockAction])
      levelScene.rootNode.runAction(sequenceAction)
    }
  }
}
