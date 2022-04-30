/// This is just a plain Dart file
/// We store the title here so we don't have to keep typing/copying it
/// This helps prevent typos
/// Also in the future, we can use this as a base for translations
/// Note this class is "abstract" meaning we can't create an instance of it
/// So whenever we want to use it, we use it directly, like Constants.title
abstract class Constants {
  /// The title of the app
  static const title = 'Coin Bitch';

  /// This is the API URL we want to fetch coin pairs from
  static const apiUrl = 'https://api.coingecko.com/api/v3/exchange_rates';
}
