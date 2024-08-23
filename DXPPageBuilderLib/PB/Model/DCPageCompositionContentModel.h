//
//  DCPageCompositionContentModel.h
//  GaiaCLP
//
//  Created by 李标 on 2022/6/16.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class CompositionProps;
@class CompositionChildrenItem;
@class PicturesItem;
@class NewsDataSource;
@class BgImg;
@class AccountIconItem;
@class UploadIconItem;
@class DownloadIconItem;
@class DBBoardingSetting;
@class DBPointsSetting;
@class SkipInfo;
@class UpperBtnInfo;
@class LowerBtnInfo;
@class LeftQuickLinkInfo;
@class RightQuickLinkInfo;
@class ObjFocus;

NS_ASSUME_NONNULL_BEGIN

@interface DCPageCompositionContentModel : NSObject

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *module;
@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *totalNum;
@property (nonatomic, strong) CompositionProps *props;
@property (nonatomic, strong) NSArray<CompositionChildrenItem *> *children;
@property (nonatomic, copy) NSString *ids;
@end



@interface CompositionProps : NSObject

@property (nonatomic, copy) NSString *floorName;

@property (nonatomic, assign) BOOL visible;
@property (nonatomic, assign) BOOL showTitle;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL showMore;
@property (nonatomic, copy) NSString *moreName;
@property (nonatomic, copy) NSString *moreLink;
@property (nonatomic, copy) NSString *moreLinkType;
@property (nonatomic, strong) NSArray<PicturesItem *> *pictures;
@property (nonatomic, copy) NSString *needLogin;
@property (nonatomic, copy) NSString *titleColor;
@property (nonatomic, assign) CGFloat titleColorOpacity;
@property (nonatomic, copy) NSString *dataColor;
@property (nonatomic, assign) CGFloat dataColorOpacity;
@property (nonatomic, copy) NSString *quickAccessColor;
@property (nonatomic, copy) NSString *switchFontColor;
@property (nonatomic, assign) CGFloat switchFontColorOpacity;
@property (nonatomic, copy) NSString *switchFontBgColor;
@property (nonatomic, assign) CGFloat switchFontBgColorOpacity;
@property (nonatomic, copy) NSString *fontHighLigntColor;
@property (nonatomic, assign) CGFloat fontHighLigntColorOpacity;
@property (nonatomic, copy) NSString *fontColor;
@property (nonatomic, assign) CGFloat fontColorOpacity;
@property (nonatomic, copy) NSString *dataTitleColor;
@property (nonatomic, assign) CGFloat dataTitleColorOpacity;
@property (nonatomic, copy) NSString *dataHighlightColor;
@property (nonatomic, assign) CGFloat dataHighlightColorOpacity;
@property (nonatomic, copy) NSString *dataBottomColor;
@property (nonatomic, assign) CGFloat dataBottomColorOpacity;
@property (nonatomic, copy) NSString *callsTitleColor;
@property (nonatomic, assign) CGFloat callsTitleColorOpacity;
@property (nonatomic, copy) NSString *callsHighlightColor;
@property (nonatomic, assign) CGFloat callsHighlightColorOpacity;
@property (nonatomic, copy) NSString *callsBottomColor;
@property (nonatomic, assign) CGFloat callsBottomColorOpacity;
@property (nonatomic, copy) NSString *smsTitleColor;
@property (nonatomic, assign) CGFloat smsTitleColorOpacity;
@property (nonatomic, copy) NSString *smsHighlightColor;
@property (nonatomic, assign) CGFloat smsHighlightColorOpacity;;
@property (nonatomic, copy) NSString *smsBottomColor;
@property (nonatomic, assign) CGFloat smsBottomColorOpacity;
@property (nonatomic, copy) NSString *phoneNumberColor;
@property (nonatomic, assign) CGFloat phoneNumberColorOpacity;
@property (nonatomic, copy) NSString *phoneNumberBgColor;
@property (nonatomic, assign) CGFloat phoneNumberBgColorOpacity;

