import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/widget/buttons.dart';
import '../../../../core/common/widget/cmn_text.dart';
import '../../domain/entities/page_content.dart';
import '../cubit/on_boarding_cubit.dart';

class OnBoardingBody extends StatelessWidget {
  const OnBoardingBody({required this.pageContent, super.key});

  final PageContent pageContent;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(pageContent.image, height: size.height * .4),
        SizedBox(height: size.height * .03),
        Padding(
          padding: const EdgeInsets.all(20).copyWith(bottom: 0),
          child: Column(
            children: [
              KTextPrimary(
                pageContent.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(height: size.height * .02),
              KTextOnSurfaceVariant(
                pageContent.description,
                textAlign: TextAlign.center,
                maxLines: 3,
              ),
              SizedBox(height: size.height * .05),
              KPrimaryBtn(
                onPressed: () {
                  context.read<OnBoardingCubit>().cacheFirstTimer();
                },
                text: 'Get Started',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
