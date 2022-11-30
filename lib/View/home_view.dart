import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:receipt_reader/Provider/home_provider.dart';
import 'package:receipt_reader/base/base_view.dart';

class HomeView extends BaseView<HomeProvider> {
  HomeView();

  @override
  PreferredSizeWidget? customAppbar(BuildContext context) {
    return null;
  }

  @override
  Widget customBuild(BuildContext context) {
    return Selector<HomeProvider, int>(
      selector: ((_, model) => model.currentStep),
      builder: (context, currentStep, child) => Stepper(
        type: StepperType.horizontal,
        steps: getSteps(),
        onStepTapped: null,
        onStepContinue: (currentStep + 1 == getSteps().length)
            ? null
            : () {
                provider.nextStep();
              },
        onStepCancel: currentStep == 0
            ? null
            : () {
                provider.previousStep();
              },
        currentStep: currentStep,
        elevation: 15,
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          return Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple[800],
                  foregroundColor: Colors.yellow,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                onPressed: details.onStepCancel,
                label: details.onStepCancel != null ? const Text("BACK") : const SizedBox.shrink(),
                icon: Icon(Icons.adaptive.arrow_back),
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple[800],
                    foregroundColor: Colors.yellow,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  onPressed: details.onStepContinue,
                  label: details.onStepContinue != null ? const Text("NEXT") : const SizedBox.shrink(),
                  icon: Icon(Icons.adaptive.arrow_back),
                ),
              ),
            ],
          );
        },
      ),
      child: Container(
        color: Colors.red,
      ),
    );
  }

  List<Step> getSteps() => [
        Step(
          title: const Text("Fatura"),
          isActive: (provider.currentStep == 0 ? true : false),
          state: provider.currentStep == 0
              ? StepState.editing
              : (provider.currentStep > 0 ? StepState.complete : StepState.indexed),
          content: ListView(
            shrinkWrap: true,
            children: [
              provider.image != null
                  ? SizedBox(
                      height: 400,
                      width: 400,
                      child: Image.file(provider.image!),
                    )
                  : const Icon(
                      Icons.image,
                      size: 200,
                    ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  child: const Text('From Gallery'),
                  onPressed: () async {
                    await provider.getImage(ImageSource.gallery);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  child: const Text('Take a picture'),
                  onPressed: () async {
                    await provider.getImage(ImageSource.camera);
                  },
                ),
              ),
              // if (provider.image != null)
              //   Padding(
              //     padding: const EdgeInsets.all(16.0),
              //     child: Text('${_path == null ? '' : 'Image path: $_path'}\n\n${widget.text ?? ''}'),
              //   ),
            ],
          ),
        ),
        Step(
            isActive: (provider.currentStep == 1 ? true : false),
            title: const Text("Editing"),
            content: const Text("data"),
            state: provider.currentStep == 1
                ? StepState.editing
                : (provider.currentStep > 1 ? StepState.complete : StepState.indexed)),
        Step(
            isActive: (provider.currentStep == 2 ? true : false),
            title: const Text("Creating"),
            content: const Text("data"),
            state: provider.currentStep == 2
                ? StepState.editing
                : (provider.currentStep > 2 ? StepState.complete : StepState.indexed)),
      ];
}
