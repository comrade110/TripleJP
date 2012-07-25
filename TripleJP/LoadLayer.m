//
//  LoadLayer.m
//  TripleJurassicPark
//
//  Created by user on 12-7-25.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoadLayer.h"


@implementation LoadLayer


-(id)init{

    self = [super init];
    
    if (self != nil) {
        
        
        
        
        CCSpriteBatchNode *loadBatchNode = [CCSpriteBatchNode node];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"titlePack-hd.plist"];
            
            loadBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"titlePack-hd.png"];
            
        }else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"titlePack.plist"];
            
            loadBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"titlePack.png"];
        }
    
    bg = [CCSprite spriteWithSpriteFrameName:@"bg_title.png"];
        
    [loadBatchNode addChild:bg];
        
    [self addChild:loadBatchNode];
    
        CGSize screenSize = [[CCDirector sharedDirector] winSize];    
        
    [bg setPosition:CGPointMake(screenSize.width*0.5f, screenSize.height*0.5f)]; 
    
    }
    return self;
}

-(void)dealloc{
    
    [super dealloc];
}

@end
