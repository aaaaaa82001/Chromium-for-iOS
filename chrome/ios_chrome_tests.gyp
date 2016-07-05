# Copyright 2014 The Chromium Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.
{
  'variables': {
    'chromium_code': 1,
  },
  'targets': [
    {
      # GN version: //ios/chrome:ios_chrome_unittests
      'target_name': 'ios_chrome_unittests',
      'type': '<(gtest_target_type)',
      'dependencies': [
        '../../base/base.gyp:base',
        '../../base/base.gyp:test_support_base',
        '../../components/components.gyp:bookmarks_test_support',
        '../../components/components.gyp:favicon_base',
        '../../components/components.gyp:metrics',
        '../../components/components.gyp:metrics_test_support',
        '../../components/components.gyp:password_manager_core_browser',
        '../../components/components.gyp:password_manager_core_browser_test_support',
        '../../components/components.gyp:password_manager_core_common',
        '../../components/components.gyp:syncable_prefs_test_support',
        '../../components/components.gyp:update_client',
        '../../components/components.gyp:version_info',
        '../../components/prefs/prefs.gyp:prefs_test_support',
        '../../net/net.gyp:net_test_support',
        '../../skia/skia.gyp:skia',
        '../../testing/gmock.gyp:gmock',
        '../../testing/gtest.gyp:gtest',
        '../../third_party/ocmock/ocmock.gyp:ocmock',
        '../../ui/gfx/gfx.gyp:gfx',
        '../../ui/gfx/gfx.gyp:gfx_test_support',
        '../web/ios_web.gyp:ios_web',
        '../web/ios_web.gyp:ios_web_test_support',
        'ios_chrome.gyp:ios_chrome_app',
        'ios_chrome.gyp:ios_chrome_browser',
        'ios_chrome.gyp:ios_chrome_common',
        'ios_chrome_test_support',
      ],
      'mac_bundle_resources': [
        'browser/ui/native_content_controller_test.xib'
      ],
      'sources': [
        'app/application_delegate/memory_warning_helper_unittest.mm',
        'app/safe_mode_util_unittest.cc',
        'browser/chrome_url_util_unittest.mm',
        'browser/crash_loop_detection_util_unittest.mm',
        'browser/favicon/large_icon_cache_unittest.cc',
        'browser/geolocation/CLLocation+XGeoHeaderTest.mm',
        'browser/geolocation/location_manager_unittest.mm',
        'browser/geolocation/omnibox_geolocation_local_state_unittest.mm',
        'browser/install_time_util_unittest.mm',
        'browser/installation_notifier_unittest.mm',
        'browser/metrics/ios_chrome_metrics_service_accessor_unittest.cc',
        'browser/metrics/ios_chrome_stability_metrics_provider_unittest.cc',
        'browser/metrics/mobile_session_shutdown_metrics_provider_unittest.mm',
        'browser/metrics/previous_session_info_unittest.mm',
        'browser/net/cookie_util_unittest.mm',
        'browser/net/image_fetcher_unittest.mm',
        'browser/net/metrics_network_client_unittest.mm',
        'browser/net/retryable_url_fetcher_unittest.mm',
        'browser/notification_promo_unittest.cc',
        'browser/passwords/password_controller_unittest.mm',
        'browser/reading_list/reading_list_entry_unittest.cc',
        'browser/reading_list/reading_list_model_unittest.cc',
        'browser/signin/chrome_identity_service_observer_bridge_unittest.mm',
        'browser/signin/gaia_auth_fetcher_ios_unittest.mm',
        'browser/snapshots/lru_cache_unittest.mm',
        'browser/snapshots/snapshot_cache_unittest.mm',
        'browser/snapshots/snapshots_util_unittest.mm',
        'browser/ssl/ios_ssl_error_handler_unittest.mm',
        'browser/translate/translate_service_ios_unittest.cc',
        'browser/ui/commands/set_up_for_testing_command_unittest.mm',
        'browser/ui/context_menu/context_menu_coordinator_unittest.mm',
        'browser/ui/elements/selector_coordinator_unittest.mm',
        'browser/ui/elements/selector_picker_view_controller_unittest.mm',
        'browser/ui/keyboard/UIKeyCommand+ChromeTest.mm',
        'browser/ui/keyboard/hardware_keyboard_watcher_unittest.mm',
        'browser/ui/native_content_controller_unittest.mm',
        'browser/ui/ui_util_unittest.mm',
        'browser/ui/uikit_ui_util_unittest.mm',
        'browser/update_client/ios_chrome_update_query_params_delegate_unittest.cc',
        'browser/web_resource/web_resource_util_unittest.cc',
        'common/string_util_unittest.mm',
      ],
      'actions': [
        {
          'action_name': 'copy_ios_chrome_test_data',
          'variables': {
            'test_data_files': [
              '../../net/data/ssl/certificates/',
              'test/data/webdata/bookmarkimages',
            ],
            'test_data_prefix': 'ios/chrome',
          },
          'includes': [ '../../build/copy_test_data_ios.gypi' ]
        },
      ],
      'includes': ['ios_chrome_resources_bundle.gypi'],
    },
    {
      # GN version: //ios/chrome/browser:test_support
      'target_name': 'ios_chrome_test_support',
      'type': 'static_library',
      'dependencies': [
        '../../base/base.gyp:base',
        '../../components/components.gyp:keyed_service_core',
        '../../components/components.gyp:keyed_service_ios',
        '../../components/components.gyp:password_manager_core_browser_test_support',
        '../../components/components.gyp:signin_ios_browser_test_support',
        '../../components/components.gyp:sync_driver_test_support',
        '../../sync/sync.gyp:sync',
        '../../testing/gmock.gyp:gmock',
        '../../testing/gtest.gyp:gtest',
        '../../ui/base/ui_base.gyp:ui_base',
        '../../url/url.gyp:url_lib',
        '../provider/ios_provider_chrome.gyp:ios_provider_chrome_browser',
        '../provider/ios_provider_chrome.gyp:ios_provider_chrome_browser_test_support',
        'ios_chrome.gyp:ios_chrome_browser',
      ],
      'sources': [
        'browser/browser_state/test_chrome_browser_state.h',
        'browser/browser_state/test_chrome_browser_state.mm',
        'browser/browser_state/test_chrome_browser_state_isolated_context.h',
        'browser/browser_state/test_chrome_browser_state_isolated_context.mm',
        'browser/browser_state/test_chrome_browser_state_manager.cc',
        'browser/browser_state/test_chrome_browser_state_manager.h',
        'browser/geolocation/location_manager+Testing.h',
        'browser/geolocation/test_location_manager.h',
        'browser/geolocation/test_location_manager.mm',
        'browser/net/mock_image_fetcher.h',
        'browser/net/mock_image_fetcher.mm',
        'browser/signin/fake_oauth2_token_service_builder.h',
        'browser/signin/fake_oauth2_token_service_builder.mm',
        'browser/signin/fake_signin_manager_builder.cc',
        'browser/signin/fake_signin_manager_builder.h',
        'browser/sync/fake_sync_service_factory.cc',
        'browser/sync/fake_sync_service_factory.h',
        'browser/sync/ios_chrome_profile_sync_test_util.cc',
        'browser/sync/ios_chrome_profile_sync_test_util.h',
        'browser/sync/sync_setup_service_mock.cc',
        'browser/sync/sync_setup_service_mock.h',
        'test/block_cleanup_test.h',
        'test/block_cleanup_test.mm',
        'test/ios_chrome_scoped_testing_chrome_browser_provider.h',
        'test/ios_chrome_scoped_testing_chrome_browser_provider.mm',
        'test/ios_chrome_scoped_testing_local_state.cc',
        'test/ios_chrome_scoped_testing_local_state.h',
        'test/ios_chrome_unit_test_suite.h',
        'test/ios_chrome_unit_test_suite.mm',
        'test/run_all_unittests.cc',
        'test/testing_application_context.h',
        'test/testing_application_context.mm',
      ],
    },
  ],
}
