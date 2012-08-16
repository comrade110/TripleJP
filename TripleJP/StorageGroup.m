//
//  StorageGroup.m
//  TripleJP
//
//  Created by user on 12-8-9.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "StorageGroup.h"


@implementation StorageGroup

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
        
        if (tagx != tempMTA.x1 && tagx != tempMTA.x2 && tagy != tempMTA.y1 && tagy != tempMTA.y2) {        
            
            return NO;
            
        }else if((abs(tagx - tempMTA.x1)>1 && abs(tagx - tempMTA.x2) >1)||
                 (abs(tagy - tempMTA.y1)>1 && abs(tagy - tempMTA.y2) >1)){
            return NO;
            
        }else if ((tagx == tempMTA.x1 || tagx == tempMTA.x2) && abs(tagy-tempMTA.y1)>1)  {
            
            return NO;
        }
        else if ((tagy == tempMTA.y1 || tagy ==tempMTA.y2)&&abs(tagx-tempMTA.x1)>1 ) {
            return NO;
        }
        
    }    
    return YES;
}

-(void)findItemsInStorageArr:(int)x withY:(int)y{
    
    NSLog(@"x=%d,y=%d",x,y);
    if ([storageArr count] == 0) {
        return;
    }
    
    for (int i= 0; i<[storageArr count]; i++) {
        MapTileAttribute *tempMTA = [storageArr objectAtIndex:i];
        
        if ((x == tempMTA.x1 && y==tempMTA.y1)||(x== tempMTA.x2 && y==tempMTA.y2)) {
            
            int clearTag1 = tempMTA.x1 *10 + tempMTA.y1; 
            
            int clearTag2 = tempMTA.x2 *10 + tempMTA.y2; 
            
            NSLog(@"clearTag1:%d",clearTag1);
            
            //            NSNumber *cnum1 = [[NSNumber alloc] initWithInt:clearTag1];
            //            NSNumber *cnum2 = [[NSNumber alloc] initWithInt:clearTag2];
            //            
            //            [clearArr addObject:cnum1];
            //            [clearArr addObject:cnum2];
            [refreshBatchNode removeChildByTag:clearTag1 cleanup:YES];
            [refreshBatchNode removeChildByTag:clearTag2 cleanup:YES];
            mapUnitGroupType[tempMTA.x1][tempMTA.y1] = -1;
            mapUnitGroupType[tempMTA.x2][tempMTA.y2] = -1;
            mapUnitType[tempMTA.x1][tempMTA.y1] = -1;
            mapUnitType[tempMTA.x2][tempMTA.y2] = -1;
            mapSpriteTag[tempMTA.x1][tempMTA.y1] = -1;
            mapSpriteTag[tempMTA.x2][tempMTA.y2] = -1;
            [storageArr fastRemoveObjectAtIndex:i];
            
        }
    }
    
}

