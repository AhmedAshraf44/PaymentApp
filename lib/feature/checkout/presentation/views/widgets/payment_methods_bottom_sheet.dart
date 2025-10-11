import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repo/checkout_repo_imple.dart';
import '../../manger/payment_cubit.dart';
import 'custom_bloc_consummer.dart';
import 'payment_methods_list_view.dart';

class PaymentMethodsBottomSheet extends StatefulWidget {
  const PaymentMethodsBottomSheet({super.key});

  @override
  State<PaymentMethodsBottomSheet> createState() =>
      _PaymentMethodsBottomSheetState();
}

class _PaymentMethodsBottomSheetState extends State<PaymentMethodsBottomSheet> {
  bool isPaypal = false;

  isupdated({required int index}) {
    if (index == 0) {
      isPaypal = false;
    } else {
      isPaypal = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 16),
          PaymentMethodsListView(isupdated: isupdated),
          SizedBox(height: 32),
          BlocProvider(
            create: (context) => PaymentCubit(CheckoutRepoImple()),
            child: CustomBlocConsummer(isPaypal: isPaypal),
          ),
        ],
      ),
    );
  }
}
