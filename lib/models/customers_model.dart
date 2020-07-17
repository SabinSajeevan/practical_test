class Customer {
  final String customercode;
  final String customername;
  final String customeraddress1;
  final String customeraddress2;
  final String customercity;
  final String creditlimit;

  Customer(
      {this.customercode,
      this.customername,
      this.customeraddress1,
      this.customeraddress2,
      this.customercity,
      this.creditlimit});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
        customercode: json["customercode"],
        customername: json["customername"],
        customeraddress1: json["customeraddress1"],
        customeraddress2: json["customeraddress2"],
        customercity: json["customercity"],
        creditlimit: json["creditlimit"]);
  }
}
