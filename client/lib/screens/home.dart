import 'package:client/contracts/contract.dart';
import 'package:client/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _sender = TextEditingController();
  TextEditingController _amount = TextEditingController();

  late String balance;
  late String account;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  void initializeData() async {
    BigInt blnc =
        await Provider.of<Contract>(context, listen: false).getBalance();
    String acc =
        Provider.of<Contract>(context, listen: false).accountAddress.toString();
    setState(() {
      balance = blnc.toString();
      account = acc;
    });
  }

  void transfer() async {
    try {
      if (_amount.text.isNotEmpty && _sender.text.isNotEmpty) {
        await Provider.of<Contract>(context, listen: false)
            .sendToken(_sender.text.toString(), BigInt.parse(_amount.text));
        initializeData();
        _sender.clear();
        _amount.clear();
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _sender.clear();
    _amount.clear();
  }

  @override
  Widget build(BuildContext context) {
    final contractProvider = Provider.of<Contract>(context);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Center(
            child: Text(
              "My Wallet",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
        body: contractProvider.isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(account,
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis)),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      'Balance',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${balance} DAI',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      'Send DAI',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _sender,
                      decoration: const InputDecoration(
                        labelText: "Enter Sender's Address",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: _amount,
                      decoration: const InputDecoration(
                        labelText: "Enter Amount",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    contractProvider.isLoading
                        ? CircularProgressIndicator()
                        : TextButton(
                            onPressed: transfer,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 50.0, vertical: 10),
                              child: Text(
                                'Send',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15),
                              ),
                            ),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.blueAccent)),
                          )
                  ],
                ),
              ));
  }
}
