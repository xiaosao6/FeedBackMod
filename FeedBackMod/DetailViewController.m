//
//  DetailViewController.m
//  FeedBackMod
//
//  Created by sischen on 16/5/14.
//  Copyright (c) 2016年 neo6. All rights reserved.
//

#import "DetailViewController.h"
#import "FeedBackFormView.h"

#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height
#define CONTACT_HINT @"请输入联系方式"
#define KEY_H	  252
#define CONTACT_H 60
#define GAP 10 //上升时底部多留的空隙

@interface DetailViewController () <UIScrollViewDelegate, UITextFieldDelegate>
{
	BOOL isKeyBoardShown;
	CGFloat needRise_H;//本次键盘弹出时,view需要上升的高度
	CGFloat needScroll_H;//本次键盘弹出时,如果文本框未展示完全,scrollview需要向上滚动的距离
}
@property (nonatomic, strong) UIScrollView *scrollerView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	self.scrollerView = [[UIScrollView alloc] init];
	self.scrollerView.frame = CGRectMake(0, 0, self.view.bounds.size.width, [UIScreen mainScreen].bounds.size.height);
	self.scrollerView.backgroundColor = [UIColor whiteColor];
	self.scrollerView.delegate = self;

	NSInteger formcount = self.item.formsArray.count;
	CGFloat contentHeight = 0;//累计内容高度
	
	for (NSInteger i = 0; i < formcount; i++) {
		
		FeedBackFormView *formView = [[FeedBackFormView alloc] initWithFrame:CGRectMake(0, contentHeight, self.scrollerView.bounds.size.width, 0) andForm:self.item.formsArray[i]];
		[formView disPlayForm];
		
		formView.keyboardBlock = ^void(UITextView *tv){
			[self keyboardRising:tv];
		};
		
		[self.scrollerView addSubview:formView];
		contentHeight += formView.bounds.size.height;
	}
	
	UITextField *contactTF = [[UITextField alloc] initWithFrame:CGRectMake(SEL_H/4, contentHeight+SEL_H/4, SCREEN_W-SEL_H/2, CONTACT_H-SEL_H/2)];
	contactTF.borderStyle = UITextBorderStyleRoundedRect;
	contactTF.delegate = self;
	contactTF.placeholder = CONTACT_HINT;
	contactTF.font = [UIFont systemFontOfSize:15];
	[self.scrollerView addSubview:contactTF];
	
	UIButton *commitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
	commitBtn.frame = CGRectMake(SEL_H/4, contentHeight+CONTACT_H+SEL_H/4, SCREEN_W-SEL_H/2, CONTACT_H-SEL_H/2);
	[commitBtn setTitle:@"提交" forState:UIControlStateNormal];
	commitBtn.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.1];
	commitBtn.clipsToBounds = YES;
	commitBtn.layer.cornerRadius = 5;
	[self.scrollerView addSubview:commitBtn];
	
	self.scrollerView.contentSize = CGSizeMake(self.scrollerView.bounds.size.width, contentHeight+CONTACT_H+CONTACT_H);
	[self.view addSubview:self.scrollerView];
	
	//监听键盘下降：
	NSNotificationCenter *noticenter = [NSNotificationCenter defaultCenter];
	[noticenter addObserver:self selector:@selector(keyboardDown) name:UIKeyboardWillHideNotification object:nil];
	
}


-(void)keyboardRising:(UIScrollView *)tv
{
	//正在输入文本框的在window的绝对坐标rect
	CGRect rect = [tv convertRect:tv.bounds toView:[[UIApplication sharedApplication] keyWindow]];
	//h:需要上升的高度
	CGFloat h = rect.origin.y + rect.size.height+GAP + KEY_H - SCREEN_H;
	
	if (h <= 0) {//不需要上升
		return;
	}
	
	//当前scrollerView的偏移
	CGPoint offset = self.scrollerView.contentOffset;
	//h2:需要向上滚的高度
	CGFloat h2 = rect.origin.y + rect.size.height+GAP - SCREEN_H;
	
	if (h2 > 0) {//先滚动scrollerView确保文本框被完全显示
		needScroll_H = h2;
		offset.y += needScroll_H;
		self.scrollerView.contentOffset = offset;
	}

	needRise_H = h;
	CGRect frame = self.view.frame;
	frame.origin.y -= needRise_H - needScroll_H;
	
	NSLog(@"键盘上升了");
	[UIView animateWithDuration:0.3 animations:^{
		self.view.frame = frame;
		isKeyBoardShown = YES;
	}];
}



- (void)keyboardDown
{
	if (!isKeyBoardShown) {
		return;
	}
	
	CGRect frame = self.view.frame;
	frame.origin.y += needRise_H - needScroll_H;
	
	NSLog(@"键盘下降了");
	[UIView animateWithDuration:0.3 animations:^{
		self.view.frame = frame;
		isKeyBoardShown = NO;
		needRise_H = 0;
		needScroll_H = 0;
	}];
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
	[self keyboardRising:(UIScrollView *)textField];
}


-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	[self.scrollerView endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return NO;
}



//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

@end
