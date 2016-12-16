//
//  CLPictureCell.h
//  CLImageBrowse
//
//  Created by Shining on 2016/12/16.
//  Copyright © 2016年 Shining. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CLPictureCellDelegate <NSObject>

- (void)pictureCollectionViewSingleTap;
- (void)pictureLongPressAction:(UILongPressGestureRecognizer *)longPressGesture;

@end

@interface CLPictureCell : UICollectionViewCell<UIScrollViewDelegate>

@property(nonatomic, strong) UIImageView *picImageV;
@property(nonatomic, strong) UIScrollView *scrollView;


@property (nonatomic, weak) id<CLPictureCellDelegate> cellDelegate;
+ (NSString *)reuseId;

- (void)configCellDataWithPictureImage:(NSString *)imageURL;
@end
