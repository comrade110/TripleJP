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
        
        intID = [[UnitAttributes node] getUnitAttrWithKey:nowUnitID withSubKey:@"ID"];
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
        
        
        for (int i =0; i<6; i++) {
            for (int j = 0 ; j<6; j++) {
                mapUID[i][j] = -1;
            }
        }        
        for (int i =0; i<6; i++) {
            for (int j = 0 ; j<6; j++) {
                mapUGT[i][j] = -1;
            }
        }
        for (int i =0; i<6; i++) {
            for (int j = 0 ; j<6; j++) {
                delGroup[i][j] =-1;
            }
        }


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


//  判断单位合并

-(int)checkForUpdate: (int)x setY:(int)y withID:(int)uid{
    
    //  判断横向的情况    
    
    NSString *xystr = [NSString stringWithFormat:@"%d",mapUID[x][y]]; 
    int groupType = [[UnitAttributes node] getUnitAttrWithKey:xystr withSubKey:@"groupto"];
    
    for (int i =0; i<6; i++) {
        for (int j = 0 ; j<6-2; j++) {
            
            //           判断这     X   |   X |  XX | XX
            //           种情况     XX  |  XX |  X  |  X    纵向和横向一样 不用再次判断
            
            if (mapUGT[i][j] == mapUGT[i][j+1]  && mapUGT[i][j] !=-1) {
                

                if (i-1>=0) {
                    if (mapUGT[i-1][j] == mapUGT[i][j]) {
                        delGroup[i-1][j] = (i-1)*10+j;
                        delGroup[i][j] = i*10+j;
                        delGroup[i][j+1] = i*10+j+1;
                    }
                    if (mapUGT[i-1][j+1] == mapUGT[i][j]) {
                        delGroup[i-1][j+1] = (i-1)*10+j+1;
                        delGroup[i][j] = i*10+j;
                        delGroup[i][j+1] = i*10+j+1;
                    }
                }
                if (i+1<=5) {
                    if (mapUGT[i+1][j] == mapUGT[i][j]) {
                        delGroup[i+1][j] = (i+1)*10+j;
                        delGroup[i][j] = i*10+j;
                        delGroup[i][j+1] = i*10+j+1;
                    }
                    if (mapUGT[i+1][j+1] == mapUGT[i][j]) {
                        
                        delGroup[i+1][j+1] = (i+1)*10+j+1;
                        delGroup[i][j] = i*10+j;
                        delGroup[i][j+1] = i*10+j+1;
                    }
                }
            }
            
            
            if (mapUGT[i][j] == mapUGT[i][j+1] && mapUGT[i][j]==mapUGT[i][j+2] && mapUGT[i][j] !=-1) {
                

                delGroup[i][j] = i*10+j;
                delGroup[i][j+1] = i*10+j+1;
                delGroup[i][j+2] = i*10+j+2;
                if (j+3 < 6) {
                    int k =j+3;
                    while (mapUGT[i][j] == mapUGT[i][k]) {
                        delGroup[i][k] = i*10 + k;
                        if (k+1<6) {
                            k++;
                        }else {
                            
                            j=k;
                            break;
                        }
                    }
                }
                
                
            }
        }
    }
    
    //  判断纵向的情况   i为列 j为行 
    
    for (int i =0; i<6; i++) {
        for (int j = 0 ; j<6-2; j++) {
            
            
            
            if (mapUGT[j][i] == mapUGT[j+1][i] && mapUGT[j][i]==mapUGT[j+2][i] && mapUGT[j][i] !=-1) {
                

                delGroup[j][i] = j*10+i;
                delGroup[j+1][i] = (j+1)*10+i;
                delGroup[j+2][i] = (j+2)*10+i;
                if (j+3 < 6) {
                    int k =j+3;
                    while (mapUGT[j][i] == mapUGT[k][i]) {
                        delGroup[k][i] = k*10 + i;
                        if (k+1<6) {
                            k++;
                        }else {
                            
                            j=k;
                            break;
                        }
                    }
                }
                
                
            }
        }
    }

    for (int i =0; i<6; i++) {
        for (int j = 0 ; j<6; j++) {
            
            if(delGroup[i][j] !=-1 && mapUGT[i][j]==groupType){
                
                delCount++;
                
            }
        }
    }
    
    
    NSLog(@"aaaa%d\n",delCount);
    if (delCount == 3) {
        
//  初级合并后判断更高级 删除计数归0 重设单位ID和组合ID
        delCount = 0;
        mapUID[x][y] = groupType;
        mapUGT[x][y] =[[UnitAttributes node] getUnitAttrWithKey:[NSString stringWithFormat:@"%d",groupType] withSubKey:@"groupto"];
         NSLog(@"dddd%d\n",mapUID[x][y]);
        [self checkForUpdate:x setY:y withID:mapUID[myx][myy]];
        
    }else if (delCount > 3 ) {
        
        int groupType = [[UnitAttributes node] getUnitAttrWithKey:xystr withSubKey:@"groupsuper"];
        delCount = 0;
        
        mapUID[x][y] = groupType;
        mapUGT[x][y] =[[UnitAttributes node] getUnitAttrWithKey:[NSString stringWithFormat:@"%d",groupType]  withSubKey:@"groupto"];
        [self checkForUpdate:x setY:y withID:groupType];
    }
    
    return mapUID[x][y];
}


