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


//   init check

-(void)initCheckArr{
    
    isNeedMove = YES;
    delGroupCount = 0;
    for (int i =0; i<6; i++) {
        for (int j = 0 ; j<6; j++) {
            ischecked[i][j] = 0;
            isDchecked[i][j] =0;
            
        }
    }
}

  
//  判断单位合并

-(int)checkForUpdate: (int)x setY:(int)y withID:(int)uid{
    
    //  判断横向的情况    
    
    NSString *xystr = [NSString stringWithFormat:@"%d",mapUID[x][y]]; 
    int groupType = [[UnitAttributes node] getUnitAttrWithKey:xystr withSubKey:@"groupto"];
    
    for (int i =0; i<6; i++) {
        for (int j = 0 ; j<6-1; j++) {
            
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
            
            
            if (j<4 && mapUGT[i][j] == mapUGT[i][j+1] && mapUGT[i][j]==mapUGT[i][j+2] && mapUGT[i][j] !=-1) {
                

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
    
    
    if (delCount == 3) {
        
//  初级合并后判断更高级 删除计数归0 重设单位ID和组合ID
        delCount = 0;
        mapUID[x][y] = groupType;
        mapUGT[x][y] =[[UnitAttributes node] getUnitAttrWithKey:[NSString stringWithFormat:@"%d",groupType] withSubKey:@"groupto"];
        
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
            
            [self mapBgInit];
            mapSpriteTag[i][j]=i*10+j;
            mapLTbgArr[i][j] = -1;
            mapRTbgArr[i][j] = -1;
            mapLBbgArr[i][j] = -1;
            mapRBbgArr[i][j] = -1;
            if (mapUnitType[i][j] == -1 || mapUnitType[i][j] == 4) {
                if (i==0 && j==0) {
                    isLCorner = YES;
                    isTCorner = YES;
                    
                    if (mapUnitType[i][j+1] != -1 && mapUnitType[i][j+1] != 4) {
                        isRightEmpty = NO;
                    }
                    if (mapUnitType[i+1][j] != -1 && mapUnitType[i+1][j] != 4 ) {
                        isBottomEmpty = NO;
                    }
                    if (mapUnitType[i+1][j+1] != -1 && mapUnitType[i+1][j+1] != 4) {
                        isRBEmpty = NO;
                    }
                }
                
                //  右上角
                if (i==0 && j==5) {
                    isRCorner = YES;
                    isTCorner = YES;
                    
                    if (mapUnitType[i][j-1] != -1 && mapUnitType[i][j-1] != 4) {
                        isLeftEmpty = NO;
                    }
                    if (mapUnitType[i+1][j-1] != -1 && mapUnitType[i+1][j-1] != 4) {
                        isLBEmpty = NO;
                    }
                    if (mapUnitType[i+1][j] != -1 && mapUnitType[i+1][j] != 4) {
                        isBottomEmpty = NO;
                    }
                }
                //  右下角
                if (i==5 && j==5) {
                    isRCorner = YES;
                    isBCorner = YES;
                    
                    if (mapUnitType[i][j-1] != -1 && mapUnitType[i][j-1] != 4) {
                        isLeftEmpty = NO;
                    }
                    if (mapUnitType[i-1][j-1] != -1 && mapUnitType[i-1][j-1] != 4) {
                        isLTEmpty = NO;
                    }
                    if (mapUnitType[i-1][j] != -1 && mapUnitType[i-1][j] != 4) {
                        isTopEmpty = NO;
                    }
                }
                //  左下角
                if (i==5 && j==0) {
                    isLCorner = YES;
                    isBCorner = YES;
                    
                    if (mapUnitType[i-1][j] != -1 && mapUnitType[i-1][j] != 4) {
                        isTopEmpty = NO;
                    }
                    if (mapUnitType[i-1][j+1] != -1 && mapUnitType[i-1][j+1] != 4) {
                        isRTEmpty = NO;
                    }
                    if (mapUnitType[i][j+1] != -1 && mapUnitType[i][j+1] != 4) {
                        isRightEmpty = NO;
                    }
                }
                
                // 上边
                if (i==0 && j> 0 && j<5) {
                    
                    isTCorner = YES;
                    
                    if (mapUnitType[i][j-1] != -1 && mapUnitType[i][j-1] != 4) {
                        isLeftEmpty = NO;
                    }
                    if (mapUnitType[i][j+1] != -1 && mapUnitType[i][j+1] != 4) {
                        isRightEmpty = NO;
                    }
                    if (mapUnitType[i+1][j-1] != -1 && mapUnitType[i+1][j-1] != 4) {
                        isLBEmpty = NO;
                    }
                    if (mapUnitType[i+1][j] != -1 && mapUnitType[i+1][j] != 4) {
                        isBottomEmpty = NO;
                    }
                    if (mapUnitType[i+1][j+1] != -1 && mapUnitType[i+1][j+1] != 4) {
                        isRBEmpty = NO;
                    }
                    
                }
                
                // 左边
                if (i >0 && i<5 && j==0) {
                    
                    
                    isLCorner = YES;
                    
                    if (mapUnitType[i-1][j] != -1 && mapUnitType[i-1][j] != 4) {
                        isTopEmpty = NO;
                    }
                    if (mapUnitType[i-1][j+1] != -1 && mapUnitType[i-1][j+1] != 4) {
                        isRTEmpty = NO;
                    }
                    if (mapUnitType[i][j+1] != -1 && mapUnitType[i][j+1] != 4) {
                        isRightEmpty = NO;
                    }
                    if (mapUnitType[i+1][j] != -1 && mapUnitType[i+1][j] != 4) {
                        isBottomEmpty = NO;
                    }
                    if (mapUnitType[i+1][j+1] != -1 && mapUnitType[i+1][j+1] != 4) {
                        isRBEmpty = NO;
                    }
                    
                }  
                // 右边
                if (i >0 && i<5 && j==5) {
                    
                    
                    isRCorner = YES;
                    
                    if (mapUnitType[i-1][j-1] != -1 && mapUnitType[i-1][j-1] != 4) {
                        isLTEmpty = NO;
                    }
                    if (mapUnitType[i-1][j] != -1 && mapUnitType[i-1][j] != 4) {
                        isTopEmpty = NO;
                    }

                    if (mapUnitType[i+1][j] != -1 && mapUnitType[i+1][j] != 4) {
                        isBottomEmpty = NO;
                    }
                    if (mapUnitType[i+1][j-1] != -1 && mapUnitType[i+1][j-1] != 4) {
                        isLBEmpty = NO;
                    }
                    if (mapUnitType[i][j-1] != -1 && mapUnitType[i][j-1] != 4) {
                        isLeftEmpty = NO;
                    }
                    
                }    
                // 下边
                if (i == 5 && j>0 && j<5) {
                    
                    
                    isBCorner = YES;
                    
                    if (mapUnitType[i][j-1] != -1 && mapUnitType[i][j-1] != 4) {
                        isLeftEmpty = NO;
                    }
                    if (mapUnitType[i-1][j-1] != -1 && mapUnitType[i-1][j-1] != 4) {
                        isLTEmpty = NO;
                    }
                    if (mapUnitType[i-1][j] != -1 && mapUnitType[i-1][j] != 4) {
                        isTopEmpty = NO;
                    }
                    if (mapUnitType[i-1][j+1] != -1 && mapUnitType[i-1][j+1] != 4) {
                        isRTEmpty = NO;
                    }
                    if (mapUnitType[i][j+1] != -1 && mapUnitType[i][j+1] != 4) {
                        isRightEmpty = NO;
                    }
                    
                }
                
                //中间
                if (i>0 && i<5 && j>0 && j<5) {
                    
                    if (mapUnitType[i-1][j-1] != -1 && mapUnitType[i-1][j-1] != 4) {
                        isLTEmpty = NO;
                    }
                    if (mapUnitType[i-1][j] != -1 && mapUnitType[i-1][j] != 4) {
                        isTopEmpty = NO;
                    }
                    if (mapUnitType[i-1][j+1] != -1&& mapUnitType[i-1][j+1] != 4) {
                        isRTEmpty = NO;
                    }
                    if (mapUnitType[i][j+1] != -1 && mapUnitType[i][j+1] != 4) {
                        isRightEmpty = NO;
                    }
                    if (mapUnitType[i+1][j+1] != -1 && mapUnitType[i+1][j+1] != 4) {
                        isRBEmpty = NO;
                    }
                    if (mapUnitType[i+1][j] != -1 && mapUnitType[i+1][j] != 4) {
                        isBottomEmpty = NO;
                    }
                    if (mapUnitType[i+1][j-1] != -1 && mapUnitType[i+1][j-1] != 4) {
                        isLBEmpty = NO;
                    }
                    if (mapUnitType[i][j-1] != -1 && mapUnitType[i][j-1] != 4) {
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
                            mapRBbgArr[i][j] = 20;
                        }
                    }
                }
                // ￣|
                
                if (isLeftEmpty && !isTopEmpty && !isRightEmpty && isBottomEmpty) {
                    
                    if (isLCorner && isBCorner) {
                        mapbgArr[i][j] = 3;
                    }else if (isLCorner && !isBCorner) {
                        mapbgArr[i][j] = 8;
                    }else if (!isLCorner && isBCorner) {
                        mapbgArr[i][j] = 6;
                    }else {
                        mapbgArr[i][j] = 12;
                        if (!isLBEmpty) {
                            mapLBbgArr[i][j] = 19;
                        }
                    }
                    
              //      [refreshBatchNode removeChildByTag:mapSpriteTag[i][j]+100 cleanup:YES];
                    
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
                            mapLTbgArr[i][j] = 19;
                            
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
                            mapRTbgArr[i][j] = 20;
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

                    }
                    if (!isRTEmpty) {
                        mapRTbgArr[i][j] = 20;
                    }
                    if (!isRBEmpty) {
                        mapRBbgArr[i][j] = 20;
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
                    }
                    if (!isLBEmpty) {
                        mapLBbgArr[i][j] = 19;
                    }
                    if (!isLTEmpty) {
                        mapLTbgArr[i][j] = 19;
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
                    }
                    if (!isRBEmpty) {
                        mapRBbgArr[i][j] = 20;
                    }
                    if (!isLBEmpty) {
                        mapLBbgArr[i][j] = 19;
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
                    }
                    if (!isLTEmpty) {
                        mapLTbgArr[i][j] = 19;
                    }
                    if (!isRTEmpty) {
                        mapRTbgArr[i][j] = 20;
                    }

                }
                
            if (isLeftEmpty && isTopEmpty && isRightEmpty && isBottomEmpty) {
                
                if (!isLTEmpty) {
                    
                    mapLTbgArr[i][j] = 19;
                }
                if (!isRTEmpty) {
                    mapRTbgArr[i][j] = 20;
                }
                if (!isLBEmpty) {
                    mapLBbgArr[i][j] = 19;
                }
                if (!isRBEmpty) {
                    mapRBbgArr[i][j] = 20;
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
                if (!isLCorner && !isTCorner && !isRCorner && !isBCorner) {
                    mapbgArr[i][j] = 1;

                }
                
                
            }
                if (mapbgArr[i][j] != mapbgInitArr[i][j]) {
                    [refreshBatchNode removeChildByTag:mapSpriteTag[i][j]+100 cleanup:YES];
                    
                    mapbg = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"tile%d.png",mapbgArr[i][j]]];
                    [mapbg setPosition:CGPointMake(50*j+10+25, 50*(5-i)+45+25)];
                    [refreshBatchNode addChild:mapbg z:1 tag:mapSpriteTag[i][j]+100];

                    mapbgInitArr[i][j] = mapbgArr[i][j];
                }
                
                
                if (mapLTbgArr[i][j] != mapLTbgInitArr[i][j]) {
                    if (mapLTbgInitArr[i][j] == -1) {
                        mapLTbg = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"tile%d.png",mapLTbgArr[i][j]]];
                        
                        [mapLTbg setPosition:CGPointMake(50*j+10+25, 50*(5-i)+45+25)];
                        [refreshBatchNode addChild:mapLTbg z:2 tag:mapSpriteTag[i][j]+200];
                        
                    }else {
                        [refreshBatchNode removeChildByTag:mapSpriteTag[i][j]+200 cleanup:YES];
                    }
                    mapLTbgInitArr[i][j] = mapLTbgArr[i][j];
                }
                if (mapRTbgArr[i][j] != mapRTbgInitArr[i][j]) {
                    if (mapRTbgInitArr[i][j] == -1) {
                        
                        mapRTbg = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"tile%d.png",mapRTbgArr[i][j]]];
                        [mapRTbg setPosition:CGPointMake(50*j+10+25, 50*(5-i)+45+25)];
                        mapRTbg.rotation = 90;
                        [refreshBatchNode addChild:mapRTbg z:2 tag:mapSpriteTag[i][j]+300];
                        
                    }else {
                        [refreshBatchNode removeChildByTag:mapSpriteTag[i][j]+300 cleanup:YES];
                    }
                    mapRTbgInitArr[i][j] = mapRTbgArr[i][j];
                }
                if (mapLBbgArr[i][j] != mapLBbgInitArr[i][j]) {
                    if (mapLBbgInitArr[i][j] == -1) {
                        mapLBbg = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"tile%d.png",mapLBbgArr[i][j]]];
                        [mapLBbg setPosition:CGPointMake(50*j+10+25, 50*(5-i)+45+25)];
                        mapLBbg.rotation = -90;
                        [refreshBatchNode addChild:mapLBbg z:2 tag:mapSpriteTag[i][j]+400];
                    }else {
                        [refreshBatchNode removeChildByTag:mapSpriteTag[i][j]+400 cleanup:YES];
                    }
                    mapLBbgInitArr[i][j] = mapLBbgArr[i][j];
                }

                if (mapRBbgArr[i][j] != mapRBbgInitArr[i][j]) {
                    if (mapRBbgInitArr[i][j] == -1) {
                        mapRBbg = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"tile%d.png",mapRBbgArr[i][j]]];
                        [mapRBbg setPosition:CGPointMake(50*j+10+25, 50*(5-i)+45+25)];
                        
                        mapRBbg.rotation = 180;
                        [refreshBatchNode addChild:mapRBbg z:2 tag:mapSpriteTag[i][j]+500];
                        
                    }else {
                        [refreshBatchNode removeChildByTag:mapSpriteTag[i][j]+500 cleanup:YES];
                    }
                    mapRBbgInitArr[i][j] = mapRBbgArr[i][j];
                }

                
                    
            }
            else{
                
                mapbg = [CCSprite spriteWithSpriteFrameName:@"tile2.png"];
                [mapbg setPosition:CGPointMake(50*j+10+25, 50*(5-i)+45+25)];
                if (![refreshBatchNode getChildByTag:mapSpriteTag[i][j]+600]) {
                    
                    [refreshBatchNode addChild:mapbg z:1 tag:mapSpriteTag[i][j]+600];

                    if (mapLTbgInitArr[i][j] != -1) {
                        [refreshBatchNode removeChildByTag:mapSpriteTag[i][j]+200 cleanup:YES];
                        mapLTbgInitArr[i][j] = -1;
                    }
                    if (mapRTbgInitArr[i][j] != -1) {
                        [refreshBatchNode removeChildByTag:mapSpriteTag[i][j]+300 cleanup:YES];
                        mapRTbgInitArr[i][j] = -1;
                    }
                    if (mapLBbgInitArr[i][j] != -1) {
                        [refreshBatchNode removeChildByTag:mapSpriteTag[i][j]+400 cleanup:YES];
                        mapLBbgInitArr[i][j] = -1;
                    }
                    if (mapRBbgInitArr[i][j] != -1) {
                        [refreshBatchNode removeChildByTag:mapSpriteTag[i][j]+500 cleanup:YES];
                        mapRBbgInitArr[i][j] = -1;
                    }
                }  
            }
        }
    }
    
    	
}

