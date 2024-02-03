import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mmm/features/shop_images/shop_images_bloc.dart';
import 'package:mmm/utils/app_colors.dart';
import 'package:mmm/utils/app_strings.dart';

class ShopImagesScreen extends StatefulWidget {
  final List<String> images;

  const ShopImagesScreen({Key? key, required this.images}) : super(key: key);

  @override
  State<ShopImagesScreen> createState() => _ShopImagesScreenState();
}

class _ShopImagesScreenState extends State<ShopImagesScreen> {
  // region Bloc
  late ShopImagesBloc shopImagesBloc;

  // endregion

  // region Init
  @override
  void initState() {
    shopImagesBloc = ShopImagesBloc(context, widget.images);
    shopImagesBloc.init();
    super.initState();
  }

  // endregion

  // region Dispose
  @override
  void dispose() {
    shopImagesBloc.dispose();
    super.dispose();
  }

  // endregion

  // region Build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
          foregroundColor: Colors.white,
          actions: [
            StreamBuilder<bool>(
                stream: shopImagesBloc.phoneCtrl.stream,
                initialData: true,
                builder: (context, snapshot) {
                  if (snapshot.data!) return const SizedBox();
                  return CupertinoButton(child: const Icon(Icons.call, color: Colors.white), onPressed: () => shopImagesBloc.shopPhonePopup());
                })
          ],
          backgroundColor: AppColors.background,
          elevation: 0,
          title: Text(AppStrings.shopImages)),
      body: body(),
    );
  }

// endregion

  // region Body
  Widget body() {
    return Column(
      children: [
        Expanded(
          child: InteractiveViewer(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: PageView.builder(
                    controller: shopImagesBloc.pageController,
                    itemBuilder: (context, index) {
                      return CachedNetworkImage(imageUrl: shopImagesBloc.images[index]);
                    },
                    onPageChanged: (int page) => shopImagesBloc.onPageChange(page),
                    itemCount: shopImagesBloc.images.length)),
          ),
        ),
        SizedBox(
          height: 80,
          child: StreamBuilder<int>(
              stream: shopImagesBloc.shopImageCtrl.stream,
              initialData: 0,
              builder: (context, snapshot) {
                return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Container(
                          margin: const EdgeInsets.only(right: 5),
                          child: Icon(
                            Icons.circle,
                            size: 15,
                            color: snapshot.data! == index ? AppColors.dropDown : Colors.black26,
                          ));
                    },
                    itemCount: shopImagesBloc.images.length);
              }),
        )
      ],
    );
  }
// endregion
}
