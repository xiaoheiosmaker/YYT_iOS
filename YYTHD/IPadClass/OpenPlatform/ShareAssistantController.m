//
//  BindingAssistantController.m
//  YYTHD
//
//  Created by 崔海成 on 11/7/13.
//  Copyright (c) 2013 btxkenshin. All rights reserved.
//

#import "WXApiObject.h"
#import "ShareAssistantController.h"
#import "BindingConfirmViewController.h"
#import "OpenPlatformQzoneProcesser.h"
#import "OpenPlatformRenrenProcesser.h"
#import "OpenPlatformTencentProcesser.h"
#import "OpenPlatformWechatTimelineProcesser.h"
#import "OpenPlatformWeiboProcesser.h"
#import "PlatformSelectViewController.h"
#import "YYTAlert.h"
#import "UserDataController.h"
#import "YYTPopoverBackgroundView.h"
#import "StatisticManager.h"
#import "MLItem.h"
#import "MVItem.h"
#import "MVDownloadItem.h"
#import "MLAuthor.h"
#import "NSError+YYTError.h"

NSString * const YYTBindingCompletion = @"YYTBindingCompletion";

NSString * const OPTitleWeibo = @"新浪微博";
NSString * const OPTitleQzone = @"QQ空间";
NSString * const OPTitleTencent = @"腾讯微博";
NSString * const OPTitleRenren = @"人人网";
NSString * const OPTitleWechatTimeline = @"微信朋友圈";

#define DEFAULT_MV_CONTENT @"在音悦tai iPad客户端里发现一首%@的《%@》,推荐给大家"
#define DEFAULT_ML_CONTENT @"在音悦tai iPad客户端里发现一个悦单《%@》,推荐给大家"

@interface ShareAssistantController() <UIPopoverControllerDelegate, PlatformSelectViewControllerDelegate,  AlertWithShareDelegate, YYTAlertDelegate>
{
    void (^completionBlock)(BOOL, NSError *);
}

@property (nonatomic, readonly)AlertWithShare *alertWithShare;
@property (nonatomic, readonly)NSArray *OPTitles;
@property (nonatomic) OpenPlatformType opType;
@property (nonatomic, strong, readonly) NSArray *umOpenPlatforms;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, weak) UIView *shareVC;
@property (nonatomic, copy) NSString *imageURLString;
@property (nonatomic, copy) NSString *url;

@property (nonatomic, strong)NSNumber *playlistID;
@property (nonatomic, strong)NSNumber *videoID;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *introduce;

@property (nonatomic, strong)NSMutableDictionary *openPlatformProcessers;

@property (nonatomic, strong)UIPopoverController *platformSelectController;

- (void)prepareForShare;
- (void)showBindingOrEditInViewController:(UIViewController *)container;
- (void)shareToOpenPlatform:(OpenPlatformType)opType;
- (void)chooseOpenPlatform:(id)sender;
- (void)sendStatistic;

@end

