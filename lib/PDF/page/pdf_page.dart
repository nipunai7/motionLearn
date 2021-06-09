import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:flutter/material.dart';
import 'package:e_shop/PDF/api/pdf_api.dart';
import 'package:e_shop/PDF/api/pdf_invoice_api.dart';
import 'package:e_shop/PDF/main.dart';
import 'package:e_shop/PDF/model/customer.dart';
import 'package:e_shop/PDF/model/invoice.dart';
import 'package:e_shop/PDF/model/supplier.dart';
import 'package:e_shop/PDF/widget/button_widget.dart';
import 'package:e_shop/PDF/widget/title_widget.dart';

class PdfPage extends StatefulWidget {
  @override
  _PdfPageState createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  @override
  Widget build(BuildContext context) => WillPopScope(onWillPop: (){
    Route route = MaterialPageRoute(builder: (c) => StoreHome());
    Navigator.pushReplacement(context, route);
  },
      child:Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Text(MyApp.title),
          centerTitle: true,
          leading: TextButton(
            child: Icon(Icons.arrow_back,color: Colors.white,),
            onPressed: (){
              Route route = MaterialPageRoute(builder: (c) => StoreHome());
              Navigator.pushReplacement(context, route);
            },
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(32),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TitleWidget(
                  icon: Icons.picture_as_pdf,
                  text: 'Generate Invoice',
                ),
                const SizedBox(height: 48),
                ButtonWidget(
                  text: 'Download',
                  onClicked: () async {
                    final date = DateTime.now();
                    final dueDate = date.add(Duration(days: 7));

                    final invoice = Invoice(
                      supplier: Supplier(
                        name: 'Motion Learn Admin',
                        address: '',
                        paymentInfo: '',
                      ),
                      customer: Customer(
                        name: EcommerceApp.sharedPreferences.getString(EcommerceApp.userName),
                        address: '',
                      ),
                      info: InvoiceInfo(
                        date: date,
                        dueDate: dueDate,
                        description: "Order ID: "+EcommerceApp.sharedPreferences.getString(EcommerceApp.latestOrder),
                        number: '${DateTime.now().millisecond}-9999',
                        order: EcommerceApp.sharedPreferences.getString(EcommerceApp.latestOrder),
                      ),
                      items: [
                        InvoiceItem(
                          description: 'HOW TO SHUFFLE DANCE',
                          date: DateTime.now(),
                          quantity: 1,
                          vat: 0.19,
                          unitPrice: 120,
                        ),
                        InvoiceItem(
                          description: 'BASIC DANCE STEPS|TOUCHE',
                          date: DateTime.now(),
                          quantity: 1,
                          vat: 0.19,
                          unitPrice: 100,
                        ),
                      ],
                    );

                    final pdfFile = await PdfInvoiceApi.generate(invoice);

                    PdfApi.openFile(pdfFile);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      );

  tableItems(){
    EcommerceApp.tempPurchase.forEach((element) {
     return InvoiceItem(
        description: element,
        date: DateTime.now(),
        quantity: 1,
        vat: 0.19,
        unitPrice: 5.99,
      );
    });
  }
}
