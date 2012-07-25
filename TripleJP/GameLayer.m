//
//  GameLayer.m
//  TripleJP
//
//  Created by user on 12-7-25.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"


@implementation GameLayer

-(id)init{
    
    self = [super init];
    
    if (self != nil) {
        
        CCSpriteBatchNode *playBatchNode;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"tiled-hd.plist"];
            
            playBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"tiled-hd.png"];
            
        }else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"tiled.plist"];
            
            playBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"tiled.png"];
        }
        

        
        playBg = [CCSprite spriteWithSpriteFrameName:@"bg_main.png"];
        
        [playBatchNode addChild:playBg];
        
        [self addChild:playBatchNode];
        
        CGSize screenSize = [[CCDirector sharedDirector] winSize];    
        
        [playBg setPosition:CGPointMake(screenSize.width*0.5f, screenSize.height*0.5f)]; 
         
        
    }
    return self;
}

@end