@implementation ShareAssistantController
@synthesize platformSelectController = _platformSelectController;
@synthesize alertWithShare = _alertWithShare;
+ (id)sharedInstance
{
    static ShareAssistantController *instance;
    if (!instance) {
        instance = [[super allocWithZone:nil] init];
        instance.openPlatformProcessers = [NSMutableDictionary dictionary];
        OpenPlatformQzoneProcesser *opQzone = [[OpenPlatformQzoneProcesser alloc] init];
        [instance.openPlatformProcessers setObject:opQzone
                                            forKey:opQzone.openPlatformTitle];
        OpenPlatformRenrenProcesser *opRenren = [[OpenPlatformRenrenProcesser alloc] init];
        [instance.openPlatformProcessers setObject:opRenren
                                            forKey:opRenren.openPlatformTitle];
        OpenPlatformTencentProcesser *opTencent = [[OpenPlatformTencentProcesser alloc] init];
        [instance.openPlatformProcessers setObject:opTencent
                                            forKey:opTencent.openPlatformTitle];
        OpenPlatformWechatTimelineProcesser *opWechatTimeline = [[OpenPlatformWechatTimelineProcesser alloc] init];
        [instance.openPlatformProcessers setObject:opWechatTimeline
                                            forKey:opWechatTimeline.openPlatformTitle];
        OpenPlatformWeiboProcesser *opWeibo = [[OpenPlatformWeiboProcesser alloc] init];
        [instance.openPlatformProcessers setObject:opWeibo
                                            forKey:opWeibo.openPlatformTitle];
    }
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

+ (NSString *)playlistURLWithID:(NSNumber *)keyID
{
    return [@"http://www.yinyuetai.com/playlist/" stringByAppendingFormat:@"%@", keyID];
}

+ (NSString *)videoURLWithID:(NSNumber *)keyID
{
    return [@"http://www.yinyuetai.com/video/" stringByAppendingFormat:@"%@", keyID];
}

+ (NSString *)playlistSWFURLWithID:(NSNumber *)keyID
{
    return [@"http://player.yinyuetai.com/playlist/player/" stringByAppendingFormat:@"%@/v_0.swf", keyID];
}

+ (NSString *)videoSWFURLWithID:(NSNumber *)keyID
{
    return [@"http://player.yinyuetai.com/video/player/" stringByAppendingFormat:@"%@/v_0.swf", keyID];
}

+ (NSString *)playlistURLForWechatTimeline:(NSNumber *)keyID
{
    return [@"http://mapi.yinyuetai.com/weixin/playlist?pid=" stringByAppendingFormat:@"%@", keyID];
}

+ (NSString *)videoURLForWechatTimeline:(NSNumber *)keyID
{
    return [@"http://mapi.yinyuetai.com/weixin/video?vid=" stringByAppendingFormat:@"%@", keyID];
}

- (NSArray *)OPTitles
{
    return [NSArray arrayWithObjects:OPTitleWeibo, OPTitleQzone, OPTitleTencent, OPTitleRenren, OPTitleWechatTimeline, nil];
}

- (AlertWithShare *)alertWithShare
{
    if (!_alertWithShare) {
        _alertWithShare = [[AlertWithShare alloc] initWithShareText:@""];
        _alertWithShare.delegate = self;
    }
    _alertWithShare.shareText = self.content;
    return _alertWithShare;
}

- (void)shareMLItem:(MLItem *)mlItem
     toOpenPlatform:(OpenPlatformType)opType
   inViewController:(UIViewController *)containerViewController
         completion:(void (^)(BOOL, NSError *))completion
{
    if (opType == OP_WECHATTIMELINE)
    {
        NSString *videoPath = [ShareAssistantController playlistURLForWechatTimeline:mlItem.keyID];
        NSURL *coverImage = mlItem.playListBigPic ?: mlItem.playListPic;
        __weak ShareAssistantController *weakSelf = self;
        [self loadCoverImage:coverImage completion:^(UIImage *thumbnailImage, NSError *error) {
            if (thumbnailImage)
            {
                [weakSelf shareToWXTimelineWithTitle:mlItem.title description:mlItem.author.nickName thumbnailImage:thumbnailImage videoPath:videoPath isVideo:NO];
            }
            else
            {
                if (completion)
                    completion(NO, error);
            }
        }];
        return;
    }
    
    self.content = [NSString stringWithFormat:DEFAULT_ML_CONTENT, mlItem.title];
    NSURL *imageURL = mlItem.playListBigPic ?: mlItem.coverPic;
    self.imageURLString = [imageURL absoluteString];
    self.playlistID = mlItem.keyID;
    self.title = mlItem.title;
    self.opType = opType;
    completionBlock = completion;
    [self showBindingOrEditInViewController:containerViewController];
}

- (void)shareMVItem:(MVItem *)mvItem
     toOpenPlatform:(OpenPlatformType)opType
   inViewController:(UIViewController *)containerViewController
         completion:(void (^)(BOOL, NSError *))completion
{
    if (opType == OP_WECHATTIMELINE)
    {
        __weak ShareAssistantController *weakSelf = self;
        NSString *videoPath = [ShareAssistantController videoURLForWechatTimeline:mvItem.keyID];
        
        NSURL *imageURL = [self coverImageWithMVItem:mvItem];
        
        [self loadCoverImage:imageURL completion:^(UIImage *thumbnailImage, NSError *err){
            if (thumbnailImage)
            {
                [weakSelf shareToWXTimelineWithTitle:mvItem.title
                                              description:mvItem.artistName
                                           thumbnailImage:thumbnailImage
                                                videoPath:videoPath
                                             isVideo:YES];
            }
            else
            {
                if (completion)
                    completion(NO, err);
            }
        }];
        return;
    }
    
    self.content = [NSString stringWithFormat:DEFAULT_MV_CONTENT, mvItem.artistName, mvItem.title];
    NSURL *imageURL = [self coverImageWithMVItem:mvItem];
    self.imageURLString = [imageURL absoluteString];
    self.videoID = mvItem.keyID;
    self.title = mvItem.title;
    self.opType = opType;
    completionBlock = completion;
    if (!containerViewController) containerViewController = self.rootViewController;
    [self showBindingOrEditInViewController:containerViewController];
    
}

- (NSURL *)coverImageWithMVItem:(MVItem *)mvItem
{
    NSURL *imageURL;
    if ([mvItem isKindOfClass:[MVDownloadItem class]])
    {
        MVDownloadItem *mvDownloadItem = (MVDownloadItem *)mvItem;
        imageURL = mvDownloadItem.thumbnailPic;
    }
    else
    {
        imageURL = mvItem.coverImageURL;
    }
    return imageURL;
}

- (void)loadCoverImage:(NSURL *)imageURL completion:(void (^)(UIImage *thumbnailImage, NSError *error))completion
{
    NSURLRequest *request = [NSURLRequest requestWithURL:imageURL];
    AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request imageProcessingBlock:^UIImage *(UIImage *image) {
        CGSize origImageSize = [image size];
        CGRect newRect = CGRectMake(0, 0, 150, 150);
        float ratio = MAX(newRect.size.width / origImageSize.width, newRect.size.height / origImageSize.height);
        
        UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
        CGRect projectRect;
        projectRect.size.width = ratio * origImageSize.width;
        projectRect.size.height = ratio * origImageSize.height;
        projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
        projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
        [image drawInRect:projectRect];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        return image;
    } success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        completion(image, nil);
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        completion(nil, error);
    }];
    [operation start];
}

