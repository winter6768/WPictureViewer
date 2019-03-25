//
//  WPictureViewerCell.m
//  WPictureViewer
//
//  Created by winter on 2019/3/22.
//  Copyright © 2019 winter. All rights reserved.
//

#import "WPictureViewerCell.h"
#import "WPictureViewerUtil.h"
#if __has_include(<SDWebImage/UIImageView+WebCache.h>)
#import <SDWebImage/UIImageView+WebCache.h>
#else
#import "UIImageView+WebCache.h"
#endif

@interface WPictureViewerCell ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView *sc_image;
@property(nonatomic,strong)UIImageView *image_show;
@property(nonatomic,strong)UIActivityIndicatorView *loadingView;
@end

@implementation WPictureViewerCell
#pragma mark - life cycle
-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildSubviews];
    }
    return self;
}
#pragma mark - public methods
-(void)setImageSource:(id)imageSource {
    _imageSource = imageSource;
    if ([imageSource isKindOfClass:[UIImage class]]) {
        [self setupImage:imageSource];
        
    } else if ([imageSource isKindOfClass:[NSString class]]) {
        if ([imageSource hasPrefix:@"http"]) {
            [self loadImage];
            
        } else {
            [self setupImage:[WPictureViewerUtil wLoadFailedImage]];
        }
        
    } else {
        [self setupImage:[WPictureViewerUtil wLoadFailedImage]];
    }
}

-(void)doubleTap:(CGPoint)point {
    CGFloat scale = (self.sc_image.zoomScale == 2.0) ? 1.0 : 2.0;
    
    CGRect zoomRect;
    zoomRect.size.height = self.sc_image.frame.size.height / scale;
    zoomRect.size.width = self.sc_image.frame.size.width / scale;
    zoomRect.origin.x = point.x - zoomRect.size.width / 2.0;
    zoomRect.origin.y = point.y - zoomRect.size.height / 2.0;
    
    [self.sc_image zoomToRect:zoomRect animated:YES];
}

-(void)clearScale {
    [self.sc_image setZoomScale:1.0];
}
#pragma mark - scroll delegete
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if (scrollView != self.sc_image) {
        return;
    }
    
    CGSize scrollSize = scrollView.bounds.size;
    CGRect imgViewFrame = self.image_show.frame;
    CGSize contentSize = scrollView.contentSize;
    CGPoint centerPoint = CGPointMake(contentSize.width/2, contentSize.height/2);
    
    // 竖着长的 就是垂直居中
    if (imgViewFrame.size.width <= scrollSize.width) {
        centerPoint.x = scrollSize.width/2;
    }
    
    // 横着长的  就是水平居中
    if (imgViewFrame.size.height <= scrollSize.height) {
        centerPoint.y = scrollSize.height/2;
    }
    self.image_show.center = centerPoint;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.image_show;
}
#pragma mark - load image
-(void)loadImage {
    [self.loadingView startAnimating];

    __weak __typeof(self)weakSelf = self;
    [self.image_show sd_setImageWithURL:[NSURL URLWithString:self.imageSource]
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [weakSelf.loadingView stopAnimating];
        if (image) {
            [weakSelf setupImage:image];
            
        } else {
            [weakSelf setupImage:[WPictureViewerUtil wLoadFailedImage]];
        }
    }];
}

-(void)setupImage:(UIImage *)image {
    self.image_show.image = image;
    self.image_show.frame = [WPictureViewerUtil resizedFrameForImageSize:image.size];
    self.sc_image.contentSize = self.image_show.frame.size;
}
#pragma mark - private methods
-(void)buildSubviews {
//    sc
    self.sc_image = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.sc_image.showsVerticalScrollIndicator = NO;
    self.sc_image.showsHorizontalScrollIndicator = NO;
    self.sc_image.delegate = self;
    self.sc_image.minimumZoomScale = 1.0f;
    self.sc_image.maximumZoomScale = 2.0f;
    [self.contentView addSubview:self.sc_image];
    
//    image
    self.image_show = [[UIImageView alloc] init];
    [self.sc_image addSubview:self.image_show];
    
    self.sc_image.center = CGPointMake(self.contentView.frame.size.width / 2.0, self.contentView.frame.size.height / 2.0);
    
//    loadingview
    self.loadingView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.loadingView.frame = CGRectMake(0, 0, 50, 50);
    self.loadingView.center = self.sc_image.center;
    [self.sc_image addSubview:self.loadingView];
}

#pragma mark - getters and setters

@end
