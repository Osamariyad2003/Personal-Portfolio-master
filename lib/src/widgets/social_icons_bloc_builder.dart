import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:personal_portfolio/src/core/utils/app_constants.dart';
import 'package:personal_portfolio/src/core/utils/functions/open_url.dart';

import '../cubit/app_cubit.dart';
import '../cubit/app_state.dart';

class SocialIconsBlocBuilder extends StatelessWidget {
  const SocialIconsBlocBuilder({
    super.key,
    this.direction = Axis.horizontal,
  });

  final Axis direction;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      buildWhen: (_, current) => current is ToggleSocialIconIsHoveredBool,
      builder: (context, state) => Wrap(
        direction: direction,
        children: List.generate(
          AppConstants.socialIcons.length,
          (index) => FadeInDown(
            duration: const Duration(milliseconds: 1000),
            delay: Duration(milliseconds: 200 * index),
            child: MouseRegion(
              onEnter: (_) {
                context.read<AppCubit>().setSocialIconHovered(index);
              },
              onExit: (_) {
                context.read<AppCubit>().setSocialIconHovered(index);
              },
              child: IconButton(
                onPressed: () async => await openUrl(
                  AppConstants.socialIcons[index].url,
                  isEmail: AppConstants.socialIcons[index].isEmail,
                ),
                icon: SvgPicture.asset(
                  context.read<AppCubit>().isSocialIconHovered[index]
                      ? AppConstants.socialIcons[index].hoveredIcon
                      : AppConstants.socialIcons[index].icon,
                  height: 32.h,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
