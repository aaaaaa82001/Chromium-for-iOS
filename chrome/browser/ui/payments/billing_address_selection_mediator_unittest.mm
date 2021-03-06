// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "ios/chrome/browser/ui/payments/billing_address_selection_mediator.h"

#include "base/mac/foundation_util.h"
#include "base/memory/ptr_util.h"
#include "components/autofill/core/browser/autofill_profile.h"
#include "components/autofill/core/browser/autofill_test_utils.h"
#include "components/autofill/core/browser/test_personal_data_manager.h"
#include "ios/chrome/browser/payments/payment_request_test_util.h"
#import "ios/chrome/browser/payments/payment_request_util.h"
#include "ios/chrome/browser/payments/test_payment_request.h"
#import "ios/chrome/browser/ui/payments/cells/autofill_profile_item.h"
#include "testing/gtest/include/gtest/gtest.h"
#include "testing/platform_test.h"
#include "third_party/ocmock/gtest_support.h"

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "This file requires ARC support."
#endif

namespace {
using ::payment_request_util::GetNameLabelFromAutofillProfile;
using ::payment_request_util::GetBillingAddressLabelFromAutofillProfile;
using ::payment_request_util::GetPhoneNumberLabelFromAutofillProfile;
}  // namespace

class PaymentRequestBillingAddressSelectionMediatorTest : public PlatformTest {
 protected:
  PaymentRequestBillingAddressSelectionMediatorTest()
      : autofill_profile_1_(autofill::test::GetFullProfile()),
        autofill_profile_2_(autofill::test::GetFullProfile2()) {
    // Add testing profiles to autofill::TestPersonalDataManager.
    personal_data_manager_.AddTestingProfile(&autofill_profile_1_);
    personal_data_manager_.AddTestingProfile(&autofill_profile_2_);
    payment_request_ = base::MakeUnique<TestPaymentRequest>(
        payment_request_test_util::CreateTestWebPaymentRequest(),
        &personal_data_manager_);
  }

  void SetUp() override {
    mediator_ = [[BillingAddressSelectionMediator alloc]
        initWithPaymentRequest:payment_request_.get()
        selectedBillingProfile:payment_request_->billing_profiles()[1]];
  }

  BillingAddressSelectionMediator* GetMediator() { return mediator_; }

  BillingAddressSelectionMediator* mediator_;

  autofill::AutofillProfile autofill_profile_1_;
  autofill::AutofillProfile autofill_profile_2_;
  autofill::TestPersonalDataManager personal_data_manager_;
  std::unique_ptr<TestPaymentRequest> payment_request_;
};

// Tests that the expected selectable items are created and that the index of
// the selected item is properly set.
TEST_F(PaymentRequestBillingAddressSelectionMediatorTest, TestSelectableItems) {
  NSArray<CollectionViewItem*>* selectable_items =
      [GetMediator() selectableItems];

  // There must be two selectable items.
  ASSERT_EQ(2U, selectable_items.count);

  // The second item must be selected.
  EXPECT_EQ(1U, GetMediator().selectedItemIndex);

  CollectionViewItem* item_1 =
      [[GetMediator() selectableItems] objectAtIndex:0];
  DCHECK([item_1 isKindOfClass:[AutofillProfileItem class]]);
  AutofillProfileItem* profile_item_1 =
      base::mac::ObjCCastStrict<AutofillProfileItem>(item_1);
  EXPECT_TRUE([profile_item_1.name
      isEqualToString:GetNameLabelFromAutofillProfile(
                          *payment_request_->billing_profiles()[0])]);
  EXPECT_TRUE([profile_item_1.address
      isEqualToString:GetBillingAddressLabelFromAutofillProfile(
                          *payment_request_->billing_profiles()[0])]);
  EXPECT_TRUE([profile_item_1.phoneNumber
      isEqualToString:GetPhoneNumberLabelFromAutofillProfile(
                          *payment_request_->billing_profiles()[0])]);
  EXPECT_EQ(nil, profile_item_1.email);
  EXPECT_EQ(nil, profile_item_1.notification);

  CollectionViewItem* item_2 =
      [[GetMediator() selectableItems] objectAtIndex:1];
  DCHECK([item_2 isKindOfClass:[AutofillProfileItem class]]);
  AutofillProfileItem* profile_item_2 =
      base::mac::ObjCCastStrict<AutofillProfileItem>(item_2);
  EXPECT_TRUE([profile_item_2.name
      isEqualToString:GetNameLabelFromAutofillProfile(
                          *payment_request_->billing_profiles()[1])]);
  EXPECT_TRUE([profile_item_2.address
      isEqualToString:GetBillingAddressLabelFromAutofillProfile(
                          *payment_request_->billing_profiles()[1])]);
  EXPECT_TRUE([profile_item_2.phoneNumber
      isEqualToString:GetPhoneNumberLabelFromAutofillProfile(
                          *payment_request_->billing_profiles()[1])]);
  EXPECT_EQ(nil, profile_item_2.email);
  EXPECT_EQ(nil, profile_item_2.notification);
}

// Tests that the index of the selected item is as expected when there is no
// selected billing profile.
TEST_F(PaymentRequestBillingAddressSelectionMediatorTest, TestNoSelectedItem) {
  mediator_ = [[BillingAddressSelectionMediator alloc]
      initWithPaymentRequest:payment_request_.get()
      selectedBillingProfile:nil];

  NSArray<CollectionViewItem*>* selectable_items =
      [GetMediator() selectableItems];

  // There must be two selectable items.
  ASSERT_EQ(2U, selectable_items.count);

  // The selected item index must be invalid.
  EXPECT_EQ(NSUIntegerMax, GetMediator().selectedItemIndex);
}
