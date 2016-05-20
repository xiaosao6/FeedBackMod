//
//  FeedBackModel.m
//  FeedBackMod
//
//  Created by sischen on 16/5/14.
//  Copyright (c) 2016年 neo6. All rights reserved.
//

#import "FeedBackModel.h"


@implementation FeedBackModel

- (id) initWithJsonFilePath:(NSString *)path
{
	if (self = [super init]) {
		
		NSData *data = [[NSData alloc] initWithContentsOfFile:path];
		NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
		NSArray *sourceArr = dict[@"feedbacks"];
		
		//解析json:
		self.indexItemArray = [NSMutableArray array];
		for (NSDictionary *dict in sourceArr) {
			FeedBackIndexItem *item = [[FeedBackIndexItem alloc] init];
			item.problem_desc = dict[@"problem_desc"];
			item.problem_id = [dict[@"problem_id"] integerValue];
			item.formsArray = [NSMutableArray array];
			
			for (NSDictionary *dict2 in dict[@"forms"]) {
				FeedBackForm *form = [[FeedBackForm alloc] init];
				form.type = dict2[@"type"];
				form.prompt = dict2[@"prompt"];
				form.required = (bool)dict2[@"required"];
				form.report_fail = dict2[@"report_fail"];
				form.hint = dict2[@"hint"];
				form.max_len = [dict2[@"max_len"] integerValue];
				form.selectionsArray = [NSMutableArray array];
				
				for (NSDictionary *dict3 in dict2[@"items"]) {
					FeedBackSelection *sel = [[FeedBackSelection alloc] init];
					sel.select_desc = dict3[@"select_desc"];
					sel.select_id = [dict3[@"select_id"] integerValue];
					
					[form.selectionsArray addObject:sel];
				}
				[item.formsArray addObject:form];
			}
			[self.indexItemArray addObject:item];
		}
		
		
	}
	return self;
}

@end


@implementation FeedBackIndexItem
-(NSString *)description
{
	return [NSString stringWithFormat:@"prob_id=%ld,prob_desc=%@,arr=%@",self.problem_id,self.problem_desc,self.formsArray];
}
@end


@implementation FeedBackForm
-(NSString *)description
{
	return [NSString stringWithFormat:@"type=%@,propt=%@,require=%d,fail_msg=%@,hint=%@,max_len=%ld,arr=%@",self.type,self.prompt,self.required,self.report_fail,self.hint,self.max_len,self.selectionsArray];
}
@end


@implementation FeedBackSelection
-(NSString *)description
{
	return [NSString stringWithFormat:@"sel_desc=%@,sel_id=%ld",self.select_desc,self.select_id];
}
@end

