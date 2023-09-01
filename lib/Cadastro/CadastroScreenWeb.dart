import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pedefacil_entregadores_flutter/lista/MainLista.dart';

//desenvolvido por HeroRickyGames

class CadastroScreenWeb extends StatefulWidget {
  const CadastroScreenWeb({Key? key}) : super(key: key);

  @override
  State<CadastroScreenWeb> createState() => _CadastroScreenWebState();
}

class _CadastroScreenWebState extends State<CadastroScreenWeb> {
  String Email = '';
  String Senha = '';
  String nomeCompleto = '';
  String idade = '';
  String cpf = '';
  String PubKey = '';
  String AssToken = '';
  
  String EnderecoLoja = '';

  String? tipos = 'entregador';
  String? cnpjCPF = 'Seu CPF';
  String? NomeOuRazao = 'Seu Nome completo';
  String? Atuacao = 'Sua Idade';
  @override
  Widget build(BuildContext context) {

    cadastrarmt() async {
      final FirebaseAuth _auth = FirebaseAuth.instance;

      if(tipos == 'entregador'){
        if(nomeCompleto == ''){
          Fluttertoast.showToast(
            msg: 'Preencha o Campo Nome',
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }else{
          if(idade == ''){
            Fluttertoast.showToast(
              msg: 'Preencha o Campo Idade',
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          }else{
            if(cpf == ''){
              Fluttertoast.showToast(
                msg: 'Preencha o Campo CPF ou CNPJ',
                toastLength: Toast.LENGTH_SHORT,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            }else{
              if(Email == ''){
                Fluttertoast.showToast(
                  msg: 'Preencha o Campo de Email',
                  toastLength: Toast.LENGTH_SHORT,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              }else{
                if(Senha == ''){
                  Fluttertoast.showToast(
                    msg: 'Preencha o Campo de Senha',
                    toastLength: Toast.LENGTH_SHORT,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                }else{
                  if(PubKey == ''){
                    Fluttertoast.showToast(
                      msg: 'Preencha o Campo de Chave Publica',
                      toastLength: Toast.LENGTH_SHORT,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  }else{
                    if(AssToken == ''){
                      Fluttertoast.showToast(
                        msg: 'Preencha o Campo de Access Token',
                        toastLength: Toast.LENGTH_SHORT,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }else{
                      if(PubKey.contains('APP_USR')){
                        if(AssToken.contains('APP_USR')){
                          try {
                            UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
                              email: Email,
                              password: Senha,
                            );
                            print('Usuário cadastrado com sucesso! UID: ${userCredential.user!.uid}');

                            String Latitude = '';
                            String longitude = '';
                            FirebaseFirestore.instance.collection('Entregador').doc(userCredential.user?.uid).set(
                                {
                                  'Email' : Email,
                                  'CPF': cpf,
                                  'Localização': EnderecoLoja,
                                  'Tipo de conta': tipos,
                                  'idadeUser': idade,
                                  'nameCompleteUser': nomeCompleto,
                                  'statusDaConta': 'Ativo',
                                  'uid': userCredential.user?.uid,
                                  'ChavePublica': PubKey,
                                  'Access Token': AssToken,
                                  'Localização': '',
                                  'Latitude': Latitude,
                                  'Longitude': longitude,
                                  'ContaCriada': DateTime.now(),
                                  'jaPagou': false
                                }
                            ).then((value) {

                              Fluttertoast.showToast(
                                msg: 'Cadastro realizado com sucesso!',
                                toastLength: Toast.LENGTH_SHORT,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                              bool loja = false;
                              String Nome =  nomeCompleto;
                              Navigator.pop(context);
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context){
                                    return MainLista(loja, Nome);
                                  }));
                            });

                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              Fluttertoast.showToast(
                                msg: 'Senha fraca. Tente novamente com uma senha mais forte.',
                                toastLength: Toast.LENGTH_SHORT,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                              print('Senha fraca. Tente novamente com uma senha mais forte.');
                            } else if (e.code == 'email-already-in-use') {
                              Fluttertoast.showToast(
                                msg: 'O e-mail já está em uso.',
                                toastLength: Toast.LENGTH_SHORT,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                              print('O e-mail já está em uso.');
                            } else {
                              Fluttertoast.showToast(
                                msg: 'Ocorreu um erro durante o cadastro do usuário: $e',
                                toastLength: Toast.LENGTH_SHORT,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                              print('Ocorreu um erro durante o cadastro do usuário: $e');
                            }
                          } catch (e) {
                            Fluttertoast.showToast(
                              msg: 'Ocorreu um erro durante o cadastro do usuário: $e',
                              toastLength: Toast.LENGTH_SHORT,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                            print('Ocorreu um erro durante o cadastro do usuário: $e');
                          }

                        }
                      }else{
                        Fluttertoast.showToast(
                          msg: 'Preencha os campos corretamente!',
                          toastLength: Toast.LENGTH_SHORT,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }

      if(tipos == 'loja'){

        if(nomeCompleto == ''){
          Fluttertoast.showToast(
            msg: 'Preencha o Campo Nome',
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }else{
          if(idade == ''){
            Fluttertoast.showToast(
              msg: 'Preencha o Campo Idade',
              toastLength: Toast.LENGTH_SHORT,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          }else{
            if(cnpjCPF == ''){
              Fluttertoast.showToast(
                msg: 'Preencha o Campo CPF ou CNPJ',
                toastLength: Toast.LENGTH_SHORT,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            }else{
              if(Email == ''){
                Fluttertoast.showToast(
                  msg: 'Preencha o Campo de Email',
                  toastLength: Toast.LENGTH_SHORT,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              }else{
                if(Senha == ''){
                  Fluttertoast.showToast(
                    msg: 'Preencha o Campo de Senha',
                    toastLength: Toast.LENGTH_SHORT,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                }else{
                  if(EnderecoLoja == ''){
                    Fluttertoast.showToast(
                      msg: 'Preencha o Campo de Endereço da Loja',
                      toastLength: Toast.LENGTH_SHORT,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  }else{

                    if(kIsWeb){


                      String lugar = EnderecoLoja;

                      // Sua chave de API do Google Maps
                      String apiKey = 'AIzaSyBYZ8y8XMESY-rrKXVXahIbNmOTnvsuIhM';

                      // Faz uma requisição HTTP à API Geocoding do Google Maps
                      var response = await http.get(
                          Uri.parse('https://maps.googleapis.com/maps/api/geocode/json?address=$lugar&key=$apiKey'));

                      // Converte a resposta em JSON
                      var jsonResponse = json.decode(response.body);

                      print(jsonResponse);
                      // Obtém a primeira localização retornada
                      var location = jsonResponse['results'][0]['geometry']['location'];

                      // Exibe a latitude e longitude
                      print('Latitude: ${location['lat']}, Longitude: ${location['lng']}');

                      try {
                        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
                          email: Email,
                          password: Senha,
                        );
                        print('Usuário cadastrado com sucesso! UID: ${userCredential.user!.uid}');

                        FirebaseFirestore.instance.collection('Loja').doc(userCredential.user?.uid).set(
                            {
                              'Email' : Email,
                              'CPF': cpf,
                              'Localização': EnderecoLoja,
                              'Latitude': location['lat'],
                              'Longitude': location['lng'],
                              'Tipo de conta': tipos,
                              'idadeUser': idade,
                              'nameCompleteUser': nomeCompleto,
                              'statusDaConta': 'Ativo',
                              'uid': userCredential.user?.uid,
                              'ContaCriada': DateTime.now(),
                              'jaPagou': false
                            }
                        ).then((value) {

                          Fluttertoast.showToast(
                            msg: 'Cadastro realizado com sucesso!',
                            toastLength: Toast.LENGTH_SHORT,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                          bool loja = true;
                          String Nome =  nomeCompleto;
                          Navigator.pop(context);
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context){
                                return MainLista(loja, Nome);
                              }));
                        });

                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          print('Senha fraca. Tente novamente com uma senha mais forte.');
                        } else if (e.code == 'email-already-in-use') {
                          print('O e-mail já está em uso.');
                        } else {
                          print('Ocorreu um erro durante o cadastro do usuário: $e');
                        }
                      } catch (e) {
                        print('Ocorreu um erro durante o cadastro do usuário: $e');
                      }
                    }
                  }
                }
              }
            }
          }
        }

      }

    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'FacilEntregas - Cadastro Web',
          style: TextStyle(
              color: Colors.black
          ),
        ),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                'Você é',
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white
                ),
              ),
            ),
            RadioListTile(
              title: Text(
                "Sou um Entregador",
                style: TextStyle(
                    fontSize: 20
                ),
              ),
              value: "entregador",
              groupValue: tipos,
              onChanged: (value){
                setState(() {
                  tipos = value.toString();
                  cnpjCPF = 'Seu CPF';
                  NomeOuRazao = 'Seu Nome completo';
                  Atuacao = 'Sua Idade';
                });
              },
            ),
            RadioListTile(
              title: Text(
                "Sou uma Loja/Estabelecimento",
                style: TextStyle(
                    fontSize: 20
                ),
              ),
              value: "loja",
              groupValue: tipos,
              onChanged: (value){
                setState(() {
                  tipos = value.toString();
                  cnpjCPF = 'CNPJ da Empresa';
                  NomeOuRazao = 'Nome do Estabelecimento';
                  Atuacao = 'Tempo de atuação (Em anos)';
                });
              },
            ),
            Container(
              padding: EdgeInsets.all(16),
              child:
              TextFormField(
                onChanged: (valor){
                  nomeCompleto = valor;
                  //Mudou mandou para a String
                },
                keyboardType: TextInputType.name,
                //enableSuggestions: false,
                //autocorrect: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: NomeOuRazao,
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
                  idade = valor;
                  //Mudou mandou para a String
                },
                keyboardType: TextInputType.number,
                //enableSuggestions: false,
                //autocorrect: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: Atuacao,
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
                  cpf = valor;
                  //Mudou mandou para a String
                },
                keyboardType: TextInputType.number,
                //enableSuggestions: false,
                //autocorrect: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: cnpjCPF,
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
                  Email = valor;
                  //Mudou mandou para a String
                },
                keyboardType: TextInputType.emailAddress,
                //enableSuggestions: false,
                //autocorrect: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Seu Email',
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
                  Senha = valor;
                  //Mudou mandou para a String
                },
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                //enableSuggestions: false,
                //autocorrect: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Sua Senha',
                  hintStyle: TextStyle(
                      fontSize: 20
                  ),
                ),
              ),
            ),
            tipos == 'entregador'?
            Container(
                padding: EdgeInsets.all(16),
                child:
                Text(
                  'Para o uso correto do app, é preciso criar uma conta no Mercado Pago',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white
                  ),
                )
            ): Text(''),
            tipos == 'entregador'?
            Container(
                padding: EdgeInsets.all(16),
                child:
                TextButton(
                  onPressed: (){
                    //todo e to go para a documentação
                  },
                  child: Text(
                    'Clique aqui e saiba mais',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white
                    ),
                  ),
                )
            ): Text(''),
            tipos == 'entregador'?
            Container(
              padding: EdgeInsets.all(16),
              child:
              TextFormField(
                onChanged: (valor){
                  PubKey = valor;
                  //Mudou mandou para a String
                },
                keyboardType: TextInputType.text,
                //enableSuggestions: false,
                //autocorrect: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Public Key',
                  hintStyle: TextStyle(
                      fontSize: 20
                  ),
                ),
              ),
            ):Text(''),
            tipos == 'entregador'?
            Container(
              padding: EdgeInsets.all(16),
              child:
              TextFormField(
                onChanged: (valor){
                  AssToken = valor;
                  //Mudou mandou para a String
                },
                keyboardType: TextInputType.text,
                //enableSuggestions: false,
                //autocorrect: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Access Token',
                  hintStyle: TextStyle(
                      fontSize: 20
                  ),
                ),
              ),
            ): Container(
              padding: EdgeInsets.all(16),
              child: TextFormField(
                onChanged: (valor){
                  EnderecoLoja = valor;
                  //Mudou mandou para a String
                },
                keyboardType: TextInputType.streetAddress,
                //enableSuggestions: false,
                //autocorrect: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Endereço da Loja',
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
                  onPressed: cadastrarmt,
                  child: Text(
                    'Cadastrar',
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
          ],
        ),
      ),
    );
  }
}
