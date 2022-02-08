import 'package:flutter/material.dart';
import 'package:my_shop/providers/product.dart';
import 'package:my_shop/providers/products_provider.dart';
import 'package:provider/provider.dart';

class EditProductsScreen extends StatefulWidget {
  const EditProductsScreen({Key? key}) : super(key: key);

  static const routeName = '/edit-product';

  @override
  _EditProductsScreenState createState() => _EditProductsScreenState();
}

class _EditProductsScreenState extends State<EditProductsScreen> {
  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  Product _editedProduct = Product(id: '', title: '', price: 0, desc: '', imageUrl: '');
  var _isInit = true;
  var _isLoading = false;
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    // _imageUrlFocusNode.removeListener(_updateImageUrl);
    super.dispose();

  }


  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
     super.initState();
  }

  @override
  void didChangeDependencies(){
    if(_isInit){
      final productId = ModalRoute.of(context)?.settings.arguments;
      if(productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId as String);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.desc,
          'price': _editedProduct.price.toString(),
          'imageUrl': ''
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

   void _updateImageUrl(){
    if(!_imageUrlFocusNode.hasFocus){
      setState((){

      });
    }
   }

   void _saveForm() async {
     bool isValid = _form.currentState?.validate() as bool;
     if (!isValid) {
       return;
     }
     _form.currentState?.save();
     setState(() {
       _isLoading = true;
     });
     if (_editedProduct.id.isNotEmpty) {
       Provider.of<Products>(context, listen: false).updateProduct(
           _editedProduct.id, _editedProduct);
       setState(() {
         _isLoading = false;
       });
       Navigator.of(context).pop();
     } else {
       try{
         await Provider.of<Products>(context, listen: false)
             .addProduct(_editedProduct);
       }catch(error){
         showDialog<Null>(
             context: context,
             builder: (ctx) => AlertDialog(
               title: Text('An error occurred!'),
               content: Text('Something went wrong.'),
               actions: [
                 FlatButton(onPressed: (){
                   Navigator.of(ctx).pop();
                 },
                     child: Text('Okay')
                 )
               ],
             )
         );
       }finally{
         setState(() {
           _isLoading = false;
         });
         Navigator.of(context).pop();
       }

     }
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
              onPressed: () => _saveForm(),
              icon: Icon(Icons.save))
        ],
      ),
      body: _isLoading ?
          Center(
              child: CircularProgressIndicator(),
          )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
          children: <Widget>[
            TextFormField(
              initialValue: _initValues['title'],
              decoration: InputDecoration(
                labelText: 'Title'
              ),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_){
                FocusScope.of(context).requestFocus(_priceFocusNode);
              },
              validator: (value){
                if((value as String).isEmpty){
                  return 'Please provide a value';
                }
                return null;
              },
              onSaved: (value){
                _editedProduct = Product(
                    title: value as String,
                    price: _editedProduct.price,
                    id: _editedProduct.id,
                    imageUrl: _editedProduct.imageUrl,
                    desc: _editedProduct.desc,
                    isFavourite: _editedProduct.isFavourite
                );
              },
            ),
            TextFormField(
              initialValue: _initValues['price'],

              decoration: InputDecoration(
                  labelText: 'Price'
              ),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.number,
              focusNode: _priceFocusNode,
              onFieldSubmitted: (_){
                FocusScope.of(context).requestFocus(_descFocusNode);
                },
              validator: (value){
                if((value as String).isEmpty){
                  return 'Please provide a price';
                }
                if(double.tryParse(value) == null){
                  return 'Please provide a valid number';
                }
                if(double.parse(value) <= 0){
                  return 'Please provide a number greater than zero';
                }
                return null;
              },
              onSaved: (value){
                _editedProduct = Product(
                    title: _editedProduct.title,
                    price: double.parse(value!),
                    id: _editedProduct.id,
                    imageUrl: _editedProduct.imageUrl,
                    desc: _editedProduct.desc,
                    isFavourite: _editedProduct.isFavourite
                );
              },
            ),
            TextFormField(
              initialValue: _initValues['description'],
              decoration: InputDecoration(
                  labelText: 'Description'
              ),
              maxLines: 3,
              keyboardType: TextInputType.multiline,
              focusNode: _descFocusNode,
              validator: (value){
                if((value as String).isEmpty){
                  return 'Please provide a value';
                }
                return null;
              },
              onSaved: (value){
                _editedProduct = Product(
                    title: _editedProduct.title,
                    price: _editedProduct.price,
                    id: _editedProduct.id,
                    imageUrl: _editedProduct.imageUrl,
                    desc: value as String,
                    isFavourite: _editedProduct.isFavourite
                );
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
              Container(
                width: 100,
                height: 100,
                margin: EdgeInsets.only(top: 8, right: 10),
                decoration: BoxDecoration(
                  border: Border.all(width: 1),
                  color: Colors.grey,
                ),
                child: _imageUrlController.text.isEmpty ? Text(
                    'Enter a URL'
                ) :
                FittedBox(child: Image.network(
                    _imageUrlController.text,
                  fit: BoxFit.cover,
                )),
              ),
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(labelText: 'Image URL'),
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.done,
                  controller: _imageUrlController,
                  focusNode: _imageUrlFocusNode,
                  validator: (value){
                    if((value as String).isEmpty){
                      return 'Please provide an image URL.';
                    }
                    if(!value.startsWith('http')  && !value.startsWith('https')){
                      return 'Please enter a valid URL';
                    }
                    // if(!value.endsWith('.png') && !value.endsWith('.jpg') && !value.endsWith('.jpeg')){
                    //   return 'Please enter a valid image URL';
                    // }
                    return null;
                  },
                  onFieldSubmitted: (_) => _saveForm(),
                  onSaved: (value){
                    _editedProduct = Product(
                        title: _editedProduct.title,
                        price: _editedProduct.price,
                        id: _editedProduct.id,
                        imageUrl: value as String,
                        desc: _editedProduct.desc,
                        isFavourite: _editedProduct.isFavourite
                    );
                  },
                ),
              )
            ])

          ],
        ),),
      )
    );
  }
}
