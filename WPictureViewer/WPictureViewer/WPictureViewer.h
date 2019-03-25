//
//  WPictureViewer.h
//  WPictureViewer
//
//  Created by winter on 2019/3/22.
//  Copyright © 2019 winter. All rights reserved.
//

#import <UIKit/UIKit.h>
/// 出现、消失动画类型
typedef enum : NSUInteger {
    WPictureViewerAnimationNone,  /// 无
    WPictureViewerAnimationScale, /// 比例放大动画 需实现 -(UIImageView *)imageViewForIndex:(NSInteger)index
    WPictureViewerAnimationAlpha, /// 透明度动画
} WPictureViewerAnimationType;

@protocol WPictureViewerDelegate <NSObject>
/**
  图片总个数

 @return NSInteger
 */
-(NSInteger)numberOfItems;

/**
 对应位置的图片资源（image、URL）

 @param index 当前index
 @return 图片资源
 */
-(id)imageSourceForIndex:(NSInteger)index;

@optional
/**
 翻页

 @param index 当前index
 */
-(void)pictureViewerIndexDidChange:(NSInteger)index;

/**
 获取点击的imageview  动画显示和消失调用

 @param index 当前index
 @return UIImageView
 */
-(UIImageView *)imageViewForIndex:(NSInteger)index;

@end


@interface WPictureViewer : UIView
/// 图片间距
@property(nonatomic,assign)CGFloat itemSpace;
/// 当前图片位置
@property(nonatomic,assign)NSInteger currentIndex;
/// 是否显示标题 默认不显示
@property(nonatomic,assign)BOOL showIndexTitle;
/// delegate
@property(nonatomic,weak)id<WPictureViewerDelegate>delegate;
/// 动画类型
@property(nonatomic,assign)WPictureViewerAnimationType animationType;

-(void)show;

@end
