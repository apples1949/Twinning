import '/common.dart';
import '/setting.dart';
import '/module.dart';
import '/utility/convert_helper.dart';
import '/utility/storage_helper.dart';
import '/utility/permission_helper.dart';
import '/utility/control_helper.dart';
import '/view/home/common.dart';
import '/view/home/about_panel.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

// ----------------

class SettingPanel extends StatefulWidget {

  const SettingPanel({
    super.key,
  });

  // ----------------

  // ----------------

  @override
  createState() => _SettingPanelState();

}

class _SettingPanelState extends State<SettingPanel> {

  late Boolean  _storagePermissionState;
  late Boolean? _forwarderExtensionState;

  Future<Boolean?> checkForwarderExtension(
  ) async {
    var result = null as Boolean?;
    if (SystemChecker.isWindows) {
      var stateFile = '${await StorageHelper.queryApplicationSharedDirectory()}/forwarder';
      result = await StorageHelper.exist(stateFile);
    }
    if (SystemChecker.isLinux) {
      result = false;
    }
    if (SystemChecker.isMacintosh) {
      result = null;
    }
    if (SystemChecker.isAndroid) {
      result = true;
    }
    if (SystemChecker.isIphone) {
      result = null;
    }
    return result;
  }

  Future<Boolean?> toggleForwarderExtension(
  ) async {
    var result = null as Boolean?;
    if (SystemChecker.isWindows) {
      var stateFile = '${await StorageHelper.queryApplicationSharedDirectory()}/forwarder';
      if (!await StorageHelper.exist(stateFile)) {
        await StorageHelper.createFile(stateFile);
      }
      else {
        await StorageHelper.remove(stateFile);
      }
      result = true;
    }
    if (SystemChecker.isLinux) {
      result = false;
    }
    if (SystemChecker.isMacintosh) {
      // Ventura 13 and later
      await launchUrl(Uri.parse('x-apple.systempreferences:com.apple.ExtensionsPreferences?extensionPointIdentifier=com.apple.fileprovider-nonui'), mode: LaunchMode.externalApplication);
      result = null;
    }
    if (SystemChecker.isAndroid) {
      result = false;
    }
    if (SystemChecker.isIphone) {
      result = false;
    }
    return result;
  }

  // ----------------

  @override
  initState() {
    super.initState();
    this._storagePermissionState = false;
    this._forwarderExtensionState = null;
    ControlHelper.postTask(() async {
      this._storagePermissionState = await PermissionHelper.checkStorage();
      this._forwarderExtensionState = await this.checkForwarderExtension();
      await refreshState(this.setState);
    });
    return;
  }

