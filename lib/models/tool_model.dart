class Tool{
  String? id;
  String name;
  String brand;
  String voltage;
  String specifications;
  String code;
  bool isAvailable;
  String? borrowedBy;
  DateTime? borrowedDate;

  Tool({
    this.id,
    required this.name,
    required this.brand,
    required this.voltage,
    required this.specifications,
    required this.code,
    this.isAvailable = true,
    this.borrowedBy,
    this.borrowedDate,
  });

  factory Tool.fromMap(Map<String, dynamic> map, String id){
    return Tool(
      id: id,
      name: map['name'] ?? '',
      brand: map['brand'] ?? '',
      voltage: map['voltage'] ?? '',
      specifications: map['specifications'] ?? '',
      code: map['code'] ?? '',
      isAvailable: map['isAvailable'] ?? true,
      borrowedBy: map['borrowedBy'],
      borrowedDate: map['borrowedDate'] != null 
          ? DateTime.parse(map['borrowedDate']) 
          : null,
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'brand': brand,
      'voltage': voltage,
      'specifications': specifications,
      'code': code,
      'isAvailable': isAvailable,
      'borrowedBy': borrowedBy,
      'borrowedDate': borrowedDate?.toIso8601String(),
    };
  }
}