- (void)shareToWXTimelineWithTitle:(NSString *)title
                            description:(NSString *)description
                         thumbnailImage:(UIImage *)thumbnailImage
                              videoPath:(NSString *)videoPath
                                isVideo:(BOOL)isVideo
{
    if (![WXApi isWXAppInstalled])
    {
        [AlertWithTip flashFailedMessage:@"没有安装微信"];
        return;
    }
    
    WXVideoObject *videoObject = [[WXVideoObject alloc] init];
    videoObject.videoUrl = videoPath;
    WXMediaMessage *mediaMessage = [[WXMediaMessage alloc] init];
    mediaMessage.title = title;
    if (thumbnailImage)
    {
        mediaMessage.thumbData = UIImageJPEGRepresentation(thumbnailImage, 0.7);
    }
    mediaMessage.description = description;
    mediaMessage.mediaObject = videoObject;
    SendMessageToWXReq *sendMessageToWXReq = [[SendMessageToWXReq alloc] init];
    sendMessageToWXReq.bText = NO;
    sendMessageToWXReq.scene = WXSceneTimeline;
    sendMessageToWXReq.message = mediaMessage;
    BOOL success = [WXApi sendReq:sendMessageToWXReq];
    if (isVideo)
        [MobClick event:@"Share_Mv" label:@"分享到微信朋友圈"];
    else
        [MobClick event:@"Share_Ml" label:@"分享到微信朋友圈"];
}

