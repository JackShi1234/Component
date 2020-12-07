//
//  JMOAuthItem.h
//  demo
//
//  Created by 张小二 on 2020/12/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 验证码里的单个输入框View
 */
@interface JMOAuthItem : UIView

/**
 显示光标的Label
 */
@property (nonatomic, strong, readonly) CAShapeLayer *cursorLayer;

/**
 显示数字的Label
 */
@property (nonatomic, strong, readonly) UILabel *textLabel;

/**
 设置光标是否隐藏
 
 @param isHidden YES则隐藏光标
 */
- (void)setCursorIsHidden:(BOOL)isHidden;

@end

NS_ASSUME_NONNULL_END
