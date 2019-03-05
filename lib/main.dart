import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

//import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
//import 'dart:io';
//import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:http/http.dart' as http;
import 'Post.dart';
import 'dart:convert';
import 'NetworkManager.dart';

//import 'dart:async';
//import 'package:http/browser_client.dart';
//https://oauth.vk.com/authorize?client_id=6784305&display=mobile&scope=262174&redirect_uri=https://oauth.vk.com/blank.html&response_type=token&v=5.92

//void main() => runApp(MyApp());
//void main() => runApp(MyApp(post: fetchPost()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      routes: {
        "/": (_) => new VkWebView(),
      },
    );
  }
}


void main() {
  runApp(MaterialApp(
    title: 'Navigation Basics',
    home: FirstRoute(),
  ));
}



Future<Post> fetchPost() async {
  final response =
      await http.get('https://jsonplaceholder.typicode.com/posts/1');

  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON
    return Post.fromJson(json.decode(response.body));
  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to load post');
  }
}
/*
class MyApp extends StatelessWidget {
  final Future<Post> post;

  MyApp({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<Post>(
            future: post,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.title);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
*/


//id 392688129
//https://api.vk.com/method/video.get?owner_id=392688129&id=3&access_token=cd1bbea0000d612d05b7fec9d2a6f85f18c7382dacca59542e5a32e531950ec51d75ff339dbb15af967d6&v=5.92


class VkWebView extends StatefulWidget {
@override
VkWebViewState createState() => new VkWebViewState();
}

class VkWebViewState extends State<VkWebView> {

  Widget build(BuildContext context) {

  final flutterWebviewPlugin = new FlutterWebviewPlugin();
    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (url.contains("access_token")) {
        final tempString = url.split("=");
        final token = tempString[1].split("&").first;
        print("printing token string = $token");
        var networkManager = new NetworkManager();
        if (networkManager.firstToken.isEmpty) {
          networkManager.firstToken = token;
        } else if (!networkManager.firstToken.isEmpty && token != networkManager.firstToken){
          networkManager.secondToken = token;
        }
        print("full response string = $url");
        
        final testRequest = http.get('https://jsonplaceholder.typicode.com/posts/1');
        testRequest.then((result) {
          final groups = result.body;
          print("groups result = $groups");
          //https://oauth.vk.com/authorize?client_id=6784305&display=mobile&scope=262174&redirect_uri=https://oauth.vk.com/blank.html&response_type=token&v=5.92"
          //flutterWebviewPlugin.close();

          
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MainMenu()),
            );
            
        });

        flutterWebviewPlugin.close();
      }
    });
    return new WebviewScaffold(
      url: new NetworkManager().authURL,
      appBar: new AppBar(
      title: new Text('Vk authentificate')
      ),
    );
  }
}

class RandomWordsState extends State<RandomWords> {

  final List<WordPair> _suggestions = <WordPair>[];
  final Set<WordPair> _saved = new Set<WordPair>();
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);


void _pushSaved() {
  Navigator.of(context).push(
    new MaterialPageRoute<void>(
      builder: (BuildContext context) {
        final Iterable<ListTile> tiles = _saved.map(
          (WordPair pair) {
            return new ListTile(
              title: new Text(
                pair.asPascalCase,
                style: _biggerFont,
              ),
            );
          },
        );
        final List<Widget> divided = ListTile
          .divideTiles(
            context: context,
            tiles: tiles,
          )
              .toList();

        return new Scaffold(         // Add 6 lines from here...
          appBar: new AppBar(
            title: const Text('Saved Suggestions'),
          ),
          body: new ListView(children: divided),
        );                           // ... to here.
      },
    ),
  );
}

 @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Name generator'),
        actions: <Widget>[
          new IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved)
        ],
      ),
      body: _buildSuggestions(),
    );
  }
  
  Widget _buildSuggestions() {
    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      // The itemBuilder callback is called once per suggested 
      // word pairing, and places each suggestion into a ListTile
      // row. For even rows, the function adds a ListTile row for
      // the word pairing. For odd rows, the function adds a 
      // Divider widget to visually separate the entries. Note that
      // the divider may be difficult to see on smaller devices.
      itemBuilder: (BuildContext _context, int i) {
        // Add a one-pixel-high divider widget before each row 
        // in the ListView.
        if (i.isOdd) {
          return new Divider();
        }

        // The syntax "i ~/ 2" divides i by 2 and returns an 
        // integer result.
        // For example: 1, 2, 3, 4, 5 becomes 0, 1, 1, 2, 2.
        // This calculates the actual number of word pairings 
        // in the ListView,minus the divider widgets.
        final int index = i ~/ 2;
        // If you've reached the end of the available word
        // pairings...
        if (index >= _suggestions.length) {
          // ...then generate 10 more and add them to the 
          // suggestions list.
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      }
    );
  }

    Widget _buildRow(WordPair pair) {
      final bool alreadySaved = _saved.contains(pair);
    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.arrow_right : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
                  if (alreadySaved) {
                    _saved.remove(pair);
                  } else {
                    _saved.add(pair);
                  }
                });
                //final link = http.get('https://api.vk.com/method/users.get?user_id=210700286&v=5.52');
                //link.then((response){
                  //print("Response status: ${response.statusCode}");
                  //print("Response body: ${response.body}");
                //});

                  //var client = new BrowserClient();
                  //var url = '/whatsit/create';
                  //var response = client.get('https://api.vk.com/method/users.get?user_id=210700286&v=5.52');
                  //response.then((response) {
                  //print(response.body);

  });
  //print('Response status: ${response.statusCode}');
  //print('Response body: ${response.body}');
  }

}

