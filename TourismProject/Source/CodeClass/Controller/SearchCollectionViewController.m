//
//  SearchCollectionViewController.m
//  TourismApp
//
//  Created by ShenDeju on 16/1/25.
//  Copyright © 2016年 王欣. All rights reserved.
//

#import "SearchCollectionViewController.h"

@interface SearchCollectionViewController () <UISearchResultsUpdating ,UISearchBarDelegate,UICollectionViewDelegateFlowLayout>
@property(strong,nonatomic) UICollectionViewController *searchResultsController;
@property(strong,nonatomic) UISearchController *SearchController;
@property(strong,nonatomic) NSMutableArray *collectionArray; // 数据
@property(strong,nonatomic) NSMutableArray *allData;
@property(strong,nonatomic) NSMutableArray *domainArray;
@property(strong,nonatomic) NSMutableArray *overSeaArray;
@property(strong,nonatomic) NSMutableArray *searchArray; //搜索后的数据
@property(strong,nonatomic) UISearchBar *searchBar;
@end

static NSString *const reuseIdentifier2 = @"reuseIdentifier";
static NSString * const reuseIdentifier = @"Cell";
@implementation SearchCollectionViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton  = YES;
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10,0, kWidth-80, 44)];
    self.searchBar.delegate = self;
    self.searchBar.placeholder= @"搜索";
    [_searchBar setBackgroundColor:[UIColor clearColor]];
//    [self.searchBar setKeyboardType:UIKeyboardTypeDefault];
    _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [[[_searchBar.subviews objectAtIndex:0].subviews objectAtIndex:0] removeFromSuperview];
    [self.navigationController.navigationBar addSubview:self.searchBar];
    [self.navigationController.navigationBar setBackgroundColor:[UIColor cyanColor]];
 /*
//    //导航条的搜索条
//    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0.0f,0.0f,240.f,44.0f)];
//    _searchBar.backgroundColor = [UIColor clearColor];
//    _searchBar.delegate = self;
//    [_searchBar setTintColor:[UIColor blackColor]];
//    [_searchBar setPlaceholder:@"输入艺人名字"];
//    
//    //将搜索条放在一个UIView上
//    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 240, 44)];
//    searchView.backgroundColor = [UIColor greenColor];
//    [searchView addSubview:_searchBar];
//    searchView.alpha = 0.1;
//    self.navigationItem.titleView = searchView;
 */
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier2];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self loadData];
    [self loadSearchController];
    
}
-(void) cancelAction
{
    [self.searchBar resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void) loadData
{
    self.domainArray = [NSMutableArray array];
    self.overSeaArray = [NSMutableArray array];
    self.collectionArray = [NSMutableArray array];
    
    [[SearchDataTools sharePassSearchData] getSearchDomainData:^(NSMutableArray *dataArr) {
        self.domainArray = dataArr[0];
        self.overSeaArray = dataArr[1];
        self.allData = dataArr;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    }];

}

-(void) loadSearchController
{
 
    self.SearchController=[[UISearchController alloc]initWithSearchResultsController:nil];
    self.SearchController.searchResultsUpdater=self;
    self.SearchController.view.backgroundColor = [UIColor whiteColor];
    self.SearchController.dimsBackgroundDuringPresentation = false;
    self.SearchController.hidesNavigationBarDuringPresentation = NO;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 2;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
        if (section == 0) {
            return self.domainArray.count;
        }
        else{
            return self.overSeaArray.count;
        }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
        if (indexPath.section == 0) {
            UICollectionViewCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
            DestinationCityModel *model = self.domainArray[indexPath.row];
            NSLog(@"======%@",model.name);
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell1.frame.size.width+5, cell1.frame.size.height+5)];
            label.text = model.name;
            label.textAlignment = NSTextAlignmentCenter;
            label.layer.cornerRadius = 5;
            label.layer.masksToBounds = YES;
            label.layer.borderWidth = 1;
            label.layer.borderColor = [[UIColor lightGrayColor] CGColor];
            label.backgroundColor = [UIColor whiteColor];
            [cell1 addSubview:label];
            return cell1;
        }
        else
        {
            UICollectionViewCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier2 forIndexPath:indexPath];
            DestinationCityModel *model = self.overSeaArray[indexPath.row];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell1.frame.size.width+5, cell1.frame.size.height+5)];
            label.text = model.name;
            label.textAlignment = NSTextAlignmentCenter;
            label.layer.cornerRadius = 5;
            label.layer.masksToBounds = YES;
            label.layer.borderWidth = 1;
            label.layer.borderColor = [[UIColor lightGrayColor] CGColor];
            label.backgroundColor = [UIColor whiteColor];
            [cell1 addSubview:label];
            return cell1;
        }
}

#pragma mark searchControllerDelegate
-(void) updateSearchResultsForSearchController:(UISearchController *)searchController
{
    //[self.SearchController.searchBar resignFirstResponder];
    
//    NSString *filterString = self.SearchController.searchBar.text;
//    [self.searchArray removeAllObjects];
//    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains [c] %@", filterString];
////    self.searchArray = [NSMutableArray arrayWithArray:[self.collectionArray filteredArrayUsingPredicate:predicate]];
//    
//    [self.searchArray addObject:filterString];
//    [self.searchResultsController.collectionView reloadData];
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"点击键盘搜索");
    SearchResultTableViewController *searchTVC = [[SearchResultTableViewController alloc] init];
    UINavigationController *unc = [[UINavigationController alloc] initWithRootViewController:searchTVC];
    searchTVC.keyString = searchBar.text;
    [self presentViewController:unc animated:YES completion:nil];
    
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (collectionView == self.searchResultsController.collectionView) {
//        NSLog(@".........");
//    }else
//    {

    //}

    NSLog(@"fasjfdos");
    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
    [self.SearchController.searchBar resignFirstResponder];
    
    SearchResultTableViewController *searchTVC = [[SearchResultTableViewController alloc] init];
    UINavigationController *unc = [[UINavigationController alloc] initWithRootViewController:searchTVC];
    
    if (indexPath.section == 0) {
        DestinationCityModel *model = self.domainArray[indexPath.row];
        searchTVC.keyString = model.name;
    }
    else
    {
        DestinationCityModel *model = self.overSeaArray[indexPath.row];
        searchTVC.keyString =model.name;
    }
    
    [self presentViewController:unc animated:YES completion:nil];
}


#pragma mark--------UICollectionViewLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
        if (indexPath.section == 0) {
            DestinationCityModel *model = self.domainArray[indexPath.row];
            CGRect rect = [model.name boundingRectWithSize:CGSizeMake(150, 21) options:NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
            return CGSizeMake(rect.size.width, 21);
        }
        else
        {
            DestinationCityModel *model = self.overSeaArray[indexPath.row];
            CGRect rect = [model.name boundingRectWithSize:CGSizeMake(150, 21) options:NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
            return CGSizeMake(rect.size.width, 21);
        }
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return  UIEdgeInsetsMake(10, 10, 10, 10);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 15;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(kWidth, 21);
}     


#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
