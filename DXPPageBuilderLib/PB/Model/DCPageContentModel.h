//
//  DCPageContentModel.h
//  GaiaCLP
//
//  Created by 李标 on 2022/6/16.
//

#import <Foundation/Foundation.h>

@class ChildrenItem;
@class Props;
@class SubProps;
@class SubChildrenItem;
@class Pictures;
@class DataSource;
@class Sheet1Pictures;
@class Sheet2Pictures;
NS_ASSUME_NONNULL_BEGIN

@interface DCPageContentModel : NSObject

@property (nonatomic, strong) Props *props;
@property (nonatomic, copy) NSString *ids;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) NSArray<ChildrenItem *> *children;
@property (nonatomic, copy) NSString *focusId;
@end


@interface Props : NSObject

@end


@interface ChildrenItem : NSObject

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *module;
@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *totalNum;
@property (nonatomic, strong) SubProps *props;
@property (nonatomic, strong) NSArray<SubChildrenItem *> *children;
@property (nonatomic, copy) NSString *ids;
@end


@interface SubProps : NSObject

@property (nonatomic, assign) BOOL visible;
@property (nonatomic, copy) NSString *menuStyle;
@property (nonatomic, copy) NSString *sheet1;
@property (nonatomic, copy) NSString *sheet2;
@property (nonatomic, copy) NSString *activeTabKey;
@property (nonatomic, strong) NSArray<Sheet1Pictures *> *sheet1Pictures;
@property (nonatomic, strong) NSArray<Sheet2Pictures *> *sheet2Pictures;
@property (nonatomic, strong) NSArray<DataSource *> *dataSource;
@property (nonatomic, assign) BOOL showTitle;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL showMore;
@property (nonatomic, copy) NSString *moreName;
@property (nonatomic, copy) NSString *direction;
@property (nonatomic, copy) NSString *repeat;
@property (nonatomic, copy) NSString *autos;
@property (nonatomic, copy) NSString *speed;
@property (nonatomic, copy) NSString *floorStyle;
@property (nonatomic, copy) NSString *slidingEffect;
@property (nonatomic, copy) NSString *moreLink;
@property (nonatomic, assign) BOOL needLogin;
@property (nonatomic, copy) NSString *publishTime;
@property (nonatomic, copy) NSString *publishType;
@property (nonatomic, copy) NSString *expireTime;
@property (nonatomic, copy) NSString *expireType;
@property (nonatomic, strong) NSArray<Pictures *> *pictures;
@end


@interface Sheet1Pictures : NSObject

@property (nonatomic, copy) NSString *src;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *width;
@property (nonatomic, copy) NSString *height;
@end



@interface Sheet2Pictures : NSObject

@end



@interface DataSource : NSObject

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *link;
@end



@interface SubChildrenItem : NSObject
@end



@interface Pictures : NSObject

@property (nonatomic, copy) NSString *src;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *width;
@property (nonatomic, copy) NSString *height;
@end

NS_ASSUME_NONNULL_END
