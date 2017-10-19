//
//  ViewController.m
//  JYScrollTabDemo
//
//  Created by XJY on 2017/10/18.
//  Copyright © 2017年 JY. All rights reserved.
//

#import "ViewController.h"

#import <JYScrollTab/JYScrollTab.h>


@interface ViewController ()

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    JYScrollTab *scrollTab = [[JYScrollTab alloc] init];
    [scrollTab setBackgroundColor:[UIColor redColor]];
    [scrollTab setShowSeparator:YES];
    [scrollTab setSeparatorHeight:1];
    [scrollTab setSeparatorColor:[UIColor greenColor]];
    [scrollTab setSeparatorAnimated:YES];
    [scrollTab setAnimateDuration:0.5];
    [self.view addSubview:scrollTab];
    [scrollTab setFrame:CGRectMake(10, 100, 300, 50)];

    NSArray *titles = @[ @"test1", @"test2", @"test3", @"test4", @"test5", @"test6", @"test7", @"test8", @"test9", @"test10", @"test11", @"test12" ];
    NSMutableArray *buttons = @[].mutableCopy;

    for (NSString *title in titles) {
        //uiview
        UILabel *label = [[UILabel alloc] init];
        [label setBackgroundColor:[UIColor yellowColor]];
        [label setText:title];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setTextColor:[UIColor blackColor]];
        [buttons addObject:label];

        //button
        //        UIButton *button = [[UIButton alloc] init];
        //        [button setBackgroundColor:[UIColor greenColor]];
        //        [button setTitle:title forState:UIControlStateNormal];
        //        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //        [buttons addObject:button];
    }

    NSArray *widths = @[ @(60), @(90), @(150) ];
    [scrollTab widthForTab:^CGFloat(UIView *tab, NSUInteger tabIndex) {
        if (tabIndex < widths.count) {
            return [[widths objectAtIndex:tabIndex] floatValue];
        } else {
            return 50;
        }
    }];

    [scrollTab didSelectedTab:^(UIView *tab, NSUInteger tabIndex) {
        NSLog(@"select tab at Index : %d", (int)tabIndex);
    }];

    [scrollTab setTabs:buttons];

    [scrollTab selectTab:1];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
