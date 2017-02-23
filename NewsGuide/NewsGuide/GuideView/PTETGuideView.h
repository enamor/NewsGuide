//
//  ChannelView.h
//  NewsGuide
//
//  Created by zhouen on 16/9/9.
//  Copyright © 2016年 zhouen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Extension.h"

@class PTETGuideView;
@protocol  GuideViewDelegate<NSObject>

-(void)guideView:(PTETGuideView *)guideView didSelectIndex:(NSUInteger)index;

@end
@interface PTETGuideView : UIView

@property (strong, nonatomic) NSArray <NSString *>*channels;

@property (weak, nonatomic) id<GuideViewDelegate> delegate;

+ (instancetype)guideViewWithSelectColor:(UIColor *)selectColor;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
- (void)scrollToPositionByIndex:(NSUInteger)index;

@end



@interface ZNGuideLabel : UILabel

@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) CGFloat textWidth;
@property (nonatomic, strong) UIColor *selectedColor;

+ (instancetype)guideLabelWithTitle:(NSString *)title;

@end
