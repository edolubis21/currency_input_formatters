# currency_input_formatters

Currency Text Field Input Formatter for Flutter.

<p align="center">
  
![example](https://user-images.githubusercontent.com/59104566/95548683-d0567600-0a2f-11eb-95ff-f1115e5a5dc6.png)

</p>


## Usage

Import the library

```dart
import 'package:currency_input_formatters/currency_input_formatters.dart';
```

declare the InputFormatter
```dart
  final currencyFormatter = CurrencyFormatter();
```

### Decimal

you can customize decimal

```dart
 final currencyFormatter1 = CurrencyFormatter(decimal: 3);
```

### Get current number value and current text value


To get the number value and text value, use the `currentNumber` and `currentText` property:

```dart
final num value = currencyFormatter.currentNumber;
final String text = currencyFormatter.currentText
```


### Full Example

```dart
import 'package:currency_input_formatters/currency_input_formatters.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final currencyFormatter = CurrencyFormatter();
  final currencyFormatter1 = CurrencyFormatter(decimal: 3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Format Example'),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  inputFormatters: [currencyFormatter],
                  onChanged: (_) {
                    print(currencyFormatter.currentNumber);
                  },
                  decoration: new InputDecoration(
                      border: new OutlineInputBorder(borderSide: new BorderSide(color: Colors.blue)),
                      prefixText: ' ',
                      hintText: "example",
                      suffixText: 'RP',
                      suffixStyle: const TextStyle(color: Colors.grey)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  inputFormatters: [currencyFormatter1],
                  onChanged: (_) {
                    print(currencyFormatter1.currentText);
                  },
                  decoration: new InputDecoration(
                      border: new OutlineInputBorder(borderSide: new BorderSide(color: Colors.blue)),
                      prefixText: ' ',
                      hintText: "example",
                      suffixText: 'RP',
                      suffixStyle: const TextStyle(color: Colors.grey)),
                ),
              )
            ],
          )),
    );
  }
}

```

