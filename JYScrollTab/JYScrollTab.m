//
//  JYScrollTab.m
//  JYScrollTab
//
//  Created by XJY on 2017/10/18.
//  Copyright © 2017年 JY. All rights reserved.
//

#import "JYScrollTab.h"
#import "UIView+JYTab.h"


@interface JYScrollTab () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *containerScrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *separatorImageView;

@end


@implementation JYScrollTab

#pragma mark - Public

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //add UI
        _containerScrollView = [[UIScrollView alloc] init];
        [_containerScrollView setBackgroundColor:[UIColor clearColor]];
        [_containerScrollView setDelegate:self];
        [_containerScrollView setPagingEnabled:NO];
        [self addSubview:_containerScrollView];

        _contentView = [[UIView alloc] init];
        [_contentView setBackgroundColor:[UIColor clearColor]];
        [_containerScrollView addSubview:_contentView];

        _separatorImageView = [[UIImageView alloc] init];
        [_contentView addSubview:_separatorImageView];

        //init
        _separatorHeight = 5;
        _showSeparator = YES;
        _separatorAnimated = YES;
        _animateDuration = 0.3;
        _tabs = nil;
        _selectedTabIndex = NSNotFound;

        [self setShowsHorizontalScrollIndicator:NO];
        [self setBounces:NO];
        [self setSeparatorColor:[UIColor blackColor]];
        [self setSeparatorImage:nil];
    }
    return self;
}

- (void)setShowsHorizontalScrollIndicator:(BOOL)showsHorizontalScrollIndicator {
    _showsHorizontalScrollIndicator = showsHorizontalScrollIndicator;
    [_containerScrollView setShowsHorizontalScrollIndicator:_showsHorizontalScrollIndicator];
}

- (void)setBounces:(BOOL)bounces {
    _bounces = bounces;
    [_containerScrollView setBounces:_bounces];
}

- (void)setSeparatorColor:(UIColor *)separatorColor {
    if (_separatorColor == separatorColor) {
        return;
    }
    _separatorColor = separatorColor;
    [_separatorImageView setBackgroundColor:_separatorColor];
}

- (void)setSeparatorImage:(UIImage *)separatorImage {
    if (_separatorImage == separatorImage) {
        return;
    }
    _separatorImage = separatorImage;
    [_separatorImageView setImage:_separatorImage];
}

- (void)setShowSeparator:(BOOL)showSeparator {
    if (_showSeparator == showSeparator) {
        return;
    }
    _showSeparator = showSeparator;

    [self setNeedsLayout];
}

- (void)setSeparatorHeight:(CGFloat)separatorHeight {
    if (_separatorHeight == separatorHeight) {
        return;
    }
    _separatorHeight = separatorHeight;

    [self setNeedsLayout];
}

- (void)setTabs:(NSArray<UIView *> *)tabs {
    _tabs = tabs;
    _selectedTabIndex = NSNotFound;

    //remove all tabs.
    for (UIView *subView in _contentView.subviews) {
        if (subView != _separatorImageView) {
            [subView removeFromSuperview];
        }
    }

    //add new tabs.
    Class UIControlClass = [UIControl class];
    for (UIView *tab in tabs) {
        if ([tab isKindOfClass:UIControlClass]) {
            SEL tapSEL = @selector(didTapTab:);
            if ([((UIControl *)tab).allTargets containsObject:self]) {
                [((UIControl *)tab) removeTarget:self action:tapSEL forControlEvents:UIControlEventTouchUpInside];
            }
            [((UIControl *)tab) addTarget:self action:tapSEL forControlEvents:UIControlEventTouchUpInside];
        } else if ([tab isKindOfClass:[UIView class]]) {
            [tab setUserInteractionEnabled:YES];

            if (tab.tapGesture) {
                [tab removeGestureRecognizer:tab.tapGesture];
                [tab setTapGesture:nil];
            }
            UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapTab:)];
            [tab addGestureRecognizer:tapGestureRecognizer];
            [tab setTapGesture:tapGestureRecognizer];
        } else {
            continue;
        }

        [_contentView addSubview:tab];
    }

    [self setNeedsLayout];
}

- (void)selectTab:(NSUInteger)tabIndex {
    if (tabIndex == NSNotFound) {
        return;
    }

    if (tabIndex >= _tabs.count) {
        tabIndex = _tabs.count - 1;
    }
    _selectedTabIndex = tabIndex;

    //call back
    UIView *tab = [_tabs objectAtIndex:_selectedTabIndex];

    if (_didSelectedTab) {
        _didSelectedTab(tab, _selectedTabIndex);
    }
    if (_delegate && [_delegate respondsToSelector:@selector(scrollTab:didSelectedTab:tabIndex:)]) {
        [_delegate scrollTab:self didSelectedTab:tab tabIndex:_selectedTabIndex];
    }

    //layout
    [self setNeedsLayout];
}

