import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:payment_app/core/api_services.dart';
import 'package:payment_app/env.dart';
import 'package:payment_app/feature/checkout/data/payment_intent_model/payment_intent_model.dart';

class StripeServices {
  final ApiServices _apiServices = ApiServices();
  Future<PaymentIntentModel> createPaymentIntent(
    PaymentIntentModel paymentIntent,
  ) async {
    var response = await _apiServices.post(
      'https://api.stripe.com/v1/payment_intents',
      body: paymentIntent.toJsonForCreate(),
      headers: {'Authorization': 'Bearer ${Env.secretKey}'},
    );
    return PaymentIntentModel.fromJson(response.data);
  }

  Future<void> initPaymentSheet(String? paymentIntentClientSecret) async {
    // 2. initialize the payment sheet
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        // Main params
        merchantDisplayName: 'Ahmed Ashraf',
        paymentIntentClientSecret: paymentIntentClientSecret,
      ),
    );
  }

  Future<void> presentPaymentSheet() async {
    // 3. display the payment sheet
    await Stripe.instance.presentPaymentSheet();
  }

  Future<void> makePayment(PaymentIntentModel paymentIntent) async {
    var paymentIntentItem = await createPaymentIntent(paymentIntent);
    await initPaymentSheet(paymentIntentItem.clientSecret);
    await presentPaymentSheet();
  }
}
