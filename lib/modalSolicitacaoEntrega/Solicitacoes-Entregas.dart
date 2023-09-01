import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pedefacil_entregadores_flutter/lista/MainLista.dart';
import 'package:uuid/uuid.dart';

//desenvolvido por HeroRickyGames

class SolcitacaoEntrega extends StatefulWidget {
  const SolcitacaoEntrega({Key? key}) : super(key: key);

  @override
  State<SolcitacaoEntrega> createState() => _SolcitacaoEntregaState();
}

class _SolcitacaoEntregaState extends State<SolcitacaoEntrega> {
  String nomeCliente = '';
  String numCliente = '';
  String LocalEntrega = '';
  String kmCalculado = '';
  String? tipos = 'Sim';
  String? preco = 'R\$ 0';

  String? LatiEntrega = '';
  String? LongEntrega = '';

  @override
  Widget build(BuildContext context) {
    calcularDistanciaMT() async {

      if(LocalEntrega == ''){
        Fluttertoast.showToast(
          msg: 'Preencha o campo Local de Entrega',
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }else{
        var UID = FirebaseAuth.instance.currentUser?.uid;

        var result = await FirebaseFirestore.instance
            .collection("Loja")
            .doc(UID)
            .get();


        List<Location> locations = await locationFromAddress(result.get('Localização'));
        Location location = locations.first;
        print("Latitude: ${location.latitude}, Longitude: ${location.longitude}");

        List<Location> locations2 = await locationFromAddress(LocalEntrega);
        Location location2 = locations2.first;
        print("Latitude: ${location2.latitude}, Longitude: ${location2.longitude}");

        LatiEntrega =  '${location2.latitude}';
        LongEntrega = '${location2.longitude}';

        // Calcular a distância entre os dois pontos usando a fórmula de Haversine
        final distanciaEmMetros = await Geolocator.distanceBetween(
            location.latitude, location.longitude, location2.latitude, location2.longitude);
        final distanciaEmQuilometros = distanciaEmMetros / 1000;

        String valorSimplificado = distanciaEmQuilometros.toStringAsFixed(2);

        print(valorSimplificado);

        var result2 = await FirebaseFirestore.instance
            .collection("Server")
            .doc('ServerValues')
            .get();
        print(DateTime.now().hour);

        double paraVerificarosKM = double.parse(valorSimplificado);
        if(paraVerificarosKM <= 3.00){

          if(DateTime.now().hour == 0){
            String PrecominimoDia = result2.get('precoMinimoNoite');

            print(PrecominimoDia);

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${PrecominimoDia}';
            });
          }

          if(DateTime.now().hour == 1){
            String PrecominimoDia = result2.get('precoMinimoNoite');

            print(PrecominimoDia);

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${PrecominimoDia}';
            });
          }
          if(DateTime.now().hour == 2){
            String PrecominimoDia = result2.get('precoMinimoNoite');

            print(PrecominimoDia);

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${PrecominimoDia}';
            });
          }
          if(DateTime.now().hour == 3){
            String PrecominimoDia = result2.get('precoMinimoNoite');

            print(PrecominimoDia);

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${PrecominimoDia}';
            });
          }
          if(DateTime.now().hour == 4){
            String PrecominimoDia = result2.get('precoMinimoNoite');

            print(PrecominimoDia);

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${PrecominimoDia}';
            });
          }
          if(DateTime.now().hour == 5){
            String PrecominimoDia = result2.get('precoMinimoNoite');

            print(PrecominimoDia);

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${PrecominimoDia}';
            });
          }
          if(DateTime.now().hour == 6){
            String PrecominimoDia = result2.get('precoMinimoDia');

            print(PrecominimoDia);

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${PrecominimoDia}';
            });
          }
          if(DateTime.now().hour == 7){
            String PrecominimoDia = result2.get('precoMinimoDia');

            print(PrecominimoDia);

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${PrecominimoDia}';
            });
          }
          if(DateTime.now().hour == 8){
            String PrecominimoDia = result2.get('precoMinimoDia');

            print(PrecominimoDia);

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${PrecominimoDia}';
            });
          }
          if(DateTime.now().hour == 9){
            String PrecominimoDia = result2.get('precoMinimoDia');

            print(PrecominimoDia);

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${PrecominimoDia}';
            });
          }
          if(DateTime.now().hour == 10){
            String PrecominimoDia = result2.get('precoMinimoDia');

            print(PrecominimoDia);

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${PrecominimoDia}';
            });
          }
          if(DateTime.now().hour == 11){
            String PrecominimoDia = result2.get('precoMinimoDia');

            print(PrecominimoDia);

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${PrecominimoDia}';
            });
          }
          if(DateTime.now().hour == 12){
            String PrecominimoDia = result2.get('precoMinimoDia');

            print(PrecominimoDia);

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${PrecominimoDia}';
            });
          }
          if(DateTime.now().hour == 13){
            String PrecominimoDia = result2.get('precoMinimoDia');

            print(PrecominimoDia);

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${PrecominimoDia}';
            });
          }
          if(DateTime.now().hour == 14){
            String PrecominimoDia = result2.get('precoMinimoDia');

            print(PrecominimoDia);

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${PrecominimoDia}';
            });
          }
          if(DateTime.now().hour == 15){
            String PrecominimoDia = result2.get('precoMinimoDia');

            print(PrecominimoDia);

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${PrecominimoDia}';
            });
          }
          if(DateTime.now().hour == 16){
            String PrecominimoDia = result2.get('precoMinimoDia');

            print(PrecominimoDia);

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${PrecominimoDia}';
            });
          }
          if(DateTime.now().hour == 17){
            String PrecominimoDia = result2.get('precoMinimoDia');

            print(PrecominimoDia);

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${PrecominimoDia}';
            });
          }
          if(DateTime.now().hour == 18){
            String PrecominimoDia = result2.get('precoMinimoDia');

            print(PrecominimoDia);

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${PrecominimoDia}';
            });
          }
          if(DateTime.now().hour == 19){
            String PrecominimoDia = result2.get('precoMinimoDia');

            print(PrecominimoDia);

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${PrecominimoDia}';
            });
          }
          if(DateTime.now().hour == 20){
            String PrecominimoDia = result2.get('precoMinimoDia');

            print(PrecominimoDia);

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${PrecominimoDia}';
            });
          }
          if(DateTime.now().hour == 21){
            String PrecominimoDia = result2.get('precoMinimoDia');

            print(PrecominimoDia);

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${PrecominimoDia}';
            });
          }
          if(DateTime.now().hour == 22){
            String PrecominimoDia = result2.get('precoMinimoDia');

            print(PrecominimoDia);

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${PrecominimoDia}';
            });
          }
          if(DateTime.now().hour == 23){
            String PrecominimoDia = result2.get('precoMinimoDia');

            print(PrecominimoDia);

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${PrecominimoDia}';
            });
          }
          if(DateTime.now().hour == 24){
            String PrecominimoDia = result2.get('precoMinimoNoite');

            print(PrecominimoDia);

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${PrecominimoDia}';
            });
          }
        }else if(paraVerificarosKM > 3.00){
          if(DateTime.now().hour == 0){
            String precoMinimoNoite = result2.get('valorPorKmNoite');

            double valorCalculo = double.parse(valorSimplificado);
            double precominimonoite = double.parse(precoMinimoNoite);
            double calculo = valorCalculo * precominimonoite;

            print(calculo);

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${calculo.toStringAsFixed(2)}';
            });

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${calculo.toStringAsFixed(2)}';
            });
          }
          if(DateTime.now().hour == 1){
            String precoMinimoNoite = result2.get('valorPorKmNoite');

            double valorCalculo = double.parse(valorSimplificado);
            double precominimonoite = double.parse(precoMinimoNoite);
            double calculo = valorCalculo * precominimonoite;

            print(calculo);

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${calculo.toStringAsFixed(2)}';
            });

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${calculo.toStringAsFixed(2)}';
            });
          }
          if(DateTime.now().hour == 2){
            String precoMinimoNoite = result2.get('valorPorKmNoite');

            double valorCalculo = double.parse(valorSimplificado);
            double precominimonoite = double.parse(precoMinimoNoite);
            double calculo = valorCalculo * precominimonoite;

            print(calculo);

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${calculo.toStringAsFixed(2)}';
            });

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${calculo.toStringAsFixed(2)}';
            });
          }
          if(DateTime.now().hour == 3){
            String precoMinimoNoite = result2.get('valorPorKmNoite');

            double valorCalculo = double.parse(valorSimplificado);
            double precominimonoite = double.parse(precoMinimoNoite);
            double calculo = valorCalculo * precominimonoite;

            print(calculo);

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${calculo.toStringAsFixed(2)}';
            });

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${calculo.toStringAsFixed(2)}';
            });
          }
          if(DateTime.now().hour == 4){
            String precoMinimoNoite = result2.get('valorPorKmNoite');

            double valorCalculo = double.parse(valorSimplificado);
            double precominimonoite = double.parse(precoMinimoNoite);
            double calculo = valorCalculo * precominimonoite;

            print(calculo);

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${calculo.toStringAsFixed(2)}';
            });

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${calculo.toStringAsFixed(2)}';
            });
          }
          if(DateTime.now().hour == 5){
            String precoMinimoNoite = result2.get('valorPorKmNoite');

            double valorCalculo = double.parse(valorSimplificado);
            double precominimonoite = double.parse(precoMinimoNoite);
            double calculo = valorCalculo * precominimonoite;

            print(calculo);

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${calculo.toStringAsFixed(2)}';
            });

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${calculo.toStringAsFixed(2)}';
            });
          }
          if(DateTime.now().hour == 6){
            String precoMinimoDia = result2.get('valorPorKmNoite');

            double valorCalculo = double.parse(valorSimplificado);
            double precominimodia = double.parse(precoMinimoDia);
            double calculo = valorCalculo * precominimodia;

            print(calculo);

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${calculo.toStringAsFixed(2)}';
            });

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${calculo.toStringAsFixed(2)}';
            });
          }
          if(DateTime.now().hour == 7){
            String precoMinimoDia = result2.get('valorPorKmNoite');

            double valorCalculo = double.parse(valorSimplificado);
            double precominimodia = double.parse(precoMinimoDia);
            double calculo = valorCalculo * precominimodia;

            print(calculo);

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${calculo.toStringAsFixed(2)}';
            });

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${calculo.toStringAsFixed(2)}';
            });
          }
          if(DateTime.now().hour == 8){
            String precoMinimoDia = result2.get('valorPorKmNoite');

            double valorCalculo = double.parse(valorSimplificado);
            double precominimodia = double.parse(precoMinimoDia);
            double calculo = valorCalculo * precominimodia;

            print(calculo);

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${calculo.toStringAsFixed(2)}';
            });

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${calculo.toStringAsFixed(2)}';
            });
          }
          if(DateTime.now().hour == 9){
            String precoMinimoDia = result2.get('valorPorKmNoite');

            double valorCalculo = double.parse(valorSimplificado);
            double precominimodia = double.parse(precoMinimoDia);
            double calculo = valorCalculo * precominimodia;

            print(calculo);

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${calculo.toStringAsFixed(2)}';
            });

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${calculo.toStringAsFixed(2)}';
            });
          }
          if(DateTime.now().hour == 10){
            String precoMinimoDia = result2.get('valorPorKmNoite');

            double valorCalculo = double.parse(valorSimplificado);
            double precominimodia = double.parse(precoMinimoDia);
            double calculo = valorCalculo * precominimodia;

            print(calculo);

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${calculo.toStringAsFixed(2)}';
            });

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${calculo.toStringAsFixed(2)}';
            });
          }
          if(DateTime.now().hour == 11){
            String precoMinimoDia = result2.get('valorPorKmNoite');

            double valorCalculo = double.parse(valorSimplificado);
            double precominimodia = double.parse(precoMinimoDia);
            double calculo = valorCalculo * precominimodia;

            print(calculo);

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${calculo.toStringAsFixed(2)}';
            });

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${calculo.toStringAsFixed(2)}';
            });
          }
          if(DateTime.now().hour == 12){
            String precoMinimoDia = result2.get('valorPorKmNoite');

            double valorCalculo = double.parse(valorSimplificado);
            double precominimodia = double.parse(precoMinimoDia);
            double calculo = valorCalculo * precominimodia;

            print(calculo);

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${calculo.toStringAsFixed(2)}';
            });

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${calculo.toStringAsFixed(2)}';
            });
          }
          if(DateTime.now().hour == 13){
            String precoMinimoDia = result2.get('valorPorKmNoite');

            double valorCalculo = double.parse(valorSimplificado);
            double precominimodia = double.parse(precoMinimoDia);
            double calculo = valorCalculo * precominimodia;

            print(calculo);

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${calculo.toStringAsFixed(2)}';
            });

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${calculo.toStringAsFixed(2)}';
            });
          }
          if(DateTime.now().hour == 14){
            String precoMinimoDia = result2.get('valorPorKmNoite');

            double valorCalculo = double.parse(valorSimplificado);
            double precominimodia = double.parse(precoMinimoDia);
            double calculo = valorCalculo * precominimodia;

            print(calculo);

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${calculo.toStringAsFixed(2)}';
            });

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${calculo.toStringAsFixed(2)}';
            });
          }
          if(DateTime.now().hour == 15){
            String precoMinimoDia = result2.get('valorPorKmNoite');

            double valorCalculo = double.parse(valorSimplificado);
            double precominimodia = double.parse(precoMinimoDia);
            double calculo = valorCalculo * precominimodia;

            print(calculo);

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${calculo.toStringAsFixed(2)}';
            });

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${calculo.toStringAsFixed(2)}';
            });
          }
          if(DateTime.now().hour == 16){
            String precoMinimoDia = result2.get('valorPorKmNoite');

            double valorCalculo = double.parse(valorSimplificado);
            double precominimodia = double.parse(precoMinimoDia);
            double calculo = valorCalculo * precominimodia;

            print(calculo);

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${calculo.toStringAsFixed(2)}';
            });

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${calculo.toStringAsFixed(2)}';
            });
          }
          if(DateTime.now().hour == 17){
            String precoMinimoDia = result2.get('valorPorKmNoite');

            double valorCalculo = double.parse(valorSimplificado);
            double precominimodia = double.parse(precoMinimoDia);
            double calculo = valorCalculo * precominimodia;

            print(calculo);

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${calculo.toStringAsFixed(2)}';
            });

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${calculo.toStringAsFixed(2)}';
            });
          }
          if(DateTime.now().hour == 18){
            String precoMinimoDia = result2.get('valorPorKmNoite');

            double valorCalculo = double.parse(valorSimplificado);
            double precominimodia = double.parse(precoMinimoDia);
            double calculo = valorCalculo * precominimodia;

            print(calculo);

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${calculo.toStringAsFixed(2)}';
            });

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${calculo.toStringAsFixed(2)}';
            });
          }
          if(DateTime.now().hour == 19){
            String precoMinimoDia = result2.get('valorPorKmNoite');

            double valorCalculo = double.parse(valorSimplificado);
            double precominimodia = double.parse(precoMinimoDia);
            double calculo = valorCalculo * precominimodia;

            print(calculo);

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${calculo.toStringAsFixed(2)}';
            });

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${calculo.toStringAsFixed(2)}';
            });
          }
          if(DateTime.now().hour == 20){
            String precoMinimoDia = result2.get('valorPorKmNoite');

            double valorCalculo = double.parse(valorSimplificado);
            double precominimodia = double.parse(precoMinimoDia);
            double calculo = valorCalculo * precominimodia;

            print(calculo);

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${calculo.toStringAsFixed(2)}';
            });

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${calculo.toStringAsFixed(2)}';
            });
          }
          if(DateTime.now().hour == 21){
            String precoMinimoDia = result2.get('valorPorKmNoite');

            double valorCalculo = double.parse(valorSimplificado);
            double precominimodia = double.parse(precoMinimoDia);
            double calculo = valorCalculo * precominimodia;

            print(calculo);

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${calculo.toStringAsFixed(2)}';
            });

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${calculo.toStringAsFixed(2)}';
            });
          }
          if(DateTime.now().hour == 22){
            String precoMinimoDia = result2.get('valorPorKmNoite');

            double valorCalculo = double.parse(valorSimplificado);
            double precominimodia = double.parse(precoMinimoDia);
            double calculo = valorCalculo * precominimodia;

            print(calculo);

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${calculo.toStringAsFixed(2)}';
            });

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${calculo.toStringAsFixed(2)}';
            });
          }
          if(DateTime.now().hour == 23){
            String precoMinimoDia = result2.get('valorPorKmNoite');

            double valorCalculo = double.parse(valorSimplificado);
            double precominimodia = double.parse(precoMinimoDia);
            double calculo = valorCalculo * precominimodia;

            print(calculo);

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${calculo.toStringAsFixed(2)}';
            });

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${calculo.toStringAsFixed(2)}';
            });
          }
          if(DateTime.now().hour == 24){
            String precoMinimoNoite = result2.get('valorPorKmNoite');

            double valorCalculo = double.parse(valorSimplificado);
            double precominimonoite = double.parse(precoMinimoNoite);
            double calculo = valorCalculo * precominimonoite;

            print(calculo);

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${calculo.toStringAsFixed(2)}';
            });

            setState(() {
              kmCalculado = valorSimplificado + ' KM';
              preco = 'R\$ ${calculo.toStringAsFixed(2)}';
            });
          }
        }
      }
    }
    todb(){
      if(nomeCliente == ''){
        Fluttertoast.showToast(
          msg: 'Preencha o campo Nome do Cliente',
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }else{
        if(numCliente == ''){
          Fluttertoast.showToast(
            msg: 'Preencha o campo Numero do Cliente',
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }else{
          calcularDistanciaMT();

          Fluttertoast.showToast(
            msg: 'Enviando dados para o servidor...\n Isso pode demorar um pouquinho!',
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 5,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0,
          );
          Future.delayed(Duration(seconds: 5), () async {
            var UID = FirebaseAuth.instance.currentUser?.uid;
            var result2 = await FirebaseFirestore.instance
                .collection("Loja")
                .doc(UID)
                .get();

            var uuid = Uuid();

            String idd = "${DateTime.now().toString()}" + uuid.v4();
            FirebaseFirestore.instance.collection('Solicitacoes-Entregas').doc(idd).set(
                {
                  'Data de publicação' : DateTime.now(),
                  'Distancia': kmCalculado,
                  'LatitudeDoEntregador': '',
                  'Local de Entrega': LocalEntrega ,
                  'LocalizacaoEntregador': '' ,
                  'Localização': result2.get('Localização') ,
                  'NomedoProduto': nomeCliente  ,
                  'PertenceA': result2.get('nameCompleteUser')  ,
                  'Preço': preco ,
                  'RazãodoEntregador': '',
                  'Telefone do Cliente': numCliente ,
                  'entreguePor': '' ,
                  'idLoja': result2.get('uid') ,
                  'latEntrega': double.parse(LatiEntrega!) ,
                  'longEntrega': double.parse(LongEntrega!) ,
                  'latitude': result2.get('Latitude') ,
                  'longitude': result2.get('Latitude') ,
                  'statusDoProduto': 'Ativo' ,
                  'id': idd ,
                  'idEntregador': '' ,
                  'pagardepois': false ,
                  'É retornavel': false ,
                }
            ).then((value) {

              Fluttertoast.showToast(
                msg: 'Pedido adicionado com sucesso!',
                toastLength: Toast.LENGTH_SHORT,
                timeInSecForIosWeb: 5,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0,
              );
              
              bool loja = true;
              String Nome =  (result2.get('nameCompleteUser'));
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context){
                    return MainLista(loja, Nome);
                  }));
            });

          });

        }
      }
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Adicionar Entrega',
          style: TextStyle(
              color: Colors.black
          ),
        ),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child:
            TextFormField(
              onChanged: (valor){
                nomeCliente = valor;
                //Mudou mandou para a String
              },
              keyboardType: TextInputType.name,
              //enableSuggestions: false,
              //autocorrect: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Nome do Cliente',
                hintStyle: TextStyle(
                    fontSize: 20
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child:
            TextFormField(
              onChanged: (valor){
                numCliente = valor;
                //Mudou mandou para a String
              },
              keyboardType: TextInputType.number,
              //enableSuggestions: false,
              //autocorrect: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Numero do Cliente',
                hintStyle: TextStyle(
                    fontSize: 20
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child:
            TextFormField(
              onChanged: (valor){
                LocalEntrega = valor;
                //Mudou mandou para a String
              },
              keyboardType: TextInputType.streetAddress,
              //enableSuggestions: false,
              //autocorrect: false,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Local de Entrega: (Rua, numero, Cidade, Estado, CEP)',
                hintStyle: TextStyle(
                    fontSize: 20
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child:
            ElevatedButton(
              onPressed: calcularDistanciaMT,
              child: Text(
                  'Calcular distancia e ou preço se o campo é retornavél estiver selecionado',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white
                ),
              ),
              style: ElevatedButton.styleFrom(
                  primary: Colors.orange
              ),
            )
          ),
          Container(
              padding: EdgeInsets.all(16),
              child:
              Text(
                'Distancia do estabelecimento até o local é: ' + kmCalculado,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white
                ),
              )
          ),
          Column(
            children: [
              Container(
                  padding: EdgeInsets.all(16),
                  child:
                  Text(
                    'É retornável?',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white
                    ),
                  )
              ),
              RadioListTile(
                title: Text(
                  "Não",
                  style: TextStyle(
                      fontSize: 20
                  ),
                ),
                value: "Nao",
                groupValue: tipos,
                onChanged: (value){
                  setState(() {
                    tipos = value.toString();
                  });
                },
              ),
              RadioListTile(
                title: Text(
                  "Sim",
                  style: TextStyle(
                      fontSize: 20
                  ),
                ),
                value: "Sim",
                groupValue: tipos,
                onChanged: (value){
                  setState(() {
                    tipos = value.toString();
                  });
                },
              ),
            ],
          ),
          Container(
              padding: EdgeInsets.all(16),
              child:
              ElevatedButton(
                onPressed: todb,
                child: Text(
                    'Enviar',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    primary: Colors.orange
                ),
              )
          ),
          Container(
              padding: EdgeInsets.all(16),
              child:
              Text(
                'Preço: ' + preco!,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white
                ),
              )
          ),
        ],
      ),
    );
  }
}
