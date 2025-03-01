import 'dart:convert';
import 'package:client/constants/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

class Contract with ChangeNotifier {
  String rpcUrl = 'http://127.0.0.1:8545';
  bool isLoading = false;
  late Web3Client web3client;
  late String abi;
  late EthereumAddress ethereumAddress;
  late Credentials credentials;
  late DeployedContract deployedContract;
  late ContractFunction getBalanceFunction;
  late ContractFunction sendTokenFunction;
  late ContractFunction getHistoryFunction;
  String? accountAddress;

  Contract() {
    web3client = Web3Client(rpcUrl, Client());
  }

  Future initializeContract(String privateKey) async {
    isLoading = true;
    notifyListeners();

    try {
      await getAbi();
      await getCredentials(privateKey);
      await getDeployedContract();

      final address = await credentials.extractAddress();
      accountAddress = address.hexEip55;
    } catch (e) {
      print("Error initializing contract: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future getAbi() async {
    String abiFile = await rootBundle.loadString('assets/DaiToken.json');
    final jsonAbi = jsonDecode(abiFile);
    abi = jsonEncode(jsonAbi['abi']);
    ethereumAddress = EthereumAddress.fromHex(contractAddress);
  }

  Future getCredentials(String privateKey) async {
    credentials = EthPrivateKey.fromHex(privateKey);
  }

  Future getDeployedContract() async {
    deployedContract = DeployedContract(
        ContractAbi.fromJson(abi, 'DaiToken'), ethereumAddress);

    getBalanceFunction = deployedContract.function('balanceOf');
    sendTokenFunction = deployedContract.function('transfer');
  }

  Future<void> sendToken(String reciever, BigInt amount) async {
    isLoading = true;
    notifyListeners();

    try {
      await web3client.sendTransaction(
          credentials,
          Transaction.callContract(
              contract: deployedContract,
              function: sendTokenFunction,
              parameters: [EthereumAddress.fromHex(reciever), amount]),
          chainId: null,
          fetchChainIdFromNetworkId: true);
    } catch (e) {
      print("Error adding task: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<BigInt> getBalance() async {
    isLoading = true;
    notifyListeners();

    BigInt balance = BigInt.zero;

    try {
      if (accountAddress != null) {
        final EthereumAddress address =
            EthereumAddress.fromHex(accountAddress!);
        final result = await web3client.call(
          contract: deployedContract,
          function: getBalanceFunction,
          params: [address],
        );

        if (result.isNotEmpty) {
          balance = result[0];
        }
      }
    } catch (e) {
      print("Error getting balance: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }

    return balance;
  }
}
