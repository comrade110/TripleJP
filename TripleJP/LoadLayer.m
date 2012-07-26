//
//  LoadLayer.m
//  TripleJurassicPark
//
//  Created by user on 12-7-25.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoadLayer.h"
#import "GameScene.h"


@implementation LoadLayer

@synthesize director=director_;

-(id)init{

    self = [super init];
    
    if (self != nil) {
        
        CCSpriteBatchNode *loadBatchNode;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"titlePack-hd.plist"];
            
            loadBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"titlePack-hd.png"];
            
        }else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"titlePack.plist"];
            
            loadBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"titlePack.png"];
        }
        CCSprite *btnSprite = [CCSprite spriteWithSpriteFrameName:@"button_start.png"];
        
        sBtn = [CCMenuItemImage itemWithNormalSprite:btnSprite selectedSprite:nil target:self selector:@selector(makeTransition)];
        
        loadMenu = [CCMenu menuWithItems:sBtn, nil];
        
        loadMenu.position = CGPointZero;
        
        
        bg = [CCSprite spriteWithSpriteFrameName:@"bg_title.png"];
        
        [loadBatchNode addChild:bg];
        
        
        [self addChild:loadMenu z:1];
        
        [self addChild:loadBatchNode z:0];
    
        CGSize screenSize = [[CCDirector sharedDirector] winSize];    
        
        [bg setPosition:CGPointMake(screenSize.width*0.5f, screenSize.height*0.5f)]; 
        
        [sBtn setPosition:CGPointMake(screenSize.width*0.5f, screenSize.height*0.2f)]; 
        
    	director_ = (CCDirectorIOS*) [CCDirector sharedDirector];
        
        director_.wantsFullScreenLayout = YES;
        
        [director_ setDelegate:self];
    }
    return self;
}

-(void) makeTransition
{
	[[CCDirector sharedDirector] replaceScene:[GameScene node]];
}


-(void)dealloc{
    
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

@end
