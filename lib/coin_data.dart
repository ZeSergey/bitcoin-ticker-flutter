import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  final String urlApi =
      'https://apiv2.bitcoinaverage.com/indices/global/ticker/';
  final String publicKey = 'NTI2ODY3ODdiMjUzNDVjN2E5MGRlNDA3ZDFmNGFhNTc';

  Map<String, String> cryptoValues = {};
  Future getData(String currency) async {
    for (String cryptocurrency in cryptoList) {
      http.Response response = await http.get(
          urlApi + cryptocurrency + currency,
          headers: {'x-ba-key': publicKey});
      if (response.statusCode == 200) {
        dynamic data = response.body;
        data = jsonDecode(data);
        cryptoValues[cryptocurrency] = data['last'].toString();
      } else {
        print(response.statusCode);
      }
    }
    return cryptoValues;
  }
}
