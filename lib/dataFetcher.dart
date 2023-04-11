import 'package:http/http.dart' as http;
import 'dart:convert';

import 'global.dart';

class DataFetcher {
  //static final databaseUrl = 'https://ninety-days-switch-161-142-153-1.loca.lt';
  static final databaseUrl = 'http://192.168.1.22/PHP';

  static Future<List<Map<String, dynamic>>> fetchData() async {
    final response = await http
        // ignore: unnecessary_brace_in_string_interps
        .get(Uri.parse('${databaseUrl}/fetch_data.php?action=getProducts'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body).cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<List<dynamic>> fetchUsersData() async {
    final response = await http
        .get(Uri.parse('${databaseUrl}/fetch_data.php?action=getUsers'));

    if (response.statusCode == 200) {
      // return jsonDecode(response.body).cast<Map<String, dynamic>>();
      final jsonData = jsonDecode(response.body) as List<dynamic>;
      return jsonData;
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<bool> submitEditProductForm(
      String productId,
      String productName,
      String description,
      double weight,
      double unitPrice,
      int stockQuantity,
      String? filePath) async {
    final body = {
      'id': productId,
      'name': productName,
      'description': description,
      'weight': weight.toString(),
      'unit_price': unitPrice.toString(),
      'quantity': stockQuantity.toString(),
      'imagePath': filePath,
      'action': 'editProduct'
    };

    final headers = {'Content-Type': 'application/json'};

    try {
      var response = await http.post(
        Uri.parse('${databaseUrl}/fetch_data.php'),
        headers: headers,
        body: json.encode(body),
      );
      if (response.statusCode == 200) {
        // Success!
        bool result = response.body == 'true';
        return result;
      } else {
        // Handle the error\
        throw Exception('Failed to add product');
      }
    } catch (e) {
      print('Error submitting form: $e');
      rethrow;
    }
  }

  static Future<bool> submitEditUserForm(
      String userId, String userName, String userEmail) async {
    final body = {
      'id': userId,
      'name': userName,
      'email': userEmail,
      'action': 'editUser'
    };

    final headers = {'Content-Type': 'application/json'};

    try {
      var url = Uri.parse('${databaseUrl}/fetch_data.php');
      var response = await http.post(
        url,
        headers: headers,
        body: json.encode(body),
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        // Success!
        bool result = response.body == 'true';
        return result;
      } else {
        // Handle the error
        throw Exception('Failed to edit user');
      }
    } catch (e) {
      print('Error submitting form: $e');
      rethrow;
    }
  }

  static Future<bool> verifyCredentials(String email, String password) async {
    var url = Uri.parse('${databaseUrl}/fetch_data.php');

    print("receive email and password $email .... $password");

    try {
      var response = await http.post(url as Uri,
          body: {'email': email, 'password': password, 'action': 'signInUser'});

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['success']) {
          // Login succeeded, access the role value
          var role = data['role'];
          GlobalData globalData = GlobalData();
          globalData.userRole = role;
          print('Role: $role');
          return true;
        } else {
          // Login failed
          print('Login failed.');
          return false;
        }
      } else {
        // Handle error
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print("Error comes: $e");
    }
    return false;
  }

  static Future<bool> submitAddProductForm(
      String productName,
      String description,
      double weight,
      double unitPrice,
      int stockQuantity,
      String? filePath) async {
    var url = Uri.parse('${databaseUrl}/fetch_data.php');

    // Send a POST request to your PHP script with the form data
    var response = await http.post(
      url as Uri,
      body: {
        'product_name': productName,
        'description': description,
        'weight': weight.toString(),
        'unit_price': unitPrice.toString(),
        'stock_quantity': stockQuantity.toString(),
        'imagePath': filePath,
        'action': 'AddNewProduct'
      },
    );

    print(response.statusCode);

    // Handle the response from your server here
    if (response.statusCode == 200) {
      // Success!
      bool result = response.body == 'true';
      return result;
    } else {
      // Handle the error\
      throw Exception('Failed to add product');
    }
    return false;
  }
}
