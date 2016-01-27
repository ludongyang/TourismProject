//
//  NearbyMainViewController.m
//  TourismApp
//
//  Created by lanou3g on 16/1/23.
//  Copyright © 2016年 王欣. All rights reserved.
//

#import "NearbyMainViewController.h"
#import "UserLocationViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "NearbyTableViewController.h"
@interface NearbyMainViewController ()<MAMapViewDelegate,AMapSearchDelegate>
@property(nonatomic,strong)NSMutableArray * titleArray;
@property(nonatomic,strong)NSMutableArray * controllerClasses;
@property(nonatomic,strong)NSDictionary * dataDict;
@property(nonatomic,strong)MAMapView * mapView;
//逆地理编码
@property(nonatomic,strong)AMapReGeocode * geo;

@property(nonatomic,strong)NSMutableString * geoLocationStr;
@property(nonatomic,strong)AMapSearchAPI * serach;
@property(nonatomic,strong)UserLocationViewController * userLocation;
@end

@implementation NearbyMainViewController

-(NSArray<NSString *> *)titles{
    if (!_titleArray) {
        _titleArray = [NSMutableArray arrayWithObjects:@"全部",@"景点",@"住宿",@"餐厅",@"休闲娱乐",@"购物", nil];
    }return _titleArray;
}
-(NSArray<Class> *)viewControllerClasses{
    if (_controllerClasses) {
    
    }return _controllerClasses;
}
-(instancetype)init{
    if (self = [super init]) {
      self.controllerClasses  = [NSMutableArray arrayWithObjects:[NearbyTableViewController class],[NearbyTableViewController class],[NearbyTableViewController class],[NearbyTableViewController class],[NearbyTableViewController class],[NearbyTableViewController class], nil];
        self.keys = [NSMutableArray arrayWithObjects:@"category",@"category",@"category",@"category",@"category",@"category", nil];
        self.values =[NSMutableArray arrayWithObjects:kAllCategory,kScenic,kStay,kRestaurant,kLeisure,kShoping, nil];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"地图" style:(UIBarButtonItemStylePlain) target:self action:@selector(toMapView:)];
        self.mapView = [[MAMapView alloc]init];
        self.mapView.showsUserLocation = YES;
        self.mapView.userTrackingMode = MAUserTrackingModeFollow;
        [self.mapView.userLocation addObserver:self forKeyPath:@"location" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:nil];
        
    }return self;
}
//观察是否定位成功
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"location"]) {
   
        AMapReGeocodeSearchRequest * regeo = [[AMapReGeocodeSearchRequest alloc]init];
        CLLocation * locat = (CLLocation*)change[@"new"];
        regeo.location = [AMapGeoPoint locationWithLatitude:locat.coordinate.latitude longitude:locat.coordinate.longitude];
        regeo.radius = 10000;
        _serach = [[AMapSearchAPI alloc]init];
        _serach.delegate = self;
        regeo.requireExtension = YES;
        
        [_serach AMapReGoecodeSearch:regeo];

        [self.currentViewController setValue:locat forKey:@"location"];
    }
}
//反编码

-(void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{
    if (response.regeocode != NULL) {
         AMapAddressComponent * result = response.regeocode.addressComponent;
        
        self.geoLocationStr = [NSMutableString stringWithFormat:@"%@%@%@%@",result.province,result.city,result.district,result.township];
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"定位成功" message:self.geoLocationStr preferredStyle:(UIAlertControllerStyleAlert)];
        
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissViewControllerAnimated:YES completion:nil];
            if ([self.currentViewController isKindOfClass:[NearbyTableViewController class]]) {
                
                [(NearbyTableViewController*)self.currentViewController performSelector:@selector(getDataWithCategory)];
            }

        });

        [self presentViewController:alert animated:YES completion:nil];
        self.mapView.showsUserLocation = NO;
    }
}
-(void)toMapView:(UIBarButtonItem*)sender{
    UserLocationViewController * userLocation = [UserLocationViewController shareUserLocation];

    [self.navigationController pushViewController:userLocation animated:YES];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
  
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [self.mapView.userLocation removeObserver:self forKeyPath:@"location"];
}


@end
