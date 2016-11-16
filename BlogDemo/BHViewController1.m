//
//  BHWXPullController.m
//  BlogDemo
//
//  Created by HanBin on 16/3/9.
//  Copyright © 2016年 BinHan. All rights reserved.
//

#import "BHViewController1.h"
#import "WXPullView.h"

@interface BHViewController1 ()<UITableViewDataSource, UITableViewDelegate>

/**
 tableView
 */
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, weak) WXPullView *pullView;

@end

@implementation BHViewController1

#pragma mark -circle

- (void)viewDidLoad
{
    [super viewDidLoad];
    WXPullView *pullView = [[WXPullView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame) / 2) - 25, -kNavBarHeight, 50, 30)];
    [self.tableView addSubview:(self.pullView = pullView)];
}

#pragma mark -UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = @"test标题";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark -UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    BHLog(@"contentOffset y = %0.f", scrollView.contentOffset.y);
    BHLog(@"contentInset y = %0.f", scrollView.contentInset.top);
    [self.pullView animationWith:scrollView.contentOffset.y];
    if(scrollView.contentOffset.y < -200.f)
    {
        UIViewController *controller = [[UIViewController alloc] init];
        controller.title = @"录制视频";
        controller.view.backgroundColor = [UIColor whiteColor];
        BHPushVC(controller);
    }
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
