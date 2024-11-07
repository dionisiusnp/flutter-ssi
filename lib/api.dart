import 'package:basic_mobile/model.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';

class Api {
  final String baseUrl = "http://127.0.0.1:8002";
  Client client = Client();

  Future<List<Blog>> getBlogs() async {
    final response = await client.get(Uri.parse("$baseUrl/api/blog"));
    // print("Response body: ${response.body}");
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      List<dynamic> data = jsonResponse['data'];

      List<Blog> blogs = data.map<Blog>((item) => Blog.fromJson(item)).toList();

      return blogs;
    } else {
      return [];
    }
  }

  Future<bool> createBlog(Blog data) async {
    // print("Creating blog with data: ${blogToJson(data)}");
    
    final response = await client.post(
      Uri.parse("$baseUrl/api/blog"),
      headers: {"content-type": "application/json"},
      body: blogToJson(data),
    );

    // print("Response status: ${response.statusCode}");
    // print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateBlog(Blog data) async {
    final response = await client.put(
      Uri.parse("$baseUrl/api/blog/${data.id}"),
      headers: {"content-type": "application/json"},
      body: blogToJson(data),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteBlog(int id) async {
    final response = await client.delete(
      Uri.parse("$baseUrl/api/blog/$id"),
      headers: {"content-type": "application/json"},
    );
    if (response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }
}
