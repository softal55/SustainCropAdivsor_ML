import 'package:crop_recommendation/app/controllers/auth_controller.dart';
import 'package:crop_recommendation/app/views/field/widgets/field_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crop_recommendation/app/utils/app_colors.dart';
import 'package:crop_recommendation/app/controllers/fields_controller.dart';

class FieldsView extends StatelessWidget {
  FieldsView({super.key});

  final FieldController controller = Get.find<FieldController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 50),
              _buildSearchBar(),
              const SizedBox(height: 20),
              Expanded(child: _buildFieldList()),
            ],
          ),
        ),
        floatingActionButton: _buildFloatingButton(),
      ),
    );
  }

  Widget _buildHeader(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'SustainCrop',
          style: TextStyle(
            fontSize: 28,
            color: AppColors.secondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: AppColors.background,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  title: Text("Confirm Logout"),
                  content: Text("Are you sure you want to log out?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.secondary,
                      ),
                      child: Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        AuthController authController =
                            Get.find<AuthController>();
                        Navigator.of(context).pop(); // Close the dialog
                        await authController.logout();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: AppColors.background,
                      ),
                      child: Text("Logout"),
                    ),
                  ],
                );
              },
            );
          },
          icon: Icon(Icons.logout, color: AppColors.secondary, size: 28),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      textCapitalization: TextCapitalization.sentences,
      onChanged: (value) {
        controller.updateSearchQuery(value);
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.grey,
        hintText: 'Search',
        hintStyle: TextStyle(color: AppColors.secondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(Icons.search, color: AppColors.secondary),
      ),
    );
  }

  Widget _buildFieldList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        );
      }

      final fieldsToShow = controller.filteredFields;

      if (fieldsToShow.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.agriculture, color: AppColors.secondary, size: 50),
              const SizedBox(height: 10),
              Text(
                'No fields match your search.',
                style: TextStyle(color: AppColors.secondary, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        itemCount: fieldsToShow.length,
        itemBuilder: (context, index) {
          final field = fieldsToShow[index];
          return FieldListTile(field: field);
        },
      );
    });
  }

  Widget _buildFloatingButton() {
    return FloatingActionButton.extended(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.background,
      onPressed: () => Get.toNamed('/addfield'),
      label: const Text('Add Field', style: TextStyle(fontSize: 16)),
      icon: const Icon(Icons.add),
    );
  }
}
