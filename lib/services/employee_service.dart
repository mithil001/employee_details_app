// lib/services/employee_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/employee.dart';

class EmployeeService {
  static const String _url = 'https://aamras.com/dummy/EmployeeDetails.json';

  Future<List<Employee>> fetchEmployees() async {
    final response = await http.get(Uri.parse(_url));

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final jsonList = decoded['employees'] as List<dynamic>;
      return jsonList
          .map((e) => Employee.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to load employees. Status: ${response.statusCode}');
    }
  }
}
