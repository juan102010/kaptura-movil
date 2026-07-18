import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Kaptura'**
  String get appTitle;

  /// No description provided for @workOrders.
  ///
  /// In en, this message translates to:
  /// **'Work Orders'**
  String get workOrders;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @inventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get inventory;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @signInToContinue.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue.'**
  String get signInToContinue;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'you@email.com'**
  String get emailHint;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterEmail;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get invalidEmail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password is too short'**
  String get passwordTooShort;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @biometricLogin.
  ///
  /// In en, this message translates to:
  /// **'Login with fingerprint'**
  String get biometricLogin;

  /// No description provided for @biometricReason.
  ///
  /// In en, this message translates to:
  /// **'Confirm your identity to sign in'**
  String get biometricReason;

  /// No description provided for @noSavedCredentials.
  ///
  /// In en, this message translates to:
  /// **'There are no saved credentials.'**
  String get noSavedCredentials;

  /// No description provided for @biometricFailed.
  ///
  /// In en, this message translates to:
  /// **'Biometric authentication could not be used: {error}'**
  String biometricFailed(String error);

  /// No description provided for @validatingAccess.
  ///
  /// In en, this message translates to:
  /// **'Validating access...'**
  String get validatingAccess;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @unauthorizedError.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized. Sign in again.'**
  String get unauthorizedError;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'Server error. Try again later.'**
  String get serverError;

  /// No description provided for @timeoutError.
  ///
  /// In en, this message translates to:
  /// **'The request timed out. Check your connection.'**
  String get timeoutError;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred.'**
  String get unexpectedError;

  /// No description provided for @missingUserIdError.
  ///
  /// In en, this message translates to:
  /// **'The user ID was not found in the session.'**
  String get missingUserIdError;

  /// No description provided for @userNotLoadedError.
  ///
  /// In en, this message translates to:
  /// **'The user has not been loaded yet.'**
  String get userNotLoadedError;

  /// No description provided for @remoteUpdateCacheError.
  ///
  /// In en, this message translates to:
  /// **'Remote data could not be updated. Showing cached data.'**
  String get remoteUpdateCacheError;

  /// No description provided for @projectsLoadError.
  ///
  /// In en, this message translates to:
  /// **'Projects could not be loaded: {error}'**
  String projectsLoadError(String error);

  /// No description provided for @projectsRefreshError.
  ///
  /// In en, this message translates to:
  /// **'Projects could not be refreshed: {error}'**
  String projectsRefreshError(String error);

  /// No description provided for @historyUpdated.
  ///
  /// In en, this message translates to:
  /// **'History updated successfully.'**
  String get historyUpdated;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get noData;

  /// No description provided for @unnamed.
  ///
  /// In en, this message translates to:
  /// **'(Unnamed)'**
  String get unnamed;

  /// No description provided for @idLabel.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get idLabel;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @end.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get end;

  /// No description provided for @ongoing.
  ///
  /// In en, this message translates to:
  /// **'Ongoing'**
  String get ongoing;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @technician.
  ///
  /// In en, this message translates to:
  /// **'Technician'**
  String get technician;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @parts.
  ///
  /// In en, this message translates to:
  /// **'Parts'**
  String get parts;

  /// No description provided for @evidence.
  ///
  /// In en, this message translates to:
  /// **'Evidence'**
  String get evidence;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @cache.
  ///
  /// In en, this message translates to:
  /// **'Cache'**
  String get cache;

  /// No description provided for @customers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get customers;

  /// No description provided for @customerDetail.
  ///
  /// In en, this message translates to:
  /// **'Customer Details'**
  String get customerDetail;

  /// No description provided for @customerNotFound.
  ///
  /// In en, this message translates to:
  /// **'Customer not found for ID: {id}'**
  String customerNotFound(String id);

  /// No description provided for @showingCache.
  ///
  /// In en, this message translates to:
  /// **'Showing cached data (offline or loading remote data)'**
  String get showingCache;

  /// No description provided for @customerType.
  ///
  /// In en, this message translates to:
  /// **'Customer type'**
  String get customerType;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @mobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get mobile;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @street.
  ///
  /// In en, this message translates to:
  /// **'Street'**
  String get street;

  /// No description provided for @cameraMessage.
  ///
  /// In en, this message translates to:
  /// **'Camera message'**
  String get cameraMessage;

  /// No description provided for @firstCameraImageUrl.
  ///
  /// In en, this message translates to:
  /// **'First camera image URL'**
  String get firstCameraImageUrl;

  /// No description provided for @offlineDetailNotice.
  ///
  /// In en, this message translates to:
  /// **'These details remain available offline because they come from the local cache.'**
  String get offlineDetailNotice;

  /// No description provided for @projects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get projects;

  /// No description provided for @projectDetail.
  ///
  /// In en, this message translates to:
  /// **'Project Details'**
  String get projectDetail;

  /// No description provided for @projectNotFound.
  ///
  /// In en, this message translates to:
  /// **'Project not found for ID: {id}'**
  String projectNotFound(String id);

  /// No description provided for @showingLocalCache.
  ///
  /// In en, this message translates to:
  /// **'Showing data from the local cache.'**
  String get showingLocalCache;

  /// No description provided for @noProjects.
  ///
  /// In en, this message translates to:
  /// **'No projects available.'**
  String get noProjects;

  /// No description provided for @projectName.
  ///
  /// In en, this message translates to:
  /// **'Project name'**
  String get projectName;

  /// No description provided for @createdAt.
  ///
  /// In en, this message translates to:
  /// **'Creation date'**
  String get createdAt;

  /// No description provided for @customerCode.
  ///
  /// In en, this message translates to:
  /// **'Customer code'**
  String get customerCode;

  /// No description provided for @mainInformation.
  ///
  /// In en, this message translates to:
  /// **'Main information'**
  String get mainInformation;

  /// No description provided for @nestedFields.
  ///
  /// In en, this message translates to:
  /// **'Nested fields'**
  String get nestedFields;

  /// No description provided for @firstWorkOrderId.
  ///
  /// In en, this message translates to:
  /// **'First Work Order ID'**
  String get firstWorkOrderId;

  /// No description provided for @firstWorkOrderName.
  ///
  /// In en, this message translates to:
  /// **'First Work Order name'**
  String get firstWorkOrderName;

  /// No description provided for @rawPreview.
  ///
  /// In en, this message translates to:
  /// **'Raw preview'**
  String get rawPreview;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// No description provided for @userDetail.
  ///
  /// In en, this message translates to:
  /// **'User Details'**
  String get userDetail;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'User not found for ID: {id}'**
  String userNotFound(String id);

  /// No description provided for @noUsers.
  ///
  /// In en, this message translates to:
  /// **'No users found'**
  String get noUsers;

  /// No description provided for @identification.
  ///
  /// In en, this message translates to:
  /// **'Identification'**
  String get identification;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @scheme.
  ///
  /// In en, this message translates to:
  /// **'Scheme'**
  String get scheme;

  /// No description provided for @companyId.
  ///
  /// In en, this message translates to:
  /// **'Company ID'**
  String get companyId;

  /// No description provided for @activeCluster.
  ///
  /// In en, this message translates to:
  /// **'Active cluster'**
  String get activeCluster;

  /// No description provided for @allowedClusterKeys.
  ///
  /// In en, this message translates to:
  /// **'Allowed Cluster Keys'**
  String get allowedClusterKeys;

  /// No description provided for @entryExitHistory.
  ///
  /// In en, this message translates to:
  /// **'Entry and Exit History'**
  String get entryExitHistory;

  /// No description provided for @fullJson.
  ///
  /// In en, this message translates to:
  /// **'Full JSON'**
  String get fullJson;

  /// No description provided for @selectOrScanInventory.
  ///
  /// In en, this message translates to:
  /// **'Select an item or scan a QR code'**
  String get selectOrScanInventory;

  /// No description provided for @inventoryInstructions.
  ///
  /// In en, this message translates to:
  /// **'The QR code must contain the inventory _id. You can also select the item directly from the list.'**
  String get inventoryInstructions;

  /// No description provided for @inventoryItem.
  ///
  /// In en, this message translates to:
  /// **'Inventory item'**
  String get inventoryItem;

  /// No description provided for @openCamera.
  ///
  /// In en, this message translates to:
  /// **'Open camera'**
  String get openCamera;

  /// No description provided for @inventoryLoadError.
  ///
  /// In en, this message translates to:
  /// **'Inventory could not be loaded'**
  String get inventoryLoadError;

  /// No description provided for @noItems.
  ///
  /// In en, this message translates to:
  /// **'No items'**
  String get noItems;

  /// No description provided for @noInventoryAvailable.
  ///
  /// In en, this message translates to:
  /// **'No inventory is available right now.'**
  String get noInventoryAvailable;

  /// No description provided for @quickView.
  ///
  /// In en, this message translates to:
  /// **'Quick view'**
  String get quickView;

  /// No description provided for @inventoryItemNotFound.
  ///
  /// In en, this message translates to:
  /// **'The item read from {source} does not exist in inventory.'**
  String inventoryItemNotFound(String source);

  /// No description provided for @inventorySummary.
  ///
  /// In en, this message translates to:
  /// **'{active} active out of {total} registered'**
  String inventorySummary(int active, int total);

  /// No description provided for @inventoryQuantities.
  ///
  /// In en, this message translates to:
  /// **'Default: {defaultQty} | Minimum stock: {stockMin}'**
  String inventoryQuantities(int defaultQty, int stockMin);

  /// No description provided for @inventoryDetail.
  ///
  /// In en, this message translates to:
  /// **'Inventory Details'**
  String get inventoryDetail;

  /// No description provided for @requestedItemNotFound.
  ///
  /// In en, this message translates to:
  /// **'The requested item was not found.'**
  String get requestedItemNotFound;

  /// No description provided for @selectedItem.
  ///
  /// In en, this message translates to:
  /// **'Selected item'**
  String get selectedItem;

  /// No description provided for @stockAdjustment.
  ///
  /// In en, this message translates to:
  /// **'Stock adjustment'**
  String get stockAdjustment;

  /// No description provided for @stockAdjustmentHelp.
  ///
  /// In en, this message translates to:
  /// **'Use the controls to adjust quantities or tap the number to enter a value.'**
  String get stockAdjustmentHelp;

  /// No description provided for @defaultQuantity.
  ///
  /// In en, this message translates to:
  /// **'Default quantity'**
  String get defaultQuantity;

  /// No description provided for @defaultQuantityHelp.
  ///
  /// In en, this message translates to:
  /// **'Quantity applied by default'**
  String get defaultQuantityHelp;

  /// No description provided for @minimumStock.
  ///
  /// In en, this message translates to:
  /// **'Minimum stock'**
  String get minimumStock;

  /// No description provided for @minimumStockHelp.
  ///
  /// In en, this message translates to:
  /// **'Recommended minimum level'**
  String get minimumStockHelp;

  /// No description provided for @invalidNumericValues.
  ///
  /// In en, this message translates to:
  /// **'Enter valid numeric values.'**
  String get invalidNumericValues;

  /// No description provided for @inventoryUpdated.
  ///
  /// In en, this message translates to:
  /// **'Inventory updated successfully.'**
  String get inventoryUpdated;

  /// No description provided for @scanQr.
  ///
  /// In en, this message translates to:
  /// **'Scan QR code'**
  String get scanQr;

  /// No description provided for @scanQrHelp.
  ///
  /// In en, this message translates to:
  /// **'Point at the item\'s QR code. The scanned value must be the inventory _id.'**
  String get scanQrHelp;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose the language used throughout the app.'**
  String get languageDescription;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// No description provided for @session.
  ///
  /// In en, this message translates to:
  /// **'Session'**
  String get session;

  /// No description provided for @sessionDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage your session and access.'**
  String get sessionDescription;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @logoutDescription.
  ///
  /// In en, this message translates to:
  /// **'This will clear your local session and take you to the login screen.'**
  String get logoutDescription;

  /// No description provided for @confirmation.
  ///
  /// In en, this message translates to:
  /// **'Confirmation'**
  String get confirmation;

  /// No description provided for @confirmLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get confirmLogout;

  /// No description provided for @loggingOut.
  ///
  /// In en, this message translates to:
  /// **'Logging out...'**
  String get loggingOut;

  /// No description provided for @assignedToYou.
  ///
  /// In en, this message translates to:
  /// **'Assigned to you'**
  String get assignedToYou;

  /// No description provided for @reviewWorkOrders.
  ///
  /// In en, this message translates to:
  /// **'Review and open the details of each work order.'**
  String get reviewWorkOrders;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select a date'**
  String get selectDate;

  /// No description provided for @noWorkOrders.
  ///
  /// In en, this message translates to:
  /// **'No Work Orders'**
  String get noWorkOrders;

  /// No description provided for @noWorkOrdersForDate.
  ///
  /// In en, this message translates to:
  /// **'There are no Work Orders for the selected date.'**
  String get noWorkOrdersForDate;

  /// No description provided for @tapForDetails.
  ///
  /// In en, this message translates to:
  /// **'Tap to view details'**
  String get tapForDetails;

  /// No description provided for @workOrderNotFound.
  ///
  /// In en, this message translates to:
  /// **'The Work Order was not found in memory/cache.'**
  String get workOrderNotFound;

  /// No description provided for @historyRecords.
  ///
  /// In en, this message translates to:
  /// **'History (records)'**
  String get historyRecords;

  /// No description provided for @timeHistory.
  ///
  /// In en, this message translates to:
  /// **'Time history'**
  String get timeHistory;

  /// No description provided for @noTimeRecords.
  ///
  /// In en, this message translates to:
  /// **'There are no time records.'**
  String get noTimeRecords;

  /// No description provided for @record.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get record;

  /// No description provided for @minutesShort.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String minutesShort(String minutes);

  /// No description provided for @customer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// No description provided for @project.
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get project;

  /// No description provided for @assignedTo.
  ///
  /// In en, this message translates to:
  /// **'Assigned to'**
  String get assignedTo;

  /// No description provided for @classLabel.
  ///
  /// In en, this message translates to:
  /// **'Class'**
  String get classLabel;

  /// No description provided for @customerName.
  ///
  /// In en, this message translates to:
  /// **'Customer name'**
  String get customerName;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastName;

  /// No description provided for @mainEmail.
  ///
  /// In en, this message translates to:
  /// **'Main email'**
  String get mainEmail;

  /// No description provided for @mainPhone.
  ///
  /// In en, this message translates to:
  /// **'Main phone'**
  String get mainPhone;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @generalInformation.
  ///
  /// In en, this message translates to:
  /// **'General information'**
  String get generalInformation;

  /// No description provided for @showCredentialsNotes.
  ///
  /// In en, this message translates to:
  /// **'Show credentials or notes'**
  String get showCredentialsNotes;

  /// No description provided for @timeAndScheduling.
  ///
  /// In en, this message translates to:
  /// **'Time and scheduling'**
  String get timeAndScheduling;

  /// No description provided for @technicalDetails.
  ///
  /// In en, this message translates to:
  /// **'Technical details'**
  String get technicalDetails;

  /// No description provided for @technicalNotes.
  ///
  /// In en, this message translates to:
  /// **'Technical notes'**
  String get technicalNotes;

  /// No description provided for @tasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasks;

  /// No description provided for @toDo.
  ///
  /// In en, this message translates to:
  /// **'To Do'**
  String get toDo;

  /// No description provided for @clockStatus.
  ///
  /// In en, this message translates to:
  /// **'Clock status'**
  String get clockStatus;

  /// No description provided for @workplace.
  ///
  /// In en, this message translates to:
  /// **'Workplace'**
  String get workplace;

  /// No description provided for @partsSpareParts.
  ///
  /// In en, this message translates to:
  /// **'Parts / Spare parts'**
  String get partsSpareParts;

  /// No description provided for @partsToDeliver.
  ///
  /// In en, this message translates to:
  /// **'Parts to deliver'**
  String get partsToDeliver;

  /// No description provided for @requestParts.
  ///
  /// In en, this message translates to:
  /// **'Request parts'**
  String get requestParts;

  /// No description provided for @usedParts.
  ///
  /// In en, this message translates to:
  /// **'Used parts (done)'**
  String get usedParts;

  /// No description provided for @requiredParts.
  ///
  /// In en, this message translates to:
  /// **'Pending / Required parts'**
  String get requiredParts;

  /// No description provided for @attachedImagesCount.
  ///
  /// In en, this message translates to:
  /// **'Attached images (count)'**
  String get attachedImagesCount;

  /// No description provided for @attachImages.
  ///
  /// In en, this message translates to:
  /// **'Attach images'**
  String get attachImages;

  /// No description provided for @uploaderPending.
  ///
  /// In en, this message translates to:
  /// **'Pending: uploader / camera (to be implemented later).'**
  String get uploaderPending;

  /// No description provided for @clientNotes.
  ///
  /// In en, this message translates to:
  /// **'Customer notes'**
  String get clientNotes;

  /// No description provided for @credentialsByCategory.
  ///
  /// In en, this message translates to:
  /// **'Credentials or notes by category'**
  String get credentialsByCategory;

  /// No description provided for @noCredentialsNotes.
  ///
  /// In en, this message translates to:
  /// **'There are no saved credentials or notes.'**
  String get noCredentialsNotes;

  /// No description provided for @notesCredentials.
  ///
  /// In en, this message translates to:
  /// **'Notes / credentials'**
  String get notesCredentials;

  /// No description provided for @notesHint.
  ///
  /// In en, this message translates to:
  /// **'Enter notes or credentials...'**
  String get notesHint;

  /// No description provided for @imagesCount.
  ///
  /// In en, this message translates to:
  /// **'Images ({count})'**
  String imagesCount(int count);

  /// No description provided for @noCategoryContent.
  ///
  /// In en, this message translates to:
  /// **'There is no content saved in this category.'**
  String get noCategoryContent;

  /// No description provided for @imageLoadError.
  ///
  /// In en, this message translates to:
  /// **'The image could not be loaded'**
  String get imageLoadError;

  /// No description provided for @noCustomerInformation.
  ///
  /// In en, this message translates to:
  /// **'No customer information is available.'**
  String get noCustomerInformation;

  /// No description provided for @timer.
  ///
  /// In en, this message translates to:
  /// **'Timer'**
  String get timer;

  /// No description provided for @activityInProgress.
  ///
  /// In en, this message translates to:
  /// **'Activity in progress'**
  String get activityInProgress;

  /// No description provided for @elapsedTime.
  ///
  /// In en, this message translates to:
  /// **'Elapsed time: {time}'**
  String elapsedTime(String time);

  /// No description provided for @pauseActivity.
  ///
  /// In en, this message translates to:
  /// **'Pause activity'**
  String get pauseActivity;

  /// No description provided for @shortBreak.
  ///
  /// In en, this message translates to:
  /// **'Short break / rest'**
  String get shortBreak;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @endOfDay.
  ///
  /// In en, this message translates to:
  /// **'End of day'**
  String get endOfDay;

  /// No description provided for @noRunningActivity.
  ///
  /// In en, this message translates to:
  /// **'There is no activity currently running.'**
  String get noRunningActivity;

  /// No description provided for @startTravel.
  ///
  /// In en, this message translates to:
  /// **'Start travel'**
  String get startTravel;

  /// No description provided for @travelStart.
  ///
  /// In en, this message translates to:
  /// **'Travel start'**
  String get travelStart;

  /// No description provided for @startWork.
  ///
  /// In en, this message translates to:
  /// **'Start work'**
  String get startWork;

  /// No description provided for @activityStart.
  ///
  /// In en, this message translates to:
  /// **'Activity start'**
  String get activityStart;

  /// No description provided for @activityStarted.
  ///
  /// In en, this message translates to:
  /// **'Activity started successfully.'**
  String get activityStarted;

  /// No description provided for @activityFinished.
  ///
  /// In en, this message translates to:
  /// **'Activity finished successfully.'**
  String get activityFinished;

  /// No description provided for @activityPaused.
  ///
  /// In en, this message translates to:
  /// **'Activity paused successfully.'**
  String get activityPaused;

  /// No description provided for @helloUser.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String helloUser(String name);

  /// No description provided for @offlineModeActive.
  ///
  /// In en, this message translates to:
  /// **'Offline mode is active. Some data may come from the cache.'**
  String get offlineModeActive;

  /// No description provided for @manageDay.
  ///
  /// In en, this message translates to:
  /// **'Manage your workday and review your Work Orders.'**
  String get manageDay;

  /// No description provided for @noInternetOffline.
  ///
  /// In en, this message translates to:
  /// **'No internet. Working offline.'**
  String get noInternetOffline;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternetConnection;

  /// No description provided for @noTodayWorkOrders.
  ///
  /// In en, this message translates to:
  /// **'You have no Work Orders scheduled for today.'**
  String get noTodayWorkOrders;

  /// No description provided for @locationDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location is disabled'**
  String get locationDisabled;

  /// No description provided for @locationServiceError.
  ///
  /// In en, this message translates to:
  /// **'Location is disabled. Enable it to continue.'**
  String get locationServiceError;

  /// No description provided for @locationDisabledMessage.
  ///
  /// In en, this message translates to:
  /// **'Location must be enabled to record Clock In/Out. Would you like to open location settings?'**
  String get locationDisabledMessage;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notNow;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open settings'**
  String get openSettings;

  /// No description provided for @permissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Permission required'**
  String get permissionRequired;

  /// No description provided for @locationPermissionMessage.
  ///
  /// In en, this message translates to:
  /// **'Location permission was permanently denied. Enable it in Settings to record Clock In/Out.'**
  String get locationPermissionMessage;

  /// No description provided for @clockOutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Do you want to Clock Out?'**
  String get clockOutConfirmation;

  /// No description provided for @clockIn.
  ///
  /// In en, this message translates to:
  /// **'Clock In'**
  String get clockIn;

  /// No description provided for @clockOut.
  ///
  /// In en, this message translates to:
  /// **'Clock Out'**
  String get clockOut;

  /// No description provided for @yesClockOut.
  ///
  /// In en, this message translates to:
  /// **'Yes, Clock Out'**
  String get yesClockOut;

  /// No description provided for @attention.
  ///
  /// In en, this message translates to:
  /// **'Attention'**
  String get attention;

  /// No description provided for @lastClockIn.
  ///
  /// In en, this message translates to:
  /// **'Last record: Clock In'**
  String get lastClockIn;

  /// No description provided for @lastClockOut.
  ///
  /// In en, this message translates to:
  /// **'Last record: Clock Out'**
  String get lastClockOut;

  /// No description provided for @lastRecord.
  ///
  /// In en, this message translates to:
  /// **'Last record'**
  String get lastRecord;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @noInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet'**
  String get noInternet;

  /// No description provided for @activeWorkday.
  ///
  /// In en, this message translates to:
  /// **'Active workday'**
  String get activeWorkday;

  /// No description provided for @noActiveWorkday.
  ///
  /// In en, this message translates to:
  /// **'No active workday'**
  String get noActiveWorkday;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @noTime.
  ///
  /// In en, this message translates to:
  /// **'No time'**
  String get noTime;

  /// No description provided for @clockInRecorded.
  ///
  /// In en, this message translates to:
  /// **'Clock In recorded'**
  String get clockInRecorded;

  /// No description provided for @clockOutRecorded.
  ///
  /// In en, this message translates to:
  /// **'Clock Out recorded'**
  String get clockOutRecorded;

  /// No description provided for @connectForClock.
  ///
  /// In en, this message translates to:
  /// **'Connect to the internet to record Clock In/Out.'**
  String get connectForClock;

  /// No description provided for @rememberClockOut.
  ///
  /// In en, this message translates to:
  /// **'Remember to Clock Out when you finish.'**
  String get rememberClockOut;

  /// No description provided for @clockInToStart.
  ///
  /// In en, this message translates to:
  /// **'Clock In to start your workday.'**
  String get clockInToStart;

  /// No description provided for @todayWorkOrders.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Work Orders'**
  String get todayWorkOrders;

  /// No description provided for @reasonRequiredValidation.
  ///
  /// In en, this message translates to:
  /// **'A reason is required.'**
  String get reasonRequiredValidation;

  /// No description provided for @reasonRequired.
  ///
  /// In en, this message translates to:
  /// **'Reason required'**
  String get reasonRequired;

  /// No description provided for @additionalClockInReasonHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the reason for the additional Clock In'**
  String get additionalClockInReasonHint;

  /// No description provided for @accessDenied.
  ///
  /// In en, this message translates to:
  /// **'No access'**
  String get accessDenied;

  /// No description provided for @modulePermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'You do not have the View and Read permissions required to access this section.'**
  String get modulePermissionRequired;

  /// No description provided for @timeReports.
  ///
  /// In en, this message translates to:
  /// **'Time reports'**
  String get timeReports;

  /// No description provided for @dailyTimeline.
  ///
  /// In en, this message translates to:
  /// **'Daily timeline'**
  String get dailyTimeline;

  /// No description provided for @noTimeReportsForDate.
  ///
  /// In en, this message translates to:
  /// **'There are no time reports for this date.'**
  String get noTimeReportsForDate;

  /// No description provided for @editTimeReport.
  ///
  /// In en, this message translates to:
  /// **'Edit time report'**
  String get editTimeReport;

  /// No description provided for @reportedTime.
  ///
  /// In en, this message translates to:
  /// **'Reported time'**
  String get reportedTime;

  /// No description provided for @entryType.
  ///
  /// In en, this message translates to:
  /// **'Clock in'**
  String get entryType;

  /// No description provided for @exitType.
  ///
  /// In en, this message translates to:
  /// **'Clock out'**
  String get exitType;

  /// No description provided for @timeReportUpdated.
  ///
  /// In en, this message translates to:
  /// **'Time report updated successfully.'**
  String get timeReportUpdated;

  /// No description provided for @updatePermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Update permission is required to edit reports.'**
  String get updatePermissionRequired;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @registerCustomerLocation.
  ///
  /// In en, this message translates to:
  /// **'Register customer location'**
  String get registerCustomerLocation;

  /// No description provided for @customerLocationConfirmation.
  ///
  /// In en, this message translates to:
  /// **'You are about to register the customer\'s location. Are you currently at the workplace?'**
  String get customerLocationConfirmation;

  /// No description provided for @showInMaps.
  ///
  /// In en, this message translates to:
  /// **'Show in Maps'**
  String get showInMaps;

  /// No description provided for @couldNotOpenMaps.
  ///
  /// In en, this message translates to:
  /// **'Maps could not be opened.'**
  String get couldNotOpenMaps;

  /// No description provided for @uploadingImagePercent.
  ///
  /// In en, this message translates to:
  /// **'Uploading image {percent}%'**
  String uploadingImagePercent(int percent);

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get takePhoto;

  /// No description provided for @noEvidenceImages.
  ///
  /// In en, this message translates to:
  /// **'This work order does not have any images yet.'**
  String get noEvidenceImages;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
