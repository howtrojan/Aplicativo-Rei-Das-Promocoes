import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/promotion_model.dart';

class LikeProvider extends ChangeNotifier {
  Map<String, bool> _likes = {};
  Map<String, Promotion> _likedPromotions = {}; // Armazena as promoções curtidas

  Map<String, bool> get likes => _likes;

  List<Promotion> get likedPromotions => _likedPromotions.values.toList(); // Expor as promoções curtidas

  List<String> get likedUrls => _likedPromotions.keys.toList();

  Future<void> loadLikes() async {
    final prefs = await SharedPreferences.getInstance();

    // Carregar o mapa de curtidas
    final likedPromotionsJson = prefs.getString('likedPromotions') ?? '{}';
    final Map<String, dynamic> likedPromotionsMap = jsonDecode(likedPromotionsJson);

    // Carregar o estado das curtidas
    final likesJson = prefs.getString('likes') ?? '{}';
    final Map<String, dynamic> likesMap = jsonDecode(likesJson);

    _likedPromotions = likedPromotionsMap.map((key, value) => MapEntry(key, Promotion.fromJson(value)));
    _likes = likesMap.map((key, value) => MapEntry(key, value as bool));

    notifyListeners();
  }

  Future<void> saveLikes() async {
    final prefs = await SharedPreferences.getInstance();

    // Salvar o mapa de promoções curtidas
    final likedPromotionsJson = jsonEncode(_likedPromotions.map((key, promotion) => MapEntry(key, promotion.toJson())));
    await prefs.setString('likedPromotions', likedPromotionsJson);

    // Salvar o estado das curtidas
    final likesJson = jsonEncode(_likes);
    await prefs.setString('likes', likesJson);
  }

  void addLikedPromotion(String url, Promotion promotion) {
    _likedPromotions[url] = promotion;
    _likes[url] = true;
    saveLikes(); // Salva as mudanças
    notifyListeners();
  }

  bool isLiked(String promotionUrl) {
    return _likes[promotionUrl] ?? false;
  }

  Future<void> toggleLike(String promotionUrl, Promotion promotion) async {
    final isLiked = _likes[promotionUrl] ?? false;
    _likes[promotionUrl] = !isLiked;

    if (!isLiked) {
      _likedPromotions[promotionUrl] = promotion; // Adiciona a promoção nos favoritos
    } else {
      _likedPromotions.remove(promotionUrl); // Remove a promoção dos favoritos
    }

    saveLikes(); // Salva as mudanças
    notifyListeners();
  }

  Future<void> clearLikes() async {
    final prefs = await SharedPreferences.getInstance();
    _likes.clear();
    _likedPromotions.clear(); // Limpa também a lista de promoções curtidas
    await prefs.remove('likedPromotions');
    await prefs.remove('likes');
    notifyListeners();
  }
}
