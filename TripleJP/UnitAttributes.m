//
//  UnitAttributes.m
//  TripleJP
//
//  Created by user on 12-8-8.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "UnitAttributes.h"


@implementation UnitAttributes


- (NSString *) dataPath
{
    NSArray *storeFilePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *doucumentsDirectiory = [storeFilePath objectAtIndex:0];
    
    return [doucumentsDirectiory stringByAppendingPathComponent:@"Items.plist"];
    
}


-(int)getUnitAttrWithKey:(NSString*)key withSubKey:(NSString*)subKey{
    
    NSString *tmpFilePath = [self dataPath];
    
    int keyV;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:tmpFilePath ]) {

        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:tmpFilePath];
        
        NSDictionary *useKeyDic = [dic objectForKey:key];
        
        keyV = [[useKeyDic objectForKey:subKey] intValue];

    }
    return keyV;
}

@end
