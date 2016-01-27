//
//  NearbyTableViewController.m
//  TourismApp
//
//  Created by lanou3g on 16/1/23.
//  Copyright © 2016年 王欣. All rights reserved.
//

#import "NearbyTableViewController.h"
#import "UserLocationViewController.h"
@interface NearbyTableViewController ()
@property(nonatomic,strong)DataBaseTool * tool;
@property(nonatomic,strong)MAMapView * mapView;
@property(nonatomic,assign)NSUInteger dataIndex;
@property(nonatomic,strong)UserLocationViewController * userLocation;

@end
static NSString * const reusedNearByTableCell = @"reusedNearByTableCell";

@implementation NearbyTableViewController
-(UserLocationViewController *)userLocation{
    if (!_userLocation) {
        _userLocation = [UserLocationViewController shareUserLocation];
    }return _userLocation;
}
-(CLLocation *)location{
    if (!_location) {
        _location = [[CLLocation alloc]init];
    }return _location;
}

-(DataBaseTool *)tool{
    if (!_tool) {
        _tool = [DataBaseTool shareDataBaseTool];
    }return _tool;
}
-(NSMutableDictionary *)dataDict{
    if (!_dataDict) {
        _dataDict = [NSMutableDictionary new];
    }return _dataDict;
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setToolbarHidden:YES animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataIndex = 1;
    UINib * nib = [UINib nibWithNibName:@"NearbyTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:reusedNearByTableCell];
    self.location = self.userLocation.mapView.userLocation.location;
    NSLog(@"@@@@%@",self.userLocation.mapView.userLocation.location);
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self getDataWithCategory];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getDataWithCategory];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getMoreDataWithCategory:self.category WithDataIndex:self.dataIndex];
    }];
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 160;
}
//根据类型获取数据,传入类型
-(void)getDataWithCategory{
    
    [self.tool getDtaWithCategory:self.category location:self.location passData:^(NSDictionary *dict) {
   
        NSArray * dataArray = dict[@"items"];
        NSMutableArray * categoryArr = [NSMutableArray new];
        for (NSDictionary * dic in dataArray) {
            NearByModel * model  = [NearByModel initWithDictionary:dic];
            [categoryArr addObject:model];
            
    }
        [_dataDict setObject:categoryArr forKey:self.category];
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];
    
}

//获取更多数据
-(void)getMoreDataWithCategory:(NSNumber*)category WithDataIndex:(NSInteger)dataIndex{
    
    if ([[self.dataDict objectForKeyedSubscript:category] count]==0) {
        [self getDataWithCategory];
        return;
    }
    
    [self.tool getDtaWithCategory:category location:self.location dataIndex:self.dataIndex passData:^(NSDictionary *dict) {
       
        
        NSArray * dataArray = dict[@"items"];
        NSMutableArray * categoryArr = [_dataDict objectForKey:category];
        
        for (NSDictionary * dic in dataArray) {
            NearByModel * model  = [NearByModel initWithDictionary:dic];
            [categoryArr addObject:model];
            
        }
         NSLog(@"=========%ld",self.dataIndex);
        self.dataIndex++;
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
        
        
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.dataDict objectForKey:self.category] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NearbyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedNearByTableCell forIndexPath:indexPath];
    NearByModel * model = [_dataDict objectForKey:self.category][indexPath.row];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.cover]];
    cell.nameLabel.text = model.name;
    cell.descripLabel.text = model.d_Description;
    cell.popularityLabel.text = [NSString stringWithFormat:@"%@",model.popularity];
    return cell;
}



@end
