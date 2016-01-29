//
//  NearbyTableViewController.m
//  TourismApp
//
//  Created by lanou3g on 16/1/23.
//  Copyright © 2016年 王欣. All rights reserved.
//

#import "NearbyTableViewController.h"

@interface NearbyTableViewController ()
@property(nonatomic,strong)DataBaseTool * tool;
//@property(nonatomic,strong)MAMapView * mapView;
@property(nonatomic,assign)NSUInteger dataIndex;


@end
static NSString * const reusedNearByTableCell = @"reusedNearByTableCell";

@implementation NearbyTableViewController

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

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setToolbarHidden:YES animated:animated];
  
    

}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataIndex = 1;
    UINib * nib = [UINib nibWithNibName:@"NearbyTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:reusedNearByTableCell];

    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self getDataWithCategory];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self getMoreDataWithCategory:self.category WithDataIndex:self.dataIndex];
    }];
    
   
    
    
    _dataDict = [NSMutableDictionary new];
    _keyArray  = [NSMutableArray new];
    [self.tableView.mj_header beginRefreshing];
}
-(void)viewDidAppear:(BOOL)animated{
    if (self.keyArray.count==0) {
        self.tableView.mj_footer.hidden = YES;
    }else{
        self.tableView.mj_footer.hidden = NO;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}
//根据类型获取数据,传入类型
-(void)getDataWithCategory{

    NSMutableDictionary * dic1 = [NSMutableDictionary new];
    NSMutableArray * key = [NSMutableArray new];
    [self.tool getDtaWithCategory:self.category location:self.location passData:^(NSDictionary *dict) {
        NSArray * dataArray = dict[@"items"];
        for (NSDictionary * dic in dataArray) {
            
            NearByModel * model  = [NearByModel initWithDictionary:dic];
            [dic1 setValue:model forKey:model.name];
            [key addObject:model.name];
      
    }
        _dataDict = dic1;
        _keyArray = key;
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];
    
}
-(void)getMoreDataWithCategory{
    
    [self.tool getDtaWithCategory:self.category location:self.location passData:^(NSDictionary *dict) {
        NSArray * dataArray = dict[@"items"];
        for (NSDictionary * dic in dataArray) {
            
            NearByModel * model  = [NearByModel initWithDictionary:dic];
            if ([_dataDict objectForKey:model.name]==nil ) {
                [_dataDict setObject:model forKey:model.name];
                [_keyArray insertObject:model.name atIndex:0];
                
            }
            
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    }];
    
    
    
    
    
}
//获取更多数据
-(void)getMoreDataWithCategory:(NSNumber*)category WithDataIndex:(NSInteger)dataIndex{
    
    if (_keyArray.count==0) {
        [self getDataWithCategory];
        return;
    }
    
    [self.tool getDtaWithCategory:category location:self.location dataIndex:self.dataIndex passData:^(NSDictionary *dict) {
       
        
        NSArray * dataArray = dict[@"items"];


        for (NSDictionary * dic in dataArray) {
            NearByModel * model  = [NearByModel initWithDictionary:dic];
            if ([_dataDict objectForKey:model.name]==nil ) {
                [_dataDict setObject:model forKey:model.name];
                [_keyArray addObject:model.name];
                
            }
            
        }

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

    return _keyArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NearbyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusedNearByTableCell forIndexPath:indexPath];

    NearByModel * model = [_dataDict objectForKey:_keyArray[indexPath.row]];
    
    [cell.imgView yy_setImageWithURL:[NSURL URLWithString:model.cover] options:YYWebImageOptionProgressiveBlur|YYWebImageOptionSetImageWithFadeAnimation];
    cell.nameLabel.text = model.name;
    cell.descripLabel.text = model.d_Description;
    cell.popularityLabel.text = [NSString stringWithFormat:@"%@",model.popularity];
    return cell;
}



@end
