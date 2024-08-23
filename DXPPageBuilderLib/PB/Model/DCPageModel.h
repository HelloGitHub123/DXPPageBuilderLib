//
//  DCPageModel.h
//  GaiaCLP
//
//  Created by 李标 on 2022/6/16.
//

#import <Foundation/Foundation.h>
#import "DCPageContentModel.h"
#import "DCPageCompositionContentModel.h"

@class PageCompositionItem;

NS_ASSUME_NONNULL_BEGIN
@interface DCPageModel : NSObject

@property (nonatomic, copy) NSString *seq;
@property (nonatomic, copy) NSString *pageId;
@property (nonatomic, copy) NSString *pageName;
@property (nonatomic, copy) NSString *pageVerId;
@property (nonatomic, copy) NSString *backgroundImage;
@property (nonatomic, copy) NSString *backgroundColor;
@property (nonatomic, copy) NSString *backgroundRepeatMode;
@property (nonatomic, copy) NSString *backgroundSize;
@property (nonatomic, strong) DCPageContentModel *content;
@property (nonatomic, strong) NSArray<PageCompositionItem *> *pageCompositionList;
@end



@interface PageCompositionItem : NSObject

@property (nonatomic, copy) NSString *seq;
@property (nonatomic, copy) NSString *pageCompId;
@property (nonatomic, strong) DCPageCompositionContentModel *content;
@end
NS_ASSUME_NONNULL_END
