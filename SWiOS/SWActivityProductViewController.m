//
//  SWActivityProductViewController.m
//  SWiOS
//
//  Created by 陆思 on 15/10/4.
//  Copyright (c) 2015年 com.itangxueqiu. All rights reserved.
//

#import "SWActivityProductViewController.h"
#import "HttpHelper.h"
#import "ActivityProduct.h"
#import "ActivityProductCell.h"
#import "SWBuyBuyBuyViewController.h"
#import "JSBadgeView.h"
#import "ShoppingCartController.h"
#define kCCell_Img			1
#define kCCell_Button		4
static NSString *activityProductCellIdentifier = @"activityProductCellIdentifier";
@interface SWActivityProductViewController ()

@end

@implementation SWActivityProductViewController
-(void)viewDidAppear:(BOOL)animated{
    
}
- (void)viewDidLoad {
   
    [super viewDidLoad];
    [HttpHelper sendGetRequest:[@"getActivityProcut/" stringByAppendingFormat:@"%@",_activity._id]
                    parameters: @{}
                       success:^(id response) {
                           NSData* data = [response dataUsingEncoding:NSUTF8StringEncoding];
//                           NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                           NSArray *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                           NSLog(@"获取到的数据为dict：%@", _data);
                           // 构造数组(MRC:以下情况会出问题，ARC)
                           _data = [NSMutableArray array];
                           
                           // 设置数据模型
                           for (id content in result) {
                               ActivityProduct *model = [[ActivityProduct alloc] init];
                               [model setValuesForKeysWithDictionary:content];
                               [_data addObject:model];
                           }
                           [self _loadContentView];
                       } fail:^{
                           NSLog(@"网络异常，取数据异常");
                       }];
    // 如果数据从网络中来，那么就需要刷新表视图
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_loadContentView {
    self.arOfWatchesOfCart = [NSMutableArray array];
    // 创建表视图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT)];
    _tableView.contentInset = UIEdgeInsetsMake(64.f, 0.f, 49.f, 0.f);
    _tableView.rowHeight = 134.f;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerNib:[UINib nibWithNibName:@"ActivityProductCell" bundle:nil] forCellReuseIdentifier:activityProductCellIdentifier];
    [self.view addSubview:_tableView];
    //shopping cart
    UIView  *barView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 66, SCREEN_WIDTH, 66)];
    barView.backgroundColor = UIColorFromRGB(0x1abc9c);
    barView.center = CGPointMake(barView.frame.size.width / 2,SCREEN_HEIGHT - 66 / 2);
    //cart home image view
    bottomImageView=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 60, 60)];
    bottomImageView.image=[UIImage imageNamed:@"cart_home"];

    [barView addSubview:bottomImageView];
    //price label
    UILabel *priceLabel=[[UILabel alloc] initWithFrame:CGRectMake(bottomImageView.frame.size.width+20, 20, 200, 30)];
    priceLabel.textColor=[UIColor whiteColor];
    priceLabel.text=@"¥ 15000";
    priceLabel.font=[UIFont boldSystemFontOfSize:20];
    [barView addSubview:priceLabel];
    //buy label
    UIButton *bottomLabel=[[UIButton alloc] initWithFrame:CGRectMake(barView.frame.size.width-80, 20, 65, 34)];
//    bottomLabel.titleLabel.text=@"请选购";
//    bottomLabel.titleLabel.textColor=[UIColor whiteColor];
//    bottomLabel.titleLabel.textAlignment=NSTextAlignmentCenter;
//    bottomLabel.titleLabel.font=[UIFont boldSystemFontOfSize:15];
    [bottomLabel setTitle:@"请选购" forState:UIControlStateNormal];
    bottomLabel.backgroundColor=UIColorFromRGB(0x1abc9c);
    bottomLabel.layer.masksToBounds=YES;
    bottomLabel.layer.cornerRadius=6;
    bottomLabel.layer.borderWidth=2;
    bottomLabel.layer.borderColor=[[UIColor whiteColor] CGColor];
  [bottomLabel addTarget:self action:@selector(bottomLabelClick) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:bottomLabel];
    [self.view addSubview:barView];
    //    [self.view bringSubviewToFront:barView];
    //    self.automaticallyAdjustsScrollViewInsets = NO;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_data count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    ActivityProductCell *cell=[tableView dequeueReusableCellWithIdentifier:activityProductCellIdentifier forIndexPath:indexPath ];
    UIButton *btn = (UIButton*)[cell viewWithTag:kCCell_Button];
    [btn addTarget:self action:@selector(CartTapped:) forControlEvents:UIControlEventTouchUpInside];
    cell.activityProduct=_data[indexPath.row];
