import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pedefacil_entregadores_flutter/LoginScreen/LoginScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pedefacil_entregadores_flutter/firebase_options.dart';
import 'package:pedefacil_entregadores_flutter/lista/MainLista.dart';
import 'package:pedefacil_entregadores_flutter/services/NotificationApi.dart';
import 'package:pedefacil_entregadores_flutter/services/notificationintermeter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info_plus/package_info_plus.dart';

//desenvolvido por HeroRickyGames
bool _notificationsEnabled = false;
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

void main(){
  runApp(
    MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        primaryColor: Colors.white,
      ),
      home: const MainClass(),
    ),
  );
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  print('Handling a background message ${message.messageId}');

  var UID = FirebaseAuth.instance.currentUser?.uid;
  var ntf = await FirebaseFirestore.instance
      .collection("Entregador")
      .doc(UID)
      .get();
  if(ntf.exists){
    NotificationApi.showNotification(
        title: '${message.data['title']}',
        body: '${message.data['body']}',
        payload: 'hrg.ntf'
    );

    print('Message data: ${message.data}');
    print('Message data: ${message.data['title']}');
    print('Message data: ${message.data['body']}');

  }else{

  }
}

verifyitsLoginOurNot(context) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  var server = await FirebaseFirestore.instance
      .collection("Server")
      .doc('ServerValues')
      .get();

      if((server.get('SafeOff')) == true){
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                'O servidor do FacilEntregas foi desligado temporariamente!',
                style: TextStyle(
                    fontSize: 19
                ),
              ),
              content: const Text(
                'O desenvolvedor está fazendo manutenção no servidor! Por favor espere até que a manutenção seja finalizada para conseguir usar o app!',
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
      }else{
        FirebaseMessaging messaging = FirebaseMessaging.instance;

        final fcmToken = await FirebaseMessaging.instance.getToken();
        print('O fcm token desse device é ${fcmToken!}');

        final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

        FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
          print('Serviço de notificações está funcionando OK!');

          final SharedPreferences prefs = await _prefs;

          String? negado = prefs.getString('Foi Negado');

          WidgetsFlutterBinding.ensureInitialized();
          await Firebase.initializeApp();
          FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

          if(negado == 'false'){
          //negado!
          }else{
            final bool granted = await flutterLocalNotificationsPlugin
                .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
                ?.areNotificationsEnabled() ??
                false;

            if(granted == false){
              final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
              flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>();

              final bool? granted = await androidImplementation?.requestPermission();
              _notificationsEnabled = granted ?? false;

              prefs.setString('Foi Negado', '$granted');
              //não garantido
            }else{
              _notificationsEnabled = granted;
              //garantido
            }
          }
          intermeterNotifications();
        });

        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
          print('A new onMessageOpenedApp event was published!');
          print('Message data: ${message.data}');
          if (message.notification != null) {
            print('Message also contained a notification: ${message.notification}');
          }
        });

        final info = await PackageInfo.fromPlatform();

        print('App version é ${info.version}');

        await FirebaseAuth.instance
            .idTokenChanges()
            .listen((User? user) async {
          if (user == null) {
            final fcmToken = await FirebaseMessaging.instance.getToken();
            print('O fcm token desse device é ${fcmToken!}');

            FirebaseFirestore.instance.collection('DeviceTokens').doc().set({
              'token': fcmToken
            });

            print('User is currently signed out!');
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context){
                  return LoginScreen();
                }));

          }else{
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
              if(StatusConta == 'Ativo'){
                String Nome =  (result.get('nameCompleteUser'));
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
                  barrierDismissible: false,
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
                String StatusConta = (result2.get('statusDaConta'));
                bool Loja = true;

                if(StatusConta == 'Ativo'){
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context){
                        String Nome =  (result2.get('nameCompleteUser'));
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
                    barrierDismissible: false,
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
          }

        });
      }
}



class MainClass extends StatefulWidget {
  const MainClass({Key? key}) : super(key: key);

  @override
  State<MainClass> createState() => _MainClassState();
}
class _MainClassState extends State<MainClass> {
  @override
  Widget build(BuildContext context) {
    verifyitsLoginOurNot(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
            'FacilEntregas',
          style: TextStyle(
            color: Colors.black
          ),
        ),
        backgroundColor: Colors.orange,
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
