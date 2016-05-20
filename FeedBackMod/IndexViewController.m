//
//  IndexViewController.m
//  FeedBackMod
//
//  Created by sischen on 16/5/14.
//  Copyright (c) 2016年 neo6. All rights reserved.
//

#import "IndexViewController.h"
#import "FeedBackModel.h"
#import "DetailViewController.h"

@interface IndexViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) FeedBackModel *feedBackModel;//!<数据源
@end

@implementation IndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

	
	self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
	
	[self.view addSubview:self.tableView];
	
}

-(FeedBackModel *)feedBackModel
{
	if (_feedBackModel == nil) {
		
		NSString *path = [[NSBundle mainBundle] pathForResource:@"quick_feedback_model" ofType:@"json"];
		_feedBackModel = [[FeedBackModel alloc] initWithJsonFilePath:path];
		
	}
	return _feedBackModel;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return self.feedBackModel.indexItemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
	FeedBackIndexItem *item = self.feedBackModel.indexItemArray[indexPath.row];
	cell.textLabel.text = [NSString stringWithFormat:@" %ld. %@",item.problem_id, item.problem_desc];
	cell.textLabel.font = [UIFont systemFontOfSize:16];
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[[tableView cellForRowAtIndexPath:indexPath] setSelected:NO animated:YES];
	DetailViewController *detailVC = [[DetailViewController alloc] init];
	detailVC.navigationItem.title = @"反馈详情";
	detailVC.item = self.feedBackModel.indexItemArray[indexPath.row];
	[self.navigationController pushViewController:detailVC animated:YES];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
