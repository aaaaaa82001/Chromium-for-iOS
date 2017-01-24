// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#include "base/memory/ptr_util.h"
#include "base/strings/string_number_conversions.h"
#include "base/strings/sys_string_conversions.h"
#include "base/strings/utf_string_conversions.h"
#include "base/test/ios/wait_util.h"
#import "ios/web/navigation/navigation_item_impl.h"
#import "ios/web/public/navigation_item.h"
#import "ios/web/public/navigation_manager.h"
#import "ios/web/public/test/http_server.h"
#include "ios/web/public/test/http_server_util.h"
#import "ios/web/public/test/web_view_interaction_test_util.h"
#import "ios/web/public/web_state/web_state.h"
#import "ios/web/test/web_int_test.h"
#include "testing/gtest/include/gtest/gtest.h"
#include "testing/gtest_mac.h"
#include "url/url_canon.h"

using base::ASCIIToUTF16;

namespace {

// URL for the test window.location test file.  The page at this URL contains
// several buttons that trigger window.location commands.  The page supports
// several JavaScript functions:
// - updateUrlToLoadText(), which takes a URL and updates a div on the page to
//   contain that text.  This URL is used as the parameter for window.location
//   function calls triggered by button taps.
// - getUrl(), which returns the URL that was set via updateUrlToLoadText().
// - isOnLoadTextVisible(), which returns whether a placeholder string is
//   present on the page.  This string is added to the page in the onload event
//   and is removed once a button is tapped.  Verifying that the onload text is
//   visible after tapping a button is equivalent to checking that a load has
//   occurred as the result of the button tap.
const char kHistoryStateOperationsTestUrl[] =
    "http://ios/testing/data/http_server_files/state_operations.html";

// Button IDs used in the window.location test page.
const char kPushStateId[] = "push-state";
const char kReplaceStateId[] = "replace-state";

// JavaScript functions on the history state test page.
NSString* const kUpdateStateParamsScriptFormat =
    @"updateStateParams('%s', '%s', '%s')";
NSString* const kOnLoadCheckScript = @"isOnLoadPlaceholderTextVisible()";
NSString* const kNoOpCheckScript = @"isNoOpPlaceholderTextVisible()";

}  // namespace

// Test fixture for integration tests involving html5 window.history state
// operations.
class HistoryStateOperationsTest : public web::WebIntTest {
 protected:
  void SetUp() override {
    web::WebIntTest::SetUp();

    // History state tests use file-based test pages.
    web::test::SetUpFileBasedHttpServer();

    // Load the history state test page.
    state_operations_url_ =
        web::test::HttpServer::MakeUrl(kHistoryStateOperationsTestUrl);
    LoadUrl(state_operations_url());
  }

  // The URL of the window.location test page.
  const GURL& state_operations_url() { return state_operations_url_; }

  // Reloads the page and waits for the load to finish.
  void Reload() {
    ExecuteBlockAndWaitForLoad(GetLastCommittedItem()->GetURL(), ^{
      // TODO(crbug.com/677364): Use NavigationManager::Reload() once it no
      // longer requires a web delegate.
      web_state()->ExecuteJavaScript(ASCIIToUTF16("window.location.reload()"));
    });
  }

  // Sets the parameters to use for state operations on the test page.  This
  // function executes a script that populates JavaScript values on the test
  // page.  When the "push-state" or "replace-state" buttons are tapped, these
  // parameters will be passed to their corresponding JavaScript function calls.
  void SetStateParams(const std::string& state_object,
                      const std::string& title,
                      const GURL& url) {
    ASSERT_EQ(state_operations_url(), GetLastCommittedItem()->GetURL());
    std::string url_spec = url.possibly_invalid_spec();
    NSString* set_params_script = [NSString
        stringWithFormat:kUpdateStateParamsScriptFormat, state_object.c_str(),
                         title.c_str(), url_spec.c_str()];
    ExecuteJavaScript(set_params_script);
  }

