import 'promo_model.dart';

class GetPromoWithFiltersRes {
  String? status;
  List<Promo>? promos;

  GetPromoWithFiltersRes({
    this.status,
    this.promos,
  });

  GetPromoWithFiltersRes.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    promos = json['promoes'] != null
        ? (json['promoes'] as List).map((i) => Promo.fromJson(i)).toList()
        : null;
  }
}
