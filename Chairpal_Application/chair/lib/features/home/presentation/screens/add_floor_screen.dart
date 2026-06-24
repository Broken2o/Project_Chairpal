import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/app_styles.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import '../../domain/entities/place.dart';
import '../cubit/add_floor_cubit/add_floor_cubit.dart';
import '../cubit/add_floor_cubit/add_floor_state.dart';
import '../cubit/floor_list_cubit/floor_list_cubit.dart';
import '../../../../l10n/l10n.dart';
import 'package:chair_pal/core/widgets/custom_back_button.dart';

class AddFloorScreen extends StatefulWidget {
  final Place building;

  const AddFloorScreen({super.key, required this.building});

  @override
  State<AddFloorScreen> createState() => _AddFloorScreenState();
}

class _AddFloorScreenState extends State<AddFloorScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _levelController = TextEditingController();

  void _submit(BuildContext innerContext) {
    if (_formKey.currentState!.validate()) {
      innerContext.read<AddFloorCubit>().createFloor(
        buildingId: int.parse(widget.building.id),
        name: _nameController.text.trim(),
        level: int.tryParse(_levelController.text.trim()),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _levelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context)!;
    return BlocProvider(
      create: (context) => sl<AddFloorCubit>(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leadingWidth: 100.w,
          leading: const CustomBackButton(),
          title: Text(
            l10n.addNewFloor,
            style: AppStyles.h3PrimaryDark.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        body: BlocConsumer<AddFloorCubit, AddFloorState>(
          listener: (context, state) {
            if (state is AddFloorSuccess) {
              CustomSnackBar.showSuccess(
                context: context,
                message: l10n.floorAddedSuccessfully,
              );
              // Refresh floor list
              context.read<FloorListCubit>().fetchFloors(int.parse(widget.building.id));
              Navigator.pop(context);
            } else if (state is AddFloorError) {
              CustomSnackBar.showError(
                context: context,
                message: state.message,
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(l10n.floorName, style: AppStyles.labelPrimaryDark),
                    SizedBox(height: 8.h),
                    CustomTextField(
                      controller: _nameController,
                      hintText: l10n.floorNameHint,
                      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                    ),
                    SizedBox(height: 16.h),

                    // Level
                    Text(l10n.floorLevel, style: AppStyles.labelPrimaryDark),
                    SizedBox(height: 8.h),
                    CustomTextField(
                      controller: _levelController,
                      hintText: l10n.floorLevelHint,
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16.h),

                    SizedBox(height: 40.h),

                    // Submit Button
                    CustomButton(
                      text: l10n.addFloor,
                      onPressed: () => _submit(context),
                      isLoading: state is AddFloorLoading,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