@property (nonatomic, copy) NSString *balOrBillColor;
@property (nonatomic, assign) CGFloat balOrBillColorOpacity;
@property (nonatomic, copy) NSString *balOrBillLinkColor;
@property (nonatomic, assign) CGFloat balOrBillLinkColorOpacity;

@property (nonatomic, copy) NSString *arrowIconColor;
@property (nonatomic, assign) CGFloat arrowIconColorOpacity;
@property (nonatomic, strong) ObjFocus *objFocus;

@property (nonatomic, copy) NSString *expireTimeFormat;
@property (nonatomic, copy) NSString *publishTimeFormat;

@property (nonatomic, copy) NSString *balanceColor;
@property (nonatomic, assign) CGFloat balanceColorOpacity;
@property (nonatomic, copy) NSString *buyColor;
@property (nonatomic, assign) CGFloat buyColorOpacity;
@property (nonatomic, copy) NSString *pointsColor;
@property (nonatomic, assign) CGFloat pointsColorOpacity;

@property (nonatomic, strong) NSArray *phoneIcon;
@property (nonatomic, strong) NSArray *changeIcon;
@property (nonatomic, strong) NSArray *pointsIcon;

/// 金刚区属性
@property (nonatomic, copy) NSString *menuStyle;
@property (nonatomic, copy) NSString *sheet1;
@property (nonatomic, copy) NSString *sheet2;
@property (nonatomic, copy) NSString *activeTabKey;
@property (nonatomic, strong) NSArray<PicturesItem *> *sheet1Pictures;
@property (nonatomic, strong) NSArray<PicturesItem *> *sheet2Pictures;

//
@property (nonatomic, copy) NSString *msgName;
///
      
@property (nonatomic, copy) NSString *publishTime;
@property (nonatomic, copy) NSString *publishType;
@property (nonatomic, copy) NSString *expireTime;
@property (nonatomic, copy) NSString *expireType;
// HotNews
@property (nonatomic, strong) NSArray<NewsDataSource *> *dataSource;
// FloorPoster
@property (nonatomic, strong) NSString *floorStyle;
@property (nonatomic, strong) NSArray *floorPictures;
@property (nonatomic, strong) NSString *slidingEffect;
//
@property (nonatomic, assign) CGFloat topMargin;
@property (nonatomic, copy) NSString *hasBackground;
@property (nonatomic, strong) PicturesItem *bgImg;

@property (nonatomic, assign) CGFloat titleFontSize;
@property (nonatomic, copy) NSString *titleFontColor;
@property (nonatomic, assign) CGFloat titleFontColorOpacity;

@property (nonatomic, assign) CGFloat staticTitleFontSize;
@property (nonatomic, copy) NSString *staticTitleFontColor;
@property (nonatomic, assign) CGFloat staticTitleFontColorOpacity;

// 背景色
@property (nonatomic, copy) NSString *hasBg;
@property (nonatomic, copy) NSString *bgColorOpacity;


@property (nonatomic, copy) NSString *componentBgColor;
@property (nonatomic, copy) NSString *backgroundType; // color  image

@property (nonatomic, copy) NSString *groupSetting;
@property (nonatomic, copy) NSString *profileSetting;
@property (nonatomic, copy) NSString *targetLabel;

@property (nonatomic, strong) SkipInfo *skipInfo;
@property (nonatomic, strong) UpperBtnInfo *upperBtnInfo;
@property (nonatomic, strong) LowerBtnInfo *lowerBtnInfo;
@property (nonatomic, strong) LeftQuickLinkInfo *leftQuickLinkInfo;
@property (nonatomic, strong) RightQuickLinkInfo *rightQuickLinkInfo;

@property (nonatomic, copy) NSString *themeType; // DB的主题类型
@property (nonatomic, copy) NSString *dashboardType;  // DB类型

