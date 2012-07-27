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
        CCSpriteBatchNode *refreshBatchNode;
        
        NSString *unitID = [self getUnitID];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"tiled-hd.plist"];
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"texturePack-hd.plist"];
            
            bgTiledBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"tiled-hd.png"];
            refreshBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"texturePack-hd.png"];
            
        }else if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
            
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"tiled.plist"];
            [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"texturePack.plist"];
            
            bgTiledBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"tiled.png"];
            refreshBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"texturePack.png"];
        }
        
        CCSprite *tile3 = [CCSprite spriteWithSpriteFrameName:@"tile3.png"];
        CCSprite *tile4 = [CCSprite spriteWithSpriteFrameName:@"tile8.png"];
        CCSprite *tile5 = [CCSprite spriteWithSpriteFrameName:@"tile9.png"];
        CCSprite *tile8 = [CCSprite spriteWithSpriteFrameName:@"tile7.png"];
        CCSprite *tile9 = [CCSprite spriteWithSpriteFrameName:@"tile9.png"];
        CCSprite *refreshUnit = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@_a.png",unitID]];
        
        
        playBg = [CCSprite spriteWithSpriteFrameName:@"bg_main.png"];
        
        [bgTiledBatchNode addChild:playBg z:0];
        [bgTiledBatchNode addChild:tile3 z:1];
        [bgTiledBatchNode addChild:tile4 z:1];
        [bgTiledBatchNode addChild:tile5 z:1];
        [bgTiledBatchNode addChild:tile8 z:1];
        [bgTiledBatchNode addChild:tile9 z:1];
        [refreshBatchNode addChild:refreshUnit z:1];
        
        [self addChild:bgTiledBatchNode];
        [self addChild:refreshBatchNode];
        
        CGSize screenSize = [[CCDirector sharedDirector] winSize];    
        
        [playBg setPosition:CGPointMake(screenSize.width*0.5f, screenSize.height*0.5f)]; 
        [tile3 setPosition:CGPointMake(tile3.anchorPointInPoints.x + 10, 335)]; 
        [tile4 setPosition:CGPointMake(75 + 10, 335)]; 
        [tile5 setPosition:CGPointMake(125 + 10, 335)]; 
        [tile8 setPosition:CGPointMake(75 + 10, 285)];  
        [tile9 setPosition:CGPointMake(125 + 10, 285)]; 
        [refreshUnit setPosition:CGPointMake(125 + 10, 375)]; 
                 
        
        
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

-(CCSprite *)reflashUnit{
    
    
    CCSprite *dd = [CCSprite node];
    return dd;
    
}

//******* 随机一个对象的ID

-(NSString *)getUnitID
{
    int randNum = arc4random()%1000;
    
    NSString *unitID;
    
    NSLog(@"%d",randNum);
    
    NSString *tmpFilePath = [self dataPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:tmpFilePath ]) {
        NSLog(@"asdasd");
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:tmpFilePath];
        
        int perRange = 0;
        
        for (int i = 0; i < 8; i++) {
            
            NSDictionary *keyDic = [dic objectForKey:[NSString stringWithFormat:@"%d",i]];
            
            if (i == 0) {
                
                perRange = 0;
                
            }else {
                NSDictionary *preKeyDic = [dic objectForKey:[NSString stringWithFormat:@"%d",i-1]];
                
                perRange = [[preKeyDic objectForKey:@"range"] intValue];
            }
            
            
            [dic release];
            
            int range = [[keyDic objectForKey:@"range"] intValue];
            
            
            if (randNum >= perRange && randNum < range) {
                
                unitID = [[NSString alloc] init];
                
                unitID = [keyDic objectForKey:@"ID"];
                
                
                
            }
        }
        
    }
    return unitID;

}

@end
