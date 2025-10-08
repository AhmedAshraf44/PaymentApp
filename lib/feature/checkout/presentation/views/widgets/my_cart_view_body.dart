import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payment_app/feature/checkout/data/repo/checkout_repo_imple.dart';
import 'package:payment_app/feature/checkout/presentation/manger/payment_cubit.dart';
import 'package:payment_app/feature/checkout/presentation/views/thank_you_view.dart';
import 'package:payment_app/feature/checkout/presentation/views/widgets/payment_methods_list_view.dart';
import 'package:payment_app/feature/checkout/presentation/views/widgets/total_price_widget.dart';

import '../../../../../core/widgets/custom_button.dart';
import '../../../data/model/payment_intent_input_model.dart'
    show PaymentIntentInputModel;
import '../../manger/payment_state.dart';
import 'cart_info_item.dart';

class MyCartViewBody extends StatelessWidget {
  const MyCartViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 18),
          Expanded(child: Image.asset('assets/images/basket_image.png')),
          const SizedBox(height: 25),
          const OrderInfoItem(title: 'Order Subtotal', value: r'42.97$'),
          const SizedBox(height: 3),
          const OrderInfoItem(title: 'Discount', value: r'0$'),
          const SizedBox(height: 3),
          const OrderInfoItem(title: 'Shipping', value: r'8$'),
          const Divider(thickness: 2, height: 34, color: Color(0xffC7C7C7)),
          const TotalPrice(title: 'Total', value: r'$50.97'),
          const SizedBox(height: 16),
          BuildBlocConsummer(),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class BuildBlocConsummer extends StatelessWidget {
  const BuildBlocConsummer({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      text: 'Complete Payment',
      onTap: () {
        // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        //   return const PaymentDetailsView();
        // }));

        showModalBottomSheet(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          builder: (context) {
            return const PaymentMethodsBottomSheet();
          },
        );
      },
    );
  }
}

class PaymentMethodsBottomSheet extends StatelessWidget {
  const PaymentMethodsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 16),
          PaymentMethodsListView(),
          SizedBox(height: 32),
          BlocProvider(
            create: (context) => PaymentCubit(CheckoutRepoImple()),
            child: CustomBlocConsummer(),
          ),
        ],
      ),
    );
  }
}

class CustomBlocConsummer extends StatelessWidget {
  const CustomBlocConsummer({super.key});

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
          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(
          //     content: Text('Payment Successful'),
          //     backgroundColor: Colors.green,
          //   ),
          // );
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
            PaymentIntentInputModel paymentIntent = PaymentIntentInputModel(
              amount: 10000,
              currency: 'USD',
              customerId: 'cus_TCRhbobVW4B2Qd',
            );
            BlocProvider.of<PaymentCubit>(context).makePayment(paymentIntent);
          },
          text: 'Continue',
          isLoading: state is PaymentLoading,
        );
      },
    );
  }
}
