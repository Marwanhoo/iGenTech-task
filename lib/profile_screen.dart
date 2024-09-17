import 'package:flutter/material.dart';
import 'package:flutter_igentech_task/core/utils/app_helper.dart';
import 'package:flutter_igentech_task/sqldb.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  SqlDb sqlDb = SqlDb();

  Future<List<Map>> readData() async {
    List<Map> response = await sqlDb.read("notes");
    return response;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: FutureBuilder(
        future: readData(),
        builder: (BuildContext context, AsyncSnapshot<List<Map>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Something went wrong! ${snapshot.error} ${snapshot.hasError}",
              ),
            );
          }
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.separated(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(
                bottom: 80,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    child: Text("${snapshot.data?[index]['id']}"),
                  ),
                  title: Text("Name : ${snapshot.data?[index]['name']}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Email : ${snapshot.data?[index]['email']}"),
                      Text("Password : ${snapshot.data?[index]['password']}"),
                      Text("Gender : ${snapshot.data?[index]['gender']}"),
                      Text("Date : ${snapshot.data?[index]['date']}"),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            );
          } else if (snapshot.data!.isEmpty) {
            return const Center(
                child: FlutterLogo(
                  size: 100,
                ));
          } else {
            return Container();
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){},
        label: const Text("View On Map"),
        icon: const Icon(Icons.map),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
