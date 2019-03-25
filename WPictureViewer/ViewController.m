//
//  ViewController.m
//  WPictureViewer
//
//  Created by winter on 2019/3/22.
//  Copyright © 2019 winter. All rights reserved.
//

#import "ViewController.h"
#import "WPictureViewer/WPictureViewer.h"

@interface ViewController ()<WPictureViewerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (int i = 0; i < 5; i ++) {
        
        UIImageView *image = [UIImageView new];
        image.frame = CGRectMake(5 + 65 * i, 100, 60, 60);
        image.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i + 1]];
        image.contentMode = UIViewContentModeScaleAspectFill;
        image.clipsToBounds = YES;
        image.tag = i + 700;
        image.userInteractionEnabled = YES;
        [image addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)]];
        [self.view addSubview:image];
    }
    
    for (int i = 5; i < 7; i ++) {
        
        UIImageView *image = [UIImageView new];
        image.frame = CGRectMake(5 + 65 * (i - 5), 200, 60, 60);
        image.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i + 1]];
        image.contentMode = UIViewContentModeScaleAspectFill;
        image.clipsToBounds = YES;
        image.tag = i + 700;
        image.userInteractionEnabled = YES;
        [image addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)]];
        [self.view addSubview:image];
    }
}

-(void)imageTap:(UITapGestureRecognizer *)tap {
    WPictureViewer *viewer = [WPictureViewer new];
    viewer.delegate = self;
    viewer.showIndexTitle = YES;
    viewer.currentIndex = tap.view.tag - 700;
    viewer.itemSpace = 10;
    viewer.animationType = WPictureViewerAnimationScale;
    [viewer show];
}

- (id)imageSourceForIndex:(NSInteger)index {
//    return @"http://pic75.nipic.com/file/20150821/9448607_145742365000_2.jpg";
    return [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",(int)index + 1]];
}

- (NSInteger)numberOfItems {
    return 7;
}

-(UIImageView *)imageViewForIndex:(NSInteger)index {
    return [self.view viewWithTag:index + 700];
}

-(void)pictureViewerIndexDidChange:(NSInteger)index {
    NSLog(@"pictureViewerIndexDidChange: %ld",index);
}

@end
