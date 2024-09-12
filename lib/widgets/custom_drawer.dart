import 'package:flutter/material.dart';
import 'package:reidaspromocoes/screen/cupons_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart'; // Importa o OneSignal corretamente
import '../utils/utils.dart';
import '../screen/home_screen.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadNotificationPreference();
  }

  // Carrega a preferência de notificações do SharedPreferences
  Future<void> _loadNotificationPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
    });
  }

  // Salva a preferência de notificações no SharedPreferences e ajusta o OneSignal
  Future<void> _saveNotificationPreference(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', value);

    if (value) {
      // Habilita notificações
      OneSignal.User.pushSubscription.optIn();
    } else {
      // Desabilita notificações
      OneSignal.User.pushSubscription.optOut();
    }
  }

  Future<void> _showConsentDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // Usuário deve interagir com o diálogo
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Aviso Importante'),
          content: const Text('''
              Termos de Uso

Bem-vindo ao nosso aplicativo!

Este aplicativo tem como principal objetivo ajudar você a encontrar e visualizar promoções e cupons do dia. Ele não funciona como uma loja online, mas sim como uma ferramenta para indexar e exibir ofertas de diversas fontes, facilitando a sua busca por boas oportunidades.

Ao utilizar nosso aplicativo, você concorda que não somos responsáveis pela validade ou disponibilidade das promoções e cupons apresentados. Nossa missão é simplesmente tornar a busca por ofertas mais prática e acessível para você.

Agradecemos a sua compreensão e esperamos que você aproveite as ofertas encontradas aqui!

          '''),
          actions: <Widget>[
            TextButton(
              child: const Text('Aceitar'),
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('hasConsented', true);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown, // Ajusta o conteúdo para caber
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/splash_icon.png', // Substitua pelo caminho da sua imagem
                    width: 100, // Ajuste o tamanho conforme necessário
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Rei das Promoções',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Início'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
          ),
          ListTile(
            title: Text('Ver Cupons'),
            leading: Icon(Icons
                .local_offer), // Ícone opcional, substitua conforme necessário
            onTap: () {
              // Navegação para a página de cupons
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CuponsScreen()),
              );
            },
          ),
          ListTile(
            title: Text('Promoções Favoritas'),
            leading: Icon(Icons
                .favorite),
            onTap: () {
              Navigator.pushNamed(context, '/favorite');
            },
          ),
          ListTile(
            leading: const Icon(Icons.star),
            title: const Text('Avaliar'),
            onTap: () async {
              const url =
                  'https://play.google.com/store/apps/details?id=com.myapp.reidaspromocoes';
              await Utils.launch(url);
            },
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Termos de Uso'),
            onTap: () {
              Navigator.pop(context);
              _showConsentDialog();
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configurações'),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return AlertDialog(
                        title: const Text('Configurações'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                border: Border.all(
                                    color:
                                        Colors.black), // Adiciona borda preta
                                borderRadius: BorderRadius.circular(
                                    5), // Opcional: arredondar os cantos
                              ),
                              child: SwitchListTile(
                                title: const Text('Receber notificações'),
                                value: _notificationsEnabled,
                                onChanged: (bool value) {
                                  if (_notificationsEnabled != value) {
                                    // Mostra modal de confirmação se a mudança de estado for diferente
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Confirmar'),
                                          content: const Text(
                                              'Você realmente deseja desativar/ativar as notificações?'),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text('Cancelar'),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // Fecha o modal de confirmação
                                              },
                                            ),
                                            TextButton(
                                              child: const Text('Confirmar'),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop(); // Fecha o modal de confirmação
                                                setState(() {
                                                  _notificationsEnabled = value;
                                                  _saveNotificationPreference(
                                                      value);
                                                });
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else {
                                    // Caso contrário, faz a mudança diretamente
                                    setState(() {
                                      _notificationsEnabled = value;
                                      _saveNotificationPreference(value);
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Fechar'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
