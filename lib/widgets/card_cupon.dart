import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:reidaspromocoes/admob/intersticial.dart';
import 'package:reidaspromocoes/model/cupons_model.dart';
import 'package:reidaspromocoes/screen/cupons_detail_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CouponCard extends StatefulWidget {
  final Coupon coupon;
  final void Function(String url) onTap;

  const CouponCard({
    super.key,
    required this.coupon,
    required this.onTap,
  });

  @override
  _CouponCardState createState() => _CouponCardState();
}

class _CouponCardState extends State<CouponCard> {
  bool isLiked = false;
  final InterstitialAdManager _interstitialAdManager = InterstitialAdManager();  

  @override
  void initState() {
    super.initState();
    _loadLikeStatus();    
  }

  Future<void> _loadLikeStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isLiked = prefs.getBool('like_${widget.coupon.url}') ?? false;
    });
  }

  Future<void> _toggleLike() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (isLiked) {
        prefs.remove('like_${widget.coupon.url}');
      } else {
        prefs.setBool('like_${widget.coupon.url}', true);
      }
      isLiked = !isLiked;
    });
  }

  void _navigateToDetails(BuildContext context, Coupon coupon) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CouponDetailScreen(
          coupon: coupon,
        ),
      ),
    );
  }

  void _shareCoupon(BuildContext context) {
    final String appLink =
        'https://play.google.com/store/apps/details?id=com.myapp.reidaspromocoes';
    final String message = 'Confira esse cupom: ${widget.coupon.title}\n'
        'Código: ${widget.coupon.couponCode}\n'
        'Acesse o link: ${widget.coupon.url}\n\n'
        'Cupom disponível no aplicativo "Rei das Promoções"! Baixe nosso app: $appLink';

    Share.share(message);
  }
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: CachedNetworkImage(
                    imageUrl: widget.coupon.imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        Image.asset('assets/splash_icon.png'), // Imagem padrão
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.coupon.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        widget.coupon.description,
                        style: const TextStyle(fontSize: 14.0),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Criado em: ${DateFormat('dd/MM/yyyy').format(widget.coupon.dateTime)}',
                        style: const TextStyle(
                            fontSize: 12.0, color: Colors.black54),
                      ),
                      Text(
                        'Validade: ${(widget.coupon.expiration)}',
                        style:
                            const TextStyle(fontSize: 12.0, color: Colors.blue),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Código: ${widget.coupon.couponCode}',
                        style: const TextStyle(
                            fontSize: 14.0, color: Colors.blueAccent),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.favorite,
                          color: isLiked ? Colors.red : Colors.grey,
                        ),
                        onPressed: _toggleLike,
                      ),
                      IconButton(
                        icon: const Icon(Icons.share),
                        onPressed: () {
                          _shareCoupon(context);
                        },
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _interstitialAdManager.showAd();
                      _navigateToDetails(context, widget.coupon);                      
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.yellow,
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text('Ver detalhes'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _interstitialAdManager
        .dispose(); 
    super.dispose();
  }
}
