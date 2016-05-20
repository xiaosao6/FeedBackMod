//
//  FeedBackFormView.h
//  FeedBackMod
//
//  Created by sischen on 16/5/14.
//  Copyright (c) 2016年 neo6. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedBackModel.h"
#import "UICheckView.h"

#define TEXT_H 120.0f//!<文本输入框高度


@interface FeedBackFormView : UIView

@property(nonatomic, strong) FeedBackForm *form;
@property(nonatomic, strong) UILabel *promptLabel;
@property(nonatomic, strong) UITextView *textview;

@property(nonatomic, copy) void(^keyboardBlock)(UITextView *);//!<用于键盘升起时其他界面调用,将view整体上移

- (id)initWithFrame:(CGRect)frame andForm:(FeedBackForm *)form;//!<通过form实例化
- (void) disPlayForm;

@end
