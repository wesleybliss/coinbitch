import 'package:coin_bitch/models/coin.dart';
import 'package:flutter/material.dart';

/// A simple list row showing details about a [Coin]
/// A coin is required when creating an instance of this widget
/// When rendered, this will look like:
///  -------------------------------------------
/// | ETH (large font)           1.234 (price) |
/// | Ethereum                                 |
/// |-------------------------------------------
class CoinRow extends StatelessWidget {
  /// The coin we'll show
  final Coin coin;

  /// The index within the list
  /// This is just so we can show alternating row colors
  final int index;

  const CoinRow({Key? key, required this.coin, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Our coin "header" info to be shown on the left
    final header = Column(
      // Align children to the start of the cross axis (e.g. totally left, horizontally)
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(coin.unit, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(coin.name),
      ],
    );

    // The price, to be shown on the right
    final price =
        Text('${coin.value}', textAlign: TextAlign.end, style: const TextStyle(color: Colors.green, fontSize: 30));

    // Here's our actual row, that renders horizontally
    final row = Row(
      // We tell the row to use the maximum space between it's children, so the
      // header will be on the left, and the price all the way on the right of the screen
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        header,
        price,
      ],
    );

    // Let's wrap that in some padding so it's nicely spaced out
    final paddedRow = Padding(padding: const EdgeInsets.all(16), child: row);

    // Let's alternate the background color based on the index
    // We can use the % (modulus) operator for this
    bool isEvenRow = ((index % 2) == 0);

    Color? color = isEvenRow ? Colors.grey.shade200 : null;

    final container = Container(
      color: color,
      child: paddedRow,
    );

    return container;
  }
}
