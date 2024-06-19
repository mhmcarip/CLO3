import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newsample/datakelompok.dart';
import 'package:newsample/drinkdetail.dart';
import 'package:newsample/minuman1.dart';
import 'package:newsample/minuman2.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var api = "https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=Cocktail";
  var res, drinks;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    res = await http.get(Uri.parse(api));
    drinks = jsonDecode(res.body)["drinks"];
    print(drinks.toString());
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.brown,
          Colors.lightBlue,
        ]),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text("Cocktail App"),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 15),
              child: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(context: context, delegate: DrinkSearchDelegate(drinks));
                },
              ),
            ),
          ],
        ),
        drawer: drawer(),
        body: Center(
          child: res != null
              ? ListView.builder(
                  itemCount: drinks.length,
                  itemBuilder: (context, index) {
                    var drink = drinks[index];
                    return ListTile(
                      leading: Hero(
                        tag: drink["idDrink"],
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            drink["strDrinkThumb"] ??
                                "http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg",
                          ),
                        ),
                      ),
                      title: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "${drink["strDrink"]}",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        "${drink["idDrink"]}",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DrinkDetail(drink: drink),
                          ),
                        );
                      },
                    );
                  },
                )
              : CircularProgressIndicator(backgroundColor: Colors.white),
        ),
      ),
    );
  }

  Widget drawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              "Cafe Joni",
              textAlign: TextAlign.end,
              style: TextStyle(color: Colors.blue),
            ),
            accountEmail: Text(
              "Joni@gmail.com",
              style: TextStyle(color: Colors.blue),
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: ExactAssetImage('assets/images/bgg.jpg'),
                fit: BoxFit.fill,
              ),
            ),
            currentAccountPicture: Image.asset("assets/images/eudeka.png"),
          ),
          ExpansionTile(
            leading: Icon(
              Icons.folder,
              color: Colors.lightBlue,
            ),
            title: Text("Minuman"),
            trailing: Icon(Icons.arrow_drop_down),
            children: <Widget>[
              ListTile(
                title: Text("Minuman Alkohol"),
                trailing: Icon(Icons.arrow_right),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MinumanSatu(),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text("Minuman Non-Alkohol"),
                trailing: Icon(Icons.arrow_right),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MinumanDua(),
                    ),
                  );
                },
              ),
            ],
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.info,
              color: Colors.lightBlue,
            ),
            title: Text("Tentang"),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => DataKelompok()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Colors.lightBlue,
            ),
            title: Text("Keluar"),
            onTap: () {
              SystemNavigator.pop();
            },
          ),
        ],
      ),
    );
  }
}

class DrinkSearchDelegate extends SearchDelegate {
  final List drinks;

  DrinkSearchDelegate(this.drinks);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: AppBarTheme(
        color: Colors.brown,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      textTheme: TextTheme(
        headline6: TextStyle(color: Colors.white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white),
        border: InputBorder.none,
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear, color: Colors.white),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = drinks.where((drink) => drink["strDrink"].toLowerCase().contains(query.toLowerCase())).toList();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.brown,
          Colors.lightBlue,
        ]),
      ),
      child: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          var drink = results[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                drink["strDrinkThumb"] ??
                    "http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg",
              ),
            ),
            title: Text("${drink["strDrink"]}", style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DrinkDetail(drink: drink),
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = drinks.where((drink) => drink["strDrink"].toLowerCase().contains(query.toLowerCase())).toList();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.brown,
          Colors.lightBlue,
        ]),
      ),
      child: ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          var drink = suggestions[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                drink["strDrinkThumb"] ??
                    "http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg",
              ),
            ),
            title: Text("${drink["strDrink"]}", style: TextStyle(color: Colors.white)),
            onTap: () {
              query = drink["strDrink"];
              showResults(context);
            },
          );
        },
      ),
    );
  }
}