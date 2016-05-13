//
//  BHViewController8.m
//  BlogDemo
//
//  Created by HanBin on 16/5/10.
//  Copyright © 2016年 BinHan. All rights reserved.
//

#import "BHViewController8.h"
#import <GPUImage/GPUImage.h>
#import <AssetsLibrary/ALAsset.h>
/**
 *  滤镜名称label的宽度  苹果已不建议使用宏来定义
 */
const CGFloat lableWidth = 100.f;

@interface BHViewController8 ()

/**
 * 滤镜名称数组
 **/
@property (nonatomic, strong) NSArray *filterArray;
/**
 * 当前所选则的滤镜序号
 **/
@property (nonatomic, assign) NSInteger currentFiterIndex;
/**
 * 当前所选则的滤镜
 **/
@property (nonatomic, strong) GPUImageFilter *currentFilter;
/**
 * 摄像机
 **/
@property (nonatomic, strong) GPUImageVideoCamera *videoCamera;
@property (nonatomic, weak) GPUImageView *filterView;
/**
 * 滤镜label的scorllview
 **/
@property (nonatomic, weak) UIScrollView *controlFilterView;
@property (nonatomic, weak) UIButton *recordBtn;
/**
 * 录制视频
 **/
@property (nonatomic, strong) GPUImageMovieWriter *movieWriter;
/**
 * 录制视频文件地址
 **/
@property (nonatomic, copy) NSString *pathToMovie;
/**
 * 开始触摸的point
 **/
@property (nonatomic, assign) CGPoint toucheBeganPoint;
/**
 * 结束触摸的point
 **/
@property (nonatomic, assign) CGPoint toucheEndPoint;
/**
 * 是否在录制视频
 **/
@property (nonatomic, assign) BOOL isrecording;
/**
 * 是否在执行动画
 **/
@property (nonatomic, assign) BOOL isAnimating;

@end

@implementation BHViewController8

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.filterArray = @[@"nil",
                         @"GPUImageBilateralFilter",@"GPUImageHueFilter",@"GPUImageColorInvertFilter",
                         @"GPUImageSepiaFilter",@"GPUImageGaussianBlurPositionFilter",@"GPUImageMedianFilter",
                         @"GPUImageVignetteFilter",@"GPUImageKuwaharaRadius3Filter",@"GPUImageBilateralFilter",];
    self.currentFiterIndex = 0;
    //设置实时摄像头及配置参数
//    GPUImageStillCamera
    self.videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionFront];
    //摄像头录制方向
    self.videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    //默认开启非滤镜
    self.videoCamera.horizontallyMirrorFrontFacingCamera = YES;
    GPUImageView *filterView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, SCREEN_WIDTH, SCREEN_WIDTH * 4.f / 3.f)];
//    self.filterView.fillMode = kGPUImageFillModePreserveAspectRatio;
    [self.view addSubview:(self.filterView = filterView)];
    [self.videoCamera addTarget:self.filterView];
    //摄像头开始捕捉图像
    [self.videoCamera startCameraCapture];
    [self setUpCameraFilterView];
}

/**
 *  添加展示滤镜的Label及录制视频按钮
 */
-(void)setUpCameraFilterView
{
    UIScrollView *controlFilterView = [UIScrollView new];
    controlFilterView.scrollEnabled = NO;
    [self.view addSubview:(self.controlFilterView = controlFilterView)];
    NSInteger count = self.filterArray.count;
    UILabel *lastLabel;
    for (NSInteger i = 0; i < count; i++)
    {
        UILabel *lable = [UILabel new];
        lable.text = self.filterArray[i];
        if( i == 0)
        {
            lable.textColor = [BHUtils hexStringToColor:@"ffd900"];
        }
        else
        {
            lable.textColor = [UIColor whiteColor];
        }
        lable.font = [UIFont systemFontOfSize:13.0f];
        lable.textAlignment = NSTextAlignmentCenter;
        lable.tag = 100 + i;
        [controlFilterView addSubview:lable];
        [lable sizeToFit];
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(lableWidth));
            make.top.equalTo(controlFilterView);
            if(lastLabel)
            {
                make.left.equalTo(lastLabel.mas_right);
            }
            else
            {
                make.left.equalTo(controlFilterView);
            }
        }];
        lastLabel = lable;
    }
    [controlFilterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.filterView.mas_bottom).offset(10.f);
        make.left.mas_equalTo(self.view.center.x - lableWidth / 2.f);
        make.width.mas_equalTo(lableWidth * count);
        make.height.mas_equalTo(15.f);
    }];
    //录制按钮
    UIButton *recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [recordBtn setImage:BHIMG(@"record") forState:UIControlStateNormal];
    [self.view addSubview:(self.recordBtn = recordBtn)];
    [recordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.controlFilterView.mas_bottom).offset(15.f);
        make.centerX.equalTo(self.view);
        make.width.height.mas_equalTo(51.f);
    }];
    [recordBtn addTarget:self action:@selector(recording:) forControlEvents:UIControlEventTouchUpInside];
}

