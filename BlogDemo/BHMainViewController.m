//
//  ViewController.m
//  BlogDemo
//
//  Created by HanBin on 15/12/19.
//  Copyright © 2015年 BinHan. All rights reserved.
//

#import "BHMainViewController.h"

static NSString *identifier = @"cell";

@interface BHMainViewController ()<UITableViewDelegate, UITableViewDataSource>

/**
 *  数据源
 **/
@property (nonatomic, strong) NSArray *dataArray;


@property (nonatomic, strong) UITableView *tableView;

@end


@implementation BHMainViewController

#pragma mark - LifeCyle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.view setNeedsUpdateConstraints];
    self.title      =   @"BlogDemo";
    self.dataArray  =   @[@"UIBezierPath配合CAShapeLayer画一些有趣的图形",
                          @"链式编程(UILable/UIButton/AFN封装Demo)",
                          @"封装AVPlayer，触摸手势快进调节音量",
                          @"PhotoKit框架",
                          @"RAC常用法",
                          ];

    
}

- (void)dealloc {
    NSLog(@"%@-释放了",self.class);
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

-(UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    }
    return _tableView;
}

#pragma mark - External Delegate

#pragma mark -UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark -UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSInteger row = indexPath.row;
    UIViewController *controller = [[NSClassFromString([NSString stringWithFormat:@"BHViewController%ld",row]) alloc] init];
    controller.title = self.dataArray[row];
    BHPushVC(controller);
}


@end
