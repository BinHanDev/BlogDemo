//
//  UIScrollView+BHRefresh.m
//  BlogDemo
//
//  Created by HanBin on 16/5/30.
//  Copyright © 2016年 BinHan. All rights reserved.
//

#import "UIScrollView+BHRefresh.h"

@implementation UIScrollView (BHRefresh)

-(void)setBh_header:(BHRefreshHeader *)bh_header
{
    if (bh_header != self.bh_header)
    {
        [self.bh_header removeFromSuperview];
        [self insertSubview:bh_header atIndex:0];
        [self willChangeValueForKey:@"bh_header"];
        objc_setAssociatedObject(self, @selector(bh_header), bh_header , OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"bh_header"];
    }
}

-(BHRefreshHeader *)bh_header
{
    return objc_getAssociatedObject(self, @selector(bh_header));
}

@end
