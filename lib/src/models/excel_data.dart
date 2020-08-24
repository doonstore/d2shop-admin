class ExcelData {
  static const String URL =
      "https://script.google.com/macros/s/AKfycbzkW52CgICPx19iWkWh7pXdcBabXsfhjKv4Jg3H7EFWeMuXQ1Zs/exec";
  final String name,
      number,
      address,
      products,
      noOfProducts,
      orderDate,
      deliveryDate,
      price;

  const ExcelData(
      {this.name,
      this.number,
      this.address,
      this.noOfProducts,
      this.orderDate,
      this.deliveryDate,
      this.products,
      this.price});

  String toParam() =>
      "?name=$name&number=$number&address=$address&noOfProducts=$noOfProducts&orderDate=$orderDate&deliveryDate=$deliveryDate&price=$price&products=$products";
}
