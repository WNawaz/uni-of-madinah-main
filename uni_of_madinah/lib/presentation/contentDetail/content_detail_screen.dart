import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:uni_of_madinah/presentation/contentDetail/content_detail_vm.dart';

class ContentDetailScreen extends StatelessWidget {
  const ContentDetailScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ContentDetailViewModel>.reactive(
      onViewModelReady: (viewModel) => viewModel.init(),
      viewModelBuilder: () => ContentDetailViewModel(),
      builder: (context, model, _) => Scaffold(
        appBar: AppBar(
          title: Text(model.contentDetailService.content!.title),
          actions: [
            model.volunteerService.isVolunteer
                ? IconButton(
                    icon: Icon(Icons.save),
                    onPressed: () => model.saveContent(),
                  )
                : const SizedBox.shrink(),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(12.0),
          child: Directionality(
            textDirection: model.contentDetailService.content!.isRTL
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: model.titleController,
                        decoration: InputDecoration(
                          labelText: 'Title',
                        ),
                        readOnly: !model
                            .isTitleEditing, // Disable editing if not in edit mode
                      ),
                    ), // Check if the user is a volunteer
                    model.volunteerService.isVolunteer
                        ? IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => model.toggleTitleEditMode(),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: model.descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Description',
                        ),
                        readOnly: !model
                            .isDescriptionEditing, // Disable editing if not in edit mode
                        maxLines: null,
                      ),
                    ),
                    model.volunteerService.isVolunteer
                        ? InkWell(
                            onTap: () => model.toggleDescriptionEditMode(),

                            //  onTap: () => model.toggleDescriptionEditMode(),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.edit),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: model.isTtsLoading
            ? CircularProgressIndicator()
            : FloatingActionButton(
                onPressed: () {
                  if (model.isTtsActive) {
                    model.pauseOrResumeTts();
                  } else {
                    model.speakContent();
                  }
                },
                child: Icon(model.isTtsActive ? Icons.pause : Icons.volume_up),
              ),
      ),
    );
  }
}
