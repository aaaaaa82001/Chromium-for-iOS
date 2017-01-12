// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "ios/chrome/browser/ui/suggestions/suggestions_collection_updater.h"

#import "ios/chrome/browser/ui/collection_view/collection_view_controller.h"
#import "ios/chrome/browser/ui/collection_view/collection_view_model.h"
#import "ios/chrome/browser/ui/suggestions/suggestions_item.h"

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "This file requires ARC support."
#endif

namespace {
typedef NS_ENUM(NSInteger, ItemType) {
  ItemTypeText = kItemTypeEnumZero,
  ItemTypeArticle,
  ItemTypeExpand,
};

}  // namespace

@implementation SuggestionsCollectionUpdater {
  CollectionViewController* _collectionViewController;
}

- (instancetype)initWithCollectionViewController:
    (CollectionViewController*)collectionViewController {
  self = [super init];
  if (self) {
    _collectionViewController = collectionViewController;
    [collectionViewController loadModel];
    CollectionViewModel* model = collectionViewController.collectionViewModel;
    NSInteger sectionIdentifier = kSectionIdentifierEnumZero;
    for (NSInteger i = 0; i < 3; i++) {
      [model addSectionWithIdentifier:sectionIdentifier];
      [model addItem:[[SuggestionsItem alloc] initWithType:ItemTypeText
                                                     title:@"The title"
                                                  subtitle:@"The subtitle"]
          toSectionWithIdentifier:sectionIdentifier];
      sectionIdentifier++;
    }
  }
  return self;
}

#pragma mark - Public methods

- (void)addTextItem:(NSString*)title
           subtitle:(NSString*)subtitle
          toSection:(NSInteger)inputSection {
  SuggestionsItem* item = [[SuggestionsItem alloc] initWithType:ItemTypeText
                                                          title:title
                                                       subtitle:subtitle];
  NSInteger sectionIdentifier = kSectionIdentifierEnumZero + inputSection;
  NSInteger sectionIndex = inputSection;
  CollectionViewModel* model = _collectionViewController.collectionViewModel;
  if ([model numberOfSections] <= inputSection) {
    sectionIndex = [model numberOfSections];
    sectionIdentifier = kSectionIdentifierEnumZero + sectionIndex;
    [_collectionViewController.collectionView performBatchUpdates:^{
      [_collectionViewController.collectionViewModel
          addSectionWithIdentifier:sectionIdentifier];
      [_collectionViewController.collectionView
          insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]];
    }
                                                       completion:nil];
  }
  NSInteger numberOfItemsInSection =
      [model numberOfItemsInSection:sectionIndex];
  [_collectionViewController.collectionViewModel addItem:item
                                 toSectionWithIdentifier:sectionIdentifier];
  [_collectionViewController.collectionView performBatchUpdates:^{
    [_collectionViewController.collectionView
        insertItemsAtIndexPaths:@[ [NSIndexPath
                                    indexPathForRow:numberOfItemsInSection
                                          inSection:sectionIndex] ]];
  }
                                                     completion:nil];
}

@end