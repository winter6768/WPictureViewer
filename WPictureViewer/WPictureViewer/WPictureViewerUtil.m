//
//  WPictureViewerUtil.m
//  WPictureViewer
//
//  Created by winter on 2019/3/22.
//  Copyright © 2019 winter. All rights reserved.
//

#import "WPictureViewerUtil.h"

@implementation WPictureViewerUtil

+(CGRect)resizedFrameForImageSize:(CGSize)imageSize {
    if (CGSizeEqualToSize(imageSize, CGSizeZero)) {
        return [UIScreen mainScreen].bounds;
    }
    
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGFloat targetX = 0;
    CGFloat targetY = 0;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    
    CGFloat scale_w = imageSize.width / size.width;
    CGFloat scale_h = imageSize.height / size.height;
    
    if (scale_w < 1 && scale_h < 1) {
        targetWidth = imageSize.width;
        targetHeight = imageSize.height;
        
    } else if (scale_w >= scale_h) {
        targetWidth = size.width;
        targetHeight = imageSize.height / scale_w;
        
    } else {
        targetHeight = size.height;
        targetWidth = imageSize.width / scale_h;
    }
    
    targetX = (size.width - targetWidth) / 2.0;
    targetY = (size.height - targetHeight) / 2.0;
    
    return CGRectMake(targetX, targetY, targetWidth, targetHeight);
}

@end
