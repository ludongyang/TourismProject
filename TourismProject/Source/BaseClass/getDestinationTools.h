//
//  getDestinationTools.h
//  TourismApp
//
//  Created by ShenDeju on 16/1/20.
//  Copyright © 2016年 王欣. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^PassValue) (NSMutableArray * dataArray, BOOL success);
typedef void (^PassElement) (NSMutableDictionary *dataDict,BOOL success);
@interface getDestinationTools : NSObject
+(instancetype) shareGetDestinationTools;
-(void) getBannerData:(PassValue) passBanner;
-(void) getSectionData:(PassElement) passElement;
@end
