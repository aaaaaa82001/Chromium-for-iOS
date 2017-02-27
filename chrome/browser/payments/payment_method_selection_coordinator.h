// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#ifndef IOS_CHROME_BROWSER_PAYMENTS_PAYMENT_METHOD_SELECTION_COORDINATOR_H_
#define IOS_CHROME_BROWSER_PAYMENTS_PAYMENT_METHOD_SELECTION_COORDINATOR_H_

#import <UIKit/UIKit.h>
#include <vector>

#import "ios/chrome/browser/chrome_coordinator.h"
#import "ios/chrome/browser/payments/payment_method_selection_view_controller.h"
#include "ios/chrome/browser/payments/payment_request.h"

namespace autofill {
class CreditCard;
}

@class PaymentMethodSelectionCoordinator;

// Delegate protocol for PaymentMethodSelectionCoordinator.
@protocol PaymentMethodSelectionCoordinatorDelegate<NSObject>

// Notifies the delegate that the user has selected a payment method.
- (void)paymentMethodSelectionCoordinator:
            (PaymentMethodSelectionCoordinator*)coordinator
                   didSelectPaymentMethod:(autofill::CreditCard*)paymentMethod;

// Notifies the delegate that the user has chosen to return to the previous
// screen without making a selection.
- (void)paymentMethodSelectionCoordinatorDidReturn:
    (PaymentMethodSelectionCoordinator*)coordinator;

@end

// Coordinator responsible for creating and presenting the payment method
// selection view controller. This view controller will be presented by the view
// controller provided in the initializer.
@interface PaymentMethodSelectionCoordinator
    : ChromeCoordinator<PaymentMethodSelectionViewControllerDelegate>

// The PaymentRequest object owning an instance of web::PaymentRequest as
// provided by the page invoking the Payment Request API. This pointer is not
// owned by this class and should outlive it.
@property(nonatomic, assign) PaymentRequest* paymentRequest;

// The delegate to be notified when the user selects a payment method or returns
// without selecting a payment method.
@property(nonatomic, weak)
    id<PaymentMethodSelectionCoordinatorDelegate> delegate;

@end

#endif  // IOS_CHROME_BROWSER_PAYMENTS_PAYMENT_METHOD_SELECTION_COORDINATOR_H_
