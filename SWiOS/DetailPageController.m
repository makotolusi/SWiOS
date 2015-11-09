//
//  DetailPageController.m
//  SWiOS
//
//  Created by 陆思 on 15/11/1.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "DetailPageController.h"
#import "LoadingView.h"
@interface DetailPageController ()<UIWebViewDelegate>

@end

@implementation DetailPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    _webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_HEIGHT-100)];
    NSString *url=[@"http://okeasy.eicp.net:9888/index.html#/Product/" stringByAppendingString:_productCode];
    _webView.delegate=self;
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString: url]];
    [self.webView loadRequest:request];
    
    [self.view addSubview:_webView];
    //button
    UIButton *buy=[[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50, SCREEN_WIDTH, 50)];
    buy.backgroundColor = UIColorFromRGB(0x1abc9c);
    buy.alpha=0.7f;
    [buy setTitle:@"加入购物车" forState:UIControlStateNormal];
    [buy setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [buy addTarget:self action:@selector(shoppingCart:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buy];
}

-(void)shoppingCart:(id)sender{

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [LoadingView initWithFrame:CGRectMake(SCREEN_WIDTH/2,SCREEN_HEIGHT/2 , 50, 50) parentView:self.view];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [LoadingView stopAnimating:self.view];
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
