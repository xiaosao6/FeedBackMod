//
//  FeedBackModel.h
//  FeedBackMod
//
//  Created by sischen on 16/5/14.
//  Copyright (c) 2016年 neo6. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SIG_SEL @"single_select"
#define MUL_SEL @"multi_select"
#define TXT		@"texts"


/**反馈数据模型
 */
@interface FeedBackModel : NSObject
@property (nonatomic, strong) NSMutableArray *indexItemArray;//!<索引条目列表
- (id) initWithJsonFilePath:(NSString *)path;
@end


/**索引条目
 */
@interface FeedBackIndexItem : NSObject
@property (nonatomic, copy) NSString *problem_desc;//!<问题描述
@property (nonatomic, assign) NSInteger problem_id;//!<问题id
@property (nonatomic, strong) NSMutableArray *formsArray;//!<表单列表
@end


/**反馈表单，包括单选/多选/填空
 */
@interface FeedBackForm : NSObject
@property (nonatomic, copy) NSString *type;//!<类型
@property (nonatomic, copy) NSString *prompt;//!<选项或文本框上方提示或问题
@property (nonatomic, assign) bool required;//!<是否必填/必选
@property (nonatomic, copy) NSString *report_fail;//!<失败提示
@property (nonatomic, copy) NSString *hint;//!<place holder
@property (nonatomic, assign) NSInteger max_len;//!<最长字符数
@property (nonatomic, strong) NSMutableArray *selectionsArray;//!<选项列表
@end


/**反馈选项
 */
@interface FeedBackSelection : NSObject
@property (nonatomic, copy) NSString *select_desc;//!<选项描述
@property (nonatomic, assign) NSInteger select_id;//!<选项id
@end


