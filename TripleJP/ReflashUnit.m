//
//  ReflashUnit.m
//  TripleJP
//
//  Created by user on 12-7-27.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReflashUnit.h"


@implementation ReflashUnit

- (id)init {
    self = [super init];
    if (self) {
        
        
    }
    return self;
}

/********创建路径**********/
- (NSString *) dataPath
{
    NSArray *storeFilePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *doucumentsDirectiory = [storeFilePath objectAtIndex:0];
    
    return [doucumentsDirectiory stringByAppendingPathComponent:@"refreshUnit.plist"];
    
}

-(CCSprite *)reflashUnit{

    int randNum = arc4random()%8;
    
    NSString *tmpFilePath = [self dataPath];
    if ( [[NSFileManager defaultManager] fileExistsAtPath:tmpFilePath ]) {
        NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:tmpFilePath];
        
        NSDictionary *tempDic = [array objectAtIndex:randNum];
        CCLOG(tempDic);
        [array release];
        [tempDic release];
    }
    CCSprite *dd = [CCSprite node];
    return dd;

}

@end
