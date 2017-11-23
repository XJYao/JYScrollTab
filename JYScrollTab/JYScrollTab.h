//
//  JYScrollTab.h
//  JYScrollTab
//
//  Created by XJY on 2017/10/18.
//  Copyright © 2017年 JY. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JYScrollTab;

@protocol JYScrollTabDelegate <NSObject>

@optional

/**
 return width for tab.
 if not implement this method and block, width will be averaged.
 */
- (CGFloat)scrollTab:(JYScrollTab *)scrollTab widthForTab:(UIView *)tab tabIndex:(NSUInteger)tabIndex;

/**
 called when tab is selected.
 */
- (void)scrollTab:(JYScrollTab *)scrollTab didSelectedTab:(UIView *)tab tabIndex:(NSUInteger)tabIndex;

@end


@interface JYScrollTab : UIView

@property (nonatomic, weak) id<JYScrollTabDelegate> delegate;

/**
 show horizontal scroll indicator, default is NO.
 */
@property (nonatomic, assign) BOOL showsHorizontalScrollIndicator;

/**
 default is NO.
 */
@property (nonatomic, assign) BOOL bounces;

/**
 height of separator, default is 5.
 */
@property (nonatomic, assign) CGFloat separatorHeight;

/**
 separator color, default is black.
 */
@property (nonatomic, strong) UIColor *separatorColor;

/**
 separator image, default is nil.
 */
@property (nonatomic, strong) UIImage *separatorImage;

/**
 show separator, default is YES.
 if NO, separatorHeight won't be 0, it only be hidden.
 */
@property (nonatomic, assign) BOOL showSeparator;

/**
 If animating when separator be changed position, default is YES.
 */
@property (nonatomic, assign) BOOL separatorAnimated;

/**
 animate duration of separator, default is 0.3.
 */
@property (nonatomic, assign) double animateDuration;

/**
 return width for tab.
 if not implement this block and protocol method, width will be averaged.
 */
@property (nonatomic, copy, setter=widthForTab:) CGFloat (^widthForTab)(UIView *tab, NSUInteger tabIndex);

/**
 tabs with views, default is nil.
 */
@property (nonatomic, strong) NSArray<UIView *> *tabs;

/**
 index of tab which is selected.
 if no tabs, it will be NSNotFound.
 */
@property (nonatomic, assign, readonly) NSUInteger selectedTabIndex;

/**
 auto adjust selected tab to center if it can, default is YES.
 */
@property (nonatomic, assign) BOOL autoAdjustSelectedTabToCenter;

/**
 called when tab is selected.
 */
@property (nonatomic, copy, setter=didSelectedTab:) void (^didSelectedTab)(UIView *tab, NSUInteger tabIndex);

/**
 select tab with index. This will callback by 'didSelectedTab' block and protocol.
 
 @param tabIndex index of tab which will be selected.
 @return If tabIndex is NSNotFound, will return NO.
 */
- (BOOL)selectTab:(NSUInteger)tabIndex;

/**
 select tab with index. This will callback by 'didSelectedTab' block and protocol.

 @param tabIndex index of tab which will be selected.
 @param animated use animated.
 @return If tabIndex is NSNotFound, will return NO.
 */
- (BOOL)selectTab:(NSUInteger)tabIndex animated:(BOOL)animated;

/**
 select tab with index.
 
 @param tabIndex index of tab which will be selected.
 @param animated if YES, use animated.
 @param shouldCallback if NO, will not callback by 'didSelectedTab' block and protocol.
 @return If tabIndex is NSNotFound, will return NO.
 */
- (BOOL)selectTab:(NSUInteger)tabIndex animated:(BOOL)animated shouldCallback:(BOOL)shouldCallback;

@end
