import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const String _title = 'Flutter con il GDG di Firenze!';
    return MaterialApp(
      title: _title,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyFirstList(title: _title),
    );
  }
}

class MyFirstList extends StatefulWidget {
  const MyFirstList({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyFirstListState createState() => _MyFirstListState();
}

class _MyFirstListState extends State<MyFirstList> {
  List<String> talks;
  //done: 4.1) Use the documentation to implement the TextEditingController:
  ///  * Learn how to use a [TextEditingController] in one of our [cookbook recipes](https://flutter.dev/docs/cookbook/forms/text-field-changes#2-use-a-texteditingcontroller).
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    talks = ['Talk su Flutter', 'Talk su Angular', 'Spritz di benvenuto'];
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //done: 1) Implement the Scaffold (appBar and body)
    //old: return _myFancylist();
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: _myFancylist(),
      //done: 3) Implement the custom input text row
      floatingActionButton: _inputTextRow(),
    );
  }

  Widget _myFancylist() {
    return ListView.builder(
      padding: const EdgeInsets.all(20.0),
      itemCount: talks.length,
      itemBuilder: (BuildContext context, int index) {
        //old: return Text(talks[index]);
        //done: 2) Remove the text widget and create a custom row
        return _listItem(context, index);
      },
    );
  }

  Widget _listItem(contex, index) {
    //done: 2.1) create a custom row using Card and ListTile (leading and title)

    //done: 6) Wrap the custom row with the Dismissible widget
    //done: 7) Implement onDismissed
    return Dismissible(
      key: Key(talks[index]),
      onDismissed: (direction) {
        _showSnackBar(contex, index);
        _removeTalk(index);
      },
      background: dismissableBackground(),
      child: Card(
        child: ListTile(
          leading: const Icon(Icons.star),
          title: Text(talks[index]),
        ),
      ),
    );
  }

  Row _inputTextRow() {
    return Row(
      children: [
        //done: 4) Implement the custom inputField
        //done: _inputField()
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: _inputField(),
          ),
        ),
        FloatingActionButton(
          tooltip: 'Add a talk',
          child: const Icon(Icons.send),
          onPressed: () {
            //done 5) Call the setState if the text is not empty
            if (_textController.text.isNotEmpty) {
              setState(() {
                talks.add(_textController.text);
                _textController.text = '';
              });
            }
          },
        ),
      ],
    );
  }

  TextField _inputField() {
    return TextField(
      controller: _textController,
      textAlign: TextAlign.left,
    );
  }

  // Use the following code to implement the Dismissible Widget
  void _showSnackBar(context, index) {
    final String _talk = talks[index];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$_talk deleted'),
        action: SnackBarAction(
          label: "UNDO",
          onPressed: () {
            _undoDelete(index, _talk);
          },
        ),
        behavior: SnackBarBehavior.fixed,
        duration: const Duration(milliseconds: 2000),
      ),
    );
  }

  void _undoDelete(index, talk) {
    setState(() {
      talks.insert(index, talk);
    });
  }

  void _removeTalk(index) {
    setState(() {
      talks.removeAt(index);
    });
  }

  Container dismissableBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20.0),
      color: Colors.red,
      child: const Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }
}
