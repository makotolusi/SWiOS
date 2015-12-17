//
//  DetailPageController.m
//  SWiOS
//
//  Created by 陆思 on 15/11/1.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "DetailPageController.h"
#import "LoadingView.h"
#import "MPview.h"
#import "UILabel+Extension.h"
#import "YCAsyncImageView.h"
#import "ShoppingCartController.h"
#import "UIAlertView+Extension.h"
#import "UIWindow+Extension.h"
#import "ShoppingCartLocalDataManager.h"
@interface DetailPageController ()<UIWebViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong)UIView* infoView;
@property (nonatomic,strong)UIView* modal;
@property (nonatomic,strong)MPview* mp;
@end

@implementation DetailPageController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [UIWindow showTabBar:NO];
    _cartModel=[ShoppingCartModel sharedInstance];
    _webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT-100)];
    NSString *url=[@"http://okeasy.eicp.net:9888/index.html#/Product/" stringByAppendingString:_product.productCode];
    _webView.delegate=self;
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString: url]];
    [self.webView loadRequest:request];
    
    [self.view addSubview:_webView];
    //button
    UIButton *buy=[[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - kSWTabBarViewHeight, SCREEN_WIDTH, kSWTabBarViewHeight)];
    buy.backgroundColor = UIColorFromRGB(0x1abc9c);
    buy.alpha=0.7f;
    [buy setTitle:@"加入购物车" forState:UIControlStateNormal];
    [buy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buy addTarget:self action:@selector(shoppingCart:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buy];
}

-(void)shoppingCart:(id)sender{
    float w=300;
    float h=200;
     _modal=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _modal.backgroundColor=[UIColor lightGrayColor];
    _modal.alpha=0.5;
      [self.view addSubview:_modal];
     _infoView=[[UIView alloc]init];
    _infoView.backgroundColor=[UIColor whiteColor];
    _infoView.layer.borderWidth=1;
    _infoView.alpha=1.0;
    _infoView.layer.borderColor=[UIColorFromRGB(0x1abc9c)CGColor];
      [_infoView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
     float bw=250,bh=30;
    _mp=[[MPview alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-bw/2, _infoView.frame.size.height-200, bw, bh) gap:230 ];
    _mp.product=_product;
    [_infoView addSubview:_mp];
    UIButton *cartBtn=[[UIButton alloc] initWithFrame:CGRectMake(_mp.frame.origin.x,_mp.frame.origin.y+50, bw, bh)];
    [cartBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
    [cartBtn addTarget:self action:@selector(cartAction:) forControlEvents:UIControlEventTouchUpInside];
    [cartBtn.layer setCornerRadius:10.0]; //设置矩形四个圆角半径
    [ cartBtn.titleLabel smallLabel];
    cartBtn.backgroundColor=UIColorFromRGB(0x1abc9c);
    [_infoView addSubview:cartBtn];
    //image
    float imgW=60.f;
    YCAsyncImageView *image=[[YCAsyncImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-60/2, _infoView.frame.origin.x+100, imgW, imgW)];
    [image setUrl:_product.picUrl1];
    [_infoView addSubview:image];
    //title
    UILabel *title=[[UILabel alloc] init];
    title.lineBreakMode =NSLineBreakByWordWrapping;
    title.numberOfLines = 2;
    title.textAlignment=NSTextAlignmentLeft;
    title.text=_product.productName;
    title.font=[UIFont systemFontOfSize:13];
    CGSize size = [title sizeThatFits:CGSizeMake(200, MAXFLOAT)];
    title.frame=CGRectMake(SCREEN_WIDTH/2-size.width/2, image.frame.origin.y+60, 200, size.height);
    [_infoView addSubview:title];
//     [_modal addSubview:_infoView ];
    [self.view insertSubview:_infoView aboveSubview:_modal];
    //animation
    [UIView animateWithDuration:0.0
                          delay:0.0
                        options:0
                     animations:^{
                        
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.2
                                               delay:0.0
                                             options:UIViewAnimationOptionShowHideTransitionViews
                                          animations:^{
                                              [_infoView setFrame:CGRectMake(SCREEN_WIDTH/2-w/2, SCREEN_HEIGHT-h-100 ,w, h)];
                                              [image setFrame:CGRectMake(_infoView.frame.size.width/2-imgW/2, 15, imgW, imgW)];
                                              [title setFrame:CGRectMake(_infoView.frame.size.width/2-size.width/2, image.frame.origin.y+imgW+5, size.width, size.height)];
                                              [_mp setFrame:CGRectMake(_infoView.frame.size.width/2-bw/2, title.frame.origin.y+35, bw, bh)];
                                              [cartBtn setFrame:CGRectMake(_infoView.frame.size.width/2-bw/2, _mp.frame.origin.y+40, bw, bh)];
                                              UIImageView *cha=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cha"]];
                                              [cha setFrame:CGRectMake(_infoView.frame.origin.x+_infoView.frame.size.width-30, 5, 20, 20)];
                                              [_infoView addSubview:cha];
                                              UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesturedDetected:)]; // 手势类型随你喜欢。
                                              cha.userInteractionEnabled = YES;
                                              tapGesture.delegate = self;
                                              [cha addGestureRecognizer:tapGesture];
                                          }
                                          completion:^(BOOL finished) {
                                          }];
                     }];

}

- (void)tapGesturedDetected:(UITapGestureRecognizer *)recognizer
{
    [_infoView removeFromSuperview];
      [_modal removeFromSuperview];
    // do something
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
//    [LoadingView initWithFrame:CGRectMake(0,SCREEN_HEIGHT/2 , 50, 50) parentView:nil];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
//    [LoadingView stopAnimating:nil];
}

- (void)cartAction:(UIButton*)sender {
    if ( [ShoppingCartModel add2CartWithProduct:_product buyCount:_mp.count]) {  
        ShoppingCartController *vc =[[ShoppingCartController alloc]init];
        vc.navigationItem.titleView = [UILabel navTitleLabel:@"购物车"];
        UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc]
                                         initWithTitle:@""
                                         style:UIBarButtonItemStylePlain
                                         target:self
                                         action:nil];
        self.navigationItem.backBarButtonItem = cancelButton;
        [self.navigationController pushViewController:vc animated:YES];
        
        [_infoView removeFromSuperview];
        [_modal removeFromSuperview];
    }

//    }
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
