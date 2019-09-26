# GXTSwitch
自定义的开关switch，可通过滑动手势和点击来修改值，可自定义点的宽度和不同状态的颜色 
使用方法
可通过代码和nib
    GXTSwitch *gxtswitch = [[GXTSwitch alloc] initWithFrame:CGRectZero];
    设置圆点的大小
    gxtswitch.dotDiam = 20;
    设置颜色
    gxtswitch.onColor = [UIColor redColor];
    gxtswitch.offColor = [UIColor blueColor];
 
 设置回调
  gxtswitch.changeBlock = ^(BOOL isOn) {
        
    };
    
![image](https://github.com/strugglehw/GXTSwitch/blob/master/2019-09-26%20170433.gif)
