//
//  ChannelView.m
//  NewsGuide
//
//  Created by zhouen on 16/9/9.
//  Copyright © 2016年 zhouen. All rights reserved.
//

#import "PTETGuideView.h"

#define GUIDE_LABEL_FONT [UIFont systemFontOfSize:15]

//左右侧 margin
#define kLRMargin 10
@interface PTETGuideView ()

@property (nonatomic ,strong) UIView *underline;

@property (nonatomic ,strong) NSMutableArray *channelLabels;

@property (nonatomic ,weak) ZNGuideLabel *selectLabel;
@property (nonatomic, strong) UIColor  *selectColor;
@property (nonatomic, assign) CGFloat allTextWidth; //所有标题总长度
@property (nonatomic, assign) CGFloat lrMargin;     //左右侧间距



@end

@implementation PTETGuideView

- (instancetype)initWithSelectColor:(UIColor *)selectColor
{
    _selectColor = selectColor;
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (instancetype)guideViewWithSelectColor:(UIColor *)selectColor {
    return [[PTETGuideView alloc] initWithSelectColor:selectColor];
}

- (void)setChannels:(NSArray <NSString *>*)channels{
    _channels = channels;
    NSArray *allWidths = [self textWidth:channels];
    CGFloat margin = (self.frame.size.width - _allTextWidth) / (_channels.count + 1);
    CGFloat x = margin;
    int i = 0;
    
    for (NSString *channel in _channels) {
        ZNGuideLabel *label = [ZNGuideLabel guideLabelWithTitle:channel];
        label.selectedColor = _selectColor;
        label.font = GUIDE_LABEL_FONT;
        label.frame = CGRectMake(x, 0, [allWidths[i] integerValue] , self.frame.size.height);
        [self addSubview:label];
        [self.channelLabels addObject:label];
        
        label.tag = i;
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(labelClick:)]];
        if (i == 0) {
            _selectLabel = label;
            label.textColor = label.selectedColor;
            CGRect rect = label.frame;
            rect.origin.y = rect.size.height - 2;
            rect.size.height = 2;
            
            _underline = [[UIView alloc] initWithFrame:rect];
            _underline.backgroundColor = label.selectedColor;
            [self addSubview:_underline];
        }
        
        x = x + [allWidths[i] integerValue] + margin;
        i++;
    }
}

- (void)labelClick:(UITapGestureRecognizer *)tap{
    ZNGuideLabel *label = (ZNGuideLabel *)tap.view;
    if (_selectLabel == label) {
        return;
    }
    _selectLabel.textColor = [UIColor blackColor];
    label.textColor = label.selectedColor;
    _selectLabel = label;
    
    if (_delegate && [_delegate respondsToSelector:@selector(guideView:didSelectIndex:)]) {
        [_delegate guideView:self didSelectIndex:label.tag];
    }
    
    CGRect rect = label.frame;
    rect.origin.y = _underline.frame.origin.y;
    rect.size.height = _underline.frame.size.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        _underline.frame = rect;
    }];
}

- (NSArray *)textWidth:(NSArray *)texts {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:texts.count];
    for (NSString *text in texts) {
        CGFloat width = [text sizeWithAttributes:@{NSFontAttributeName:GUIDE_LABEL_FONT}].width + 20;
        _allTextWidth += width;
        [array addObject:@(width)];
    }
    BOOL b = _allTextWidth > self.frame.size.width ? NO : YES;
    NSAssert(b, @"所有标题总长度大于屏幕宽度");
    return array;
}


/** 手指点击smallScrollView */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 获得索引
    NSUInteger index = scrollView.contentOffset.x / scrollView.width;
    [self p_scrollToPositionByIndex:index animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat scale = scrollView.contentOffset.x / scrollView.frame.size.width;
    if (scale < 0) {return;} // 防止在最左侧的时候，再滑，下划线位置会偏移，颜色渐变会混乱。
    
    NSUInteger leftIndex = (int)scale;
    NSUInteger rightIndex = leftIndex + 1;
    if (rightIndex >= self.channels.count) {  // 防止滑到最右，再滑，数组越界，从而崩溃
        rightIndex = self.channels.count - 1;
    }
    
    CGFloat scaleRight = scale - leftIndex;
    CGFloat scaleLeft  = 1 - scaleRight;
    
    if (scaleLeft == 1 && scaleRight == 0) {
        return;
    }
    
    ZNGuideLabel *labelLeft  = self.channelLabels[leftIndex];
    ZNGuideLabel *labelRight = self.channelLabels[rightIndex];
    
    labelLeft.scale  = scaleLeft;
    labelRight.scale = scaleRight;
    
    
    _underline.centerX = labelLeft.centerX   + (labelRight.centerX   - labelLeft.centerX)   * scaleRight;
    _underline.width   = labelLeft.textWidth + (labelRight.textWidth - labelLeft.textWidth) * scaleRight;
}

- (void)scrollToPositionByIndex:(NSUInteger)index {
    // 获得索引
    [self p_scrollToPositionByIndex:index animated:NO];

}



- (void)p_scrollToPositionByIndex:(NSUInteger)index animated:(BOOL)animated{
    
    // 滚动标题栏到中间位置
    ZNGuideLabel *label = self.channelLabels[index];
    if (_selectLabel == label) {
        return;
    }
    _selectLabel.textColor = [UIColor blackColor];
    label.textColor = label.selectedColor;
    _selectLabel = label;
    
    if (_delegate && [_delegate respondsToSelector:@selector(guideView:didSelectIndex:)]) {
        [_delegate guideView:self didSelectIndex:label.tag];
    }
    
    CGRect rect = label.frame;
    rect.origin.y = _underline.frame.origin.y;
    rect.size.height = _underline.frame.size.height;
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            _underline.frame = rect;
        }];
    } else {
        _underline.frame = rect;
    }
    
}


- (NSMutableArray *)channelLabels {
    if (!_channelLabels) {
        _channelLabels = [NSMutableArray array];
    }
    return _channelLabels;
}
@end



@implementation ZNGuideLabel

+ (instancetype)guideLabelWithTitle:(NSString *)title
{
    ZNGuideLabel *label = [self new];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14];
//    [label sizeToFit];
    label.userInteractionEnabled = YES;
    
    return label;
}

- (void)p_setLableColor {
    
    CGFloat red, green, blue, alpha;
    [self.selectedColor getRed:&red
                         green:&green
                          blue:&blue
                         alpha:&alpha];
    
    self.textColor = [UIColor colorWithRed:self.scale * red
                                     green:self.scale * green
                                      blue:self.scale * blue
                                     alpha:1];
    
}

- (CGFloat)textWidth {
    return [self.text sizeWithAttributes:@{NSFontAttributeName:self.font}].width + 20; // +10，要不太窄
}

- (void)setScale:(CGFloat)scale {
    _scale = scale;
    [self p_setLableColor];
}

- (void)setSelectedColor:(UIColor *)selectedColor {
    _selectedColor = selectedColor;
    [self p_setLableColor];
}

@end
