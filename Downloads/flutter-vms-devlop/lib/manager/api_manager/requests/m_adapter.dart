class MAdapter<T> {
  MAdapter({
    required this.status,
    required this.message,
    required this.dataModels,
  });

  late final bool status;
  late final String message;

  T? get dataModel {
    return dataModels.firstOrNull;
  }

  late List<T> dataModels;

  MAdapter.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic> json) fromJsonT,
  ) {
    status = json['status'] == 200;
    message = json['message'] ?? json['error'] ?? '';
    final dataJson = json['data'];
    if (dataJson is Map<String, dynamic>) {
      dataModels = [fromJsonT(dataJson)];
    } else if (dataJson is List<dynamic>) {
      dataModels = List.from(dataJson).map((e) => fromJsonT(e)).toList();
    } else {
      dataModels = [];
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['data'] = dataModel;
    return data;
  }
}
