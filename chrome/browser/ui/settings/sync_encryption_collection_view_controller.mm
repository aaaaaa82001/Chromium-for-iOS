// Copyright 2013 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "ios/chrome/browser/ui/settings/sync_encryption_collection_view_controller.h"

#include "base/ios/weak_nsobject.h"
#import "base/mac/scoped_nsobject.h"
#include "base/strings/sys_string_conversions.h"
#include "components/browser_sync/profile_sync_service.h"
#include "components/google/core/browser/google_util.h"
#include "components/strings/grit/components_strings.h"
#include "components/sync/base/sync_prefs.h"
#include "ios/chrome/browser/application_context.h"
#include "ios/chrome/browser/browser_state/chrome_browser_state.h"
#include "ios/chrome/browser/chrome_url_constants.h"
#include "ios/chrome/browser/sync/ios_chrome_profile_sync_service_factory.h"
#import "ios/chrome/browser/ui/collection_view/cells/MDCCollectionViewCell+Chrome.h"
#import "ios/chrome/browser/ui/collection_view/cells/collection_view_footer_item.h"
#import "ios/chrome/browser/ui/collection_view/cells/collection_view_item.h"
#import "ios/chrome/browser/ui/collection_view/collection_view_model.h"
#import "ios/chrome/browser/ui/settings/cells/encryption_item.h"
#import "ios/chrome/browser/ui/settings/settings_utils.h"
#import "ios/chrome/browser/ui/settings/sync_create_passphrase_collection_view_controller.h"
#import "ios/chrome/browser/ui/settings/sync_encryption_passphrase_collection_view_controller.h"
#include "ios/chrome/grit/ios_strings.h"
#include "ui/base/l10n/l10n_util_mac.h"
#include "url/gurl.h"

namespace {

typedef NS_ENUM(NSInteger, SectionIdentifier) {
  SectionIdentifierEncryption = kSectionIdentifierEnumZero,
  SectionIdentifierFooter,
};

typedef NS_ENUM(NSInteger, ItemType) {
  ItemTypeAccount = kItemTypeEnumZero,
  ItemTypePassphrase,
  ItemTypeFooter,
};

}  // namespace

@interface SyncEncryptionCollectionViewController () {
  ios::ChromeBrowserState* _browserState;
}
// Returns an account item.
- (CollectionViewItem*)accountItem;

// Returns a passphrase item.
- (CollectionViewItem*)passphraseItem;

// Returns a footer item with a link.
- (CollectionViewItem*)footerItem;
@end

@implementation SyncEncryptionCollectionViewController

- (instancetype)initWithBrowserState:(ios::ChromeBrowserState*)browserState {
  DCHECK(browserState);
  self = [super initWithStyle:CollectionViewControllerStyleAppBar];
  if (self) {
    self.title = l10n_util::GetNSString(IDS_IOS_SYNC_ENCRYPTION_TITLE);
    _browserState = browserState;
    [self loadModel];
  }
  return self;
}

#pragma mark - SettingsRootCollectionViewController

- (void)loadModel {
  [super loadModel];
  CollectionViewModel* model = self.collectionViewModel;

  [model addSectionWithIdentifier:SectionIdentifierEncryption];
  [model addItem:[self accountItem]
      toSectionWithIdentifier:SectionIdentifierEncryption];
  [model addItem:[self passphraseItem]
      toSectionWithIdentifier:SectionIdentifierEncryption];

  browser_sync::ProfileSyncService* service =
      IOSChromeProfileSyncServiceFactory::GetForBrowserState(_browserState);
  if (service->IsEngineInitialized() && service->IsUsingSecondaryPassphrase()) {
    [model addSectionWithIdentifier:SectionIdentifierFooter];
    [model addItem:[self footerItem]
        toSectionWithIdentifier:SectionIdentifierFooter];
  }
}

#pragma mark - Items

- (CollectionViewItem*)accountItem {
  DCHECK(browser_sync::ProfileSyncService::IsSyncAllowedByFlag());
  BOOL checkedAndEnabled = YES;
  browser_sync::ProfileSyncService* service =
      IOSChromeProfileSyncServiceFactory::GetForBrowserState(_browserState);
  if (service->IsEngineInitialized() && service->IsUsingSecondaryPassphrase()) {
    checkedAndEnabled = NO;
  }
  NSString* text = l10n_util::GetNSString(IDS_SYNC_BASIC_ENCRYPTION_DATA);
  return [self itemWithType:ItemTypeAccount
                       text:text
                    checked:checkedAndEnabled
                    enabled:checkedAndEnabled];
}

