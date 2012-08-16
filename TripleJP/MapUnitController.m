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
    for (int i =0; i<6; i++) {
        for (int j = 0 ; j<6; j++) {
            mapUGT[i][j] =0;
        }
    }
    for (int i =0; i<6; i++) {
        for (int j = 0 ; j<6; j++) {
            delGroup[i][j] =-1;
        }
    }
    
        
}

-(void)checkForUpdate{

    //  判断横向的情况    
    
    for (int i =0; i<6; i++) {
        for (int j = 0 ; j<6-2; j++) {
            
            //           判断这     X   |   X |  XX | XX
            //           种情况     XX  |  XX |  X  |  X    纵向和横向一样 不用再次判断
            
            if (mapUGT[i][j] == mapUGT[i][j+1] && mapUGT[i][j]!=mapUGT[i][j+2]) {
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
            
            
            if (mapUGT[i][j] == mapUGT[i][j+1] && mapUGT[i][j]==mapUGT[i][j+2]) {
                
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
            
            
            if (mapUGT[j][i] == mapUGT[j+1][i] && mapUGT[i][j]==mapUGT[j+2][i]) {
                
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
    



}

@end
