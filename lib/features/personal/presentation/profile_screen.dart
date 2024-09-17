import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_igentech_task/features/personal/domain/app_cubit/app_cubit.dart';
import 'package:flutter_igentech_task/features/personal/domain/app_cubit/app_state.dart';
import 'package:geolocator/geolocator.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, this.selectedPosition});

  final Position? selectedPosition;

  @override
  Widget build(BuildContext context) {
    final AppCubit profileCubit = BlocProvider.of<AppCubit>(context);

    profileCubit.loadProfileData();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: BlocBuilder<AppCubit, AppState>(
        builder: (context, state) {
          if (state is LoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileErrorState) {
            return Center(
              child: Text(
                "Something went wrong! ${state.error}",
              ),
            );
          } else if (state is ProfileLoadedState) {
            if (state.profileData.isNotEmpty) {
              return ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(
                  bottom: 80,
                ),
                itemCount: state.profileData.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      child: Text("${state.profileData[index]['id']}"),
                    ),
                    title: Text("Name : ${state.profileData[index]['name']}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Email : ${state.profileData[index]['email']}"),
                        Text(
                            "Password : ${state.profileData[index]['password']}"),
                        Text("Gender : ${state.profileData[index]['gender']}"),
                        Text("Date : ${state.profileData[index]['date']}"),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
              );
            } else {
              return const Center(
                child: Text("No data available."),
              );
            }
          } else if (state is EmptyProfileState) {
            return const Center(
              child: Text("No profile data found"),
            );
          } else {
            return Container();
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (selectedPosition != null) {
            // final latitude = selectedPosition!.latitude;
            // final longitude = selectedPosition!.longitude;
            // final googleMapsUrl =
            //     'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
            //
            // if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
            //   await launchUrl(Uri.parse(googleMapsUrl));
            // } else {
            //   throw 'Could not open Google Maps';
            // }
            BlocProvider.of<AppCubit>(context).openInGoogleMaps(selectedPosition);
          }else{
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Location not selected.'),
              ),
            );          }
        },
        label: const Text("View On Map"),
        icon: const Icon(Icons.map),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
