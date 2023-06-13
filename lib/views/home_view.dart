import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

Future<Map> getData() async {
  // const request = "http://api.hgbrasil.com/finance?format=json&key=e6dd5371";
  const request = "https://api.hgbrasil.com/finance?format=json-cors&key=e6dd5371";

  http.Response response = await http.get(Uri.parse(request));
  return json.decode(response.body);
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  Future<Map>? data;

  @override
  void initState() {
    super.initState();
    data = getData();
  }

  double? dolar;
  double? euro;

  final TextEditingController realController = TextEditingController();
  final TextEditingController dolarController = TextEditingController();
  final TextEditingController euroController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String changed = "";

  void convert(String label) {

    if (label == 'BRL') {
      dolarController.text = "";
      euroController.text = "";

      double v = double.parse(realController.text);
      dolarController.text = (v / dolar!).toStringAsFixed(2);
      euroController.text = (v / euro!).toStringAsFixed(2);
    } else if (label == 'USD') {
      realController.text = "";
      euroController.text = "";

      double v = double.parse(dolarController.text);
      realController.text = (v * dolar!).toStringAsFixed(2);
      euroController.text = (v * dolar! / euro!).toStringAsFixed(2);
    } else {
      realController.text = "";
      dolarController.text = "";

      double v = double.parse(euroController.text);
      realController.text = (v * euro!).toStringAsFixed(2);
      dolarController.text = (v * dolar! / euro!).toStringAsFixed(2);
    }
  }

  Center showMessage(String message) {
    return Center(
      child: Text(
        'Loading data...',
        style: TextStyle(
          fontSize: 25,
          color: Colors.amber,
        ),
      ),
    );
  }

  Container textField(
      String label, String prefix, TextEditingController controller) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: TextFormField(
        inputFormatters: [
          FilteringTextInputFormatter.allow(
            RegExp('[0-9.]'),
          ),
        ],
        controller: controller,
        cursorColor: Colors.amber,
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.amber,
            fontSize: 20,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.amber,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.amber,
            ),
          ),
          prefix: Text(
            prefix,
          ),
          prefixStyle: TextStyle(
            color: Colors.amber,
            fontSize: 20,
          ),
        ),
        validator: (value) {
          if (value!.isNotEmpty && double.tryParse(value!) == null) {
            return 'Please insert valid number!';
          }
        },
        onChanged: (value) {
          if (formKey.currentState!.validate()) {
            convert(label);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text(
          '\$ CURRENCY CONVERTER \$',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
        future: data,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return showMessage('Loading data...');
            default:
              if (snapshot.hasError) {
                return showMessage('Error on loading data!');
              } else {
                dolar = snapshot.data!['results']['currencies']['USD']['buy'];
                euro = snapshot.data!['results']['currencies']['EUR']['buy'];

                //print(dolar);
                //print(euro);
                return SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Container(
                      padding: EdgeInsets.all(25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Icon(
                            Icons.monetization_on,
                            size: 150,
                            color: Colors.amber,
                          ),
                          textField('BRL', 'R\$ ', realController),
                          textField('USD', '\$ ', dolarController),
                          textField('EUR', '€ ', euroController),
                        ],
                      ),
                    ),
                  ),
                );
              }
          }
        },
      ),
    );
  }
}
