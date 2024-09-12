import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:reidaspromocoes/model/cupons_model.dart';
import 'package:reidaspromocoes/services/cupons_service.dart';
import 'package:reidaspromocoes/widgets/appbar.dart';
import 'package:reidaspromocoes/widgets/card_cupon.dart';
import 'package:reidaspromocoes/widgets/custom_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/utils.dart';
import 'package:reidaspromocoes/admob/banner.dart';

class CuponsScreen extends StatefulWidget {
  const CuponsScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<CuponsScreen> {
  late Future<List<Coupon>> _couponsFuture; // Atualize o tipo para Coupon
  DateTime? _selectedDate;
  // ignore: unused_field
  String _searchQuery = '';
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final BannerAdManager _bannerAdManager =
      BannerAdManager(); // Instancia do gerenciador de banner
   // Instancia do gerenciador de anúncios intersticiais

  @override
  void initState() {
    super.initState();
    _loadCoupons(); // Atualize para carregar cupons
    _checkUserConsent();
    _bannerAdManager.loadAd();    
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

  Future<void> _loadCoupons() async {
    setState(() {
      _couponsFuture =
          CouponService().fetchCoupons(); // Atualize para usar CouponService
    });
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

  Future<List<Coupon>> _fetchFilteredCoupons() async {
    final coupons = await _couponsFuture;

    return coupons;
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
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12), // Borda arredondada
            ),
            child: FutureBuilder<List<Coupon>>(
              future: _fetchFilteredCoupons(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox.shrink();
                } else if (snapshot.hasError ||
                    !snapshot.hasData ||
                    snapshot.data!.isEmpty) {
                  return const Text(
                    'Nenhum cupom disponível hoje',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  );
                } else {
                  final todayCoupons = snapshot.data!;
                  if (todayCoupons.isNotEmpty) {
                    return Text(
                      'Cupons válidos do dia:',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    );
                  } else {
                    return const Text(
                      'Nenhum cupom disponível hoje',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    );
                  }
                }
              },
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadCoupons,
              child: FutureBuilder<List<Coupon>>(
                future: _fetchFilteredCoupons(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erro: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                        child: Text('Nenhum cupom encontrado.'));
                  } else {
                    final filteredCoupons = snapshot.data!;

                    return ListView.builder(
                      itemCount: filteredCoupons.length,
                      itemBuilder: (context, index) {
                        final coupon = filteredCoupons[index];
                        return CouponCard(
                          // Atualize para usar CouponCard
                          coupon: coupon,
                          onTap: (url){                            
                            Utils.launch(url);
                          } 
                        );
                      },
                    );
                  }
                },
              ),
            ),
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
    _bannerAdManager.dispose();
    super.dispose();
  }
}
