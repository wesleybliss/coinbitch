import 'package:flutter/material.dart';

@immutable
class Coin {
  final String name;
  final String unit;
  final double value;

  /// This is a constructor. It's the function that gets called
  /// when you create a new instance of this class.
  /// In our case, all of the fields are required, but sometimes they can be optional.
  const Coin({
    required this.name,
    required this.unit,
    required this.value,
  });

  /// This is a factory. It's essentially a static function that
  /// makes a new Coin. In our case, we're taking in a dynamic map
  /// (a dictionary of key/values), and taking the data we need from it
  factory Coin.fromMap(Map<String, dynamic> data) => Coin(
        name: data['name'],
        unit: data['unit'],
        value: data['value'],
      );
}
