//
//  MapUnitController.m
//  TripleJP
//
//  Created by user on 12-8-8.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "MapUnitController.h"


@implementation MapUnitController


-(int)checkDirectionWithL:(int)leftNum withT:(int)topNum withR:(int)rightNum withB:(int)bottomNum{
    NSLog(@"leftNum+topNum+rightNum+bottomNum = %d+%d+%d+%d",leftNum,topNum,rightNum,bottomNum);
    NSLog(@"ltrb = %d",leftNum+topNum+rightNum+bottomNum);
    switch (leftNum+topNum+rightNum+bottomNum) {
        case 0:            
            return 0;
            break;
        case 1:
            return leftNum;
            break;
        case 2:
            return topNum;
            break;
        case 3:
            if (leftNum !=0) {
                int i = arc4random()%2+1;
                
                NSLog(@"case3 i=%d",i);
                return i;
            }else {
                return rightNum;
            }
            break;
        case 4:
            if (leftNum !=0) {
                int i = arc4random()%2;
                
                NSLog(@"case4 i=%d",i);
                if (i==0) {
                    return leftNum;
                }else{
                    return rightNum;
                }
            }else {
                return bottomNum;
            }
            break;
        case 5:
            
            if (leftNum !=0) {
                int i = arc4random()%2;  
                NSLog(@"case5 i=%d",i);
                if (i==0) {
                    return leftNum;
                }else {
                    return bottomNum;
                }
            }else {
                int i = arc4random()%2;
                if (i==0) {
                    return rightNum;
                }else {
                    return topNum;
                }
            }
            break;
        case 6:
            if (leftNum !=0) {
                int i = arc4random()%3;
                
                NSLog(@"case61 i=%d",i);
                if (i==0) {
                    return leftNum;
                }else if (i == 1) {
                    return topNum;
                }else {
                    return rightNum;
                }
            }else {
                int i = arc4random()%2;
                
                NSLog(@"case62 i=%d",i);
                if (i == 0) {
                    return topNum;
                }else {
                    return bottomNum;
                }
            }
            break;
        case 7:
            if (leftNum !=0) {
                int i = arc4random()%3;
                
                NSLog(@"case71 i=%d",i);
                if (i == 0) {
                    return leftNum;
                }else if (i == 1) {
                    return topNum;
                }else {
                    return bottomNum;
                }
            }else {
                int i = arc4random()%2;
                
                NSLog(@"case72 i=%d",i);
                if (i == 0) {
                    return rightNum;
                }else {
                    return bottomNum;
                }
            }
            break;
        case 8:{
            int i = arc4random()%3;
            
            NSLog(@"case8 i=%d",i);
            if (i==0) {
                return leftNum;
            }else if (i ==1) {
                return rightNum;
            }else {
                return bottomNum;
            }}
            break;
        case 9:{
            int i = arc4random()%3;
            
            NSLog(@"case9 i=%d",i);
            if (i==0) {
                return topNum;
            }else if (i ==1) {
                return rightNum;
            }else {
                return bottomNum;
            }
            }
            break;
        case 10:{
            
            int i =arc4random()%4+1;
            NSLog(@"case10 i=%d",i);
            return i;
        }  
            break;
        default:
            return -1;
            break;
    }


}
@end
