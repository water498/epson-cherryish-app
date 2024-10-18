class QnaItemModel {
  final int id;
  final String category;
  final String title;
  final String answer;
  final bool isShow;
  final DateTime created_date;
  final DateTime updated_date;

  QnaItemModel({
    required this.id,
    required this.category,
    required this.title,
    required this.answer,
    required this.isShow,
    required this.created_date,
    required this.updated_date,
  });

  factory QnaItemModel.fromJson(Map<String, dynamic> json) {
    return QnaItemModel(
      id: json['id'],
      category: json['category'],
      title: json['title'],
      answer: json['answer'],
      isShow: json['is_show'],
      created_date: DateTime.parse(json['created_date']),
      updated_date: DateTime.parse(json['updated_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'title': title,
      'answer': answer,
      'is_show': isShow,
      'created_date': created_date,
      'updated_date': updated_date,
    };
  }
}


class QnaResponseModel {
  final List<QnaItemModel> items;
  final int page;
  final int page_size;
  final int total_itemCount;

  QnaResponseModel({
    required this.items,
    required this.page,
    required this.page_size,
    required this.total_itemCount,
  });

  factory QnaResponseModel.fromJson(Map<String, dynamic> json) {
    return QnaResponseModel(
      items: (json['items'] as List).map((item) => QnaItemModel.fromJson(item)).toList(),
      page: json['page'],
      page_size: json['page_size'],
      total_itemCount: json['total_item_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'page': page,
      'page_size': page_size,
      'total_item_count': total_itemCount,
    };
  }
}