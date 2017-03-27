//
//  TableView.h
//  BlogDemo
//
//  Created by BinHan on 2016/5/27.
//  Copyright © 2016年 BinHan. All rights reserved.
//

@class BHTableViewModel;

@interface BHTableView : UIView

/**
 初始化

 @param viewModel 要 bind 的 viewModel
 @return 返回实例
 */
-(instancetype)initWithViewModle:(BHTableViewModel *)viewModel;

@end
