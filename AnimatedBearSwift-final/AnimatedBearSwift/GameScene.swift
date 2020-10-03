/**
 * GameScene.swift
 * AnimatedBearSwift
 *
 * Copyright (c) 2017 Razeware LLC
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
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
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

class GameScene: SKScene {
  
  private var bear = SKSpriteNode()
  private var bearWalkingFrames: [SKTexture] = []
  
  override func didMove(to view: SKView) {
    backgroundColor = .blue
    buildBear()
  }
  
  // MARK: - Bear code
  func buildBear() {
    let bearAnimatedAtlas = SKTextureAtlas(named: "BearImages")
    var walkFrames: [SKTexture] = []
    
    let numImages = bearAnimatedAtlas.textureNames.count
    for i in 1...numImages {
      let bearTextureName = "bear\(i)"
      walkFrames.append(bearAnimatedAtlas.textureNamed(bearTextureName))
    }
    bearWalkingFrames = walkFrames
    
    let firstFrameTexture = bearWalkingFrames[0]
    bear = SKSpriteNode(texture: firstFrameTexture)
    bear.position = CGPoint(x: frame.midX, y: frame.midY)
    addChild(bear)
  }
  
  func animateBear() {
    bear.run(SKAction.repeatForever(
      SKAction.animate(with: bearWalkingFrames,
                       timePerFrame: 0.1,
                       resize: false,
                       restore: true)),
             withKey:"walkingInPlaceBear")
  }
  
  func moveBear(location: CGPoint) {
    // 1
    var multiplierForDirection: CGFloat
    
    // 2
    let bearSpeed = frame.size.width / 3.0
    
    // 3
    let moveDifference = CGPoint(x: location.x - bear.position.x, y: location.y - bear.position.y)
    let distanceToMove = sqrt(moveDifference.x * moveDifference.x + moveDifference.y * moveDifference.y)
    
    // 4
    let moveDuration = distanceToMove / bearSpeed
    
    // 5
    if moveDifference.x < 0 {
      multiplierForDirection = 1.0
    } else {
      multiplierForDirection = -1.0
    }
    bear.xScale = abs(bear.xScale) * multiplierForDirection
    
    // 1
    if bear.action(forKey: "walkingInPlaceBear") == nil {
      // if legs are not moving, start them
      animateBear()
    }
    
    // 2
    let moveAction = SKAction.move(to: location, duration:(TimeInterval(moveDuration)))
    
    // 3
    let doneAction = SKAction.run({ [weak self] in
      self?.bearMoveEnded()
    })
    
    // 4
    let moveActionWithDone = SKAction.sequence([moveAction, doneAction])
    bear.run(moveActionWithDone, withKey:"bearMoving")
  }
  
  func bearMoveEnded() {
    bear.removeAllActions()
  }
  
  // MARK: - Handle touches
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touch = touches.first!
    let location = touch.location(in: self)
    moveBear(location: location)
  }
}
