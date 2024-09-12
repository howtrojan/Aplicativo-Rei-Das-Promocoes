class Promotion {
  final String imageUrl;
  final String title;
  final String description;
  final double originalPrice;
  final double discountedPrice;
  final String url; // Link para a promoção
  final DateTime dateTime; // Data e hora da promoção
  final String couponCode; // Código do cupom de desconto

  Promotion({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.originalPrice,
    required this.discountedPrice,
    required this.url,
    required this.dateTime,
    this.couponCode = '', // Valor padrão vazio para cupom de desconto
  });

  // Método para converter JSON para um objeto Promotion
  factory Promotion.fromJson(Map<String, dynamic> json) {
    return Promotion(
      imageUrl: json['imageUrl'] ?? '', // Valor padrão vazio se nulo
      title: json['title'] ?? '', // Valor padrão vazio se nulo
      description: json['description'] ?? '', // Valor padrão vazio se nulo
      originalPrice: _parsePrice(json['originalPrice']),
      discountedPrice: _parsePrice(json['discountedPrice']),
      url: json['url'] ?? '', // Valor padrão vazio se nulo
      dateTime: DateTime.parse(json['dateTime'] ?? DateTime.now().toIso8601String()), // Valor padrão se nulo
      couponCode: json['couponCode'] ?? '', // Valor padrão vazio se nulo
    );
  }

  // Método para converter um objeto Promotion para JSON
  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'title': title,
      'description': description,
      'originalPrice': originalPrice,
      'discountedPrice': discountedPrice,
      'url': url,
      'dateTime': dateTime.toIso8601String(), // Converter DateTime para string
      'couponCode': couponCode, // Adicionar o código do cupom ao JSON
    };
  }

  // Método auxiliar para converter preços de forma segura
  static double _parsePrice(dynamic price) {
  if (price == null) return 0.0;

  try {
    // Se price já for um número, retorne-o diretamente
    if (price is double) return price;
    if (price is int) return price.toDouble();

    // Se price for uma string, remova caracteres não numéricos e tente converter
    if (price is String) {
      final sanitizedPriceStr = price.replaceAll(RegExp(r'[^\d.]'), '');
      return double.tryParse(sanitizedPriceStr) ?? 0.0;
    }

    // Caso contrário, trate como inválido e retorne 0.0
    return 0.0;
  } catch (e) {
    print('Erro ao converter preço: $e');
    return 0.0; // Valor padrão em caso de erro
  }
}

}
