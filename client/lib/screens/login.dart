import 'package:client/contracts/contract.dart';
import 'package:client/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _privateKey = TextEditingController();

  void connectWallet() async {
    try {
      if (_privateKey.text.isNotEmpty) {
        await Provider.of<Contract>(context, listen: false)
            .initializeContract(_privateKey.text);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _privateKey.clear();
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
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              TextField(
                controller: _privateKey,
                decoration: const InputDecoration(
                  labelText: 'Enter Private Key',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              contractProvider.isLoading
                  ? CircularProgressIndicator()
                  : TextButton(
                      onPressed: connectWallet,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 50.0, vertical: 10),
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blueAccent)),
                    )
            ],
          ),
        ));
  }
}
