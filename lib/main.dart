import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart';
void main() {
  runApp(MaterialApp(
    title:'Money Converter',
    home: MyHomePage(),
  )
  );
}


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var formcontroller= TextEditingController();
  List<String> currencies;
  String fromcurrency='USD';
  String tocurrency='GBP';
  String result;
  @override
  void initState(){
    super.initState();
    _loadcurrency();
    _convertcurrency();
  }
  Future<String>_loadcurrency() async{
    print("running");
    String uri="https://api.exchangeratesapi.io/latest";
    Response response=await get(uri,headers:{"Accept":"application/json"});
    var responseBody=jsonDecode(response.body);
    //the body rates looks like USD:1.0784,so we need to get the country code
    Map curmap=responseBody['rates'];
    //to get all the countries
    setState(() {
      currencies=curmap.keys.toList();
    });

    print(responseBody);
    print("running");
  }
  Future<String>_convertcurrency() async{
    print("running");
    String uri="https://api.openrates.io/latest?base=$fromcurrency&synbols=$tocurrency";
    Response response=await get(uri,headers:{"Accept":"application/json"});
    var responseBody=jsonDecode(response.body);
    //the body rates looks like USD:1.0784,so we need to get the country code

    //to get all the countries
    setState(() {
      if(formcontroller.text!="") {
        result = (double.parse(formcontroller.text) *
            responseBody['rates'][tocurrency]).toString();
      }else{result = (
          responseBody['rates'][tocurrency]).toString();}
    });

    print(responseBody);
    print("running");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("Currency Converter")),),
      body: currencies ==null?Center(child: CircularProgressIndicator()):Container(
        height: MediaQuery.of(context).size.height/2,
        width: MediaQuery.of(context).size.width,
        child: Card(
          elevation: 10.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ListTile(
                    title: TextField(
                    controller: formcontroller,
                    style: TextStyle(fontSize: 22.0),

                    keyboardType: TextInputType.numberWithOptions(decimal: true),

                  ),
                  trailing: _builddropdown(fromcurrency),
                ),
                IconButton(icon: Icon(Icons.arrow_downward), onPressed:_convertcurrency),
                ListTile(
                  title: Chip(label: Text(result,style:Theme.of(context).textTheme.headline4 ,)),
                  trailing: _builddropdown(tocurrency),
                ),
              ],
            ),
          )


        ),
      ),
    );
  }
  Widget _builddropdown(String currencycategory){
    return DropdownButton(
      value: currencycategory,
        items: currencies.map((String e) => DropdownMenuItem(
          value: e,
            child: Row(
          children: [Text(e)],
        ))).toList(),
        onChanged: (String value){
          if(currencycategory==fromcurrency){
            setState(() {
              fromcurrency=value;
              _convertcurrency();
            });
          }
          else{setState(() {
            tocurrency=value;
            _convertcurrency();
          });}
        });
  }
}