- (CollectionViewItem*)passphraseItem {
  DCHECK(browser_sync::ProfileSyncService::IsSyncAllowedByFlag());
  BOOL checked = NO;
  BOOL enabled = NO;
  browser_sync::ProfileSyncService* service =
      IOSChromeProfileSyncServiceFactory::GetForBrowserState(_browserState);
  if (service->IsEngineInitialized() && service->IsUsingSecondaryPassphrase()) {
    checked = YES;
  } else {
    enabled = YES;
  }
  NSString* text = l10n_util::GetNSString(IDS_SYNC_FULL_ENCRYPTION_DATA);
  return [self itemWithType:ItemTypePassphrase
                       text:text
                    checked:checked
                    enabled:enabled];
}

- (CollectionViewItem*)footerItem {
  CollectionViewFooterItem* footerItem = [[[CollectionViewFooterItem alloc]
      initWithType:ItemTypeFooter] autorelease];
  footerItem.text =
      l10n_util::GetNSString(IDS_IOS_SYNC_ENCRYPTION_PASSPHRASE_HINT);
  footerItem.linkURL = google_util::AppendGoogleLocaleParam(
      GURL(kSyncGoogleDashboardURL),
      GetApplicationContext()->GetApplicationLocale());
  footerItem.linkDelegate = self;
  return footerItem;
}

#pragma mark - MDCCollectionViewStylingDelegate

- (MDCCollectionViewCellStyle)collectionView:(UICollectionView*)collectionView
                         cellStyleForSection:(NSInteger)section {
  NSInteger sectionIdentifier =
      [self.collectionViewModel sectionIdentifierForSection:section];
  switch (sectionIdentifier) {
    case SectionIdentifierFooter:
      // Display the Learn More footer in the default style with no "card" UI
      // and no section padding.
      return MDCCollectionViewCellStyleDefault;
    default:
      return self.styler.cellStyle;
  }
}

- (BOOL)collectionView:(UICollectionView*)collectionView
    shouldHideItemBackgroundAtIndexPath:(NSIndexPath*)indexPath {
  NSInteger sectionIdentifier =
      [self.collectionViewModel sectionIdentifierForSection:indexPath.section];
  switch (sectionIdentifier) {
    case SectionIdentifierFooter:
      // Display the Learn More footer without any background image or
      // shadowing.
      return YES;
    default:
      return NO;
  }
}

- (CGFloat)collectionView:(UICollectionView*)collectionView
    cellHeightAtIndexPath:(NSIndexPath*)indexPath {
  CollectionViewItem* item =
      [self.collectionViewModel itemAtIndexPath:indexPath];
  return [MDCCollectionViewCell
      cr_preferredHeightForWidth:CGRectGetWidth(collectionView.bounds)
                         forItem:item];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView*)collectionView
    didSelectItemAtIndexPath:(NSIndexPath*)indexPath {
  [super collectionView:collectionView didSelectItemAtIndexPath:indexPath];
  DCHECK_EQ(indexPath.section,
            [self.collectionViewModel
                sectionForSectionIdentifier:SectionIdentifierEncryption]);

  CollectionViewItem* item =
      [self.collectionViewModel itemAtIndexPath:indexPath];
  if ([item respondsToSelector:@selector(isEnabled)] &&
      ![item performSelector:@selector(isEnabled)]) {
    // Don't perform any action if the cell isn't enabled.
    return;
  }

  switch (item.type) {
    case ItemTypePassphrase: {
      DCHECK(browser_sync::ProfileSyncService::IsSyncAllowedByFlag());
      browser_sync::ProfileSyncService* service =
          IOSChromeProfileSyncServiceFactory::GetForBrowserState(_browserState);
      if (service->IsEngineInitialized() &&
          !service->IsUsingSecondaryPassphrase()) {
        base::scoped_nsobject<SyncCreatePassphraseCollectionViewController>
            controller([[SyncCreatePassphraseCollectionViewController alloc]
                initWithBrowserState:_browserState]);
        [self.navigationController pushViewController:controller animated:YES];
      }
      break;
    }
    case ItemTypeAccount:
    case ItemTypeFooter:
    default:
      break;
  }
}

#pragma mark - Private methods

- (CollectionViewItem*)itemWithType:(NSInteger)type
                               text:(NSString*)text
                            checked:(BOOL)checked
                            enabled:(BOOL)enabled {
  EncryptionItem* item =
      [[[EncryptionItem alloc] initWithType:type] autorelease];
  item.text = text;
  item.accessoryType = checked ? MDCCollectionViewCellAccessoryCheckmark
                               : MDCCollectionViewCellAccessoryNone;
  item.enabled = enabled;
  return item;
}

@end
