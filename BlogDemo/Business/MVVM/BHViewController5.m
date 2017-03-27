//
//  BHViewController5.m
//  BlogDemo
//
//  Created by BinHan on 2016/5/27.
//  Copyright © 2016年 BinHan. All rights reserved.
//

#import "BHViewController5.h"
#import "BHTableView.h"
#import "BHTableViewModel.h"

@interface BHViewController5 () <UISearchBarDelegate>

/**
 搜索框
 */
@property (nonatomic, weak) UISearchBar *searchBar;

/**
 table 列表
 */
@property (nonatomic, weak) BHTableView *tableView;

/**
 table 列表中的 ViewModel
 */
@property (nonatomic, strong) BHTableViewModel *viewModel;

@end

@implementation BHViewController5

#pragma mark -cricle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setNeedsUpdateConstraints];
}

- (void)dealloc {
    NSLog(@"%@-dealloc",self.class);
}

#pragma mark - Intial Methods

-(void)updateViewConstraints
{
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(40.f);
        make.top.mas_equalTo(kNavBarHeight);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.searchBar.mas_bottom).offset(10.f);
        make.leading.bottom.trailing.mas_equalTo(self.view);
    }];
    [super updateViewConstraints];
}

#pragma mark - Target Methods

#pragma mark - Private Method

#pragma mark - Setter Getter Methods

-(UISearchBar *)searchBar
{
    if (!_searchBar)
    {
        UISearchBar *searchBar = [[UISearchBar alloc] init];
        [searchBar setPlaceholder:@"请输入查询的页数"];
        searchBar.delegate = self;
        [self.view addSubview:(_searchBar = searchBar)];
    }
    return _searchBar;
}

-(BHTableView *)tableView
{
    if (!_tableView)
    {
        BHTableView *tableView = [[BHTableView alloc] initWithViewModle:self.viewModel];
        [self.view addSubview:(_tableView = tableView)];
    }
    return _tableView;
}

-(BHTableViewModel *)viewModel
{
    if (!_viewModel)
    {
        _viewModel = [[BHTableViewModel alloc] init];
    }
    return _viewModel;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchContent = searchBar.text;
    [self.viewModel.searchCommand execute:searchContent];
    [searchBar resignFirstResponder];
}
@end
