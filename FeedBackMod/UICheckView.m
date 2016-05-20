//
//  UICheckView.m
//  FeedBackMod
//
//  Created by sischen on 16/5/15.
//  Copyright (c) 2016年 neo6. All rights reserved.
//

#import "UICheckView.h"


@interface UICheckView ()
- (UIImage *) checkBoxImageForType:(UICheckViewType)type
							checked:(BOOL)isChecked;
- (CGRect) imageViewFrameForCheckBoxImage:(UIImage *)img;
- (void) updateCheckBoxImage;
@end


@implementation UICheckView

@synthesize type, checked, enabled, textLabel, sel_id;
@synthesize stateChangedBlock;


- (id) initWithFrame:(CGRect)frame
				type:(UICheckViewType)aType
			 checked:(BOOL)aChecked
{
		frame.size.height = SEL_H;
		if (!(self = [super initWithFrame:frame])) {
			return self;
		}
		
		self.stateChangedBlock = nil;
		type = aType;
		checked = aChecked;
		self.enabled = YES;
		self.userInteractionEnabled = YES;
		self.backgroundColor = [UIColor clearColor];
		
		CGRect labelFrame = CGRectMake(SEL_H*5/4, SEL_H/4, self.frame.size.width - SEL_H*5/4, SEL_H/2);
		UILabel *l = [[UILabel alloc] initWithFrame:labelFrame];
		l.textAlignment = NSTextAlignmentLeft;
		l.backgroundColor = [UIColor clearColor];
		l.font = [UIFont systemFontOfSize:16];
		[self addSubview:l];
		self.textLabel = l;
		
		UIImage *img = [self checkBoxImageForType:type checked:checked];
		CGRect imageViewFrame = [self imageViewFrameForCheckBoxImage:img];
		UIImageView *iv = [[UIImageView alloc] initWithFrame:imageViewFrame];
		iv.image = img;
		[self addSubview:iv];
		checkBoxImageView = iv;
		
		return self;
	
}

- (void) setEnabled:(BOOL)isEnabled
{
	textLabel.enabled = isEnabled;
	enabled = isEnabled;
	checkBoxImageView.alpha = isEnabled ? 1.0f: 0.5f;
}

- (BOOL) enabled
{
	return enabled;
}

- (void) setText:(NSString *)text
{
	[textLabel setText:text];
}

- (void) setChecked:(BOOL)isChecked
{
	checked = isChecked;
	[self updateCheckBoxImage];
}



#pragma mark - Touch-related Methods

- (void) touchesBegan:(NSSet *)touches
			withEvent:(UIEvent *)event
{
	if (!enabled) {
		return;
	}
	
	self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.1];
	self.alpha = 0.7f;
	[super touchesBegan:touches withEvent:event];
}

- (void) touchesCancelled:(NSSet *)touches
				withEvent:(UIEvent *)event
{
	if (!enabled) {
		return;
	}
	
	self.backgroundColor = [UIColor clearColor];
	self.alpha = 1.0f;
	[super touchesCancelled:touches withEvent:event];
}

- (void) touchesEnded:(NSSet *)touches
			withEvent:(UIEvent *)event
{
	if (!enabled) {
		return;
	}
	
	self.backgroundColor = [UIColor clearColor];
	// restore alpha
	self.alpha = 1.0f;
	
	// check touch up inside
	if ([self superview]) {
		UITouch *touch = [touches anyObject];
		CGPoint point = [touch locationInView:[self superview]];
		CGRect validTouchArea = CGRectMake((self.frame.origin.x - 5),
										   (self.frame.origin.y - 10),
										   (self.frame.size.width + 5),
										   (self.frame.size.height + 10));
		if (CGRectContainsPoint(validTouchArea, point)) {
			
			if (self.type == UICheckViewTypeMulti) {
				checked = !checked;
			}else{
				checked = YES;
			}
		
			[self updateCheckBoxImage];
			
			if(stateChangedBlock) {
				stateChangedBlock(self);
			}
		}
	}
	
	[super touchesEnded:touches withEvent:event];
}

- (BOOL) canBecomeFirstResponder
{
	return YES;
}

#pragma mark - Private Methods

- (UIImage *) checkBoxImageForType:(UICheckViewType)t checked:(BOOL)isChecked
{
	NSString *suffix = isChecked ? @"checked" : @"unchecked";
	NSString *imageName = @"";
	
	switch (t) {
		case UICheckViewTypeMulti:
			imageName = @"feedback_mchoice_";
			break;
		case UICheckViewTypeSingle:
			imageName = @"feedback_schoice_";
			break;
		default:
			return nil;
	}
	imageName = [NSString stringWithFormat:@"%@%@", imageName, suffix];
	return [UIImage imageNamed:imageName];
}

- (CGRect) imageViewFrameForCheckBoxImage:(UIImage *)img
{
	return CGRectMake(SEL_H/2, SEL_H/4, SEL_H/2, SEL_H/2);
}

- (void) updateCheckBoxImage
{
	checkBoxImageView.image = [self checkBoxImageForType:type checked:checked];
}

@end