class RandomWords extends StatefulWidget {
 @override
 RandomWordsState createState() => new RandomWordsState();
}

class FirstRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authenticate'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Login VK'),
          onPressed: () {
            // Navigate to second route when tapped.
              Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyApp()),
            );
          },
        ),
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            // Navigate back to first route when tapped.
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}

enum Options { 
  groups, 
  photos, 
  videos, 
  wall, 
  friends, 
  favorite, 
  bookmates }
              
class MainMenu extends StatelessWidget { 

  //Options.pho

  final List<String> _options =['Groups', 'Photos', 'Videos', 'Wall', 'Friends', 'Favorite', 'Bookmates'];

  var networkManager = new NetworkManager();

  void _openOption() {
    //Navigator.push(context, route)
    /*
  Navigator.push(context, MaterialPageRoute<void>( builder: (BuildContext context) {
        final Iterable<ListTile> tiles = _saved.map(
          (WordPair pair) {
            return new ListTile(
              title: new Text(
                pair.asPascalCase,
                style: _biggerFont,
              ),
            );
          },
        );
        final List<Widget> divided = ListTile
          .divideTiles(
            context: context,
            tiles: tiles,
          )
              .toList();

        return new Scaffold(         // Add 6 lines from here...
          appBar: new AppBar(
            title: const Text('Saved Suggestions'),
          ),
          body: new ListView(children: divided),
        );                           // ... to here.
      },
    ),
  );

  */
}



 @override
 Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Main menu')
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      // The itemBuilder callback is called once per suggested 
      // word pairing, and places each suggestion into a ListTile
      // row. For even rows, the function adds a ListTile row for
      // the word pairing. For odd rows, the function adds a 
      // Divider widget to visually separate the entries. Note that
      // the divider may be difficult to see on smaller devices.
      itemBuilder: (BuildContext _context, int i) {
        // Add a one-pixel-high divider widget before each row 
        // in the ListView.
        if (i.isOdd) {
          return new Divider();
        }

        // The syntax "i ~/ 2" divides i by 2 and returns an 
        // integer result.
        // For example: 1, 2, 3, 4, 5 becomes 0, 1, 1, 2, 2.
        // This calculates the actual number of word pairings 
        // in the ListView,minus the divider widgets.

        final int index = i ~/ 2;

        print('options index = $index');
        print('options count = ${_options.length}');

        if (index <= _options.length * 2) {

        }

        return _buildRow(_options[index]);
      },
      itemCount: _options.length * 2,
    );
  }

    Widget _buildRow(String option) {

      print('build row with options count = ${_options.length}');
      
    return new ListTile(
      title: new Text(
        option
      ),
      trailing: new Icon(Icons.arrow_forward_ios),
      onTap: () {
        final String rowTitle = option.toLowerCase();
        Options selectedOption = Options.values.firstWhere((e) => e.toString() == 'Options.' + rowTitle);

        switch (selectedOption) {
          case Options.groups:
          //Navigator.push(context, route)
            print('selected groups!');
            var groups = http.get(networkManager.groupsURL());
 
            break;
          case Options.photos:
            print('selected photos!');
            //var photoAlbums = http.get(networkManager.photoAlbumsURL);
            break;
          case Options.videos:
            print('selected videos!');
            //var videos = http.get(networkManager.videosURL);
            break;
          case Options.wall:
            print('selected wall!');
            break;
          case Options.friends:
            print('selected friends!');
            break;
          case Options.favorite:
            print('selected favorite!');
            break;
          case Options.bookmates:
            print('selected bookmates!');
            break;
          default: // Without this, you see a WARNING.
            print('Selected option not handled ($selectedOption)');
} 
        
  });
  //print('Response status: ${response.statusCode}');
  //print('Response body: ${response.body}');
  }


 //RandomWordsState createState() => new RandomWordsState();
 
 
}


/*
var videos = http.get(networkManager.videosURL);
        var groups = http.get(networkManager.groupsURL);
        var photoAlbums = http.get(networkManager.photoAlbumsURL);

*/

//



