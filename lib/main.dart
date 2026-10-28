import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shadesmaster/app/app_scope.dart';
import 'package:shadesmaster/app/app_settings.dart';
import 'package:shadesmaster/app/settings_page.dart';
import 'package:shadesmaster/l10n/app_localizations.dart';
import 'package:shadesmaster/orders/order_repository.dart';
import 'package:shadesmaster/widget_shade_master.dart';
import 'package:shadesmaster/widget_primary_button.dart';

const appVersion = '1.0.0';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  registerFontLicenses();
  final storage = await AppStorage.open();
  final settings = await AppSettings.load(storage.settingsFile);
  runApp(MyApp(settings: settings, orders: OrderRepository(storage.ordersDirectory)));
}

/// Shows the bundled fonts' licenses on the open source licenses page.
void registerFontLicenses() {
  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks(
      ['IBM Plex Sans Arabic'],
      await rootBundle.loadString('assets/fonts/IBMPlexSansArabic-LICENSE.txt'),
    );
    yield LicenseEntryWithLineBreaks(['Noto Sans'], await rootBundle.loadString('assets/fonts/NotoSans-LICENSE.txt'));
  });
}

class MyApp extends StatelessWidget {
  final AppSettings settings;
  final OrderRepository orders;

  const MyApp({super.key, required this.settings, required this.orders});

  @override
  Widget build(BuildContext context) {
    return AppScope(
      settings: settings,
      orders: orders,
      child: ListenableBuilder(
        listenable: settings,
        builder: (context, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
          locale: settings.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0078D4)),
            fontFamily: 'IBMPlexSansArabic',
            useMaterial3: true,
          ),
          home: const MainPage(),
        ),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  XFile? imgPicked;

  pickImage(bool camera) async {
    final target = await ImagePicker().pickImage(source: camera ? ImageSource.camera : ImageSource.gallery);
    setState(() {
      imgPicked = target;
    });
  }

  closeImage() {
    setState(() {
      imgPicked = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: imgPicked != null
          ? null
          : AppBar(
              title: Text(l10n.appTitle),
              actions: [
                IconButton(
                  tooltip: l10n.settings,
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsPage())),
                ),
              ],
            ),
      body: Center(
        child: imgPicked != null
            ? ShadeMaster(
                img: imgPicked!,
                onClose: closeImage,
              )
            : SingleChildScrollView(
                padding: EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(l10n.homeHeadline, style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
                    SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16), // adjust the radius
                      child: Image.asset(
                        'assets/icon/app_icon.png',
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 10),
                    buildPickerButtons(l10n),
                    SizedBox(height: 25),
                    Text(l10n.appVersion(appVersion), style: TextStyle(fontSize: 11)),
                    Text(l10n.basedOn, style: TextStyle(fontSize: 11), textAlign: TextAlign.center),
                  ],
                ),
              ),
      ),
    );
  }

  Column buildPickerButtons(AppLocalizations l10n) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(l10n.homeHint, textAlign: TextAlign.center),
        ),
        SizedBox(height: 10),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          runSpacing: 10,
          children: <Widget>[
            PrimaryButton(
              onPressed: () => pickImage(true),
              title: l10n.useCamera,
              icon: Icons.camera_alt,
            ),
            PrimaryButton(
              onPressed: () => pickImage(false),
              title: l10n.pickImage,
              icon: Icons.folder,
            ),
          ],
        ),
      ],
    );
  }
}
