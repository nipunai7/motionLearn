// trending() {
//   return Container(
//       height: MediaQuery.of(context).size.height / 5,
//       child: StreamBuilder(
//         stream: Firestore.instance
//             .collection("Items")
//             .orderBy("purchaseCount", descending: true)
//             .limit(5)
//             .snapshots(),
//         builder: (context, snapshot12) {
//           if (!snapshot12.hasData) {
//             print("No data");
//             return CircularProgressIndicator();
//           }
//           return ListView(
//             children: snapshot12.data.documents.map<Widget>((document) {
//               // print("Name: " + document['title']);
//               return InkWell(
//                 child: Container(
//                   // decoration: BoxDecoration(
//                   //   border: Border.all(color: Colors.deepPurple)
//                   // ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Container(width:200.0,child: Text(document['title'],style: TextStyle(fontSize: 18.0),)),
//                         Text(document['purchaseCount'].toString()),
//                         Text((document['purchaseCount']*document['price']).toString()),
//                       ],
//                     )
//                 ),
//               );
//             }).toList(),
//           );
//         },
//       )
//   );
// }
