import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import '../../config/localization/localization.dart';
import '../../data/api/user_api.dart';
import '../../data/models/picked_file.dart';
import 'logout_sheet.dart';
import '../../utils/extension.dart';
import '../../utils/global.dart';
import '../../utils/images.dart';
import 'package:image_picker/image_picker.dart' as x;
import '../../widgets/easy_overlay/easy_overlay.dart';
import 'package:path/path.dart' as path;
import '../../widgets/network_imge_view.dart';
import '../../utils/app_colors.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<StatefulWidget> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  String? coverURL;
  PickedFile? cover;
  x.XFile? _pickedFile;

  @override
  void initState() {
    super.initState();
    coverURL = Global.user?.cover;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _emailController.text = Global.user?.email ?? '';
      _nameController.text = Global.user?.name ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    final primary = Theme.of(context).colorScheme.primary;
    final bg = isDark ? AppColors.darkCardDeep : AppColors.lightBg2;
    final cardBg = isDark ? AppColors.darkCard : Colors.white;
    final borderColor = isDark
        ? Colors.white.withValues(alpha: 0.07)
        : Colors.black.withValues(alpha: 0.07);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Edit Profile",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
          ),
          actions: [
            TextButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (ctx) => const LogoutSheet(),
                );
              },
              child: Text(
                LocaleKeys.logout.tr(),
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 28),

              // ── Avatar ──
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: borderColor, width: 2),
                        ),
                        child: ClipOval(
                          child: cover == null
                              ? NetworkImageView(
                                  width: 96,
                                  height: 96,
                                  fit: BoxFit.cover,
                                  url: coverURL,
                                  borderRadius: BorderRadius.circular(48),
                                )
                              : Image.memory(
                                  cover!.bytes,
                                  width: 96,
                                  height: 96,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: bg, width: 2),
                        ),
                        child: const Icon(
                          Icons.edit_rounded,
                          color: Colors.white,
                          size: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                Global.user?.name ?? '',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                Global.user?.email ?? '',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.35)
                      : Colors.black38,
                ),
              ),

              const SizedBox(height: 32),

              // ── Form ──
              Container(
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  children: [
                    _FormRow(
                      controller: _nameController,
                      label: "Name",
                      icon: Icons.person_outline_rounded,
                      maxLength: 20,
                      isDark: isDark,
                      primary: primary,
                      showDivider: true,
                    ),
                    _FormRow(
                      controller: _emailController,
                      label: "Email",
                      icon: Icons.email_outlined,
                      readOnly: true,
                      isDark: isDark,
                      primary: primary,
                      showDivider: false,
                    ),
                  ],
                ),
              ),

              // ── Avatars ──
              if ((Global.config.avatars?.length ?? 0) > 0) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: borderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Choose Avatar",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.5)
                              : Colors.black45,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 14),
                      GridView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                            ),
                        itemCount: Global.config.avatars!.length,
                        itemBuilder: (_, i) {
                          final current = Global.config.avatars![i];
                          final isSelected =
                              coverURL != null && coverURL == current;
                          return GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              setState(() {
                                coverURL = current;
                                cover = null;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? primary
                                      : Colors.transparent,
                                  width: 2.5,
                                ),
                              ),
                              child: ClipOval(
                                child: NetworkImageView(
                                  fit: BoxFit.cover,
                                  fallbackAssets: Imgs.user,
                                  url: current,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 28),

              // ── Save ──
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "Save Changes",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  _save() async {
    EasyOverlay.show();
    var response = await UserApi.update(
      name: _nameController.text.trim(),
      file: cover,
      coverURL: coverURL,
    );
    EasyOverlay.dismiss();
    if (response.status) {
      Global.user = response.data;
      EasyOverlay.showToast(message: "success");
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await x.ImagePicker().pickImage(
      source: x.ImageSource.gallery,
    );
    if (pickedFile != null) {
      _pickedFile = pickedFile;
      _cropImage();
    }
  }

  Future<void> _cropImage() async {
    if (_pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _pickedFile!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 60,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Profile Image',
            toolbarColor: context.colors.primaryFixed,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
            hideBottomControls: true,
            cropStyle: CropStyle.circle,
            aspectRatioPresets: [CropAspectRatioPreset.square],
          ),
        ],
      );
      if (croppedFile != null) {
        Uint8List bytes = await croppedFile.readAsBytes();
        String ext = path.basename(croppedFile.path).split(".").last;
        String name = path.basename(croppedFile.path).split(".").first;
        setState(() {
          cover = PickedFile(bytes: bytes, ext: ext, name: name);
          coverURL = null;
        });
      }
    }
  }
}

// ── Form row widget ───────────────────────────
class _FormRow extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool readOnly;
  final int? maxLength;
  final bool isDark;
  final Color primary;
  final bool showDivider;

  const _FormRow({
    required this.controller,
    required this.label,
    required this.icon,
    required this.isDark,
    required this.primary,
    required this.showDivider,
    this.readOnly = false,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: TextField(
            controller: controller,
            readOnly: readOnly,
            maxLength: maxLength,
            style: TextStyle(
              fontSize: 15,
              color: isDark ? Colors.white : Colors.black87,
            ),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.white38 : Colors.black38,
              ),
              counterText: "",
              prefixIcon: Icon(
                icon,
                size: 18,
                color: isDark ? Colors.white38 : Colors.black38,
              ),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: 16,
            endIndent: 16,
            color: isDark
                ? Colors.white.withValues(alpha: 0.07)
                : Colors.black.withValues(alpha: 0.07),
          ),
      ],
    );
  }
}
