//
//  WPictureViewerUtil.h
//  WPictureViewer
//
//  Created by winter on 2019/3/22.
//  Copyright © 2019 winter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPictureViewerUtil : NSObject

/**
 根据图片大小返回frame

 @param imageSize CGSize
 @return CGRect
 */
+(CGRect)resizedFrameForImageSize:(CGSize)imageSize;

@end

