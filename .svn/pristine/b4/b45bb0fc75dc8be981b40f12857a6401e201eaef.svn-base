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


NSInteger kWDTransitionViewTag = 33331;

@interface SWExploreEntranceViewController () <ZYCScrollableToolbarDelegate>

@property (nonatomic, strong) SWExploreNaviDelegate *naviDelegate;

@property (nonatomic, strong) UITableView *contentView;

@property (nonatomic, strong) ZYCScrollableToolbar *scrollableToolbar;

@property (nonatomic, strong) SWExploreEntranceDataProvider *dataProvider;

@property (nonatomic, strong) NSMutableArray *titleList;

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
    [self p_mockData];
    
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
    [super viewWillAppear:animated];
    
    [self.view bringSubviewToFront:_scrollableToolbar];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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
        
        
        // refresh toolbar titles with data fetched from api server
        dispatch_async(dispatch_get_main_queue(), ^{
            NSArray *strongRefList = titlesStrList;
            [_scrollableToolbar updateWithTitles:strongRefList];
            strongRefList = nil;
        });

    } failure:^(SWHttpRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)p_mockData
{
    [_titleList addObjectsFromArray:@[@"   香港",@"美国",@"韩国",@"日本",@"法国",@"台湾",@"泰国",@"新加坡",@"德国",@"登录",@"美国",@"韩国",@"日本",@"美国",@"韩国",@"日本",@"美国",@"韩国",@"日本",]];
}

- (void)drawViews
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    const CGFloat toolbarHeight = 50;
    
    self.scrollableToolbar = [[ZYCScrollableToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, toolbarHeight) titles:_titleList];
    
    _scrollableToolbar.toolbarDelegate = self;
    _scrollableToolbar.backgroundColor = [UIColor whiteColor];
//    _scrollableToolbar.backgroundColor = [UIColor greenColor];
//    _scrollableToolbar.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
    
//    [self.view addSubview:_scrollableToolbar];
    
    self.contentView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                     toolbarHeight,
                                                                     SCREEN_WIDTH,
                                                                     CGRectGetHeight(self.view.bounds) - toolbarHeight)
                                                    style:UITableViewStylePlain];
    
    _contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _contentView.delegate = [self dataProvider];
    _contentView.dataSource = _dataProvider;
    _contentView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_contentView];
    
    [self.view addSubview:_scrollableToolbar];
}

- (SWExploreEntranceDataProvider *)dataProvider
{
    if (_dataProvider == nil) {
        _dataProvider = [SWExploreEntranceDataProvider new];
        _dataProvider.targetTable = self.contentView;
        _dataProvider.vc = self;
    }
    return _dataProvider;
}


#pragma mark ZYCScrollableToolbarDelegate
- (void)scrollableToolbar:(ZYCScrollableToolbar *)toolbar didSelecedAtIndex:(NSInteger)index
{
//    NSLog(@"clicked title at index:%d with name:%@", index, [_titleList objectAtIndex:index]);
//
    
    NSDictionary *pieceInfo = [_titleList objectAtIndex:index];
    NSString *pieceID = pieceInfo[@"id"];
    
    NSString *pieceImageURL = pieceInfo[@"sortUrl"];
    
    [_dataProvider reloadDataWithPieceID:pieceID pieceImageUrl:pieceImageURL pageNum:0];

}


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
