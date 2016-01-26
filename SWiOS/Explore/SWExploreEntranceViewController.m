//
//  SWExploreEntranceViewController.m
//  SWiOS
//
//  Created by YuchenZhang on 7/25/15.
//  Copyright (c) 2015 com.itangxueqiu. All rights reserved.
//

#import "SWExploreEntranceViewController.h"
#import "SWExploreEntranceDataProvider.h"

#import "ZYCScrollableToolbar.h"
#import "SWCommonAPI.h"

#import "SWExploreNaviDelegate.h"
#import "UILabel+Extension.h"
#import "SWExploreItemDetailViewController.h"
#import "HttpHelper.h"
#import "LSUIScrollView.h"
#import "NSString+Extension.h"
#import "UIWindow+Extension.h"
#import "CommentViewController.h"
#import "MJRefresh.h"
#import "SVTopScrollView.h"
#import "SVRootScrollView.h"
#import "SVGloble.h"
NSInteger kWDTransitionViewTag = 33331;

@interface SWExploreEntranceViewController () <LSUIScrollViewDelegate,SWExploreEntranceDataProviderDelegate,SVTopScrollViewDelegate>

@property (nonatomic, strong) SWExploreNaviDelegate *naviDelegate;

@property (nonatomic, strong) UITableView *contentView;

@property (nonatomic, strong) ZYCScrollableToolbar *scrollableToolbar;

@property (nonatomic, strong) SWExploreEntranceDataProvider *dataProvider;

@property (nonatomic, strong) NSMutableArray *titleList;

@property (nonatomic, assign) int curIndex;


@property (nonatomic,strong) UIImageView *zan;

@end

@implementation SWExploreEntranceViewController


- (void)dealloc
{
    if (self.navigationController.delegate == _naviDelegate) {
        self.navigationController.delegate = nil;
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _initialize];
    }
    return self;
}


- (void)_initialize
{
//    self.dataProvider = [SWExploreEntranceDataProvider new];
    
    self.titleList = [NSMutableArray array];
    
    self.naviDelegate = [SWExploreNaviDelegate new];
    
    // fake some mock data
//    [self p_mockData];
    
    [self p_loadPiecesTitles];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.delegate = _naviDelegate;
    
 
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.pageName=@"SWExploreEntranceViewController";
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIWindow showTabBar:YES];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)p_loadPiecesTitles
{
    [[SWCommonAPI sharedInstance] post:@"getPiece/1" params:nil withSuccess:^(SWHttpRequestOperation *operation, id response) {
        
        _titleList = [response copy];
        NSLog(@"%@", response);
        
        NSMutableArray *titlesStrList = [NSMutableArray arrayWithCapacity:_titleList.count];
        [_titleList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            // assemble title string to linked list
            NSDictionary *val = obj;
            [titlesStrList addObject:val[@"sortTitle"]];
        }];
        
        
//        // refresh toolbar titles with data fetched from api server
//        dispatch_async(dispatch_get_main_queue(), ^{
//            NSArray *strongRefList = titlesStrList;
//            [_scrollableToolbar updateWithTitles:strongRefList];
//            strongRefList = nil;
//        });

        NSDictionary *pieceInfo = [_titleList objectAtIndex:0];
        NSString *pieceID = pieceInfo[@"id"];
        
        NSString *pieceImageURL = pieceInfo[@"sortUrl"];
        
//        [_dataProvider reloadDataWithPieceID:pieceID pieceImageUrl:pieceImageURL pageNum:0];
    
        
    } failure:^(SWHttpRequestOperation *operation, NSError *error) {
        NSLog(@"");
    }];
}

