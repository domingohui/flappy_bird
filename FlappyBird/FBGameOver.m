//
//  FBGameOver.m
//  FlappyBird
//
//  Created by Domingo on 2/14/2014.
//  Copyright (c) 2014 Domingo. All rights reserved.
//

#import "FBGameOver.h"
#import "FBGamePlay.h"

@implementation FBGameOver

- (void)didMoveToView:(SKView *)view
{
    if (!self.contentCreated)
    {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents
{
    //self.view.backgroundColor = [UIColor blackColor];
    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Courier New"];
    [label setText:@"game over touch to try again"];
    label.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height*0.75);
    label.fontSize = 16;
    [self addChild:label];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    FBGamePlay *gamePlay = [[FBGamePlay alloc]initWithSize:self.size];
    SKTransition *door = [SKTransition doorsCloseVerticalWithDuration:0.35];
    [self.view presentScene:gamePlay transition:door];
}

@end
