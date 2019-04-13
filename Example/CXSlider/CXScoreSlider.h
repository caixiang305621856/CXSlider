//
//  CXScoreSlider.h
//  CXScoreSlider
//
//  Created by caixiang on 2019/4/12.
//  Copyright © 2019年 蔡翔. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CXScoreSlider : UIView

@property (nonatomic, assign) NSInteger score;

@property (nonatomic, copy) void(^reloadHandler)(CXScoreSlider *slider,NSInteger score);

@end
