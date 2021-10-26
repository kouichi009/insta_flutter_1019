import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class Test4 extends StatefulWidget {
  const Test4({Key? key}) : super(key: key);

  @override
  _Test4State createState() => _Test4State();
}

class _Test4State extends State<Test4> {
  bool isReadMore = false;

  String loremIpsum =
      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.';

  readMoreLess() {
    setState(() {
      isReadMore = !isReadMore;
    });
  }

  Widget buildText() {
    final maxLines = isReadMore ? null : 2;
    final overflow = isReadMore ? TextOverflow.visible : TextOverflow.ellipsis;

    return /* Padding(
      padding: EdgeInsets.all(10),
      child: */
        Row(
      children: <Widget>[
        Expanded(
            child: Text(
          loremIpsum,
          maxLines: maxLines,
          overflow: overflow,
          style: TextStyle(fontSize: 16),
        )),
        GestureDetector(
          onTap: () => readMoreLess(),
          child: Icon(
            isReadMore ? Icons.expand_less : Icons.expand_more,
            size: 35.0,
            // color: Colors.pink,
          ),
        ),
      ],
    );
    // );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text('MyApp'), centerTitle: true),
      body: Container(child: buildText())
      // ListView(
      //   children: [buildText(loremIpsum)],
      // )
      );
}