-(id)init{
    
    self = [super init];
    
    if (self != nil) {
        
        
        for (int i =0; i<6; i++) {
            
            if (i<4) {
                mergeX[i] = -1;
                mergeY[i] = -1;
            }
            
            for (int j = 0 ; j<6; j++) {
                mapUID[i][j] = -1;
                mapUGT[i][j] = -1;
                mapUnitType[i][j] = -1;
                mapUnitScore[i][j] = 0;
                delGroup[i][j] =-1;
                mapLTbgArr[i][j] = -1;
                mapRTbgArr[i][j] = -1;
                mapLBbgArr[i][j] = -1;
                mapRBbgArr[i][j] = -1;
                mapLTbgInitArr[i][j] = -1;
                mapRTbgInitArr[i][j] = -1;
                mapLBbgInitArr[i][j] = -1;
                mapRBbgInitArr[i][j] = -1;
                mapUnitScore[i][j] = 0;
            }
        }
        
        
        NSString *nowUnitID = [[ReflashUnit node] getUnitID];
        
        intID = [[UnitAttributes node] getUnitAttrWithKey:nowUnitID withSubKey:@"ID"];
        intGroupType = [[UnitAttributes node] getUnitAttrWithKey:nowUnitID withSubKey:@"groupto"];
        intType = [[UnitAttributes node] getUnitAttrWithKey:nowUnitID withSubKey:@"type"];
        intScore = [[UnitAttributes node] getUnitAttrWithKey:nowUnitID withSubKey:@"score"];
        
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
        refreshUnit = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@.png",nowUnitID]]; 
        
        
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
        
        
        //******* 初始化动画效果
        CCSpriteBatchNode *bombFrame = [CCSpriteBatchNode batchNodeWithFile:@"texturePack.png" capacity:BOMB_SPRITE_SHEET_CAPACITY];
        [self addChild:bombFrame];
        
        
        
        // 初始化背景
        [self mapBgInit];
        
        [self initCheckArr];
        
        [self pavingHanlder];
        
        for (int i=0; i<6; i++) {
            for (int j=0; j<6; j++) {
                mapbgInitArr[i][j] = mapbgArr[i][j];
                
            }
        }
        
    }
    return self;
}

