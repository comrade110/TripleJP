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
        
      
        for (int i =0; i<6; i++) {
            for (int j = 0 ; j<6; j++) {
                mapUID[i][j] = -1;
                mapUGT[i][j] = -1;
                mapUnitType[i][j] = -1;
                delGroup[i][j] =-1;

            }
        }
        
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
        

        CCSprite *unitStorage = [CCSprite spriteWithSpriteFrameName:@"main_bar.png"];
        refreshUnit = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@_s.png",nowUnitID]]; 
                
        
        playBg = [CCSprite spriteWithSpriteFrameName:@"bg_main.png"];
        
        [bgTiledBatchNode addChild:playBg z:0];

        [bgTiledBatchNode addChild:unitStorage z:1];
        [refreshBatchNode addChild:refreshUnit z:2 tag:0];
        
        [self addChild:bgTiledBatchNode];
        [self addChild:refreshBatchNode];
        
        screenSize = [[CCDirector sharedDirector] winSize];    
        
        [playBg setPosition:CGPointMake(screenSize.width*0.5f, screenSize.height*0.5f)]; 
 
        [unitStorage setPosition:CGPointMake(screenSize.width*0.5f, 380)]; 
        [refreshUnit setPosition:CGPointMake(screenSize.width*0.5f, 380)]; 
        
        
