//
//  ObjClass.m
//  TripleJP
//
//  Created by user on 12-7-26.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "ObjClass.h"


@implementation ObjClass

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
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        return [doucumentsDirectiory stringByAppendingPathComponent:@"texturePack-hd.plist"];
        
    }
    else{
        
        return [doucumentsDirectiory stringByAppendingPathComponent:@"texturePack.plist"];
        
    }

}

//-(CCSprite *)buildUnit:(NSString *)UnitID{
//    
//    NSString *tmpFilePath = [self dataPath];
//    if ( [[NSFileManager defaultManager] fileExistsAtPath:tmpFilePath ]) {
//        
//        NSMutableArray *array = [[NSMutableArray alloc] initWithContentsOfFile:tmpFilePath];
//        
//        NSNumber *temNumber = [array objectAtIndex:0];
//        aIntValue = [temNumber intValue];
//        [array release];
//    }
//    
//
//}


@end
