//
//  CustomSwitch.m
//  School
//
//  Created by Gong Xintao on 2019/4/24.
//  Copyright © 2019 Gong Xintao. All rights reserved.
//

#import "GXTSwitch.h"
@interface GXTSwitch()<UIGestureRecognizerDelegate>
{
    UIImageView *imageview;  
    UIView *potView;//y开关圆圈
    CGPoint touchPoint;
    BOOL canPan;
    CGPoint startPoint;
    CGPoint tapPoint;
    BOOL finishChange;
    BOOL isPaning;
}

@end

@implementation GXTSwitch

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
//        [self addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}
-(void)setup
{
    self.onColor = [UIColor lightGrayColor];
    self.offColor = [UIColor greenColor];
    self.layer.borderColor = [self.offColor CGColor];
    self.backgroundColor = [UIColor clearColor];
    //拖动收拾
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGuesture:)];
    panGesture.delegate = self;
    [self addGestureRecognizer:panGesture];
    //点击a手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    tapGesture.delegate = self;
    [self addGestureRecognizer:tapGesture];
    
    //        self.layer.borderColor = [];
    //
    //圆圈
    //
    self.layer.borderWidth = 2.0f;
//    potView = [[UIView alloc]initWithFrame:CGRectMake(frame.size.width-18, y, 12, 12)];
    self.dotDiam = 12;//直径默认12
    potView = [UIView new];
    [self addSubview:potView];
    self.userInteractionEnabled = YES;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width =  CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    self.layer.cornerRadius = height/2;
    potView.backgroundColor = self.offColor;
    potView.layer.cornerRadius =  self.dotDiam/2;
    CGFloat y =  (height-self.dotDiam)/2;
    potView.frame = CGRectMake(width-self.dotDiam-(self.dotDiam/2), y, self.dotDiam, self.dotDiam);
}
-(IBAction)tapGesture:(UITapGestureRecognizer*)sender
{
    CGPoint point = [sender locationInView:self];
    
    tapPoint = point;
    double y = (self.frame.size.height - self.dotDiam)/2;
    CGFloat width =  CGRectGetWidth(self.bounds);
    //设置左边点击区域，点击该区域将把值设置为左边选项的值
    CGRect rect1 = CGRectInset(CGRectMake(self.dotDiam/2, y, self.dotDiam, self.dotDiam), -(width/4),  -(width/4)) ;
    CGFloat maxX = width-self.dotDiam-(self.dotDiam/2);
    //设置右边点击区域，点击该区域将把值设置为右边选项的值
    CGRect rect2 = CGRectInset(CGRectMake(maxX, y, self.dotDiam, self.dotDiam),  -(width/4),  -(width/4));
    self.layer.borderColor = [self.offColor CGColor];
    if (CGRectContainsPoint(rect1, tapPoint)||CGRectContainsPoint(rect2, tapPoint)) {
        finishChange = YES;
        [self adjustView:tapPoint];
    }
}
-(void)setIsOn:(BOOL)isOn
{
    _isOn = isOn;
    CGFloat width =  CGRectGetWidth(self.bounds);
    CGSize size = self.frame.size;
    CGPoint point = CGPointZero;
    if (isOn) {
         point = CGPointMake(size.width/2+(width/4), 0);
    }
    CGRect potFrame = potView.frame;
    if (point.x>size.width/2) {
        potFrame.origin.x = size.width-self.dotDiam-(self.dotDiam/2);
        
        
        self.layer.borderColor = [self.offColor CGColor];
        potView.backgroundColor = self.offColor;
    }else{
        potFrame.origin.x = self.dotDiam/2;
  
        
        self.layer.borderColor = [self.onColor CGColor];
        potView.backgroundColor = self.onColor;
    }
    potView.frame = potFrame;
}
-(void)adjustView:(CGPoint)point
{
    CGSize size = self.frame.size;
    CGRect potFrame = potView.frame;
    if (point.x>size.width/2) {
        potFrame.origin.x = size.width-self.dotDiam-(self.dotDiam/2);
        self.isOn = YES;
        
        self.layer.borderColor = [self.offColor CGColor];
        potView.backgroundColor = self.offColor;
    }else{
        potFrame.origin.x = self.dotDiam/2;
        self.isOn = NO;
        
        self.layer.borderColor = [self.onColor CGColor];
        potView.backgroundColor = self.onColor;
    }
    if (self.changeBlock) {
        self.changeBlock(self.isOn);
    }
    potView.frame = potFrame;
}
-(void)click:(UIControl*)sender
{
    if (finishChange) {
        return;
    }
    
    CGFloat width =  CGRectGetWidth(self.bounds);
    CGFloat space = width/4;
    double y = (self.frame.size.height - self.dotDiam)/2;
    CGRect rect1 = CGRectInset(CGRectMake(self.dotDiam/2, y, self.dotDiam, self.dotDiam), -space, -space) ;
    CGFloat maxX = self.frame.size.width-self.dotDiam-(self.dotDiam/2);
    CGRect rect2 = CGRectInset(CGRectMake(maxX, y, self.dotDiam, self.dotDiam), -space, -space);
    if (CGRectContainsPoint(rect1, tapPoint)||CGRectContainsPoint(rect2, tapPoint)) {
        finishChange = YES;
        [self adjustView:tapPoint];
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    CGPoint point = [touch locationInView:self];
    tapPoint = point;
    if (CGRectContainsPoint(potView.frame, point)) {
        finishChange = NO;
        startPoint = potView.frame.origin;
        canPan = YES;
        isPaning = YES;
    }
    return YES;
}
-(void)panGuesture:(UIPanGestureRecognizer*)guesture
{
    CGPoint point =  [guesture translationInView:self];
//    NSLog(@"%s  velocPointt is %@",__func__,NSStringFromCGPoint(velocPointt));
    if (guesture.state==UIGestureRecognizerStateBegan){
        isPaning = YES;
        startPoint = potView.frame.origin;
        NSLog(@"%s  UIGestureRecognizerStateBegan point is %@",__func__,NSStringFromCGPoint(point));
    }else
    if (guesture.state==UIGestureRecognizerStateRecognized)
    {
        [self adjustView:point];
        isPaning = NO;
    }else if (guesture.state==UIGestureRecognizerStateCancelled)
    {
        NSLog(@"%s UIGestureRecognizerStateCancelled",__func__);
        
        [self adjustView:point];
        isPaning = NO;
    }else if (guesture.state==UIGestureRecognizerStateChanged)
    {
        CGSize size = self.frame.size;
        CGRect potFrame = potView.frame;
        finishChange= YES;
        CGFloat potX = point.x;
        if (point.x>0) {
            potX = point.x+startPoint.x;
            CGFloat maxX = size.width-self.dotDiam-(self.dotDiam/2);
            potX = MIN(maxX, potX);
        }else{
            NSLog(@" UIGestureRecognizerStateChanged point is %@ startPoint is %@",NSStringFromCGPoint(point),NSStringFromCGPoint(startPoint));//147
            potX = point.x+startPoint.x;
            potX = MAX(potX, self.dotDiam/2) ;
        }
        potFrame.origin.x = potX;
        potView.frame = potFrame;
        isPaning = YES;
        
    }
}
@end
