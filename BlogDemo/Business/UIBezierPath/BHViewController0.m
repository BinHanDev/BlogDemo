//
//  UIBezierPathController.m
//  BlogDemo
//
//  Created by HanBin on 16/3/9.
//  Copyright © 2016年 BinHan. All rights reserved.
//

#define MENU_HEIGHT 64.f

#import "BHViewController0.h"

@interface BHViewController0 ()

@end

@implementation BHViewController0

#pragma mark - LifeCyle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUp];
}

- (void)dealloc {
    NSLog(@"%@-dealloc",self.class);
}

#pragma mark - Intial Methods

-(void)setUp
{
    [self initBtn];
    [self initLayer];
    [self initCircle];
    [self showImage];
}

#pragma mark - Target Methods

/**
 *  无限循环放大的圆  这种动画在按home键跳出用后，再次进入应用动画会没有效果，因为跳出应用后，
 *  所有的view将执行removeAllAnimations 如果需要动画继续需在application中发送通知
 */
-(void)loopCircle:(UIButton *)btn
{
    UIBezierPath *originPath = [UIBezierPath bezierPathWithOvalInRect:btn.frame];
    UIBezierPath *finalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(btn.mj_x- 100, btn.mj_y- 100, 200, 200)];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = finalPath.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor blueColor].CGColor;
    layer.lineWidth = 1.f;
    [self.view.layer addSublayer:layer];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.fromValue = (__bridge id _Nullable)(originPath.CGPath);
    animation.toValue = (__bridge id _Nullable)(finalPath.CGPath);
    animation.duration = 2.f;
    //    animation.autoreverses = YES;
    animation.repeatCount = MAXFLOAT;
    [layer addAnimation:animation forKey:@"path"];
}

#pragma mark - Private Method

-(void)initBtn
{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-60, 100, 40, 20)];
    [btn setTitle:@"点我" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor blueColor];
    [btn addTarget:self action:@selector(loopCircle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

/**
 *  初步认识UIBezierPath曲线，其可以设置起始点、移动到某点、及两点之间设置控制点进行曲线绘制
 *  CAShapeLayer设置其的填充色、边框粗细及颜色
 */
-(void)initLayer
{
    CAShapeLayer *layer =  [[CAShapeLayer alloc] init];
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path moveToPoint:CGPointMake(0, SCREEN_HEIGHT - MENU_HEIGHT)];
    [path addLineToPoint:CGPointMake(0, SCREEN_HEIGHT)];
    [path addLineToPoint:CGPointMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    [path addLineToPoint:CGPointMake(SCREEN_WIDTH, SCREEN_HEIGHT - MENU_HEIGHT)];
    [path addQuadCurveToPoint:CGPointMake(0, SCREEN_HEIGHT - MENU_HEIGHT) controlPoint:CGPointMake(SCREEN_WIDTH/2.f, SCREEN_HEIGHT - MENU_HEIGHT * 2.0f)];
    layer.path = path.CGPath;
    layer.fillColor = [UIColor purpleColor].CGColor;
    layer.strokeColor = [UIColor blueColor].CGColor;
    layer.lineWidth = 1.f;
    [self.view.layer addSublayer:layer];
}

/**
 *  绘制一个圆形，可以设置其起始位置及终止位置
 */
-(void)initCircle
{
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 200, 200)];
    layer.path = path.CGPath;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor blueColor].CGColor;
    layer.lineWidth = 1.f;
    layer.strokeStart = 0;
    layer.strokeEnd = 0.75;
    layer.frame = CGRectMake(0, 0, 200, 200);
    layer.position = self.view.center;
    [self.view.layer addSublayer:layer];
    CABasicAnimation *animation = [[CABasicAnimation alloc] init];
    animation.fromValue = [NSNumber numberWithFloat:1.0];
    animation.toValue = [NSNumber numberWithFloat:0.0];
    animation.duration = 5.f;
    [layer addAnimation:animation forKey:@"strokeStart"];
}

/**
 *  使用CABasicAnimation的path属性为layer的mark添加动画
 */
-(void)showImage
{
    UIImage *image = BHIMG(@"sunyizhen.jpg");
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.mj_y = kNavBarHeight;
    [self.view addSubview:imageView];
    
    UIBezierPath *originPath = [UIBezierPath bezierPathWithRect:CGRectInset(imageView.bounds, 67.f, 91.5f)];
    UIBezierPath *finalPath = [UIBezierPath bezierPathWithRect:imageView.bounds];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = finalPath.CGPath;
    //    layer.fillColor = [UIColor clearColor].CGColor;
    //    layer.strokeColor = [UIColor blueColor].CGColor;
    //    layer.lineWidth = 2.f;
    imageView.layer.mask = layer;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.fromValue = (__bridge id _Nullable)(originPath.CGPath);
    animation.toValue = (__bridge id _Nullable)(finalPath.CGPath);
    animation.duration = 2.f;
    [layer addAnimation:animation forKey:@"path"];
}


#pragma mark - Setter Getter Methods

#pragma mark - External Delegate



@end