  // Returns the state object returned by JavaScript.
  std::string GetJavaScriptState() {
    return base::SysNSStringToUTF8(ExecuteJavaScript(@"window.history.state"));
  }

  // Executes JavaScript to check whether the onload text is visible.
  bool IsOnLoadTextVisible() {
    return [ExecuteJavaScript(kOnLoadCheckScript) boolValue];
  }

  // Executes JavaScript to check whether the no-op text is visible.
  bool IsNoOpTextVisible() {
    return [ExecuteJavaScript(kNoOpCheckScript) boolValue];
  }

  // Waits for the NoOp text to be visible.
  void WaitForNoOpText() {
    base::test::ios::WaitUntilCondition(^bool {
      return IsNoOpTextVisible();
    });
  }

 private:
  GURL state_operations_url_;
};

// Tests that calling window.history.pushState() is a no-op for unresolvable
// URLs.
TEST_F(HistoryStateOperationsTest, NoOpPushUnresolvable) {
  // Perform a window.history.pushState() with an unresolvable URL.  This will
  // clear the OnLoad and NoOp text, so checking below that the NoOp text is
  // displayed and the OnLoad text is empty ensures that no navigation occurred
  // as the result of the pushState() call.
  std::string empty_state;
  std::string empty_title;
  GURL unresolvable_url("http://www.google.invalid");
  SetStateParams(empty_state, empty_title, unresolvable_url);
  ASSERT_TRUE(web::test::TapWebViewElementWithId(web_state(), kPushStateId));
  WaitForNoOpText();
}

// Tests that calling window.history.replaceState() is a no-op for unresolvable
// URLs.
TEST_F(HistoryStateOperationsTest, NoOpReplaceUnresolvable) {
  // Perform a window.history.replaceState() with an unresolvable URL.  This
  // will clear the OnLoad and NoOp text, so checking below that the NoOp text
  // is displayed and the OnLoad text is empty ensures that no navigation
  // occurred as the result of the pushState() call.
  std::string empty_state;
  std::string empty_title;
  GURL unresolvable_url("http://www.google.invalid");
  SetStateParams(empty_state, empty_title, unresolvable_url);
  ASSERT_TRUE(web::test::TapWebViewElementWithId(web_state(), kReplaceStateId));
  WaitForNoOpText();
}

// Tests that calling window.history.pushState() is a no-op for URLs with a
// different scheme.
TEST_F(HistoryStateOperationsTest, NoOpPushDifferentScheme) {
  // Perform a window.history.pushState() with a URL with a different scheme.
  // This will clear the OnLoad and NoOp text, so checking below that the NoOp
  // text is displayed and the OnLoad text is empty ensures that no navigation
  // occurred as the result of the pushState() call.
  std::string empty_state;
  std::string empty_title;
  GURL different_scheme_url("https://google.com");
  ASSERT_TRUE(IsOnLoadTextVisible());
  SetStateParams(empty_state, empty_title, different_scheme_url);
  ASSERT_TRUE(web::test::TapWebViewElementWithId(web_state(), kPushStateId));
  WaitForNoOpText();
}

// Tests that calling window.history.replaceState() is a no-op for URLs with a
// different scheme.
TEST_F(HistoryStateOperationsTest, NoOpRelaceDifferentScheme) {
  // Perform a window.history.replaceState() with a URL with a different scheme.
  // This will clear the OnLoad and NoOp text, so checking below that the NoOp
  // text is displayed and the OnLoad text is empty ensures that no navigation
  // occurred as the result of the pushState() call.
  std::string empty_state;
  std::string empty_title;
  GURL different_scheme_url("https://google.com");
  ASSERT_TRUE(IsOnLoadTextVisible());
  SetStateParams(empty_state, empty_title, different_scheme_url);
  ASSERT_TRUE(web::test::TapWebViewElementWithId(web_state(), kReplaceStateId));
  WaitForNoOpText();
}

