import 'item.dart';

class ItemListTransactionModel {
  List<Item>? items;

  ItemListTransactionModel({this.items});

  factory ItemListTransactionModel.fromJson(Map<String, dynamic> json) {
    return ItemListTransactionModel(
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'items': items?.map((e) => e.toJson()).toList(),
  };
}
