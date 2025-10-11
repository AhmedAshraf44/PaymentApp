import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:payment_app/feature/checkout/presentation/manger/payment_cubit.dart';
import 'package:payment_app/feature/checkout/presentation/manger/payment_state.dart';

import '../../../../../core/widgets/custom_button.dart';
import '../../../data/model/amount_paypal_model/amount_paypal_model.dart'
    show AmountPaypalModel;
import '../../../data/model/amount_paypal_model/details.dart';
import '../../../data/model/item_list_transaction_model/item.dart';
import '../../../data/model/payment_intent_input_model.dart';
import '../thank_you_view.dart';

class CustomBlocConsummer extends StatelessWidget {
  const CustomBlocConsummer({super.key, required this.isPaypal});
  final bool isPaypal;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentCubit, PaymentState>(
      listener: (context, state) {
        if (state is PaymentFailure) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is PaymentSuccess) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) {
                return const ThankYouView();
              },
            ),
          );
        }
      },
      builder: (context, state) {
        return CustomButton(
          onTap: () {
            if (isPaypal) {
              // 2- Handle PayPal Payment
              paypalMethod(context);
            } else {
              // 1- Handle Stripe Payment
              stripeMethod(context);
            }
          },
          text: 'Continue',
          isLoading: state is PaymentLoading,
        );
      },
    );
  }

  void stripeMethod(BuildContext context) {
    PaymentIntentInputModel paymentIntent = PaymentIntentInputModel(
      amount: 10000,
      currency: 'USD',
      customerId: 'cus_TCRhbobVW4B2Qd',
    );
    BlocProvider.of<PaymentCubit>(context).makePayment(paymentIntent);
  }

  void paypalMethod(BuildContext context) {
    AmountPaypalModel amount = AmountPaypalModel(
      total: '100',
      currency: 'USD',
      details: Details(subtotal: '100', shipping: '0', shippingDiscount: 0),
    );
    List<Item> itemList = [
      Item(name: "Apple", quantity: 5, price: '10', currency: "USD"),
      Item(name: "Pineapple", quantity: 5, price: '10', currency: "USD"),
    ];
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => PaypalCheckoutView(
          sandboxMode: true,
          clientId:
              "AbrhDG0aKfqeuNa65wxoQviax6S6e1UvqYoVY0eBI1cTxRN89en_8FXBlJf26h3SWqOj8b6I1Yq8GItQ",
          secretKey:
              "EC-k8ObB3FdwWjW3-3-6UjCKOfkpMU5q3JyKHRhEzO-0htfd-PXNN1-XB9ec6LgiT1yQKHjR7eW6iv9F",
          transactions: [
            {
              "amount": amount,
              "description": "The payment transaction description.",
              "item_list": {"items": itemList},
            },
          ],
          note: "Contact us for any questions on your order.",
          onSuccess: (Map params) async {
            log("onSuccess: $params");
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const ThankYouView()),
              (route) {
                log(route.toString());
                if (route.settings.name == '/') {
                  return true;
                }
                return false;
              },
            );
          },
          onError: (error) {
            log("onError: $error");
            Navigator.pop(context);
            Navigator.pop(context);
          },
          onCancel: () {
            log('cancelled:');
          },
        ),
      ),
    );
  }
}
