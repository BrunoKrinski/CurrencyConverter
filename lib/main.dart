import 'package:flutter/material.dart';
import 'package:currency_converter/views/home_view.dart';

void main() async{
  runApp(CurrencyConverter());
}

class CurrencyConverter extends StatelessWidget {
  const CurrencyConverter({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      debugShowCheckedModeBanner: false,
      home: HomeView(),
    );
  }
}
