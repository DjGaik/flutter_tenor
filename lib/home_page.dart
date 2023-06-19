import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path_provider/path_provider.dart';

import 'gif_cards.dart';
import 'main.dart';
import 'single_gif_card.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final IconData _iconLight = Icons.wb_sunny;
  final IconData _iconDark = Icons.nights_stay;
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  String apiKey = 'LIVDSRZULELA';
  int limit = 10;
  List<String> gifUrls = [];
  List<String> autocompleteData = [];

  Future<void> getGIFFromAPI(String searchInput) async {
    final response = await Dio().get(
        'https://g.tenor.com/v1/search?q=$searchInput&key=$apiKey&limit=$limit');
    gifUrls.clear();
    for (int i = 0; i < limit; i++) {
      gifUrls.add(response.data['results'][i]['media'][0]['mediumgif']['url']);
    }
    setState(() {});
  }

  Future<void> getGIFAutocomplete(String searchInput) async {
    final response = await Dio().get(
        'https://g.tenor.com/v1/autocomplete?q=$searchInput&key=$apiKey&limit=$limit');
    autocompleteData.clear();
    autocompleteData.addAll(
        (response.data['results'] as List).map((item) => item as String));
    setState(() {});
  }

  void singleGifScreen(String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => SingleGifCard(imageUrl: imageUrl),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetScreens = <Widget>[
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: Autocomplete(
              fieldViewBuilder:
                  (context, controller, focusNode, onEditingComplete) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  onEditingComplete: onEditingComplete,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Пошук картинок ...',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => controller.clear(),
                    ),
                    prefixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        getGIFFromAPI(controller.text);
                        autocompleteData.clear();
                        focusNode.unfocus();
                      },
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.green,
                        width: 3,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                );
              },
              optionsBuilder: (TextEditingValue value) {
                getGIFAutocomplete(value.text);

                return autocompleteData;
              },
              onSelected: (String selected) {
                getGIFFromAPI(selected);
              },
            ),
          ),
          gifUrls.isEmpty
              ? const Center(
                  child: Text(
                    "Не знайдено жодної картинки",
                    textAlign: TextAlign.center,
                  ),
                )
              : SizedBox(
                  child: GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(10.0),
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    children: List.generate(gifUrls.length, (index) {
                      return GestureDetector(
                        child: GifCards(gifUrls[index]),
                        onTap: () {
                          singleGifScreen(gifUrls[index]);
                        },
                      );
                    }),
                  ),
                ),
        ],
      ),
      const Text(
        'Улюблені',
        style: optionStyle,
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Налаштування',
            style: optionStyle,
          ),
          IconButton(
            onPressed: () {
              MyApp.of(context).changeTheme();
              setState(() {});
            }, icon: Icon(MyApp.of(context).themeMode ? _iconLight : _iconDark),
          ),
        ],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                child: widgetScreens[_selectedIndex],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        iconSize: 35,
        selectedFontSize: 14,
        unselectedFontSize: 12,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Головна',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Улюблені',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Налаштування',
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
