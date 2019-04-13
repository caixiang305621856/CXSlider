//
//  CXViewController.m
//  CXSlider
//
//  Created by caixiang305621856 on 04/13/2019.
//  Copyright (c) 2019 caixiang305621856. All rights reserved.
//

#import "CXViewController.h"
#import "CXScoreSlider.h"

@interface CXViewController ()

@end

@implementation CXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
  __block UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 70, self.view.bounds.size.width - 30, 35)];
    titleLabel.text = @"滑动打分";
    titleLabel.font =[UIFont systemFontOfSize:35];
    [self.view addSubview:titleLabel];
    
    //滑动条
    CXScoreSlider *slider = [[CXScoreSlider alloc] initWithFrame:CGRectMake(30, 100, self.view.bounds.size.width - 60, 100)];
    slider.score = 3;
    slider.reloadHandler = ^(CXScoreSlider *slider, NSInteger score) {
        NSLog(@"-->%zd",score);
        if (score == 0) {
            titleLabel.text = @"滑动打分";
            return;
        }
         if (score <= 2) {
         titleLabel.text = @"极差";
         }else if (score <= 4) {
         titleLabel.text = @"比较差";
         }else if (score <= 6) {
         titleLabel.text = @"一般";
         }else if (score <= 8) {
         titleLabel.text = @"比较好";
         }else if (score <= 10) {
         titleLabel.text = @"非常棒";
         }
    };
    [self.view addSubview:slider];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
