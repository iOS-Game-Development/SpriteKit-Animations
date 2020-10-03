//
//  GameScene.swift
//  MyAnimatedBearSwift
//
//  Created by Hung Phan on 10/2/20.
//

import Foundation
import SpriteKit

class GameScene: SKScene {
    private var bear = SKSpriteNode()
    private var bearWalkingFrames: [SKTexture] = []
    
    override func didMove(to view: SKView) {
        backgroundColor = .blue
        buildBear()
//        animateBear()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
//
//        var multiplierForDirection: CGFloat
//        if location.x < frame.midX {
//            // walk left
//            multiplierForDirection = 1.0
//        } else {
//            // walk right
//            multiplierForDirection = -1.0
//        }
//
//        // 0 to 1 = left bear
//        // 0 to -1 = right bear
//        bear.xScale = abs(bear.xScale) * multiplierForDirection
//        animateBear()
        
        moveBear(location: location)
        
    }
    
    func moveBear(location: CGPoint) {
        var multiplierForDirection: CGFloat
        let bearSpeed = frame.size.width / 3.0
        let moveDifference = CGPoint(x: location.x - bear.position.x, y: location.y - bear.position.y)
        let distanceToMove = sqrt(moveDifference.x * moveDifference.x + moveDifference.y * moveDifference.y)
        let moveDuration = distanceToMove / bearSpeed
        if moveDifference.x < 0 {
            multiplierForDirection = 1.0
        }
        else {
            multiplierForDirection = -1.0
        }
        bear.xScale = abs(bear.xScale) * multiplierForDirection
        
        if bear.action(forKey: "walkingInPlaceBear") == nil {
            animateBear()
        }
        
        let moveAction = SKAction.move(to: location, duration: (TimeInterval(moveDuration)))
        let doneAction = SKAction.run({
            [weak self] in self?.bearMoveEnded()
        })
        
        let moveActionWithDone = SKAction.sequence([moveAction, doneAction])
        bear.run(moveActionWithDone, withKey: "bearMoving")
    }
    
    func buildBear() {
        let bearAnimatedAtlas = SKTextureAtlas(named: "BearImages")
        var walkFrames : [SKTexture] = []
        
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
        bear.run(SKAction.repeatForever(SKAction.animate(with: bearWalkingFrames, timePerFrame: 0.1, resize: false, restore: true)), withKey: "walkingInPlaceBear")
    }
    
    func bearMoveEnded() {
        bear.removeAllActions()
    }
}
