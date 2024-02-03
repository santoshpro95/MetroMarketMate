import 'package:flutter/material.dart';
import 'package:mmm/features/shops/bloc/shops_bloc.dart';
import 'package:mmm/utils/app_colors.dart';
import 'package:mmm/utils/app_constants.dart';

// region header
Widget header(ShopsBloc shopsBloc) {
  return Row(children: [toggleView(shopsBloc), const Expanded(child: SizedBox()), citySelection(shopsBloc)]);
}
// endregion

// region toggleView
Widget toggleView(ShopsBloc shopsBloc) {
  return ValueListenableBuilder<bool>(
      valueListenable: shopsBloc.toggleViewCtrl,
      builder: (context, value, _) {
        return GestureDetector(
          onTap: () => shopsBloc.toggleViewCtrl.value = !value,
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: AppColors.primary),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: value ? AppColors.background : AppColors.primary),
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      child: Text(
                        'Map',
                        style: TextStyle(fontWeight: FontWeight.bold, color: value ? Colors.white : AppColors.background),
                      ),
                    )),
                  ),
                  const SizedBox(width: 5),
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: value ? AppColors.primary : AppColors.background),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      child: Center(
                          child: Text(
                        'List',
                        style: TextStyle(fontWeight: FontWeight.bold, color: value ? AppColors.background : Colors.white),
                      )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
}

// endregion

// region City Selection
Widget citySelection(ShopsBloc shopsBloc) {
  return ValueListenableBuilder<String>(
      valueListenable: shopsBloc.citySelectionCtrl,
      builder: (context, snapshot, _) {
        return DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            borderRadius: BorderRadius.circular(30),
            value: snapshot,
            dropdownColor: AppColors.background,
            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
            items: AppConstants.cities.map((String city) {
              return DropdownMenuItem(
                  value: city, child: Text(city, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500)));
            }).toList(),
            onChanged: (String? newValue) => shopsBloc.onChangeCity(newValue!),
          ),
        );
      });
}

// endregion
