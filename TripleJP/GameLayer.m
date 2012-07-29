//
//  GameLayer.m
//  TripleJP
//
//  Created by user on 12-7-25.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"
#import "ReflashUnit.h"


@implementation GameLayer


-(id)init{
    
    self = [super init];
    
    if (self != nil) {
        
        CCSpriteBatchNode *bgTiledBatchNode;
        CCSpriteBatchNode *refreshBatchNode;
        
        NSString *nowUnitID = [[ReflashUnit node] getUnitID];
        
        NSLog(@"~~~~~%@~~~~~",nowUnitID);
     
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {

            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"layout-hd.plist"];
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"texturePack-hd.plist"];
            
            bgTiledBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"layout-hd.png"];
            refreshBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"texturePack-hd.png"];
            
        }else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"layout.plist"];
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"texturePack.plist"];
            
            bgTiledBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"layout.png"];
            refreshBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"texturePack.png"];
        }
        
        CCSprite *tile3 = [CCSprite spriteWithSpriteFrameName:@"tile3.png"];
        CCSprite *tile4 = [CCSprite spriteWithSpriteFrameName:@"tile8.png"];
        CCSprite *tile5 = [CCSprite spriteWithSpriteFrameName:@"tile9.png"];
        CCSprite *tile8 = [CCSprite spriteWithSpriteFrameName:@"tile7.png"];
        CCSprite *tile9 = [CCSprite spriteWithSpriteFrameName:@"tile9.png"];
        CCSprite *unitStorage = [CCSprite spriteWithSpriteFrameName:@"main_bar.png"];
        refreshUnit = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@_s.png",nowUnitID]]; 

        
        
        playBg = [CCSprite spriteWithSpriteFrameName:@"bg_main.png"];
        
        [bgTiledBatchNode addChild:playBg z:0];
        [refreshBatchNode addChild:tile3 z:1];
        [refreshBatchNode addChild:tile4 z:1];
        [refreshBatchNode addChild:tile5 z:1];
        [refreshBatchNode addChild:tile8 z:1];
        [refreshBatchNode addChild:tile9 z:1];
        [bgTiledBatchNode addChild:unitStorage z:1];
        [refreshBatchNode addChild:refreshUnit z:2];
        
        [self addChild:bgTiledBatchNode];
        [self addChild:refreshBatchNode];
        
        CGSize screenSize = [[CCDirector sharedDirector] winSize];    
        
        [playBg setPosition:CGPointMake(screenSize.width*0.5f, screenSize.height*0.5f)]; 
        [tile3 setPosition:CGPointMake(tile3.anchorPointInPoints.x + 10, 320)]; 
        [tile4 setPosition:CGPointMake(75 + 10, 320)]; 
        [tile5 setPosition:CGPointMake(125 + 10, 320)]; 
        [tile8 setPosition:CGPointMake(75 + 10, 270)];  
        [tile9 setPosition:CGPointMake(125 + 10, 270)]; 
        [unitStorage setPosition:CGPointMake(screenSize.width*0.5f, 380)]; 
        [refreshUnit setPosition:CGPointMake(screenSize.width*0.5f, 380)]; 
        
        map = [NSArray arrayWithObjects:line1,line2,line3,line4,line5,line6, nil];
        self.isTouchEnabled = YES;
        
    }
    return self;
}

- (NSString *) dataPath
{
    NSArray *storeFilePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *doucumentsDirectiory = [storeFilePath objectAtIndex:0];
    NSLog(@"%@",doucumentsDirectiory);
    
    return [doucumentsDirectiory stringByAppendingPathComponent:@"refreshUnit.plist"];
    
}

-(CCSprite *)setUnitPositon{
    
    
    CCSprite *dd = [CCSprite node];
    return dd;
    
}
-(void)onEnter{
        self.isTouchEnabled = YES;

}


-(CGRect)AtlasRect:(CCSprite *)atlSpr
{
    CGRect rc = [atlSpr textureRect];
    return CGRectMake( - rc.size.width / 2, -rc.size.height / 2, rc.size.width, rc.size.height); 
}


-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"你没啊00");
    CGPoint pt =[touch locationInView: [touch view]];    
    CGPoint touchPoint = [refreshUnit convertTouchToNodeSpaceAR:touch];
    
    CGRect rect = [self AtlasRect:refreshUnit];
    NSLog(@"~~~%@~~~~~",pt);
    
    
    return CGRectContainsPoint(rect, [refreshUnit convertTouchToNodeSpaceAR:touch]);
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"草啊");
}


@end
