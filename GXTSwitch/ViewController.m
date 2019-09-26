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
    GXTSwitch *gxtswitch = [[GXTSwitch alloc] initWithFrame:CGRectZero];
    self.switchView.dotDiam = 20;
    self.switchView.onColor = [UIColor redColor];
    self.switchView.offColor = [UIColor blueColor];
}


@end
