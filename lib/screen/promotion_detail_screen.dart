import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:reidaspromocoes/provider/like_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/promotion_model.dart';
import '../utils/utils.dart';

class PromotionDetailScreen extends StatefulWidget {
  final Promotion promotion;

  const PromotionDetailScreen({super.key, required this.promotion});

  @override
  State<PromotionDetailScreen> createState() => _PromotionDetailScreenState();
}

class _PromotionDetailScreenState extends State<PromotionDetailScreen> {
  int likeCount = 0;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    // Carrega o estado de like do SharedPreferences usando o Provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LikeProvider>(context, listen: false)
          .loadLikes();
    });
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Acesso'),
          content: const Text('Você deseja ir para a promoção?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
                // Navegar para o link da promoção
                Utils.launch(widget.promotion.url);
              },
              child: const Text('Ir para a Promoção'),
            ),
          ],
        );
      },
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

  Future<void> _toggleLike() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (isLiked) {
        likeCount--;
        prefs.remove('like_${widget.promotion.url}');
      } else {
        likeCount++;
        prefs.setBool('like_${widget.promotion.url}', true);
      }
      isLiked = !isLiked;
    });
  }

  String _formatTitle(String title) {
    return title.split(' ').map((word) {
      if (word.length > 1) {
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      }
      return word.toUpperCase();
    }).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final likeProvider = Provider.of<LikeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_formatTitle(widget.promotion.title)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200, // Define uma altura fixa para o container da imagem
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: Colors.grey[400]!, width: 2.0),
              ),
              clipBehavior: Clip.antiAlias,
              child: CachedNetworkImage(
                imageUrl: widget.promotion.imageUrl,
                fit: BoxFit.cover, // Ajusta a imagem para cobrir o container
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => Image.asset(
                  'assets/new_offer.png', // Caminho da imagem padrão
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              _formatTitle(widget.promotion.title),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22.0,
              ),
            ),
            const SizedBox(height: 8.0),
            if (widget.promotion.originalPrice > 0)
              Text(
                'De: R\$${widget.promotion.originalPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            if (widget.promotion.discountedPrice > 0)
              Text(
                'Por: R\$${widget.promotion.discountedPrice.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 24.0,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 16.0),
            Text(
              'Descrição:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              widget.promotion.description.isNotEmpty
                  ? widget.promotion.description
                  : 'Acesse o botão abaixo para conferir a oferta!',
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            if (widget.promotion.couponCode.isNotEmpty)
              Text(
                'Cupom: ${widget.promotion.couponCode}',
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.black87,
                ),
              ),
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
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: ElevatedButton(
                  onPressed: () => _showConfirmationDialog(context),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.yellow,
                    backgroundColor: Colors.black, // Cor do texto
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text('Ir para a Promoção'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
