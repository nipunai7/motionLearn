import 'package:e_shop/PDF/model/supplier.dart';
import 'package:e_shop/PDF/model/customer.dart';

class Invoice {
  final InvoiceInfo info;
  final Supplier supplier;
  final Customer customer;
  final List items;

  const Invoice({
    this.info,
    this.supplier,
    this.customer,
    this.items,
  });
}

class InvoiceInfo {
  final String description;
  final String number;
  final String order;
  final DateTime date;
  final DateTime dueDate;

  const InvoiceInfo({
    this.description,
    this.order,
    this.number,
    this.date,
    this.dueDate,
  });
}

class InvoiceItem {
  final String description;
  final DateTime date;
  final int quantity;
  final double vat;
  final double unitPrice;

  const InvoiceItem({
    this.description,
    this.date,
    this.quantity,
    this.vat,
    this.unitPrice,
  });
}
