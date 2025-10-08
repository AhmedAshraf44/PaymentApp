import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:payment_app/core/api_services.dart';
import 'package:payment_app/env.dart';
import 'package:payment_app/feature/checkout/data/model/payment_intent_model/payment_intent_model.dart';

import '../feature/checkout/data/model/ephemeral_kay_model/ephemeral_kay_model.dart';
import '../feature/checkout/data/model/payment_intent_input_model.dart';

class StripeServices {
  final ApiServices _apiServices = ApiServices();
  // 1. create Customer ID
  // --- from api when user register

  // 2. create payment intent
  Future<PaymentIntentModel> createPaymentIntent(
    PaymentIntentInputModel paymentIntent,
  ) async {
    var response = await _apiServices.post(
      'https://api.stripe.com/v1/payment_intents',
      body: paymentIntent.toJson(),
      headers: {'Authorization': 'Bearer ${Env.secretKey}'},
    );
    return PaymentIntentModel.fromJson(response.data);
  }

  // 3 Create Ephemeral Key
  Future<EphemeralKayModel> createEphemeralKey(
    PaymentIntentInputModel paymentIntent,
  ) async {
    var response = await _apiServices.post(
      'https://api.stripe.com/v1/ephemeral_keys',
      body: {'customer': 'cus_TCRhbobVW4B2Qd'},
      headers: {
        'Authorization': 'Bearer ${Env.secretKey}',
        'Stripe-Version': '2025-09-30.clover',
      },
    );
    return EphemeralKayModel.fromJson(response.data);
  }

  // 4- initialize the payment sheet
  Future<void> initPaymentSheet(
    String? paymentIntentClientSecret,
    String ephemeralKey,
  ) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        // Main params
        merchantDisplayName: 'Ahmed Ashraf',
        paymentIntentClientSecret: paymentIntentClientSecret,
        customerEphemeralKeySecret: ephemeralKey,
        customerId: 'cus_TCRhbobVW4B2Qd',
      ),
    );
  }

  Future<void> presentPaymentSheet() async {
    // 4. display the payment sheet
    await Stripe.instance.presentPaymentSheet();
  }

  Future<void> makePayment(PaymentIntentInputModel paymentIntent) async {
    var paymentIntentItem = await createPaymentIntent(paymentIntent);
    var ephemeralKeyItem = await createEphemeralKey(paymentIntent);
    await initPaymentSheet(
      paymentIntentItem.clientSecret,
      ephemeralKeyItem.secret!,
    );
    await presentPaymentSheet();
  }
}
