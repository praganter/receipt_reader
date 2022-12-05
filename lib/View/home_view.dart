import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:receipt_reader/Provider/home_provider.dart';
import 'package:receipt_reader/base/base_view.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:tuple/tuple.dart';

class HomeView extends BaseView<HomeProvider> {
  HomeView();

  @override
  PreferredSizeWidget? customAppbar(BuildContext context) {
    return null;
  }

  @override
  Widget customBuild(BuildContext context) {
    return Selector<HomeProvider, Tuple2<int, bool?>>(
      selector: ((_, model) => Tuple2(model.currentStep, model.isAcceptable)),
      builder: (context, model, child) => Stepper(
        type: StepperType.horizontal,
        steps: getSteps(),
        onStepTapped: null,
        onStepContinue: (model.item1 + 1 == getSteps().length)
            ? null
            : model.item2 != null
                ? (model.item2!
                    ? () {
                        provider.nextStep();
                      }
                    : null)
                : null,
        onStepCancel: model.item1 == 0
            ? null
            : () {
                provider.previousStep();
              },
        currentStep: model.item1,
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
              Selector<HomeProvider, File?>(
                selector: ((_, model) => model.image),
                builder: (context, image, child) => image != null
                    ? SizedBox(
                        height: 400,
                        width: 400,
                        child: Image.file(image),
                      )
                    : const Icon(
                        Icons.image,
                        size: 200,
                      ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  child: const Text('From Gallery'),
                  onPressed: () async {
                    EasyLoading.show(maskType: EasyLoadingMaskType.black, status: "Processing...");
                    await provider.getImage(ImageSource.gallery);
                    EasyLoading.dismiss();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ElevatedButton(
                  child: const Text('Take a picture'),
                  onPressed: () async {
                    EasyLoading.show();
                    await provider.getImage(ImageSource.camera);
                    EasyLoading.dismiss();
                  },
                ),
              ),
              Center(
                child: Selector<HomeProvider, bool?>(
                    selector: ((_, model) => model.isAcceptable),
                    builder: (context, isAcceptable, child) {
                      return isAcceptable != null
                          ? (isAcceptable
                              ? const Text("Geçerli fatura devam edin.")
                              : const Text("Geçersiz fatura yeniden deneyin."))
                          : const SizedBox.shrink();
                    }),
              ),
            ],
          ),
        ),
        Step(
          isActive: (provider.currentStep == 1 ? true : false),
          title: const Text("Editing"),
          state: provider.currentStep == 1
              ? StepState.editing
              : (provider.currentStep > 1 ? StepState.complete : StepState.indexed),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Selector<HomeProvider, File?>(
                  selector: ((_, model) => model.image),
                  builder: (context, image, child) => image != null
                      ? SizedBox(
                          height: 400,
                          width: 400,
                          child: Image.file(image),
                        )
                      : const Icon(
                          Icons.image,
                          size: 200,
                        ),
                ),
                Selector<HomeProvider, String>(
                    selector: ((_, model) => model.scannedText),
                    builder: (context, scannedText, child) {
                      return Text(scannedText);
                    }),
              ],
            ),
          ),
        ),
        Step(
            isActive: (provider.currentStep == 2 ? true : false),
            title: const Text("Creating"),
            content: const Text("data"),
            state: provider.currentStep == 2
                ? StepState.editing
                : (provider.currentStep > 2 ? StepState.complete : StepState.indexed)),
      ];
}
