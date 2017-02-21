// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "ios/chrome/browser/ui/reading_list/reading_list_coordinator.h"

#include "base/metrics/histogram_macros.h"
#include "base/metrics/user_metrics.h"
#include "base/metrics/user_metrics_action.h"
#include "components/reading_list/ios/reading_list_model.h"
#include "ios/chrome/browser/browser_state/chrome_browser_state.h"
#include "ios/chrome/browser/favicon/ios_chrome_large_icon_service_factory.h"
#include "ios/chrome/browser/reading_list/offline_url_utils.h"
#include "ios/chrome/browser/reading_list/reading_list_download_service.h"
#include "ios/chrome/browser/reading_list/reading_list_download_service_factory.h"
#include "ios/chrome/browser/reading_list/reading_list_model_factory.h"
#import "ios/chrome/browser/ui/alert_coordinator/action_sheet_coordinator.h"
#import "ios/chrome/browser/ui/reading_list/reading_list_collection_view_item.h"
#import "ios/chrome/browser/ui/reading_list/reading_list_toolbar.h"
#import "ios/chrome/browser/ui/reading_list/reading_list_view_controller.h"
#import "ios/chrome/browser/ui/url_loader.h"
#import "ios/chrome/browser/ui/util/pasteboard_util.h"
#include "ios/chrome/grit/ios_strings.h"
#include "ios/web/public/referrer.h"
#include "ui/base/l10n/l10n_util.h"
#include "ui/strings/grit/ui_strings.h"
#include "url/gurl.h"

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "This file requires ARC support."
#endif

namespace {
// Action chosen by the user in the context menu, for UMA report.
// These match tools/metrics/histograms/histograms.xml.
enum UMAContextMenuAction {
  // The user opened the entry in a new tab.
  NEW_TAB = 0,
  // The user opened the entry in a new incognito tab.
  NEW_INCOGNITO_TAB = 1,
  // The user copied the url of the entry.
  COPY_LINK = 2,
  // The user chose to view the offline version of the entry.
  VIEW_OFFLINE = 3,
  // The user cancelled the context menu.
  CANCEL = 4,
  // Add new enum above ENUM_MAX.
  ENUM_MAX
};
}

@interface ReadingListCoordinator ()

@property(nonatomic, assign) ios::ChromeBrowserState* browserState;
// Used to load the Reading List pages.
@property(nonatomic, weak) id<UrlLoader> URLLoader;
@property(nonatomic, strong) ReadingListViewController* containerViewController;
@property(nonatomic, strong) AlertCoordinator* alertCoordinator;

// Opens |URL| in a new tab |incognito| or not.
- (void)openNewTabWithURL:(const GURL&)URL incognito:(BOOL)incognito;

// Opens the offline url |offlineURL| of the entry saved in the reading list
// model with the |entryURL| url.
- (void)openOfflineURL:(const GURL&)offlineURL
                      correspondingEntryURL:(const GURL&)entryURL
    fromReadingListCollectionViewController:
        (ReadingListCollectionViewController*)
            readingListCollectionViewController;

@end

@implementation ReadingListCoordinator

@synthesize alertCoordinator = _alertCoordinator;
@synthesize containerViewController = _containerViewController;
@synthesize URLLoader = _URLLoader;
@synthesize browserState = _browserState;

- (instancetype)initWithBaseViewController:(UIViewController*)viewController
                              browserState:
                                  (ios::ChromeBrowserState*)browserState
                                    loader:(id<UrlLoader>)loader {
  self = [super initWithBaseViewController:viewController];
  if (self) {
    _browserState = browserState;
    _URLLoader = loader;
  }
  return self;
}

#pragma mark - ChromeCoordinator

- (void)start {
  if (!self.containerViewController) {
    ReadingListModel* model =
        ReadingListModelFactory::GetInstance()->GetForBrowserState(
            self.browserState);
    favicon::LargeIconService* largeIconService =
        IOSChromeLargeIconServiceFactory::GetForBrowserState(self.browserState);
    ReadingListDownloadService* readingListDownloadService =
        ReadingListDownloadServiceFactory::GetInstance()->GetForBrowserState(
            self.browserState);

    ReadingListToolbar* toolbar = [[ReadingListToolbar alloc] init];
    ReadingListCollectionViewController* collectionViewController =
        [[ReadingListCollectionViewController alloc]
                         initWithModel:model
                      largeIconService:largeIconService
            readingListDownloadService:readingListDownloadService
                               toolbar:toolbar];
    collectionViewController.delegate = self;

    self.containerViewController = [[ReadingListViewController alloc]
        initWithCollectionViewController:collectionViewController
                                 toolbar:toolbar];
    self.containerViewController.delegate = self;
  }

  [self.baseViewController presentViewController:self.containerViewController
                                        animated:YES
                                      completion:nil];
}

- (void)stop {
  [self.containerViewController.presentingViewController
      dismissViewControllerAnimated:YES
                         completion:nil];

  self.containerViewController = nil;
}

#pragma mark - ReadingListCollectionViewControllerDelegate

- (void)dismissReadingListCollectionViewController:
    (ReadingListCollectionViewController*)readingListCollectionViewController {
  [readingListCollectionViewController willBeDismissed];
  [self stop];
}