//   刷新背景

-(void)pavingHanlder{

    for (int i =0; i<6; i++) {
        for (int j=0; j<6; j++) {
            if (mapUnitType[i][j] != 1) {
                if (j-1>0) {                    
                    if (mapUnitType[i][j-1] == 1) {
                        isLeftEmpty = NO;
                    }                    
                }else{
                    isLCorner = YES;
                    isCorner = YES;
                    
                }
                if (j+1<6) {
                    if (mapUnitType[i][j+1] == 1) {
                        isRightEmpty = NO;
                    }
                    
                }else {
                    isRCorner = YES;
                    isCorner = YES;        
                }
                if (i-1>0) {
                    if (mapUnitType[i-1][j] == 1) {
                        isTopEmpty = NO;
                        isCorner = YES;
                    }
                    
                }else {
                    isTCorner = YES;
                }   
                if (i+1<6) {
                    if (mapUnitType[i+1][j] == 1) {
                        isBottomEmpty = NO;
                    }
                
                }else {
                    isBCorner = YES;
                    isCorner = YES;
                }
                
                if (isCorner) {
                    if (isLCorner && isTCorner) {
                        

                    }
                }
                    
            }
        }
    }
    
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




-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [self convertTouchToNodeSpace:touch];
    
    NSString *nowUnitID = [[ReflashUnit node] getUnitID];
    
    myx = 5- mapTileY;
    
    myy = mapTileX;
    
    if (CGRectContainsPoint(tileRect, touchPoint)) {
        
        if (mapUGT[myx][myy]>0) {
            return;
        }

//    把精灵属性存入各自数组中
        
        mapUID[myx][myy] = intID;
        mapUGT[myx][myy] = intGroupType;
        mapUnitType[myx][myy] = intType;
        mapSpriteTag[myx][myy] = myx*10 + myy;
        refreshUnit.tag = myx*10+myy;
        
        
              //    获取groupType数值
        int nowID = [self checkForUpdate:myx setY:myy withID:mapUID[myx][myy]];
        
        if (nowID > intID && mapUnitType[myx][myy]<4) {
            delCount = 0; 
            
            for (int i =0; i<6; i++) {
                for (int j = 0 ; j<6; j++) {
                    if(delGroup[i][j] !=-1){
                        NSLog(@"%d",delGroup[i][j]);
                        [refreshBatchNode removeChildByTag:mapSpriteTag[i][j] cleanup:YES]; 
                        mapUID[i][j] = -1;
                        mapUGT[i][j] = -1;
                        
                        delGroup[i][j] =-1;
                    }
                }
            }
            
            mapUID[myx][myy] = nowID;          //  新精灵grouptype为原来的groupto
            mapUGT[myx][myy] = [[UnitAttributes node] getUnitAttrWithKey:[NSString stringWithFormat:@"%d",nowID] withSubKey:@"groupto"];

            
            refreshUnit =[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%d_s.png",nowID]];
            
            
            //  给新精灵type数组赋值 以同步精灵属性
            

            mapUnitType[myx][myy] =[[UnitAttributes node] getUnitAttrWithKey:[NSString stringWithFormat:@"%d",nowID] withSubKey:@"type"];
            
            [refreshBatchNode addChild:refreshUnit z:2 tag:mapSpriteTag[myx][myy]];
            
            
            [refreshUnit setPosition:CGPointMake(tileRect.origin.x + 25, tileRect.origin.y+refreshUnit.contentSize.height*0.5)];
            



        }else if(nowID == intID){
            
             NSLog(@"beijua");
            
            [refreshUnit setPosition:CGPointMake(tileRect.origin.x + 25, tileRect.origin.y+refreshUnit.contentSize.height*0.5)];
            refreshUnit.tag = myx*10+myy;
            
            
        }
        
//       刷新单位
        
        refreshUnit = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@_s.png",nowUnitID]];
        [refreshBatchNode addChild:refreshUnit z:2];
        
        [refreshUnit setPosition:CGPointMake(screenSize.width*0.5f, 380)]; 
        
        intType = [[UnitAttributes node] getUnitAttrWithKey:nowUnitID withSubKey:@"type"];
        intID = [[UnitAttributes node] getUnitAttrWithKey:nowUnitID withSubKey:@"ID"];
        if (intType < 4) {
            
            intGroupType = [[UnitAttributes node] getUnitAttrWithKey:nowUnitID withSubKey:@"groupto"];
        }else {
            intGroupType = 0;
        }
    }
}

-(void)realloc{

    [super dealloc];
}





@end
