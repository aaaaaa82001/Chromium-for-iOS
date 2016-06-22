# Copyright 2016 The Chromium Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

{
  'targets': [
    {
      'target_name': 'EarlGrey',
      'type': 'shared_library',
      'mac_bundle': 1,
      'sources': [
        'src/EarlGrey/Action/GREYAction.h',
        'src/EarlGrey/Action/GREYActionBlock.h',
        'src/EarlGrey/Action/GREYActionBlock.m',
        'src/EarlGrey/Action/GREYActions.h',
        'src/EarlGrey/Action/GREYActions.m',
        'src/EarlGrey/Action/GREYBaseAction.m',
        'src/EarlGrey/Action/GREYChangeStepperAction.h',
        'src/EarlGrey/Action/GREYChangeStepperAction.m',
        'src/EarlGrey/Action/GREYPathGestureUtils.h',
        'src/EarlGrey/Action/GREYPathGestureUtils.m',
        'src/EarlGrey/Action/GREYPickerAction.h',
        'src/EarlGrey/Action/GREYPickerAction.m',
        'src/EarlGrey/Action/GREYScrollAction.h',
        'src/EarlGrey/Action/GREYScrollAction.m',
        'src/EarlGrey/Action/GREYScrollActionError.m',
        'src/EarlGrey/Action/GREYScrollToContentEdgeAction.h',
        'src/EarlGrey/Action/GREYScrollToContentEdgeAction.m',
        'src/EarlGrey/Action/GREYSlideAction.h',
        'src/EarlGrey/Action/GREYSlideAction.m',
        'src/EarlGrey/Action/GREYSwipeAction.h',
        'src/EarlGrey/Action/GREYSwipeAction.m',
        'src/EarlGrey/Action/GREYTapAction.h',
        'src/EarlGrey/Action/GREYTapAction.m',
        'src/EarlGrey/Action/GREYTapper.h',
        'src/EarlGrey/Action/GREYTapper.m',
        'src/EarlGrey/Additions/__NSCFLocalDataTask_GREYAdditions.h',
        'src/EarlGrey/Additions/__NSCFLocalDataTask_GREYAdditions.m',
        'src/EarlGrey/Additions/_UIGestureRecognizerFailureMap_GREYAdditions.h',
        'src/EarlGrey/Additions/_UIGestureRecognizerFailureMap_GREYAdditions.m',
        'src/EarlGrey/Additions/_UIModalItemsPresentingViewController_GREYAdditions.h',
        'src/EarlGrey/Additions/_UIModalItemsPresentingViewController_GREYAdditions.m',
        'src/EarlGrey/Additions/CAAnimation+GREYAdditions.h',
        'src/EarlGrey/Additions/CAAnimation+GREYAdditions.m',
        'src/EarlGrey/Additions/CALayer+GREYAdditions.h',
        'src/EarlGrey/Additions/CALayer+GREYAdditions.m',
        'src/EarlGrey/Additions/CGGeometry+GREYAdditions.h',
        'src/EarlGrey/Additions/CGGeometry+GREYAdditions.m',
        'src/EarlGrey/Additions/NSError+GREYAdditions.h',
        'src/EarlGrey/Additions/NSError+GREYAdditions.m',
        'src/EarlGrey/Additions/NSObject+GREYAdditions.h',
        'src/EarlGrey/Additions/NSObject+GREYAdditions.m',
        'src/EarlGrey/Additions/NSRunLoop+GREYAdditions.h',
        'src/EarlGrey/Additions/NSRunLoop+GREYAdditions.m',
        'src/EarlGrey/Additions/NSString+GREYAdditions.h',
        'src/EarlGrey/Additions/NSString+GREYAdditions.m',
        'src/EarlGrey/Additions/NSTimer+GREYAdditions.h',
        'src/EarlGrey/Additions/NSTimer+GREYAdditions.m',
        'src/EarlGrey/Additions/NSURL+GREYAdditions.h',
        'src/EarlGrey/Additions/NSURL+GREYAdditions.m',
        'src/EarlGrey/Additions/NSURLConnection+GREYAdditions.h',
        'src/EarlGrey/Additions/NSURLConnection+GREYAdditions.m',
        'src/EarlGrey/Additions/UIAnimation+GREYAdditions.h',
        'src/EarlGrey/Additions/UIAnimation+GREYAdditions.m',
        'src/EarlGrey/Additions/UIApplication+GREYAdditions.h',
        'src/EarlGrey/Additions/UIApplication+GREYAdditions.m',
        'src/EarlGrey/Additions/UIScrollView+GREYAdditions.h',
        'src/EarlGrey/Additions/UIScrollView+GREYAdditions.m',
        'src/EarlGrey/Additions/UISwitch+GREYAdditions.h',
        'src/EarlGrey/Additions/UISwitch+GREYAdditions.m',
        'src/EarlGrey/Additions/UITouch+GREYAdditions.h',
        'src/EarlGrey/Additions/UITouch+GREYAdditions.m',
        'src/EarlGrey/Additions/UIView+GREYAdditions.h',
        'src/EarlGrey/Additions/UIView+GREYAdditions.m',
        'src/EarlGrey/Additions/UIViewController+GREYAdditions.h',
        'src/EarlGrey/Additions/UIViewController+GREYAdditions.m',
        'src/EarlGrey/Additions/UIWebView+GREYAdditions.h',
        'src/EarlGrey/Additions/UIWebView+GREYAdditions.m',
        'src/EarlGrey/Additions/UIWindow+GREYAdditions.h',
        'src/EarlGrey/Additions/UIWindow+GREYAdditions.m',
        'src/EarlGrey/Additions/XCTestCase+GREYAdditions.h',
        'src/EarlGrey/Additions/XCTestCase+GREYAdditions.m',
        'src/EarlGrey/AppSupport/GREYIdlingResource.h',
        'src/EarlGrey/Assertion/GREYAssertion.h',
        'src/EarlGrey/Assertion/GREYAssertionBlock.h',
        'src/EarlGrey/Assertion/GREYAssertionBlock.m',
        'src/EarlGrey/Assertion/GREYAssertionDefines.h',
        'src/EarlGrey/Assertion/GREYAssertions.h',
        'src/EarlGrey/Assertion/GREYAssertions.m',
        'src/EarlGrey/Common/GREYAnalytics.h',
        'src/EarlGrey/Common/GREYAnalytics.m',
        'src/EarlGrey/Common/GREYConfiguration.h',
        'src/EarlGrey/Common/GREYConfiguration.m',
        'src/EarlGrey/Common/GREYConstants.h',
        'src/EarlGrey/Common/GREYConstants.m',
        'src/EarlGrey/Common/GREYDefines.h',
        'src/EarlGrey/Common/GREYElementHierarchy.h',
        'src/EarlGrey/Common/GREYElementHierarchy.m',
        'src/EarlGrey/Common/GREYExposed.h',
        'src/EarlGrey/Common/GREYPrivate.h',
        'src/EarlGrey/Common/GREYScreenshotUtil.h',
        'src/EarlGrey/Common/GREYScreenshotUtil.m',
        'src/EarlGrey/Common/GREYSwizzler.h',
        'src/EarlGrey/Common/GREYSwizzler.m',
        'src/EarlGrey/Common/GREYTestHelper.h',
        'src/EarlGrey/Common/GREYTestHelper.m',
        'src/EarlGrey/Common/GREYVisibilityChecker.h',
        'src/EarlGrey/Common/GREYVisibilityChecker.m',
        'src/EarlGrey/Core/GREYAutomationSetup.h',
        'src/EarlGrey/Core/GREYAutomationSetup.m',
        'src/EarlGrey/Core/GREYElementFinder.h',
        'src/EarlGrey/Core/GREYElementFinder.m',
        'src/EarlGrey/Core/GREYElementInteraction.h',
        'src/EarlGrey/Core/GREYElementInteraction.m',
        'src/EarlGrey/Core/GREYInteractionDataSource.h',
        'src/EarlGrey/Core/GREYKeyboard.h',
        'src/EarlGrey/Core/GREYKeyboard.m',
        'src/EarlGrey/Delegate/GREYCAAnimationDelegate.h',
        'src/EarlGrey/Delegate/GREYCAAnimationDelegate.m',
        'src/EarlGrey/Delegate/GREYNSURLConnectionDelegate.h',
        'src/EarlGrey/Delegate/GREYNSURLConnectionDelegate.m',
        'src/EarlGrey/Delegate/GREYSurrogateDelegate.h',
        'src/EarlGrey/Delegate/GREYSurrogateDelegate.m',
        'src/EarlGrey/Delegate/GREYUIWebViewDelegate.h',
        'src/EarlGrey/Delegate/GREYUIWebViewDelegate.m',
        'src/EarlGrey/EarlGrey.h',
        'src/EarlGrey/EarlGrey.m',
        'src/EarlGrey/Event/GREYSingleSequenceTouchInjector.h',
        'src/EarlGrey/Event/GREYSingleSequenceTouchInjector.m',
        'src/EarlGrey/Event/GREYSyntheticEvents.h',
        'src/EarlGrey/Event/GREYSyntheticEvents.m',
        'src/EarlGrey/Exception/GREYDefaultFailureHandler.h',
        'src/EarlGrey/Exception/GREYDefaultFailureHandler.m',
        'src/EarlGrey/Exception/GREYFailureHandler.h',
        'src/EarlGrey/Exception/GREYFrameworkException.h',
        'src/EarlGrey/Exception/GREYFrameworkException.m',
        'src/EarlGrey/Matcher/GREYAllOf.h',
        'src/EarlGrey/Matcher/GREYAllOf.m',
        'src/EarlGrey/Matcher/GREYAnyOf.h',
        'src/EarlGrey/Matcher/GREYAnyOf.m',
        'src/EarlGrey/Matcher/GREYBaseMatcher.h',
        'src/EarlGrey/Matcher/GREYBaseMatcher.m',
        'src/EarlGrey/Matcher/GREYDescription.h',
        'src/EarlGrey/Matcher/GREYElementMatcherBlock.h',
        'src/EarlGrey/Matcher/GREYElementMatcherBlock.m',
        'src/EarlGrey/Matcher/GREYHCMatcher.h',
        'src/EarlGrey/Matcher/GREYHCMatcher.m',
        'src/EarlGrey/Matcher/GREYLayoutConstraint.h',
        'src/EarlGrey/Matcher/GREYLayoutConstraint.m',
        'src/EarlGrey/Matcher/GREYMatcher.h',
        'src/EarlGrey/Matcher/GREYMatchers.h',
        'src/EarlGrey/Matcher/GREYMatchers.m',
        'src/EarlGrey/Matcher/GREYNot.h',
        'src/EarlGrey/Matcher/GREYNot.m',
        'src/EarlGrey/Matcher/GREYStringDescription.h',
        'src/EarlGrey/Matcher/GREYStringDescription.m',
        'src/EarlGrey/Provider/GREYDataEnumerator.h',
        'src/EarlGrey/Provider/GREYDataEnumerator.m',
        'src/EarlGrey/Provider/GREYElementProvider.h',
        'src/EarlGrey/Provider/GREYElementProvider.m',
        'src/EarlGrey/Provider/GREYProvider.h',
        'src/EarlGrey/Provider/GREYUIWindowProvider.h',
        'src/EarlGrey/Provider/GREYUIWindowProvider.m',
        'src/EarlGrey/Synchronization/GREYAppStateTracker.h',
        'src/EarlGrey/Synchronization/GREYAppStateTracker.m',
        'src/EarlGrey/Synchronization/GREYCondition.h',
        'src/EarlGrey/Synchronization/GREYCondition.m',
        'src/EarlGrey/Synchronization/GREYDispatchQueueIdlingResource.h',
        'src/EarlGrey/Synchronization/GREYDispatchQueueIdlingResource.m',
        'src/EarlGrey/Synchronization/GREYNSTimerIdlingResource.h',
        'src/EarlGrey/Synchronization/GREYNSTimerIdlingResource.m',
        'src/EarlGrey/Synchronization/GREYOperationQueueIdlingResource.h',
        'src/EarlGrey/Synchronization/GREYOperationQueueIdlingResource.m',
        'src/EarlGrey/Synchronization/GREYSyncAPI.h',
        'src/EarlGrey/Synchronization/GREYSyncAPI.m',
        'src/EarlGrey/Synchronization/GREYTimedIdlingResource.h',
        'src/EarlGrey/Synchronization/GREYTimedIdlingResource.m',
        'src/EarlGrey/Synchronization/GREYUIThreadExecutor.h',
        'src/EarlGrey/Synchronization/GREYUIThreadExecutor.m',
        'src/EarlGrey/Synchronization/GREYUIWebViewIdlingResource.h',
        'src/EarlGrey/Synchronization/GREYUIWebViewIdlingResource.m',
      ],
      'mac_framework_headers': [
        'src/EarlGrey/EarlGrey.h',
        'src/EarlGrey/Action/GREYAction.h',
        'src/EarlGrey/Action/GREYActionBlock.h',
        'src/EarlGrey/Action/GREYActions.h',
        'src/EarlGrey/Action/GREYBaseAction.h',
        'src/EarlGrey/Action/GREYScrollActionError.h',
        'src/EarlGrey/AppSupport/GREYIdlingResource.h',
        'src/EarlGrey/Assertion/GREYAssertion.h',
        'src/EarlGrey/Assertion/GREYAssertionBlock.h',
        'src/EarlGrey/Assertion/GREYAssertionDefines.h',
        'src/EarlGrey/Assertion/GREYAssertions.h',
        'src/EarlGrey/Common/GREYConfiguration.h',
        'src/EarlGrey/Common/GREYConstants.h',
        'src/EarlGrey/Common/GREYDefines.h',
        'src/EarlGrey/Common/GREYElementHierarchy.h',
        'src/EarlGrey/Common/GREYScreenshotUtil.h',
        'src/EarlGrey/Common/GREYTestHelper.h',
        'src/EarlGrey/Core/GREYElementFinder.h',
        'src/EarlGrey/Core/GREYElementInteraction.h',
        'src/EarlGrey/Core/GREYInteraction.h',
        'src/EarlGrey/Exception/GREYFailureHandler.h',
        'src/EarlGrey/Exception/GREYFrameworkException.h',
        'src/EarlGrey/Matcher/GREYAllOf.h',
        'src/EarlGrey/Matcher/GREYAnyOf.h',
        'src/EarlGrey/Matcher/GREYBaseMatcher.h',
        'src/EarlGrey/Matcher/GREYDescription.h',
        'src/EarlGrey/Matcher/GREYElementMatcherBlock.h',
        'src/EarlGrey/Matcher/GREYLayoutConstraint.h',
        'src/EarlGrey/Matcher/GREYMatcher.h',
        'src/EarlGrey/Matcher/GREYMatchers.h',
        'src/EarlGrey/Matcher/GREYNot.h',
        'src/EarlGrey/Provider/GREYDataEnumerator.h',
        'src/EarlGrey/Provider/GREYProvider.h',
        'src/EarlGrey/Synchronization/GREYNSTimerIdlingResource.h',
        'src/EarlGrey/Synchronization/GREYOperationQueueIdlingResource.h',
        'src/EarlGrey/Synchronization/GREYDispatchQueueIdlingResource.h',
        'src/EarlGrey/Synchronization/GREYSyncAPI.h',
        'src/EarlGrey/Synchronization/GREYCondition.h',
        'src/EarlGrey/Synchronization/GREYUIThreadExecutor.h',
      ],
      'mac_framework_private_headers': [
        'src/EarlGrey/Action/GREYPathGestureUtils.h',
        'src/EarlGrey/Action/GREYScrollAction.h',
        'src/EarlGrey/Action/GREYSwipeAction.h',
        'src/EarlGrey/Action/GREYTapAction.h',
        'src/EarlGrey/Additions/__NSCFLocalDataTask_GREYAdditions.h',
        'src/EarlGrey/Additions/_UIGestureRecognizerFailureMap_GREYAdditions.h',
        'src/EarlGrey/Additions/_UIModalItemsPresentingViewController_GREYAdditions.h',
        'src/EarlGrey/Additions/CAAnimation+GREYAdditions.h',
        'src/EarlGrey/Additions/CALayer+GREYAdditions.h',
        'src/EarlGrey/Additions/CGGeometry+GREYAdditions.h',
        'src/EarlGrey/Additions/NSError+GREYAdditions.h',
        'src/EarlGrey/Additions/NSRunLoop+GREYAdditions.h',
        'src/EarlGrey/Additions/NSString+GREYAdditions.h',
        'src/EarlGrey/Additions/NSTimer+GREYAdditions.h',
        'src/EarlGrey/Additions/NSURL+GREYAdditions.h',
        'src/EarlGrey/Additions/NSURLConnection+GREYAdditions.h',
        'src/EarlGrey/Additions/UIAnimation+GREYAdditions.h',
        'src/EarlGrey/Additions/UIApplication+GREYAdditions.h',
        'src/EarlGrey/Additions/UIScrollView+GREYAdditions.h',
        'src/EarlGrey/Additions/UISwitch+GREYAdditions.h',
        'src/EarlGrey/Additions/UITouch+GREYAdditions.h',
        'src/EarlGrey/Additions/UIView+GREYAdditions.h',
        'src/EarlGrey/Additions/UIViewController+GREYAdditions.h',
        'src/EarlGrey/Additions/UIWebView+GREYAdditions.h',
        'src/EarlGrey/Additions/UIWindow+GREYAdditions.h',
        'src/EarlGrey/Additions/XCTestCase+GREYAdditions.h',
        'src/EarlGrey/Common/GREYExposed.h',
        'src/EarlGrey/Common/GREYPrivate.h',
        'src/EarlGrey/Common/GREYSwizzler.h',
        'src/EarlGrey/Common/GREYVisibilityChecker.h',
        'src/EarlGrey/Delegate/GREYCAAnimationDelegate.h',
        'src/EarlGrey/Delegate/GREYNSURLConnectionDelegate.h',
        'src/EarlGrey/Delegate/GREYSurrogateDelegate.h',
        'src/EarlGrey/Delegate/GREYUIWebViewDelegate.h',
        'src/EarlGrey/Event/GREYSingleSequenceTouchInjector.h',
        'src/EarlGrey/Event/GREYSyntheticEvents.h',
        'src/EarlGrey/Provider/GREYElementProvider.h',
        'src/EarlGrey/Provider/GREYUIWindowProvider.h',
        'src/EarlGrey/Synchronization/GREYAppStateTracker.h',
        'src/EarlGrey/Synchronization/GREYTimedIdlingResource.h',
      ],
      'dependencies': [
        '../../../third_party/google_toolbox_for_mac/google_toolbox_for_mac.gyp:google_toolbox_for_mac',
        '../fishhook/fishhook.gyp:fishhook',
        '../ochamcrest/ochamcrest.gyp:OCHamcrest',
      ],
      # EarlGrey.pch requires that NS_BLOCK_ASSERTIONS be undefined.
      'defines!': [
        'NS_BLOCK_ASSERTIONS=1',
      ],
      'xcode_settings': {
        'GCC_SYMBOLS_PRIVATE_EXTERN': 'NO',
        'GCC_PREFIX_HEADER': 'src/EarlGrey.pch',
        'USE_HEADERMAP': 'YES',
        'CLANG_ENABLE_OBJC_ARC': 'YES',
        'CODE_SIGN_IDENTITY[sdk=iphoneos*]': 'iPhone Developer',
        'BUNDLE_IDENTIFIER': 'com.google.earlgrey.EarlGrey',
        'INFOPLIST_FILE': 'src/EarlGrey-Info.plist',
        'DYLIB_INSTALL_NAME_BASE': '@rpath',
        'OTHER_LDFLAGS': [
          '-Xlinker', '-rpath', '-Xlinker', '@executable_path/Frameworks',
          '-Xlinker', '-rpath', '-Xlinker', '@loader_path/Frameworks'
        ]
      },
      'link_settings': {
        'libraries': [
          'CoreGraphics.framework',
          'Foundation.framework',
          'IOKit.framework',
          'QuartzCore.framework',
          'UIKit.framework',
          'XCTest.framework',
        ],
      },
      'include_dirs': [
        'src',
        'src/EarlGrey',
      ],
      'export_dependent_settings': [
        '../ochamcrest/ochamcrest.gyp:OCHamcrest',
      ],
      'mac_framework_dirs': [
        '$(SDKROOT)/../../Library/Frameworks',
        '<(PRODUCT_DIR)'
      ],
      'direct_dependent_settings': {
        'include_dirs': [
          'src/EarlGrey',
        ],
        'mac_framework_dirs': [
          # EarlGrey and its dependencies need to link to XCTest.framework
          # which is not under SDKROOT.
          '$(SDKROOT)/../../Library/Frameworks',
          '<(PRODUCT_DIR)'
        ],
      },
    },
  ],
}

