# WPictureViewer
一款自定义图片查看器，当前版本 1.0.1

cocoapods 导入   'pod WPictureViewer'

使用方法
#import "WPictureViewer.h"

  初始化：
  WPictureViewer *viewer = [WPictureViewer new];
  viewer.delegate = self;
  viewer.showIndexTitle = YES;
  viewer.currentIndex = 0;
  viewer.itemSpace = 10;
  viewer.animationType = WPictureViewerAnimationScale;
  [viewer show];


必须实现的代理方法：

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


选择实现的代理方法：

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