// Tests that calling window.history.pushState() is a no-op for URLs with a
// origin differing from that of the current page.
TEST_F(HistoryStateOperationsTest, NoOpPushDifferentOrigin) {
  // Perform a window.history.pushState() with a URL with a different origin.
  // This will clear the OnLoad and NoOp text, so checking below that the NoOp
  // text is displayed and the OnLoad text is empty ensures that no navigation
  // occurred as the result of the pushState() call.
  std::string empty_state;
  std::string empty_title;
  std::string new_port_string = base::IntToString(
      web::test::HttpServer::GetSharedInstance().GetPort() + 1);
  url::Replacements<char> port_replacement;
  port_replacement.SetPort(new_port_string.c_str(),
                           url::Component(0, new_port_string.length()));
  GURL different_origin_url =
      state_operations_url().ReplaceComponents(port_replacement);
  ASSERT_TRUE(IsOnLoadTextVisible());
  SetStateParams(empty_state, empty_title, different_origin_url);
  ASSERT_TRUE(web::test::TapWebViewElementWithId(web_state(), kPushStateId));
  WaitForNoOpText();
}

// Tests that calling window.history.replaceState() is a no-op for URLs with a
// origin differing from that of the current page.
TEST_F(HistoryStateOperationsTest, NoOpReplaceDifferentOrigin) {
  // Perform a window.history.replaceState() with a URL with a different origin.
  // This will clear the OnLoad and NoOp text, so checking below that the NoOp
  // text is displayed and the OnLoad text is empty ensures that no navigation
  // occurred as the result of the pushState() call.
  std::string empty_state;
  std::string empty_title;
  std::string new_port_string = base::IntToString(
      web::test::HttpServer::GetSharedInstance().GetPort() + 1);
  url::Replacements<char> port_replacement;
  port_replacement.SetPort(new_port_string.c_str(),
                           url::Component(0, new_port_string.length()));
  GURL different_origin_url =
      state_operations_url().ReplaceComponents(port_replacement);
  ASSERT_TRUE(IsOnLoadTextVisible());
  SetStateParams(empty_state, empty_title, different_origin_url);
  ASSERT_TRUE(web::test::TapWebViewElementWithId(web_state(), kReplaceStateId));
  WaitForNoOpText();
}

// Tests that calling window.history.replaceState() with only a new title
// successfully replaces the current NavigationItem's title.
// TODO(crbug.com/677356): Enable this test once the NavigationItem's title is
// updated from within the web layer.
TEST_F(HistoryStateOperationsTest, DISABLED_TitleReplacement) {
  // Navigate to about:blank then navigate back to the test page.  The created
  // NavigationItem can be used later to verify that the title is replaced
  // rather than pushed.
  GURL about_blank("about:blank");
  LoadUrl(about_blank);
  web::NavigationItem* about_blank_item = GetLastCommittedItem();
  ExecuteBlockAndWaitForLoad(state_operations_url(), ^{
    navigation_manager()->GoBack();
  });
  EXPECT_EQ(state_operations_url(), GetLastCommittedItem()->GetURL());
  // Set up the state parameters and tap the replace state button.
  std::string empty_state;
  std::string new_title("NEW TITLE");
  GURL empty_url;
  SetStateParams(empty_state, new_title, empty_url);
  ASSERT_TRUE(web::test::TapWebViewElementWithId(web_state(), kReplaceStateId));
  // Wait for the title to be reflected in the NavigationItem.
  base::test::ios::WaitUntilCondition(^bool {
    return GetLastCommittedItem()->GetTitle() == ASCIIToUTF16(new_title);
  });
  // Verify that the forward navigation was not pruned.
  EXPECT_EQ(GetIndexOfNavigationItem(GetLastCommittedItem()) + 1,
            GetIndexOfNavigationItem(about_blank_item));
}

