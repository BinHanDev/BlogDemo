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

-(void)initTableView:(CGRect)frame style:(UITableViewStyle) style
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:style];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:(self.tableView = tableView)];
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
