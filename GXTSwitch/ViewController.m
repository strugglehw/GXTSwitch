//
//  ViewController.m
//  Switch
//
//  Created by zhuoyue on 2019/9/25.
//  Copyright © 2019 zhuoyue. All rights reserved.
//

#import "ViewController.h"
#import "GXTSwitch.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet GXTSwitch *switchView;
@end

@implementation ViewController

- (void)viewDidLoad {
     
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.switchView.dotDiam = 20;
    self.switchView.onColor = [UIColor redColor];
    self.switchView.offColor = [UIColor blueColor];
    self.switchView.isOn = NO;
    self.switchView.changeBlock = ^(BOOL isOn) {
        NSLog(@"isOn is %i ",isOn);
    };
}


@end