// toolbar的 bg
@property (nonatomic, copy) NSString *toolbarBgStyle;  // 沉浸式标题栏 “IE”
@property (nonatomic, copy) NSString *hasToolbarBg;
@property (nonatomic, copy) NSString *toolbarBg;
@property (nonatomic, assign) NSInteger toolbarBgOpacity;

@property (nonatomic, assign) bool immersive; // 沉浸式  只有banner需要单独设置
// DB 跳转配置
@property (nonatomic, strong) NSArray *infoList;

@property (nonatomic, strong) NSArray *viewDetailPic;

@property (nonatomic, strong) NSArray *balIcon;
@property (nonatomic, strong) NSArray *billIcon;

@property (nonatomic,copy) NSString *repeat;
@property (nonatomic,copy) NSString *speed;
@property (nonatomic,copy) NSString *Autos;
@property (nonatomic, copy) NSString *btnUrl;
@property (nonatomic, copy) NSString *msgInfo;
@property (nonatomic, assign) CGFloat horizontalOutterMargin;
@property (nonatomic, assign) CGFloat adRatio;
@property (nonatomic, assign) bool showDesc;
@property (nonatomic, copy) NSString *desc;
// 背景类型 Color: 颜色   Image:图片
@property (nonatomic, copy) NSString *bgType;
@property (nonatomic, copy) NSString *bgColor;
@property (nonatomic, strong) BgImg *bgFWBImg;
@property (nonatomic, strong) NSArray <AccountIconItem *> *accountIcon;
@property (nonatomic, strong) NSArray <UploadIconItem *> *uploadIcon;
@property (nonatomic, strong) NSArray <DownloadIconItem *> *downloadIcon;
@property (nonatomic, copy) NSString *accountNumColor; // 右上角号码颜色
@property (nonatomic, copy) NSString *accountNumColorOpacity;
@property (nonatomic, copy) NSString *accountInfoBgColor; // 右上角号码背景色
@property (nonatomic, copy) NSString *accountInfoBgColorOpacity;
@property (nonatomic, copy) NSString *dashTextColor;// dash中间的静态文本颜色
@property (nonatomic, copy) NSString *dashTextColorOpacity;
@property (nonatomic, copy) NSString *subInfoColor;// dash中间接口数据文本颜色
@property (nonatomic, copy) NSString *subInfoColorOpacity;
@property (nonatomic, copy) NSString *speedStaticColor;// 下面速度框的静态文本
@property (nonatomic, copy) NSString *speedStaticColorOpacity;
@property (nonatomic, copy) NSString *speedInfoColor;// 下面速度框的接口文本
@property (nonatomic, copy) NSString *speedInfoColorOpacity;
@property (nonatomic, copy) NSString *speedBgColor;// 下面速度框的背景色
@property (nonatomic, copy) NSString *speedBgColorOpacity;
@property (nonatomic, copy) NSString *downloadIconColor;//下载图片颜色
@property (nonatomic, copy) NSString *downloadIconColorOpacity;
@property (nonatomic, copy) NSString *lineColor;
@property (nonatomic, copy) NSString *lineColorOpacity;
@property (nonatomic, copy) NSString * uploadIconColor;//上传图片颜色
@property (nonatomic, copy) NSString *uploadIconColorOpacity;
@property (nonatomic, copy) NSString *bottomMargin;
@property (nonatomic, copy) NSString *speedTextColor;

@property (nonatomic, copy) NSString * uploadIconBgColorOpacity;
@property (nonatomic, copy) NSString * uploadIconBgColor;
@property (nonatomic, copy) NSString * downloadIconBgColorOpacity;
@property (nonatomic, copy) NSString * downloadIconBgColor;
@property (nonatomic, copy) NSString * uploadBgColorOpacity;
@property (nonatomic, copy) NSString * uploadBgColor;
@property (nonatomic, copy) NSString * downloadBgColorOpacity;
@property (nonatomic, copy) NSString * downloadBgColor;
@property (nonatomic, copy) NSString * mainIconColor;


