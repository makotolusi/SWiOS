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
#import "Activate.h"
#import "RegisterModel.h"
#import "HttpHelper.h"
#import "NSString+Extension.h"
#import "RegisterViewController.h"
#import "ShoppingCartLocalDataManager.h"
#import "DatabaseManager.h"
UIButton *lastButton;

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
        self.backgroundColor = DEFAULT_BAR_COLOR;
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
        if (startX==0) {
            b.backgroundColor=[UIColor blackColor];
            b.selected=YES;
            lastButton=b;
        }
        
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
    //is activate
    Activate *act= [[Activate alloc]init];
    [act sendActiveRequest:^(){
        //load user info
        ShoppingCartModel *cart=[ShoppingCartModel sharedInstance];
        [HttpHelper sendPostRequest:@"getUserByToken"
                         parameters: [[NSDictionary alloc]init]
                            success:^(id response) {
                                NSDictionary* result=[response jsonString2Dictionary];
                                BOOL success=[result valueForKey:@"success"];
                                NSDictionary* attr=[result valueForKey:@"attr"];
                                if(success){
                                    if ([attr[@"code"] isEqualToString:@"001"]) {// login
                                        RegisterViewController * mvc = [[RegisterViewController alloc]init];
                                        UIWindow * window = [[UIApplication sharedApplication] keyWindow];
                                        window.rootViewController = mvc;
                                    } else{ //entrance
                                        RegisterModel  *userinfo1 = [[RegisterModel alloc] initWithString:result[@"data"] error:nil];
                                        cart.registerModel=userinfo1;
                                        [ShoppingCartModel loadAddressModel];
                                        NSLog(@"获取到的数据为dict：%@", userinfo1);
                                       cart.arOfWatchesOfCart=[ShoppingCartLocalDataManager getAllShoppingCart];
                                       OrderModel* order= [ShoppingCartLocalDataManager getAllOrderModel];
                                        if (order) {
                                            cart.orderModel=order;
                                        }
                                        
                                      DatabaseManager *databaseManager=[DatabaseManager sharedDatabaseManager];
                                        NSArray *array=databaseManager.getAllAddress;
                                        if (array==nil||array.count==0) {
                                            [databaseManager insertAddress:cart.addressModel];
                                        }
                                        
                                          [self p_initUI];
                                            
                                    }
                                }
                            } fail:^{
                                //                            [UIAlertView showMessage:@"取得用户注册信息失败"];
                                NSLog(@"请求失败");
                            }];
    }];
  
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
    cart.fromMain=YES;
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
        button.tag=idx;
        [button addTarget:self
                   action:@selector(tabClicked:atIndex:)
         forControlEvents:UIControlEventTouchUpInside];
//        [button setTitle:vc.title forState:UIControlStateNormal];
        NSString* imgName=@"";
        switch (idx) {
            case 0:
                imgName=icon_sousuo;
                break;
            case 1:
                imgName=icon_qiang;
                break;
            case 2:
                imgName=icon_gouwuche;
                break;
            case 3:
                imgName=icon_yonghu;
                break;
            default:
                break;
        }
        [button setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
         [button setImage:[UIImage imageNamed:[imgName stringByAppendingString:@"-light"]] forState:UIControlStateSelected];
        float s=SCREEN_WIDTH/4;
        [button setImageEdgeInsets:UIEdgeInsetsMake(kSWTabBarViewHeight/5,s/3,kSWTabBarViewHeight/5,s/3)];
//        button.imageView.image=;
//        float s=kSWTabBarViewHeight/2+5;
//        button.imageView.frame=CGRectMake(SCREEN_WIDTH/4/2-s/2, kSWTabBarViewHeight/2-s/2,s, s);
        
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
        UIView * sv=[oldShowingView superview];
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
    button.backgroundColor=[UIColor blackColor];
    button.selected=YES;
    
    if (button.tag!=lastButton.tag) {
        lastButton.backgroundColor=DEFAULT_BAR_COLOR;
        lastButton.selected=NO;
        lastButton=button;

        
    }
//    if([shouldShowVc isKindOfClass:[SWBuyBuyBuyViewController class]]){
//       
//    }
    [self p_showController:shouldShowVc];
}

@end
