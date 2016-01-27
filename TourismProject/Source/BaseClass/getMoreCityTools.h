//
//  getMoreCityTools.h
//  TourismApp
//
//  Created by ShenDeju on 16/1/21.
//  Copyright © 2016年 王欣. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^PassCity) (NSMutableArray *dataArr);
@interface getMoreCityTools : NSObject
+(instancetype) shareGetMoreCityTools;
-(void) getMoreCityWithUrl:(NSString *) url Data:(PassCity) passCity;

@end
