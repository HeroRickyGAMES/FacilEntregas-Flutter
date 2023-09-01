import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

//desenvolvido por HeroRickyGames

class configModal extends StatefulWidget {
  bool loja;
  String NameDB;
  String cpfDB;
  String PubKeyDB;
  String AssKeyDB;
  configModal(this.loja, this.NameDB, this.cpfDB, this.PubKeyDB, this.AssKeyDB);

  @override
  State<configModal> createState() => _configModalState();
}

class _configModalState extends State<configModal> {

  String name = '';
  String CPF = '';
  String ChavePublica = '';
  String AssKey = '';

  String HolderName = 'Seu Nome';
  String HolderCPF = 'CPF';

  @override
  Widget build(BuildContext context) {

    name = widget.NameDB;
    CPF = widget.cpfDB;

    TextEditingController nameController = TextEditingController(text: widget.NameDB);
    TextEditingController cpfController = TextEditingController(text: widget.cpfDB);
    TextEditingController PubKeyController = TextEditingController(text: widget.PubKeyDB);
    TextEditingController AssKeyController = TextEditingController(text: widget.AssKeyDB);

    verificaroquee() async {
      if(widget.loja == true){
        HolderName = 'Nome da Empresa';
        HolderCPF = 'CNPJ da Empresa';

      }
      if(widget.loja == false){
        ChavePublica = widget.PubKeyDB;
        AssKey = widget.AssKeyDB;
      }
    }
    verificaroquee();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
            'Configurações',
          style: TextStyle(
            color: Colors.black
          ),
        ),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child:
            TextFormField(
              controller: nameController,
              onChanged: (valor){
                name = valor;
                //Mudou mandou para a String
              },
              keyboardType: TextInputType.name,
              obscureText: false,
              //enableSuggestions: false,
              //autocorrect: false,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: HolderName,
                hintStyle: const TextStyle(
                    fontSize: 20
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child:
            TextFormField(
              controller: cpfController,
              onChanged: (valor){
                CPF = valor;
                //Mudou mandou para a String
              },
              keyboardType: TextInputType.number,
              obscureText: false,
              //enableSuggestions: false,
              //autocorrect: false,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: HolderCPF,
                hintStyle: const TextStyle(
                    fontSize: 20
                ),
              ),
            ),
          ),
          widget.loja == false ?
          Container(
            padding: const EdgeInsets.all(16),
            child:
            TextFormField(
              controller: PubKeyController,
              onChanged: (valor){
                ChavePublica = valor;
                //Mudou mandou para a String
              },
              keyboardType: TextInputType.number,
              obscureText: false,
              //enableSuggestions: false,
              //autocorrect: false,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Sua Chave Publica do Mercado Pago',
                hintStyle: TextStyle(
                    fontSize: 20
                ),
              ),
            ),
          ): const Text(''),
          widget.loja == false ?
          Container(
            padding: const EdgeInsets.all(16),
            child:
            TextFormField(
              controller: AssKeyController,
              onChanged: (valor){
                AssKey = valor;
                //Mudou mandou para a String
              },
              keyboardType: TextInputType.number,
              obscureText: false,
              //enableSuggestions: false,
              //autocorrect: false,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Seu Access Token do Mercado Pago',
                hintStyle: TextStyle(
                    fontSize: 20
                ),
              ),
            ),
          ): const Text(''),
          Container(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: (){
                if(widget.loja == true){
                  if(name == ''){
                    Fluttertoast.showToast(
                      msg: 'Preencha o campo nome',
                      toastLength: Toast.LENGTH_SHORT,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  }else{
                    if(CPF  == ''){
                      Fluttertoast.showToast(
                        msg: 'Preencha o campo de CNPJ',
                        toastLength: Toast.LENGTH_SHORT,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }else{
                      var UID = FirebaseAuth.instance.currentUser?.uid;
                      FirebaseFirestore.instance.collection('Loja').doc(UID).update({
                        'nameCompleteUser': name,
                        'CPF': CPF
                      });
                    }
                  }
                }
                if(widget.loja == false){
                  if(name == ''){
                    Fluttertoast.showToast(
                      msg: 'Preencha o campo nome',
                      toastLength: Toast.LENGTH_SHORT,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  }else{
                    if(CPF  == ''){
                      Fluttertoast.showToast(
                        msg: 'Preencha o campo de CNPJ',
                        toastLength: Toast.LENGTH_SHORT,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }else{
                      if(ChavePublica == ''){
                        Fluttertoast.showToast(
                          msg: 'Preencha o campo de Chave Publica',
                          toastLength: Toast.LENGTH_SHORT,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }else{
                        if(ChavePublica.contains('APP_USR')){
                          if(AssKey == ''){
                            Fluttertoast.showToast(
                              msg: 'Preencha o campo de Access Token',
                              toastLength: Toast.LENGTH_SHORT,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              fontSize: 16.0,
                            );
                          }else{
                            if(AssKey.contains('APP_USR')){
                              //todo update
                              var UID = FirebaseAuth.instance.currentUser?.uid;
                              FirebaseFirestore.instance.collection('Entregador').doc(UID).update({
                                'nameCompleteUser': name,
                                'CPF': CPF,
                                'ChavePublica': ChavePublica,
                                'Access Token': AssKey
                              }).then((value){

                                Fluttertoast.showToast(
                                  msg: 'Dados salvos com sucesso!',
                                  toastLength: Toast.LENGTH_SHORT,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.black,
                                  textColor: Colors.white,
                                  fontSize: 16.0,
                                );

                                Navigator.pop(context);
                              });
                            }else{
                              Fluttertoast.showToast(
                                msg: 'Preencha corretamente o campo de Access Token!',
                                toastLength: Toast.LENGTH_SHORT,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            }
                          }
                        }else{
                          Fluttertoast.showToast(
                            msg: 'Preencha corretamente o campo de Chave Publica!',
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
              },
              child:
              const Text(
                  'Confirmar',
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              style: ElevatedButton.styleFrom(
                  primary: Colors.orange
              ),
            ),
          )
        ],
      ),
    );
  }
}