@property (nonatomic, strong) NSArray<PicturesItem*> *accountPictures;  // 头部icon和name
@property (nonatomic, strong) NSArray<PicturesItem*> *accountChangePictures;  // 头部切换账号icon
@property (nonatomic, strong) NSArray<PicturesItem*> *dashLeftPictures;  // 下方左侧图片
@property (nonatomic, strong) NSArray<PicturesItem*> *dashRightPictures;  // 下方右侧图片
///
@property (nonatomic, strong) NSArray<PicturesItem*> *sidebarInfo; //
@property (nonatomic, strong) NSArray<PicturesItem*> *logoInfo; //
@property (nonatomic, copy) NSString *hasSidebar;
@property (nonatomic, copy) NSString *hasLogo;

@property (nonatomic, copy) NSString *position; // 标题 位置

@property (nonatomic, copy) NSString *isCountdownbg;
@property (nonatomic, copy) NSString *countdownBg;


@property (nonatomic, copy) NSString *showPoints; // 是否展示积分
@property (nonatomic, strong) DBBoardingSetting *onBoardingSetting;  // 开户跳转设置
@property (nonatomic, strong) DBPointsSetting *onPointsSetting;  // 积分跳转配置

@property (nonatomic, strong) NSArray *pointsAmountIcon;

// circle  样式
@property (nonatomic, copy) NSString *circleDataColor; // '#000000', // 手机号码，余额，日期，流量余额，语音余额，短信余额，总量
@property (nonatomic, assign) CGFloat circleDataColorOpacity; //  100,
@property (nonatomic, copy) NSString *circleStaticColor; //#000000', // 如remaining data等，下面的total等不变的内容
@property (nonatomic, assign) CGFloat circleStaticColorOpacity; // 100,

//
@property (nonatomic, strong) NSArray<PicturesItem*> *circlePhoneIcon; // 上边左侧phone
@property (nonatomic, strong) NSArray<PicturesItem*> *circleChangeIcon; // 上边右侧切换账户icon
@property (nonatomic, strong) NSArray<PicturesItem*> *circleSmsIcon;// sms icon
@property (nonatomic, strong) NSArray<PicturesItem*> *circleDataIcon;// data icon
@property (nonatomic, strong) NSArray<PicturesItem*> *circleVoiceIcon;// voice icon

@property (nonatomic, copy) NSString *smsBgType; // bg的类型  'Color',
@property (nonatomic, copy) NSString *smsBgColor; //  '#ffffff',
@property (nonatomic, strong) BgImg *smsBgImg;
@property (nonatomic, copy) NSString *dataBgType; // : 'Color', // bg的类型
@property (nonatomic, copy) NSString *dataBgColor; //  '#ffffff',
@property (nonatomic, strong) BgImg *dataBgImg;
@property (nonatomic, copy) NSString *voiceBgType; // 'Color', // bg的类型
@property (nonatomic, copy) NSString *voiceBgColor; // '#ffffff',
@property (nonatomic, strong) BgImg *voiceBgImg;

//
@property (nonatomic, copy) NSString *dashCardBgType; // 'Color', // Dashboard Card 背景类型 新增
@property (nonatomic, strong) BgImg *dashCardBgImg; // Dashboard Card 背景图 新增
@property (nonatomic, copy) NSString *circleCardColor; //  '#000000',
@property (nonatomic, copy) NSString *circleCardColorOpacity; // 100,

@property (nonatomic, copy) NSString *dashBgType; // 'Color', // Dashboard Background 背景类型 新增
@property (nonatomic, strong) BgImg *dashBgImg; // Dashboard Background 背景图 新增
@property (nonatomic, copy) NSString *circleDashBgColor; //  '#000000',
@property (nonatomic, copy) NSString *circleDashBgColorOpacity; // 100,

