// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "ios/chrome/browser/ui/tab_switcher/tab_switcher_panel_view.h"

#import "base/mac/scoped_nsobject.h"
#import "ios/chrome/browser/ui/tab_switcher/tab_switcher_panel_cell.h"
#import "ios/chrome/browser/ui/tab_switcher/tab_switcher_panel_collection_view_layout.h"

@interface TabSwitcherPanelView () {
  base::scoped_nsobject<UICollectionView> _collectionView;
  base::scoped_nsobject<TabSwitcherPanelCollectionViewLayout>
      _collectionViewLayout;
  TabSwitcherSessionType _sessionType;
}

@end

@implementation TabSwitcherPanelView

- (instancetype)initWithSessionType:(TabSwitcherSessionType)sessionType {
  self = [super initWithFrame:CGRectZero];
  if (self) {
    _sessionType = sessionType;
    [self loadSubviews];
  }
  return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
  NOTREACHED();
  return nil;
}

- (instancetype)initWithCoder:(NSCoder*)aDecoder {
  NOTREACHED();
  return nil;
}

- (UICollectionView*)collectionView {
  return _collectionView;
}

- (void)updateCollectionLayoutWithCompletion:(void (^)(void))completion {
  [_collectionView performBatchUpdates:nil
                            completion:^(BOOL) {
                              if (completion)
                                completion();
                            }];
}

- (CGSize)cellSize {
  return [_collectionViewLayout itemSize];
}

#pragma mark - Private

- (void)loadSubviews {
  _collectionViewLayout.reset(
      [[TabSwitcherPanelCollectionViewLayout alloc] init]);
  _collectionView.reset([[UICollectionView alloc]
             initWithFrame:self.bounds
      collectionViewLayout:_collectionViewLayout.get()]);
  if (_sessionType == TabSwitcherSessionType::DISTANT_SESSION) {
    [_collectionView registerClass:[TabSwitcherDistantSessionCell class]
        forCellWithReuseIdentifier:[TabSwitcherDistantSessionCell identifier]];
  } else {
    [_collectionView registerClass:[TabSwitcherLocalSessionCell class]
        forCellWithReuseIdentifier:[TabSwitcherLocalSessionCell identifier]];
  }
  [_collectionView setBackgroundColor:[UIColor clearColor]];
  [self addSubview:_collectionView];
  [_collectionView setAutoresizingMask:UIViewAutoresizingFlexibleHeight |
                                       UIViewAutoresizingFlexibleWidth];
}

@end
