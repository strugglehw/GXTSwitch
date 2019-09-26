//
//  CustomSwitch.h
//  School
//
//  Created by Gong Xintao on 2019/4/24.
//  Copyright © 2019 Gong Xintao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^SwitchChange) (BOOL isOn);
@interface GXTSwitch : UIControl
@property (copy, nonatomic)SwitchChange changeBlock;
@property (assign,nonatomic) BOOL isOn; 
@property (copy, nonatomic)UIColor *onColor;
@property (copy, nonatomic)UIColor *offColor;
@property (assign, nonatomic)CGFloat dotDiam;//开关圆圈的直径 
@end

NS_ASSUME_NONNULL_END