//-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
//{
//    CGPoint touchPoint = [self convertTouchToNodeSpace:touch];
//    
//    NSString *nowUnitID = [[ReflashUnit node] getUnitID];
//    
//    if (CGRectContainsPoint(tileRect, touchPoint)) {
//        
//        if (mapUGT[mapTileX][mapTileY]>0) {
//            return;
//        }
//        
//        //    把精灵属性存入各自数组中
//        
//        mapUGT[mapTileX][mapTileY] = intGroupType;
//        mapUnitType[mapTileX][mapTileY] = intType;
//        mapSpriteTag[mapTileX][mapTileY] = mapTileX*10 + mapTileY;
//        refreshUnit.tag = mapTileX*10+mapTileY;
//        
//        
//        
//        
//        NSLog(@"mapUGT[mapTileX - 1][mapTileY]:%d",mapUGT[mapTileX - 1][mapTileY]);
//        
//        if (mapUGT[mapTileX - 1][mapTileY] == intGroupType && intType < 4 ) {
//            
//            NSLog(@"NO.1");
//            
//            if ([self checkIsInStorage:mapSpriteTag[mapTileX-1][mapTileY]] == YES) {
//                
//                isNeedGroup = YES; 
//                
//                [self findItemsInStorageArr:mapTileX-1 withY:mapTileY];
//                
//                
//                
//            }else {
//                
//                
//                [aroundSpriteTag addObject:[NSString stringWithFormat:@"%d",mapSpriteTag[mapTileX-1][mapTileY]]];
//                NSLog(@"aroundSpriteTag count:%d",[aroundSpriteTag count]);
//                //         把自己和临近的精灵坐标存起
//                
//                MapTileAttribute *mapAttr = [MapTileAttribute node];
//                
//                mapAttr.x1 = mapTileX - 1;
//                mapAttr.y1 = mapTileY;
//                mapAttr.x2 = mapTileX;
//                mapAttr.y2 = mapTileY;
//                
//                //               NSLog(@"%d %d %d %d",mapAttr.x1,mapAttr.y1,mapAttr.x2,mapAttr.y2);
//                
//                [storageArr addObject:mapAttr];
//                NSLog(@"storageArr+1 at (%d,%d)",mapTileX - 1,mapTileY);
//                NSLog(@"storageArr:%d",[storageArr count]);
//                
//            }
//            
//        }
//        if (mapUGT[mapTileX + 1][mapTileY] == intGroupType && intType < 4 ) {
//            
//            NSLog(@"NO.2");
//            
//            
//            if ([self checkIsInStorage:mapSpriteTag[mapTileX+1][mapTileY]] == YES) {
//                
//                isNeedGroup = YES;
//                
//                [self findItemsInStorageArr:mapTileX+1 withY:mapTileY];   
//                
//                NSLog(@"noaroundSpriteTag~~~2");
//            }else if(!isNeedGroup){
//                
//                [aroundSpriteTag addObject:[NSString stringWithFormat:@"%d",mapSpriteTag[mapTileX+1][mapTileY]]];
//                
//                MapTileAttribute *mapAttr = [MapTileAttribute node];
//                
//                mapAttr.x1 = mapTileX + 1;
//                mapAttr.y1 = mapTileY;
//                mapAttr.x2 = mapTileX;
//                mapAttr.y2 = mapTileY;
//                
//                
//                
//                [storageArr addObject:mapAttr];
//                NSLog(@"storageArr+1 at (%d,%d)",mapTileX + 1,mapTileY);
//            }
//            
//        }
//        if (mapUGT[mapTileX][mapTileY-1] == intGroupType && intType < 4 ) {
//            
//            NSLog(@"NO.3");
//            
//            
//            if ([self checkIsInStorage:mapSpriteTag[mapTileX][mapTileY-1]] == YES) {
//                
//                isNeedGroup = YES;
//                [self findItemsInStorageArr:mapTileX withY:mapTileY-1];    
//                
//                NSLog(@"noaroundSpriteTag~~~3");
//            }else if(!isNeedGroup){
//                
//                [aroundSpriteTag addObject:[NSString stringWithFormat:@"%d",mapSpriteTag[mapTileX][mapTileY-1]]];
//                
//                MapTileAttribute *mapAttr = [MapTileAttribute node];
//                NSLog(@"storageArr+1 at (%d,%d)",mapTileX ,mapTileY- 1);                
//                mapAttr.x1 = mapTileX ;
//                mapAttr.y1 = mapTileY - 1;
//                mapAttr.x2 = mapTileX;
//                mapAttr.y2 = mapTileY;
//                
//                //               NSLog(@"%d %d %d %d",mapAttr.x1,mapAttr.y1,mapAttr.x2,mapAttr.y2);
//                
//                [storageArr addObject:mapAttr];
//                
//            }
//            
//        }
//        if (mapUGT[mapTileX][mapTileY + 1] == intGroupType && intType < 4 ) {
//            
//            NSLog(@"NO.4");
//            
//            
//            if ([self checkIsInStorage:mapSpriteTag[mapTileX][mapTileY+1]] == YES) {
//                
//                isNeedGroup = YES;
//                
//                [self findItemsInStorageArr:mapTileX withY:mapTileY+1];
//                
//                NSLog(@"noaroundSpriteTag~~~4");
//                
//            }else if(!isNeedGroup){
//                
//                
//                [aroundSpriteTag addObject:[NSString stringWithFormat:@"%d",mapSpriteTag[mapTileX][mapTileY + 1]]];
//                
//                MapTileAttribute *mapAttr = [MapTileAttribute node];
//                
//                mapAttr.x1 = mapTileX;
//                mapAttr.y1 = mapTileY + 1;
//                mapAttr.x2 = mapTileX;
//                mapAttr.y2 = mapTileY;
//                
//                //               NSLog(@"%d %d %d %d",mapAttr.x1,mapAttr.y1,mapAttr.x2,mapAttr.y2);
//                
//                [storageArr addObject:mapAttr];
//                NSLog(@"storageArr+1 at (%d,%d)",mapTileX,mapTileY+1);
//            }
//            
//        }
//        if (isNeedGroup || [aroundSpriteTag count] > 1) {
//            
//            int newUnitID = mapUGT[mapTileX][mapTileY];      //    获取groupType数值
//            
//            NSString *newUnitIDStr = [NSString stringWithFormat:@"%d",newUnitID];
//            
//            
//            for (int i =0; i<[aroundSpriteTag count]; i++) {
//                
//                if (mapSpriteTag[mapTileX][mapTileY] != -1) {
//                    
//                    int temptag = [[aroundSpriteTag objectAtIndex:i] intValue];
//                    
//                    [refreshBatchNode removeChildByTag:temptag cleanup:YES];
//                    
//                    mapUGT[temptag/10][temptag%10] = -1;
//                    mapUnitType[temptag/10][temptag%10] = -1;
//                    mapSpriteTag[mapTileX][mapTileY] = -1;
//                }
//                
//            }
//            
//            
//            //            for (int i=0; i<[clearArr count]; i++) {
//            //                int ctag = [[clearArr objectAtIndex:i] intValue];
//            //                
//            //                NSLog(@"%d~~~~~~~~~~~~\n",ctag);
//            //                
//            //                [refreshBatchNode removeChildByTag:ctag cleanup:YES];
//            //            }
//            
//            
//            [refreshBatchNode removeChildByTag:mapSpriteTag[mapTileX][mapTileY] cleanup:YES]; 
//            
//            //            
//            //   移除原来的精灵
//            
//            
//            intGroupType = [[UnitAttributes node] getUnitAttrWithKey:newUnitIDStr withSubKey:@"groupto"];
//            
//            mapUGT[mapTileX][mapTileY] = intGroupType;          //  新精灵grouptype为原来的groupto
//            
//            refreshUnit =[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%d_s.png",newUnitID]];
//            
//            
//            //  给新精灵type数组赋值 以同步精灵属性
//            
//            
//            mapUnitType[mapTileY][mapTileY] =[[UnitAttributes node] getUnitAttrWithKey:newUnitIDStr withSubKey:@"type"];
//            
//            [refreshBatchNode addChild:refreshUnit z:2 tag:mapSpriteTag[mapTileX][mapTileY]];
//            
//            
//            [refreshUnit setPosition:CGPointMake(tileRect.origin.x + 25, tileRect.origin.y+refreshUnit.contentSize.height*0.5)];
//            
//            [aroundSpriteTag release];                          //  统计周围单个精灵数量 合成后归0
//            [clearArr release];            
//            aroundSpriteTag = [[CCArray array] retain];
//            clearArr = [[CCArray array] retain];
//            
//        }else{
//            [refreshUnit setPosition:CGPointMake(tileRect.origin.x + 25, tileRect.origin.y+refreshUnit.contentSize.height*0.5)];
//            refreshUnit.tag = mapTileX*10+mapTileY;
//            
//            [aroundSpriteTag release];                         //   未合成归0
//            aroundSpriteTag = [[CCArray array] retain];
//            
//        }
//        
//        //       刷新单位
//        
//        refreshUnit = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"%@_s.png",nowUnitID]];
//        [refreshBatchNode addChild:refreshUnit z:2];
//        
//        [refreshUnit setPosition:CGPointMake(screenSize.width*0.5f, 380)]; 
//        
//        intType = [[UnitAttributes node] getUnitAttrWithKey:nowUnitID withSubKey:@"type"];
//        if (intType < 4) {
//            
//            intGroupType = [[UnitAttributes node] getUnitAttrWithKey:nowUnitID withSubKey:@"groupto"];
//        }else {
//            intGroupType = 0;
//        }
//        isNeedGroup = NO;
//    }
//}

@end
