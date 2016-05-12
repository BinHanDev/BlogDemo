//
//  BHBaseTableController.h
//  BlogDemo
//
//  Created by HanBin on 15/11/25.
//  Copyright © 2015年 BinHan. All rights reserved.
//

@interface BHBaseTableController : BHBaseController

/**
 *  手动添加的tableView
 */
@property (nonatomic, weak)UITableView *tableView;

/**
 *  初始化UITableView
 *
 *  @param frame frame
 *  @param style style
 */
-(void)initTableView:(CGRect)frame style:(UITableViewStyle) style;

@end
