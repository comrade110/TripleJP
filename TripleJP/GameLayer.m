//
//  GameLayer.m
//  TripleJP
//
//  Created by user on 12-7-25.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"
#import "ReflashUnit.h"
#import "UnitAttributes.h"
#import "MapTileAttribute.h"

@implementation GameLayer


-(id)init{
    
    self = [super init];
    
    if (self != nil) {
        
        NSString *nowUnitID = [[ReflashUnit node] getUnitID];
        
        intGroupType = [[UnitAttributes node] getUnitAttrWithKey:nowUnitID withSubKey:@"groupto"];
        intType = [[UnitAttributes node] getUnitAttrWithKey:nowUnitID withSubKey:@"type"];
     
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
        [refreshBatchNode addChild:refreshUnit z:2 tag:0];
        
        [self addChild:bgTiledBatchNode];
        [self addChild:refreshBatchNode];
        
        screenSize = [[CCDirector sharedDirector] winSize];    
        
        [playBg setPosition:CGPointMake(screenSize.width*0.5f, screenSize.height*0.5f)]; 
        [tile3 setPosition:CGPointMake(tile3.anchorPointInPoints.x + 10, 320)]; 
        [tile4 setPosition:CGPointMake(75 + 10, 320)]; 
        [tile5 setPosition:CGPointMake(125 + 10, 320)]; 
        [tile8 setPosition:CGPointMake(75 + 10, 270)];  
        [tile9 setPosition:CGPointMake(125 + 10, 270)]; 
        [unitStorage setPosition:CGPointMake(screenSize.width*0.5f, 380)]; 
        [refreshUnit setPosition:CGPointMake(screenSize.width*0.5f, 380)]; 
        
        
//*******  启动响应触摸
        
        self.isTouchEnabled = YES;
        CCDirector *director = [CCDirector sharedDirector];
        [[director touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
        
//******* 初始化地图矩阵
        
        mapRect = CGRectMake((screenSize.width - 300)*0.5, 45, 300, 300);
        
        
        clearArr = [[CCArray array] retain];
        storageArr = [[CCArray array] retain];
        aroundSpriteTag = [[CCArray array] retain];
//******* 合并
        isNeedGroup = NO;
        

    }
    return self;
}

- (NSString *) dataPath
{
    NSArray *storeFilePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *doucumentsDirectiory = [storeFilePath objectAtIndex:0];
//    NSLog(@"%@",doucumentsDirectiory);
    
    return [doucumentsDirectiory stringByAppendingPathComponent:@"refreshUnit.plist"];
    
}



//  精灵的CGRect

-(CGRect)AtlasRect:(CCSprite *)atlSpr
{
    CGRect rc = [atlSpr textureRect];
    return CGRectMake( - rc.size.width / 2, -rc.size.height / 2, rc.size.width, rc.size.height); 
}

// map CGRect


//  该精灵周围精灵的周围

-(BOOL)checkIsInStorage:(int)tag{
    
    int tagx = tag/10;
    
    int tagy;
    
    if (tag <10) {
        
        tagy = tag;
        
    }else {
        
        tagy = tag%10;
        
    }
    
    if ([storageArr count] == 0) {
        
        return NO;
        
    }
    NSLog(@"ca!!!!!!!");
    for (int i= 0; i<[storageArr count]; i++) {
        MapTileAttribute *tempMTA = [storageArr objectAtIndex:i];
        
        NSLog(@"tempMTA.x1:%d",tempMTA.x1);
        
        if ((tagx == tempMTA.x1 ||tagx == tempMTA.x2|| tagy == tempMTA.y1 || tagy == tempMTA.y2)&&(tempMTA.x2 !=mapTileX && tempMTA.y2 != mapTileY)) {
            
            return YES;
            
        }
        
    }    
    return NO;
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    

    CGPoint touchPoint = [self convertTouchToNodeSpace:touch];
    
    NSLog(@"%f,%f",touchPoint.x,touchPoint.y);
    
    
    if (CGRectContainsPoint(mapRect, touchPoint)) {
        
        mapTileX = (int)(touchPoint.x - 10)*0.02;
        mapTileY = (int)(touchPoint.y - 45)*0.02;
        
        
//        NSLog(@"----%d,----%d",mapTileX,mapTileY);
        
        int orX = 50*mapTileX + 10;
        int orY = 50*mapTileY + 45;
                
        tileRect = CGRectMake(orX, orY, 50, 50);
        
        return YES;
    }else {
        
        return NO;
    }
     
    
}

-(void)findItemsInStorageArr:(int)x withY:(int)y{
    
    NSLog(@"x=%d,y=%d",x,y);
    
    for (int i= 0; i<[storageArr count]; i++) {
        MapTileAttribute *tempMTA = [storageArr objectAtIndex:i];
        
        NSLog(@"~~x1=%d y1=%d x2=%d y2=%d~~",tempMTA.x1,tempMTA.y1,tempMTA.x2,tempMTA.y2);
        
        if ((x == tempMTA.x1 && y==tempMTA.y1)||(x== tempMTA.x2 && y==tempMTA.y2)) {
            
            int clearTag1 = tempMTA.x1 *10 + tempMTA.y1; 
            
            int clearTag2 = tempMTA.x2 *10 + tempMTA.y2; 
            
            NSLog(@"clearTag1:%d",clearTag1);
            
            NSNumber *cnum1 = [[NSNumber alloc] initWithInt:clearTag1];
            NSNumber *cnum2 = [[NSNumber alloc] initWithInt:clearTag2];
            
            [clearArr addObject:cnum1];
            [clearArr addObject:cnum2];
            [storageArr removeObjectAtIndex:i];
            
        }
    }

}



-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [self convertTouchToNodeSpace:touch];
    
    NSString *nowUnitID = [[ReflashUnit node] getUnitID];
    if (CGRectContainsPoint(tileRect, touchPoint)) {

//    把精灵属性存入各自数组中
        
        mapUnitGroupType[mapTileX][mapTileY] = intGroupType;
        mapUnitType[mapTileX][mapTileY] = intType;
        mapSpriteTag[mapTileX][mapTileY] = mapTileX*10 + mapTileY;
        refreshUnit.tag = mapTileX*10+mapTileY;
        
        NSLog(@"mapUnitGroupType[mapTileX - 1][mapTileY]:%d",mapUnitGroupType[mapTileX - 1][mapTileY]);

        if (mapUnitGroupType[mapTileX - 1][mapTileY] == intGroupType && intType < 4 ) {
            
            NSLog(@"NO.1");
            
            if ([self checkIsInStorage:mapSpriteTag[mapTileX-1][mapTileY]] == YES) {
                
                isNeedGroup = YES; 
                [self findItemsInStorageArr:mapTileX-1 withY:mapTileY];
                

                
            }else {
                
                NSLog(@"aroundSpriteTag~~~1");
                [aroundSpriteTag addObject:[NSString stringWithFormat:@"%d",mapSpriteTag[mapTileX-1][mapTileY]]];
                NSLog(@"aroundSpriteTag count:%d",[aroundSpriteTag count]);
                //         把自己和临近的精灵坐标存起
                
                MapTileAttribute *mapAttr = [MapTileAttribute node];
                
                mapAttr.x1 = mapTileX - 1;
                mapAttr.y1 = mapTileY;
                mapAttr.x2 = mapTileX;
                mapAttr.y2 = mapTileY;
                
 //               NSLog(@"%d %d %d %d",mapAttr.x1,mapAttr.y1,mapAttr.x2,mapAttr.y2);
                
                [storageArr addObject:mapAttr];
                
                NSLog(@"storageArr:%d",[storageArr count]);
                
            }
            
        }
        if (mapUnitGroupType[mapTileX + 1][mapTileY] == intGroupType && intType < 4 ) {
            
            NSLog(@"NO.2");

            
            if ([self checkIsInStorage:mapSpriteTag[mapTileX+1][mapTileY]] == YES) {
                
                isNeedGroup = YES; 
                [self findItemsInStorageArr:mapTileX+1 withY:mapTileY];   
                
                NSLog(@"noaroundSpriteTag~~~2");
            }else {
                NSLog(@"aroundSpriteTag~~~2");
                [aroundSpriteTag addObject:[NSString stringWithFormat:@"%d",mapSpriteTag[mapTileX+1][mapTileY]]];
                NSLog(@"aroundSpriteTag count:%d",[aroundSpriteTag count]);
                MapTileAttribute *mapAttr = [MapTileAttribute node];
                
                mapAttr.x1 = mapTileX + 1;
                mapAttr.y1 = mapTileY;
                mapAttr.x2 = mapTileX;
                mapAttr.y2 = mapTileY;
                

                
                [storageArr addObject:mapAttr];
                
            }
            
        }
        if (mapUnitGroupType[mapTileX][mapTileY-1] == intGroupType && intType < 4 ) {
            
            NSLog(@"NO.3");

            
            if ([self checkIsInStorage:mapSpriteTag[mapTileX][mapTileY-1]] == YES) {
                
                isNeedGroup = YES;
                [self findItemsInStorageArr:mapTileX withY:mapTileY-1];    
                
                NSLog(@"noaroundSpriteTag~~~3");
            }else {
                
                NSLog(@"aroundSpriteTag~~~3");
                [aroundSpriteTag addObject:[NSString stringWithFormat:@"%d",mapSpriteTag[mapTileX][mapTileY-1]]];
                NSLog(@"aroundSpriteTag count:%d",[aroundSpriteTag count]);
                MapTileAttribute *mapAttr = [MapTileAttribute node];
                
                mapAttr.x1 = mapTileX ;
                mapAttr.y1 = mapTileY - 1;
                mapAttr.x2 = mapTileX;
                mapAttr.y2 = mapTileY;
                
                //               NSLog(@"%d %d %d %d",mapAttr.x1,mapAttr.y1,mapAttr.x2,mapAttr.y2);
                
                [storageArr addObject:mapAttr];
                
            }
            
        }
        if (mapUnitGroupType[mapTileX][mapTileY + 1] == intGroupType && intType < 4 ) {
            
            NSLog(@"NO.4");
            
            
            if ([self checkIsInStorage:mapSpriteTag[mapTileX][mapTileY+1]] == YES) {
                
                isNeedGroup = YES;
                
                [self findItemsInStorageArr:mapTileX withY:mapTileY+1];
                
                NSLog(@"noaroundSpriteTag~~~4");
                
            }else {
                
                NSLog(@"aroundSpriteTag~~~4");
                [aroundSpriteTag addObject:[NSString stringWithFormat:@"%d",mapSpriteTag[mapTileX][mapTileY + 1]]];
                NSLog(@"aroundSpriteTag count:%d",[aroundSpriteTag count]);
                MapTileAttribute *mapAttr = [MapTileAttribute node];
                
                mapAttr.x1 = mapTileX;
                mapAttr.y1 = mapTileY + 1;
                mapAttr.x2 = mapTileX;
                mapAttr.y2 = mapTileY;
                
                //               NSLog(@"%d %d %d %d",mapAttr.x1,mapAttr.y1,mapAttr.x2,mapAttr.y2);
                
                [storageArr addObject:mapAttr];
                
            }
            
        }
        if (isNeedGroup || [aroundSpriteTag count] > 1) {
            int newUnitID = mapUnitGroupType[mapTileX][mapTileY];      //    获取groupType数值
            NSString *newUnitIDStr = [NSString stringWithFormat:@"%d",newUnitID];
            
            
            for (int i =0; i<[aroundSpriteTag count]; i++) {
                    [refreshBatchNode removeChildByTag:[[aroundSpriteTag objectAtIndex:i] intValue] cleanup:YES];
            }
            
            
            for (int i=0; i<[clearArr count]; i++) {
                int ctag = [[clearArr objectAtIndex:i] intValue];
                
                NSLog(@"%d~~~~~~~~~~~~\n",ctag);
                
                [refreshBatchNode removeChildByTag:ctag cleanup:YES];
            }
            
            [refreshBatchNode removeChildByTag:mapSpriteTag[mapTileX][mapTileY] cleanup:YES];       //   移除原来的精灵
            
            
            refreshUnit =[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%d_s.png",newUnitID]];
            
            [aroundSpriteTag release];    
            [clearArr release];            
            aroundSpriteTag = [[CCArray array] retain];
            clearArr = [[CCArray array] retain];
            
            //  给新精灵type数组赋值 以同步精灵属性
            
            intGroupType = [[UnitAttributes node] getUnitAttrWithKey:newUnitIDStr withSubKey:@"groupto"];
            
            mapUnitGroupType[mapTileX][mapTileY] = intGroupType;
            
            [refreshBatchNode addChild:refreshUnit z:2 tag:mapSpriteTag[mapTileX][mapTileY]];
            
            [refreshUnit setPosition:CGPointMake(tileRect.origin.x + 25, tileRect.origin.y+refreshUnit.contentSize.height*0.5)];
            refreshUnit.tag = mapTileX*10+mapTileY;

        }else{
            [refreshUnit setPosition:CGPointMake(tileRect.origin.x + 25, tileRect.origin.y+refreshUnit.contentSize.height*0.5)];
            refreshUnit.tag = mapTileX*10+mapTileY;
            
        }
        
//       刷新单位
        
        refreshUnit = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@_s.png",nowUnitID]];
        [refreshBatchNode addChild:refreshUnit z:2];
        
        [refreshUnit setPosition:CGPointMake(screenSize.width*0.5f, 380)]; 
        
        intType = [[UnitAttributes node] getUnitAttrWithKey:nowUnitID withSubKey:@"type"];
        if (intType < 4) {
            
            intGroupType = [[UnitAttributes node] getUnitAttrWithKey:nowUnitID withSubKey:@"groupto"];
        }else {
            intGroupType = 0;
        }
    isNeedGroup = NO;
    }
}

-(void)dealloc{

    [super dealloc];
    [storageArr release];
}





@end
