//
//  ReflashUnit.m
//  TripleJP
//
//  Created by user on 12-7-27.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReflashUnit.h"

@implementation ReflashUnit


/********创建路径**********/
- (NSString *) dataPath
{
    NSArray *storeFilePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *doucumentsDirectiory = [storeFilePath objectAtIndex:0];
    
    return [doucumentsDirectiory stringByAppendingPathComponent:@"refreshUnit.plist"];
    
}

-(id)getUnitID{
    
    int randNum = arc4random()%1000;
    NSString *unitID;
    NSLog(@"%d",randNum);
    
    NSString *tmpFilePath = [self dataPath];
    NSLog(@"%@",tmpFilePath);
    if ([[NSFileManager defaultManager] fileExistsAtPath:tmpFilePath ]) {
        NSLog(@"asdasd");
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:tmpFilePath];
        
        NSLog(@"%@",dic);
        int perRange = 0;
        
        for (int i = 0; i < 8; i++) {
            
            NSDictionary *keyDic = [dic objectForKey:[NSString stringWithFormat:@"%d",i]];
            
            if (i == 0) {
                
                perRange = 0;
                
            }else {
                NSDictionary *preKeyDic = [dic objectForKey:[NSString stringWithFormat:@"%d",i-1]];
                
                perRange = [[preKeyDic objectForKey:@"range"] intValue];
            }
            
            
            
            int range = [[keyDic objectForKey:@"range"] intValue];
            
            
            if (randNum >= perRange && randNum < range) {
                
                unitID = [keyDic objectForKey:@"ID"];
                
                NSLog(@"-----%@-------",unitID);
                
            }
        }
        
    }
    return unitID;
}




@end
