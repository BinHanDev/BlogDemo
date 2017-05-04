//
//  BHTableViewModel.m
//  BlogDemo
//
//  Created by BinHan on 2016/5/27.
//  Copyright © 2016年 BinHan. All rights reserved.
//

#import "BHTableViewModel.h"
#import "BHVideoModel.h"

@implementation BHTableViewModel

#pragma mark - Intial Methods

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initialize];
    }
    return self;
}

-(void)initialize
{
    @weakify(self)
    [self.searchCommand.executionSignals.switchToLatest subscribeNext:^(NSArray *array) {
        @strongify(self)
        self.isHasData = array.count > 0;
        self.dataArray = array;
    }];
}

#pragma mark - Setter Getter Methods

-(RACCommand *)searchCommand
{
    if (!_searchCommand)
    {
        _searchCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *pageNum) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                NSString *url = [NSString stringWithFormat:@"http://cache.video.iqiyi.com/jp/avlist/202861101/%ld/", (long)[pageNum integerValue]];
                [[BHNetReqManager sharedManager].bh_requestUrl(url).bh_responseSerializer(HTTPResponseSerializer) startRequestWithCompleteHandler:^(id response, NSError *error) {
                    if (!error && response)
                    {
                        // 这个接口返回的不是一个标准的 json 格式  所以稍微做了一下处理
                        NSString *standardJson = [[[NSString alloc] initWithData:response  encoding:NSUTF8StringEncoding] substringFromIndex:13];
                        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[standardJson dataUsingEncoding:NSUTF8StringEncoding]  options:NSJSONReadingMutableContainers error:&error];
                        NSArray *array = [BHVideoModel mj_objectArrayWithKeyValuesArray:dic[@"data"][@"vlist"]];
                        [subscriber sendNext:array];
                        [subscriber sendCompleted];
                    }
                    else
                    {
                        [subscriber sendError:nil];
                    }
                }];
                return nil;
            }];
        }];
    }
    return _searchCommand;
}

@end