- (void)readingListCollectionViewController:
            (ReadingListCollectionViewController*)
                readingListCollectionViewController
                  displayContextMenuForItem:
                      (ReadingListCollectionViewItem*)readingListItem
                                    atPoint:(CGPoint)menuLocation {
  if (!self.containerViewController) {
    return;
  }

  const ReadingListEntry* entry =
      readingListCollectionViewController.readingListModel->GetEntryByURL(
          readingListItem.url);

  if (!entry) {
    [readingListCollectionViewController reloadData];
    return;
  }
  const GURL entryURL = entry->URL();

  __weak ReadingListCoordinator* weakSelf = self;

  _alertCoordinator = [[ActionSheetCoordinator alloc]
      initWithBaseViewController:self.containerViewController
                           title:readingListItem.text
                         message:readingListItem.detailText
                            rect:CGRectMake(menuLocation.x, menuLocation.y, 0,
                                            0)
                            view:readingListCollectionViewController
                                     .collectionView];

  NSString* openInNewTabTitle =
      l10n_util::GetNSString(IDS_IOS_CONTENT_CONTEXT_OPENLINKNEWTAB);
  [_alertCoordinator
      addItemWithTitle:openInNewTabTitle
                action:^{
                  [weakSelf openNewTabWithURL:entryURL incognito:NO];
                  UMA_HISTOGRAM_ENUMERATION("ReadingList.ContextMenu", NEW_TAB,
                                            ENUM_MAX);

                }
                 style:UIAlertActionStyleDefault];

  NSString* openInNewTabIncognitoTitle =
      l10n_util::GetNSString(IDS_IOS_CONTENT_CONTEXT_OPENLINKNEWINCOGNITOTAB);
  [_alertCoordinator
      addItemWithTitle:openInNewTabIncognitoTitle
                action:^{
                  UMA_HISTOGRAM_ENUMERATION("ReadingList.ContextMenu",
                                            NEW_INCOGNITO_TAB, ENUM_MAX);
                  [weakSelf openNewTabWithURL:entryURL incognito:YES];
                }
                 style:UIAlertActionStyleDefault];

  NSString* copyLinkTitle =
      l10n_util::GetNSString(IDS_IOS_CONTENT_CONTEXT_COPY);
  [_alertCoordinator
      addItemWithTitle:copyLinkTitle
                action:^{
                  UMA_HISTOGRAM_ENUMERATION("ReadingList.ContextMenu",
                                            COPY_LINK, ENUM_MAX);
                  StoreURLInPasteboard(entryURL);
                }
                 style:UIAlertActionStyleDefault];

  if (entry->DistilledState() == ReadingListEntry::PROCESSED) {
    GURL offlineURL = reading_list::OfflineURLForPath(
        entry->DistilledPath(), entryURL, entry->DistilledURL());
    NSString* viewOfflineVersionTitle =
        l10n_util::GetNSString(IDS_IOS_READING_LIST_CONTENT_CONTEXT_OFFLINE);
    [_alertCoordinator
        addItemWithTitle:viewOfflineVersionTitle
                  action:^{
                    UMA_HISTOGRAM_ENUMERATION("ReadingList.ContextMenu",
                                              VIEW_OFFLINE, ENUM_MAX);
                    [weakSelf openOfflineURL:offlineURL
                                          correspondingEntryURL:entryURL
                        fromReadingListCollectionViewController:
                            readingListCollectionViewController];
                  }
                   style:UIAlertActionStyleDefault];
  }

  [_alertCoordinator
      addItemWithTitle:l10n_util::GetNSString(IDS_APP_CANCEL)
                action:^{
                  UMA_HISTOGRAM_ENUMERATION("ReadingList.ContextMenu", CANCEL,
                                            ENUM_MAX);
                }
                 style:UIAlertActionStyleCancel];

  [_alertCoordinator start];
}

- (void)
readingListCollectionViewController:
    (ReadingListCollectionViewController*)readingListCollectionViewController
                           openItem:
                               (ReadingListCollectionViewItem*)readingListItem {
  const ReadingListEntry* entry =
      readingListCollectionViewController.readingListModel->GetEntryByURL(
          readingListItem.url);

  if (!entry) {
    [readingListCollectionViewController reloadData];
    return;
  }

  base::RecordAction(base::UserMetricsAction("MobileReadingListOpen"));

  [self.URLLoader loadURL:entry->URL()
                 referrer:web::Referrer()
               transition:ui::PAGE_TRANSITION_AUTO_BOOKMARK
        rendererInitiated:NO];

  [self stop];
}

#pragma mark - Private

- (void)openOfflineURL:(const GURL&)offlineURL
                      correspondingEntryURL:(const GURL&)entryURL
    fromReadingListCollectionViewController:
        (ReadingListCollectionViewController*)
            readingListCollectionViewController {
  [readingListCollectionViewController willBeDismissed];

  [self openNewTabWithURL:offlineURL incognito:NO];

  UMA_HISTOGRAM_BOOLEAN("ReadingList.OfflineVersionDisplayed", true);
  const GURL updateURL = entryURL;
  readingListCollectionViewController.readingListModel->SetReadStatus(updateURL,
                                                                      true);
}

- (void)openNewTabWithURL:(const GURL&)URL incognito:(BOOL)incognito {
  base::RecordAction(base::UserMetricsAction("MobileReadingListOpen"));

  [self.URLLoader webPageOrderedOpen:URL
                            referrer:web::Referrer()
                          windowName:nil
                         inIncognito:incognito
                        inBackground:NO
                            appendTo:kLastTab];

  [self stop];
}

@end