/**
 *  开始录制视频，再次点击停止录制
 *
 *  @param btn 录制按钮
 */
-(void)recording:(UIButton *)btn
{
    self.isrecording = !self.isrecording;
    if (self.isrecording)
    {
        self.pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m4v", [BHUtils randFileName]]];
        unlink([self.pathToMovie UTF8String]);
        // If a file already exists, AVAssetWriter won't let you record new frames, so delete the old movie
        NSURL *movieURL = [NSURL fileURLWithPath:self.pathToMovie];
        self.movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(360.0, 640.0)];
        self.movieWriter.encodingLiveVideo = YES;
        self.movieWriter.shouldPassthroughAudio = YES;
        [self.currentFilter addTarget:self.movieWriter];
        self.videoCamera.audioEncodingTarget = self.movieWriter;
        [self.movieWriter startRecording];
    }
    else
    {
        self.videoCamera.audioEncodingTarget = nil;
        UISaveVideoAtPathToSavedPhotosAlbum(self.pathToMovie, nil, nil, nil);
        [self.movieWriter finishRecording];
        [self.currentFilter removeTarget:self.movieWriter];
        [self savePhotoCmare:self.pathToMovie];
    }
}

/**
 *  将视频写入保存到系统相处
 *
 *  @param pathToMovie 要保存的视频路径
 */
- (void)savePhotoCmare:(NSString *)pathToMovie
{
    NSURL *url = [[NSURL alloc] initFileURLWithPath:pathToMovie];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:url])
    {
        [library writeVideoAtPathToSavedPhotosAlbum:url completionBlock:^(NSURL *assetURL, NSError *error){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error)
                {
                    [BHUtils showMessage:[NSString stringWithFormat:@"保存失败！%@", error.localizedDescription]];
                }
                else
                {
                    [BHUtils showMessage:@"保存成功"];
                }
            });
        }];
    }
}

/**
 *  通过监听整个视图的触摸操作来切换当前的滤镜
 *
 *  @param touches
 *  @param event
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.isAnimating) return;
    self.toucheBeganPoint = [[touches anyObject] locationInView:self.view];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self lableTextColor:[UIColor whiteColor] tag:self.currentFiterIndex];
    self.toucheEndPoint = [[touches anyObject] locationInView:self.view];
    if (self.toucheBeganPoint.x - self.toucheEndPoint.x > 0)
    {
        self.currentFiterIndex++;
        if (self.currentFiterIndex > self.filterArray.count - 1)
        {
            self.currentFiterIndex = self.filterArray.count - 1;
        }
    }
    else
    {
        self.currentFiterIndex--;
        if (self.currentFiterIndex <= 0)
        {
            self.currentFiterIndex = 0;
        }
    }
    [self lableTextColor:[BHUtils hexStringToColor:@"ffd900"] tag:self.currentFiterIndex];
    self.isAnimating = YES;
    [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.controlFilterView.mj_x= self.view.center.x - lableWidth / 2.f - self.currentFiterIndex * lableWidth;
    } completion:^(BOOL finished) {
        self.isAnimating = NO;
        [self cameraFilterWithIndex];
    }];
}

/**
 *  刷新滤镜
 */
-(void)cameraFilterWithIndex
{
    [self.videoCamera removeAllTargets];
    if (self.currentFiterIndex != 0)
    {
        self.currentFilter = [[NSClassFromString(self.filterArray[self.currentFiterIndex]) alloc] init];
         [self.videoCamera addTarget:self.currentFilter];
        [self.currentFilter addTarget:self.filterView];
    }
}

/**
 *  更新滤镜文本颜色
 *
 *  @param color label文本的颜色
 *  @param tag   lable的tag
 */
-(void)lableTextColor:(UIColor *)color tag:(NSInteger)tag
{
    UILabel *label = [self.controlFilterView viewWithTag:self.currentFiterIndex + 100];
    label.textColor = color;
}

/**
 *  设置录制时候时的按钮动画，循环旋转是一个递归函数
 *
 *  @param options 动画option
 */
- (void) spinWithOptions: (UIViewAnimationOptions) options
{
    [UIView animateWithDuration:0.3f delay:0 options:options animations:^{
        self.recordBtn.transform = CGAffineTransformRotate(self.recordBtn.transform, M_PI / 2);
    } completion:^(BOOL finished) {
        if (finished)
        {
            if (self.isrecording)
            {
                [self spinWithOptions: UIViewAnimationOptionCurveLinear];
            }
            else if (options != UIViewAnimationOptionCurveEaseOut)
            {
                [self spinWithOptions: UIViewAnimationOptionCurveEaseOut];
            }
        }
    }];
}


@end
