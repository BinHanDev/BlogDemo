//
//  BHInputTextDelegate.h
//  BlogDemo
//
//  Created by HanBin on 16/8/14.
//  Copyright © 2016年 BinHan. All rights reserved.
//
//  用于解决项目中多出出入文本长度限制问题
//

/**
 到达限制长度后的blokc回调

 @return 返回值
 */
typedef void(^LimitBlock)();

@interface BHInputTextDelegate : NSObject<UITextFieldDelegate, UITextViewDelegate>


/**
创建自定义代理对象

 @param textLength 文本限制长度
 @param limitBlock 超过长度时候的block回调 

 @return 返回代理对象
 */
+(instancetype)creatDelegateWithLimitLength:(NSInteger)limitLength textField:(UITextField *)textField limitBlock:(LimitBlock)limitBlock;

@end
