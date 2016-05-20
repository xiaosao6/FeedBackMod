//
//  UICheckView.h
//  FeedBackMod
//
//  Created by sischen on 16/5/15.
//  Copyright (c) 2016年 neo6. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SEL_H 44.0f//!<选项高度

typedef enum UICheckViewType_ {
	
	UICheckViewTypeSingle = 0,//!<单选
	UICheckViewTypeMulti	  //!<多选
	
} UICheckViewType;


@interface UICheckView : UIView
{
	UICheckViewType type;
	BOOL checked;
	BOOL enabled;
	NSInteger sel_id;//!<选项id
	
	UIImageView *checkBoxImageView;
	UILabel *textLabel;

	void (^stateChangedBlock)(UICheckView *cv);
}

@property (nonatomic, readonly) UICheckViewType type;
@property (nonatomic, readonly) BOOL checked;
@property (nonatomic, getter=enabled, setter=setEnabled:) BOOL enabled;
@property (nonatomic, assign) NSInteger sel_id;
@property (nonatomic, retain) UILabel *textLabel;
@property (nonatomic, copy) void (^stateChangedBlock)(UICheckView *cv);


- (id) initWithFrame:(CGRect)frame
			   type:(UICheckViewType)aType
			 checked:(BOOL)aChecked;

- (void) setText:(NSString *)text;

- (void) setChecked:(BOOL)isChecked;


@end
