import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';

class Test2 extends StatefulWidget {
  const Test2({Key? key}) : super(key: key);

  @override
  _Test2State createState() => _Test2State();
}

class _Test2State extends State<Test2> {
  int _radioSelected = 1;
  String _radioVal = '';
  dateWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            child: Text("open picker dialog"),
            onPressed: () async {
              var datePicked = await DatePicker.showSimpleDatePicker(
                context,
                initialDate: DateTime(1994),
                firstDate: DateTime(1960),
                lastDate: DateTime(2020),
                dateFormat: "dd-MMMM-yyyy",
                locale: DateTimePickerLocale.jp,
                looping: true,
              );

              final snackBar = SnackBar(
                  content:
                      Text("Date Picked $datePicked ${datePicked!.month}"));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          ),
          ElevatedButton(
            child: Text("Show picker widget"),
            onPressed: () {},
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Male'),
              Radio(
                value: 1,
                groupValue: _radioSelected,
                activeColor: Colors.blue,
                onChanged: (value) {
                  setState(() {
                    _radioSelected = 1;
                    _radioVal = 'male';
                  });
                },
              ),
              Text('Female'),
              Radio(
                value: 2,
                groupValue: _radioSelected,
                activeColor: Colors.pink,
                onChanged: (value) {
                  setState(() {
                    _radioSelected = 2;
                    _radioVal = 'female';
                  });
                },
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Holo Datepicker Example'),
        ),
        body: dateWidget());
  }
}
