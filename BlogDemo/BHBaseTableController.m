//
//  BHBaseTableController.m
//  BlogDemo
//
//  Created by HanBin on 15/11/25.
//  Copyright © 2015年 BinHan. All rights reserved.
//

@interface BHBaseTableController()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation BHBaseTableController

-(void)initTableViewWithStyle:(UITableViewStyle) style
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:style];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:(self.tableView = tableView)];
    //添加约束的方法则不论在任何版本都会让视图显示正确的大小
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
