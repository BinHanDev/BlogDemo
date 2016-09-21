//
//  ViewController.m
//  BlogDemo
//
//  Created by HanBin on 15/12/19.
//  Copyright © 2015年 BinHan. All rights reserved.
//

#import "BHMainViewController.h"


@interface BHMainViewController ()
{
    NSArray *_titleArr;
}
@end

@implementation BHMainViewController

#pragma mark - circle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [super initTableViewWithStyle:UITableViewStylePlain];
    self.title      =   @"BlogDemo";
    _titleArr       =   @[@"UIBezierPath配合CAShapeLayer画一些有趣的图形",
                          @"微信下拉小视频加载动画",
                          @"Cell中子UIView数量不定的使用UICollectionViewCell的方案",
                          @"无限循环UIScrollView的两种实现方法",
                          @"CoreSpotlight入门",
                          @"IOS中不同版本模糊效果实现",
                          @"AFNetworking链式网络请求封装",
                          @"封装AVPlayer，触摸手势快进调节音量",
                          @"GPUImage实现实时滤镜，需真机测试",
                          @"下拉刷新",
                          @"链式编程写UILabel和UIButton",
                          @"自定义Delegate为控制器瘦身",
                          @"ReactiveCocoa学习",];
    
}

/**
 *  仅仅是跳转AVPlayer页后修改了navigationBar及状态栏状态
 *
 *  @param animated
 */
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

#pragma mark -UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = _titleArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSInteger row = indexPath.row;
    UIViewController *controller = [[NSClassFromString([NSString stringWithFormat:@"BHViewController%ld",row]) alloc] init];
    controller.title = _titleArr[row];
    BHPushVC(controller);
}

@end
