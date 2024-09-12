class Coupon {
  final String imageUrl;
  final String title;
  final String description;
  final String discount; // Desconto aplicado
  final String expiration; // Data de expiração do cupom
  final String url; // Link para o cupom
  final DateTime dateTime; // Data e hora da promoção
  final String couponCode; // Código do cupom

  Coupon({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.discount,
    required this.expiration,
    required this.url,
    required this.dateTime,
    this.couponCode = '', // Valor padrão vazio
  });

  // Método para converter JSON para um objeto Coupon
  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      imageUrl: json['image'] ?? '', // Campo da imagem
      title: json['title'] ?? '', // Campo do título
      description: json['description'] ?? '', // Campo da descrição
      discount: json['discount'] ?? '', // Campo do desconto
      expiration: json['expiration'] ?? '', // Campo da expiração
      url: json['url'] ?? '', // Campo do URL
      dateTime: _parseDateTime(json['expiration'] ?? DateTime.now().toIso8601String()), // Data e hora da expiração
      couponCode: json['couponCode'] ?? '', // Valor padrão vazio
    );
  }

  // Método para converter um objeto Coupon para JSON
  Map<String, dynamic> toJson() {
    return {
      'image': imageUrl,
      'title': title,
      'description': description,
      'discount': discount,
      'expiration': expiration,
      'url': url,
      'dateTime': dateTime.toIso8601String(), // Converter DateTime para string
      'couponCode': couponCode, // Adicionar o código do cupom ao JSON
    };
  }

  // Método auxiliar para converter a data de expiração para DateTime
  static DateTime _parseDateTime(String expiration) {
    try {
      // Exemplo de parsing: supondo que 'expiration' é uma string representando dias
      final daysUntilExpiration = int.tryParse(expiration.split(' ')[2]) ?? 0;
      return DateTime.now().add(Duration(days: daysUntilExpiration));
    } catch (e) {
      print('Erro ao converter data: $e');
      return DateTime.now(); // Valor padrão em caso de erro
    }
  }
}
