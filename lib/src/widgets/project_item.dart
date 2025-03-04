import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:personal_portfolio/src/core/helpers/extensions.dart';
import 'package:personal_portfolio/src/core/locale/lang_keys.dart';
import 'package:personal_portfolio/src/core/locale/logic/locale_cubit.dart';
import 'package:personal_portfolio/src/core/themes/app_colors.dart';
import 'package:personal_portfolio/src/core/themes/app_text_styles.dart';
import 'package:personal_portfolio/src/core/utils/app_utils.dart';
import 'package:personal_portfolio/src/core/utils/functions/open_url.dart';
import 'package:personal_portfolio/src/core/widgets/main_button.dart';
import 'package:personal_portfolio/src/core/widgets/my_sized_box.dart';
import 'package:personal_portfolio/src/models/project.dart';

import '../cubit/app_cubit.dart';
import '../cubit/app_state.dart';

class ProjectItem extends StatelessWidget {
  const ProjectItem({
    super.key,
    required this.project,
    required this.index,
    required this.isExpanded,
    this.itemMargin,
  });

  final Project project;
  final int index;
  final bool isExpanded;
  final EdgeInsetsGeometry? itemMargin;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.watch<LocaleCubit>().isArabic;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: isExpanded ? context.screenHeight : context.screenHeight * 0.4,
      width: double.infinity,
      margin: itemMargin ??
          AppUtils.tabContentEdgeInsets(isArabic).add(
            EdgeInsets.symmetric(
              vertical: 32.h,
            ),
          ),
      decoration: BoxDecoration(
        color: context.isDarkModeActive
            ? AppColors.closeToBlackColor
            : Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 6.h),
            blurRadius: 64.r,
            spreadRadius: 0,
            color: const Color(0xff7090B0).withOpacity(0.1),
          ),
        ],
      ),
      child: MaterialButton(
        onPressed: () =>
            context.read<AppCubit>().toggleProjectItemExpanded(index),
        padding: EdgeInsets.zero,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minWidth: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsetsDirectional.only(
                  start: 24.w,
                  end: 32.w,
                  top: 16.h,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      project.name,
                      style: AppTextStyles.playfairFont32Bold(context).copyWith(
                        color: context.isDarkModeActive
                            ? Colors.white
                            : AppColors.closeToBlackColor,
                      ),
                    ),
                    MySizedBox.height12,
                    Expanded(
                      child: Text(
                        context.translate(project.descriptionKey),
                        style:
                            AppTextStyles.nunitoFont16Regular(context).copyWith(
                          color: context.isDarkModeActive
                              ? Colors.white60
                              : AppColors.mediumGrey,
                        ),
                      ),
                    ),
                    MySizedBox.height24,
                    project.neitherDownloadedNorViewed
                        ? const SizedBox.shrink()
                        : BlocBuilder<AppCubit, AppState>(
                            buildWhen: (_, current) =>
                                current is ToggleProjectItemButtonIsHovered,
                            builder: (context, state) {
                              final isButtonHovered = context
                                  .read<AppCubit>()
                                  .isProjectButtonHovered[index];
                              return MouseRegion(
                                onEnter: (_) {
                                  context
                                      .read<AppCubit>()
                                      .toggleProjectButtonHovered(index);
                                },
                                onExit: (_) {
                                  context
                                      .read<AppCubit>()
                                      .toggleProjectButtonHovered(index);
                                },
                                child: MainButton(
                                  onPressed: () async =>
                                      await openUrl(project.url!),
                                  margin: EdgeInsets.only(bottom: 16.h),
                                  isOutlined: isButtonHovered ? false : true,
                                  backgroundColor: isButtonHovered
                                      ? null
                                      : context.isDarkModeActive
                                          ? AppColors.closeToBlackColor
                                          : Colors.white,
                                  textKey: project.canBeDownloaded
                                      ? LangKeys.downloadApp
                                      : LangKeys.viewProject,
                                  borderRadius: 24,
                                  fontSize: 16,
                                  textColor:
                                      isButtonHovered ? Colors.white : null,
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadiusDirectional.only(
                  topEnd: Radius.circular(24.r),
                  bottomEnd: Radius.circular(24.r),
                ),
                child: Image.asset(
                  project.image,
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
