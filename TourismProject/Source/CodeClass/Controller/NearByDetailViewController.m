//
//  NearByDetailViewController.m
//  TourismProject
//
//  Created by lanou3g on 16/1/30.
//  Copyright © 2016年 鲁东阳. All rights reserved.
//

#import "NearByDetailViewController.h"
#import "CExpandHeader.h"
#import "NearbyDetailTableViewCell.h"

@interface NearByDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView * tableView;

@property(nonatomic,strong)UIImageView * imgView;
@property(nonatomic,strong)NSMutableArray * keyArray;
@end

@implementation NearByDetailViewController
{
    CExpandHeader * _header;
}

-(NSMutableDictionary *)dataDict{
    if (!_dataDict) {
        _dataDict = [NSMutableDictionary dictionaryWithObjects:@[@"model.d_Description",@"model.address",@"model.arrival_type",@"model.opening_time",@"model.tel"] forKeys:@[@"概况",@"地址",@"到达方式",@"开放时间",@"联系方式"]];
    }return _dataDict;
}
-(NSMutableArray *)keyArray{
    if (!_keyArray) {
        _keyArray = [NSMutableArray arrayWithObjects:@"概况",@"地址",@"到达方式",@"开放时间",@"联系方式", nil];
    }return _keyArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 180)];
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 180)];
//    [imageView setImage:[UIImage imageNamed:@"backview"]];
    _imgView.backgroundColor = [UIColor redColor];
    customView.backgroundColor = [UIColor cyanColor];
    //关键步骤 设置可变化背景view属性
    _imgView.autoresizingMask = UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleWidth;
    _imgView.clipsToBounds = YES;
    _imgView.contentMode = UIViewContentModeScaleAspectFill;
       [_imgView yy_setImageWithURL:[NSURL URLWithString:_model.cover] options:YYWebImageOptionProgressiveBlur|YYWebImageOptionSetImageWithFadeAnimation];
    UINib * cellNib = [UINib nibWithNibName:@"NearbyDetailTableViewCell" bundle:nil];

    [customView addSubview:_imgView];
//    NSMutableDictionary * dic = [NSMutableDictionary dic]
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    [label setText:@"这是一个自定义头部view"];
    [label setTextColor:[UIColor redColor]];
    [customView addSubview:label];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:(UITableViewStyleGrouped)];
        [self.tableView registerNib:cellNib forCellReuseIdentifier:@"cell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewRowAnimationAutomatic;
    self.tableView.estimatedRowHeight = 10;

    _header = [CExpandHeader expandWithScrollView:_tableView expandView:customView];
 
    
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
//    self.tableView.tableHeaderView = view;
    [self.view addSubview:self.tableView];
//    _dataDict ob
   
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  NSString *sectionTitle=[self tableView:tableView titleForHeaderInSection:section];
  
      if (sectionTitle==nil) {
      
          return nil;
      }
   
    UIView *sectionView=[[UIView alloc] initWithFrame:CGRectMake(0, 10, kWidth, 30)];
    
    UILabel *label=[[UILabel alloc] init];
    label.frame=CGRectMake(10, 0, kWidth-10, 30);
    label.backgroundColor=[UIColor clearColor];
    label.font=[UIFont fontWithName:@"Helvetica-Bold" size:14];
    [sectionView addSubview:label];
    label.text=sectionTitle;
    return sectionView;
    
  }
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.keyArray[section];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.keyArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NearbyDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[NearbyDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.nameLabel.text = @"awwwwwwwwwwwwwwwiytluyfktruytiutyioutgouigiygiutgioesdgfdhdfshdfshdfshfeshrwagrwagrgerwagresgreshgreshthtrshtrsjhtrdsjrsjugiouguiogougoiuhwwwwa";

    NSLog(@"=============%@",cell.nameLabel.text);
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
