import 'dart:convert';

import 'package:helpooappclient/Models/companies/corporate_company_model.dart';
import 'package:helpooappclient/Models/packages/deal.dart';

class PackageByCorporateResponse {
  final CorporateCompany corporateCompany;
  final List<Deal> deals;
  PackageByCorporateResponse({
    required this.corporateCompany,
    required this.deals,
  });

  factory PackageByCorporateResponse.fromMap(Map<String, dynamic> map) {
    return PackageByCorporateResponse(
      corporateCompany: CorporateCompany.fromJson(map['corporateCompany']),
      deals: List<Deal>.from(map['deals']?.map((x) => Deal.fromMap(x))),
    );
  }

  factory PackageByCorporateResponse.fromJson(String source) =>
      PackageByCorporateResponse.fromMap(json.decode(source));
}
