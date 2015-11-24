//
//  CommentViewCell.h
//  SWiOS
//
//  Created by 陆思 on 15/11/21.
//  Copyright © 2015年 com.itangxueqiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"
#import "YCAsyncImageView.h"
#import "EmptyCell.h"
@interface CommentViewCell : EmptyCell


@property (weak, nonatomic) IBOutlet UILabel *username;



@property (strong, nonatomic) UILabel *commentLabel;
@property(assign,nonatomic) CGSize commentLabelSize;

@property(strong,nonatomic) CommentModel* commentM;
@end
