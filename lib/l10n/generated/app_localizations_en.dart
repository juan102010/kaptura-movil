// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Kaptura';

  @override
  String get workOrders => 'Work Orders';

  @override
  String get home => 'Home';

  @override
  String get inventory => 'Inventory';

  @override
  String get settings => 'Settings';

  @override
  String get welcome => 'Welcome';

  @override
  String get signInToContinue => 'Sign in to continue.';

  @override
  String get continueLabel => 'Continue';

  @override
  String get signIn => 'Sign in';

  @override
  String get email => 'Email';

  @override
  String get emailHint => 'you@email.com';

  @override
  String get enterEmail => 'Enter your email';

  @override
  String get invalidEmail => 'Invalid email';

  @override
  String get password => 'Password';

  @override
  String get enterPassword => 'Enter your password';

  @override
  String get passwordTooShort => 'Password is too short';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get login => 'Login';

  @override
  String get biometricLogin => 'Login with fingerprint';

  @override
  String get biometricReason => 'Confirm your identity to sign in';

  @override
  String get noSavedCredentials => 'There are no saved credentials.';

  @override
  String biometricFailed(String error) {
    return 'Biometric authentication could not be used: $error';
  }

  @override
  String get validatingAccess => 'Validating access...';

  @override
  String get error => 'Error';

  @override
  String get unauthorizedError => 'Unauthorized. Sign in again.';

  @override
  String get serverError => 'Server error. Try again later.';

  @override
  String get timeoutError => 'The request timed out. Check your connection.';

  @override
  String get unexpectedError => 'An unexpected error occurred.';

  @override
  String get missingUserIdError => 'The user ID was not found in the session.';

  @override
  String get userNotLoadedError => 'The user has not been loaded yet.';

  @override
  String get remoteUpdateCacheError =>
      'Remote data could not be updated. Showing cached data.';

  @override
  String projectsLoadError(String error) {
    return 'Projects could not be loaded: $error';
  }

  @override
  String projectsRefreshError(String error) {
    return 'Projects could not be refreshed: $error';
  }

  @override
  String get historyUpdated => 'History updated successfully.';

  @override
  String get refresh => 'Refresh';

  @override
  String get cancel => 'Cancel';

  @override
  String get accept => 'Accept';

  @override
  String get confirm => 'Confirm';

  @override
  String get ok => 'OK';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get saving => 'Saving...';

  @override
  String get noData => 'No data';

  @override
  String get unnamed => '(Unnamed)';

  @override
  String get idLabel => 'ID';

  @override
  String get type => 'Type';

  @override
  String get name => 'Name';

  @override
  String get status => 'Status';

  @override
  String get date => 'Date';

  @override
  String get start => 'Start';

  @override
  String get end => 'End';

  @override
  String get ongoing => 'Ongoing';

  @override
  String get general => 'General';

  @override
  String get time => 'Time';

  @override
  String get technician => 'Technician';

  @override
  String get location => 'Location';

  @override
  String get parts => 'Parts';

  @override
  String get evidence => 'Evidence';

  @override
  String get active => 'Active';

  @override
  String get inactive => 'Inactive';

  @override
  String get cache => 'Cache';

  @override
  String get customers => 'Customers';

  @override
  String get customerDetail => 'Customer Details';

  @override
  String customerNotFound(String id) {
    return 'Customer not found for ID: $id';
  }

  @override
  String get showingCache =>
      'Showing cached data (offline or loading remote data)';

  @override
  String get customerType => 'Customer type';

  @override
  String get phone => 'Phone';

  @override
  String get mobile => 'Mobile';

  @override
  String get city => 'City';

  @override
  String get state => 'State';

  @override
  String get country => 'Country';

  @override
  String get street => 'Street';

  @override
  String get cameraMessage => 'Camera message';

  @override
  String get firstCameraImageUrl => 'First camera image URL';

  @override
  String get offlineDetailNotice =>
      'These details remain available offline because they come from the local cache.';

  @override
  String get projects => 'Projects';

  @override
  String get projectDetail => 'Project Details';

  @override
  String projectNotFound(String id) {
    return 'Project not found for ID: $id';
  }

  @override
  String get showingLocalCache => 'Showing data from the local cache.';

  @override
  String get noProjects => 'No projects available.';

  @override
  String get projectName => 'Project name';

  @override
  String get createdAt => 'Creation date';

  @override
  String get customerCode => 'Customer code';

  @override
  String get mainInformation => 'Main information';

  @override
  String get nestedFields => 'Nested fields';

  @override
  String get firstWorkOrderId => 'First Work Order ID';

  @override
  String get firstWorkOrderName => 'First Work Order name';

  @override
  String get rawPreview => 'Raw preview';

  @override
  String get users => 'Users';

  @override
  String get userDetail => 'User Details';

  @override
  String userNotFound(String id) {
    return 'User not found for ID: $id';
  }

  @override
  String get noUsers => 'No users found';

  @override
  String get identification => 'Identification';

  @override
  String get role => 'Role';

  @override
  String get scheme => 'Scheme';

  @override
  String get companyId => 'Company ID';

  @override
  String get activeCluster => 'Active cluster';

  @override
  String get allowedClusterKeys => 'Allowed Cluster Keys';

  @override
  String get entryExitHistory => 'Entry and Exit History';

  @override
  String get fullJson => 'Full JSON';

  @override
  String get selectOrScanInventory => 'Select an item or scan a QR code';

  @override
  String get inventoryInstructions =>
      'The QR code must contain the inventory _id. You can also select the item directly from the list.';

  @override
  String get inventoryItem => 'Inventory item';

  @override
  String get openCamera => 'Open camera';

  @override
  String get inventoryLoadError => 'Inventory could not be loaded';

  @override
  String get noItems => 'No items';

  @override
  String get noInventoryAvailable => 'No inventory is available right now.';

  @override
  String get quickView => 'Quick view';

  @override
  String inventoryItemNotFound(String source) {
    return 'The item read from $source does not exist in inventory.';
  }

  @override
  String inventorySummary(int active, int total) {
    return '$active active out of $total registered';
  }

  @override
  String inventoryQuantities(int defaultQty, int stockMin) {
    return 'Default: $defaultQty | Minimum stock: $stockMin';
  }

  @override
  String get inventoryDetail => 'Inventory Details';

  @override
  String get requestedItemNotFound => 'The requested item was not found.';

  @override
  String get selectedItem => 'Selected item';

  @override
  String get stockAdjustment => 'Stock adjustment';

  @override
  String get stockAdjustmentHelp =>
      'Use the controls to adjust quantities or tap the number to enter a value.';

  @override
  String get defaultQuantity => 'Default quantity';

  @override
  String get defaultQuantityHelp => 'Quantity applied by default';

  @override
  String get minimumStock => 'Minimum stock';

  @override
  String get minimumStockHelp => 'Recommended minimum level';

  @override
  String get invalidNumericValues => 'Enter valid numeric values.';

  @override
  String get inventoryUpdated => 'Inventory updated successfully.';

  @override
  String get scanQr => 'Scan QR code';

  @override
  String get scanQrHelp =>
      'Point at the item\'s QR code. The scanned value must be the inventory _id.';

  @override
  String get language => 'Language';

  @override
  String get languageDescription =>
      'Choose the language used throughout the app.';

  @override
  String get english => 'English';

  @override
  String get spanish => 'Spanish';

  @override
  String get session => 'Session';

  @override
  String get sessionDescription => 'Manage your session and access.';

  @override
  String get logout => 'Log out';

  @override
  String get logoutDescription =>
      'This will clear your local session and take you to the login screen.';

  @override
  String get confirmation => 'Confirmation';

  @override
  String get confirmLogout => 'Are you sure you want to log out?';

  @override
  String get loggingOut => 'Logging out...';

  @override
  String get assignedToYou => 'Assigned to you';

  @override
  String get reviewWorkOrders =>
      'Review and open the details of each work order.';

  @override
  String get selectDate => 'Select a date';

  @override
  String get noWorkOrders => 'No Work Orders';

  @override
  String get noWorkOrdersForDate =>
      'There are no Work Orders for the selected date.';

  @override
  String get tapForDetails => 'Tap to view details';

  @override
  String get workOrderNotFound =>
      'The Work Order was not found in memory/cache.';

  @override
  String get historyRecords => 'History (records)';

  @override
  String get timeHistory => 'Time history';

  @override
  String get noTimeRecords => 'There are no time records.';

  @override
  String get record => 'Record';

  @override
  String minutesShort(String minutes) {
    return '$minutes min';
  }

  @override
  String get customer => 'Customer';

  @override
  String get project => 'Project';

  @override
  String get assignedTo => 'Assigned to';

  @override
  String get classLabel => 'Class';

  @override
  String get customerName => 'Customer name';

  @override
  String get firstName => 'First name';

  @override
  String get lastName => 'Last name';

  @override
  String get mainEmail => 'Main email';

  @override
  String get mainPhone => 'Main phone';

  @override
  String get address => 'Address';

  @override
  String get generalInformation => 'General information';

  @override
  String get showCredentialsNotes => 'Show credentials or notes';

  @override
  String get timeAndScheduling => 'Time and scheduling';

  @override
  String get technicalDetails => 'Technical details';

  @override
  String get technicalNotes => 'Technical notes';

  @override
  String get tasks => 'Tasks';

  @override
  String get toDo => 'To Do';

  @override
  String get clockStatus => 'Clock status';

  @override
  String get workplace => 'Workplace';

  @override
  String get partsSpareParts => 'Parts / Spare parts';

  @override
  String get partsToDeliver => 'Parts to deliver';

  @override
  String get requestParts => 'Request parts';

  @override
  String get usedParts => 'Used parts (done)';

  @override
  String get requiredParts => 'Pending / Required parts';

  @override
  String get attachedImagesCount => 'Attached images (count)';

  @override
  String get attachImages => 'Attach images';

  @override
  String get uploaderPending =>
      'Pending: uploader / camera (to be implemented later).';

  @override
  String get clientNotes => 'Customer notes';

  @override
  String get credentialsByCategory => 'Credentials or notes by category';

  @override
  String get noCredentialsNotes => 'There are no saved credentials or notes.';

  @override
  String get notesCredentials => 'Notes / credentials';

  @override
  String get notesHint => 'Enter notes or credentials...';

  @override
  String imagesCount(int count) {
    return 'Images ($count)';
  }

  @override
  String get noCategoryContent => 'There is no content saved in this category.';

  @override
  String get imageLoadError => 'The image could not be loaded';

  @override
  String get noCustomerInformation => 'No customer information is available.';

  @override
  String get timer => 'Timer';

  @override
  String get activityInProgress => 'Activity in progress';

  @override
  String elapsedTime(String time) {
    return 'Elapsed time: $time';
  }

  @override
  String get pauseActivity => 'Pause activity';

  @override
  String get shortBreak => 'Short break / rest';

  @override
  String get finish => 'Finish';

  @override
  String get endOfDay => 'End of day';

  @override
  String get noRunningActivity => 'There is no activity currently running.';

  @override
  String get startTravel => 'Start travel';

  @override
  String get travelStart => 'Travel start';

  @override
  String get startWork => 'Start work';

  @override
  String get activityStart => 'Activity start';

  @override
  String get activityStarted => 'Activity started successfully.';

  @override
  String get activityFinished => 'Activity finished successfully.';

  @override
  String get activityPaused => 'Activity paused successfully.';

  @override
  String helloUser(String name) {
    return 'Hello, $name';
  }

  @override
  String get offlineModeActive =>
      'Offline mode is active. Some data may come from the cache.';

  @override
  String get manageDay => 'Manage your workday and review your Work Orders.';

  @override
  String get noInternetOffline => 'No internet. Working offline.';

  @override
  String get noInternetConnection => 'No internet connection';

  @override
  String get noTodayWorkOrders =>
      'You have no Work Orders scheduled for today.';

  @override
  String get locationDisabled => 'Location is disabled';

  @override
  String get locationServiceError =>
      'Location is disabled. Enable it to continue.';

  @override
  String get locationDisabledMessage =>
      'Location must be enabled to record Clock In/Out. Would you like to open location settings?';

  @override
  String get notNow => 'Not now';

  @override
  String get openSettings => 'Open settings';

  @override
  String get permissionRequired => 'Permission required';

  @override
  String get locationPermissionMessage =>
      'Location permission was permanently denied. Enable it in Settings to record Clock In/Out.';

  @override
  String get clockOutConfirmation => 'Do you want to Clock Out?';

  @override
  String get clockIn => 'Clock In';

  @override
  String get clockOut => 'Clock Out';

  @override
  String get yesClockOut => 'Yes, Clock Out';

  @override
  String get attention => 'Attention';

  @override
  String get lastClockIn => 'Last record: Clock In';

  @override
  String get lastClockOut => 'Last record: Clock Out';

  @override
  String get lastRecord => 'Last record';

  @override
  String get user => 'User';

  @override
  String get noInternet => 'No internet';

  @override
  String get activeWorkday => 'Active workday';

  @override
  String get noActiveWorkday => 'No active workday';

  @override
  String get offline => 'Offline';

  @override
  String get noTime => 'No time';

  @override
  String get clockInRecorded => 'Clock In recorded';

  @override
  String get clockOutRecorded => 'Clock Out recorded';

  @override
  String get connectForClock =>
      'Connect to the internet to record Clock In/Out.';

  @override
  String get rememberClockOut => 'Remember to Clock Out when you finish.';

  @override
  String get clockInToStart => 'Clock In to start your workday.';

  @override
  String get todayWorkOrders => 'Today\'s Work Orders';

  @override
  String get reasonRequiredValidation => 'A reason is required.';

  @override
  String get reasonRequired => 'Reason required';

  @override
  String get additionalClockInReasonHint =>
      'Enter the reason for the additional Clock In';

  @override
  String get accessDenied => 'No access';

  @override
  String get modulePermissionRequired =>
      'You do not have the View and Read permissions required to access this section.';

  @override
  String get timeReports => 'Time reports';

  @override
  String get dailyTimeline => 'Daily timeline';

  @override
  String get noTimeReportsForDate => 'There are no time reports for this date.';

  @override
  String get editTimeReport => 'Edit time report';

  @override
  String get reportedTime => 'Reported time';

  @override
  String get entryType => 'Clock in';

  @override
  String get exitType => 'Clock out';

  @override
  String get timeReportUpdated => 'Time report updated successfully.';

  @override
  String get updatePermissionRequired =>
      'Update permission is required to edit reports.';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get registerCustomerLocation => 'Register customer location';

  @override
  String get customerLocationConfirmation =>
      'You are about to register the customer\'s location. Are you currently at the workplace?';

  @override
  String get showInMaps => 'Show in Maps';

  @override
  String get couldNotOpenMaps => 'Maps could not be opened.';

  @override
  String uploadingImagePercent(int percent) {
    return 'Uploading image $percent%';
  }

  @override
  String get takePhoto => 'Take photo';

  @override
  String get noEvidenceImages =>
      'This work order does not have any images yet.';
}