- (void)bindingOpenPlatform:(OpenPlatformType)opType
                    confirm:(BOOL)confirm
           inViewController:(UIViewController *)container
                 completion:(void (^)(BOOL success, NSError *error))completion
{
    if (!container) container = self.rootViewController;
    if (confirm) {
        __weak UIViewController *weakContainer = container;
        YYTAlert *alert = [[YYTAlert alloc] initWithMessage:@"您还未设置该分享帐号，要现在设置吗？" confirmBlock:^{
            [self bindingOpenPlatform:opType confirm:NO inViewController:weakContainer completion:nil];
        }];
        [alert showInView:weakContainer.view];
    } else {
        [UMSocialControllerService defaultControllerService].socialUIDelegate = self;
        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:[self.umOpenPlatforms objectAtIndex:opType]];
        snsPlatform.loginClickHandler(
                                      container,
                                      [UMSocialControllerService defaultControllerService],
                                      YES,
                                      ^(UMSocialResponseEntity *entity){
                                          if (completion) {
                                              switch (entity.responseCode) {
                                                  case UMSResponseCodeSuccess:
                                                      completion(YES, nil);
                                                      break;
                                                      
                                                  case UMSResponseCodeCancel:
                                                      break;
                                                      
                                                  default:
                                                      completion(NO, [NSError errorWithDomain:@"开放平台授权失败" code:entity.responseCode userInfo:nil]);
                                                      break;
                                              }   
                                        }
                                      }
                                      );
    }
}

- (void)unbindingOpenPlatform:(OpenPlatformType)opType
                   completion:(void (^)(BOOL, NSError *))completion
{
    [[UMSocialDataService defaultDataService] requestUnOauthWithType:[self.umOpenPlatforms objectAtIndex:opType] completion:^(UMSocialResponseEntity *entity) {
        if (completion) {
            completion(YES, nil);
        }
    }];
}

- (NSArray *)umOpenPlatforms
{
    return @[UMShareToSina, UMShareToQzone, UMShareToTencent, UMShareToRenren, UMShareToWechatTimeline];
}

- (BOOL)isOAuthInSocialPlatform:(OpenPlatformType)opType
{
    return [UMSocialAccountManager isOauthWithPlatform:[self.umOpenPlatforms objectAtIndex:opType]];
}

- (NSString *)nickNameInSocialPlatform:(OpenPlatformType)opType
{
    UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:[self.umOpenPlatforms objectAtIndex:opType]];
    return snsAccount.userName;
}

- (void)logonOpenPlatform:(NSString *)optype uid:(NSString *)opuid token:(NSString *)token
{
    [[UserDataController sharedInstance] loginForOpenPlatform:optype userID:opuid accessToken:token completionBlock:^(YYTLoginInfo *loginInfo, NSError *error) {
        if (error) {
            YYTAlert *alert = [[YYTAlert alloc] initSureWithMessage:@"登录失败，您的微博还没有绑定音悦台账号，请先前往音悦台网站进行绑定" delegate:nil];
            [alert viewShow];
            return;
        }
        [AlertWithTip flashSuccessMessage:@"登录成功"];
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:YYTBindingCompletion object:self];
}

- (void)shareToOpenPlatform:(OpenPlatformType)opType
{
    NSString *umType = [self.umOpenPlatforms objectAtIndex:opType];
    NSString *swfURL;
    NSString *url;
    if (self.playlistID) {
        swfURL = [self.delegate createSWFURLForMLID:self.playlistID];
        url = [self.delegate createURLForMLID:self.playlistID];
    } else if (self.videoID) {
        swfURL = [self.delegate createSWFURLForMVID:self.videoID];
        url = [self.delegate createURLForMVID:self.videoID];
    } else {
        // error，
        return;
    }
    
    self.content = [self.content stringByAppendingFormat:@" %@ %@ 【 音悦台HD客户端——看超清MV更过瘾。到这下载>>http://um0.cn/FCAMU8/ 】", swfURL, url];
    UMSocialUrlResource *umURLResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:self.imageURLString];
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[umType] content:self.content image:nil location:nil urlResource:umURLResource presentedController:[self rootViewController] completion:^(UMSocialResponseEntity *response) {
        if (response.responseCode == UMSResponseCodeSuccess) {
            [AlertWithTip flashSuccessMessage:@"分享成功"];
            NSString *label;
            switch (opType) {
                case OP_WEIBO:
                    label = @"分享到新浪微博";
                    break;
                case OP_QZONE:
                    label = @"分享到QQ空间";
                    break;
                case OP_TENCENT:
                    label = @"分享到腾讯微博";
                    break;
                case OP_RENREN:
                    label = @"分享到人人网";
                    break;
                case OP_WECHATTIMELINE:
                    label = @"分享到微信朋友圈";
                    break;
            }
            NSString *event;
            if (self.playlistID) event = @"Share_Ml";
            if (self.videoID) event = @"Share_Mv";
            if (event && label)
                [MobClick event:event label:label];
            
            self.playlistID = nil;
            self.videoID = nil;
            self.title = nil;
            self.introduce = nil;
            
            if (completionBlock) completionBlock(YES, nil);
        } else {
            NSDictionary *platformResponse = [[response.data allValues] objectAtIndex:0];
            int errorCode = [[platformResponse objectForKey:@"st"] intValue];
            if (errorCode == 5024 || errorCode == 5027 || errorCode == 5030) {
                [AlertWithTip flashFailedMessage:@"授权失效，需要重新绑定授权"];
            } else {
                [AlertWithTip flashFailedMessage:@"分享失败"];
            }
            if (completionBlock) completionBlock(NO, nil);
        }
        completionBlock = nil;
    }];
}