  @override
  didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    return;
  }

  @override
  dispose() {
    super.dispose();
    return;
  }

  @override
  build(context) {
    var setting = Provider.of<SettingProvider>(context);
    var theme = Theme.of(context);
    return Column(
      children: [
        SizedBox(height: 4),
        CustomSettingLabel(
          label: 'Theme',
          action: null,
        ),
        CustomSettingItem(
          icon: IconSymbols.brightness_4,
          label: 'Theme Mode',
          content: [
            Text(
              ['System', 'Light', 'Dark'][setting.data.themeMode.index],
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium,
            ),
          ],
          onTap: null,
          panelBuilder: (context, setStateForPanel) => [
            ...ThemeMode.values.map(
              (item) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Radio(
                  value: item,
                  groupValue: setting.data.themeMode,
                  onChanged: (value) async {
                    setting.data.themeMode = value!;
                    await refreshState(setStateForPanel);
                    await refreshState(this.setState);
                    await setting.save();
                  },
                ),
                title: Text(
                  ['System', 'Light', 'Dark'][item.index],
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        CustomSettingItem(
          icon: IconSymbols.colorize,
          label: 'Theme Color',
          content: [
            Text(
              !setting.data.themeColorState ? 'Default' : 'Custom',
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium,
            ),
          ],
          onTap: null,
          panelBuilder: (context, setStateForPanel) => [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Switch(
                value: setting.data.themeColorState,
                onChanged: (value) async {
                  setting.data.themeColorState = value;
                  await refreshState(setStateForPanel);
                  await refreshState(this.setState);
                  await setting.save();
                },
              ),
              title: Text(
                'Enable',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: CustomTextField(
                keyboardType: TextInputType.text,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9a-fA-F]'))],
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(12, 16, 12, 16),
                  filled: false,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(IconSymbols.light_mode),
                  suffixIcon: Icon(
                    IconSymbols.circle,
                    fill: 0.6,
                    color: setting.data.themeColorLight,
                  ),
                ),
                value: setting.data.themeColorLight.withValues(alpha: 0.0).toARGB32().toRadixString(16).padLeft(6, '0'),
                onChanged: (value) async {
                  setting.data.themeColorLight = Color(Integer.tryParse(value, radix: 16) ?? 0x000000).withValues(alpha: 1.0);
                  await refreshState(setStateForPanel);
                  await refreshState(this.setState);
                  await setting.save();
                },
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: CustomTextField(
                keyboardType: TextInputType.text,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9a-fA-F]'))],
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(12, 16, 12, 16),
                  filled: false,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(IconSymbols.dark_mode),
                  suffixIcon: Icon(
                    IconSymbols.circle,
                    fill: 0.6,
                    color: setting.data.themeColorDark,
                  ),
                ),
                value: setting.data.themeColorDark.withValues(alpha: 0.0).toARGB32().toRadixString(16).padLeft(6, '0'),
                onChanged: (value) async {
                  setting.data.themeColorDark = Color(Integer.tryParse(value, radix: 16) ?? 0x000000).withValues(alpha: 1.0);
                  await refreshState(setStateForPanel);
                  await refreshState(this.setState);
                  await setting.save();
                },
              ),
            ),
          ],
        ),
        CustomSettingItem(
          icon: IconSymbols.text_fields,
          label: 'Theme Font',
          content: [
            Text(
              !setting.data.themeFontState ? 'Default' : 'Custom',
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium,
            ),
          ],
          onTap: null,
          panelBuilder: (context, setStateForPanel) => [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Switch(
                value: setting.data.themeFontState,
                onChanged: (value) async {
                  setting.data.themeFontState = value;
                  await refreshState(setStateForPanel);
                  await refreshState(this.setState);
                  await setting.save();
                },
              ),
              title: Text(
                'Enable',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: CustomTextField(
                keyboardType: TextInputType.multiline,
                inputFormatters: [],
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(12, 16, 12, 16),
                  filled: false,
                  border: OutlineInputBorder(),
                  suffixIcon: CustomTextFieldSuffixRegion(
                    children: [
                      IconButton(
                        tooltip: 'Pick',
                        icon: Icon(IconSymbols.open_in_new),
                        onPressed: () async {
                          var target = await StorageHelper.pickLoadFile(context, 'Application.ThemeFont');
                          if (target != null) {
                            setting.data.themeFontPath = setting.data.themeFontPath + [target];
                            await refreshState(setStateForPanel);
                            await refreshState(this.setState);
                            await setting.save();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                value: ConvertHelper.makeStringListToStringWithLine(setting.data.themeFontPath),
                onChanged: (value) async {
                  setting.data.themeFontPath = ConvertHelper.parseStringListFromStringWithLine(value);
                  await refreshState(setStateForPanel);
                  await refreshState(this.setState);
                  await setting.save();
                },
              ),
            ),
          ],
        ),
        CustomSettingLabel(
          label: 'Window',
          action: null,
        ),
        CustomSettingItem(
          enabled: SystemChecker.isWindows || SystemChecker.isLinux || SystemChecker.isMacintosh,
          icon: IconSymbols.recenter,
          label: 'Window Position',
          content: [
            Text(
              !setting.data.windowPositionState ? 'Default' : 'Custom',
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: SystemChecker.isWindows || SystemChecker.isLinux || SystemChecker.isMacintosh ? null : theme.disabledColor,
              ),
            ),
          ],
          onTap: null,
          panelBuilder: (context, setStateForPanel) => [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Switch(
                value: setting.data.windowPositionState,
                onChanged: (value) async {
                  setting.data.windowPositionState = value;
                  await refreshState(setStateForPanel);
                  await refreshState(this.setState);
                  await setting.save();
                },
              ),
              title: Text(
                'Enable',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: CustomTextField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(12, 16, 12, 16),
                  filled: false,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(IconSymbols.swap_horiz),
                ),
                value: setting.data.windowPositionX.toString(),
                onChanged: (value) async {
                  setting.data.windowPositionX = Integer.tryParse(value) ?? setting.data.windowPositionX;
                  await refreshState(setStateForPanel);
                  await refreshState(this.setState);
                  await setting.save();
                },
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: CustomTextField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(12, 16, 12, 16),
                  filled: false,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(IconSymbols.swap_vert),
                ),
                value: setting.data.windowPositionY.toString(),
                onChanged: (value) async {
                  setting.data.windowPositionY = Integer.tryParse(value) ?? setting.data.windowPositionY;
                  await refreshState(setStateForPanel);
                  await refreshState(this.setState);
                  await setting.save();
                },
              ),
            ),
          ],
        ),
        CustomSettingItem(
          enabled: SystemChecker.isWindows || SystemChecker.isLinux || SystemChecker.isMacintosh,
          icon: IconSymbols.fit_screen,
          label: 'Window Size',
          content: [
            Text(
              !setting.data.windowSizeState ? 'Default' : 'Custom',
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: SystemChecker.isWindows || SystemChecker.isLinux || SystemChecker.isMacintosh ? null : theme.disabledColor,
              ),
            ),
          ],
          onTap: null,
          panelBuilder: (context, setStateForPanel) => [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Switch(
                value: setting.data.windowSizeState,
                onChanged: (value) async {
                  setting.data.windowSizeState = value;
                  await refreshState(setStateForPanel);
                  await refreshState(this.setState);
                  await setting.save();
                },
              ),
              title: Text(
                'Enable',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: CustomTextField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(12, 16, 12, 16),
                  filled: false,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(IconSymbols.width),
                ),
                value: setting.data.windowSizeWidth.toString(),
                onChanged: (value) async {
                  setting.data.windowSizeWidth = Integer.tryParse(value) ?? setting.data.windowSizeWidth;
                  await refreshState(setStateForPanel);
                  await refreshState(this.setState);
                  await setting.save();
                },
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: CustomTextField(
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(12, 16, 12, 16),
                  filled: false,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(IconSymbols.height),
                ),
                value: setting.data.windowSizeHeight.toString(),
                onChanged: (value) async {
                  setting.data.windowSizeHeight = Integer.tryParse(value) ?? setting.data.windowSizeHeight;
                  await refreshState(setStateForPanel);
                  await refreshState(this.setState);
                  await setting.save();
                },
              ),
            ),
          ],
        ),
        CustomSettingLabel(
          label: 'Storage',
          action: null,
        ),
        CustomSettingItem(
          enabled: SystemChecker.isAndroid,
          icon: IconSymbols.key,
          label: 'Storage Permission',
          content: [
            Text(
              !this._storagePermissionState ? 'Denied' : 'Granted',
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: SystemChecker.isAndroid ? null : theme.disabledColor,
              ),
            ),
          ],
          onTap: () async {
            this._storagePermissionState = await PermissionHelper.requestStorage();
            await refreshState(this.setState);
          },
          panelBuilder: null,
        ),
        CustomSettingItem(
          enabled: SystemChecker.isAndroid,
          icon: IconSymbols.snippet_folder,
          label: 'Storage Picker Fallback Directory',
          content: [
            Text(
              !StorageHelper.existDirectorySync(setting.data.storagePickerFallbackDirectory) ? 'Invalid' : 'Available',
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: SystemChecker.isAndroid ? null : theme.disabledColor,
              ),
            ),
          ],
          onTap: null,
          panelBuilder: (context, setStateForPanel) => [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: CustomTextField(
                keyboardType: TextInputType.text,
                inputFormatters: [],
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(12, 16, 12, 16),
                  filled: false,
                  border: OutlineInputBorder(),
                  suffixIcon: CustomTextFieldSuffixRegion(
                    children: [
                      IconButton(
                        tooltip: 'Pick',
                        icon: Icon(IconSymbols.open_in_new),
                        onPressed: () async {
                          var target = await StorageHelper.pickLoadDirectory(context, 'Application.StoragePickerFallbackDirectory');
                          if (target != null) {
                            setting.data.storagePickerFallbackDirectory = target;
                            await refreshState(setStateForPanel);
                            await refreshState(this.setState);
                            await setting.save();
                          }
                        },
                      ),
                    ],
                  ),
                ),
                value: setting.data.storagePickerFallbackDirectory,
                onChanged: (value) async {
                  setting.data.storagePickerFallbackDirectory = StorageHelper.regularize(value);
                  await refreshState(setStateForPanel);
                  await refreshState(this.setState);
                  await setting.save();
                },
              ),
            ),
          ],
        ),
        CustomSettingLabel(
          label: 'Forwarder',
          action: null,
        ),
        CustomSettingItem(
          enabled: SystemChecker.isWindows || SystemChecker.isMacintosh,
          icon: IconSymbols.send_time_extension,
          label: 'Forwarder Extension',
          content: [
            Text(
              this._forwarderExtensionState == null ? 'System' : !this._forwarderExtensionState! ? 'Disabled' : 'Enabled',
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: SystemChecker.isWindows || SystemChecker.isMacintosh ? null : theme.disabledColor,
              ),
            ),
          ],
          onTap: null,
          panelBuilder: (context, setStateForPanel) => [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Switch(
                thumbIcon: this._forwarderExtensionState != null ? null : WidgetStatePropertyAll(Icon(IconSymbols.question_mark)),
                value: this._forwarderExtensionState == null ? false : this._forwarderExtensionState!,
                onChanged: (value) async {
                  await this.toggleForwarderExtension();
                  this._forwarderExtensionState = await this.checkForwarderExtension();
                  await refreshState(setStateForPanel);
                  await refreshState(this.setState);
                },
              ),
              title: Text(
                'Enable',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        CustomSettingItem(
          icon: IconSymbols.nearby,
          label: 'Forwarder Default Target',
          content: [
            Text(
              ModuleHelper.query(setting.data.forwarderDefaultTarget).name,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium,
            ),
          ],
          onTap: null,
          panelBuilder: (context, setStateForPanel) => [
            ...ModuleType.values.map(
              (item) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Radio(
                  value: item,
                  groupValue: setting.data.forwarderDefaultTarget,
                  onChanged: (value) async {
                    setting.data.forwarderDefaultTarget = value!;
                    await refreshState(setStateForPanel);
                    await refreshState(this.setState);
                    await setting.save();
                  },
                ),
                title: Text(
                  ModuleHelper.query(item).name,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        CustomSettingItem(
          icon: IconSymbols.touch_app,
          label: 'Forwarder Immediate Jump',
          content: [
            Text(
              !setting.data.forwarderImmediateJump ? 'Disabled' : 'Enabled',
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium,
            ),
          ],
          onTap: null,
          panelBuilder: (context, setStateForPanel) => [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Switch(
                value: setting.data.forwarderImmediateJump,
                onChanged: (value) async {
                  setting.data.forwarderImmediateJump = value;
                  await refreshState(setStateForPanel);
                  await refreshState(this.setState);
                  await setting.save();
                },
              ),
              title: Text(
                'Enable',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        CustomSettingLabel(
          label: 'Other',
          action: null,
        ),
        CustomSettingItem(
          icon: IconSymbols.info,
          label: 'About',
          content: [],
          onTap: null,
          panelBuilder: (context, setStateForPanel) => [
            AboutPanel(),
          ],
        ),
        CustomSettingItem(
          icon: IconSymbols.settings,
          label: 'Setting File',
          content: [],
          onTap: null,
          panelBuilder: (context, setStateForPanel) => [
            ListTile(
              title: Text(
                'Reload',
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () async {
                Navigator.pop(context);
                await setting.load();
                await setting.save();
                await ControlHelper.showSnackBar(setting.state.applicationNavigatorKey.currentContext!, 'Done!');
              },
            ),
            ListTile(
              title: Text(
                'Reset',
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () async {
                Navigator.pop(context);
                if (await ControlHelper.showDialogForConfirm(context)) {
                  await setting.reset();
                  await setting.save();
                  await ControlHelper.showSnackBar(setting.state.applicationNavigatorKey.currentContext!, 'Done!');
                }
              },
            ),
            ListTile(
              title: Text(
                'Import',
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () async {
                Navigator.pop(context);
                var file = await StorageHelper.pickLoadFile(context, 'Application.SettingFile');
                if (file != null) {
                  await setting.load(file: file);
                  await setting.save();
                  await ControlHelper.showSnackBar(setting.state.applicationNavigatorKey.currentContext!, 'Done!');
                }
              },
            ),
            ListTile(
              title: Text(
                'Export',
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () async {
                Navigator.pop(context);
                var file = await StorageHelper.pickSaveFile(context, 'Application.SettingFile');
                if (file != null) {
                  await setting.save(file: file, apply: false);
                  await ControlHelper.showSnackBar(setting.state.applicationNavigatorKey.currentContext!, 'Done!');
                }
              },
            ),
          ],
        ),
        CustomSettingItem(
          icon: IconSymbols.folder_special,
          label: 'Shared Directory',
          content: [],
          onTap: null,
          panelBuilder: (context, setStateForPanel) => [
            ListTile(
              title: Text(
                'Reveal',
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () async {
                Navigator.pop(context);
                await ControlHelper.showDialogForRevealStoragePath(context, 'Shared Directory', await StorageHelper.queryApplicationSharedDirectory());
              },
            ),
          ],
        ),
        CustomSettingItem(
          icon: IconSymbols.folder_delete,
          label: 'Cache Directory',
          content: [],
          onTap: null,
          panelBuilder: (context, setStateForPanel) => [
            ListTile(
              title: Text(
                'Clear',
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () async {
                Navigator.pop(context);
                var cacheDirectory = await StorageHelper.queryApplicationCacheDirectory();
                if (await StorageHelper.exist(cacheDirectory)) {
                  await StorageHelper.remove(cacheDirectory);
                }
                await ControlHelper.showSnackBar(setting.state.applicationNavigatorKey.currentContext!, 'Done!');
              },
            ),
          ],
        ),
        SizedBox(height: 8),
      ],
    );
  }

}
