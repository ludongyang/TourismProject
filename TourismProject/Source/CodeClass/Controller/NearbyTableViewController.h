//
//  NearbyTableViewController.h
//  TourismApp
//
//  Created by lanou3g on 16/1/23.
//  Copyright © 2016年 王欣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
@interface NearbyTableViewController : UITableViewController
@property (strong, nonatomic) NSMutableDictionary *dataDict;
@property(nonatomic,strong) NSMutableArray * keyArray;
@property (strong, nonatomic) NSNumber * category;
@property(nonatomic,strong) CLLocation * location;
-(void)getDataWithCategory;
@end
