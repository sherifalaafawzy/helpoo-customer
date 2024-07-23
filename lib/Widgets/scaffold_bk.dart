import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:helpooappclient/Configurations/Constants/assets_images.dart';
import 'package:helpooappclient/Configurations/extensions/build_context_extension.dart';
import '../Configurations/extensions/size_extension.dart';
import '../Style/theme/text_styles.dart';

class ScaffoldWithBackground extends StatelessWidget {
  final Widget body;
  final AlignmentGeometry alignment;
  final double? horizontalPadding;
  final double? verticalPadding;
  final bool withBack;
  final bool extendBodyBehindAppBar;
  final Widget? bottomNavBar;
  final PreferredSizeWidget? appBar;
  final String? appBarTitle;
  final Function()? onBackTab;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  const ScaffoldWithBackground({
    Key? key,
    required this.body,
    this.alignment = AlignmentDirectional.center,
    this.horizontalPadding,
    this.verticalPadding,
    this.withBack = true,
    this.extendBodyBehindAppBar = false,
    this.bottomNavBar,
    this.appBar,
    this.appBarTitle,
    this.onBackTab,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                AssetsImages.backgroundLight,
              ),
              fit: BoxFit.fill)),
      child: Scaffold(
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        extendBody: false,
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.rSp),
          child: appBar ??
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                title: Text(
                  appBarTitle ?? '',
                  style: TextStyles.semiBold16,
                ),
                leading: withBack
                    ? IconButton(
                        onPressed: onBackTab ??
                            () {
                              context.pop;
                            },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding ?? 16.rw,
            vertical: verticalPadding ?? 0.0,
          ),
          child: body,
        ),
        bottomNavigationBar: bottomNavBar,
        floatingActionButton: floatingActionButton,
        floatingActionButtonLocation: floatingActionButtonLocation,
      ),
    );
  }
}
