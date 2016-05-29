//
//  BHViewController9.m
//  BlogDemo
//
//  Created by HanBin on 16/5/29.
//  Copyright © 2016年 BinHan. All rights reserved.
//

#import "BHViewController9.h"

@interface BHViewController9()
{
    NSMutableArray *_dataArr;
}
@end

@implementation BHViewController9

- (void)viewDidLoad
{
    [super viewDidLoad];
    [super initTableViewWithStyle:UITableViewStylePlain];
    [self dataArr];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = _dataArr[indexPath.row];
    return cell;
}

-(void)dataArr
{
    if (!_dataArr)
    {
        _dataArr = [NSMutableArray array];
        for (NSInteger i = 0; i < 20; i++)
        {
            [_dataArr addObject:[NSString stringWithFormat:@"test数据 %ld", i]];
        }
    }
    [super.tableView reloadData];
}

@end
