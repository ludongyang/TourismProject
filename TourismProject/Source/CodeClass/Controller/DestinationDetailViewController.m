//
//  DestinationDetailViewController.m
//  TourismProject
//
//  Created by ShenDeju on 16/1/29.
//  Copyright © 2016年 鲁东阳. All rights reserved.
//

#import "DestinationDetailViewController.h"

@interface DestinationDetailViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(strong,nonatomic) UICollectionView *collectionView;
@property(strong,nonatomic) ExpandHeader *header;
@end

static NSString *const collectionReuseID = @"collectionReuseidentifier";
@implementation DestinationDetailViewController

-(instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 180)];
    customView.backgroundColor = [UIColor redColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 180)];
    [imageView setImage:[UIImage imageNamed:@"backview"]];
     //关键步骤 设置可变化背景view属性
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [customView addSubview:imageView];
    
    
    UICollectionViewFlowLayout *flayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flayout];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:collectionReuseID];
    
    _header =[ExpandHeader expandWithScrollView:_collectionView expandView:customView];
    // Do any additional setup after loading the view.
}
-(void) backAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:collectionReuseID forIndexPath:indexPath];
       cell.backgroundColor = [UIColor redColor];
    return cell;
}

#pragma mark---collectionFlowlayoutDelegate---------
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kWidth, 50);
    
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//    
//}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
//{
//    
//}


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
