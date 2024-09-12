import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:reidaspromocoes/admob/intersticial.dart';
import 'package:reidaspromocoes/model/promotion_model.dart';
import 'package:reidaspromocoes/provider/like_provider.dart';
import 'package:reidaspromocoes/screen/promotion_detail_screen.dart';
import 'package:share_plus/share_plus.dart';

class PromotionCard extends StatefulWidget {
  final Promotion promotion;
  final void Function(String url) onTap;

  const PromotionCard({
    super.key,
    required this.promotion,
    required this.onTap,
  });

  @override
  _PromotionCardState createState() => _PromotionCardState();
}

class _PromotionCardState extends State<PromotionCard> {  
  final InterstitialAdManager _interstitialAdManager = InterstitialAdManager();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LikeProvider>(context, listen: false)
          .loadLikes();
    });    
    _interstitialAdManager.initialize();
  }

  void _navigateToDetails(BuildContext context, Promotion promotion) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PromotionDetailScreen(
          promotion: promotion,
        ),
      ),
    );
  }

  void _sharePromotion(BuildContext context) {
    final String appLink =
        'https://play.google.com/store/apps/details?id=com.myapp.reidaspromocoes';
    final String message = 'Confira essa oferta: ${widget.promotion.title}\n'
        'Acesse o link: ${widget.promotion.url}\n\n'
        'Oferta disponível no aplicativo "Rei das Promoções"! Baixe nosso app: $appLink';

    Share.share(message);
  }

  String _formatTitle(String title) {
    if (title.isEmpty) return '';
    final words = title.split(' ');
    return words.map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final likeProvider = Provider.of<LikeProvider>(context);
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
                    imageUrl: widget.promotion.imageUrl,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Image.asset(
                        'assets/new_offer.png'), // Imagem predefinida
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatTitle(
                            widget.promotion.title), // Formata o título
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.black87),
                      ),
                      const SizedBox(height: 4.0),
                      if (widget.promotion.description
                          .isNotEmpty) // Verifica se a descrição não é vazia
                        Text(
                          widget.promotion.description,
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.black54,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      const SizedBox(height: 8.0),
                      if (widget.promotion.originalPrice >
                          0) // Verifica se o preço original não é nulo e maior que zero
                        Text(
                          'De: R\$${widget.promotion.originalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      if (widget.promotion.discountedPrice >
                          0) // Verifica se o preço com desconto não é nulo e maior que zero
                        Text(
                          'Por: R\$${widget.promotion.discountedPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 22.0,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          DateFormat('dd/MM/yyyy')
                                  .format(widget.promotion.dateTime) +
                              ' ' +
                              DateFormat('HH:mm')
                                  .format(widget.promotion.dateTime),
                          style: const TextStyle(
                              fontSize: 12.0, color: Colors.black54),
                        ),
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
                          color: likeProvider.isLiked(widget.promotion.url)
                              ? Colors.red
                              : Colors.grey,
                        ),
                        onPressed: () {
                          likeProvider.toggleLike(widget.promotion.url, widget.promotion);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.share),
                        onPressed: () {
                          _sharePromotion(context);
                        },
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _interstitialAdManager.showAd();
                      _navigateToDetails(context, widget.promotion);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.yellow,
                      backgroundColor: Colors.black, // Cor do texto
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
        .dispose(); // Libera o gerenciador de anúncios intersticiais
    super.dispose();
  }
}
