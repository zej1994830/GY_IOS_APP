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

import SpriteKit
import SceneKit

// Information about a level
struct GameLevel {
  let canPositions: [SCNVector3]
}

class GameHelper {
    
  // Defaults key for persisting the highscore
  fileprivate let kHighscoreKey = "highscore"
  
  // Hud nodes
  var hudNode: SCNNode!
  fileprivate var labelNode: SKLabelNode!
  
  // Gameplay references
  var canNodes = [SCNNode]()
  var ballNodes = [SCNNode]() {
    didSet {
      refreshLabel()
    }
  }
  
  // Game's score
  var score = 0 {
    didSet {
      if score > highScore {
        highScore = score
      }
      refreshLabel()
    }
  }
  
  var highScore: Int {
    get {
      return UserDefaults.standard.integer(forKey: kHighscoreKey)
    }
    set {
      UserDefaults.standard.set(newValue, forKey: kHighscoreKey)
      UserDefaults.standard.synchronize()
    }
  }
  
  var menuLabelNode: SKLabelNode!
  
  var menuHUDMaterial: SCNMaterial {
    // Create a HUD label node in SpriteKit
    let sceneSize = CGSize(width: 300, height: 200)
    
    let skScene = SKScene(size: sceneSize)
    skScene.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
    
    let instructionLabel = SKLabelNode(fontNamed: "Menlo-Bold")
    instructionLabel.fontSize = 35
    instructionLabel.text = "Tap To Play"
    instructionLabel.position.x = sceneSize.width / 2
    instructionLabel.position.y = 115
    skScene.addChild(instructionLabel)
    
    menuLabelNode = SKLabelNode(fontNamed: "Menlo-Bold")
    menuLabelNode.fontSize = 24
    
    menuLabelNode.position.x = sceneSize.width / 2
    menuLabelNode.position.y = 60
    skScene.addChild(menuLabelNode)
    
    let material = SCNMaterial()
    material.lightingModel = SCNMaterial.LightingModel.constant
    material.isDoubleSided = true
    material.diffuse.contents = skScene
    
    return material
  }
  
  // Game state
  enum GameStateType {
    case tapToPlay
    case playing
  }
  
  // Maximum number of ball attempts
  static let maxBallNodes = 5
  static let gameEndActionKey = "game_end"
  static let ballCanCollisionAudioKey = "ball_hit_can"
  static let ballFloorCollisionAudioKey = "ball_hit_floor"
  
  // Game state
  var currentLevel = 0
  var levels = [GameLevel]()
  var state = GameStateType.tapToPlay
  
  // Audio sources
  lazy var whooshAudioSource: SCNAudioSource = {
    let source = SCNAudioSource(fileNamed: "sounds/whoosh.aiff")!
    
    source.isPositional = false
    source.volume = 0.15
    
    return source
  }()
  lazy var ballCanAudioSource: SCNAudioSource = {
    let source = SCNAudioSource(fileNamed: "sounds/ball_can.aiff")!
    
    source.isPositional = true
    source.volume = 0.6
    
    return source
  }()
  lazy var ballFloorAudioSource: SCNAudioSource = {
    let source = SCNAudioSource(fileNamed: "sounds/ball_floor.aiff")!
    
    source.isPositional = true
    source.volume = 0.6
    
    return source
  }()
  lazy var canFloorAudioSource: SCNAudioSource = {
    let source = SCNAudioSource(fileNamed: "sounds/can_floor.aiff")!
    
    source.isPositional = true
    source.volume = 0.6
    
    return source
  }()
  
  init() {
    loadAudio()
    createHud()
    refreshLabel()
  }
  
  func refreshLabel() {
    guard let labelNode = labelNode else { return }
    labelNode.text = "⚾️: \(GameHelper.maxBallNodes - ballNodes.count) | 🍺: \(score)"
  }
  
  func createHud() {
    let screen = UIScreen.main.bounds
    
    // Create a HUD label node in SpriteKit
    let skScene = SKScene(size: CGSize(width: screen.width, height: 100))
    skScene.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
    
    labelNode = SKLabelNode(fontNamed: "Menlo-Bold")
    labelNode.fontSize = 35
    labelNode.position.y = 50
    labelNode.position.x = screen.width / 2
    
    skScene.addChild(labelNode)
    
    // Add the SKScene to a plane node
    let plane = SCNPlane(width: 5, height: 1)
    let material = SCNMaterial()
    material.lightingModel = SCNMaterial.LightingModel.constant
    material.isDoubleSided = true
    material.diffuse.contents = skScene
    plane.materials = [material]
    
    // Add the hud to the level
    hudNode = SCNNode(geometry: plane)
    hudNode.name = "hud"
    hudNode.position = SCNVector3(x: 0.0, y: 6.0, z: -4.5)
    hudNode.rotation = SCNVector4(x: 1, y: 0, z: 0, w: Float(M_PI))
  }
  
  func loadAudio() {
    let sources = [
      whooshAudioSource,
      ballCanAudioSource,
      ballFloorAudioSource,
      canFloorAudioSource
    ]
    
    for source in sources {
      source.load()
    }
  }
  
}
