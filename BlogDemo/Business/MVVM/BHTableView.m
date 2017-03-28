//
//  TableView.m
//  BlogDemo
//
//  Created by BinHan on 2016/5/27.
//  Copyright © 2017年 BinHan. All rights reserved.
//

#import "BHTableView.h"
#import "BHTableViewModel.h"
#import "BHTableViewModel.h"
#import "BHListCell.h"

@interface BHTableView() <UITableViewDelegate, UITableViewDataSource>

/**
 没有数据时的 lable 进行提示
 */
@property (nonatomic, weak) UILabel *tipsLabel;

/**
 table
 */
@property (nonatomic, weak) UITableView *tableView;

/**
 viewModle
 */
@property (nonatomic, strong) BHTableViewModel *viewModel;

@end

@implementation BHTableView

+(BOOL)requiresConstraintBasedLayout
{
    return YES;
}

#pragma mark - Intial Methods

-(instancetype)initWithViewModle:(BHTableViewModel *)viewModel
{
    self = [super init];
    if (self)
    {
        self.viewModel = viewModel;
        [self bind];
    }
    return self;
}

-(void)updateConstraints
{
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.center);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.insets(UIEdgeInsetsZero);
    }];
    [super updateConstraints];
}

#pragma mark - Private Method

- (void)bind
{
    @weakify(self)
    [[RACObserve(self.viewModel, dataArray) distinctUntilChanged] subscribeNext:^(NSArray *array) {
        @strongify(self)
        [self.tableView reloadData];
    }];
    [[RACObserve(self.viewModel, isHasData) distinctUntilChanged] subscribeNext:^(id isHasData) {
        @strongify(self)
        BOOL result = [isHasData boolValue];
        self.tipsLabel.hidden = result;
        self.tableView.hidden = !result;
    }];
}

#pragma mark - Setter Getter Methods

-(UILabel *)tipsLabel
{
    if (!_tipsLabel)
    {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"没有数据~~~";
        label.font = [UIFont systemFontOfSize:17.f];
        [self addSubview:_tipsLabel = label];
    }
    return _tipsLabel;
}

-(UITableView *)tableView
{
    if (!_tableView)
    {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.rowHeight = 80.f;
        [tableView registerClass:[BHListCell class] forCellReuseIdentifier:[BHListCell identifier]];
        [self addSubview:(_tableView = tableView)];
    }
    return _tableView;
}

#pragma mark -UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.viewModel.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BHListCell *cell = [tableView dequeueReusableCellWithIdentifier:[BHListCell identifier]];
    cell.modle = self.viewModel.dataArray[indexPath.row];
    return cell;
}

#pragma mark -UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


@end
