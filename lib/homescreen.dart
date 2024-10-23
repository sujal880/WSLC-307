import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wslc_302/models/usermodel.dart';
import 'package:http/http.dart' as http;
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    getData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HomeScreen"),
        centerTitle: true,
      ),
      body: FutureBuilder(future: getData(), builder: (context,data){
        if(data.connectionState==ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(),);
        }
        else if(data.hasError){
          return Center(child: Text(data.hasError.toString()),);
        }
        else if(data.data==null){
          return Center(child: Text("No Data Found"),);
        }
        return ListView.builder(itemBuilder: (context,index){
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(data.data!.data![index].avatar.toString()),
            ),
            title: Text(data.data!.data![index].email.toString()),
            subtitle: Text(data.data!.data![index].firstName.toString()),
          );
        },itemCount: data.data!.data!.length,);
      }),// Future Data Source
    );
  }
  Future<UserModel>getData()async{
    final response=await http.get(Uri.parse("https://reqres.in/api/users?page=2"));
    if(response.statusCode==200){
      Map<String,dynamic>responsedata=jsonDecode(response.body);
      UserModel newuser=UserModel.fromJson(responsedata);
      return newuser;
    }
    else{
      return UserModel();
    }
  }
}
