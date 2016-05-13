//
//  BHCellRandomController.m
//  BlogDemo
//
//  Created by HanBin on 16/3/9.
//  Copyright © 2016年 BinHan. All rights reserved.
//

#import "BHViewController2.h"
#import "BHCellRandomCell.h"

@interface BHViewController2 ()<BHCellRandomCellDelegate>

/**
  *  数据源
 **/
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation BHViewController2

- (void)viewDidLoad
{
    [super viewDidLoad];
    [super initTableViewWithStyle:UITableViewStylePlain];
    self.dataArray = @[@[@(arc4random()%20), @(arc4random()%20)], @[@(arc4random()%20), @(arc4random()%20)], @[@(arc4random()%20), @(arc4random()%20)], @[@(arc4random()%20), @(arc4random()%20)], @[@(arc4random()%20), @(arc4random()%20)], @[@(arc4random()%20), @(arc4random()%20)]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BHCellRandomCell *cell = [tableView dequeueReusableCellWithIdentifier:[BHCellRandomCell identifier]];
    if (!cell)
    {
        cell = [[BHCellRandomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[BHCellRandomCell identifier]];
        cell.delegate = self;
    }
    NSInteger count = [self.dataArray[indexPath.section][indexPath.row] integerValue];
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i < count; i++)
    {
        [array addObject:[NSString stringWithFormat:@"当前点击的cell section = %ld row = %ld", indexPath.section, indexPath.row]];
    }
    cell.dataArr = array;
    return cell;
}


/**
 *  返回不定cell高度，正常情况下我们可以在cell中计算其高度，然后将其设置在model中，此方法中在model中获取cell高度
 *  可以在明确NSIndexPath的数量下，手动计算出cell中UICollectionView高度
 *
 *  @param tableView tableView
 *  @param indexPath indexPath
 *
 *  @return
 */
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count = [self.dataArray[indexPath.section][indexPath.row] integerValue];
    NSInteger rowNum = SCREEN_WIDTH / 50.f;
    NSInteger row = count / rowNum;
    if (count % rowNum != 0)
    {
        row ++;
    }
    return row * 50.f;
}

/**
 *  IOS7后的预估高度，可防止一开始heightForRowAtIndexPath调用多次，因为heightForRowAtIndexPath中计算高度某些时候是个耗时的操作，会造成卡顿
 *
 *  @param tableView tableView
 *  @param indexPath indexPath
 *
 *  @return 返回cell预估高度，接近值既可以
 */
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 44.F)];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.text = [NSString stringWithFormat:@"第section = %ld标题", section];
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.f;
}

-(void)chickItem:(NSString *)str
{
    [BHUtils showMessage:str];
}

@end
