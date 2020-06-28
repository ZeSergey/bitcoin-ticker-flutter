import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  bool loading = false;
  Map<String, String> dataBank = {};

  @override
  void initState() {
    super.initState();
    getData();
  }

  DropdownButton<dynamic> androidDropDown() {
    List<DropdownMenuItem> dropDownlist = [];
    for (String currency in currenciesList) {
      var newValue = DropdownMenuItem(child: Text(currency), value: currency);
      dropDownlist.add(newValue);
    }

    return DropdownButton<dynamic>(
        value: selectedCurrency,
        items: dropDownlist,
        onChanged: (value) {
          setState(() {
            selectedCurrency = value;
          });
          getData();
        });
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
        backgroundColor: Colors.lightBlue,
        itemExtent: 32.0,
        onSelectedItemChanged: (selected) {
          setState(() {
            selectedCurrency = currenciesList[selected];
          });
          getData();
        },
        children: pickerItems);
  }

  void getData() async {
    loading = true;
    var data = await CoinData().getData(selectedCurrency);
    loading = false;
    setState(() {
      dataBank = data;
    });
  }

  List<Widget> getCurrentButton() {
    List<Widget> cryptoInfo = [];
    for (String value in cryptoList) {
      cryptoInfo.add(currentButton(
        cryptoCurrency: value,
        value: loading ? '?' : dataBank[value],
        selectedCurrency: selectedCurrency,
      ));
    }
    return cryptoInfo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: getCurrentButton()),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropDown(),
          ),
        ],
      ),
    );
  }
}

class currentButton extends StatelessWidget {
  const currentButton({
    this.cryptoCurrency,
    this.value,
    this.selectedCurrency,
  });

  final String cryptoCurrency;
  final String value;
  final String selectedCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
        child: Card(
          color: Colors.lightBlueAccent,
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
              child: Text('1 $cryptoCurrency = $value $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ))),
        ));
  }
}