- (void)prepareForShare
{
    NSString *key = [self.OPTitles objectAtIndex:self.opType];
    self.delegate = [self.openPlatformProcessers objectForKey:key];
}

- (void)showBindingOrEditInViewController:(UIViewController *)container
{
    BOOL oauth = [self isOAuthInSocialPlatform:self.opType];
    if (!oauth) {
        [self bindingOpenPlatform:self.opType confirm:YES inViewController:container completion:nil];
    }
    else {
        [self prepareForShare];
        [container.view addSubview:self.alertWithShare];
    }
}

#pragma mark - PlatformSelectViewControllerDelegate
- (void)selectOpenPlatform:(int)opType
{
    if (self.platformSelectController) {
        // 默认分享方法，selectController由自身处理
        self.opType = opType;
        [self.platformSelectController dismissPopoverAnimated:NO];
        [self showBindingOrEditInViewController:[self rootViewController]];
        self.platformSelectController = nil;
    }
}

#pragma mark - UIPopoverControllerDelegate
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
    if (popoverController == self.platformSelectController) {
        self.platformSelectController = nil;
    }
}

- (void)sendStatistic
{
    NSString *platform;
    if (self.opType == OP_WEIBO) {
        platform = StatisticPlatformSina;
    }
    else if (self.opType == OP_QZONE) {
        platform = StatisticPlatformQzone;
    }
    else if (self.opType == OP_TENCENT) {
        platform = StatisticPlatformTencent;
    }
    else if (self.opType == OP_RENREN) {
        platform = StatisticPlatformRenren;
    }
    else if (self.opType == OP_WECHATTIMELINE) {
        platform = StatisticPlatformWechatTimeline;
    }
    NSString *contentType;
    NSNumber *content;
    if (self.playlistID) {
        contentType = StatisticContentML;
        content = self.playlistID;
    }
    else {
        contentType = StatisticContentMV;
        content = self.videoID;
    }
    [StatisticManager sendAutoStatisticToPath:ShareStatisticPath userInfo:@{StatisticPlatformInfoKey:platform, StatisticContentTypeInfoKey:contentType, StatisticContentIDInfoKey:content}];
}

#pragma mark - AlertWithShareDelegate
- (void)alertWithShare:(AlertWithShare *)alert shareText:(NSString *)shareText
{
    [self sendStatistic];
    self.shareVC = alert;
    self.content = shareText;
    [alert removeFromSuperview];
    [self shareToOpenPlatform:self.opType];
    [alert.commentTextView resignFirstResponder];
}

@end
