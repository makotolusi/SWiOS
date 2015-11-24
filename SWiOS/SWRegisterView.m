//
//  SWRegisterView.m
//  GHWalk
//
//  Created by 李乐 on 15/8/29.
//  Copyright (c) 2015年 李乐. All rights reserved.
//

#import "SWRegisterView.h"
#import "NSString+Extension.h"
#import "Activate.h"
#import "RegisterModel.h"
#import "HttpHelper.h"
#import "SWMainViewController.h"
#import "ShoppingCartModel.h"
#import "SMMessageXSend.h"
#define   WIN_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define   WIN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define SET_PLACE(text) [text  setValue:[UIFont boldSystemFontOfSize:(13)] forKeyPath:@"_placeholderLabel.font"];
#define COLOR_BLUE_LOGIN [UIColor colorWithRed:78/255.0 green:198/255.0 blue:56/255.0 alpha:1];
#define   FONT(size)  ([UIFont systemFontOfSize:size])


@interface SWRegisterView(){
    
    UIButton* registerCodeButton;
    UIButton* nextButton;
    UITextField *phoneText;
    UITextField *passText;
    BOOL _isTime;
    NSTimer *_timer;
    int timecount;
}


@end

@implementation SWRegisterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]) {
        [self _initialze];
    }
    return self;
}
- (void)_initialze{
    
    CGFloat offsetX = 0;
    
    self.backgroundColor = [UIColor whiteColor];
    
    
    // cell phone num
    phoneText = [[UITextField alloc] initWithFrame:CGRectMake(offsetX+30, 30, WIN_WIDTH-60, 30)];
    phoneText.placeholder = @"请输入要注册的手机号码";
    SET_PLACE(phoneText);
    phoneText.tag = 501;
    [self addSubview:phoneText];
    
    //icon
    UIImageView *phoneIcon = [[UIImageView alloc] initWithFrame:CGRectMake(offsetX, 0, 25, 25)];
    phoneIcon.image = [UIImage imageNamed:@"label_phone.png"];
    phoneText.leftView = phoneIcon;
    phoneText.leftViewMode = UITextFieldViewModeAlways;
    
    // line
    UIImageView *accImage = [[UIImageView alloc] initWithFrame:CGRectMake(offsetX+28, 65, WIN_WIDTH-56, 2)];
    
    accImage.image = [UIImage imageNamed:@"textfield_default_holo_light.9.png"];
    [self addSubview:accImage];
    
    // pw
    passText = [[UITextField alloc] initWithFrame:CGRectMake(offsetX+30, 80, WIN_WIDTH-60, 30)];
    [self addSubview:passText];
    passText.placeholder = @"请输入获取到的验证码";
    SET_PLACE(passText);
    passText.tag = 201;
    
    
    // line
    UIImageView *passImage = [[UIImageView alloc] initWithFrame:CGRectMake(offsetX+28, 115, WIN_WIDTH-56, 2)];
    [self addSubview:passImage];
    passImage.image = [UIImage imageNamed:@"textfield_default_holo_light.9.png"];
    
    // registerBtn
    registerCodeButton =  [UIButton buttonWithType:0];
    registerCodeButton.frame = CGRectMake(WIN_WIDTH-130, 80, 100, 25);
    [registerCodeButton setTitle:@"获取验证码" forState:0];
    registerCodeButton.backgroundColor = COLOR_BLUE_LOGIN;
    registerCodeButton.clipsToBounds = YES;
    registerCodeButton.layer.cornerRadius = 5.0f;
    [registerCodeButton addTarget:self action:@selector(registerCodeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    registerCodeButton.titleLabel.font = FONT(13);
    [self addSubview:registerCodeButton];
    [self bringSubviewToFront:registerCodeButton];
    
    // next
    nextButton = [UIButton buttonWithType:0];
    nextButton.frame = CGRectMake(offsetX+30, 140, WIN_WIDTH-60, 35);
    [nextButton setTitle:@"下一步" forState:0];
    nextButton.backgroundColor = COLOR_BLUE_LOGIN;
    [self addSubview:nextButton];
    nextButton.clipsToBounds = YES;
    nextButton.layer.cornerRadius = 5.0f;
    [nextButton addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    
}

-(void)registerCodeButtonClick{
//    SMMessageXSend * submail = [[SMMessageXSend alloc] init];
//    
//    [submail.aryTo addObject:@"18616761881"];
//    submail.project = @"kZ9Ky3";
//    [submail.dictVar setValue:@"198276" forKey:@"code"];
//    
//    [submail xSend:^(BOOL success, id responseObject) {
//        // your code
//    }];
    
    timecount = 60;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    [NSTimer scheduledTimerWithTimeInterval:timecount target:self selector:@selector(time) userInfo:nil repeats:NO];
    registerCodeButton.backgroundColor = [UIColor grayColor];
    registerCodeButton.userInteractionEnabled = NO;
    _isTime = YES;
    [NSTimer scheduledTimerWithTimeInterval:timecount target:self selector:@selector(endTime) userInfo:nil repeats:NO];
}

-(void)showMessage:(NSString *)message{
    
    [[[UIAlertView alloc] initWithTitle:message message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil] show];
    
}
-(void)nextButtonClick{
    if(StringIsNullOrEmpty(phoneText.text)){
        [self showMessage:@"请输入电话号码"];
        return;
    }
    if(StringIsNullOrEmpty(passText.text)){
        [self showMessage:@"请输入验证码"];
        return;
    }
    if(![NSString validateMobile:phoneText.text]){
        [self showMessage:@"输入电话号码有误"];
        return;
    }
//    RegisterModel *rm=[RegisterModel sharedInstance];
        if([@"2222" isEqualToString:passText.text]){
            //activate
            Activate *act= [[Activate alloc]init];
            if([act Notactivated]){
                [act sendActiveRequest:^(){
                    //register
                    [self login];
                }];
            }else{
                [self login];
            }
        
                    }else{
             [self showMessage:@"验证码错误"];
                    }
    
}

-(void)login{
    [HttpHelper sendGetRequest:@"CommerceUserServices/login"
                    parameters: @{@"phoneNum":phoneText.text}
                       success:^(id response) {
                           NSDictionary* result=[response jsonString2Dictionary];
                           BOOL success=[result valueForKey:@"success"];
                           if(success){
                               NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                               
                               [defaults setObject:phoneText.text forKey:USER_LOGIN_PHONE_NUM];
                               
                               //load user info
                               ShoppingCartModel *cart=[ShoppingCartModel sharedInstance];
                               [HttpHelper sendPostRequest:@"getUserByToken"
                                                parameters: [[NSDictionary alloc]init]
                                                   success:^(id response) {
                                                       NSDictionary* result=[response jsonString2Dictionary];
                                                       BOOL success=[result valueForKey:@"success"];
                                                       if(success){
                                                               RegisterModel  *userinfo1 = [[RegisterModel alloc] initWithString:result[@"data"] error:nil];
                                                               cart.registerModel=userinfo1;
                                                               NSLog(@"获取到的数据为dict：%@", userinfo1);

                                                               
                                                               [NSThread sleepForTimeInterval:3.0];
                                                               
                                                           //close
                                                           [UIView animateWithDuration:0.3 animations:^{
                                                               self.alpha = 0;
                                                           } completion:^(BOOL finished){
                                                               dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)0);
                                                               dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                                                   [self removeFromSuperview];
                                                                   if (self.delegate != nil && [self.delegate respondsToSelector:@selector(registerDidDismissView:)]) {
                                                                       [self.delegate registerDidDismissView:self];
                                                                   }
                                                               });
                                                           }];

                                                       }
                                                   } fail:^{
                                                       //                            [UIAlertView showMessage:@"取得用户注册信息失败"];
                                                       NSLog(@"请求失败");
                                                   } parentView:self];
                             
                           }
                       }fail:^{
                           NSLog(@"网络异常，取数据异常");
                       }];


}
- (void)timerFired
{
    [registerCodeButton setTitle:[NSString stringWithFormat:@"(%ds)重新获取",timecount--] forState:0];
    if (timecount==1||timecount<1) {
        [_timer invalidate];
        [registerCodeButton setTitle:@"获取验证码" forState:0];
    }
}
- (void)time
{
    registerCodeButton.backgroundColor = COLOR_BLUE_LOGIN;
    registerCodeButton.userInteractionEnabled = YES;
}
- (void)endTime
{
    _isTime = NO;//
}


@end
