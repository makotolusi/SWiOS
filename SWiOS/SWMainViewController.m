//
//  SWMainViewController.m
//  SWiOS
//
//  Created by YuchenZhang on 7/19/15.
//  Copyright (c) 2015 com.itangxueqiu. All rights reserved.
//

#import "SWMainViewController.h"
#import "SWExploreEntranceViewController.h"
#import "SWBuyBuyBuyViewController.h"
#import "SWMeTableViewController.h"
#import "ShoppingCartController.h"
static CGFloat kSWTabBarViewHeight = 66;

static CGFloat kSWCurrentShowingViewTag = 12333;

@interface SWTabBarView ()

@property (nonatomic, weak)id selfTarget;

@property (nonatomic, strong) NSArray *buttons;

@end

@implementation SWTabBarView

- (instancetype)initWithFrame:(CGRect)frame
                      buttons:(NSArray *)buttons
                       target:(id)target
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(0x1abc9c);
        self.selfTarget = target;
        self.buttons = buttons;
    
    }
    return self;
}

- (void)setButtons:(NSArray *)buttons
{
    if (_buttons != buttons) {
        _buttons = buttons;
        [self p_layoutButtons];
    }
}

#pragma mark for buttons layout
- (void)p_layoutButtons
{
    CGFloat bWidth = self.bounds.size.width / _buttons.count;
    __block CGFloat startX = 0;
    [_buttons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *b = obj;
        if (b.superview == nil || b.superview != self) {
            [self addSubview:b];
        }
        b.frame = CGRectMake(startX, 0, bWidth, self.bounds.size.height);
        b.tag = idx;
        b.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [b setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        startX += bWidth;
        
    }];
}


@end

@interface SWMainViewController ()

@property (nonatomic, strong)UIView *contentView;

@end

@implementation SWMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self p_initUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (instancetype)initWithViewControllers:(NSArray *)controllers
{
    self = [super init];
    if (self) {
        [self initWithoutControlls];
    }
    return self;
}
- (void)initWithoutControlls{

    SWExploreEntranceViewController* ex = [[SWExploreEntranceViewController alloc] init];
    SWBuyBuyBuyViewController* buy = [[SWBuyBuyBuyViewController alloc] init];
    ShoppingCartController *cart=[[ShoppingCartController alloc] init];
    SWMeTableViewController* me = [[SWMeTableViewController alloc] init];

    ex.title = @"探索";
    buy.title = @"抢抢抢";
    cart.title=@"购物车";
    me.title = @"我";

    UINavigationController* nav1 = [[UINavigationController alloc] initWithRootViewController:ex];

    UINavigationController* nav2 = [[UINavigationController alloc] initWithRootViewController:buy];

      UINavigationController* nav3 = [[UINavigationController alloc] initWithRootViewController:cart];
    
    UINavigationController* nav4 = [[UINavigationController alloc] initWithRootViewController:me];

    NSArray* views = @[ nav1, nav2, nav3, nav4 ];
    self.viewControlers = [views mutableCopy];
}
- (void)p_initUI
{
    self.view.backgroundColor = DEFAULT_BG_COLOR;
    
    
    NSMutableArray *buttons = [NSMutableArray arrayWithCapacity:_viewControlers.count];
    
    [_viewControlers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIViewController *vc = obj;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self
                   action:@selector(tabClicked:atIndex:)
         forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:vc.title forState:UIControlStateNormal];
        [buttons insertObject:button atIndex:idx];
        
        
    }];
    
    // tab bar
    _tabBarView = [[SWTabBarView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kSWTabBarViewHeight)
                                              buttons:[buttons copy]
                                               target:self];
    
    _tabBarView.center = CGPointMake(_tabBarView.frame.size.width / 2,
                                     
                                     self.view.bounds.size.height - kSWTabBarViewHeight / 2);
    
    
    
    [self.view addSubview:[self contentView]];
    
    [self p_showController:[_viewControlers firstObject]];
    //_tabBarView.hidden=YES;
 
    [self.view addSubview:_tabBarView];
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hehe) name:@"11" object:nil];
  
//    [_tabBarView addConstraint:nil];
    
}


- (UIView *)contentView
{
    if (_contentView == nil) {
//        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-kSWTabBarViewHeight)];
           _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

- (void)p_showController:(UIViewController *)vc
{
    UIView *targetView = vc.view;
 
    targetView.tag = kSWCurrentShowingViewTag;
    
    UIView *contentView = [self contentView];
    
    UIView *oldShowingView = [contentView viewWithTag:kSWCurrentShowingViewTag];
    
    if (oldShowingView) {
        UIViewController *vc = (UIViewController *)[oldShowingView nextResponder];
        [vc willMoveToParentViewController:nil];
        [oldShowingView removeFromSuperview];
        [vc removeFromParentViewController];
    }
    
    
    [vc viewWillAppear:NO];
    
    CGRect newFrame = _contentView.bounds;
    
    targetView.frame = newFrame;
    
    [contentView addSubview:targetView];
    [vc didMoveToParentViewController:self];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)tabClicked:(UIButton *)button
           atIndex:(NSInteger)index
{
    UIViewController *shouldShowVc = [_viewControlers objectAtIndex:button.tag];
    
    
    if (button.tag==1) {
        
         NSLog(@" buy buy buy ");
        
    }
//    if([shouldShowVc isKindOfClass:[SWBuyBuyBuyViewController class]]){
//       
//    }
    [self p_showController:shouldShowVc];
}

@end
