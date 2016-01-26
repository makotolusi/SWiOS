//
//  ViewController.m
//  GHWalk
//
//  Created by 李乐 on 15/8/29.
//  Copyright (c) 2015年 李乐. All rights reserved.
//

#import "SWIntroductionViewController.h"
#import "RegisterViewController.h"

static NSString* const s1 = @"1";
static NSString* const s2 = @"2";
static NSString* const s3 = @"3";
static NSString* const s4 = @"4";
static NSString* const s5 = @"5";

@interface SWIntroductionViewController ()<GHWalkThroughViewDataSource,GHWalkThroughViewDelegate>

@property(nonatomic,strong)GHWalkThroughView* ghView;
@property(nonatomic,strong)NSArray* descStrings;
@end

@implementation SWIntroductionViewController

-(void)viewWillAppear:(BOOL)animated{
    self.pageName=@"SWIntroductionViewController";
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self _initGHWalkUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)_initGHWalkUI{
    
    _ghView = [[GHWalkThroughView alloc]initWithFrame:self.view.bounds];
    [_ghView setDataSource:self];
    [_ghView setWalkThroughDirection:GHWalkThroughViewDirectionHorizontal];
    
    self.descStrings = [NSArray arrayWithObjects:s1,s2,s3,s4,s5, nil];
    _ghView.delegate = self;
    
    [self.ghView showInView:self.view animateDuration:0.3];
    
}

#pragma GHDataSource
-(NSInteger) numberOfPages{
    return 5;
}

-(void) configurePage:(GHWalkThroughPageCell*) cell atIndex:(NSInteger) index{
    cell.title = [NSString stringWithFormat:@"this is page %ld",index+1];
    cell.titleImage = [UIImage imageNamed:[NSString stringWithFormat:@"title%ld",index +1]];
    cell.desc = [self.descStrings objectAtIndex:index];
}

- (UIImage*) bgImageforPage:(NSInteger) index{
    NSString* imageName = [NSString stringWithFormat:@"bg_0%ld.jpg",index+1];
    UIImage* image = [UIImage imageNamed:imageName];
    return image;
}

#pragma GHWalkThroughViewDelegate
- (void)walkthroughDidDismissView:(GHWalkThroughView *)walkthroughView{
    NSLog(@"ViewControll DismissView");
    RegisterViewController * mvc = [[RegisterViewController alloc]init];
    
    [self presentViewController:mvc animated:YES completion:nil];
}

@end


