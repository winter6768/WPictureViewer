//
//  WPictureViewerCell.h
//  WPictureViewer
//
//  Created by winter on 2019/3/22.
//  Copyright © 2019 winter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPictureViewerCell : UICollectionViewCell
/// image、URL
@property(nonatomic,strong)id imageSource;

/** 双击 放大或者缩小 */
- (void)doubleTap:(CGPoint)point;

-(void)clearScale;

@end
