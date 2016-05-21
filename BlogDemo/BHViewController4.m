//
//  BHViewController4.m
//  BlogDemo
//
//  Created by HanBin on 16/4/11.
//  Copyright © 2016年 BinHan. All rights reserved.
//

#import "BHViewController4.h"
#import <CoreSpotlight/CoreSpotlight.h>

@interface BHViewController4 ()

@end

@implementation BHViewController4

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UILabel *lable = [UILabel new];
    [self.view addSubview:lable];
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    if(iOS_VERSION_ABOVE(9.0))
    {
        lable.text = @"在Spotlight搜索关键词索引Test";
        CSSearchableItemAttributeSet *attributeSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:@"com.mobile.BlogDemo"];
        attributeSet.title = @"CoreSpotlightTestTitle";
        attributeSet.contentDescription = @"CoreSpotlightTestDescription";
        CSSearchableItem *item = [[CSSearchableItem alloc] initWithUniqueIdentifier:@"com.mobile.BlogDem" domainIdentifier:@"mxy" attributeSet:attributeSet];
        [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:@[item] completionHandler:^(NSError * _Nullable error) {
            if (error)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [BHUtils showMessage:error.localizedDescription];
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [BHUtils showMessage:@"添加CoreSpotlight索引成功"];
                });
            }
        }];
    }
    else
    {
        lable.text = @"Spotlight功能不可用，请升级到IOS9";
    }
}

-(void)deleteSearchableItem
{
    //关于删除指定的spotlight
    [[CSSearchableIndex defaultSearchableIndex] deleteSearchableItemsWithDomainIdentifiers:@[@"mxy"] completionHandler:^(NSError * _Nullable error) {
        
    }];
    //删除所有spotlight
    [[CSSearchableIndex defaultSearchableIndex] deleteAllSearchableItemsWithCompletionHandler:^(NSError * _Nullable error) {
        
    }];
}

@end
