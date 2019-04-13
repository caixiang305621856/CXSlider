//
//  CXScoreSlider.m
//  CXScoreSlider
//
//  Created by caixiang on 2019/4/12.
//  Copyright © 2019年 蔡翔. All rights reserved.
//

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0f green:((float)((rgbValue & 0xFF00) >> 8))/255.0f blue:((float)(rgbValue & 0xFF))/255.0f alpha:1.0]

#define kMainColor UIColorFromRGB(0xFF7E00)
#define kTipsColor UIColorFromRGB(0xCCCCCC)
#define kOtherFontColor  UIColorFromRGB(0x999999)

#import "CXScoreSlider.h"
#import "UIView+Additions.h"

@interface CXScoreSlider ()

@property (nonatomic, weak) UIView *trackView;
@property (nonatomic, weak) UIImageView *thumb;
@property (nonatomic, weak) UILabel *lastTransformLable;

@end

@implementation CXScoreSlider

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        //轨道可点击视图（轨道只设置了5pt，通过这个视图增加以下点击区域）
        UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(0, (self.bounds.size.height - 40)/2.0f, self.bounds.size.width, 40)];
        [tapView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)]];
        [self addSubview:tapView];
        
        //轨道背景
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, (tapView.bounds.size.height - 8)/2.0f, tapView.bounds.size.width, 8)];
        backView.backgroundColor = kTipsColor;
        backView.layer.cornerRadius = 4.f;
        [tapView addSubview:backView];
        
        //轨道前景
        UIView *trackView = [[UIView alloc] initWithFrame:CGRectMake(0, (tapView.bounds.size.height - 8)/2.0f, tapView.bounds.size.width, 8)];
        trackView.backgroundColor = kMainColor;
        trackView.layer.cornerRadius = 4.f;
        [tapView addSubview:trackView];
        _trackView = trackView;
        
        //滑块
        UIImageView *thumb = [[UIImageView alloc] initWithFrame:CGRectMake(-37/2, (self.bounds.size.height - 37)/2.f, 37, 37)];
        [thumb setImage:[UIImage imageNamed:@"sliderImg"]];
        thumb.userInteractionEnabled = YES;
        thumb.contentMode = UIViewContentModeCenter;
        thumb.layer.masksToBounds = NO;
        [thumb addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)]];
        [self addSubview:thumb];
        _thumb = thumb;
        
        NSArray *scoreLabels =  @[@"0",@"2",@"4",@"6",@"8",@"10"];
        NSArray *scoreLabelDess =  @[@"极差",@"比较差",@"一般般",@"比较好",@"非常棒"];
        [scoreLabels enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(idx *(tapView.bounds.size.width/5.f) - 20/2.0f, tapView.center.y - 10 - 14, 20, 14)];
            la.text = obj;
            la.tag = idx *2 + 2019 ;
            la.textAlignment = NSTextAlignmentCenter;
            la.textColor = kOtherFontColor;
            la.font = [UIFont systemFontOfSize:14.f];
            [self insertSubview:la belowSubview:_thumb];
        }];
        
        [scoreLabelDess enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(idx *(tapView.bounds.size.width/5.f), tapView.center.y + 10, tapView.bounds.size.width/5.f, 14)];
            la.text = obj;
            la.tag = idx*2 + 1 + 2019;
            la.textAlignment = NSTextAlignmentCenter;
            la.textColor = kOtherFontColor;
            la.font = [UIFont systemFontOfSize:14.f];
            [self insertSubview:la belowSubview:_thumb];
        }];
        //默认 0
        self.score = 0;
    }
    
    return self;
}

- (void)setScore:(NSInteger)score {
    _score = score;
    //刷新视图
    [self reloadViewWithThumbCeneterX:score / 10.0 * self.bounds.size.width];
    //动画放大选择的效果
    [self endReloadViewWithThumbCeneterX:@(_score / 10.0 * self.bounds.size.width)];
}

//点击滑动条
- (void)handleTap:(UITapGestureRecognizer *)sender {
    //刷新视图
    [self reloadViewWithThumbCeneterX:[sender locationInView:self].x];
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self endReloadViewWithThumbCeneterX:@(_score / 10.0 * self.bounds.size.width)];
    }
}

//滑动滑块
- (void)handlePan:(UIPanGestureRecognizer *)sender {
    //获取偏移量
    CGFloat moveX = [sender translationInView:self].x;
    
    //重置偏移量，避免下次获取到的是原基础的增量
    [sender setTranslation:CGPointMake(0, 0) inView:self];
    
    //计算当前中心值
    CGFloat centerX = _thumb.centerX + moveX;
    
    //防止过度滑动
    if (centerX < 1) centerX = 1;
    if (centerX > self.bounds.size.width - 1) centerX = self.bounds.size.width - 1;
    
    //刷新视图
    [self reloadViewWithThumbCeneterX:centerX];
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self endReloadViewWithThumbCeneterX:@(_score / 10.0 * self.bounds.size.width)];
    }
}

- (void)reloadViewWithThumbCeneterX:(CGFloat)thumbCeneterX {
    if (_lastTransformLable) {
        [UIView animateWithDuration:0.25 animations:^{
            _lastTransformLable.transform = CGAffineTransformIdentity;
        }];
    }
    
    [UIView animateWithDuration:0.1 animations:^{
        //更新轨道前景色
        _trackView.frameWidth = thumbCeneterX;
        //更新滑块位置
        _thumb.centerX = thumbCeneterX;
    }];
    
    //分数，四舍五入取整
    _score = round(thumbCeneterX / self.bounds.size.width * 10);
}

- (void)endReloadViewWithThumbCeneterX:(NSNumber *)thumbCeneterX {
    [UIView animateWithDuration:0.2 animations:^{
        //更新轨道前景色
        _trackView.frameWidth = thumbCeneterX.floatValue;
        //更新滑块位置
        _thumb.centerX = thumbCeneterX.floatValue;
    }completion:^(BOOL finished) {
        !self.reloadHandler?:self.reloadHandler(self,_score);
        UILabel *la = (UILabel *)[self viewWithTag:(_score + 2019)];
        _lastTransformLable = la;
        CGFloat y = _score%2 == 1?8:-10;
        CGAffineTransform transform = CGAffineTransformMakeTranslation(0, y);
        [UIView animateWithDuration:0.25 animations:^{
            la.transform = CGAffineTransformScale(transform, 1.15, 1.15);
        }];
    }];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        for (UIView *subView in self.subviews) {
            CGPoint tp = [subView convertPoint:point fromView:self];
            if (CGRectContainsPoint(subView.bounds, tp)) {
                view = subView;
            }
        }
    }
    return view;
}

@end
