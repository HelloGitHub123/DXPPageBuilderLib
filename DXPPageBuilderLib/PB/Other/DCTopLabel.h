//
//  DCTopLabel.h
//  GaiaCLP
//
//  Created by 孙全民 on 2022/6/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef enum  {
    DCVerticalAlignmentTop,
    DCVerticalAlignmentMiddle,
    DCVerticalAlignmentBottom,
} DCVerticalAlignment;

@interface DCTopLabel : UILabel{
    
@private
    DCVerticalAlignment _verticalAlignment;
}

@property (nonatomic, assign) DCVerticalAlignment verticalAlignment;
@end


NS_ASSUME_NONNULL_END
