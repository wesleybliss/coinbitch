import 'package:coin_bitch/api.dart';
import 'package:coin_bitch/models/coin.dart';
import 'package:coin_bitch/widgets/coin_row.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final String title;

  const HomeScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Creates an instance of the Dio networking library
  final api = Api();

  // This is a "state" variable
  // We can update this using setState() which will automatically
  // update any part of the UI that's using it
  // Initially we start with an empty list of coins
  List<Coin> coins = [];

  /// Fetches coin pairs from the API
  /// It's a Future with async because we need to wait for the request to complete
  Future<void> fetchCoins() async {
    // Placeholder for the message we'll show the user
    String message = '';

    try {
      // Get the response from the API
      final response = await api.fetchCoins();

      // This just logs to our debug console
      print(response);

      // Update our screen's state so it knows to re-render
      setState(() {
        coins = response;
      });

      // Update our user-facing message with success
      message = 'Fetched all coins!';
    } catch (e) {
      print('Something broke! $e');

      // Update our user-facing message with error
      message = 'Something broke!';
    }

    // We do this dumb little check here, because since the
    // network request (fetch coins) could potentially take some time,
    // we may have lost our "context" before we reach this point
    // (i.e. the user navigated away to another screen, etc.)
    // So just make sure this component is still "mounted" before we proceed
    if (!mounted) return;

    // Create a snackbar message
    final snackBar = SnackBar(
      content: Text(message),
    );

    // ...and then show it at the bottom of the screen
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> onRefresh() async {
    print('Refreshing coins list');

    // When the user does a "pull to refresh" from the top of the screen,
    // fetch the coins list again
    await fetchCoins();
  }

  // We can put this code anywhere, but it's easier to read when
  // we define simpler functions like this one, which renders the
  // "empty" state, i.e. we have no coins
  Widget buildEmpty() {
    // A centered message to show
    const info = Center(child: Text('No coins loaded yet. Pull to refresh!'));

    // Here we wrap the message in this scroll view, because
    // typically the "pull to refresh" only works with a scrollable child
    // So here we're kind of tricking it to always work
    final scrollView = SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      // We use a sized box to take up the full screen height
      child: SizedBox(
          height: MediaQuery.of(context).size.height,
          // And we use a column here just to add some space above the message
          child: Column(children: const [
            SizedBox(height: 50),
            info,
          ])),
    );

    return scrollView;
  }

  Widget buildList() {
    return ListView.builder(
        itemCount: coins.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          // Get the coin by it's list index
          final coin = coins[index];

          // Build the actual row widget
          return CoinRow(coin: coin, index: index);
        });
  }

  @override
  void initState() {
    super.initState();

    // This gets called the first time this screen is rendered
    // We'd usually fetch the coins list here, but for demo purposes,
    // let's leave it off & make the user pull to refresh first
    // fetchCoins();
  }

  @override
  Widget build(BuildContext context) {
    // Here we can selectively choose what to render based on our data
    final content = coins.isEmpty ? buildEmpty() : buildList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: RefreshIndicator(
        color: Colors.green.shade500,
        backgroundColor: Colors.grey.shade100,
        onRefresh: onRefresh,
        child: content,
      ),
    );
  }
}
