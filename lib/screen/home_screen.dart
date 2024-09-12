import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:reidaspromocoes/admob/banner.dart';
import 'package:reidaspromocoes/admob/intersticial.dart';
import 'package:reidaspromocoes/widgets/appbar.dart';
import 'package:reidaspromocoes/widgets/card.dart';
import 'package:reidaspromocoes/widgets/custom_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/promotion_model.dart';
import '../services/promotion_service.dart';
import '../utils/utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Promotion>> _promotionsFuture;
  DateTime? _selectedDate;
  String _searchQuery = '';
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final InterstitialAdManager _interstitialAdManager =
      InterstitialAdManager(); 
  final BannerAdManager _bannerAdManager =
      BannerAdManager(); 
 

  @override
  void initState() {
    super.initState();    
    _bannerAdManager.loadAd(); 
    _signInAnonymously().then((_) {
      setState(() {
        _promotionsFuture = _loadPromotions();
      });
    }).catchError((error) {
      print('Erro ao autenticar: $error');
    });
    _checkUserConsent();
  }

  Future<void> _signInAnonymously() async {
    final prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('anonymousUid');

    if (uid == null) {
      try {
        UserCredential userCredential = await _auth.signInAnonymously();
        uid = userCredential.user?.uid;
        await prefs.setString('anonymousUid', uid!);
      } catch (e) {
        print('Erro ao autenticar anonimamente: $e');
      }
    }
  }

  Future<void> _checkUserConsent() async {
    final prefs = await SharedPreferences.getInstance();
    final hasConsented = prefs.getBool('hasConsented') ?? false;
    if (!hasConsented) {
      _showConsentDialog();
    }
  }

  Future<void> _showConsentDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
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

  Future<List<Promotion>> _loadPromotions() async {
    try {
      final fetchedPromotions = await PromocaoService().fetchPromocoes();
      return fetchedPromotions;
    } catch (e) {
      print('Erro ao buscar promoções: $e');
      return [];
    }
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _cancelSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      _searchQuery = '';
    });
  }

  void _onDateSelected(DateTime? pickedDate) {
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  Future<List<Promotion>> _fetchFilteredPromotions() async {
    final promotions = await _promotionsFuture;

    final filteredPromotions = promotions.where((promotion) {
      final matchesDate = _selectedDate == null ||
          (promotion.dateTime.year == _selectedDate!.year &&
              promotion.dateTime.month == _selectedDate!.month &&
              promotion.dateTime.day == _selectedDate!.day);
      final matchesQuery = _searchQuery.isEmpty ||
          promotion.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          promotion.description
              .toLowerCase()
              .contains(_searchQuery.toLowerCase());
      return matchesDate && matchesQuery;
    }).toList();

    filteredPromotions.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return filteredPromotions;
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        isSearching: _isSearching,
        searchController: _searchController,
        onSearchCancel: _cancelSearch,
        onSearchQueryChanged: (query) {
          setState(() {
            _searchQuery = query;
          });
        },
        onSearchStart: _startSearch,
        onDateSelected: () async {
          final DateTime? pickedDate =
              await Utils.selectDate(context, _selectedDate);
          if (pickedDate != null) {
            _onDateSelected(pickedDate);
          }
        },
      ),
      drawer: const CustomDrawer(),
      body: Stack(
        children: [
          FutureBuilder<List<Promotion>>(
            future: _fetchFilteredPromotions(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError ||
                  !snapshot.hasData ||
                  snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    'Nenhuma promoção disponível',
                    style: TextStyle(fontSize: 18),
                  ),
                );
              } else {
                final promotions = snapshot.data!;
                return RefreshIndicator(
                  onRefresh: () async {
                    final newPromotions = await _loadPromotions();
                    setState(() {
                      _promotionsFuture = Future.value(newPromotions);
                    });
                  },
                  child: ListView.builder(
                    itemCount: promotions.length,
                    itemBuilder: (context, index) {
                      final promotion = promotions[index];
                      return PromotionCard(
                        promotion: promotion,
                        onTap: (url) {                          
                          Utils.launch(url);
                        },
                      );
                    },
                  ),
                );
              }
            },
          ),
          if (_bannerAdManager.bannerAd != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: _bannerAdManager.bannerAd?.size.height.toDouble(),
                child: AdWidget(ad: _bannerAdManager.bannerAd!),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _interstitialAdManager
        .dispose(); // Libera o gerenciador de anúncios intersticiais
    _bannerAdManager.dispose(); // Libera o gerenciador de banner
    super.dispose();
  }
}
