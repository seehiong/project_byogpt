import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './models/chat_model.dart';
import '../widgets/user_input.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final chatcontroller = TextEditingController();

    return MaterialApp(
      title: "OpenAI Chat",
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('FlutterChat'),
          actions: [
            DropdownButton(
              underline: Container(),
              icon: Icon(
                Icons.more_vert,
                color: Theme.of(context).primaryIconTheme.color,
              ),
              items: [
                DropdownMenuItem(
                  value: 'logout',
                  child: Row(
                    children: const <Widget>[
                      Icon(Icons.exit_to_app),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Logout'),
                    ],
                  ),
                ),
              ],
              onChanged: (itemIdentifier) {
                if (itemIdentifier == 'logout') {}
              },
            ),
          ],
        ),
        body: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ChatModel()),
          ],
          child: Consumer<ChatModel>(builder: (_, model, child) {
            List<Widget> messages = model.getMessages;
            return Stack(
              children: <Widget>[
                Container(
                  color: Colors.black,
                  margin: const EdgeInsets.only(bottom: 80),
                  child: ListView(
                    children: [
                      for (int i = 0; i < messages.length; i++) messages[i]
                    ],
                  ),
                ),
                UserInput(
                  chatcontroller: chatcontroller,
                )
              ],
            );
          }),
        ),
      ),
    );
  }
}
