import 'package:chattin/core/utils/app_pallete.dart';
import 'package:chattin/core/utils/app_spacing.dart';
import 'package:chattin/core/utils/app_theme.dart';
import 'package:chattin/core/utils/validators.dart';
import 'package:chattin/core/widgets/button_widget.dart';
import 'package:chattin/core/widgets/input_widget.dart';
import 'package:chattin/features/chat/presentation/cubits/chat_cubit/chat_cubit.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddContactView extends StatefulWidget {
  const AddContactView({super.key});

  @override
  State<AddContactView> createState() => _AddContactViewState();
}

class _AddContactViewState extends State<AddContactView> {
  String currentCountryCode = "+91";
  String currentCountry = "India 🇮🇳";
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New contact"),
        centerTitle: true,
        systemOverlayStyle: const SystemUiOverlayStyle(
          systemNavigationBarColor: AppPallete.backgroundColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                InputWidget(
                  labelText: "Display Name",
                  hintText: "Enter displayname",
                  textEditingController: _displayNameController,
                  validator: Validators.validateDisplayName,
                  suffixIcon: const Icon(
                    Icons.person,
                    size: 20,
                  ),
                  fillColor: AppPallete.backgroundColor,
                ),
                verticalSpacing(12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Phone code",
                    style:
                        AppTheme.darkThemeData.textTheme.displaySmall!.copyWith(
                      color: AppPallete.whiteColor,
                    ),
                  ),
                ),
                verticalSpacing(7),
                GestureDetector(
                  onTap: () => showCountryPicker(
                    context: context,
                    countryListTheme: CountryListThemeData(
                      textStyle: AppTheme.darkThemeData.textTheme.displaySmall!
                          .copyWith(
                        color: AppPallete.whiteColor,
                      ),
                      borderRadius: BorderRadius.circular(6),
                      backgroundColor: AppPallete.bottomSheetColor,
                      bottomSheetHeight: context.size!.height * .75,
                      searchTextStyle: AppTheme
                          .darkThemeData.textTheme.displaySmall!
                          .copyWith(
                        color: AppPallete.whiteColor,
                      ),
                      inputDecoration: InputDecoration(
                        hintText: "Search for your country",
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18,
                        ),
                        hintStyle: AppTheme
                            .darkThemeData.textTheme.displaySmall!
                            .copyWith(
                          color: AppPallete.greyColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(
                            color: AppPallete.greyColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          gapPadding: 15,
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(
                            color: AppPallete.greyColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          gapPadding: 15,
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(
                            color: AppPallete.greyColor,
                          ),
                        ),
                      ),
                    ),
                    showPhoneCode:
                        true, // optional. Shows phone code before the country name.
                    onSelect: (Country country) {
                      setState(() {
                        currentCountry = "${country.name} ${country.flagEmoji}";
                        currentCountryCode = "+${country.phoneCode}";
                      });
                    },
                  ),
                  child: Container(
                    width: double.maxFinite,
                    height: 45,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppPallete.greyColor,
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "$currentCountryCode $currentCountry",
                            style: AppTheme
                                .darkThemeData.textTheme.displaySmall!
                                .copyWith(
                              color: AppPallete.whiteColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                verticalSpacing(12),
                InputWidget(
                  labelText: "Phone",
                  hintText: "Enter a valid 10 digit phone number",
                  textEditingController: _phoneNoController,
                  validator: Validators.validatePhoneNumber,
                  suffixIcon: const Icon(
                    Icons.phone,
                    size: 20,
                  ),
                  fillColor: AppPallete.backgroundColor,
                ),
                verticalSpacing(20),
                ButtonWidget(
                  buttonText: "Add contact",
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<ChatCubit>().addNewContact(
                            phoneNumber: _phoneNoController.text.trim(),
                            phoneCode: currentCountryCode,
                            displayName: _displayNameController.text,
                          );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
