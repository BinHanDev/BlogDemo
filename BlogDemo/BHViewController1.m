//
//  BHWXPullController.m
//  BlogDemo
//
//  Created by HanBin on 16/3/9.
//  Copyright © 2016年 BinHan. All rights reserved.
//

#import "BHViewController1.h"
#import "WXPullView.h"

@interface BHViewController1 ()

@property (nonatomic, weak) WXPullView *pullView;

@end

@implementation BHViewController1

- (void)viewDidLoad
{
    [super viewDidLoad];
    [super initTableView:self.view.frame style:UITableViewStylePlain];
    super.tableView.backgroundColor = [UIColor blackColor];
    WXPullView *pullView = [[WXPullView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame) / 2) - 25, -kNavBarHeight, 50, 30)];
    [super.tableView addSubview:(self.pullView = pullView)];
}

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

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.pullView animationWith:scrollView.contentOffset.y];
    if(scrollView.contentOffset.y < -250.f)
    {
        UIViewController *controller = [[UIViewController alloc] init];
        controller.title = @"录制视频";
        controller.view.backgroundColor = [UIColor whiteColor];
        BHPushVC(controller);
    }
}
@end