-(void)dragonMoveWithX:(int)i withY:(int)j{
    
    isDchecked[i][j] = 1;
    
    le = 1;
    te = 2;
    re = 3;
    be = 4;
    
    //  左上角
    if (i==0 && j==0) {
        
        le = 0;
        te = 0;
        
        if (mapUnitType[i][j+1] != -1) {
            re = 0;


        }
        
        if (mapUnitType[i+1][j] != -1) {
            be = 0;

        }
        if (le+te+re+be == 0) {
            if (ischecked[i][j+1] == 1 || ischecked[i+1][j] == 1) {
                ischecked[i][j] = 1;
                isNeedDel = NO;
            }
            isNeedMove = NO;
            if (mapUnitType[i][j+1] == 4 && isDchecked[i][j+1] == 0) {
                [self dragonMoveWithX:i withY:j+1];
            }
            if (mapUnitType[i+1][j] == 4 && isDchecked[i+1][j] == 0) {
                [self dragonMoveWithX:i+1 withY:j];
            }
        }else {
            isNeedDel = NO;
        }
        
    }//  右上角
    if (i==0 && j==5) {
        
        te = 0;
        re = 0;
        
        if (mapUnitType[i][j-1] != -1 ) {
            le = 0;

        }
        
        if (mapUnitType[i+1][j] != -1 ) {
            be = 0;

        }
        
        if (le+te+re+be == 0) {
            if (ischecked[i][j-1] == 1 || ischecked[i+1][j] == 1) {
                ischecked[i][j] = 1;
                isNeedDel = NO;
            }
            isNeedMove = NO;

            if (mapUnitType[i][j-1] == 4 && isDchecked[i][j-1] == 0) {
                [self dragonMoveWithX:i withY:j-1];
            }
            if (mapUnitType[i+1][j] == 4 && isDchecked[i+1][j] == 0) {
                [self dragonMoveWithX:i+1 withY:j];
            }
            
        }else {
            isNeedDel = NO;
        }

    }
    //  右下角
    if (i==5 && j==5) {
        
        re = 0;
        be = 0;
        
        if (mapUnitType[i][j-1] != -1) {
            le = 0;
        }
        
        if (mapUnitType[i-1][j] != -1) {
            te = 0;
        }
        if (le+te+re+be == 0) {
            if (ischecked[i-1][j] == 1|| ischecked[i][j-1] == 1) {
                ischecked[i][j] = 1;
                isNeedDel = NO;
            }
            isNeedMove = NO;
            if (mapUnitType[i][j-1] == 4 && isDchecked[i][j-1] == 0) {
                [self dragonMoveWithX:i withY:j-1];
            }
            if (mapUnitType[i-1][j] == 4 && isDchecked[i-1][j] == 0) {
                [self dragonMoveWithX:i-1 withY:j];
            }
        }else {
            isNeedDel = NO;
        }
    }
    //  左下角
    if (i==5 && j==0) {
        
        le = 0;
        be = 0;
        
        if (mapUnitType[i-1][j] != -1) {
            te = 0;
        }
        
        if (mapUnitType[i][j+1] != -1) {
            re = 0;
        }
        if (le+te+re+be == 0) {
            if (ischecked[i-1][j] == 1 || ischecked[i][j+1] == 1) {
                ischecked[i][j] = 1;
                isNeedDel = NO;
            }
            isNeedMove = NO;
            if (mapUnitType[i-1][j] == 4 && isDchecked[i-1][j] == 0) {
                [self dragonMoveWithX:i-1 withY:j];
            }
            if (mapUnitType[i][j+1] == 4 && isDchecked[i][j+1] == 0) {
                [self dragonMoveWithX:i withY:j+1];
            }
        }else {
            isNeedDel = NO;
        }
    }
    
    // 上边
    if (i==0 && j> 0 && j<5) {
        
        te = 0;
        
        if (mapUnitType[i][j-1] != -1) {
            le = 0;
        }
        if (mapUnitType[i][j+1] != -1) {
            re = 0;
        }
        if (mapUnitType[i+1][j] != -1) {
            be = 0;
        }
        if (le+te+re+be == 0) {
            if (ischecked[i][j+1] == 1 || ischecked[i][j-1] == 1 || ischecked[i+1][j] == 1) {
                ischecked[i][j] = 1;
                isNeedDel = NO;
            }
            isNeedMove = NO;
            if (mapUnitType[i][j-1] == 4 && isDchecked[i][j-1] == 0) {
                [self dragonMoveWithX:i withY:j-1];
            }
            if (mapUnitType[i][j+1] == 4 && isDchecked[i][j+1] == 0) {
                [self dragonMoveWithX:i withY:j+1];
            }
            if (mapUnitType[i+1][j] == 4 && isDchecked[i+1][j] == 0) {
                [self dragonMoveWithX:i+1 withY:j];
            }
        }else {
            isNeedDel = NO;
        }
        
    }
    
    // 左边
    if (i >0 && i<5 && j==0) {
        
        le = 0;
        
        if (mapUnitType[i-1][j]!= -1) {
            te = 0;
        }
        if (mapUnitType[i][j+1] != -1) {
            re = 0;
        }
        if (mapUnitType[i+1][j] != -1) {
            be = 0;
        }
        if (le+te+re+be == 0) {
            if (ischecked[i-1][j] == 1 || ischecked[i][j+1] == 1 || ischecked[i+1][j] == 1) {
                ischecked[i][j] = 1;
                isNeedDel = NO;
            }
            isNeedMove = NO;
            if (mapUnitType[i-1][j] == 4 && isDchecked[i-1][j] == 0) {
                [self dragonMoveWithX:i-1 withY:j];
            }
            if (mapUnitType[i][j+1] == 4 && isDchecked[i][j+1] == 0) {
                [self dragonMoveWithX:i withY:j+1];
            }
            if (mapUnitType[i+1][j] == 4 && isDchecked[i+1][j] == 0) {
                [self dragonMoveWithX:i+1 withY:j];
            }
        }else {
            isNeedDel = NO;
        }
        
    }  
    // 右边
    if (i >0 && i<5 && j==5) {
        
        re = 0;
        
        if (mapUnitType[i-1][j] != -1) {
            te = 0;
        }
        if (mapUnitType[i+1][j] != -1) {
            be = 0;
        }
        if (mapUnitType[i][j-1] != -1) {
            le = 0;
        }
        if (le+te+re+be == 0) {
            if (ischecked[i-1][j] == 1 || ischecked[i][j-1] == 1 || ischecked[i+1][j] == 1) {
                ischecked[i][j] = 1;
                isNeedDel = NO;
            }
            isNeedMove = NO;
            if (mapUnitType[i-1][j] == 4 && isDchecked[i-1][j] == 0) {
                [self dragonMoveWithX:i-1 withY:j];
            }
            if (mapUnitType[i+1][j] == 4 && isDchecked[i+1][j] == 0) {
                [self dragonMoveWithX:i+1 withY:j];
            }
            if (mapUnitType[i][j-1] == 4 && isDchecked[i][j-1] == 0) {
                [self dragonMoveWithX:i withY:j-1];
            }
        }else {
            isNeedDel = NO;
        }
    }    
    // 下边
    if (i == 5 && j>0 && j<5) {
        
        be = 0;
        
        if (mapUnitType[i][j-1] != -1) {
            le = 0;
        }
        if (mapUnitType[i-1][j] != -1) {
            te = 0;
        }
        if (mapUnitType[i][j+1] != -1) {
            re = 0;
        }
        if (le+te+re+be == 0) {
            if (ischecked[i-1][j] == 1 || ischecked[i][j+1] == 1 || ischecked[i][j-1] == 1) {
                ischecked[i][j] = 1;
                isNeedDel = NO;
            }
            isNeedMove = NO;
            if (mapUnitType[i][j-1] == 4 && isDchecked[i][j-1] == 0) {
                [self dragonMoveWithX:i withY:j-1];
            }
            if (mapUnitType[i-1][j] == 4 && isDchecked[i-1][j] == 0) {
                [self dragonMoveWithX:i-1 withY:j];
            }
            if (mapUnitType[i][j+1] == 4 && isDchecked[i][j+1] == 0) {
                [self dragonMoveWithX:i withY:j+1];
            }
        }else {
            isNeedDel = NO;
        }
    }
    
    //中间
    if (i>0 && i<5 && j>0 && j<5) {
        
        if (mapUnitType[i-1][j] != -1) {
            te = 0;
        }
        if (mapUnitType[i][j+1] != -1) {
            re = 0;
        }
        if (mapUnitType[i+1][j] != -1) {
            be = 0;
        }
        if (mapUnitType[i][j-1] != -1) {
            le = 0;
        }
        if (le+te+re+be == 0) {
            
            if (ischecked[i-1][j] == 1 || ischecked[i][j+1] == 1 || ischecked[i][j-1] == 1 || ischecked[i+1][j] == 1) {
                ischecked[i][j] = 1;
                isNeedDel = NO;
            }
            isNeedMove = NO;
            
            if (mapUnitType[i-1][j] == 4 && isDchecked[i-1][j] == 0) {
                [self dragonMoveWithX:i-1 withY:j];
            }
            if (mapUnitType[i][j+1] == 4 && isDchecked[i][j+1] == 0) {
                [self dragonMoveWithX:i withY:j+1];
            }
            if (mapUnitType[i+1][j] == 4 && isDchecked[i+1][j] == 0) {
                [self dragonMoveWithX:i+1 withY:j];
            }
            if (mapUnitType[i][j-1] == 4 && isDchecked[i][j-1] == 0) {
                [self dragonMoveWithX:i withY:j-1];
            }
        }else {
            isNeedDel = NO;
        }
    }
    if (le+te+re+be == 0 && (ischecked[i-1][j] == 0 || ischecked[i][j+1] == 0 || ischecked[i][j-1] == 0 || ischecked[i+1][j] == 0)) {
        NSLog(@"isNeedDel = YES");
    }else {
        NSLog(@"isNeedDel = NO （le+te+re+be: %d %d %d %d）",le,te,re,be);
        
        isNeedDel = NO;
        isDchecked[i][j] = 0;   //  If there are export is 0  避免判断时被归为消除成员中的一员
    }
}