// Tests that calling window.history.replaceState() with a new state object
// replaces the state object for the current NavigationItem.
TEST_F(HistoryStateOperationsTest, StateReplacement) {
  // Navigate to about:blank then navigate back to the test page.  The created
  // NavigationItem can be used later to verify that the state is replaced
  // rather than pushed.
  GURL about_blank("about:blank");
  LoadUrl(about_blank);
  web::NavigationItem* about_blank_item = GetLastCommittedItem();
  ExecuteBlockAndWaitForLoad(state_operations_url(), ^{
    navigation_manager()->GoBack();
  });
  ASSERT_EQ(state_operations_url(), GetLastCommittedItem()->GetURL());
  // Set up the state parameters and tap the replace state button.
  std::string new_state("STATE OBJECT");
  std::string empty_title;
  GURL empty_url;
  SetStateParams(new_state, empty_title, empty_url);
  ASSERT_TRUE(web::test::TapWebViewElementWithId(web_state(), kReplaceStateId));
  // Verify that the state is reflected in the JavaScript context.
  base::test::ios::WaitUntilCondition(^bool {
    return GetJavaScriptState() == new_state;
  });
  // Verify that the state is reflected in the latest NavigationItem.
  std::string serialized_state("\"STATE OBJECT\"");
  base::test::ios::WaitUntilCondition(^bool {
    web::NavigationItemImpl* item =
        static_cast<web::NavigationItemImpl*>(GetLastCommittedItem());
    std::string item_state =
        base::SysNSStringToUTF8(item->GetSerializedStateObject());
    return item_state == serialized_state;
  });
  // Verify that the forward navigation was not pruned.
  EXPECT_EQ(GetIndexOfNavigationItem(GetLastCommittedItem()) + 1,
            GetIndexOfNavigationItem(about_blank_item));
}

// Tests that the state object is reset to the correct value after reloading a
// page whose state has been replaced.
TEST_F(HistoryStateOperationsTest, StateReplacementReload) {
  // Set up the state parameters and tap the replace state button.
  std::string new_state("STATE OBJECT");
  std::string empty_title;
  GURL empty_url;
  SetStateParams(new_state, empty_title, empty_url);
  ASSERT_TRUE(web::test::TapWebViewElementWithId(web_state(), kReplaceStateId));
  // Reload the page and check that the state object is present.
  Reload();
  ASSERT_TRUE(IsOnLoadTextVisible());
  base::test::ios::WaitUntilCondition(^bool {
    return GetJavaScriptState() == new_state;
  });
}

// Tests that the state object is correctly set for a page after a back/forward
// navigation.
TEST_F(HistoryStateOperationsTest, StateReplacementBackForward) {
  // Navigate to about:blank then navigate back to the test page.  The created
  // NavigationItem can be used later to verify that the state is replaced
  // rather than pushed.
  GURL about_blank("about:blank");
  LoadUrl(about_blank);
  ExecuteBlockAndWaitForLoad(state_operations_url(), ^{
    navigation_manager()->GoBack();
  });
  ASSERT_EQ(state_operations_url(), GetLastCommittedItem()->GetURL());
  // Set up the state parameters and tap the replace state button.
  std::string new_state("STATE OBJECT");
  std::string empty_title("");
  GURL empty_url("");
  SetStateParams(new_state, empty_title, empty_url);
  ASSERT_TRUE(web::test::TapWebViewElementWithId(web_state(), kReplaceStateId));
  // Go forward and back, then check that the state object is present.
  ExecuteBlockAndWaitForLoad(about_blank, ^{
    navigation_manager()->GoForward();
  });
  ExecuteBlockAndWaitForLoad(state_operations_url(), ^{
    navigation_manager()->GoBack();
  });
  ASSERT_TRUE(IsOnLoadTextVisible());
  base::test::ios::WaitUntilCondition(^bool {
    return GetJavaScriptState() == new_state;
  });
}
