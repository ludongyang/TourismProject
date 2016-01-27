//
//  SearchDataTools.h
//  TourismApp
//
//  Created by ShenDeju on 16/1/22.
//  Copyright © 2016年 王欣. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^PassSearchData) (NSMutableArray *dataArr);
@interface SearchDataTools : NSObject
+(instancetype) sharePassSearchData;
-(void) getSearchDomainData:(PassSearchData) passSearchData;

@end