@property (nonatomic, copy) NSString *dashBottomBgType;  // Dashboard Bottom Background 背景类型 新增
@property (nonatomic, strong) BgImg *dashBottomBgImg;// Dashboard Bottom Background 背景图 新增
@property (nonatomic, copy) NSString *circleBottomBgColor; // '#000000',
@property (nonatomic, copy) NSString *circleBottomBgColorOpacity; // 100,

// 返回按钮
@property (nonatomic, copy) NSString *hasBack; // @"Y" @"N"
@property (nonatomic, strong) NSArray<PicturesItem*> *backInfo;

// 流量球点击事件
/*** "dataAreaType":"1",
 "dataAreaTypeId":"",
 "dataAreaTypeUrl":"/clp_purchase/index"*/
@property (nonatomic, strong)  NSDictionary *dataAreaSetting;
/*** "SMSAreaType":"1",
 "SMSAreaTypeId":"",
 "SMSAreaTypeUrl":"/clp_notification/index"*/
@property (nonatomic, strong)  NSDictionary *SMSAreaSetting;
/*** "voiceAreaType":"1",
 "voiceAreaTypeId":"",
 "voiceAreaTypeUrl":"/clp_mybillv2/index"*/
@property (nonatomic, strong)  NSDictionary *voiceAreaSetting;

@end



@interface ObjFocus : NSObject

@property (nonatomic, copy) NSString *titleFocus;
@property (nonatomic, copy) NSString *staticFocus;
@end


@interface SkipInfo : NSObject

@property (nonatomic, assign) BOOL isShow; // 是否展示skip
@property (nonatomic, copy) NSString *name; // skip文案
@property (nonatomic, copy) NSString *linkType;// skip跳转类型
@property (nonatomic, copy) NSString *linkUrl;// skip跳转url
@property (nonatomic, copy) NSString *linkId;// skip跳转id（小程序）
@property (nonatomic, copy) NSString *textColor;// skip文字颜色
@property (nonatomic, copy) NSString *textColorOpacity;// 透明度
@end

// 上方按钮信息
@interface UpperBtnInfo : NSObject

@property (nonatomic, assign) BOOL isShow; // 是否展示按钮
@property (nonatomic, copy) NSString *name; // 上方按钮文案
@property (nonatomic, copy) NSString *linkType;// 上方按钮跳转类型
@property (nonatomic, copy) NSString *linkUrl;// 上方按钮跳转url
@property (nonatomic, copy) NSString *linkId;// 上方按钮跳转id（小程序）
@property (nonatomic, copy) NSString *textColor;// 上方按钮文字颜色
@property (nonatomic, copy) NSString *textColorOpacity;// 透明度
@property (nonatomic, copy) NSString *bgColor;// 按钮背景色
@property (nonatomic, copy) NSString *bgColorOpacity;
@end

// 下方按钮信息
@interface LowerBtnInfo : NSObject

@property (nonatomic, assign) BOOL isShow; // 是否展示按钮
@property (nonatomic, copy) NSString *name; // 下方按钮文案
@property (nonatomic, copy) NSString *linkType;// 下方按钮跳转类型
@property (nonatomic, copy) NSString *linkUrl;// 下方按钮跳转url
@property (nonatomic, copy) NSString *linkId;// 下方按钮跳转id（小程序）
@property (nonatomic, copy) NSString *textColor;// 下方按钮文字颜色
@property (nonatomic, copy) NSString *textColorOpacity;// 透明度
@property (nonatomic, copy) NSString *bgColor;// 按钮背景色
@property (nonatomic, copy) NSString *bgColorOpacity;
@end

// 左侧快速链接信息
@interface LeftQuickLinkInfo : NSObject

@property (nonatomic, assign) BOOL isShow; // 是否展示按钮
@property (nonatomic, copy) NSString *name; // 左方按钮文案
@property (nonatomic, copy) NSString *linkType;// 左方按钮跳转类型
@property (nonatomic, copy) NSString *linkUrl;// 左方按钮跳转url
@property (nonatomic, copy) NSString *linkId;// 左方按钮跳转id（小程序）
@property (nonatomic, copy) NSString *textColor;// 左方按钮文字颜色
@property (nonatomic, copy) NSString *textColorOpacity; // 透明度
@end

