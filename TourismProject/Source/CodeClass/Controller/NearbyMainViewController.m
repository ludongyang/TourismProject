//
//  NearbyMainViewController.m
//  TourismApp
//
//  Created by lanou3g on 16/1/23.
//  Copyright © 2016年 王欣. All rights reserved.
//

#import "NearbyMainViewController.h"


#import "NearbyTableViewController.h"
@interface NearbyMainViewController ()<MAMapViewDelegate,AMapSearchDelegate,MapViewControllerDelegate>
@property(nonatomic,strong)NSMutableArray * titleArray;
@property(nonatomic,strong)NSMutableArray * controllerClasses;
@property(nonatomic,strong)NSDictionary * dataDict;
@property(nonatomic,strong)MAMapView * mapView;
//逆地理编码
@property(nonatomic,strong)AMapReGeocode * geo;

@property(nonatomic,strong)NSMutableString * geoLocationStr;
@property(nonatomic,strong)AMapSearchAPI * serach;
@property(nonatomic,strong)MapViewController * shareMap;
@property(nonatomic,strong)CLLocation * location;
@property(nonatomic,strong) AMapReGeocodeSearchRequest * regeo;
@end

@implementation NearbyMainViewController


+(instancetype)shareNerbyMainViewController{
    
    static NearbyMainViewController * main = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!main) {
            main = [NearbyMainViewController new];
            
        }
    });return main;
    
}

-(MapViewController *)shareMap{
    if (!_shareMap) {
        _shareMap = [MapViewController shareMapViewController];
    }return _shareMap;
}
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
        _shareMap = [MapViewController shareMapViewController];
        _location = [[CLLocation alloc]init];
        _serach = [[AMapSearchAPI alloc]init];
        
        _serach.delegate = self;
        _regeo = [[AMapReGeocodeSearchRequest alloc]init];
        _regeo.radius = 10000;
        _regeo.requireExtension = YES;
        
        __block NearbyMainViewController * main = self;

        _shareMap.mapBlock= ^(CLLocation* location){
            main.location = location;
            NearbyTableViewController * nearByCurrent = (NearbyTableViewController*)main.currentViewController;
            nearByCurrent.location = location;
            [nearByCurrent getDataWithCategory];
            
            main.regeo.location = [AMapGeoPoint locationWithLatitude:main.location.coordinate.latitude longitude:main.location.coordinate.longitude];
            NSLog(@"定位成功%@",location);
            [main.serach AMapReGoecodeSearch:main.regeo];
            
        };
        
    }return self;
}
- (void)pageController:(WMPageController *)pageController willEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info{
    NearbyTableViewController * tab = (NearbyTableViewController*)viewController;
    [tab setValue:self.location forKey:@"location"];

}


//反编码
-(void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{
    if (response.regeocode != NULL) {
         AMapAddressComponent * result = response.regeocode.addressComponent;
        
        self.geoLocationStr = [NSMutableString stringWithFormat:@"%@%@%@%@",result.province,result.city,result.district,result.township];
   
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"定位成功" message:self.geoLocationStr preferredStyle:(UIAlertControllerStyleAlert)];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissViewControllerAnimated:YES completion:nil];
        
            [UIView animateWithDuration:1 animations:^{
                self.navigationItem.titleView.alpha = 1;
                self.navigationItem.title = self.geoLocationStr;
            } completion:^(BOOL finished) {
                
            }];
            
        });

        [self presentViewController:alert animated:YES completion:nil];
        self.mapView.showsUserLocation = NO;
    }
}
//进入地图页面
-(void)toMapView:(UIBarButtonItem*)sender{

    NearbyTableViewController * tablView = (NearbyTableViewController *)self.currentViewController;
    
    
    for (NSString * st in tablView.keyArray) {
        NearByModel * model = [tablView.dataDict objectForKey:st];
        [_shareMap.anninationSet addObject:model];
    }

    [_shareMap startLocate];
    [self.navigationController pushViewController:_shareMap animated:YES];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{

}


@end
