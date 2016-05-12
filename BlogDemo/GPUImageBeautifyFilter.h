//
//  GPUImageBeautifyFilter.h
//  BlogDemo
//
//  Created by HanBin on 16/5/10.
//  Copyright © 2016年 BinHan. All rights reserved.
//


#import <GPUImage/GPUImage.h>

@class GPUImageCombinationFilter;

@interface GPUImageBeautifyFilter : GPUImageFilterGroup {
    GPUImageBilateralFilter *bilateralFilter;
    GPUImageCannyEdgeDetectionFilter *cannyEdgeFilter;
    GPUImageCombinationFilter *combinationFilter;
    GPUImageHSBFilter *hsbFilter;
}

@end
