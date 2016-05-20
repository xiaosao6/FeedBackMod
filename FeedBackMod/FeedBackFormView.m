//
//  FeedBackFormView.m
//  FeedBackMod
//
//  Created by sischen on 16/5/14.
//  Copyright (c) 2016年 neo6. All rights reserved.
//

#import "FeedBackFormView.h"



@interface FeedBackFormView () <UITextViewDelegate>
{
	CGFloat _prompt_H;//!<prompt提示文字高度
	NSMutableArray *_selViewArr;//!<选项viewArray
}
@end

@implementation FeedBackFormView


-(id)initWithFrame:(CGRect)frame andForm:(FeedBackForm *)form
{
	if (self = [super initWithFrame:frame]) {
		
		self.form = form;
		_selViewArr = [NSMutableArray array];
		_prompt_H = form.prompt == nil ? 0 : SEL_H;
		
		
		if ([self.form.type isEqualToString:SIG_SEL] || [self.form.type isEqualToString:MUL_SEL]) {
			
			NSInteger selcount = self.form.selectionsArray.count;
			self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, _prompt_H + SEL_H * selcount);
			
		}else if ([self.form.type isEqualToString:TXT]){
			
			self.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, _prompt_H + TEXT_H);
		}
	}
	return self;
}

-(void)disPlayForm
{
	
	if (self.form.prompt) {
		self.promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, _prompt_H)];
		self.promptLabel.text = [NSString stringWithFormat:@"  %@",self.form.prompt];
		self.promptLabel.font = [UIFont systemFontOfSize:16];
		self.promptLabel.textAlignment = NSTextAlignmentLeft;
		self.promptLabel.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.1];
		[self addSubview:self.promptLabel];
	}

	
	if ([self.form.type isEqualToString:SIG_SEL] || [self.form.type isEqualToString:MUL_SEL]) {
		
		NSInteger selcount = self.form.selectionsArray.count;
		for (NSInteger i = 0; i < selcount; i++) {
			
			UICheckView *checkview = [[UICheckView alloc] initWithFrame:CGRectMake(0, _prompt_H+i*SEL_H, self.bounds.size.width, SEL_H) type:[self.form.type isEqual:SIG_SEL] ? UICheckViewTypeSingle : UICheckViewTypeMulti checked:NO];
			FeedBackSelection *sel = self.form.selectionsArray[i];
			[checkview setText:sel.select_desc];
			[checkview setSel_id:sel.select_id];
			
			checkview.stateChangedBlock = ^void(UICheckView *cv){
				[self clearOtherSelWhenSingle:cv];
			};
			
			[_selViewArr addObject:checkview];
			[self addSubview:checkview];
		}
		
	}else if ([self.form.type isEqualToString:TXT]){

		self.textview = [[UITextView alloc] initWithFrame:CGRectMake(SEL_H/4, SEL_H/4+_prompt_H, self.bounds.size.width-SEL_H/2, self.bounds.size.height-_prompt_H-SEL_H/2)];
		
		self.textview.delegate = self;
		
		self.textview.text = self.form.hint;
		self.textview.textColor = [UIColor colorWithWhite:0.6 alpha:0.6];
		self.textview.font = [UIFont systemFontOfSize:15];
		self.textview.layer.cornerRadius = 5;
		self.textview.layer.borderWidth = 0.5;
		self.textview.layer.borderColor = [UIColor colorWithWhite:0.3 alpha:0.3].CGColor;
		self.textview.clipsToBounds = YES;
		[self addSubview:self.textview];
	}
}

/**单选时，清除其他已选项
 */
- (void)clearOtherSelWhenSingle:(UICheckView *)cv
{
	for (UICheckView *chv in _selViewArr) {
		if (chv.sel_id != cv.sel_id && [self.form.type isEqualToString:SIG_SEL]) {
			chv.checked = NO;
		}
	}
}

/**实现place holder效果,开始编辑时,清除hint
 */
-(void)textViewDidBeginEditing:(UITextView *)textView
{
//	NSLog(@"开始编辑");
	
	if ([textView.text isEqualToString:self.form.hint]) {
		textView.text = @"";
	}
	textView.textColor = [UIColor blackColor];
	
	self.keyboardBlock(textView);
}

/**实现place holder效果,结束编辑时,如未输入,恢复显示hint
 */
-(void)textViewDidEndEditing:(UITextView *)textView
{
//	NSLog(@"结束编辑");
	
	if (textView.text.length == 0) {
		textView.text = self.form.hint;
		textView.textColor = [UIColor colorWithWhite:0.6 alpha:0.6];
	}
}

/**当点击回车时,结束输入,键盘收起
 */
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	if ([text isEqualToString:@"\n"]){
		[textView resignFirstResponder];
		return NO;
	}
	return YES;
}


@end
