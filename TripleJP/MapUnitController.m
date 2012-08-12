//
//  MapUnitController.m
//  TripleJP
//
//  Created by user on 12-8-8.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "MapUnitController.h"


@implementation MapUnitController


-(void)setUnitX:(int)x setY:(int)y withSprite:(CCSprite*)sprite{
    


}


-(void)check:(int)x sety:(int)y
{
 //   mapUnitType[x][y].isCanClear=YES;
       mapSpriteIschecked[x][y] = 1;
    
    if (x-1<0) {
        x=0;
    }
    if (y-1<0) {
        y=0;
    }
    if (x+1>5) {
        x=5;
    }
    if (y+1<5) {
        y=5;
    }
    if(mapUnitGroupType[x-1][y]==mapUnitGroupType[x][y] && !mapSpriteIschecked[x-1][y]==1)
    {
        //...各种判断
        [delArr addObject:[NSNumber numberWithInt:mapSpriteTag[x-1][y]]];
        
        
        
        
        [self check:x-1 sety:y];
    }
    if(mapUnitGroupType[x+1][y] == mapUnitGroupType[x][y] && !mapSpriteIschecked[x-1][y]==1)
    {
        [self check:x sety:y-1];
    }
    if(mapUnitGroupType[x][y-1] == mapUnitGroupType[x][y] && !mapSpriteIschecked[x-1][y]==1)
    {
        [self check:x+1 sety:y];
    }
    if(mapUnitGroupType[x][y+1] == mapUnitGroupType[x][y] && !mapSpriteIschecked[x-1][y]==1)
    {
        [self check:x sety:y+1];
    }
    
}


@end
