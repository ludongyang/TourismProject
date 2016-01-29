//
//  MapViewController.h
//  ditu
//
//  Created by lanou3g on 16/1/27.
//  Copyright © 2016年 王欣. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import<MAMapKit/MAMapKit.h>
@protocol MapViewControllerDelegate
-(void)toGetDataWithLocation:(CLLocation*)location;
@end

typedef void(^MapBlock)(CLLocation*location);

@interface MapViewController : UIViewController
@property(nonatomic,strong)MapBlock mapBlock;
@property(nonatomic,weak) id<MapViewControllerDelegate>delegate;
@property(nonatomic,strong)NSMutableSet * anninationSet;
+(instancetype)shareMapViewController;
//开启定位
-(void)startLocate;
@end
