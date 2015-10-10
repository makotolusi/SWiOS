//
//  RegisterViewController.m
//  GHWalk
//
//  Created by 李乐 on 15/8/29.
//  Copyright (c) 2015年 李乐. All rights reserved.
//

#import "RegisterViewController.h"
#import "SWRegisterView.h"
#import "SWMainViewController.h"

@interface RegisterViewController ()<SWRegisterViewDelegate>

@property (nonatomic, strong) UIButton* registerButton;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self _initRegisterView];

}

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
-(void)_initRegisterView{
//    _registerView.delegate = self;
    SWRegisterView *view = [[SWRegisterView alloc]initWithFrame:self.view.bounds];
    view.delegate = self;
    [self.view addSubview:view];
    
}

#pragma RegisterViewDelegate
- (void)registerDidDismissView:(SWRegisterView *)registerView{
    
    NSLog(@"RegisterViewController DismissView");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    [defaults setObject:currentVersion forKey:@"last_run_version_of_application"];
    
    SWMainViewController *mainContorll = [[SWMainViewController alloc]initWithViewControllers:nil];
    
    [self presentViewController:mainContorll animated:YES completion:nil];
}

@end
