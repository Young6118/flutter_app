import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // 应用的根组件
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '欢迎使用新青柚天气',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: RandomWords(),
    );
  }
}

class RandomWordsState extends State<RandomWords> {
  // Set 元组不允许重复元素，不同于 List
  final Set<WordPair> _saved = Set<WordPair>();
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return Divider(); /*2*/

          final index = i ~/ 2; /*3*/
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10)); /*4*/
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final bool alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        //  setState 之后会重新 build 组件
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  Widget build(BuildContext context) {
    void _pushSaved() {
      // 导航切换路由到新页面
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (BuildContext context) {
            // 遍历 _saved 元组生成可迭代的 ListTile 实例 tiles
            final Iterable<ListTile> tiles = _saved.map(
              (WordPair pair) {
                return ListTile(
                  title: Text(
                    pair.asPascalCase,
                    style: _biggerFont,
                  ),
                );
              },
            );

            // 列表组件 toList() 方法生成列表
            final List<Widget> divided = ListTile.divideTiles(
              context: context,
              tiles: tiles,
            ).toList();

            return Scaffold(
              appBar: AppBar(
                title: Text('收藏夹'),
              ),
              // ListView 组件，包含 divided 组件
              body: ListView(children: divided),
            ); 
          },
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
            title: Text('单词本'),
            actions: <Widget>[
              IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
            ],
          ),
          body: _buildSuggestions()
        );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}
