//
//  MapViewController.m
//  项目高德导航
//
//  Created by lanou3g on 16/1/29.
//  Copyright © 2016年 王欣. All rights reserved.
//

#import "MapViewController.h"
#import "CustomAnnotation.h"
#import "CustomAnnotationView.h"
#import "CustomCalloutView.h"
@interface MapViewController ()<AMapNaviViewControllerDelegate,AMapLocationManagerDelegate,AMapNaviManagerDelegate,MAMapViewDelegate>
@property(nonatomic,strong)AMapLocationManager * manager;
@property(nonatomic,strong)UIButton * locatButton;
@property(nonatomic,strong)UIButton * showButton;
@property (nonatomic, strong) AMapNaviManager *naviManager;
@property (nonatomic, strong) AMapNaviViewController *naviViewController;
@property (nonatomic, strong) MAMapView *mapView;


@end
BOOL buttonBool = NO;
@implementation MapViewController


+(instancetype)shareMapManagerControl{
    static    MapViewController * mapViewControl = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!mapViewControl) {
            mapViewControl = [[MapViewController alloc]init];
        }
    });return mapViewControl;
}
-(NSSet *)dataSet{
    if (!_dataSet) {
        _dataSet = [NSSet new];
    }return _dataSet;
}
-(MAMapView *)mapView{
    if (!_mapView) {
        _mapView = [[MAMapView alloc]initWithFrame:self.view.bounds];
        _mapView.delegate = self;
        [self.view addSubview:_mapView];
    }return _mapView;
}
-(AMapLocationManager *)manager{
    if (!_manager) {
        _manager = [[AMapLocationManager alloc]init];
        _manager.delegate = self;
    }return _manager;
}
- (void)initNaviManager
{
    if (_naviManager == nil)
    {
        _naviManager = [[AMapNaviManager alloc] init];
        [_naviManager setDelegate:self];
    }
}

- (void)initNaviViewController
{
    if (_naviViewController == nil)
    {
        _naviViewController = [[AMapNaviViewController alloc] initWithDelegate:self];
    }
}
// 规划路线
- (void)routeCalWithStartPoint:(AMapNaviPoint*)startPint AndEndPoint:(AMapNaviPoint*)endPoint
{
    //    AMapNaviPoint *startPoint = [AMapNaviPoint locationWithLatitude:39.989614 longitude:116.481763];
    //    AMapNaviPoint *endPoint = [AMapNaviPoint locationWithLatitude:39.983456 longitude:116.315495];
    
    //导航的时候创建导航视图
    [self initNaviManager];
    [self initNaviViewController];
    NSArray *startPoints = @[startPint];
    NSArray *endPoints   = @[endPoint];
    
    //驾车路径规划（未设置途经点、导航策略为速度优先）
    [_naviManager calculateDriveRouteWithStartPoints:startPoints endPoints:endPoints wayPoints:nil drivingStrategy:0];
    
    //步行路径规划
//    [self.naviManager calculateWalkRouteWithStartPoints:startPoints endPoints:endPoints];
}

// !!!:路径规划成功的回调函数
- (void)naviManagerOnCalculateRouteSuccess:(AMapNaviManager *)naviManager
{
    
    //导航视图展示
    [_naviManager presentNaviViewController:_naviViewController animated:YES];
}

// !!!:导航视图被展示出来的回调函数
- (void)naviManager:(AMapNaviManager *)naviManager didPresentNaviViewController:(UIViewController *)naviViewController
{
    
    
    //调用startGPSNavi方法进行实时导航，调用startEmulatorNavi方法进行模拟导航
    [_naviManager startGPSNavi];
    //    [_naviManager startGPSNavi];
}

- (void)naviViewControllerCloseButtonClicked:(AMapNaviViewController *)naviViewController
{
    
    
    [self.naviManager stopNavi];
    
    [self.naviManager dismissNaviViewControllerAnimated:YES];
}

