import 'package:flutter/material.dart';
import 'api_service.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    List productList = await ApiService.fetchProducts();
    setState(() {
      products = productList;
    });
  }

  void deleteProduct(int id) async {
    bool? confirmDelete = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('ยืนยันการลบ'),
        content: Text('คุณต้องการลบสินค้านี้ใช่หรือไม่?'),
        actions: [
          TextButton(
            child: Text('ยกเลิก'),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: Text('ลบ'),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirmDelete == true) {
      await ApiService.deleteProduct(id);
      fetchProducts();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ลบสินค้าเรียบร้อย')),
      );
    }
  }

  void addProduct() async {
    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController priceController = TextEditingController();

    bool? confirmAdd = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('เพิ่มสินค้าใหม่'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'ชื่อสินค้า'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'รายละเอียด'),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'ราคา'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text('ยกเลิก'),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: Text('เพิ่ม'),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirmAdd == true) {
      await ApiService.addProduct(
        nameController.text,
        descriptionController.text,
        double.tryParse(priceController.text) ?? 0.0,
      );
      fetchProducts();
    }
  }

  void editProduct(int id, String currentName, String currentDescription, double currentPrice) async {
    TextEditingController nameController = TextEditingController(text: currentName);
    TextEditingController descriptionController = TextEditingController(text: currentDescription);
    TextEditingController priceController = TextEditingController(text: currentPrice.toString());

    bool? confirmEdit = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('แก้ไขสินค้า'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'ชื่อสินค้า'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'รายละเอียด'),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'ราคา'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text('ยกเลิก'),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: Text('บันทึก'),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirmEdit == true) {
      await ApiService.updateProduct(
        id,
        nameController.text,
        descriptionController.text,
        double.tryParse(priceController.text) ?? currentPrice,
      );
      fetchProducts(); // โหลดข้อมูลใหม่หลังอัปเดตสินค้า
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product List')),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            color: Colors.green.shade100, // พื้นหลังสีเขียวอ่อน
            elevation: 2,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              title: Text(product['name']),
              subtitle: Text(product['description']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${product['price'].toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.black),
                    onPressed: () => editProduct(
                      product['id'],
                      product['name'],
                      product['description'],
                      product['price'],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => deleteProduct(product['id']),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addProduct,
        child: Icon(Icons.add),
        backgroundColor: Colors.purple.shade300,
      ),
    );
  }
}
