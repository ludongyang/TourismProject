//
//  getMoreCityTools.m
//  TourismApp
//
//  Created by ShenDeju on 16/1/21.
//  Copyright © 2016年 王欣. All rights reserved.
//

#import "getMoreCityTools.h"

@implementation getMoreCityTools
+(instancetype) shareGetMoreCityTools
{
    static getMoreCityTools *getMCT = nil;
    if (getMCT == nil) {
        static dispatch_once_t token;
        dispatch_once(&token, ^{
            getMCT = [[getMoreCityTools alloc] init];
        });
    }
    return getMCT;
}

-(void) getMoreCityWithUrl:(NSString *) url Data:(PassCity) passCity
{
    NSMutableArray *tempArr = [NSMutableArray array];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *urlS = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:urlS];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSLog(@"数据解析错误:%@",error);
        }
        else
        {
            for (NSDictionary *dict in responseObject[@"data"]) {
                DestinationCityModel *model = [DestinationCityModel initWithDictionary:dict];
                [tempArr addObject:model];
            }
        }
        passCity(tempArr);
    }];
    [dataTask resume];
}

@end