#pragma mark - Private

- (void)layoutSubviews {
    [super layoutSubviews];

    CGSize superSize = self.frame.size;
    if (CGSizeEqualToSize(superSize, CGSizeZero)) {
        return;
    }

    BOOL isSeparatorShown = YES;
    if (_tabs.count == 0 || !_showSeparator) {
        isSeparatorShown = NO;
    }

    //containerScrollView
    CGFloat containerScrollViewWidth = superSize.width;
    CGFloat containerScrollViewHeight = superSize.height;
    CGFloat containerScrollViewX = 0;
    CGFloat containerScrollViewY = 0;

    CGRect containerScrollViewFrame = CGRectMake(containerScrollViewX, containerScrollViewY, containerScrollViewWidth, containerScrollViewHeight);
    if (!CGRectEqualToRect(_containerScrollView.frame, containerScrollViewFrame)) {
        [_containerScrollView setFrame:containerScrollViewFrame];
    }

    CGFloat contentViewX = 0;
    CGFloat contentViewY = 0;
    CGFloat contentViewHeight = containerScrollViewHeight;
    CGFloat contentViewWidth = 0;

    CGFloat separatorImageViewX = 0;
    CGFloat separatorImageViewY = contentViewHeight - (isSeparatorShown ? _separatorHeight : 0);
    CGFloat separatorImageViewWidth = 0;
    CGFloat separatorImageViewHeight = isSeparatorShown ? _separatorHeight : 0;

    //tabs
    CGFloat tabHeight = separatorImageViewY;
    CGFloat tabX = 0;
    CGFloat tabY = 0;

    CGFloat averagedTabWidth = _tabs.count > 0 ? containerScrollViewWidth / _tabs.count : 0;
    for (NSInteger i = 0; i < _tabs.count; i++) {
        UIView *tab = [_tabs objectAtIndex:i];

        CGFloat tabWidth = 0;
        if (_widthForTab) {
            tabWidth = _widthForTab(tab, i);
        } else if (_delegate && [_delegate respondsToSelector:@selector(scrollTab:widthForTab:tabIndex:)]) {
            tabWidth = [_delegate scrollTab:self widthForTab:tab tabIndex:i];
        } else {
            tabWidth = averagedTabWidth;
        }

        if (i == _selectedTabIndex) {
            separatorImageViewX = tabX;
            separatorImageViewWidth = tabWidth;
        }

        CGRect tabFrame = CGRectMake(tabX, tabY, tabWidth, tabHeight);
        if (!CGRectEqualToRect(tab.frame, tabFrame)) {
            [tab setFrame:tabFrame];
        }

        tabX += tabWidth;
    }
    contentViewWidth = tabX;

    //contentView
    CGRect contentViewFrame = CGRectMake(contentViewX, contentViewY, contentViewWidth, contentViewHeight);
    if (!CGRectEqualToRect(_contentView.frame, contentViewFrame)) {
        [_contentView setFrame:contentViewFrame];
    }

    //separatorImageView
    CGRect separatorImageViewFrame = CGRectMake(separatorImageViewX, separatorImageViewY, separatorImageViewWidth, separatorImageViewHeight);
    if (CGRectEqualToRect(_separatorImageView.frame, CGRectZero)) {
        [_separatorImageView setFrame:separatorImageViewFrame];
    } else if (!CGRectEqualToRect(_separatorImageView.frame, separatorImageViewFrame)) {
        if (_separatorAnimated) {
            __weak typeof(self) weak_self = self;
            [UIView animateWithDuration:_animateDuration animations:^{
                [weak_self.separatorImageView setFrame:separatorImageViewFrame];
            }];
        } else {
            [_separatorImageView setFrame:separatorImageViewFrame];
        }
    }

    //content size
    CGSize contentSize = contentViewFrame.size;
    if (!CGSizeEqualToSize(_containerScrollView.contentSize, contentSize)) {
        [_containerScrollView setContentSize:contentSize];
    }
}

#pragma mark - click

- (void)didTapTab:(id)sender {
    UIView *tab = nil;
    if ([sender isKindOfClass:[UIView class]]) {
        tab = sender;
    } else if ([sender isKindOfClass:[UITapGestureRecognizer class]]) {
        tab = ((UITapGestureRecognizer *)sender).view;
    }
    [self selectTab:[_tabs indexOfObject:tab]];
}

@end
