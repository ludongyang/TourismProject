//
//  SearchDataTools.m
//  TourismApp
//
//  Created by ShenDeju on 16/1/22.
//  Copyright © 2016年 王欣. All rights reserved.
//

#import "SearchDataTools.h"

@implementation SearchDataTools
+(instancetype) sharePassSearchData
{
    static SearchDataTools *searchDT = nil;
    if (searchDT == nil) {
        static dispatch_once_t token;
        dispatch_once(&token, ^{
            searchDT = [[SearchDataTools alloc] init];
        });
    }
    return searchDT;
}

-(void)getSearchDomainData:(PassSearchData)passSearchData
{
    NSMutableArray *tempArr = [NSMutableArray array];
    NSMutableArray *tempAr = [NSMutableArray array];
    NSMutableArray *allData = [NSMutableArray array];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *url = [NSURL URLWithString:destinationUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"数据解析错误%@",error);
        }
        else
        {
                for (NSDictionary *dict in responseObject[@"search_data"][0][@"elements"]) {
                    DestinationCityModel *model = [DestinationCityModel initWithDictionary:dict];
                    [tempArr addObject:model];
                }
            
                for (NSDictionary *dict in responseObject[@"search_data"][1][@"elements"]) {
                    DestinationCityModel *model = [DestinationCityModel initWithDictionary:dict];
                    [tempAr addObject:model];
                }
            
            [allData addObject:tempArr];
            [allData addObject:tempAr];
            passSearchData(allData);
        }
    }];
    [dataTask resume];
}

@end