// move function
-(void)dragonMoveHandler{
    
    [self initCheckArr];

    int moveXArr[36] = {0,1,0,2,1,0,3,2,1,0,4,3,2,1,0,5,4,3,2,1,0,5,4,3,2,1,5,4,3,2,5,4,3,5,4,5};
    int moveYArr[36] = {0,0,1,0,1,2,0,1,2,3,0,1,2,3,4,0,1,2,3,4,5,1,2,3,4,5,2,3,4,5,3,4,5,4,5,5};

    for (int k=0; k<36; k++) {
        int i=moveXArr[k];
        int j=moveYArr[k];
        if (mapUnitType[i][j] == 4 && ischecked[i][j] == 0) {
            
            NSLog(@"~~check I = %d J = %d    ischecked[i][j] = %d~~",i,j,ischecked[i][j]);
            for (int i =0; i<6; i++) {
                for (int j = 0 ; j<6; j++) {
                    isDchecked[i][j] =0;
                    
                }
            }
            isNeedMove = YES;    // 重设
            isNeedDel = YES;
            [self dragonMoveWithX:i withY:j];

           
//  返回数值：  ##0.挂掉  ##1.go left  ##2.go top ##3.go right  ##4.go bottom
            //****** 创建实例
        unitController = [MapUnitController node];
        int num = [unitController checkDirectionWithL:le withT:te withR:re withB:be];
            
            if (num !=0 && !isNeedMove) {
                num = 0;
            }

            
        
        switch (num) {
            case 0:
                
                if (isNeedDel) {
                    delGroupCount ++;
                    
                    NSLog(@"me me ~%d~~",delGroupCount);
                    for (int p=0; p<6; p++) {
                        for (int q=0; q<6; q++) {
                            if (isDchecked[p][q] == 1) {
                                [refreshBatchNode removeChildByTag:mapSpriteTag[p][q] cleanup:YES];
                                mapUGT[p][q] = 2002;
                                mapUID[p][q] = 2001;
                                mapUnitType[p][q] = 2;
                                CCSprite *mubei = [CCSprite spriteWithSpriteFrameName:@"2001.png"];
                                [mubei setPosition:CGPointMake(50*q+25+10, 50*(5-p)+95)];
                                [refreshBatchNode addChild:mubei z:p+2 tag:mapSpriteTag[p][q]];
                                
                                if (q>mergeY[delGroupCount-1]) {
                                    mergeY[delGroupCount-1] = q;
                                    mergeX[delGroupCount-1] = p;                             //
                                }                                           //   合成位置坐标
                                if (q == mergeY[delGroupCount-1]) {                          //
                                    if ( p >mergeX[delGroupCount-1] ) {                      //
                                        mergeX[delGroupCount-1] = p;
                                    }
                                }
                            }
                        }
                    }

                }
//                else{
//                
//                    mapUGT[i][j] = -1;
//                    mapUID[i][j] = 4001;
//                    mapUnitType[i][j] = 4;
//                }
                
                break;
            case 1:
            {
                CCAction *dACT = [CCMoveBy actionWithDuration:1 position:CGPointMake(-50, 0)];
                [[refreshBatchNode getChildByTag:i*10+j] runAction:dACT];
                
                [refreshBatchNode getChildByTag:i*10+j].tag = i*10+j-1;
                mapUGT[i][j-1] = -1;
                mapUID[i][j-1] = 4001;
                mapUGT[i][j] = -1;
                mapUID[i][j] = -1;
                mapUnitType[i][j] = -1;
                mapUnitType[i][j-1] = 4;
                ischecked[i][j-1] = 1;
            }
                break;
            case 2:
            {
                CCAction *dACT2 = [CCMoveBy actionWithDuration:1 position:CGPointMake(0,50)];
                [refreshBatchNode getChildByTag:i*10+j].zOrder = (i-1)+2;
                [[refreshBatchNode getChildByTag:i*10+j] runAction:dACT2];
                [refreshBatchNode getChildByTag:i*10+j].tag = (i-1)*10+j;
                
                mapUGT[i-1][j] = -1;
                mapUID[i-1][j] = 4001;
                mapUGT[i][j] = -1;
                mapUID[i][j] = -1;
                mapUnitType[i][j] = -1;
                mapUnitType[i-1][j] = 4;
                ischecked[i-1][j] = 1;
            }
                break;
            case 3:
             {   
                CCAction *dACT3 = [CCMoveBy actionWithDuration:1 position:CGPointMake(50, 0)];
                [[refreshBatchNode getChildByTag:i*10+j] runAction:dACT3];
                
                [refreshBatchNode getChildByTag:i*10+j].tag = i*10+j+1;
                mapUGT[i][j+1] = -1;
                mapUID[i][j+1] = 4001;
                mapUGT[i][j] = -1;
                mapUID[i][j] = -1;
                mapUnitType[i][j] = -1;
                mapUnitType[i][j+1] = 4;
                ischecked[i][j+1] = 1;
            }
                break;
            case 4:
              {  
                  CCAction *dACT4 = [CCMoveBy actionWithDuration:1 position:CGPointMake(0, -50)];
                  [refreshBatchNode getChildByTag:i*10+j].zOrder = (i+1)+2;
                  [[refreshBatchNode getChildByTag:i*10+j] runAction:dACT4];
                  [refreshBatchNode getChildByTag:i*10+j].tag = (i+1)*10+j;
                
                mapUGT[i+1][j] = -1;
                mapUID[i+1][j] = 4001;
                mapUGT[i][j] = -1;
                mapUID[i][j] = -1;
                mapUnitType[i][j] = -1;
                mapUnitType[i+1][j] = 4;
                ischecked[i+1][j] = 1;
            }
                break;
            default:
                break;
        }
        }
        
    }

}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    

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
        
        
        if (mapUnitType[myx][myy]>0 && intType != 5) {
            return;
        }else if(intType != 5){
            //    把精灵属性存入各自数组中
            
            [refreshUnit removeFromParentAndCleanup:YES];
            mapUID[myx][myy] = intID;
            mapUGT[myx][myy] = intGroupType;
            mapUnitType[myx][myy] = intType;
            mapUnitScore[myx][myy] = intScore;
            mapSpriteTag[myx][myy] = myx*10 + myy;
        }


        
        //    获取groupType数值
        
        nowID = intID;
        
        
        switch (intType) {
            case 1:
                nowID = [self checkForUpdate:myx setY:myy withID:mapUID[myx][myy]];
                if (nowID > intID) {
                    delCount = 0; 
                    
                    for (int i =0; i<6; i++) {
                        for (int j = 0 ; j<6; j++) {
                            if(delGroup[i][j] !=-1){
                                [refreshBatchNode removeChildByTag:mapSpriteTag[i][j] cleanup:YES]; 
                                [refreshBatchNode removeChildByTag:mapSpriteTag[i][j]+600 cleanup:YES];
                                
                                mapUID[i][j] = -1;
                                mapUGT[i][j] = -1;
                                mapUnitType[i][j] = -1;
                                mapUnitScore[i][j] = 0;
                                delGroup[i][j] =-1;
                            }
                        }
                    }
                    
                    mapUID[myx][myy] = nowID;          //  新精灵grouptype为原来的groupto
                    mapUGT[myx][myy] = [[UnitAttributes node] getUnitAttrWithKey:[NSString stringWithFormat:@"%d",nowID] withSubKey:@"groupto"];
                    
                    refreshUnit =[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%d.png",nowID]];
                    
                    
                    //  给新精灵type数组赋值 以同步精灵属性
                    
                    
                    mapUnitType[myx][myy] =[[UnitAttributes node] getUnitAttrWithKey:[NSString stringWithFormat:@"%d",nowID] withSubKey:@"type"];
                    
                    mapUnitScore[myx][myy] =[[UnitAttributes node] getUnitAttrWithKey:[NSString stringWithFormat:@"%d",nowID] withSubKey:@"score"];
                    
                    [refreshBatchNode addChild:refreshUnit z:myx+2 tag:mapSpriteTag[myx][myy]];
                    
                    
                    [refreshUnit setPosition:CGPointMake(tileRect.origin.x + 25, tileRect.origin.y+refreshUnit.contentSize.height*0.5)];
                    
                    
                    
                    
                }else if(nowID == intID){
                    
                    refreshUnit =[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%d.png",nowID]];
                    [refreshUnit setPosition:CGPointMake(tileRect.origin.x + 25, tileRect.origin.y+refreshUnit.contentSize.height*0.5)];
                    [refreshBatchNode addChild:refreshUnit z:myx+2 tag:mapSpriteTag[myx][myy]];
                    
                    
                }
                NSLog(@"^^^^unitscore :%d",mapUnitScore[myx][myy]);
                mapUnitType[myx][myy] =1;
                
                [self dragonMoveHandler];
                
                //  检测是否有挂逼的
                
                for (int i = 0; i<4; i++) {
                    
                    if (mergeX[i] != -1) {
                        NSLog(@"do do %d %d",mergeX[i],mergeY[i]);
                        nowID = [self checkForUpdate:mergeX[i] setY:mergeY[i] withID:mapUID[mergeX[i]][mergeY[i]]];
                        
                        
                        if (nowID == mapUID[mergeX[i]][mergeY[i]] && nowID != -1) {
                            delCount = 0; 
                            
                            for (int i =0; i<6; i++) {
                                for (int j = 0 ; j<6; j++) {
                                    if(delGroup[i][j] !=-1){
                                        [refreshBatchNode removeChildByTag:mapSpriteTag[i][j] cleanup:YES]; 
                                        [refreshBatchNode removeChildByTag:mapSpriteTag[i][j]+600 cleanup:YES];
                                        
                                        mapUID[i][j] = -1;
                                        mapUGT[i][j] = -1;
                                        mapUnitType[i][j] = -1;
                                        mapUnitScore[i][j] = 0;
                                        
                                        delGroup[i][j] =-1;
                                        
                                    }
                                }
                            }
                            
                            mapUID[mergeX[i]][mergeY[i]] = nowID;          //  新精灵grouptype为原来的groupto
                            if (mergeX[i+1] != -1 && i<4) {
                                
                                mapUID[mergeX[i+1]][mergeY[i+1]] = nowID;
                                mapUGT[mergeX[i+1]][mergeY[i+1]] = [[UnitAttributes node] getUnitAttrWithKey:[NSString stringWithFormat:@"%d",nowID] withSubKey:@"groupto"];
                            }
                            mapUGT[mergeX[i]][mergeY[i]] = [[UnitAttributes node] getUnitAttrWithKey:[NSString stringWithFormat:@"%d",nowID] withSubKey:@"groupto"];
                            
                            [refreshBatchNode removeChildByTag:mapSpriteTag[mergeX[i]][mergeY[i]] cleanup:YES];

                            CCSprite *newUnit =[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%d.png",nowID]];
                            
                            
                            //  给新精灵type数组赋值 以同步精灵属性
                            
                            
                            mapUnitType[mergeX[i]][mergeY[i]] =[[UnitAttributes node] getUnitAttrWithKey:[NSString stringWithFormat:@"%d",nowID] withSubKey:@"type"];
                            
                            mapUnitScore[mergeX[i]][mergeY[i]] =[[UnitAttributes node] getUnitAttrWithKey:[NSString stringWithFormat:@"%d",nowID] withSubKey:@"score"];
                            
                            [refreshBatchNode addChild:newUnit z:myx+2 tag:mapSpriteTag[mergeX[i]][mergeY[i]]];
                            
                            
                            [newUnit setPosition:CGPointMake(50*mergeY[i] + 25 +10, 50*(5-mergeX[i])+45+50)];
                            
                            mergeX[i] = -1;
                            mergeY[i] = -1;
                            
                        }

                    }
                    
                }
                break;
                
            case 4:
                refreshUnit =[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%d.png",nowID]];
                [refreshUnit setPosition:CGPointMake(tileRect.origin.x + 25, tileRect.origin.y+refreshUnit.contentSize.height*0.5)];
                [refreshBatchNode addChild:refreshUnit z:myx+2 tag:mapSpriteTag[myx][myy]];
                
                [self dragonMoveHandler];
                
                [self delUnits];
                
                break;
            case 5:
                
                if (mapUnitType[myx][myy] == -1) {
                    
                    return;
                    
                }else if(mapUnitType[myx][myy] == 4){
                    
                    [refreshUnit removeFromParentAndCleanup:YES];
                    asp = [AnimateSprite node];
                    asp.position =CGPointMake(tileRect.origin.x + 25, tileRect.origin.y+40); 
                    [self addChild:asp];
                    
                    [refreshBatchNode removeChildByTag:mapSpriteTag[myx][myy] cleanup:YES];
                    
                    mapUID[myx][myy] = 2001;
                    mapUGT[myx][myy] = 2002;
                    mapUnitType[myx][myy] = 2;
                    mapUnitScore[myx][myy] = [[UnitAttributes node] getUnitAttrWithKey:[NSString stringWithFormat:@"%d", mapUID[myx][myy]] withSubKey:@"score"];
                    refreshUnit =[CCSprite spriteWithSpriteFrameName:@"2001.png"];
                    
                    [self dragonMoveHandler];
                    [self delUnits];

                    
                }else if (mapUnitType[myx][myy] == 8) {
                    
                    [refreshUnit removeFromParentAndCleanup:YES];
                }else {
                    
                    [refreshUnit removeFromParentAndCleanup:YES];
                    asp = [AnimateSprite node];
                    asp.position =CGPointMake(tileRect.origin.x + 25, tileRect.origin.y+ 40); 
                    [self addChild:asp];
                    [refreshBatchNode removeChildByTag:mapSpriteTag[myx][myy] cleanup:YES];
                    [refreshBatchNode removeChildByTag:mapSpriteTag[myx][myy]+600 cleanup:YES];
                    mapUID[myx][myy] = -1;
                    mapUGT[myx][myy] = -1;
                    mapUnitType[myx][myy] = -1;
                    mapUnitScore[myx][myy] = 0;
                }
            
                break;
            case 6:
                if (mapUnitType[myx][myy] != -1) {
                    
                    return;
                    
                }else {
                    int aroundUID[4];
                    aroundUID[0] = mapUID[myx-1][myy];
                    aroundUID[1] = mapUID[myx][myy+1];
                    aroundUID[2] = mapUID[myx+1][myy];
                    aroundUID[3] = mapUID[myx][myy-1];
                    if (myx == 0) {
                        aroundUID[0] = -1;
                    }
                    if (myx == 5) {
                        aroundUID[2]= -1;
                    }
                    if (myy == 0) {
                        aroundUID[3] = -1;
                    }
                    if (myy == 5) {
                        aroundUID[1] = -1;
                    }
                    int max[4];
                    int temp;
                    for (int i =0; i<4; i++) {
                        max[i]=aroundUID[i];
                    }
                    for (int i =0; i<3; i++) {
                        for (int j=0; j<3; j++) {
                            if (max[j] < max[j+1]) {
                                temp = max[j+1];
                                max[j+1] =max[j];
                                max[j] = temp;
                            }
                        }
                    }
                    
                    int getID = 0;
                    int getID2 = 0;
                    int getID3 = 0;
                    int getID4 = 0;
                    
                    getID = [self checkForUpdate:myx setY:myy withID:max[0]];
                    getID2 = [self checkForUpdate:myx setY:myy withID:max[1]];
                    getID3 = [self checkForUpdate:myx setY:myy withID:max[2]];
                    getID4 = [self checkForUpdate:myx setY:myy withID:max[3]];
                    if (getID == max[0]) {
                        if (getID2 == max[1]) {
                            if (getID3 == max[2]) {
                                if (getID4 == max[3]) {
                                    refreshUnit =[CCSprite spriteWithSpriteFrameName:@"7001.png"];
                                    [refreshUnit setPosition:CGPointMake(tileRect.origin.x + 25, tileRect.origin.y+refreshUnit.contentSize.height*0.5)];
                                    [refreshBatchNode addChild:refreshUnit z:myx+2 tag:mapSpriteTag[myx][myy]];
                                }else {
                                    getID = max[3];
                                }
                            }else {
                                getID = max[2];
                            }
                        }else {
                            nowID = getID2;
                            if (getID3 == max[2]) {       // 第三级不能合
                                if (getID4 == max[3]) {      // 第四级不能合
                                    nowID = getID;              // 下3级都不行 所以等于最大
                                }else if (getID - getID4 <= 2) {    // 第四级能合 且是最大的下级
                                    nowID = getID4;                 // 则为第四级
                                }
                            }else if (getID - getID3<= 2) {         // 第三级能合 且为最大下级
                                if (getID3-getID4<=2) {             // 则判断第四级
                                    nowID = getID4;                 // 能合 且为第三级下级
                                }else {
                                    nowID = getID3;                 // 不能合则为第三级
                                }
                            }

                        }
                    }else {                        
                        nowID = getID;                  //  当最大的可以合成
                        if (getID2 == max[1]) {         // 第二级不能合
                            if (getID3 == max[2]) {       // 第三级不能合
                                if (getID4 == max[3]) {      // 第四级不能合
                                    nowID = getID;              // 下3级都不行 所以等于最大
                                }else if (getID - getID4 <= 2) {    // 第四级能合 且是最大的下级
                                    nowID = getID4;                 // 则为第四级
                                }
                            }else if (getID - getID3<= 2) {         // 第三级能合 且为最大下级
                                if (getID3-getID4<=2) {             // 则判断第四级
                                    nowID = getID4;                 // 能合 且为第三级下级
                                }else {
                                    nowID = getID3;                 // 不能合则为第三级
                                }
                            }
                        }else if (getID - getID2 <= 2) {            // 第二级能和 且为最大下级
                            if (getID2-getID3<=2) {                 // 第三级也能合 且为2下级
                                if (getID3-getID4>=2) {             // 第四级也能合 且为3下级  
                                    nowID = getID4;                 // 则为4
                                }else {
                                    nowID = getID3;                 // 4不行 则3
                                }
                            }else {
                                nowID = getID2;                     // 3不行 则2
                            }
                        }
                        
                    }
                }
                break;
        }        
        

//       reflash mapbg
        [self pavingHanlder];

//       刷新单位
        NSLog(@"***%@.png***",nowUnitID);
        refreshUnit = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@.png",nowUnitID]];
        [refreshBatchNode addChild:refreshUnit z:2];
        
        [refreshUnit setPosition:CGPointMake(screenSize.width*0.5f, 380)]; 
        
        intType = [[UnitAttributes node] getUnitAttrWithKey:nowUnitID withSubKey:@"type"];
        intID = [[UnitAttributes node] getUnitAttrWithKey:nowUnitID withSubKey:@"ID"];
        intScore = [[UnitAttributes node] getUnitAttrWithKey:nowUnitID withSubKey:@"score"];
        if (intType < 4) {
            
            intGroupType = [[UnitAttributes node] getUnitAttrWithKey:nowUnitID withSubKey:@"groupto"];
        }else {
            intGroupType = -1;
        }
    }
}

-(void)delUnits{

    nowID = [self checkForUpdate:myx setY:myy withID:mapUID[myx][myy]];
    
    if (nowID == mapUID[myx][myy] && mapUnitType[myx][myy] != 4 && nowID != -1) {
        delCount = 0; 
        
        for (int i =0; i<6; i++) {
            for (int j = 0 ; j<6; j++) {
                if(delGroup[i][j] !=-1){
                    [refreshBatchNode removeChildByTag:mapSpriteTag[i][j] cleanup:YES]; 
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
        
        
        refreshUnit =[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%d.png",nowID]];
        
        
        //  给新精灵type数组赋值 以同步精灵属性
        
        
        mapUnitType[myx][myy] = [[UnitAttributes node] getUnitAttrWithKey:[NSString stringWithFormat:@"%d",nowID] withSubKey:@"type"];
        
        mapUnitScore[myx][myy] = [[UnitAttributes node] getUnitAttrWithKey:[NSString stringWithFormat:@"%d",nowID] withSubKey:@"score"];
        
        [refreshBatchNode addChild:refreshUnit z:myx+2 tag:mapSpriteTag[myx][myy]];
        
        
        [refreshUnit setPosition:CGPointMake(tileRect.origin.x + 25, tileRect.origin.y+refreshUnit.contentSize.height*0.5)];
        
        
        
        
    }

}



-(void)realloc{

    [super dealloc];
}





@end
