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
        
        CCSpriteBatchNode *bgTiledBatchNode;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"tiled-hd.plist"];
            
            bgTiledBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"tiled-hd.png"];
            
        }else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"tiled.plist"];
            
            bgTiledBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"tiled.png"];
        }
        
        CCSprite *tile3 = [CCSprite spriteWithSpriteFrameName:@"tile3.png"];
        CCSprite *tile4 = [CCSprite spriteWithSpriteFrameName:@"tile8.png"];
        CCSprite *tile5 = [CCSprite spriteWithSpriteFrameName:@"tile9.png"];
        CCSprite *tile8 = [CCSprite spriteWithSpriteFrameName:@"tile7.png"];
        CCSprite *tile9 = [CCSprite spriteWithSpriteFrameName:@"tile9.png"];
        
        
        playBg = [CCSprite spriteWithSpriteFrameName:@"bg_main.png"];
        
        [bgTiledBatchNode addChild:playBg z:0];
        [bgTiledBatchNode addChild:tile3 z:1];
        [bgTiledBatchNode addChild:tile4 z:1];
        [bgTiledBatchNode addChild:tile5 z:1];
        [bgTiledBatchNode addChild:tile8 z:1];
        [bgTiledBatchNode addChild:tile9 z:1];
        
        [self addChild:bgTiledBatchNode];
        
        CGSize screenSize = [[CCDirector sharedDirector] winSize];    
        
        [playBg setPosition:CGPointMake(screenSize.width*0.5f, screenSize.height*0.5f)]; 
        [tile3 setPosition:CGPointMake(tile3.anchorPointInPoints.x + 10, 335)]; 
        [tile4 setPosition:CGPointMake(75 + 10, 335)]; 
        [tile5 setPosition:CGPointMake(125 + 10, 335)]; 
        [tile8 setPosition:CGPointMake(75 + 10, 285)];  
        [tile9 setPosition:CGPointMake(125 + 10, 285)]; 
         
        
    }
    return self;
}

@end
