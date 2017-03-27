//
//  ViewController.m
//  BlogDemo
//
//  Created by HanBin on 15/12/19.
//  Copyright © 2015年 BinHan. All rights reserved.
//

#import "BHMainViewController.h"

static NSString *identifier = @"identifier";

@interface BHMainViewController ()<UITableViewDelegate, UITableViewDataSource>

/**
 *  标题源
 **/
@property (nonatomic, strong) NSArray *titleArray;

/**
 tableView 视图
 */
@property (nonatomic, weak) UITableView *tableView;

@end


@implementation BHMainViewController

#pragma mark - LifeCyle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"BlogDemo";
    [self.view setNeedsUpdateConstraints];
}

- (void)dealloc
{
    NSLog(@"%@-dealloc",self.class);
}

#pragma mark - Intial Methods

-(void)updateViewConstraints
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
    [super updateViewConstraints];
}

#pragma mark - Target Methods

#pragma mark - Private Method

#pragma mark - Setter Getter Methods

-(NSArray *)titleArray
{
    if (!_titleArray)
    {
        _titleArray = @[@"UIBezierPath 配合 CAShapeLayer 画一些有趣的图形",
                        @"链式编程 UILable/UIButton/AFN 封装 Demo)",
                        @"封装 AVPlayer，触摸手势快进调节音量",
                        @"PhotoKit 框架",
                        @"RAC 常用法",
                        @"MVVM + RAC 示例",];
    }
    return _titleArray;
}


-(UITableView *)tableView
{
    if (!_tableView)
    {
        UITableView *tableView = [[UITableView alloc] init];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
        [self.view addSubview:(_tableView = tableView)];
    }
    return _tableView;
}

#pragma mark - External Delegate

#pragma mark -UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.textLabel.text = self.titleArray[indexPath.row];
    return cell;
}

#pragma mark -UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSInteger row = indexPath.row;
    UIViewController *controller = [[NSClassFromString([NSString stringWithFormat:@"BHViewController%ld",row]) alloc] init];
    controller.title = self.titleArray[row];
    BHPushVC(controller);
}


@end
