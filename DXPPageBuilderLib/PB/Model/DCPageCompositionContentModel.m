//
//  DCPageCompositionContentModel.m
//  GaiaCLP
//
//  Created by 李标 on 2022/6/16.
//

#import "DCPageCompositionContentModel.h"

@implementation DCPageCompositionContentModel

+(NSDictionary *)mj_objectClassInArray{
    return @{
        @"children" : [CompositionChildrenItem class],
       
    };
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"ids":@"id",
    };
}
@end



@implementation CompositionProps

+ (NSDictionary *)mj_objectClassInArray{
    return @{
        @"pictures" : [PicturesItem class],
        @"dataSource" : [NewsDataSource class],
        @"sheet1Pictures" : [PicturesItem class],
        @"sheet2Pictures" : [PicturesItem class],
        @"logoInfo": [PicturesItem class],
        @"sidebarInfo": [PicturesItem class],
        @"accountIcon": [AccountIconItem class],
        @"uploadIcon": [UploadIconItem class],
        @"downloadIcon" : [DownloadIconItem class],
        @"circlePhoneIcon": [PicturesItem class],
        @"circleChangeIcon": [PicturesItem class],
        @"circleSmsIcon": [PicturesItem class],
        @"circleDataIcon": [PicturesItem class],
        @"circleVoiceIcon": [PicturesItem class],
        @"backInfo": [PicturesItem class],
        @"accountPictures":[PicturesItem class],
        @"accountChangePictures":[PicturesItem class],
        @"dashLeftPictures":[PicturesItem class],
        @"dashRightPictures":[PicturesItem class],
    };
}

@end


@implementation ObjFocus

@end



@implementation PicturesItem

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"ids":@"id",
    };
}

@end



@implementation NewsDataSource

@end




@implementation CompositionChildrenItem

@end


@implementation BgImg

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"bgFWBImg":@"bgImg"
    };
}

@end

@implementation AccountIconItem

@end


@implementation UploadIconItem

@end


@implementation DownloadIconItem


@end

@implementation SkipInfo


@end


@implementation UpperBtnInfo


@end


@implementation LowerBtnInfo


@end

@implementation LeftQuickLinkInfo


@end


@implementation RightQuickLinkInfo


@end
