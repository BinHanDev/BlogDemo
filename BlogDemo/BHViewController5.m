//
//  BHViewController5.m
//  BlogDemo
//
//  Created by HanBin on 16/4/25.
//  Copyright © 2016年 BinHan. All rights reserved.
//
//  参考官方Blurring and Tinting an Image Demo https://developer.apple.com/library/ios/samplecode/UIImageEffects/Introduction/Intro.html


#import "BHViewController5.h"
#import "UIImageEffects.h"

@interface BHViewController5()

/**底图**/
@property (nonatomic, weak) UIImageView *bgImageView;
/**毛玻璃遮罩view**/
@property (nonatomic, weak) UIVisualEffectView *visualEffectView;

@end

@implementation BHViewController5

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"AddBlue" style:UIBarButtonItemStylePlain target:self action:@selector(addBlurMask:)];
    [self bgImageView];
}

-(UIImageView *)bgImageView
{
    if (!_bgImageView)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.view addSubview:(_bgImageView = imageView)];
        //加载图有点大，用了个异步
        __weak UIImageView *weakImageView = _bgImageView;
        dispatch_async(dispatch_get_main_queue(), ^{;
            weakImageView.image = BHIMG(@"BlurEffect.jpg");
        });
    }
    return _bgImageView;
}

-(void)addBlurMask:(UIBarButtonItem *)sender
{
    if (IOS_VERSION_ABOVE(8.0))
    {
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
        visualEffectView.frame = self.view.bounds;
        //低于1.0会导致离屏渲染
        visualEffectView.alpha = 1.0;
        visualEffectView.frame = CGRectMake(0, 0, SCREEN_WIDTH / 2.F, SCREEN_HEIGHT / 2.f);
        [self.view addSubview:(self.visualEffectView = visualEffectView)];
    }
    else
    {
        UIImage *effectImage = [UIImageEffects imageByApplyingLightEffectToImage:_bgImageView.image];
        _bgImageView.image = effectImage;
    }
}

/**
 *  snapshot操作
 *
 *  @param view view
 *
 *  @return 返回快照后的图像
 */
- (UIImage *)imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(view.mj_w, view.mj_h), NO, [[UIScreen mainScreen] scale]);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
//    UIColor *tintColor = [UIColor colorWithWhite:0.95 alpha:0.3];
//    image = [UIImageEffects imageByApplyingLightEffectToImage:BHIMG(@"BlurEffect.jpg")];
    UIGraphicsEndImageContext();
    return image;
}

@end
