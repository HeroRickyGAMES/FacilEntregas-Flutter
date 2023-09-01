import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pedefacil_entregadores_flutter/Cadastro/CadastroScreen.dart';
import 'package:pedefacil_entregadores_flutter/Cadastro/CadastroScreenWeb.dart';
import 'package:pedefacil_entregadores_flutter/lista/MainLista.dart';
import 'package:url_launcher/url_launcher.dart';

//desenvolvido por HeroRickyGames

class LoginScreen extends StatelessWidget {

  LoginScreen();

  @override
  Widget build(BuildContext context) {

    String Email = '';
    String Senha = '';


    Future<Position> _determinePosition() async {
      bool serviceEnabled;
      LocationPermission permission;

      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      // When we reach here, permissions are granted and we can
      // continue accessing the position of the device.
      return await Geolocator.getCurrentPosition();
    }
    _determinePosition();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'FacilEntregas - Login',
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
            padding: const EdgeInsets.all(16),
            child: 
            Image.asset(
                'assets/ic_launcher.png',
            width: 300,
            height: 300,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child:
            TextFormField(
              onChanged: (valor){
                Email = valor;
                //Mudou mandou para a String
              },
              keyboardType: TextInputType.emailAddress,
              //enableSuggestions: false,
              //autocorrect: false,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Seu Email',
                hintStyle: TextStyle(
                    fontSize: 20
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child:
            TextFormField(
              onChanged: (valor){
                Senha = valor;
                //Mudou mandou para a String
              },
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              //enableSuggestions: false,
              //autocorrect: false,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Sua Senha',
                hintStyle: TextStyle(
                    fontSize: 20
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () async {
                final FirebaseAuth _auth = FirebaseAuth.instance;

                try {
                  UserCredential userCredential = await _auth.signInWithEmailAndPassword(
                    email: Email,
                    password: Senha,
                  );
                  print('Usuário autenticado com sucesso! UID: ${userCredential.user!.uid}');



                  var db = FirebaseFirestore.instance;
                  var UID = FirebaseAuth.instance.currentUser?.uid;

                  var result = await FirebaseFirestore.instance
                      .collection("Entregador")
                      .doc(UID)
                      .get();

                  var result2 = await FirebaseFirestore.instance
                      .collection("Loja")
                      .doc(UID)
                      .get();

//Checar a conta!
                  if(result.exists){
                    String StatusConta = (result.get('statusDaConta'));
                    bool Loja = false;
                    String Nome =  (result.get('nameCompleteUser'));
                    if(StatusConta == 'Ativo'){

                      Navigator.pop(context);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context){
                            return MainLista(Loja, Nome);
                          }));

                    }else if(StatusConta == 'Banido'){
                      Fluttertoast.showToast(
                        msg: 'Essa Conta foi banida!',
                        toastLength: Toast.LENGTH_SHORT,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text(
                              'Essa conta foi banida!',
                              style: TextStyle(
                                  fontSize: 19
                              ),
                            ),
                            content: const Text(
                              'Essa conta foi banida por desrespeitar algumas regras do app!',
                              style: TextStyle(
                                  fontSize: 19
                              ),
                            ),
                            actions: [
                              TextButton(onPressed: (){
                                Navigator.pop(context);
                                SystemNavigator.pop();
                              }, child: const Text(
                                'Ok',
                                style: TextStyle(
                                    fontSize: 19
                                ),
                              )
                              )
                            ],
                          );
                        },
                      );
                    }
                  }else{

                    if(result2.exists){

                      print('isso existe?');
                      String StatusConta = (result2.get('statusDaConta'));
                      bool Loja = true;
                      String Nome =  (result2.get('nameCompleteUser'));

                      if(StatusConta == 'Ativo'){
                        Navigator.pop(context);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context){
                              return MainLista(Loja, Nome);
                            }));
                      }else if(StatusConta == 'Banido'){
                        Fluttertoast.showToast(
                          msg: 'Essa Conta foi banida!',
                          toastLength: Toast.LENGTH_SHORT,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text(
                                'Essa conta foi banida!',
                                style: TextStyle(
                                    fontSize: 19
                                ),
                              ),
                              content: const Text(
                                'Essa conta foi banida por desrespeitar algumas regras do app!',
                                style: TextStyle(
                                    fontSize: 19
                                ),
                              ),
                              actions: [
                                TextButton(onPressed: (){
                                  SystemNavigator.pop();
                                }, child: const Text(
                                  'Ok',
                                  style: TextStyle(
                                      fontSize: 19
                                  ),
                                )
                                )
                              ],
                            );
                          },
                        );
                      }
                    }
                  }
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    Fluttertoast.showToast(
                      msg: 'Nenhum usuário encontrado com este e-mail.',
                      toastLength: Toast.LENGTH_SHORT,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );

                  } else if (e.code == 'wrong-password') {
                    Fluttertoast.showToast(
                      msg: 'Senha incorreta.',
                      toastLength: Toast.LENGTH_SHORT,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                    print('Senha incorreta.');
                  } else {
                    Fluttertoast.showToast(
                      msg: 'Ocorreu um erro durante a autenticação do usuário: $e',
                      toastLength: Toast.LENGTH_SHORT,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                    print('Ocorreu um erro durante a autenticação do usuário: $e');
                  }
                } catch (e) {
                  Fluttertoast.showToast(
                    msg: 'Ocorreu um erro durante a autenticação do usuário: $e',
                    toastLength: Toast.LENGTH_SHORT,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                  print('Ocorreu um erro durante a autenticação do usuário: $e');
                }
              },
              child: const Text(
                  'Entrar',
                style: TextStyle(
                    fontSize: 20,
                  color: Colors.white
                ),
              ),
              style: ElevatedButton.styleFrom(
                  primary: Colors.orange
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                    'Ainda não tem uma conta?',
                  style: TextStyle(
                    fontSize: 18
                  ),
                ),
                TextButton(
                  onPressed: (){
                    if(kIsWeb){
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context){
                            return const CadastroScreenWeb();
                          }));
                    }else{
                      if(Platform.isAndroid){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context){
                              return const CadastroScreen();
                            }));
                      }
                    }
                  },
                  child: const Text(
                      'Crie uma agora!',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            kIsWeb ? IconButton(onPressed: (){
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Baixe a versão Mobile do app!'),
                    content: const Text('Tendo uma versão Mobile Android terá carregamentos mais rapidos e mais funções desbloqueadas!\n Está esperando o que? Baixe já!'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancelar'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('Ok'),
                        onPressed: () async {
                          Navigator.of(context).pop();
                          const url = 'https://github.com/HeroRickyGAMES/Projeto-Pede-Facil-Entregadores/releases';

                          if (await canLaunch(url)) {

                            await launch(url);

                          } else {

                            throw'Não foi possível abrir a URL: $url';

                          }
                        },
                      ),
                    ],
                  );
                },
              );
            }, icon: const Row(
              children: [
                Icon(Icons.download),
                Text('Baixe a versão Android do aplicativo!')
              ],
            )): const Text('')
          ],
        ),
      ),
    );
  }
}