//*******  启动响应触摸
        
        self.isTouchEnabled = YES;
        CCDirector *director = [CCDirector sharedDirector];
        [[director touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
        
//******* 初始化地图矩阵
        
        mapRect = CGRectMake((screenSize.width - 300)*0.5, 45, 300, 300);
        
        

        
// 初始化背景
        [self mapBgInit];
        
        [self pavingHanlder];
        
        for (int i=0; i<6; i++) {
            for (int j=0; j<6; j++) {
                mapbgInitArr[i][j] = mapbgArr[i][j];
                
                NSLog(@"%d",mapbgInitArr[i][j]);
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

//  初始化地图状态

-(void)mapBgInit{

    isLeftEmpty = YES;
    
    isRightEmpty = YES;
    
    isTopEmpty = YES;
    
    isBottomEmpty = YES;
    
    isLTEmpty = YES;
    
    isRTEmpty = YES;
    
    isLBEmpty = YES;
    
    isRBEmpty = YES;
    
    isLCorner = NO;
    
    isRCorner = NO;
    
    isTCorner = NO;
    
    isBCorner = NO;


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
    NSLog(@"pavinghandler");
    

    for (int i =0; i<6; i++) {
        for (int j=0; j<6; j++) {
            
            [self mapBgInit];
            mapSpriteTag[i][j]=i*10+j;
            
            if (mapUnitType[i][j] != 1) {
                if (i==0 && j==0) {
                    isLCorner = YES;
                    isTCorner = YES;
                    
                    if (mapUnitType[i][j+1] == 1) {
                        isRightEmpty = NO;
                    }
                    if (mapUnitType[i+1][j] == 1) {
                        isBottomEmpty = NO;
                    }
                    if (mapUnitType[i+1][j+1] == 1) {
                        isRBEmpty = NO;
                    }
                }
                
                //  右上角
                if (i==0 && j==5) {
                    isRCorner = YES;
                    isTCorner = YES;
                    
                    if (mapUnitType[i][j-1] == 1) {
                        isLeftEmpty = NO;
                    }
                    if (mapUnitType[i+1][j-1] == 1) {
                        isLBEmpty = NO;
                    }
                    if (mapUnitType[i+1][j] == 1) {
                        isBottomEmpty = NO;
                    }
                }
                //  右下角
                if (i==5 && j==5) {
                    isRCorner = YES;
                    isBCorner = YES;
                    
                    if (mapUnitType[i][j-1] == 1) {
                        isLeftEmpty = NO;
                    }
                    if (mapUnitType[i-1][j-1] == 1) {
                        isLTEmpty = NO;
                    }
                    if (mapUnitType[i-1][j] == 1) {
                        isTopEmpty = NO;
                    }
                }
                //  左下角
                if (i==5 && j==0) {
                    isLCorner = YES;
                    isBCorner = YES;
                    
                    if (mapUnitType[i-1][j] == 1) {
                        isTopEmpty = NO;
                    }
                    if (mapUnitType[i-1][j+1] == 1) {
                        isRTEmpty = NO;
                    }
                    if (mapUnitType[i][j+1] == 1) {
                        isRightEmpty = NO;
                    }
                }
                
                // 上边
                if (i==0 && j> 0 && j<5) {
                    
                    isTCorner = YES;
                    
                    if (mapUnitType[i][j-1] == 1) {
                        isLeftEmpty = NO;
                    }
                    if (mapUnitType[i][j+1] == 1) {
                        isRightEmpty = NO;
                    }
                    if (mapUnitType[i+1][j-1] == 1) {
                        isLBEmpty = NO;
                    }
                    if (mapUnitType[i+1][j] == 1) {
                        isBottomEmpty = NO;
                    }
                    if (mapUnitType[i+1][j+1] == 1) {
                        isRBEmpty = NO;
                    }
                    
                }
                
                // 左边
                if (i >0 && i<5 && j==0) {
                    
                    
                    isLCorner = YES;
                    
                    if (mapUnitType[i-1][j] == 1) {
                        isTopEmpty = NO;
                    }
                    if (mapUnitType[i-1][j+1] == 1) {
                        isRTEmpty = NO;
                    }
                    if (mapUnitType[i][j+1] == 1) {
                        isRightEmpty = NO;
                    }
                    if (mapUnitType[i+1][j] == 1) {
                        isBottomEmpty = NO;
                    }
                    if (mapUnitType[i+1][j+1] == 1) {
                        isRBEmpty = NO;
                    }
                    
                }  
                // 右边
                if (i >0 && i<5 && j==5) {
                    
                    
                    isRCorner = YES;
                    
                    if (mapUnitType[i-1][j-1] == 1) {
                        isLTEmpty = NO;
                    }
                    if (mapUnitType[i-1][j] == 1) {
                        isTopEmpty = NO;
                    }

                    if (mapUnitType[i+1][j] == 1) {
                        isBottomEmpty = NO;
                    }
                    if (mapUnitType[i+1][j-1] == 1) {
                        isLBEmpty = NO;
                    }
                    if (mapUnitType[i][j-1] == 1) {
                        isLeftEmpty = NO;
                    }
                    
                }    
                // 下边
                if (i == 5 && j>0 && j<5) {
                    
                    
                    isBCorner = YES;
                    
                    if (mapUnitType[i][j-1] == 1) {
                        isLeftEmpty = NO;
                    }
                    if (mapUnitType[i-1][j-1] == 1) {
                        isLTEmpty = NO;
                    }
                    if (mapUnitType[i-1][j] == 1) {
                        isTopEmpty = NO;
                    }
                    if (mapUnitType[i-1][j+1] == 1) {
                        isRTEmpty = NO;
                    }
                    if (mapUnitType[i][j+1] == 1) {
                        isRightEmpty = NO;
                    }
                    
                }
                
                //中间
                if (i>0 && i<5 && j>0 && j<5) {
                    
                    if (mapUnitType[i-1][j-1] == 1) {
                        isLTEmpty = NO;
                    }
                    if (mapUnitType[i-1][j] == 1) {
                        isTopEmpty = NO;
                    }
                    if (mapUnitType[i-1][j+1] == 1) {
                        isRTEmpty = NO;
                    }
                    if (mapUnitType[i][j+1] == 1) {
                        isRightEmpty = NO;
                    }
                    if (mapUnitType[i+1][j+1] == 1) {
                        isRBEmpty = NO;
                    }
                    if (mapUnitType[i+1][j] == 1) {
                        isBottomEmpty = NO;
                    }
                    if (mapUnitType[i+1][j-1] == 1) {
                        isLBEmpty = NO;
                    }
                    if (mapUnitType[i][j-1] == 1) {
                        isLeftEmpty = NO;
                    }
                }

                
                //  口
                if (!isLeftEmpty && !isTopEmpty && !isRightEmpty && !isBottomEmpty) {
                        mapbgArr[i][j] = 3;
                    
                }
                //  二|
                if (isLeftEmpty && !isTopEmpty && !isRightEmpty && !isBottomEmpty) {
                    
                    if (isLCorner) {
                        mapbgArr[i][j] = 3;
                    }else {
                        mapbgArr[i][j] = 6;
                    }
                }   
                //  C
                if (!isLeftEmpty && !isTopEmpty && isRightEmpty && !isBottomEmpty) {
                    
                    if (isRCorner) {
                        mapbgArr[i][j] = 3;
                    }else {
                        mapbgArr[i][j] = 5;
                    }
                }
                //  门
                if (!isLeftEmpty && !isTopEmpty && !isRightEmpty && isBottomEmpty) {
                    
                    if (isBCorner) {
                        mapbgArr[i][j] = 3;
                    }else {
                        mapbgArr[i][j] = 8;
                    }
                }
                //  |_|
                if (!isLeftEmpty && isTopEmpty && !isRightEmpty && !isBottomEmpty) {
                    
                    if (isTCorner) {
                        mapbgArr[i][j] = 3;
                    }else {
                        mapbgArr[i][j] = 7;
                    }
                }
                //  二
                if (isLeftEmpty && !isTopEmpty && isRightEmpty && !isBottomEmpty) {
                    
                    if (isLCorner) {
                        mapbgArr[i][j] = 5;
                    }else if(isRCorner){
                        mapbgArr[i][j] = 6;
                    }else {
                        mapbgArr[i][j] = 10;
                    }
                }
                //  | |
                if (!isLeftEmpty && isTopEmpty && !isRightEmpty && isBottomEmpty) {
                    
                    if (isTCorner) {
                         mapbgArr[i][j] = 8;
                    }else if (isBCorner) {
                         mapbgArr[i][j] = 7;
                    }else {                        
                        mapbgArr[i][j] = 9;
                        
                    }
                }
                //  |￣
                if (!isLeftEmpty && !isTopEmpty && isRightEmpty && isBottomEmpty) {
                    if(isRCorner && !isBCorner){
                        mapbgArr[i][j] = 8;
                    }else if (!isRCorner && isBCorner) {
                        mapbgArr[i][j] = 5;
                    }else if (isRCorner && isBCorner) {
                        mapbgArr[i][j] = 3;
                    }else {
                        mapbgArr[i][j] = 11;
                        if (!isRBEmpty) {
                            mapRBbg = [CCSprite spriteWithSpriteFrameName:@"tile20.png"];
                            mapRBbg.rotation = 180;
                        }
                    }
                }
                // ￣|
                
                if (isLeftEmpty && !isTopEmpty && !isRightEmpty && isBottomEmpty) {
                    NSLog(@"%d+%d",i,j);
                    if (isLCorner && !isBottomEmpty) {
                        mapbgArr[i][j] = 8;
                    }else if (isLCorner && isBCorner) {
                        NSLog(@"cena");
                        mapbgArr[i][j] = 3;
                    }else if (!isLCorner && isBCorner) {
                        mapbgArr[i][j] = 6;
                    }else {
                        mapbgArr[i][j] = 12;
                        if (!isLBEmpty) {
                            mapLBbg = [CCSprite spriteWithSpriteFrameName:@"tile19.png"];
                            mapLBbg.rotation = -90;
                        }
                    }
                    
                    [refreshBatchNode removeChildByTag:mapSpriteTag[i][j]+100 cleanup:YES];
                    
                }
                //  __|
                
                if (isLeftEmpty && isTopEmpty && !isRightEmpty && !isBottomEmpty) {
                    if (isLCorner && !isTCorner) {
                        mapbgArr[i][j] = 7;
                    }else if ( isLCorner && isTCorner) {
                        mapbgArr[i][j] = 3;
                    }else if (!isLCorner && isTCorner) {
                        mapbgArr[i][j] = 6;
                    }else {
                        mapbgArr[i][j] = 14;
                        if (!isLTEmpty) {
                            mapLTbg = [CCSprite spriteWithSpriteFrameName:@"tile19.png"];
                            
                        }
                    }
                }
                //  |__
                if (!isLeftEmpty && isTopEmpty && isRightEmpty && !isBottomEmpty) {
                    if (isTCorner && !isRCorner) {
                        mapbgArr[i][j] = 5;
                    }else if (isTCorner && isRCorner) {
                        mapbgArr[i][j] = 3;
                    }else if (!isTCorner && isRCorner) {
                        mapbgArr[i][j] = 7;
                    }else {
                        mapbgArr[i][j] = 13;
                        if (!isRTEmpty) {
                            mapRTbg = [CCSprite spriteWithSpriteFrameName:@"tile20.png"];
                            mapRTbg.rotation = 90;
                        }
                    }
                }
                
                //  左|
                if (!isLeftEmpty && isTopEmpty && isRightEmpty && isBottomEmpty) {
                    if (isTCorner && isRCorner) {
                        
                        mapbgArr[i][j] = 8;
                        
                    }else if (isTCorner && !isRCorner) {
                        mapbgArr[i][j] = 11;
                    }else if (!isRCorner && isBCorner) {
                        mapbgArr[i][j] = 13;
                    }
                    else if (isRCorner && isBCorner) {
                        mapbgArr[i][j] = 7;
                    }else if (isRCorner && !isBCorner && !isTCorner) {
                        mapbgArr[i][j] = 9;
                    }else {
                        mapbgArr[i][j] = 15;
                        if (!isRTEmpty) {
                            mapRTbg = [CCSprite spriteWithSpriteFrameName:@"tile20.png"];
                        }
                        if (!isRBEmpty) {
                            mapRBbg = [CCSprite spriteWithSpriteFrameName:@"tile20.png"];
                            mapRBbg.rotation = 180;
                        }
                    }
                }
                //  右|
                if (isLeftEmpty && isTopEmpty && !isRightEmpty && isBottomEmpty) {
                    if (isTCorner && isLCorner) {
                        mapbgArr[i][j] = 8;
                    }
                    else if (isLCorner && isBCorner) {
                        mapbgArr[i][j] = 7;
                    }
                    else if (isTCorner && !isLCorner) {
                        mapbgArr[i][j] = 12;
                    }
                    else if (!isLCorner && isBCorner) {
                        mapbgArr[i][j] = 14;
                    }
                    else if (isLCorner && !isBCorner && !isTCorner) {
                        mapbgArr[i][j] = 9;
                    }
                    else {
                        mapbgArr[i][j] = 16;
                        if (!isLBEmpty) {
                            mapLBbg = [CCSprite spriteWithSpriteFrameName:@"tile19.png"];
                            mapLBbg.rotation = -90;
                        }
                        if (!isLTEmpty) {
                            mapLTbg = [CCSprite spriteWithSpriteFrameName:@"tile19.png"];
                        }
                    }
                }
                //上 ￣
                if (isLeftEmpty && !isTopEmpty && isRightEmpty && isBottomEmpty) {
                    if (isLCorner && isBCorner) {
                        mapbgArr[i][j] = 5;
                    }else if (isLCorner &&!isBCorner) {
                        mapbgArr[i][j] = 11;
                    }else if (isRCorner &&!isBCorner) {
                        mapbgArr[i][j] = 12;
                    }
                    else if (isBCorner && isRCorner) {
                        mapbgArr[i][j] = 6;
                    }
                    else if (isBCorner && !isLCorner && !isRCorner) {
                        mapbgArr[i][j] = 10;
                    }
                    else {
                        mapbgArr[i][j] = 17;
                        NSLog(@"hello");
                        if (!isRBEmpty) {
                            mapRBbg = [CCSprite spriteWithSpriteFrameName:@"tile20.png"];
                            mapRBbg.rotation = 180;
                        }
                        if (!isLBEmpty) {
                            mapLBbg = [CCSprite spriteWithSpriteFrameName:@"tile19.png"];
                            mapLBbg.rotation = -90;
                        }
                    }
                }
                //下 __
                if (isLeftEmpty && isTopEmpty && isRightEmpty && !isBottomEmpty) {
                    if (isLCorner && isTCorner) {
                        mapbgArr[i][j] = 5;
                    }else if (isLCorner && !isTCorner) {
                        mapbgArr[i][j] = 13;
                    }
                    else if (isRCorner && !isTCorner) {
                        mapbgArr[i][j] = 14;
                    }
                    else if (isTCorner && isRCorner) {
                        mapbgArr[i][j] = 6;
                    }
                    else if (isTCorner && !isLCorner && !isRCorner) {
                        mapbgArr[i][j] = 10;
                    }

                    else {
                        mapbgArr[i][j] = 18;
                        if (!isLTEmpty) {
                            mapLTbg = [CCSprite spriteWithSpriteFrameName:@"tile19.png"];
                        }
                        if (!isRTEmpty) {
                            mapRTbg = [CCSprite spriteWithSpriteFrameName:@"tile20.png"];
                            mapRTbg.rotation = 90;
                        }
                    }
                    

                }
                
            if (isLeftEmpty && isTopEmpty && isRightEmpty && isBottomEmpty) {
                mapbgArr[i][j] = 1;
                if (!isLTEmpty) {
                    
                    mapLTbg = [CCSprite spriteWithSpriteFrameName:@"tile19.png"];
                    [mapLTbg setPosition:CGPointMake(50*j+10+25, 50*(5-i)+45+25)];
                    [refreshBatchNode addChild:mapLTbg z:3 tag:mapSpriteTag[i][j]+200];
                }
                if (!isRTEmpty) {
                    mapRTbg = [CCSprite spriteWithSpriteFrameName:@"tile20.png"];
                    mapRTbg.rotation = 90;
                    [mapRTbg setPosition:CGPointMake(50*j+10+25, 50*(5-i)+45+25)];
                    [refreshBatchNode addChild:mapRTbg z:3 tag:mapSpriteTag[i][j]+300];
                }
                if (!isLBEmpty) {
                    mapLBbg = [CCSprite spriteWithSpriteFrameName:@"tile19.png"];
                    mapLBbg.rotation = -90;
                    [mapLBbg setPosition:CGPointMake(50*j+10+25, 50*(5-i)+45+25)];
                    [refreshBatchNode addChild:mapLBbg z:3 tag:mapSpriteTag[i][j]+400];
                }
                if (!isRBEmpty) {
                    mapRBbg = [CCSprite spriteWithSpriteFrameName:@"tile20.png"];
                    mapRBbg.rotation = 180;
                    [mapRBbg setPosition:CGPointMake(50*j+10+25, 50*(5-i)+45+25)];
                    [refreshBatchNode addChild:mapRBbg z:3 tag:mapRBbgTag[i][j]+500];
                }
                
                if (isLCorner) {
                    mapbgArr[i][j] = 15;
                }
                if (isRCorner) {
                    mapbgArr[i][j] = 16;
                }
                if (isTCorner) {
                    mapbgArr[i][j] = 17;
                }
                if (isBCorner) {
                    mapbgArr[i][j] = 18;
                }
                if (isLCorner && isTCorner) {
                    mapbgArr[i][j] = 11;
                }
                if (isRCorner && isTCorner) {
                    mapbgArr[i][j] = 12;
                }
                if (isLCorner && isBCorner) {
                    mapbgArr[i][j] = 13;
                }
                if (isRCorner && isBCorner) {
                    mapbgArr[i][j] = 14;
                }


                
            }
                if (mapbgArr[i][j] != mapbgInitArr[i][j]) {
                    mapbg = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"tile%d.png",mapbgArr[i][j]]];
                    [mapbg setPosition:CGPointMake(50*j+10+25, 50*(5-i)+45+25)];
                    [refreshBatchNode addChild:mapbg z:1 tag:mapSpriteTag[i][j]+100];
                    
                    if (![refreshBatchNode getChildByTag:mapSpriteTag[i][j]+200]) {
                        
                        
                        mapLBbg = [CCSprite spriteWithSpriteFrameName:@"tile19.png"];
                    }
                    if (![refreshBatchNode getChildByTag:mapSpriteTag[i][j]+300]) {
                        
                        
                        mapLBbg = [CCSprite spriteWithSpriteFrameName:@"tile19.png"];
                    }
                    if (![refreshBatchNode getChildByTag:mapSpriteTag[i][j]+400]) {
                        
                        
                        mapLBbg = [CCSprite spriteWithSpriteFrameName:@"tile19.png"];
                    }
                    if (![refreshBatchNode getChildByTag:mapSpriteTag[i][j]+500]) {
                        
                        
                        mapLBbg = [CCSprite spriteWithSpriteFrameName:@"tile19.png"];
                    }
                    mapbgInitArr[i][j] = mapbgArr[i][j];
                }
                
                
                    
            }
            else{
                
                mapbg = [CCSprite spriteWithSpriteFrameName:@"tile2.png"];
                [mapbg setPosition:CGPointMake(50*j+10+25, 50*(5-i)+45+25)];
                if (![refreshBatchNode getChildByTag:mapSpriteTag[i][j]+600]) {
                    
                    [refreshBatchNode addChild:mapbg z:1 tag:mapSpriteTag[i][j]+600];
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
        
        int nowID = intID;
        
        
        if (mapUnitType[myx][myy] == 1) {
            nowID = [self checkForUpdate:myx setY:myy withID:mapUID[myx][myy]];
        }
                
        
        if (nowID > intID) {
            delCount = 0; 

            for (int i =0; i<6; i++) {
                for (int j = 0 ; j<6; j++) {
                    if(delGroup[i][j] !=-1){
                        NSLog(@"%d",delGroup[i][j]);
                        [refreshBatchNode removeChildByTag:mapSpriteTag[i][j] cleanup:YES]; 
                        [refreshBatchNode removeChildByTag:mapSpriteTag[i][j]+100 cleanup:YES]; 
                        [refreshBatchNode removeChildByTag:mapSpriteTag[i][j]+600 cleanup:YES]; 
                        
                        mapUID[i][j] = -1;
                        mapUGT[i][j] = -1;
                        mapUnitType[i][j] = -1;
                        
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

//       reflash mapbg
        [self pavingHanlder];
        
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


-(void)initMapBoolValue{


}


-(void)realloc{

    [super dealloc];
}





@end
