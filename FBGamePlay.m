//
//  FBGamePlay.m
//  FlappyBird
//
//  Created by Domingo on 2/12/2014.
//  Copyright (c) 2014 Domingo. All rights reserved.
//

#import "FBGamePlay.h"
#import "FBGameOver.h"

const float GAP_PERCENTAGE = 0.23;
const int PIPE_INTERVAL = 2;

@implementation FBGamePlay
{
    SKSpriteNode *bird;
    CFTimeInterval startTime;
}

- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
    }
    
    self.physicsWorld.contactDelegate = self;
    startTime = CACurrentMediaTime();
}

- (void)createSceneContents
{
    self.backgroundColor = [SKColor blackColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    
    self.physicsWorld.gravity = CGVectorMake(0.0, -9.5);
    
    bird = [[SKSpriteNode alloc]initWithImageNamed:@"FB-icon.png"];
    bird.size = CGSizeMake(30, 30);
    bird.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    bird.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:bird.size.width/2];
    bird.physicsBody.dynamic = YES;
    bird.physicsBody.mass = 1;
    bird.physicsBody.affectedByGravity = YES;
    
    
    [self addChild:bird];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    //Check postion
    if (bird.position.y <= 0)
        [self gameOver];
    if (bird.position.y >= self.frame.size.height)
        bird.physicsBody.velocity = CGVectorMake(0, 0);
    
    //Update time interval for pipes to come in
    if (currentTime - startTime >= PIPE_INTERVAL) {
        [self makePipes];
        startTime += PIPE_INTERVAL;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    bird.physicsBody.velocity = CGVectorMake(0, 0);
    [bird.physicsBody applyImpulse:CGVectorMake(0.0, 450)];
}

- (void)makePipes {
    int topPipeBaseY = arc4random() % (int)self.frame.size.height * GAP_PERCENTAGE + 50;
    NSLog(@"%i", topPipeBaseY);
    
    //pipe 1
    UIImage *pipeImage = [UIImage imageNamed:@"FB-trunk.png"];
    CGImageRef pipeCGImage = CGImageCreateWithImageInRect(pipeImage.CGImage, CGRectMake(0, 0, pipeImage.size.width, topPipeBaseY));
    SKSpriteNode *pipe1 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithCGImage:pipeCGImage]];
    pipe1.position = CGPointMake(self.frame.size.width + pipe1.size.width/2, self.frame.size.height - pipe1.size.height/4);
    pipe1.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:pipe1.size];
    pipe1.physicsBody.contactTestBitMask = 0xFFFFFFFF;
    pipe1.physicsBody.dynamic = NO;
    [self addChild:pipe1];
    
    
    //pipe2
    int pipe2Height = self.frame.size.height * (1.0 - GAP_PERCENTAGE) - topPipeBaseY;
    pipeCGImage = CGImageCreateWithImageInRect(pipeImage.CGImage, CGRectMake(0, pipeImage.size.height - pipe2Height, pipeImage.size.width, pipe2Height));
    SKSpriteNode *pipe2 = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithCGImage:pipeCGImage]];
    pipe2.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:pipe2.size];
    pipe2.position = CGPointMake(self.frame.size.width + pipe2.size.width/2, pipe2.size.height/4);
    pipe2.physicsBody.contactTestBitMask = 0xFFFFFFFF;
    pipe2.physicsBody.dynamic = NO;
    [self addChild:pipe2];
    
    
    //add action to pipes
    SKAction *moveLeft = [SKAction moveToX:-pipeImage.size.width/2 duration:5];
    [pipe1 runAction:moveLeft completion:^{
        [pipe1 removeFromParent];
    }];
    [pipe2 runAction:moveLeft completion:^{
        [pipe2 removeFromParent];
    }];
}

- (void) didBeginContact:(SKPhysicsContact *)contact {
    [self gameOver : contact.contactPoint];
}

- (void)gameOver {
    FBGameOver *gameOver = [[FBGameOver alloc]initWithSize:self.frame.size];
    [self.view presentScene:gameOver transition:[SKTransition pushWithDirection:SKTransitionDirectionUp duration:0.5]];
}

- (void)gameOver : (CGPoint) contactPoint{
    //self.paused = YES;
    
    SKSpriteNode *bang = [SKSpriteNode spriteNodeWithImageNamed:@"bang.png"];
    bang.position = contactPoint;
    bang.size = CGSizeMake(0, 0);
    [self addChild:bang];
    [bang runAction:[SKAction scaleTo:20 duration:0.4]];
    
    [self gameOver];
}

@end
