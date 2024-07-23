// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class FeesOtherServiceResponseModel {
  num originalFees;
  num fees;
  num discountPercent;
  FeesOtherServiceResponseModel({
    required this.originalFees,
    required this.fees,
    required this.discountPercent,
  });

  FeesOtherServiceResponseModel copyWith({
    num? originalFees,
    num? fees,
    num? discountPercent,
  }) {
    return FeesOtherServiceResponseModel(
      originalFees: originalFees ?? this.originalFees,
      fees: fees ?? this.fees,
      discountPercent: discountPercent ?? this.discountPercent,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'originalFees': originalFees,
      'fees': fees,
      'discountPercent': discountPercent,
    };
  }

  factory FeesOtherServiceResponseModel.fromMap(Map<String, dynamic> map) {
    return FeesOtherServiceResponseModel(
      originalFees: map['originalFees'] as num,
      fees: map['fees'] as num,
      discountPercent: map['discountPercent'] as num,
    );
  }

  String toJson() => json.encode(toMap());

  factory FeesOtherServiceResponseModel.fromJson(String source) =>
      FeesOtherServiceResponseModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'FeesOtherServiceResponseModel(originalFees: $originalFees, fees: $fees, discountPercent: $discountPercent)';

  @override
  bool operator ==(covariant FeesOtherServiceResponseModel other) {
    if (identical(this, other)) return true;

    return other.originalFees == originalFees &&
        other.fees == fees &&
        other.discountPercent == discountPercent;
  }

  @override
  int get hashCode =>
      originalFees.hashCode ^ fees.hashCode ^ discountPercent.hashCode;
}
