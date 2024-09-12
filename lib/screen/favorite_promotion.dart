import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reidaspromocoes/provider/like_provider.dart';
import 'package:reidaspromocoes/widgets/card.dart';
import 'package:reidaspromocoes/widgets/custom_drawer.dart';
import 'package:reidaspromocoes/utils/utils.dart';


class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    super.initState();          
  }  



  @override
  Widget build(BuildContext context) {
    // Acessa as promoções curtidas através do LikeProvider
    final likedPromotions = Provider.of<LikeProvider>(context).likedPromotions;

    return Scaffold(
      appBar: AppBar(
        title:
            Text('Promoçoes Favoritas', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: const CustomDrawer(),
      body: likedPromotions.isEmpty
          ? const Center(
              child: Text(
                'Nenhuma promoção curtida.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: likedPromotions.length,
              itemBuilder: (context, index) {
                final promotion = likedPromotions[index];
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
}
