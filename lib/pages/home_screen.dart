
import 'package:e_commerce_app/components/product_tile.dart';
import 'package:e_commerce_app/models/Products.dart';
import 'package:e_commerce_app/services/remote_services.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Products? listOfProducts;
  bool isLoaded = false;
  String searchTerm = '';
  String selectedCategory = 'All';
  List<String> categories = [
    "smartphones",
    "laptops",
    "fragrances",
    "skincare",
    "groceries",
    "home-decoration",
    "furniture",
    "tops",
    "womens-dresses",
    "womens-shoes",
    "mens-shirts",
    "mens-shoes",
    "mens-watches",
    "womens-watches",
    "womens-bags",
    "womens-jewellery",
    "sunglasses",
    "automotive",
    "motorcycle",
    "lighting"
  ];


  @override
  void initState(){
    super.initState();
    getData();
  }

  getData() async{
    listOfProducts = await RemoteServices.fetchProducts();
    if(listOfProducts != null){
      setState(() {
        isLoaded = true;
      });
    }
  }

   List<Product>? getFilteredProducts() {
    if (searchTerm.isEmpty && selectedCategory == 'All') {
      return listOfProducts?.products;
    } else if (searchTerm.isNotEmpty && selectedCategory == 'All') {
      return listOfProducts?.products
          .where((product) =>
              product.title.toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();
    } else if (searchTerm.isEmpty && selectedCategory != 'All') {
      return listOfProducts?.products
          .where((product) => product.category == selectedCategory)
          .toList();
    } else {
      return listOfProducts?.products
          .where((product) =>
              product.title.toLowerCase().contains(searchTerm.toLowerCase()) &&
              product.category == selectedCategory)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Shop',
              style: TextStyle(
                fontFamily: 'avenir',
                fontSize: 40,
                fontWeight: FontWeight.w900
              )
            )
          ),
      ),
      body: Column(
        
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search Product',
                labelStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  searchTerm = value;
                });
              },
            ),
          ),
           SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Categories:',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                    ),
                    
                    ),
                ),
                ...categories.map((category) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ChoiceChip(
                      shape:const StadiumBorder(),
                      selectedColor: Colors.yellow[700],
                      label: Text(category),
                      selected: selectedCategory == category,
                      onSelected: (selected) {
                        setState(() {
                          selectedCategory = selected ? category : 'All';
                        });
                      },
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: getFilteredProducts()?.length ?? 0,
              itemBuilder: (context, index){
                //var product = listOfProducts?.products[index];
                var product = getFilteredProducts()?[index];
                if(product != null){
                  return ProductTile(product: product);
                }
              }, 
             
            ),
          )
        ]
      )
    );
  }
}