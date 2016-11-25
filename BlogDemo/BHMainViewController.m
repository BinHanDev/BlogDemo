//
//  ViewController.m
//  BlogDemo
//
//  Created by HanBin on 15/12/19.
//  Copyright © 2015年 BinHan. All rights reserved.
//

#import "BHMainViewController.h"

@interface BHMainViewController ()<UITableViewDelegate, UITableViewDataSource>

/**
 *  数据源
 **/
@property (nonatomic, strong) NSArray *dataArray;


@property (nonatomic, weak) UITableView *tableView;

@end


@implementation BHMainViewController

#pragma mark - circle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self tableView];
    self.title      =   @"BlogDemo";
    self.dataArray  =   @[@"UIBezierPath配合CAShapeLayer画一些有趣的图形",
                          @"链式编程(UILable/UIButton/AFN)",
                          @"封装AVPlayer，触摸手势快进调节音量",
                          @"下拉刷新",
                          @"RAC常用法",];
    
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

-(void)updateViewConstraints
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSInteger row = indexPath.row;
    UIViewController *controller = [[NSClassFromString([NSString stringWithFormat:@"BHViewController%ld",row]) alloc] init];
    controller.title = self.dataArray[row];
    BHPushVC(controller);
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
