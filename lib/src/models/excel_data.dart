class ExcelData {
  String id, name, number;

  ExcelData({this.id, this.name, this.number});

  String toParam() => "?id=$id&name=$name&number=$number";
}
