//
//  FBMyScene.m
//  FlappyBird
//
//  Created by Domingo on 2/12/2014.
//  Copyright (c) 2014 Domingo. All rights reserved.
//

#import "FBMyScene.h"
#import "FBGamePlay.h"

@implementation FBMyScene
@synthesize bird;


-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Courier"];
        
        myLabel.text = @"flappybird";
        myLabel.fontSize = 30;
        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame)*1.5);
        [self addChild:myLabel];
        
        
        //the bird
        bird = [[SKSpriteNode alloc]init];
        bird.size = CGSizeMake(30, 30);
        bird.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        
        /*
        NSArray *birdIcons = [NSArray arrayWithObjects:[UIImage imageNamed:@"FB-icon1.png"], [UIImage imageNamed:@"FB-icon2.png"], nil];
        SKAction *action = [SKAction animateWithTextures:birdIcons timePerFrame:1];
        [bird runAction:action];
         */
        
        [self addChild:bird];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    FBGamePlay *gamePlay = [[FBGamePlay alloc]initWithSize:self.size];
    SKTransition *door = [SKTransition doorsCloseVerticalWithDuration:0.35];
    [self.view presentScene:gamePlay transition:door];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