- (UITableView*)drawTable:(NSDictionary*)title{
    UITableView *content= [[UITableView alloc] init];
    
    content.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    SWExploreEntranceDataProvider *dataProvider=[self dataProvider:content];
    content.delegate=dataProvider;
    content.dataSource = dataProvider;
    content.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [content addHeaderWithCallback:^(){

//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([_titleList count]!=0) {
                // 刷新表格
                
                NSString *pieceID = title[@"id"];
                
                NSString *pieceImageURL = title[@"sortUrl"];
                
                [dataProvider reloadDataWithPieceID:pieceID pieceImageUrl:pieceImageURL pageNum:0 last:^(){
                    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
                    [content headerEndRefreshing];
                }];
            }
            
//        });
    }];
    #warning 自动刷新(一进入程序就下拉刷新)
    [content headerBeginRefreshing];
    return content;
}

-(void)itemDidClicked:(int)index{
    SVRootScrollView *rootScrollView = [SVRootScrollView shareInstance];
    [rootScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*(index-100), 0) animated:NO];
//    NSLog(@"");
}

- (void)drawViews
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
  
//    _contentView=[self drawTable];
    
    
    
    NSMutableArray* tl=[[NSMutableArray alloc] init];
    NSMutableArray* idtl=[[NSMutableArray alloc] init];
    
    [HttpHelper sendGetRequest:@"getPiece/1" parameters:nil success:^(id response){
        NSArray* result=[response jsonString2Dictionary];
        int i=0;
        for (NSDictionary* obj in result) {
            NSString* title=obj[@"sortTitle"];
            [tl addObject:title];
//            if (i==0) {
                [idtl addObject:[self drawTable:obj]];
//            }else{
//                [idtl addObject:[[UITableView alloc] init]];
//            }
            i++;
        }
        
        SVTopScrollView *topScrollView = [SVTopScrollView shareInstance];
        topScrollView.deleg=self;
        SVRootScrollView *rootScrollView = [SVRootScrollView shareInstance];
        
        topScrollView.nameArray = tl;
        rootScrollView.viewNameArray = idtl;
        
        [self.view addSubview:topScrollView];
        [self.view addSubview:rootScrollView];

        [topScrollView initWithNameButtons];
        [rootScrollView initWithViews];
    } fail:^{
        
    } parentView:self.view];
    

   

}


#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
//    // 1.添加假数据
//    for (int i = 0; i<5; i++) {
//        [self.fakeData insertObject:MJRandomData atIndex:0];
//    }
    
 
}

- (SWExploreEntranceDataProvider *)dataProvider:(UITableView*)content
{
//    if (_dataProvider == nil) {
        _dataProvider = [SWExploreEntranceDataProvider new];
        _dataProvider.targetTable = content;//self.contentView;
        _dataProvider.vc = self;
        _dataProvider.delegate=self;
//    }
    return _dataProvider;
}



//#pragma mark ZYCScrollableToolbarDelegate
//- (void)scrollableToolbar:(ZYCScrollableToolbar *)toolbar didSelecedAtIndex:(NSInteger)index
//{
////    NSLog(@"clicked title at index:%d with name:%@", index, [_titleList objectAtIndex:index]);
////
//    
//    NSDictionary *pieceInfo = [_titleList objectAtIndex:index];
//    _curIndex=index;
//    NSString *pieceID = pieceInfo[@"id"];
//    
//    NSString *pieceImageURL = pieceInfo[@"sortUrl"];
//#warning 自动刷新(一进入程序就下拉刷新)
//    [_contentView headerBeginRefreshing];
//    
////    [_dataProvider reloadDataWithPieceID:pieceID pieceImageUrl:pieceImageURL pageNum:0 last:^{
////        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
////        [_contentView headerEndRefreshing];
////    }];
//
//}


#pragma mark UITableViewDelegate

#pragma mark SWExploreEntranceDataProviderDelegate


- (void)itemBigImageDidClicked:(NSDictionary *)itemInfo
{
    [self presentViewController:nil animated:NO completion:^{
        UIView *transitionView = [self.view viewWithTag:kWDTransitionViewTag];
        if (transitionView) {
            [transitionView removeFromSuperview];
        }
    }];
}


@end
