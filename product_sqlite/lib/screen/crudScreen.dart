import 'package:flutter/material.dart';
import 'package:product_sqlite/database/repository.dart';

class CrudScreenPage extends StatefulWidget {
  const CrudScreenPage({super.key});

  @override
  State<CrudScreenPage> createState() => _CrudScreenPageState();
}

class _CrudScreenPageState extends State<CrudScreenPage> {
  final ProductRepository _productRepository = ProductRepository();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  int? selectedProductID;

  bool isCreateEnabled = true;
  bool isUpdateEnabled = false;
  bool isDeleteEnabled = false;

  List<Map<String, dynamic>> _products = [];

  void clearFields() {
    nameController.clear();
    descriptionController.clear();
    priceController.clear();
    selectedProductID = null;
    setState(() {
      isCreateEnabled = true;
      isUpdateEnabled = false;
      isDeleteEnabled = false;
    });
  }

  void _loadProducts() async {
    final products = await _productRepository.getAllProducts();
    setState(() {
      _products = products;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _showAlertDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(''),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _addProduct() async {
    final name = nameController.text;
    final description = descriptionController.text;
    final priceText = priceController.text;
    final price = double.tryParse(priceText);

    if (name.isNotEmpty && description.isNotEmpty && price != null) {
      await _productRepository.addProduct({
        'name': name,
        'description': description,
        'price': price,
      });
      clearFields();
      _loadProducts();
    } else {
      _showAlertDialog("Please fill in all fields correctly.");
    }
  }

  void _updateProduct() async {
    final name = nameController.text;
    final description = descriptionController.text;
    final priceText = priceController.text;
    final price = double.tryParse(priceText);

    if (name.isNotEmpty && description.isNotEmpty && price != null && selectedProductID != null) {
      await _productRepository.updateProduct({
        'name': name,
        'description': description,
        'price': price,
      }, selectedProductID!);
      clearFields();
      _loadProducts();
    } else {
      _showAlertDialog("Please fill in all fields correctly.");
    }
  }



  void _deleteProduct() async {
    if (selectedProductID != null) {
      bool confirmed = await _showConfirmationDialog('Do you confirm the deletion?');
      if (confirmed) {
        await _productRepository.deleteProduct(selectedProductID!);
        clearFields();
        _loadProducts();
      }
    }
  }

  Future<bool> _showConfirmationDialog(String message) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    ) ?? false;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Soft Drinks",
          style: TextStyle(fontFamily: 'CustomFont', color: Colors.white, fontSize: 30),
        ),
        centerTitle: true,
        backgroundColor: Colors.black87,
        toolbarHeight: 60,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: "Price(Rs)"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: isCreateEnabled ? _addProduct : null,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text("Create", style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: isUpdateEnabled ? _updateProduct : null,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent),
                  child: const Text("Update", style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: isDeleteEnabled ? _deleteProduct : null,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Delete", style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: clearFields,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent),
                  child: const Text("Cancel", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return ListTile(
                    title: Text(product['name']),
                    subtitle: Text('${product['description']} - Rs. ${product['price']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () {
                            setState(() {
                              selectedProductID = product['id'];
                              nameController.text = product['name'];
                              descriptionController.text = product['description'];
                              priceController.text = product['price'].toString();
                              isCreateEnabled = false;
                              isUpdateEnabled = true;
                              isDeleteEnabled = true;
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
