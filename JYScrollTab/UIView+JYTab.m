//
//  UIView+JYTab.m
//  JYScrollTab
//
//  Created by XJY on 2017/10/19.
//

#import "UIView+JYTab.h"
#import <objc/runtime.h>


@implementation UIView (JYTab)

static const void *JYTabTapGestureKey = &JYTabTapGestureKey;

- (void)setTapGesture:(UITapGestureRecognizer *)tapGesture {
    objc_setAssociatedObject(self, JYTabTapGestureKey, tapGesture, OBJC_ASSOCIATION_RETAIN);
}

- (UITapGestureRecognizer *)tapGesture {
    return objc_getAssociatedObject(self, JYTabTapGestureKey);
}

@end