@interface RightQuickLinkInfo : NSObject

@property (nonatomic, assign) BOOL isShow; // 是否展示按钮
@property (nonatomic, copy) NSString *name; // 右方按钮文案
@property (nonatomic, copy) NSString *linkType;// 右方按钮跳转类型
@property (nonatomic, copy) NSString *linkUrl;// 右方按钮跳转url
@property (nonatomic, copy) NSString *linkId;// 右方按钮跳转id（小程序）
@property (nonatomic, copy) NSString *textColor;// 右方按钮文字颜色
@property (nonatomic, copy) NSString *textColorOpacity; // 透明度
@end

@interface DBBoardingSetting : NSObject
@property (nonatomic, copy) NSString *onBoardingType; // 类型
@property (nonatomic, copy) NSString *onBoardingTypeId; // 为小程序时，输入的id
@property (nonatomic, copy) NSString *onBoardingTypeUrl; // 链接

@end


@interface DBPointsSetting : NSObject
@property (nonatomic, copy) NSString *onPointsType; // 类型
@property (nonatomic, copy) NSString *onPointsTypeId; // 为小程序时，输入的id
@property (nonatomic, copy) NSString *onPointsTypeUrl; // 链接
@end


@interface PicturesItem : NSObject

@property (nonatomic, copy) NSString *src;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *linkType;
@property (nonatomic, copy) NSString *linkId;
@property (nonatomic, copy) NSString *ids;

@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *moreBtnName;
@property (nonatomic, copy) NSString *miniVideoSrc; // 这个视频src  是必有的。
@property (nonatomic, copy) NSString *standardVideoSrc; // 视频标准src
@property (nonatomic, copy) NSString *videoPosterSrc; // 海报
@property (nonatomic, copy) NSString *videoTitle; // 描述
@property (nonatomic, copy) NSString *videoDesc;

@property (nonatomic, copy) NSString *videoBtnName; // 首页按钮
@property (nonatomic, copy) NSString *videoBtnLink; // 首页按钮跳转
@property (nonatomic, copy) NSString *videoBtnLinkType; //  首页按钮跳转类型
@property (nonatomic, copy) NSString *videoBtnLinkId;
@property (nonatomic, copy) NSString *videoCTAName;  // 全屏按钮名称
@property (nonatomic, copy) NSString *videoCTALink;  // 全屏按钮跳转链接
@property (nonatomic, copy) NSString *videoCTALinkType;
@property (nonatomic, copy) NSString *videoCTALinkId;
@property (nonatomic, copy) NSString *closable;
@property (nonatomic, copy) NSString *showDetailPage; // 是否展示详情页
@property (nonatomic, copy) NSString *needLogin; // 是否需要登录



@end


@interface NewsDataSource : NSObject

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *link;
@end


@interface CompositionChildrenItem : NSObject

@end

@interface BgImg : NSObject

@property (nonatomic, copy) NSString *src;
@property (nonatomic, copy) NSString *width;
@property (nonatomic, copy) NSString *height;
@end

@interface AccountIconItem : NSObject

@property (nonatomic, copy) NSString *width;
@property (nonatomic, copy) NSString *height;
@property (nonatomic, copy) NSString *src;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *linkType;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *linkId;
@end

@interface UploadIconItem : NSObject

@property (nonatomic, copy) NSString *width;
@property (nonatomic, copy) NSString *height;
@property (nonatomic, copy) NSString *src;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *linkType;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *linkId;
@end


@interface DownloadIconItem : NSObject

@property (nonatomic, copy) NSString *width;
@property (nonatomic, copy) NSString *height;
@property (nonatomic, copy) NSString *src;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *linkType;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *linkId;
@end


NS_ASSUME_NONNULL_END
