//
//  BHViewController9.m
//  BlogDemo
//
//  Created by HanBin on 16/5/29.
//  Copyright © 2016年 BinHan. All rights reserved.
//

#import "BHViewController3.h"
#import "UIScrollView+BHRefresh.h"


@interface BHViewController3()<UITableViewDataSource, UITableViewDelegate>

/**
 *  数据源
 **/
@property (nonatomic, strong) NSMutableArray *dataArray;

/**
 tableView
 */
@property (nonatomic, weak) UITableView *tableView;

@end

@implementation BHViewController3

#pragma mark -cricle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self tableView];
    [self dataArr];
    self.tableView.bh_header = [BHRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
}

-(void)updateViewConstraints
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [super updateViewConstraints];
}

#pragma mark -UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

-(void)dataArr
{
    if (!self.dataArray)
    {
        self.dataArray = [NSMutableArray array];

    }
    [self.dataArray removeAllObjects];
    for (NSInteger i = 0; i < 20; i++)
    {
        [self.dataArray addObject:[NSString stringWithFormat:@"test随机数据 %d", (int)arc4random() % 100]];
    }
    [self.tableView reloadData];
}

-(void)loadNewData
{
    BHLog(@"最新数据加载结束");
    [self dataArr];
}

#pragma mark initSubView

-(UITableView *)tableView
{
    if (!_tableView)
    {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:(_tableView = tableView)];
        [self.view setNeedsUpdateConstraints];
    }
    return _tableView;
}

@end
