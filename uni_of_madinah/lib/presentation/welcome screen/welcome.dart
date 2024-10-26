import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:uni_of_madinah/presentation/figma_design_Ui/startUp/start_up_screen.dart';
import 'package:uni_of_madinah/presentation/welcome%20screen/welcome_vm.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => WelcomeScreenViewModel(),
      onViewModelReady: (model) => model.initialise(),
      builder: (context, model, child) => StartupScreen(),
    );
  }
}
