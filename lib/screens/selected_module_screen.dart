import 'package:comprehenzone_mobile/providers/loading_provider.dart';
import 'package:comprehenzone_mobile/widgets/custom_miscellaneous_widgets.dart';
import 'package:comprehenzone_mobile/widgets/custom_text_widgets.dart';
import 'package:comprehenzone_mobile/utils/firebase_util.dart';
import 'package:comprehenzone_mobile/utils/string_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../utils/color_util.dart';
import '../widgets/custom_padding_widgets.dart';
import '../utils/url_util.dart';
import 'view_pdf_screen.dart';

class SelectedModuleScreen extends ConsumerStatefulWidget {
  final String moduleID;
  const SelectedModuleScreen({super.key, required this.moduleID});

  @override
  ConsumerState<SelectedModuleScreen> createState() =>
      _SelectedModuleScreenState();
}

class _SelectedModuleScreenState extends ConsumerState<SelectedModuleScreen> {
  String title = '';
  String content = '';
  List<dynamic> additionalDocuments = [];
  List<dynamic> additionalResources = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      try {
        ref.read(loadingProvider).toggleLoading(true);

        final module = await getThisModuleDoc(widget.moduleID);
        final moduleData = module.data() as Map<dynamic, dynamic>;
        title = moduleData[ModuleFields.title];
        content = moduleData[ModuleFields.content];
        additionalDocuments = moduleData[ModuleFields.additionalDocuments];
        additionalResources = moduleData[ModuleFields.additionalResources];
        ref.read(loadingProvider).toggleLoading(false);
      } catch (error) {
        scaffoldMessenger.showSnackBar(
            SnackBar(content: Text('Error getting lesson data: $error')));
        ref.read(loadingProvider).toggleLoading(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(loadingProvider);
    return Scaffold(
      appBar: AppBar(),
      extendBodyBehindAppBar: true,
      body: stackedLoadingContainer(
        context,
        ref.read(loadingProvider).isLoading,
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(ImagePaths.modulesBG), fit: BoxFit.cover)),
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: all10Pix(
              child: Column(
                children: [
                  Gap(40),
                  _title(),
                  Gap(20),
                  _content(),
                  if (additionalDocuments.isNotEmpty) _additionalDocuments(),
                  if (additionalResources.isNotEmpty) _additionalResources()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _title() {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: blackInterBold(title, fontSize: 30));
  }

  Widget _content() {
    return Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(border: Border.all()),
        padding: EdgeInsets.all(10),
        child: blackInterRegular(content,
            fontSize: 18, textAlign: TextAlign.left));
  }

  Widget _additionalDocuments() {
    return vertical10Pix(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          interText('Supplementary Documents',
              fontWeight: FontWeight.bold, fontSize: 14),
          Column(
            children: additionalDocuments.map((document) {
              Map<dynamic, dynamic> externalDocument =
                  document as Map<dynamic, dynamic>;
              return vertical10Pix(
                child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => ViewPDFScreen(
                                  pdfURL: externalDocument[
                                      AdditionalResourcesFields
                                          .downloadLink])));
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: CustomColors.midnightBlue),
                        child: whiteInterBold(
                            externalDocument[
                                AdditionalResourcesFields.fileName],
                            fontSize: 15))),
              );
            }).toList(),
          )
        ],
      ),
    );
  }

  Widget _additionalResources() {
    return vertical10Pix(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          interText('Additional Resources',
              fontWeight: FontWeight.bold, fontSize: 14),
          Column(
            children: additionalResources.map((resource) {
              Map<dynamic, dynamic> externalResource =
                  resource as Map<dynamic, dynamic>;
              return vertical10Pix(
                child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () async => launchThisURL(externalResource[
                            AdditionalResourcesFields.downloadLink]),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: CustomColors.midnightBlue),
                        child: whiteInterBold(
                            externalResource[
                                AdditionalResourcesFields.fileName],
                            fontSize: 15))),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