// 处理位置更新
-(void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location{
    NSLog(@"处理位置更新%@",location);
}
/**
 *  定位权限状态改变时回调函数
 *
 *  @param manager 定位 AMapLocationManager 类。
 *  @param status 定位权限状态。
 */
- (void)amapLocationManager:(AMapLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    NSLog(@"定位权限改变回调函数%d",status);
    
}

/**
 *  开始定位,定位结束后将数据出传出去
 *
 *  @param CLLocationAccuracy 定位精度
 *  @param mapBlock           如果定位结束传出去的定位数据(逆地理信息)
 */
-(void)startLocationWithAccuracy:(CLLocationAccuracy)CLLocationAccuracy MapBlock:(MapBlock)mapBlock{
    
    //定位精度
    [self.manager setDesiredAccuracy:CLLocationAccuracy];
    
    //定位结束后调用
    [self.manager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        mapBlock(location,regeocode,error);
        
    }];
}


// !!!:mapView的代理方法
-(MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *customReuseIndetifier = @"customReuseIndetifier";
        
        CustomAnnotationView *annotationView = (CustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        
        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
            annotationView.canShowCallout = NO;
            annotationView.draggable = YES;
            annotationView.calloutOffset = CGPointMake(0, -5);
        }
        CustomAnnotation * an = (CustomAnnotation*)annotation;
        annotationView.name = an.title;
        //下载图片
        //        [annotationView.portraitImageView sd_setImageWithURL:[NSURL URLWithString:an.imageUrlString]];
        
        NSLog(@"%@",annotation);
        return annotationView;
    }
    
    return nil;
}
-(void)viewWillAppear:(BOOL)animated{
    
    _locatButton = [[UIButton alloc]initWithFrame:CGRectMake(30, kHeight-120, 50, 50)];
    [_locatButton setImage:[UIImage imageNamed:@"iconfont-dingwei (1)"] forState:(UIControlStateNormal)];
    [_locatButton addTarget:self action:@selector(toMyLocation:) forControlEvents:(UIControlEventTouchUpInside)];
    _locatButton.backgroundColor = [UIColor clearColor];
    _showButton = [[UIButton alloc]initWithFrame:CGRectMake(kWidth-100, kHeight-120, 50, 50)];
    _showButton.backgroundColor = [UIColor brownColor];
    [_showButton addTarget:self action:@selector(showBussiness:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_locatButton];
    [self.view addSubview:_showButton];
    [self.view bringSubviewToFront:_showButton];
    [self.view bringSubviewToFront:_locatButton];
    
}

// !!!:添加标注
-(void)addAnnotations:(NSSet *)objects{
    // :!!!遍历集合里面元素添加到地图
    if (buttonBool==NO) {
        for (NearByModel * modl in objects) {
            CustomAnnotation *annotation = [[CustomAnnotation alloc] init];
            CLLocation * location = [[CLLocation alloc]initWithLatitude:[modl.location[@"lat"]doubleValue] longitude:[modl.location[@"lng"]doubleValue]];
            
            annotation.coordinate = location.coordinate;
            annotation.title    = modl.name;
            annotation.subtitle = @"CustomAnnotationView";
            annotation.imageUrlString = modl.cover;
            
            [self.mapView addAnnotation:annotation];
            NSLog(@"%@",modl.name);
        }
        buttonBool = YES;
    }else{
        [self.mapView removeAnnotations:self.mapView.annotations];
        
        
    }

}


//清除地图信息
-(void)clearMapView{
    
    self.mapView.showsUserLocation = NO;
    [self.mapView removeAnnotations:self.mapView.annotations];
    self.mapView.delegate =nil;
    self.manager.delegate = nil;
    
    
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.mapView.showsCompass = YES;
    self.mapView.showsUserLocation = YES;
    self.mapView.showsScale = YES;

    self.mapView.compassOrigin = CGPointMake(kWidth-50, 80);
    self.mapView.scaleOrigin = CGPointMake(10, 70);
    self.mapView.mapType = MAMapTypeStandard;
    self.mapView.showsLabels = YES;

    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
 
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
