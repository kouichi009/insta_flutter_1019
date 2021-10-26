import 'package:flutter/material.dart';

class Test5 extends StatefulWidget {
  const Test5({Key? key}) : super(key: key);

  @override
  _Test5State createState() => _Test5State();
}

class _Test5State extends State<Test5> {
  bool isReadMore = false;

  String loremIpsum =
      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.';

  Widget buildButton() => ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          textStyle: TextStyle(fontSize: 20),
        ),
        child: Text(isReadMore ? 'Read Less' : 'Read More'),
        onPressed: () => setState(() => isReadMore = !isReadMore),
      );

  Widget buildText(String text) {
    final maxLines = isReadMore ? null : 2;
    final overflow = isReadMore ? TextOverflow.visible : TextOverflow.ellipsis;

    return Text(
      text,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(fontSize: 28),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text('MyApp'), centerTitle: true),
      body: ListView(
        padding: EdgeInsets.all(24),
        children: [
          Text(
            'Awesome Article',
            style: TextStyle(fontSize: 28),
          ),
          const SizedBox(height: 16),
          buildText(loremIpsum),
          const SizedBox(height: 16),
          Container(alignment: Alignment.centerLeft, child: buildButton())
        ],
      ));
}
