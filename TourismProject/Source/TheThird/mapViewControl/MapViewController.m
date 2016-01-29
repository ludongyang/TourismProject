//
//  MapViewController.m
//  ditu
//
//  Created by lanou3g on 16/1/27.
//  Copyright © 2016年 王欣. All rights reserved.
//

#import "MapViewController.h"

#import "CustomAnnotationView.h"
#import "CustomAnnotation.h"


@interface MapViewController ()<MAMapViewDelegate>
@property(nonatomic,strong)MAMapView * mapView;
@property(nonatomic,strong)UISegmentedControl * showSegment;
@property(nonatomic,strong)UISegmentedControl * modeSegment;
@property(nonatomic,strong)UIButton * locatButton;
@property(nonatomic,strong)UIButton * showButton;

//@property(nonatomic,strong)
//标注数组
@property (nonatomic, strong) NSMutableArray *annotations;

@end

@implementation MapViewController
+(instancetype)shareMapViewController{
    static MapViewController * map = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!map) {
            map = [[MapViewController alloc]init];
        }
    });return map;
    
}


-(instancetype)init{
    if (self = [super init]) {
        _mapView = [[MAMapView alloc]init];
        _mapView.delegate = self;
        //定位
        _mapView.showsUserLocation = YES;
        [_mapView.userLocation addObserver:self forKeyPath:@"location" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:nil];
        
    }return self;
    
}
-(NSMutableSet *)anninationSet{
    if (!_anninationSet) {
        _anninationSet = [NSMutableSet new];
    }return _anninationSet;
}
-(NSMutableArray *)annotations{
    if (!_annotations) {
        _annotations = [NSMutableArray new];
    }return _annotations;
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
-(void)showBussiness:(UIButton*)sender{
    [self addAnnotations:self.anninationSet];
}
-(void)toMyLocation:(UIButton*)sender{
    if (_mapView.showsUserLocation==NO) {
        _mapView.showsUserLocation = YES;
    }
    
    [UIView animateWithDuration:.5
                     animations:^{
                         sender.transform = CGAffineTransformScale(sender.transform, 0.8, 0.8);
                       
                     } completion:^(BOOL finished) {
                         sender.transform = CGAffineTransformScale(sender.transform, 1.25, 1.25);
                     }];
    [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];

}


- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
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
        [annotationView.portraitImageView sd_setImageWithURL:[NSURL URLWithString:an.imageUrlString]];

        NSLog(@"%@",annotation);
        return annotationView;
    }
    
    return nil;
}


//开启定位
-(void)startLocate{
    _mapView.showsUserLocation = YES;
}
// !!!:待做
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"location"]) {
        
        CLLocation * locat = (CLLocation*)change[@"new"];
        NSLog(@"定位成功 %@",locat);
        self.mapBlock(locat);
        self.mapView.showsUserLocation = NO;
    }
}
// !!!:待做
-(void)addAnnotations:(NSSet *)objects{
    // :!!!遍历集合里面元素添加到地图
   
    
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

}
//清除地图信息
-(void)clearMapView{
    
    self.mapView.showsUserLocation = NO;
    [self.mapView removeAnnotations:self.mapView.annotations];
    self.mapView.delegate =nil;
    
    
}
-(void)dealloc{
    [self.mapView.userLocation removeObserver:self forKeyPath:@"location"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"地图";
   
    _mapView.showsCompass = YES;
    _mapView.showsScale = YES;
    _mapView.frame = self.view.bounds;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    [self.view addSubview:_mapView];
  
    // Do any additional setup after loading the view.
}
-(void)mapView:(MAMapView *)mapView didChangeUserTrackingMode:(MAUserTrackingMode)mode animated:(BOOL)animated{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
