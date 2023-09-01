import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:pedefacil_entregadores_flutter/PaymentModal/paymentModal.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:pedefacil_entregadores_flutter/PaymentModal/paymentModalDonate.dart';
import 'package:pedefacil_entregadores_flutter/modalConfig.dart';
import 'package:pedefacil_entregadores_flutter/modalSolicitacaoEntrega/Solicitacoes-Entregas-Web.dart';
import 'package:pedefacil_entregadores_flutter/modalSolicitacaoEntrega/Solicitacoes-Entregas.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

//desenvolvido por HeroRickyGames

class MainLista extends StatefulWidget {
  bool loja;
  String Nome;
  MainLista(this.loja, this.Nome);

  @override
  State<MainLista> createState() => _MainListaState();
}

class _MainListaState extends State<MainLista> {
  @override
  Widget build(BuildContext context) {
    String holderPlaca = '';
    String? idDocumento;
    double tamanhotexto = 20;
    double tamanhotextomin = 16;
    double tamanhotextobtns = 16;
    double aspect = 1.5;

    if(kIsWeb){
      tamanhotexto = 25;
      tamanhotextomin = 16;
      tamanhotextobtns = 34;
      aspect = 1.3;
    }else{
      if(Platform.isAndroid){

        tamanhotexto = 20;
        tamanhotextobtns = 34;
        aspect =  1.3;

      }
    }
    pagamentoPorUtilizacao(int Valor) async {
      print('Payment por utilização foi iniciado!');

      var server = await FirebaseFirestore.instance
          .collection("Server")
          .doc("ServerValues")
          .get();

      String AssToken = server.get('Access Token');
      String PubKey = server.get('ChavePublica');

      final access_token = AssToken;
      final url = 'https://api.mercadopago.com/checkout/preferences';

      final body = jsonEncode({
        "items": [
          {
            "title": "Pagamento do Donate",
            "description": "Pagamento do Donate",
            "quantity": 1,
            "currency_id": "ARS",
            "unit_price": Valor
          }
        ],
        "back_urls": {
          "success": "https://herorickygames.github.io/Projeto-Pede-Facil-Entregadores/",
          "failure": "https://www.google.com"
        },
        "payer": {
          "email": "payer@email.com"
        }
      });

      final response = await http.post(
        Uri.parse('$url?access_token=$access_token'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.body);

        final preferenceId = jsonDecode(response.body)['id'];
        print('Preference created with ID: $preferenceId');
        
        var uuid = const Uuid().v4();
        var UIDUser = FirebaseAuth.instance.currentUser?.uid;

        if(kIsWeb){

          final init_point = jsonDecode(response.body)['init_point'];
          print('Link da Compra: $init_point');

          String url = '${init_point}';

          if (await canLaunch(url)) {

            await launch(url);

            //todo algo

            print(uuid);

            FirebaseFirestore.instance.collection('PaymentDonateConfim').doc(uuid).set(
                {
                  'UIDCompra': uuid
                }
            ).then((value) {

              bool loja = widget.loja;

              if(loja == true){
                var UID = FirebaseAuth.instance.currentUser?.uid;
                FirebaseFirestore.instance.collection('Loja').doc(UID).update(
                    {
                      'jaPagou': true
                    }
                ).then((value) async {

                });
              }else{
                if(loja == false){
                  var UID = FirebaseAuth.instance.currentUser?.uid;
                  FirebaseFirestore.instance.collection('Entregador').doc(UID).update(
                      {
                        'jaPagou': true
                      }
                  ).then((value) async {

                  });
                }
              }
            });

          } else {

            throw'Não foi possível abrir a URL: $url';

          }

        }else{
          if(Platform.isAndroid){
            Navigator.push(context,
                MaterialPageRoute(builder: (context){
                  return paymentSheetDonate(preferenceId, PubKey, uuid, false, widget.loja, UIDUser);
                }));
          }
        }
      } else {
        print('Error creating preference: ${response.body}');
      }
    }

    verificarsePagou() async {

      if(widget.loja == true){
        print(DateTime.now().weekday);

        var UID = FirebaseAuth.instance.currentUser?.uid;
        
        var result2 = await FirebaseFirestore.instance
            .collection("Loja")
            .doc(UID)
            .get();
        
        bool jaPagou = (result2.get('jaPagou'));
        int valor = 50;

        if(jaPagou == false){
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(
                  'Pagamento para ajudar o desenvolvedor',
                  style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold
                  ),
                ),
                content: SizedBox(
                  width: 350,
                  height: 350,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Para que a plataforma FacilEntregas continue funcionando corretamente, nós precisamos de um valor minimo de R\$${valor},00 para utilização do app, mas se quiser dar mais, seremos gratos!\nA cobrança virá toda a segunda feira.',
                        style: const TextStyle(
                            fontSize: 19
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(16),
                        child:
                        TextFormField(
                          onChanged: (vaalor){
                            valor = int.parse(vaalor);
                            //Mudou mandou para a String
                          },
                          keyboardType: TextInputType.number,
                          obscureText: false,
                          //enableSuggestions: false,
                          //autocorrect: false,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Valor',
                            hintStyle: TextStyle(
                                fontSize: 20
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(onPressed: (){

                    if(valor <= 49){
                      Fluttertoast.showToast(
                        msg: 'O valor não pode ser menor que R\$50.00!',
                        toastLength: Toast.LENGTH_SHORT,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }else{
                      if(valor >= 50){

                        String certa = "${valor}".replaceAll(",", ".");
                        
                        pagamentoPorUtilizacao(int.parse(certa));
                        Navigator.pop(context);
                      }
                    }
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
        }else{
          if(DateTime.sunday == DateTime.now().weekday){
            var UID = FirebaseAuth.instance.currentUser?.uid;
            FirebaseFirestore.instance.collection('Loja').doc(UID).update({
              'jaPagou': false
            });
          }
        }
      }else{
        if(widget.loja == false){
          var UID = FirebaseAuth.instance.currentUser?.uid;

          var result = await FirebaseFirestore.instance
              .collection("Entregador")
              .doc(UID)
              .get();
          bool jaPagou = (result.get('jaPagou'));
          int valor = 5;

          if(jaPagou == false){
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text(
                    'Pagamento para ajudar o desenvolvedor',
                    style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  content: Text(
                    'Para que a plataforma PedeFacilEntregadores continue funcionando corretamente, nós precisamos de um valor de R\$${valor},00 para utilização do app\nA cobrança virá toda a segunda feira.',
                    style: const TextStyle(
                        fontSize: 19
                    ),
                  ),
                  actions: [
                    TextButton(onPressed: (){
                      Navigator.pop(context);
                      pagamentoPorUtilizacao(valor);
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
          }else{
            if(DateTime.sunday == DateTime.now().weekday){
              var UID = FirebaseAuth.instance.currentUser?.uid;
              FirebaseFirestore.instance.collection('Entregador').doc(UID).update({
                'jaPagou': false
              });
            }
          }
        }
      }
    }
    Future.delayed(const Duration(seconds: 1), () {
      if(DateTime.monday == DateTime.now().weekday){
        verificarsePagou();
      }
    });
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Center(
              child: Text(
                  'Itens na lista',
                style: TextStyle(
                    color: Colors.black
                ),
              ),
            ),
            ElevatedButton(onPressed: () async {

              if(widget.loja == true){

                var UID = FirebaseAuth.instance.currentUser?.uid;

                var result = await FirebaseFirestore.instance
                    .collection("Loja")
                    .doc(UID)
                    .get();

                String NameDB = (result.get('nameCompleteUser'));
                String cpfDB = (result.get('CPF'));
                String PubKeyDB = '';
                String AssKeyDB = '';

                Navigator.push(context,
                    MaterialPageRoute(builder: (context){
                      return configModal(widget.loja, NameDB, cpfDB, PubKeyDB, AssKeyDB);
                    }));
              }
              if(widget.loja == false){
                var UID = FirebaseAuth.instance.currentUser?.uid;

                var result = await FirebaseFirestore.instance
                    .collection("Entregador")
                    .doc(UID)
                    .get();

                String NameDB = (result.get('nameCompleteUser'));
                String cpfDB = (result.get('CPF'));
                String PubKeyDB = (result.get('ChavePublica'));
                String AssKeyDB = (result.get('Access Token'));

                Navigator.push(context,
                    MaterialPageRoute(builder: (context){
                      return configModal(widget.loja, NameDB, cpfDB, PubKeyDB, AssKeyDB);
                    }));
              }
            },
                child:
                const Icon(
                    Icons.settings
                )
            )
          ],
        ),
        backgroundColor: Colors.orange,
      ),
      body: widget.loja == true?  StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Solicitacoes-Entregas')
            .where('statusDoProduto', isNotEqualTo:  'Inativo')
            .where('PertenceA', isEqualTo: widget.Nome)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 1.0,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            ),
            child: ListView(
              padding: const EdgeInsets.all(15),
              children: snapshot.data!.docs.map((documents) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 1.0,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: Text(
                                'Quem recebe: ${documents['NomedoProduto']}' ,
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: Text(
                              'Local da Loja: ${documents['Localização']}',
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: Text(
                              'Sendo entregue por: ${documents['entreguePor']}',
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: Text(
                              documents['Preço'],
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: Text(
                              'Pertence à: ${documents['PertenceA']}',
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: Text(
                              'Status: ${documents['statusDoProduto']}',
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                //todo Mudanças de Status

                                if(widget.loja == true){

                                  var UID = FirebaseAuth.instance.currentUser?.uid;
                                  var result = await FirebaseFirestore.instance
                                      .collection("Loja")
                                      .doc(UID)
                                      .get();
                                  if(documents['PertenceA'] == result.get('nameCompleteUser')){

                                    if(documents['statusDoProduto'] == 'Ativo' ){
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                              'Deseja Deletar esse pedido?',
                                              style: TextStyle(
                                                  fontSize: 19
                                              ),
                                            ),
                                            content: const Text(
                                              'A partir do momento que você deletar esse pedido, ele não irá aparecer para mais ninguém!',
                                              style: TextStyle(
                                                  fontSize: 18
                                              ),
                                            ),
                                            actions: [
                                              TextButton(onPressed: (){

                                                Navigator.pop(context);

                                              }, child: const Text(
                                                'Não',
                                                style: TextStyle(
                                                    fontSize: 18
                                                ),
                                              )
                                              ),
                                              TextButton(onPressed: (){

                                                FirebaseFirestore.instance.collection('Solicitacoes-Entregas').doc(documents['id']).update(
                                                    {
                                                      'statusDoProduto': 'Inativo'
                                                    }
                                                ).then((value) {
                                                  Fluttertoast.showToast(
                                                    msg: 'Inativo!',
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor: Colors.black,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0,
                                                  );
                                                  Navigator.pop(context);
                                                });

                                              }, child: const Text(
                                                'Sim, delete!',
                                                style: TextStyle(
                                                    fontSize: 19
                                                ),
                                              )
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }else{

                                      if(documents['statusDoProduto'] == 'Em Pagamento'){
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                'Fazer o pagamento agora?',
                                                style: TextStyle(
                                                    fontSize: 19
                                                ),
                                              ),
                                              content: const Text(
                                                'Fazer o pagamento agora?\n É recomendado fazer o pagamento agora!',
                                                style: TextStyle(
                                                    fontSize: 19
                                                ),
                                              ),
                                              actions: [
                                                TextButton(onPressed: () async {

                                                  var result2 = await FirebaseFirestore.instance
                                                      .collection("Entregador")
                                                      .doc(documents['idEntregador'])
                                                      .get();

                                                  String AssToken = result2.get('Access Token');
                                                  String PubKeydb = result2.get('ChavePublica');

                                                  final access_token = AssToken;
                                                  final PubKey = PubKeydb;
                                                  final url = 'https://api.mercadopago.com/checkout/preferences';

                                                  final body = jsonEncode({
                                                    "items": [
                                                      {
                                                        "title": documents['NomedoProduto'],
                                                        "description": "Pagamento da Entrega",
                                                        "quantity": 1,
                                                        "currency_id": "ARS",
                                                        "unit_price": double.parse(documents['Preço'].replaceAll('R\$ ', ''))
                                                      }
                                                    ],
                                                    "payer": {
                                                      "email": "payer@email.com"
                                                    }
                                                  });

                                                  final response = await http.post(
                                                    Uri.parse('$url?access_token=$access_token'),
                                                    headers: {
                                                      'Content-Type': 'application/json',
                                                    },
                                                    body: body,
                                                  );

                                                  if (response.statusCode == 200 || response.statusCode == 201) {
                                                    final preferenceId = jsonDecode(response.body)['id'];
                                                    print('Preference created with ID: $preferenceId');

                                                    final init_point = jsonDecode(response.body)['init_point'];
                                                    print('Link da Compra: $init_point');

                                                    String url = '${init_point}';

                                                    if(kIsWeb){

                                                      await launch(url);

                                                      print(documents['id']);

                                                      FirebaseFirestore.instance.collection('Solicitacoes-Entregas').doc(documents['id']).update(
                                                          {
                                                            'statusDoProduto': 'Pronto para a entrega'
                                                          }
                                                      ).then((value) async {

                                                        var UID = FirebaseAuth.instance.currentUser?.uid;
                                                        var result2 = await FirebaseFirestore.instance
                                                            .collection("Loja")
                                                            .doc(UID)
                                                            .get();

                                                        String Nome =  (result2.get('nameCompleteUser'));

                                                        FirebaseFirestore.instance.collection('PaymentsCompletes').doc(documents['id']).set(
                                                            {
                                                              "quemPagou": Nome,
                                                              'UIDCompra': preferenceId
                                                            }
                                                        );
                                                        Navigator.of(context).pop();
                                                      });
                                                    }else{
                                                      if(Platform.isAndroid){
                                                        Navigator.push(context,
                                                            MaterialPageRoute(builder: (context){
                                                              return paymentSheet(preferenceId, PubKey, documents['id'], documents['pagardepois']);
                                                            }));
                                                      }
                                                    }

                                                  } else {

                                                    final preferenceId = jsonDecode(response.body)['id'];
                                                    print('Error creating preference: ${response.body}');
                                                    print('Preference created with ID: $preferenceId');

                                                  }


                                                }, child: const Text(
                                                  'Pagar agora',
                                                  style: TextStyle(
                                                      fontSize: 19
                                                  ),
                                                )
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }else{

                                      }
                                    }
                                  }else{

                                  }
                                }else{
                                  if(widget.loja == false){
                                    if(documents['statusDoProduto'] == 'Ativo' ){
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                              'Fazer essa entrega?',
                                              style: TextStyle(
                                                  fontSize: 19
                                              ),
                                            ),
                                            content: const Text(
                                              'Você deseja fazer essa entrega?',
                                              style: TextStyle(
                                                  fontSize: 19
                                              ),
                                            ),
                                            actions: [
                                              TextButton(onPressed: (){
                                                Navigator.pop(context);
                                              }, child: const Text(
                                                'Não',
                                                style: TextStyle(
                                                    fontSize: 19
                                                ),
                                              )
                                              ),
                                              TextButton(onPressed: () async {

                                                var UID = FirebaseAuth.instance.currentUser?.uid;

                                                var result = await FirebaseFirestore.instance
                                                    .collection("Entregador")
                                                    .doc(UID)
                                                    .get();

                                                FirebaseFirestore.instance.collection('Solicitacoes-Entregas').doc(documents['id']).update(
                                                    {
                                                      'statusDoProduto': 'A caminho',
                                                      'idEntregador': result.get('uid'),
                                                      'entreguePor': result.get('nameCompleteUser')
                                                    }
                                                ).then((value) async {
                                                  Fluttertoast.showToast(
                                                    msg: 'A caminho!',
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor: Colors.black,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0,
                                                  );

                                                  double LatitudeLoja = documents['latitude'];
                                                  double LongtudeLoja = documents['longitude'];

                                                  Map<String, double> location = {'latitude': LatitudeLoja, 'longitude': LongtudeLoja};
                                                  MapsLauncher.launchCoordinates(location['latitude']!, location['longitude']!, 'Entrega');

                                                  Navigator.pop(context);
                                                });

                                              }, child: const Text(
                                                'Sim',
                                                style: TextStyle(
                                                    fontSize: 19
                                                ),
                                              )
                                              ),
                                            ],
                                          );
                                        },
                                      );

                                    }else{

                                      if(documents['statusDoProduto'] == 'A caminho' ){

                                        var UID = FirebaseAuth.instance.currentUser?.uid;

                                        var result = await FirebaseFirestore.instance
                                            .collection("Entregador")
                                            .doc(UID)
                                            .get();
                                        if(documents['entreguePor'] == result.get('nameCompleteUser')){

                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text(
                                                  'Chegou ao destino?',
                                                  style: TextStyle(
                                                      fontSize: 19
                                                  ),
                                                ),
                                                content: const Text(
                                                  'Você chegou á loja?',
                                                  style: TextStyle(
                                                      fontSize: 19
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(onPressed: (){
                                                    Navigator.pop(context);
                                                  }, child: const Text(
                                                    'Não',
                                                    style: TextStyle(
                                                        fontSize: 19
                                                    ),
                                                  )
                                                  ),
                                                  TextButton(onPressed: (){

                                                    FirebaseFirestore.instance.collection('Solicitacoes-Entregas').doc(documents['id']).update(
                                                        {
                                                          'statusDoProduto': 'Em Pagamento',
                                                        }).then((value) async {

                                                      Fluttertoast.showToast(
                                                        msg: 'Confirmado!',
                                                        toastLength: Toast.LENGTH_SHORT,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor: Colors.black,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0,
                                                      );

                                                      Navigator.pop(context);
                                                    });

                                                  }, child: const Text(
                                                    'Sim',
                                                    style: TextStyle(
                                                        fontSize: 19
                                                    ),
                                                  )
                                                  ),
                                                ],
                                              );
                                            },
                                          );

                                        }else{

                                        }

                                      }else{

                                        if(documents['statusDoProduto'] == 'Em Pagamento'){
                                          var UID = FirebaseAuth.instance.currentUser?.uid;

                                          var result = await FirebaseFirestore.instance
                                              .collection("Entregador")
                                              .doc(UID)
                                              .get();
                                          if(documents['entreguePor'] == result.get('nameCompleteUser')){

                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    'Aguarde o pagamento ser finalizado pelo lojista!',
                                                    style: TextStyle(
                                                        fontSize: 19
                                                    ),
                                                  ),
                                                  content: const Text(
                                                    'Aguarde o pagamento ser finalizado pelo lojista!',
                                                    style: TextStyle(
                                                        fontSize: 19
                                                    ),
                                                  ),
                                                  actions: [
                                                    TextButton(onPressed: (){
                                                    Navigator.pop(context);
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
                                          var UID = FirebaseAuth.instance.currentUser?.uid;

                                          var result = await FirebaseFirestore.instance
                                              .collection("Entregador")
                                              .doc(UID)
                                              .get();
                                          if(documents['statusDoProduto'] == 'Pronto para a entrega'){
                                            if(documents['entreguePor'] == result.get('nameCompleteUser')){
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                      'Fazer a entrega?',
                                                      style: TextStyle(
                                                          fontSize: 19
                                                      ),
                                                    ),
                                                    content: const Text(
                                                      'Você deseja realisar a entrega até o endereço?',
                                                      style: TextStyle(
                                                          fontSize: 19
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(onPressed: (){
                                                        Navigator.pop(context);
                                                      }, child: const Text(
                                                        'Não',
                                                        style: TextStyle(
                                                            fontSize: 19
                                                        ),
                                                      )
                                                      ),
                                                      TextButton(onPressed: () async {
                                                        FirebaseFirestore.instance.collection('Solicitacoes-Entregas').doc(documents['id']).update(
                                                            {
                                                              'statusDoProduto': 'Em Entrega',
                                                            }
                                                        ).then((value) async {
                                                          Fluttertoast.showToast(
                                                            msg: 'Em Entrega!',
                                                            toastLength: Toast.LENGTH_SHORT,
                                                            timeInSecForIosWeb: 1,
                                                            backgroundColor: Colors.black,
                                                            textColor: Colors.white,
                                                            fontSize: 16.0,
                                                          );

                                                          double LatitudeEntrega = double.parse(documents['latEntrega']);
                                                          double LongitudeEntrega = double.parse(documents['longEntrega']);

                                                          Map<String, double> location = {'latitude': LatitudeEntrega, 'longitude': LongitudeEntrega};
                                                          MapsLauncher.launchCoordinates(location['latitude']!, location['longitude']!, 'Entrega');

                                                          Navigator.pop(context);
                                                        });
                                                      }, child: const Text(
                                                        'Sim',
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
                                          var result = await FirebaseFirestore.instance
                                              .collection("Entregador")
                                              .doc(UID)
                                              .get();
                                          if(documents['statusDoProduto'] == 'Em Entrega'){
                                            if(documents['entreguePor'] == result.get('nameCompleteUser')){
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                      'Você chegou?',
                                                      style: TextStyle(
                                                          fontSize: 19
                                                      ),
                                                    ),
                                                    content: const Text(
                                                      'Você chegou?',
                                                      style: TextStyle(
                                                          fontSize: 19
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(onPressed: (){
                                                        double LatitudeEntrega = double.parse(documents['latEntrega']);
                                                        double LongitudeEntrega = double.parse(documents['longEntrega']);

                                                        Map<String, double> location = {'latitude': LatitudeEntrega, 'longitude': LongitudeEntrega};
                                                        MapsLauncher.launchCoordinates(location['latitude']!, location['longitude']!, 'Entrega');

                                                        Navigator.pop(context);
                                                      }, child: const Text(
                                                        'Desejo ver a localização novamente',
                                                        style: TextStyle(
                                                            fontSize: 19
                                                        ),
                                                      ),
                                                      ),
                                                      TextButton(onPressed: (){
                                                        Navigator.pop(context);
                                                      }, child: const Text(
                                                        'Não',
                                                        style: TextStyle(
                                                            fontSize: 19
                                                        ),
                                                      ),
                                                      ),
                                                      TextButton(onPressed: (){
                                                        FirebaseFirestore.instance.collection('Solicitacoes-Entregas').doc(documents['id']).update(
                                                            {
                                                              'statusDoProduto': 'Inativo',
                                                              'status': 'Entregue'
                                                            }
                                                        ).then((value) async {
                                                          Fluttertoast.showToast(
                                                            msg: 'Entrega Realisada com sucesso!',
                                                            toastLength: Toast.LENGTH_SHORT,
                                                            timeInSecForIosWeb: 1,
                                                            backgroundColor: Colors.black,
                                                            textColor: Colors.white,
                                                            fontSize: 16.0,
                                                          );
                                                          Navigator.pop(context);
                                                        });
                                                      }, child: const Text(
                                                        'Sim',
                                                        style: TextStyle(
                                                            fontSize: 19
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                    );
                                                  },
                                                );
                                              }
                                            }
                                          }
                                        }
                                      }
                                    }
                                  }
                                }
                              },
                              child: const Text(
                                  'Mudar Status',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.orange
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList().reversed.toList(),
            ),
          );
        },
      ):
      StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Solicitacoes-Entregas')
            .where('statusDoProduto', isNotEqualTo:  'Inativo')
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 1.0,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            ),
            child: ListView(
              padding: const EdgeInsets.all(15),
              children: snapshot.data!.docs.map((documents) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 1.0,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: Text(
                              'Quem recebe: ' + documents['NomedoProduto'],
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: Text(
                              'Local da Loja: ' + documents['Localização'],
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: Text(
                              'Sendo entregue por: ' + documents['entreguePor'],
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: Text(
                              documents['Preço'],
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: Text(
                              'Pertence à: ' + documents['PertenceA'],
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: Text(
                              'Status: ' + documents['statusDoProduto'],
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Center(
                            child: ElevatedButton(
                              onPressed: () async {
                                //todo Mudanças de Status

                                if(widget.loja == true){

                                  var UID = FirebaseAuth.instance.currentUser?.uid;
                                  var result = await FirebaseFirestore.instance
                                      .collection("Loja")
                                      .doc(UID)
                                      .get();
                                  if(documents['PertenceA'] == result.get('nameCompleteUser')){

                                    if(documents['statusDoProduto'] == 'Ativo' ){
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                              'Deseja Deletar esse pedido?',
                                              style: TextStyle(
                                                  fontSize: 19
                                              ),
                                            ),
                                            content: const Text(
                                              'A partir do momento que você deletar esse pedido, ele não irá aparecer para mais ninguém!',
                                              style: TextStyle(
                                                  fontSize: 18
                                              ),
                                            ),
                                            actions: [
                                              TextButton(onPressed: (){

                                                Navigator.pop(context);

                                              }, child: const Text(
                                                'Não',
                                                style: TextStyle(
                                                    fontSize: 18
                                                ),
                                              )
                                              ),
                                              TextButton(onPressed: (){

                                                FirebaseFirestore.instance.collection('Solicitacoes-Entregas').doc(documents['id']).update(
                                                    {
                                                      'statusDoProduto': 'Inativo'
                                                    }
                                                ).then((value) {
                                                  Fluttertoast.showToast(
                                                    msg: 'Inativo!',
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor: Colors.black,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0,
                                                  );
                                                  Navigator.pop(context);
                                                });

                                              }, child: const Text(
                                                'Sim, delete!',
                                                style: TextStyle(
                                                    fontSize: 19
                                                ),
                                              )
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }else{

                                      if(documents['statusDoProduto'] == 'Em Pagamento'){
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                'Fazer o pagamento agora?',
                                                style: TextStyle(
                                                    fontSize: 19
                                                ),
                                              ),
                                              content: const Text(
                                                'Fazer o pagamento agora?\n É recomendado fazer o pagamento agora!',
                                                style: TextStyle(
                                                    fontSize: 19
                                                ),
                                              ),
                                              actions: [
                                                TextButton(onPressed: (){

                                                  FirebaseFirestore.instance.collection('Solicitacoes-Entregas').doc(documents['id']).update(
                                                      {
                                                        'statusDoProduto': 'Pronto para Entrega, mais pagamento pós entrega',
                                                        'É retornavel': true,
                                                      }
                                                  ).then((value) async {
                                                    Fluttertoast.showToast(
                                                      msg: 'Ok, sem problemas!',
                                                      toastLength: Toast.LENGTH_SHORT,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor: Colors.black,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0,
                                                    );
                                                    Navigator.pop(context);
                                                  });
                                                }, child: const Text(
                                                  'Pagar apenas depois',
                                                  style: TextStyle(
                                                      fontSize: 19
                                                  ),
                                                )
                                                ),
                                                TextButton(onPressed: () async {

                                                  var server = await FirebaseFirestore.instance
                                                      .collection("Server")
                                                      .doc("ServerValues")
                                                      .get();

                                                  String URLString = server.get('URLServer');
                                                  var url = Uri.parse('http://${URLString}/api/paymentSheet');

                                                  var result2 = await FirebaseFirestore.instance
                                                      .collection("Entregador")
                                                      .doc(documents['idEntregador'])
                                                      .get();

                                                  String AssToken = result2.get('Access Token');
                                                  String PubKey = result2.get('ChavePublica');

                                                  Map data = {
                                                    "acessToken": AssToken,
                                                    "transactionValue": double.parse(documents['Preço'].replaceAll('R\$ ', '')),
                                                    "EntregaTitulo": documents['NomedoProduto']
                                                  };

                                                  String jsonData = jsonEncode(data);

                                                  var response = await http.post(url, headers: {'Content-Type': 'application/json'}, body: jsonData);

                                                  if (response.statusCode == 200 || response.statusCode == 201) {
                                                    print(response.body);

                                                    print(URLString);
                                                    final String url = 'http://${URLString}/api/paymentSheet/requestComplete';
                                                    final response2 = await http.get(Uri.parse(url));

                                                    Fluttertoast.showToast(
                                                        msg: 'O status foi ${response2.statusCode}',
                                                        toastLength: Toast.LENGTH_SHORT,
                                                        gravity: ToastGravity.CENTER,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor: Colors.grey[600],
                                                        textColor: Colors.white,
                                                        fontSize: 16.0
                                                    );

                                                    print(response2.statusCode);
                                                    if (response2.statusCode == 200) {
                                                      Fluttertoast.showToast(
                                                          msg: "Gerando o checkout para pagamento",
                                                          toastLength: Toast.LENGTH_LONG,
                                                          gravity: ToastGravity.CENTER,
                                                          timeInSecForIosWeb: 1,
                                                          backgroundColor: Colors.grey[600],
                                                          textColor: Colors.white,
                                                          fontSize: 16.0
                                                      );

                                                      final responseJson = json.decode(response2.body);
                                                      final nome = responseJson['idCompra'];
                                                      String idCompra = nome;

                                                      print(idCompra);
                                                      print(response2.body);

                                                      Navigator.push(context,
                                                          MaterialPageRoute(builder: (context){
                                                            return paymentSheet(idCompra, PubKey, documents['id'], documents['pagardepois']);
                                                          }));

                                                    } else {
                                                      // Houve um erro ao receber os dados
                                                      print('Erro ao receber os dados: ${response2.statusCode}');

                                                      Fluttertoast.showToast(
                                                          msg: "Ocorreu um erro comum ao executar, tente novamente por favor!",
                                                          toastLength: Toast.LENGTH_SHORT,
                                                          gravity: ToastGravity.CENTER,
                                                          timeInSecForIosWeb: 1,
                                                          backgroundColor: Colors.grey[600],
                                                          textColor: Colors.white,
                                                          fontSize: 16.0
                                                      );
                                                    }

                                                  } else {
                                                    // A solicitação não foi bem-sucedida, trate o erro aqui
                                                    print('Erro ao receber os dados: ${response.statusCode}.');
                                                  }

                                                }, child: const Text(
                                                  'Pagar agora',
                                                  style: TextStyle(
                                                      fontSize: 19
                                                  ),
                                                )
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }else{

                                      }
                                    }
                                  }else{

                                  }
                                }else{
                                  if(widget.loja == false){
                                    if(documents['statusDoProduto'] == 'Ativo' ){
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                              'Fazer essa entrega?',
                                              style: TextStyle(
                                                  fontSize: 19
                                              ),
                                            ),
                                            content: const Text(
                                              'Você deseja fazer essa entrega?',
                                              style: TextStyle(
                                                  fontSize: 19
                                              ),
                                            ),
                                            actions: [
                                              TextButton(onPressed: (){
                                                Navigator.pop(context);
                                              }, child: const Text(
                                                'Não',
                                                style: TextStyle(
                                                    fontSize: 19
                                                ),
                                              )
                                              ),
                                              TextButton(onPressed: () async {

                                                var UID = FirebaseAuth.instance.currentUser?.uid;

                                                var result = await FirebaseFirestore.instance
                                                    .collection("Entregador")
                                                    .doc(UID)
                                                    .get();

                                                FirebaseFirestore.instance.collection('Solicitacoes-Entregas').doc(documents['id']).update(
                                                    {
                                                      'statusDoProduto': 'A caminho',
                                                      'idEntregador': result.get('uid'),
                                                      'entreguePor': result.get('nameCompleteUser')
                                                    }
                                                ).then((value) async {
                                                  Fluttertoast.showToast(
                                                    msg: 'A caminho!',
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor: Colors.black,
                                                    textColor: Colors.white,
                                                    fontSize: 16.0,
                                                  );



                                                  double LatitudeLoja = documents['latitude'] ;
                                                  double LongtudeLoja = documents['longitude'] ;

                                                  Map<String, double> location = {'latitude': LatitudeLoja, 'longitude': LongtudeLoja};
                                                  MapsLauncher.launchCoordinates(location['latitude']!, location['longitude']!, 'Entrega');

                                                  Navigator.pop(context);
                                                });

                                              }, child: const Text(
                                                'Sim',
                                                style: TextStyle(
                                                    fontSize: 19
                                                ),
                                              )
                                              ),
                                            ],
                                          );
                                        },
                                      );

                                    }else{

                                      if(documents['statusDoProduto'] == 'A caminho' ){

                                        var UID = FirebaseAuth.instance.currentUser?.uid;

                                        var result = await FirebaseFirestore.instance
                                            .collection("Entregador")
                                            .doc(UID)
                                            .get();
                                        if(documents['entreguePor'] == result.get('nameCompleteUser')){

                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text(
                                                  'Chegou ao destino?',
                                                  style: TextStyle(
                                                      fontSize: 19
                                                  ),
                                                ),
                                                content: const Text(
                                                  'Você chegou á loja?',
                                                  style: TextStyle(
                                                      fontSize: 19
                                                  ),
                                                ),
                                                actions: [
                                                  TextButton(onPressed: (){
                                                    Navigator.pop(context);
                                                  }, child: const Text(
                                                    'Não',
                                                    style: TextStyle(
                                                        fontSize: 19
                                                    ),
                                                  )
                                                  ),
                                                  TextButton(onPressed: (){

                                                    FirebaseFirestore.instance.collection('Solicitacoes-Entregas').doc(documents['id']).update(
                                                        {
                                                          'statusDoProduto': 'Em Pagamento',
                                                        }).then((value) async {

                                                      Fluttertoast.showToast(
                                                        msg: 'Confirmado!',
                                                        toastLength: Toast.LENGTH_SHORT,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor: Colors.black,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0,
                                                      );

                                                      Navigator.pop(context);
                                                    });

                                                  }, child: const Text(
                                                    'Sim',
                                                    style: TextStyle(
                                                        fontSize: 19
                                                    ),
                                                  )
                                                  ),
                                                ],
                                              );
                                            },
                                          );

                                        }else{

                                        }

                                      }else{

                                        if(documents['statusDoProduto'] == 'Em Pagamento'){
                                          var UID = FirebaseAuth.instance.currentUser?.uid;

                                          var result = await FirebaseFirestore.instance
                                              .collection("Entregador")
                                              .doc(UID)
                                              .get();
                                          if(documents['entreguePor'] == result.get('nameCompleteUser')){

                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    'Aguarde o pagamento ser finalizado pelo lojista!',
                                                    style: TextStyle(
                                                        fontSize: 19
                                                    ),
                                                  ),
                                                  content: const Text(
                                                    'Aguarde o pagamento ser finalizado pelo lojista!',
                                                    style: TextStyle(
                                                        fontSize: 19
                                                    ),
                                                  ),
                                                  actions: [
                                                    TextButton(onPressed: (){
                                                      Navigator.pop(context);
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
                                          var UID = FirebaseAuth.instance.currentUser?.uid;

                                          var result = await FirebaseFirestore.instance
                                              .collection("Entregador")
                                              .doc(UID)
                                              .get();
                                          if(documents['statusDoProduto'] == 'Pronto para a entrega'){
                                            if(documents['entreguePor'] == result.get('nameCompleteUser')){
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                      'Fazer a entrega?',
                                                      style: TextStyle(
                                                          fontSize: 19
                                                      ),
                                                    ),
                                                    content: const Text(
                                                      'Você deseja realisar a entrega até o endereço?',
                                                      style: TextStyle(
                                                          fontSize: 19
                                                      ),
                                                    ),
                                                    actions: [
                                                      TextButton(onPressed: (){
                                                        Navigator.pop(context);
                                                      }, child: const Text(
                                                        'Não',
                                                        style: TextStyle(
                                                            fontSize: 19
                                                        ),
                                                      )
                                                      ),
                                                      TextButton(onPressed: () async {
                                                        FirebaseFirestore.instance.collection('Solicitacoes-Entregas').doc(documents['id']).update(
                                                            {
                                                              'statusDoProduto': 'Em Entrega',
                                                            }
                                                        ).then((value) async {
                                                          Fluttertoast.showToast(
                                                            msg: 'Em Entrega!',
                                                            toastLength: Toast.LENGTH_SHORT,
                                                            timeInSecForIosWeb: 1,
                                                            backgroundColor: Colors.black,
                                                            textColor: Colors.white,
                                                            fontSize: 16.0,
                                                          );

                                                          double LatitudeEntrega = documents['latEntrega'];
                                                          double LongitudeEntrega = documents['longEntrega'];

                                                          Map<String, double> location = {'latitude': LatitudeEntrega, 'longitude': LongitudeEntrega};
                                                          MapsLauncher.launchCoordinates(location['latitude']!, location['longitude']!, 'Entrega');

                                                          Navigator.pop(context);
                                                        });
                                                      }, child: const Text(
                                                        'Sim',
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
                                            var result = await FirebaseFirestore.instance
                                                .collection("Entregador")
                                                .doc(UID)
                                                .get();
                                            if(documents['statusDoProduto'] == 'Em Entrega'){
                                              if(documents['entreguePor'] == result.get('nameCompleteUser')){
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      title: const Text(
                                                        'Você chegou?',
                                                        style: TextStyle(
                                                            fontSize: 19
                                                        ),
                                                      ),
                                                      content: const Text(
                                                        'Você chegou?',
                                                        style: TextStyle(
                                                            fontSize: 19
                                                        ),
                                                      ),
                                                      actions: [
                                                        TextButton(onPressed: (){
                                                          double LatitudeEntrega = documents['latEntrega'];
                                                          double LongitudeEntrega = documents['longEntrega'];

                                                          Map<String, double> location = {'latitude': LatitudeEntrega, 'longitude': LongitudeEntrega};
                                                          MapsLauncher.launchCoordinates(location['latitude']!, location['longitude']!, 'Entrega');

                                                          Navigator.pop(context);
                                                        }, child: const Text(
                                                          'Desejo ver a localização novamente',
                                                          style: TextStyle(
                                                              fontSize: 19
                                                          ),
                                                        ),
                                                        ),
                                                        TextButton(onPressed: (){
                                                          Navigator.pop(context);
                                                        }, child: const Text(
                                                          'Não',
                                                          style: TextStyle(
                                                              fontSize: 19
                                                          ),
                                                        ),
                                                        ),
                                                        TextButton(onPressed: (){
                                                          FirebaseFirestore.instance.collection('Solicitacoes-Entregas').doc(documents['id']).update(
                                                              {
                                                                'statusDoProduto': 'Inativo',
                                                                'status': 'Entregue'
                                                              }
                                                          ).then((value) async {
                                                            Fluttertoast.showToast(
                                                              msg: 'Entrega Realisada com sucesso!',
                                                              toastLength: Toast.LENGTH_SHORT,
                                                              timeInSecForIosWeb: 1,
                                                              backgroundColor: Colors.black,
                                                              textColor: Colors.white,
                                                              fontSize: 16.0,
                                                            );
                                                            Navigator.pop(context);
                                                          });
                                                        }, child: const Text(
                                                          'Sim',
                                                          style: TextStyle(
                                                              fontSize: 19
                                                          ),
                                                        ),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              }
                                            }
                                          }
                                        }
                                      }
                                    }
                                  }
                                }
                              },
                              child: const Text(
                                'Mudar Status',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.orange
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList().reversed.toList(),
            ),
          );
        },
      ),
      floatingActionButton: widget.loja == true? FloatingActionButton(
        onPressed: () {

          if(kIsWeb){

            Navigator.push(context,
                MaterialPageRoute(builder: (context){
                  return const SolcitacaoEntregaWeb();
                }));

          }else{
            if(Platform.isAndroid){

              Navigator.push(context,
                  MaterialPageRoute(builder: (context){
                    return const SolcitacaoEntrega();
                  }));

            }
          }
        },
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ): const Text('')
        ,floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: BottomAppBar(
          child: Row(
            children: [
              IconButton(
                icon: const Row(
                  children: [
                    Icon(Icons.monetization_on),
                    Text('Doe para o Desenvolvimento do app!')
                  ],
                ),
                onPressed: () {
                  int valor = 0;
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text(
                          'Faça um donate para o desenvolvedor do app',
                          style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        content: SizedBox(
                          width: 350,
                          height: 350,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Faça uma doação para o desenvolvedor!\nQualquer valor é valido!',
                                style: TextStyle(
                                    fontSize: 19
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(16),
                                child:
                                TextFormField(
                                  onChanged: (vaalor){
                                    valor = int.parse(vaalor);
                                    //Mudou mandou para a String
                                  },
                                  keyboardType: TextInputType.number,
                                  obscureText: false,
                                  //enableSuggestions: false,
                                  //autocorrect: false,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Valor',
                                    hintStyle: TextStyle(
                                        fontSize: 20
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(onPressed: (){

                            if(valor <= 0){
                              Fluttertoast.showToast(
                                msg: 'O valor não pode ser menor que R\$0.00!',
                                toastLength: Toast.LENGTH_SHORT,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            }else{
                              if(valor >= 1){

                                String certa = "${valor}".replaceAll(",", ".");

                                pagamentoPorUtilizacao(int.parse(certa));
                                Navigator.pop(context);
                              }
                            }
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
                },
              ),
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
