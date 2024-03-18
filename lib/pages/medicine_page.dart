import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mcproj/Providers/product.dart';
import 'package:mcproj/pages/med_details.dart';
import 'package:shimmer/shimmer.dart';

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate loading delay
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        isLoading = false; // Set isLoading to false after products are loaded
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: isLoading ? _buildShimmerEffect() : _buildProductList(),
    );
  }

  Widget _buildShimmerEffect() {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 30,
            ),
            title: Container(
              width: double.infinity,
              height: 20.0,
              color: Colors.white,
            ),
            subtitle: Container(
              width: double.infinity,
              height: 20.0,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductList() {
    // Replace this with your actual product list widget
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.all(20),
        child: Container(
          margin: EdgeInsets.all(10),
          height: 90,
          width: MediaQuery.of(context).size.width,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MedicineCard(medicine: med[index]),
                ),
              );
            },
            child: Container(
                child: Row(
              children: [
                Image.network(
                  med[index].imageUrl,
                  height: 90,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(med[index].medName),
                      Text(
                        med[index].desc,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }
}
