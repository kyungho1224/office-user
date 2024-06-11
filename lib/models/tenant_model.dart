class Tenant {
  final int id;
  final String name, companyNumber;
  final DateTime createdAt, updatedAt;

  Tenant.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        companyNumber = json['company_number'],
        createdAt = DateTime.parse(json['created_at']),
        updatedAt = DateTime.parse(json['updated_at']);
}

class TenantList {
  final int count;
  final List<Tenant> tenantList;

  TenantList({required this.count, required this.tenantList});

  factory TenantList.fromJson(Map<String, dynamic> json) {
    final List<dynamic> infoList = json['info_list'];
    final List<Tenant> tenantList =
        infoList.map((item) => Tenant.fromJson(item)).toList();
    return TenantList(count: json['count'], tenantList: tenantList);
  }
}
