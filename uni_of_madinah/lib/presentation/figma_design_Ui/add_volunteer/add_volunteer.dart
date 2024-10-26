import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:stacked/stacked.dart';
import 'package:uni_of_madinah/presentation/figma_design_Ui/add_volunteer/add_volunteer_vm.dart';

class AddVolunteer extends StatelessWidget {
  const AddVolunteer({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddVolunteerViewModel>.reactive(
      viewModelBuilder: () => AddVolunteerViewModel(),
      onViewModelReady: (model) {
        model.fetchVolunteers();
      },
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          leading: Semantics(
            excludeSemantics: true,
            label:
                "Back button please double to navigate back to previous screen",
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: HexColor("#05677E"),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          title: Semantics(
            excludeSemantics: true,
            label: "Add Volunteer section",
            child: Text(
              'Add Volunteer',
              style: TextStyle(
                color: HexColor("#05677E"),
                fontFamily: 'Roboto',
                fontSize: 28.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0.sp, vertical: 12.sp),
          child: Column(
            children: [
              Semantics(
                excludeSemantics: true,
                label:
                    "You can add multiple volunteers by entering their email below to enable them to edit text content on the website.",
                child: Text(
                  'Add multiple volunteers by entering their email below to enable them to edit text content on the website.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              SizedBox(height: 60.h),
              Column(
                children: [
                  Semantics(
                    excludeSemantics: true,
                    label:
                        "Email input field. Please double click to enter the email address you want to add as a vilunteer",
                    child: SizedBox(
                      child: TextField(
                        controller: model.emailController,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          labelText: 'Email',
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16.sp),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(4.sp),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        onChanged: model.handleEmailFieldChange,
                        onSubmitted: (value) {
                          if (value.isNotEmpty) {
                            model.addVolunteerEmail(value);
                            model.emailController.clear();
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Semantics(
                    excludeSemantics: true,
                    label:
                        "Add button. Please Double click to add the entered email address as a volunteer.",
                    child: ElevatedButton.icon(
                      onPressed: !model.isValidEmail
                          ? null
                          : () {
                              if (model.emailController.text.isNotEmpty) {
                                model.addVolunteerEmail(
                                    model.emailController.text);
                                model.emailController.clear();
                              }
                            },
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Add',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: HexColor("#05677E"),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Semantics(
                excludeSemantics: true,
                label: "Volunteers Section",
                child: Row(
                  children: [
                    Text(
                      'Volunteers',
                      style: TextStyle(
                        color: HexColor("#05677E"),
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: Semantics(
                  excludeSemantics: true,
                  label: "List of added volunteers.",
                  child: Container(
                    decoration: BoxDecoration(
                      color: HexColor("#F5FAFD"),
                      borderRadius: BorderRadius.circular(22.sp),
                    ),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: model.volunteers.length,
                      itemBuilder: (context, index) {
                        return Semantics(
                          excludeSemantics: true,
                          label:
                              "Volunteer name is ${model.volunteers[index]}. Swipe right for delete button if you want to remove the volunteer",
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.0.sp, vertical: 3.0.sp),
                            child: ListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              leading: SizedBox(
                                width: 24.w,
                                height: 24.h,
                                child: Icon(Icons.person_outline_outlined,
                                    size: 24.sp),
                              ),
                              title: Text(
                                model.volunteers[index],
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              trailing: Semantics(
                                excludeSemantics: true,
                                label:
                                    "Delete button.Please double tap to Remove this volunteer.",
                                child: SizedBox(
                                  width: 24.w,
                                  height: 24.h,
                                  child: IconButton(
                                    padding: EdgeInsets.zero,
                                    iconSize: 24.sp,
                                    icon: const Icon(
                                        Icons.delete_outline_outlined),
                                    onPressed: () {
                                      model.deleteVolunteer(index);
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