//    ActivityProduct *model = [_data objectAtIndex:indexPath.row];
    btn.selected=[self.arOfWatchesOfCart containsObject:cell.activityProduct];
    // set the index of row into disabled property of button - as a trick. so we can access row-number on button tap.
    [btn setTitle:[NSString stringWithFormat:@"%li",(long)indexPath.row] forState:UIControlStateDisabled];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
}

- (void)CartTapped:(UIButton*)sender {
    // access the row number using the used trick
    NSUInteger index = [[sender titleForState:UIControlStateDisabled] integerValue];
    // obtain the object to be removed/added into cart array
    ActivityProduct *model = _data[index];
    // create indexpath
    NSIndexPath *ip = [NSIndexPath indexPathForRow:index inSection:0];
    
    // perform action
    if(sender.selected) {
        // remove selected array
        [self.arOfWatchesOfCart removeObject:model];
        // update badge number
        [self reloadBadgeNumber];
    } else {
        //badgeView
            JSBadgeView *badgeView = [[JSBadgeView alloc] initWithParentView:bottomImageView alignment:JSBadgeViewAlignmentBuyBuyBuy];
            badgeView.badgeText = [NSString stringWithFormat:@"%lu", (unsigned long)[_arOfWatchesOfCart count]+1];
        // add into selected array
        [self.arOfWatchesOfCart addObject:model];
        // perform add to cart animation
        [self addToCartTapped:ip];
    }
    // reload specific row with animation
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:ip] withRowAnimation:UITableViewRowAnimationMiddle];
}

- (void)addToCartTapped:(NSIndexPath*)indexPath {
    // grab the cell using indexpath
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    // grab the imageview using cell
    UIImageView *imgV = (UIImageView*)[cell viewWithTag:kCCell_Img];
    
    // get the exact location of image
    CGRect rect = [imgV.superview convertRect:imgV.frame fromView:nil];
    rect = CGRectMake(5, (rect.origin.y*-1)-10, imgV.frame.size.width, imgV.frame.size.height);
    NSLog(@"rect is %f,%f,%f,%f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
    
    // create new duplicate image
    UIImageView *starView = [[UIImageView alloc] initWithImage:imgV.image];
    [starView setFrame:rect];
    starView.layer.cornerRadius=5;
    starView.layer.borderColor=[[UIColor blackColor]CGColor];
    starView.layer.borderWidth=1;
    [self.view addSubview:starView];
    
    // begin ---- apply position animation
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.duration=0.65;
    pathAnimation.delegate=self;
    
    // tab-bar right side item frame-point = end point
    CGPoint endPoint = CGPointMake(90+rect.size.width/2, 520+rect.size.height/2);
    
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGPathMoveToPoint(curvedPath, NULL, starView.frame.origin.x, starView.frame.origin.y);
    CGPathAddCurveToPoint(curvedPath, NULL, endPoint.x, starView.frame.origin.y, endPoint.x, starView.frame.origin.y, endPoint.x, endPoint.y);
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    // end ---- apply position animation
    
    // apply transform animation
    CABasicAnimation *basic=[CABasicAnimation animationWithKeyPath:@"transform"];
    [basic setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.25, 0.25, 0.25)]];
    [basic setAutoreverses:NO];
    [basic setDuration:0.65];
    
    [starView.layer addAnimation:pathAnimation forKey:@"curveAnimation"];
    [starView.layer addAnimation:basic forKey:@"transform"];
    
    [starView performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.65];
    [self performSelector:@selector(reloadBadgeNumber) withObject:nil afterDelay:0.65];
}

// update the Badge number
- (void)reloadBadgeNumber {

    if(self.arOfWatchesOfCart.count) {
//        self.tabItemCart.badgeValue=[NSString stringWithFormat:@"%lu",(unsigned long)self.arOfWatchesOfCart.count];
    } else {
//        self.tabItemCart.badgeValue=nil;
    }
}

-(void)bottomLabelClick
{
    ShoppingCartController *vc =[[ShoppingCartController alloc]init];
    vc.arOfWatchesOfCart=self.arOfWatchesOfCart;
    vc.navigationItem.title=@"购物车";
    UIBarButtonItem* cancelButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@""
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:nil];
    self.navigationItem.backBarButtonItem = cancelButton;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
