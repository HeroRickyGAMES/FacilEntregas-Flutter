import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mercado_pago_mobile_checkout/mercado_pago_mobile_checkout.dart';
import 'package:pedefacil_entregadores_flutter/lista/MainLista.dart';

//desenvolvido por HeroRickyGames

apiteste(){

}

class paymentSheet extends StatefulWidget {
  String idCompra;
  String id;
  String PubKey;
  bool pagardepois;
  paymentSheet(this.idCompra,this.PubKey, this.id, this.pagardepois);

  @override
  State<paymentSheet> createState() => _paymentSheetState();
}

class _paymentSheetState extends State<paymentSheet> {
  @override
  Widget build(BuildContext context) {
    String publicKey = widget.PubKey;
    String preferenceId = widget.idCompra;
    String _platformVersion = 'Unknown';

    // Platform messages are asynchronous, so we initialize in an async method.
    Future<void> initPlatformState() async {
      String platformVersion;
      // Platform messages may fail, so we use a try/catch PlatformException.
      try {
        platformVersion = (await MercadoPagoMobileCheckout.platformVersion)!;
      } on PlatformException {
        platformVersion = 'Failed to get platform version.';
      }

      // If the widget was removed from the tree while the asynchronous platform
      // message was in flight, we want to discard the reply rather than calling
      // setState to update our non-existent appearance.
      if (!mounted) return;

      setState(() {
        _platformVersion = platformVersion;
      });
    }

    iniciarapi() async {
      if(widget.pagardepois == false){

        PaymentResult result =
        await MercadoPagoMobileCheckout.startCheckout(
          publicKey,
          preferenceId,
        );
        print('resultado é ${result.result}');

        if(result.result == 'done'){
          //todo algo

          Fluttertoast.showToast(
            msg: 'Pagamento realizado com sucesso!',
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          print(widget.id);

          FirebaseFirestore.instance.collection('Solicitacoes-Entregas').doc(widget.id).update(
              {
                'statusDoProduto': 'Pronto para a entrega'
              }
          ).then((value) async {

            Fluttertoast.showToast(
              msg: 'Pagamento feito com sucesso!',
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0,
            );
            bool loja = true;

            var UID = FirebaseAuth.instance.currentUser?.uid;
            var result2 = await FirebaseFirestore.instance
                .collection("Loja")
                .doc(UID)
                .get();

            String Nome =  (result2.get('nameCompleteUser'));

            FirebaseFirestore.instance.collection('PaymentsCompletes').doc(widget.id).set(
                {
                  "quemPagou": Nome,
                  'UIDCompra': preferenceId
                }
            );

            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context){
                  return MainLista(loja, Nome);
                }));

          });
        }else{



          Fluttertoast.showToast(
            msg: 'Ocorreu algum erro no pagamento e ele foi cancelado, tente trocar de cartão ou tentar novamente.',
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          Navigator.pop(context);
        }

      }else if(widget.pagardepois == true){
        //todo trabalhar com isso depois
      }
    }

    iniciarapi();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('FacilEntregas - Pagamento'),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      )
    );
  }
}