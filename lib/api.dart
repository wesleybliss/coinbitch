/*
If you visit the API URL in your browser, you'll see it responds
with JSON (JavaScript Object Notation), which is just a structured
text format. The response looks like this:

{
    "rates": {
        "btc": {
            "name": "Bitcoin",
            "unit": "BTC",
            "value": 1.0,
            "type": "crypto"
        },
        "eth": {
            "name": "Ether",
            "unit": "ETH",
            "value": 13.681,
            "type": "crypto"
        },
        ... etc with other coin pairs ...
    }
}

This format is also known as a dictionary, so we can access it using square brackets.
For example, to get the unit & value of ETH, we can do:

final name = response.rates['eth']['unit'];
final value = double.parse(response.rates['eth']['value']);

print('$name is currently at $value');

Note we parse the double (2+ decimal points) so we get a real number.
*/
import 'package:coin_bitch/constants.dart';
import 'package:coin_bitch/models/coin.dart';
import 'package:dio/dio.dart';

/// A basic API class we can use to organize all of our network requests
class Api {
  /// An instance of the Dio networking library
  final dio = Dio();

  /// Fetches coin pairs from the API
  /// It's a Future with async because we need to wait for the request to complete
  /// Note that we're not doing any try/catch error checking here.
  /// We let the calling function (the "presentation layer") handle that.
  /// All we care about here is getting the data in a nice usable format.
  /// If something breaks, this will throw an error.
  Future<List<Coin>> fetchCoins() async {
    // Get the response from the API
    // A response in this case is a Dio instance of the Response class
    // (You can CTRL/CMD+Click on Response to see it's code)
    final Response res = await dio.get(Constants.apiUrl);

    // Let's log the response too, so we can see what we got back
    print('fetchCoins() response: $res');

    // Attempt to convert the data into instances of our Coin class
    // If something breaks, this will just bail & throw an error
    final Map<String, dynamic> rates = res.data['rates'];

    // Now we take all of the coin data from the top-level "rates" property
    // and convert it into instances of our Coin class
    // A "fold" operation is similar to a map, but lets you convert the input
    // to a different type of output
    // Example: Given an array of numbers
    // final numbers = [1, 2, 3, 4, 5];
    //
    // If we want to multipy them all by 2, we can use a map:
    // final List<int> numbersDoubled = numbers.map((e) => e * 2).toList();
    // Which would give us [2, 4, 6, 8, 10]
    //
    // If we want to convert them all to say "Number: N", we can use a fold:
    // final List<String> numbersLabeled = numbers.fold([], (acc, it) => acc..add('Number: $it'));
    // Which would give us [Number: 1, Number: 2, Number: 3, Number: 4, Number: 5]

    // This is the initial value we want to start the fold with: an empty list of coins
    final List<Coin> initialValue = [];

    // Now fold all of the dictionaries from the HTTP response into Coin instances
    final List<Coin> coins = rates.entries.fold(initialValue, (previousValue, element) {
      // Create a new coin from the dictionary
      // At this point, element.value should look like:
      // {
      //     "name": "Bitcoin",
      //     "unit": "BTC",
      //     "value": 1.0,
      //     "type": "crypto"
      // }
      final newCoin = Coin.fromMap(element.value);

      // Add the new coin to the previous iteration of the loop
      // If this is the first iteration, previousValue will be our initialValue
      previousValue.add(newCoin);

      // Return the running value. This is also known as an accumulator,
      // bc it accumulates the results of the fold loop
      return previousValue;
    });

    // This can also be written more compactly like:
    /*final List<Coin> coins = rates.entries.fold([], (acc, it) => acc..add(Coin.fromMap(it.value)));*/

    // Now that we have a list of coins, return it to the caller
    return coins;
  }
}
