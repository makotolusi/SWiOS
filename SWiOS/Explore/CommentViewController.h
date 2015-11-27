//
//  CommentViewController.h
//  SWiOS
//
//  Created by 陆思 on 15/11/20.
//  Copyright © 2015年 com.itangxueqiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PWLoadMoreTableFooterView.h"
@interface CommentViewController : UIViewController

{
    PWLoadMoreTableFooterView *_loadMoreFooterView;
    BOOL _datasourceIsLoading;
    bool _allLoaded;
@private
    UITableView    *_tableView;
    NSDictionary* pagingData;
    NSMutableArray *_data;
    
}
@property(strong,nonatomic) UITextView *textView;
@property(strong,nonatomic) UIView* inputView;
@property(copy,nonatomic) NSString* productCode;

@end
