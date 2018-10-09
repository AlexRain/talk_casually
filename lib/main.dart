import 'package:flutter/material.dart';

void main() => runApp(new TalkcasuallyApp());

class TalkcasuallyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Talk everywhere',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  State createState() => new _ChatScreen();
}

class _ChatScreen extends State<ChatScreen> with TickerProviderStateMixin {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = new TextEditingController();

  bool _btnEnabled = false;

  void _handleSubmitted(String text) {
    if (text.isEmpty) return;
    _textController.clear();
    setState(() {
          _btnEnabled = false;
        });
    ChatMessage message = new ChatMessage(
      text: text,
      animationController: new AnimationController(
        duration: new Duration(milliseconds: 300),
        vsync: this,
      ),
    );

    ///向消息列表中添加消息
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  void _handleTextChanged(String str){
    _btnEnabled = str.isNotEmpty;
    setState(() {
          
        });
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages)
      message.animationController.dispose();
    super.dispose();
  }

  ///发送按钮颜色
  var _color = Colors.lightBlue;

  Widget _buildTextComposer() {
    var iconBtn = new IconButton(
        icon: new Icon(
          Icons.send,
          color: _btnEnabled?_color:Colors.grey,
        ),
        onPressed: () => _handleSubmitted(_textController.text));

    var btnContainer = new Container(
        margin: new EdgeInsets.symmetric(horizontal: 4.0), child: iconBtn);

    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: new Row(children: <Widget>[
            new Flexible(
                child: new TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              onChanged: _handleTextChanged,
              decoration:
                  new InputDecoration.collapsed(hintText: 'send message'),
            )),
            btnContainer,
          ])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Talk everywhere'),
      ),
      body: new Column(
        children: <Widget>[
          new Flexible(
            child: new ListView.builder(
              padding: new EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) => _messages[index],
              itemCount: _messages.length,
            ),
          ),
          new Divider(height: 1.0),
          new Container(
            decoration: new BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }
}

const String _name = "hekaiyou";

class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.animationController});
  final String text;
  final AnimationController animationController;
  @override
  Widget build(BuildContext context) {
    return SizeTransition(
        sizeFactor: new CurvedAnimation(
          parent: animationController,
          curve: Curves.easeOut,
        ),
        axisAlignment: 0.0,
        child: new Container(
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            child: new Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    margin: const EdgeInsets.only(right: 16.0),
                    child: new CircleAvatar(child: new Text(_name[0])),
                  ),
                  new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(_name,
                            style: Theme.of(context).textTheme.subhead),
                        new Container(
                          margin: const EdgeInsets.only(top: 5.0),
                          child: new Text(text),
                        )
                      ])
                ])));
  }
}
