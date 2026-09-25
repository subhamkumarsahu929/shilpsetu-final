import 'package:shilpsetu/core/localization/language_provider.dart';

/// Centralized, type-safe multi-language strings for Shilpsetu.
/// Supports all 8 official languages: Hindi, English, Gujarati, Bengali,
/// Telugu, Tamil, Odia, Marathi.
abstract class AppStrings {
  const AppStrings();

  static AppStrings of(AppLanguage language) {
    switch (language) {
      case AppLanguage.hindi:
        return const _AppStringsHi();
      case AppLanguage.english:
        return const _AppStringsEn();
      case AppLanguage.gujarati:
        return const _AppStringsGu();
      case AppLanguage.bengali:
        return const _AppStringsBn();
      case AppLanguage.telugu:
        return const _AppStringsTe();
      case AppLanguage.tamil:
        return const _AppStringsTa();
      case AppLanguage.odia:
        return const _AppStringsOr();
      case AppLanguage.marathi:
        return const _AppStringsMr();
    }
  }

  // --- App Branding & General ---
  String get appTitle;
  String get artisanFallback;
  String get continueButton;
  String get saveChanges;
  String get cancelButton;
  String get retryButton;
  String get closeButton;
  String get editButton;
  String get offlineBadge;

  // --- Navigation Bar ---
  String get navHome;
  String get navCapture;
  String get navCatalog;
  String get navOrders;

  // --- Language Selection Screen ---
  String get chooseLanguagePrompt;
  String get setupProfile;

  // --- Home Screen ---
  String greeting(String name);
  String get whatWillYouMake;
  String get homeOverviewTooltip;
  String homeOverviewSpeech(String name);
  String get voiceCatalogingTag;
  String get voiceCatalogingTitle;
  String get voiceCatalogingSubtitle;
  String get voiceCatalogingButton;
  String get voiceCatalogingSpeech;
  String get smartArtisanTools;
  String get priceCalculatorTag;
  String get priceCalculatorTitle;
  String get priceCalculatorSubtitle;
  String get priceCalculatorButton;
  String get priceCalculatorSpeech;
  String get offlineRecogTag;
  String get offlineRecogTitle;
  String get offlineRecogSubtitle;
  String get offlineRecogButton;
  String get offlineRecogSpeech;
  String get studioTag;
  String get studioTitle;
  String get studioSubtitle;
  String get studioButton;
  String get studioSpeech;

  // --- Auth Screen ---
  String authPrompt(bool isRegister);
  String authPromptSpeech(bool isRegister);
  String get registerTab;
  String get loginTab;
  String get fullNameLabel;
  String get fullNameHint;
  String get phoneLabel;
  String get phoneHint;
  String get craftCategoryLabel;
  List<String> get craftOptions;
  String get joinShilpsetu;
  String get loginButton;
  String get offlineSyncNotice;
  String get nameError;
  String get phoneError;
  String welcomeUser(String name);

  // --- Capture Screen ---
  String get capturePrompt;
  String get captureInstructionsTooltip;
  String get captureInstructionsSpeech;
  String get capturePromptReplay;
  String get pointCamera;
  String get qualityBlur;
  String get qualityTooDark;
  String get qualityBacklight;
  String get qualityReady;
  String get offlineMlActive;
  String get switchCamera;
  String get tapToCapture;
  String get retakePhoto;
  String get confirmPhoto;

  // --- Cataloger Screen (Step 2 Voice/Description) ---
  String get step2StoryBadge;
  String get step2Prompt;
  String get choiceAPhotoOnlyTag;
  String get choiceAPhotoOnlyTitle;
  String get choiceAPhotoOnlySubtitle;
  String get choiceAPhotoOnlyButton;
  String get choiceAPhotoOnlySpeech;
  String get choiceBVoiceTag;
  String get choiceBVoiceTitle;
  String get choiceBVoiceSubtitle;
  String choiceBVoiceButton(bool isRecording);
  String get recordingInProgress;
  String get descriptionPreviewTitle;
  String get listenDescription;
  String get continueToPricingButton;
  String get continueToPricingSubtitle;

  // --- Pricing Screen (Step 3 Fair Wage Pricing) ---
  String get step3PricingBadge;
  String get step3Prompt;
  String get step3PricingSpeech;
  String get materialCostTitle;
  String get materialCostSubtitle;
  String get materialCostLabel;
  String get desiredProfitTitle;
  String get desiredProfitSubtitle;
  String get targetProfitLabel;
  String get costProfitAnalysisTitle;
  String get tierFloorTitle;
  String get tierFloorBadge;
  String get tierFloorDesc;
  String get tierSuggestedTitle;
  String get tierSuggestedBadge;
  String get tierSuggestedDesc;
  String get tierStretchTitle;
  String get tierStretchBadge;
  String get tierStretchDesc;
  String publishButton(bool isPublishing);
  String get publishSubtitle;
  String get listingPublishedSuccess;

  // --- Catalog Screen ---
  String catalogOverviewSpeech(int count);
  String get myCraftShowroomTag;
  String get myCraftShowroomTitle;
  String get myCraftShowroomSubtitle;
  String get addNewCraftButton;
  String get statTotalCrafts;
  String get statFairTotal;
  String get statAvgMargin;
  String get filterAll;
  String get filterPublished;
  String get filterDrafts;
  String get emptyCatalogTitle;
  String get emptyCatalogSubtitle;
  String get emptyCatalogButton;
  String get fairWageBadge;
  String get suggestedPriceLabel;
  String get inquiriesButton;

  // --- Enquiries Screen ---
  String get ordersPrompt;
  String get filterAllOrders;
  String get filterPending;
  String get filterConfirmed;
  String get buyerOfferedPrice;
  String get replyWhatsApp;
  String get callBuyer;
  String get markCompleted;
  String get noOrdersTitle;
  String get noOrdersSubtitle;

  // --- App Info Menu & Account Sheet ---
  String get appInfoTooltip;
  String get appInfoTitle;
  String get accountDetailsTitle;
  String get changeLanguageTile;
  String get changeLanguageSubtitle;
  String get offlineStatusTile;
  String get offlineStatusSubtitle;
  String get aboutTile;
  String get aboutSubtitle;
  String get logoutTile;
  String get logoutConfirm;
}

// ============================================================================
// ENGLISH IMPLEMENTATION
// ============================================================================
class _AppStringsEn extends AppStrings {
  const _AppStringsEn();

  @override
  String get appTitle => 'Shilpsetu';
  @override
  String get artisanFallback => 'Artisan';
  @override
  String get continueButton => 'Continue';
  @override
  String get saveChanges => 'Save Changes';
  @override
  String get cancelButton => 'Cancel';
  @override
  String get retryButton => 'Retry';
  @override
  String get closeButton => 'Close';
  @override
  String get editButton => 'Edit';
  @override
  String get offlineBadge => 'Offline Ready';

  @override
  String get navHome => 'Home';
  @override
  String get navCapture => 'Capture';
  @override
  String get navCatalog => 'Products';
  @override
  String get navOrders => 'Orders';

  @override
  String get chooseLanguagePrompt => 'Choose your preferred language';
  @override
  String get setupProfile => 'Set up your craft profile';

  @override
  String greeting(String name) => 'Namaste, $name';
  @override
  String get whatWillYouMake => 'What will you make today?';
  @override
  String get homeOverviewTooltip => 'Listen overview';
  @override
  String homeOverviewSpeech(String name) =>
      'Namaste, $name. What will you make today? Use your voice, check fair pricing, or recognize crafts.';
  @override
  String get voiceCatalogingTag => 'VOICE-FIRST CATALOGING';
  @override
  String get voiceCatalogingTitle => 'Add your\ncraft';
  @override
  String get voiceCatalogingSubtitle => "Speak your story. We'll shape the rest.";
  @override
  String get voiceCatalogingButton => 'Begin with your voice';
  @override
  String get voiceCatalogingSpeech =>
      "Add your craft. Speak your story, we'll shape the rest.";
  @override
  String get smartArtisanTools => 'SMART ARTISAN TOOLS';
  @override
  String get priceCalculatorTag => '🛡️ GOVT MINIMUM WAGE BASE';
  @override
  String get priceCalculatorTitle => 'Fair Price\nCalculator';
  @override
  String get priceCalculatorSubtitle =>
      'Know your true artisan worth. Never sell below fair wage.';
  @override
  String get priceCalculatorButton => 'Check Fair Price';
  @override
  String get priceCalculatorSpeech =>
      'Fair Price Calculator. Know your true worth, based on government minimum wage.';
  @override
  String get offlineRecogTag => '📶 100% OFFLINE RECOGNITION';
  @override
  String get offlineRecogTitle => 'Recognize\nYour Craft';
  @override
  String get offlineRecogSubtitle =>
      'Take a photo, we identify craft techniques offline.';
  @override
  String get offlineRecogButton => 'Recognize Craft';
  @override
  String get offlineRecogSpeech =>
      'Recognize Your Craft. Take a photo, works 100% offline without internet.';
  @override
  String get studioTag => '⚡ 320MS STUDIO FINISH';
  @override
  String get studioTitle => 'Studio Photo\nEnhancer';
  @override
  String get studioSubtitle =>
      'Turn simple home photos into clean marketplace listings.';
  @override
  String get studioButton => 'Open Studio';
  @override
  String get studioSpeech =>
      'Studio Photo Enhancer. Turn home photos into clean marketplace listings in 320ms.';

  @override
  String authPrompt(bool isRegister) => isRegister
      ? 'Enter your name and mobile number'
      : 'Enter your registered mobile number';
  @override
  String authPromptSpeech(bool isRegister) => isRegister
      ? 'Please enter your full name and 10-digit mobile number to join Shilpsetu.'
      : 'Please enter your 10-digit mobile number to log in.';
  @override
  String get registerTab => 'Register';
  @override
  String get loginTab => 'Login';
  @override
  String get fullNameLabel => 'Artisan Full Name *';
  @override
  String get fullNameHint => 'e.g. Radhabai Kumbhar';
  @override
  String get phoneLabel => 'Mobile Number *';
  @override
  String get phoneHint => '10-digit mobile number';
  @override
  String get craftCategoryLabel => 'Primary Craft Category';
  @override
  List<String> get craftOptions => const [
        'Pottery & Clay Work',
        'Handloom & Weaving',
        'Wood & Bamboo Craft',
        'Jewelry & Beading',
        'Embroidery & Textile Art',
        'Metalwork & Bell Metal',
        'Leather & Jute Craft',
        'Stone Carving & Sculpting',
        'Other Traditional Craft',
      ];
  @override
  String get joinShilpsetu => 'Join Shilpsetu';
  @override
  String get loginButton => 'Log In to Account';
  @override
  String get offlineSyncNotice =>
      'Works offline • Free government marketplace bridge';
  @override
  String get nameError => 'Please enter a valid full name (minimum 2 letters)';
  @override
  String get phoneError => 'Please enter a valid 10-digit mobile number';
  @override
  String welcomeUser(String name) => 'Welcome $name to Shilpsetu!';

  @override
  String get capturePrompt => 'Show what you made';
  @override
  String get captureInstructionsTooltip => 'Listen instructions';
  @override
  String get captureInstructionsSpeech =>
      'Show what you made. Center the craft in the frame and tap the camera button to take a photo.';
  @override
  String get capturePromptReplay =>
      'Show what you made. Center the craft in the frame and tap the camera button.';
  @override
  String get pointCamera => 'Point camera at your craft';
  @override
  String get qualityBlur => 'Photo is blurry. Please hold steady.';
  @override
  String get qualityTooDark => 'Too dark. Please move towards light.';
  @override
  String get qualityBacklight => 'Backlight detected. Face towards light.';
  @override
  String get qualityReady => 'Ready to capture';
  @override
  String get offlineMlActive => 'On-Device AI Active';
  @override
  String get switchCamera => 'Switch Camera';
  @override
  String get tapToCapture => 'Tap to Capture Photo';
  @override
  String get retakePhoto => 'Retake Photo';
  @override
  String get confirmPhoto => 'Confirm & Continue';

  @override
  String get step2StoryBadge => 'Step 2: Craft Story';
  @override
  String get step2Prompt => 'Step 2: Tell your craft story';
  @override
  String get choiceAPhotoOnlyTag => '⚡ INSTANT AI VISION';
  @override
  String get choiceAPhotoOnlyTitle => 'Describe from Photo';
  @override
  String get choiceAPhotoOnlySubtitle =>
      'Model detects craft style, colors, and materials automatically.';
  @override
  String get choiceAPhotoOnlyButton => 'Auto-Generate Details';
  @override
  String get choiceAPhotoOnlySpeech =>
      'Analyzing photo with vision model to suggest description...';
  @override
  String get choiceBVoiceTag => '🎙️ YOUR VOICE STORY';
  @override
  String get choiceBVoiceTitle => 'Record Voice Note';
  @override
  String get choiceBVoiceSubtitle =>
      'Speak naturally in your mother tongue about how you made it.';
  @override
  String choiceBVoiceButton(bool isRecording) =>
      isRecording ? 'Tap to Stop Recording' : 'Speak Your Story';
  @override
  String get recordingInProgress => 'Listening... Speak about your craft';
  @override
  String get descriptionPreviewTitle => 'Craft Description & Attributes';
  @override
  String get listenDescription => 'Listen Description';
  @override
  String get continueToPricingButton => 'Continue to Fair Wage Pricing';
  @override
  String get continueToPricingSubtitle => 'Calculate transparent minimum price';

  @override
  String get step3PricingBadge => 'Step 3: Pricing';
  @override
  String get step3Prompt => 'Step 3: Fair Wage Pricing Model';
  @override
  String get step3PricingSpeech =>
      'Fair Wage Pricing. Set your material cost and profit to see government-backed minimum, suggested, and stretch prices.';
  @override
  String get materialCostTitle => 'Raw Material Cost';
  @override
  String get materialCostSubtitle => 'Clay, glaze, wood, cloth, paints, fuel';
  @override
  String get materialCostLabel => 'Material Cost';
  @override
  String get desiredProfitTitle => 'Your Desired Profit';
  @override
  String get desiredProfitSubtitle => 'Fair wage for artisan mastery and labor';
  @override
  String get targetProfitLabel => 'Target Profit';
  @override
  String get costProfitAnalysisTitle => 'Cost & Profit Analysis';
  @override
  String get tierFloorTitle => 'Minimum Fair Wage';
  @override
  String get tierFloorBadge => 'Fair Minimum';
  @override
  String get tierFloorDesc =>
      'Below this floor, artisan labor is underpaid per national wage rates.';
  @override
  String get tierSuggestedTitle => 'Market Suggested Price';
  @override
  String get tierSuggestedBadge => '⭐ Recommended';
  @override
  String get tierSuggestedDesc =>
      'Balanced for healthy artisan margin and strong market demand.';
  @override
  String get tierStretchTitle => 'Premium Stretch Price';
  @override
  String get tierStretchBadge => 'Boutique';
  @override
  String get tierStretchDesc =>
      'Targeted for urban exhibition, premium craft buyers, and exports.';
  @override
  String publishButton(bool isPublishing) =>
      isPublishing ? 'Publishing...' : 'Publish Listing';
  @override
  String get publishSubtitle => 'Add craft to your digital catalog';
  @override
  String get listingPublishedSuccess =>
      'Craft listing successfully published to your catalog!';

  @override
  String catalogOverviewSpeech(int count) =>
      'You have $count craft products listed. Tap any product to hear full details.';
  @override
  String get myCraftShowroomTag => 'MY CRAFT SHOWROOM';
  @override
  String get myCraftShowroomTitle => 'Handcrafted\nCollection';
  @override
  String get myCraftShowroomSubtitle =>
      'Fair prices, real stories, verified craft technique.';
  @override
  String get addNewCraftButton => 'Add New Craft';
  @override
  String get statTotalCrafts => 'Total Crafts';
  @override
  String get statFairTotal => 'Fair Value';
  @override
  String get statAvgMargin => 'Avg Margin';
  @override
  String get filterAll => 'All Crafts';
  @override
  String get filterPublished => 'Live Products';
  @override
  String get filterDrafts => 'Drafts';
  @override
  String get emptyCatalogTitle => 'No crafts listed yet';
  @override
  String get emptyCatalogSubtitle =>
      'Tap the camera button below to photograph your first craft.';
  @override
  String get emptyCatalogButton => 'Capture First Craft';
  @override
  String get fairWageBadge => 'Fair Wage Verified';
  @override
  String get suggestedPriceLabel => 'Suggested Price';
  @override
  String get inquiriesButton => 'View Inquiries';

  @override
  String get ordersPrompt => 'Buyer Orders & Inquiries';
  @override
  String get filterAllOrders => 'All';
  @override
  String get filterPending => 'New Orders';
  @override
  String get filterConfirmed => 'Confirmed';
  @override
  String get buyerOfferedPrice => 'Buyer Offered Price';
  @override
  String get replyWhatsApp => 'Reply on WhatsApp';
  @override
  String get callBuyer => 'Call Buyer';
  @override
  String get markCompleted => 'Mark Completed';
  @override
  String get noOrdersTitle => 'No new inquiries right now';
  @override
  String get noOrdersSubtitle =>
      'When buyers see your catalog, incoming purchase inquiries will appear here.';

  @override
  String get appInfoTooltip => 'App Info & Account';
  @override
  String get appInfoTitle => 'App Info & Account';
  @override
  String get accountDetailsTitle => 'Account Details';
  @override
  String get changeLanguageTile => 'Change App Language';
  @override
  String get changeLanguageSubtitle => 'Select your native mother tongue';
  @override
  String get offlineStatusTile => 'Offline Mode';
  @override
  String get offlineStatusSubtitle => '100% active, syncs when network is available';
  @override
  String get aboutTile => 'About Shilpsetu';
  @override
  String get aboutSubtitle => 'Government of India Digital Artisan On-ramp';
  @override
  String get logoutTile => 'Log Out';
  @override
  String get logoutConfirm => 'Are you sure you want to log out?';
}

// ============================================================================
// GUJARATI IMPLEMENTATION (ગુજરાતી)
// ============================================================================
class _AppStringsGu extends AppStrings {
  const _AppStringsGu();

  @override
  String get appTitle => 'શિલ્પસેતુ';
  @override
  String get artisanFallback => 'કારીગર';
  @override
  String get continueButton => 'આગળ વધો';
  @override
  String get saveChanges => 'ફેરફાર સાચવો';
  @override
  String get cancelButton => 'રદ કરો';
  @override
  String get retryButton => 'ફરી પ્રયાસ કરો';
  @override
  String get closeButton => 'બંધ કરો';
  @override
  String get editButton => 'સુધારો';
  @override
  String get offlineBadge => 'ઓફલાઇન તૈયાર';

  @override
  String get navHome => 'હોમ';
  @override
  String get navCapture => 'ફોટો';
  @override
  String get navCatalog => 'ઉત્પાદો';
  @override
  String get navOrders => 'ઓર્ડર';

  @override
  String get chooseLanguagePrompt => 'તમારી ભાષા પસંદ કરો';
  @override
  String get setupProfile => 'તમારી કારીગરી પ્રોફાઇલ બનાવો';

  @override
  String greeting(String name) => 'નમસ્તે, $name';
  @override
  String get whatWillYouMake => 'આજે તમે શું બનાવશો?';
  @override
  String get homeOverviewTooltip => 'માહિતી સાંભળો';
  @override
  String homeOverviewSpeech(String name) =>
      'નમસ્તે, $name. આજે તમે શું બનાવશો? બોલીને ઉત્પાદ ઉમેરો, ઉચિત ભાવ જાણો અથવા શિલ્પ ઓળખો.';
  @override
  String get voiceCatalogingTag => 'આવાજથી ઉત્પાદ યાદી';
  @override
  String get voiceCatalogingTitle => 'તમારો શિલ્પ\nઉમેરો';
  @override
  String get voiceCatalogingSubtitle =>
      'તમારી વાર્તા કહો, બાકી અમે તૈયાર કરીશું.';
  @override
  String get voiceCatalogingButton => 'બોલીને શરૂ કરો';
  @override
  String get voiceCatalogingSpeech =>
      'તમારો શિલ્પ ઉમેરો. તમારી વાર્તા કહો, બાકી વિગતો અમે તૈયાર કરીશું.';
  @override
  String get smartArtisanTools => 'સ્માર્ટ કારીગર ટૂલ્સ';
  @override
  String get priceCalculatorTag => '🛡️ સરકારી ન્યૂનતમ વેતન આધાર';
  @override
  String get priceCalculatorTitle => 'ઉચિત ભાવ\nકેલ્ક્યુલેટર';
  @override
  String get priceCalculatorSubtitle =>
      'તમારા શ્રમનું સાચું મૂલ્ય જાણો. ક્યારેય ઓછાં ભાવે ન વેચો.';
  @override
  String get priceCalculatorButton => 'ઉચિત ભાવ તપાસો';
  @override
  String get priceCalculatorSpeech =>
      'ઉચિત ભાવ કેલ્ક્યુલેટર. સરકારી ન્યૂનતમ વેતન આધારે તમારા શ્રમનું સાચું મૂલ્ય જાણો.';
  @override
  String get offlineRecogTag => '📶 ૧૦૦% ઓફલાઇન ઓળખ';
  @override
  String get offlineRecogTitle => 'શિલ્પ\nઓળખો';
  @override
  String get offlineRecogSubtitle =>
      'ફોટો પાડો, અમે ઇન્ટરનેટ વગર શિલ્પ તકનીક ઓળખીશું.';
  @override
  String get offlineRecogButton => 'શિલ્પ ઓળખો';
  @override
  String get offlineRecogSpeech =>
      'શિલ્પ ઓળખો. ફોટો પાડો, તે ઇન્ટરનેટ વિના ૧૦૦% ઓફલાઇન કામ કરે છે.';
  @override
  String get studioTag => '⚡ ૩૨૦MS સ્ટુડિયો ફિનિશ';
  @override
  String get studioTitle => 'સ્ટુડિયો ફોટો\nફિનિશર';
  @override
  String get studioSubtitle =>
      'ઘરના સાદા ફોટાને બજાર જેવા સાફ અને આકર્ષક બનાવો.';
  @override
  String get studioButton => 'સ્ટુડિયો ખોલો';
  @override
  String get studioSpeech =>
      'સ્ટુડિયો ફોટો ફિનિશર. ઘરના સાદા ફોટાને બજાર જેવો સ્વચ્છ બનાવો.';

  @override
  String authPrompt(bool isRegister) => isRegister
      ? 'તમારું નામ અને મોબાઇલ નંબર દાખલ કરો'
      : 'તમારો નોંધાયેલ મોબાઇલ નંબર દાખલ કરો';
  @override
  String authPromptSpeech(bool isRegister) => isRegister
      ? 'શિલ્પસેતુમાં જોડાવા માટે કૃપા કરીને તમારું પૂરું નામ અને દસ આંકડાનો મોબાઇલ નંબર દાખલ કરો.'
      : 'લૉગ ઇન કરવા માટે તમારો દસ આંકડાનો મોબાઇલ નંબર દાખલ કરો.';
  @override
  String get registerTab => 'નવી નોંધણી';
  @override
  String get loginTab => 'લૉગ ઇન';
  @override
  String get fullNameLabel => 'કારીગરનું પૂરું નામ *';
  @override
  String get fullNameHint => 'દા.ત. રાધાબહેન કુંભાર';
  @override
  String get phoneLabel => 'મોબાઇલ નંબર *';
  @override
  String get phoneHint => '૧૦ આંકડાનો મોબાઇલ નંબર';
  @override
  String get craftCategoryLabel => 'મુખ્ય શિલ્પ શ્રેણી';
  @override
  List<String> get craftOptions => const [
        'માટીકામ અને કુંભારીકામ',
        'હાથશાળ અને વણાટકામ',
        'લાકડું અને વાંસકામ',
        'દાગીના અને મણકાકામ',
        'ભરતકામ અને વસ્ત્રકલા',
        'ધાતુકામ અને પિત્તળકામ',
        'ચર્મકામ અને શણકામ',
        'પથ્થર કોતરણી અને મૂર્તિકલા',
        'અન્ય પરંપરાગત શિલ્પ',
      ];
  @override
  String get joinShilpsetu => 'શિલ્પસેતુમાં જોડાઓ';
  @override
  String get loginButton => 'ખાતામાં લૉગ ઇન કરો';
  @override
  String get offlineSyncNotice =>
      'ઓફલાઇન કામ કરે છે • મફત સરકારી બજાર જોડાણ';
  @override
  String get nameError => 'કૃપા કરીને સાચું નામ દાખલ કરો (ઓછામાં ઓછા ૨ અક્ષર)';
  @override
  String get phoneError => 'કૃપા કરીને ૧૦ આંકડાનો માન્ય મોબાઇલ નંબર દાખલ કરો';
  @override
  String welcomeUser(String name) => '$name, શિલ્પસેતુમાં આપનું સ્વાગત છે!';

  @override
  String get capturePrompt => 'તમે જે બનાવ્યું તે બતાવો';
  @override
  String get captureInstructionsTooltip => 'સૂચના સાંભળો';
  @override
  String get captureInstructionsSpeech =>
      'તમે જે બનાવ્યું તે બતાવો. વસ્તુને ફ્રેમની વચ્ચે રાખો અને ફોટો લેવા કૅમેરા બટન દબાવો.';
  @override
  String get capturePromptReplay =>
      'તમે જે બનાવ્યું તે બતાવો. વસ્તુને ફ્રેમની વચ્ચે રાખો અને કૅમેરા બટન દબાવો.';
  @override
  String get pointCamera => 'કૅમેરાને તમારા શિલ્પ તરફ રાખો';
  @override
  String get qualityBlur => 'ફોટો ઝાંખો છે. કૃપા કરીને હાથ સ્થિર રાખો.';
  @override
  String get qualityTooDark => 'ખૂબ અંધારું છે. તેજ પ્રકાશ તરફ જાઓ.';
  @override
  String get qualityBacklight => 'પ્રકાશ વસ્તુ પાછળ છે. પ્રકાશ તરફ મોં ફેરવો.';
  @override
  String get qualityReady => 'ફોટો પાડવા તૈયાર';
  @override
  String get offlineMlActive => 'ઓફલાઇન AI સક્રિય';
  @override
  String get switchCamera => 'કૅમેરો બદલો';
  @override
  String get tapToCapture => 'ફોટો પાડવા ટેપ કરો';
  @override
  String get retakePhoto => 'ફરી ફોટો પાડો';
  @override
  String get confirmPhoto => 'મંજૂર કરો અને આગળ વધો';

  @override
  String get step2StoryBadge => 'પગલું ૨: શિલ્પ વિગત';
  @override
  String get step2Prompt => 'પગલું ૨: તમારી શિલ્પ કથા કહો';
  @override
  String get choiceAPhotoOnlyTag => '⚡ ત્વરિત AI વિઝન';
  @override
  String get choiceAPhotoOnlyTitle => 'માત્ર ફોટોથી વિગત';
  @override
  String get choiceAPhotoOnlySubtitle =>
      'મોડેલ શિલ્પશૈલી, રંગો અને સામગ્રી આપોઆપ ઓળખે છે.';
  @override
  String get choiceAPhotoOnlyButton => 'આપોઆપ વિગત બનાવો';
  @override
  String get choiceAPhotoOnlySpeech =>
      'AI મોડેલ ફોટો જોઈને વિગત તૈયાર કરી રહ્યું છે...';
  @override
  String get choiceBVoiceTag => '🎙️ તમારો અવાજ';
  @override
  String get choiceBVoiceTitle => 'વોઇસ નોટ રેકોર્ડ કરો';
  @override
  String get choiceBVoiceSubtitle =>
      'તમે તે કેવી રીતે બનાવ્યું તે તમારી માતૃભાષામાં સહજ રીતે કહો.';
  @override
  String choiceBVoiceButton(bool isRecording) =>
      isRecording ? 'રેકોર્ડિંગ બંધ કરવા ટેપ કરો' : 'તમારી વાર્તા બોલો';
  @override
  String get recordingInProgress => 'સાંભળી રહ્યા છીએ... તમારા શિલ્પ વિશે બોલો';
  @override
  String get descriptionPreviewTitle => 'શિલ્પ વિગત અને લક્ષણો';
  @override
  String get listenDescription => 'વિગત સાંભળો';
  @override
  String get continueToPricingButton => 'ઉચિત ભાવ નક્કી કરવા આગળ વધો';
  @override
  String get continueToPricingSubtitle => 'પારદર્શક ન્યૂનતમ ભાવ ગણો';

  @override
  String get step3PricingBadge => 'પગલું ૩: ભાવ નિર્ધારણ';
  @override
  String get step3Prompt => 'પગલું ૩: તમારા શિલ્પનો ઉચિત ભાવ મોડેલ';
  @override
  String get step3PricingSpeech =>
      'ઉચિત ભાવ નિર્ધારણ. કાચા માલનો ખર્ચ અને નફો નક્કી કરો જેથી સરકારી ન્યૂનતમ અને બજાર ભાવો જોઈ શકાય.';
  @override
  String get materialCostTitle => 'કાચા માલનો ખર્ચ';
  @override
  String get materialCostSubtitle => 'માટી, લાકડું, રંગ, કાપડ, ઇંધણ વગેરે';
  @override
  String get materialCostLabel => 'કાચો માલ';
  @override
  String get desiredProfitTitle => 'તમારો મનચાહો નફો';
  @override
  String get desiredProfitSubtitle => 'કારીગરી અને શ્રમ માટે ઉચિત વેતન';
  @override
  String get targetProfitLabel => 'લક્ષિત નફો';
  @override
  String get costProfitAnalysisTitle => 'લાગત અને નફાનું વિશ્લેષણ';
  @override
  String get tierFloorTitle => 'ન્યૂનતમ ઉચિત વેતન';
  @override
  String get tierFloorBadge => 'ઓછામાં ઓછો ભાવ';
  @override
  String get tierFloorDesc =>
      'આ ભાવથી નીચે વેચવાથી શ્રમ અને સામગ્રીમાં નુકસાન થાય છે.';
  @override
  String get tierSuggestedTitle => 'સૂચવેલ બજાર ભાવ';
  @override
  String get tierSuggestedBadge => '⭐ સૌથી યોગ્ય';
  @override
  String get tierSuggestedDesc =>
      'સારો નફો અને બજારની ઊંચી માંગ વચ્ચે યોગ્ય સંતુલન.';
  @override
  String get tierStretchTitle => 'પ્રીમિયમ ભાવ';
  @override
  String get tierStretchBadge => 'પ્રીમિયમ';
  @override
  String get tierStretchDesc =>
      'શહેરી પ્રદર્શન, વિદેશી ગ્રાહકો અને ખાસ કલેક્શન માટે.';
  @override
  String publishButton(bool isPublishing) =>
      isPublishing ? 'પ્રકાશિત થઈ રહ્યું છે...' : 'દુકાન પર ઉમેરો';
  @override
  String get publishSubtitle => 'તમારી ડિજિટલ યાદીમાં શિલ્પ ઉમેરો';
  @override
  String get listingPublishedSuccess =>
      'ઉત્પાદ સફળતાપૂર્વક તમારી દુકાનમાં ઉમેરાઈ ગયું છે!';

  @override
  String catalogOverviewSpeech(int count) =>
      'તમારી પાસે $count ઉત્પાદો છે. સંપૂર્ણ માહિતી સાંભળવા કોઈપણ ઉત્પાદ પર ટેપ કરો.';
  @override
  String get myCraftShowroomTag => 'મારો શિલ્પ શોરૂમ';
  @override
  String get myCraftShowroomTitle => 'હસ્તકલા\nસંગ્રહ';
  @override
  String get myCraftShowroomSubtitle =>
      'ઉચિત ભાવ, સાચી વાર્તા, પ્રમાણિત કલાકારી.';
  @override
  String get addNewCraftButton => 'નવો શિલ્પ ઉમેરો';
  @override
  String get statTotalCrafts => 'કુલ ઉત્પાદ';
  @override
  String get statFairTotal => 'કુલ મૂલ્ય';
  @override
  String get statAvgMargin => 'સરેરાશ નફો';
  @override
  String get filterAll => 'બધા ઉત્પાદો';
  @override
  String get filterPublished => 'લાઇવ';
  @override
  String get filterDrafts => 'ડ્રાફ્ટ્સ';
  @override
  String get emptyCatalogTitle => 'હજુ સુધી કોઈ ઉત્પાદ ઉમેર્યા નથી';
  @override
  String get emptyCatalogSubtitle =>
      'તમારા પહેલા શિલ્પનો ફોટો પાડવા નીચેના કૅમેરા બટન પર ટેપ કરો.';
  @override
  String get emptyCatalogButton => 'પહેલો ફોટો પાડો';
  @override
  String get fairWageBadge => 'ઉચિત વેતન પ્રમાણિત';
  @override
  String get suggestedPriceLabel => 'સૂચવેલ ભાવ';
  @override
  String get inquiriesButton => 'પૂછપરછ જુઓ';

  @override
  String get ordersPrompt => 'ગ્રાહક ઓર્ડર અને પૂછપરછ';
  @override
  String get filterAllOrders => 'બધા';
  @override
  String get filterPending => 'નવા ઓર્ડર';
  @override
  String get filterConfirmed => 'કન્ફર્મ';
  @override
  String get buyerOfferedPrice => 'ગ્રાહકે આપેલો ભાવ';
  @override
  String get replyWhatsApp => 'વોટ્સએપ પર જવાબ આપો';
  @override
  String get callBuyer => 'ગ્રાહકને કૉલ કરો';
  @override
  String get markCompleted => 'પૂર્ણ થયેલ ચિહ્નિત કરો';
  @override
  String get noOrdersTitle => 'હમણાં કોઈ નવો સંદેશ નથી';
  @override
  String get noOrdersSubtitle =>
      'જ્યારે ખરીદદારો તમારા ઉત્પાદો જોશે, ત્યારે અહીં ઓર્ડર દેખાશે.';

  @override
  String get appInfoTooltip => 'માહિતી અને ખાતું';
  @override
  String get appInfoTitle => 'માહિતી અને ખાતું';
  @override
  String get accountDetailsTitle => 'ખાતાની વિગત';
  @override
  String get changeLanguageTile => 'એપ ભાષા બદલો';
  @override
  String get changeLanguageSubtitle => 'તમારી માતૃભાષા પસંદ કરો';
  @override
  String get offlineStatusTile => 'ઓફલાઇન મોડ';
  @override
  String get offlineStatusSubtitle => '૧૦૦% સક્રિય, નેટવર્ક મળતાં સિંક થશે';
  @override
  String get aboutTile => 'શિલ્પસેતુ વિશે';
  @override
  String get aboutSubtitle => 'ભારત સરકારનું ડિજિટલ કારીગર પ્લેટફોર્મ';
  @override
  String get logoutTile => 'લૉગ આઉટ';
  @override
  String get logoutConfirm => 'શું તમે ખરેખર બહાર નીકળવા માંગો છો?';
}

// ============================================================================
// HINDI IMPLEMENTATION (हिन्दी)
// ============================================================================
class _AppStringsHi extends AppStrings {
  const _AppStringsHi();

  @override
  String get appTitle => 'शिल्पसेतु';
  @override
  String get artisanFallback => 'कारीगर जी';
  @override
  String get continueButton => 'आगे बढ़ें';
  @override
  String get saveChanges => 'बदलाव सहेजें';
  @override
  String get cancelButton => 'रद्द करें';
  @override
  String get retryButton => 'पुनः प्रयास करें';
  @override
  String get closeButton => 'बंद करें';
  @override
  String get editButton => 'बदलें';
  @override
  String get offlineBadge => 'ऑफलाइन तैयार';

  @override
  String get navHome => 'होम';
  @override
  String get navCapture => 'फ़ोटो';
  @override
  String get navCatalog => 'उत्पाद';
  @override
  String get navOrders => 'ऑर्डर';

  @override
  String get chooseLanguagePrompt => 'अपनी भाषा चुनें';
  @override
  String get setupProfile => 'अपनी कारीगरी प्रोफ़ाइल बनाएं';

  @override
  String greeting(String name) => 'नमस्ते, $name';
  @override
  String get whatWillYouMake => 'आज आप क्या बनाएंगे?';
  @override
  String get homeOverviewTooltip => 'जानकारी सुनें';
  @override
  String homeOverviewSpeech(String name) =>
      'नमस्ते, $name। आज आप क्या बनाएंगे? बोलकर उत्पाद जोड़ें, उचित मूल्य जानें या शिल्प पहचानें।';
  @override
  String get voiceCatalogingTag => 'आवाज़ से उत्पाद सूचीकरण';
  @override
  String get voiceCatalogingTitle => 'अपना शिल्प\nजोड़ें';
  @override
  String get voiceCatalogingSubtitle =>
      'अपनी कहानी बोलें, बाकी हम तैयार करेंगे।';
  @override
  String get voiceCatalogingButton => 'बोलकर शुरू करें';
  @override
  String get voiceCatalogingSpeech =>
      'अपना शिल्प जोड़ें। अपनी कहानी बोलें, बाकी विवरण हम तैयार करेंगे।';
  @override
  String get smartArtisanTools => 'स्मार्ट कारीगर टूल्स';
  @override
  String get priceCalculatorTag => '🛡️ सरकारी न्यूनतम मजदूरी आधार';
  @override
  String get priceCalculatorTitle => 'उचित मूल्य\nकैलकुलेटर';
  @override
  String get priceCalculatorSubtitle =>
      'अपने श्रम का सही मूल्य जानें। कम में कभी न बेचें।';
  @override
  String get priceCalculatorButton => 'उचित मूल्य जानें';
  @override
  String get priceCalculatorSpeech =>
      'उचित मूल्य कैलकुलेटर। सरकारी न्यूनतम मजदूरी के आधार पर अपने श्रम का सही मूल्य जानें।';
  @override
  String get offlineRecogTag => '📶 बिना इंटरनेट के काम करता है';
  @override
  String get offlineRecogTitle => 'शिल्प\nपहचानें';
  @override
  String get offlineRecogSubtitle =>
      'फोटो खींचें, हम तकनीक और शिल्प बिना इंटरनेट के पहचानेंगे।';
  @override
  String get offlineRecogButton => 'शिल्प पहचानें';
  @override
  String get offlineRecogSpeech =>
      'शिल्प पहचानें। फोटो खींचें, यह बिना इंटरनेट के १००% काम करता है।';
  @override
  String get studioTag => '⚡ 320MS स्टूडियो फिनिश';
  @override
  String get studioTitle => 'फ़ोटो स्टूडियो\nफिनिशर';
  @override
  String get studioSubtitle =>
      'घर की साधारण फोटो को बनाएं बाज़ार जैसी साफ फ़ोटो।';
  @override
  String get studioButton => 'स्टूडियो खोलें';
  @override
  String get studioSpeech =>
      'फ़ोटो स्टूडियो। साधारण फोटो को बनाएं बाज़ार जैसी साफ फ़ोटो।';

  @override
  String authPrompt(bool isRegister) => isRegister
      ? 'अपना नाम और मोबाइल नंबर दर्ज करें'
      : 'अपना पंजीकृत मोबाइल नंबर दर्ज करें';
  @override
  String authPromptSpeech(bool isRegister) => isRegister
      ? 'शिल्पसेतु में शामिल होने के लिए कृपया अपना नाम और दस अंकों का मोबाइल नंबर दर्ज करें।'
      : 'लॉग इन करने के लिए अपना दस अंकों का मोबाइल नंबर दर्ज करें।';
  @override
  String get registerTab => 'नया पंजीकरण';
  @override
  String get loginTab => 'लॉग इन';
  @override
  String get fullNameLabel => 'कारीगर का पूरा नाम *';
  @override
  String get fullNameHint => 'उदा. राधाबाई कुंभार';
  @override
  String get phoneLabel => 'मोबाइल नंबर *';
  @override
  String get phoneHint => '10 अंकों का मोबाइल नंबर';
  @override
  String get craftCategoryLabel => 'मुख्य शिल्प श्रेणी';
  @override
  List<String> get craftOptions => const [
        'मिट्टी व कुम्हारी शिल्प',
        'हथकरघा व बुनाई',
        'लकड़ी व बांस शिल्प',
        'आभूषण व मनके',
        'कढ़ाई व वस्त्र कला',
        'धातु व पीतल शिल्प',
        'चर्म व जूट शिल्प',
        'पत्थर नक्काशी व मूर्ति कला',
        'अन्य पारंपरिक हस्तशिल्प',
      ];
  @override
  String get joinShilpsetu => 'शिल्पसेतु से जुड़ें';
  @override
  String get loginButton => 'खाते में लॉग इन करें';
  @override
  String get offlineSyncNotice =>
      'बिना इंटरनेट काम करता है • निःशुल्क सरकारी बाज़ार सेतु';
  @override
  String get nameError => 'कृपया सही नाम दर्ज करें (कम से कम 2 अक्षर)';
  @override
  String get phoneError => 'कृपया 10 अंकों का वैध मोबाइल नंबर दर्ज करें';
  @override
  String welcomeUser(String name) => '$name जी, शिल्पसेतु में आपका स्वागत है!';

  @override
  String get capturePrompt => 'आपने जो बनाया है वह दिखाइए';
  @override
  String get captureInstructionsTooltip => 'निर्देश सुनें';
  @override
  String get captureInstructionsSpeech =>
      'आपने जो बनाया है वह दिखाइए। वस्तु को फ्रेम के बीच में रखें और फोटो लेने के लिए कैमरा बटन दबाएं।';
  @override
  String get capturePromptReplay =>
      'आपने जो बनाया है वह दिखाइए। वस्तु को फ्रेम के बीच में रखें और कैमरा बटन दबाएं।';
  @override
  String get pointCamera => 'कैमरे को अपने शिल्प की ओर रखें';
  @override
  String get qualityBlur => 'फ़ोटो धुंधली है। कृपया हाथ स्थिर रखें।';
  @override
  String get qualityTooDark => 'बहुत अंधेरा है। कृपया रोशनी में जाएं।';
  @override
  String get qualityBacklight => 'रोशनी वस्तु के पीछे है। रोशनी की ओर मुख करें।';
  @override
  String get qualityReady => 'फ़ोटो लेने के लिए तैयार';
  @override
  String get offlineMlActive => 'डिवाइस पर AI सक्रिय';
  @override
  String get switchCamera => 'कैमरा बदलें';
  @override
  String get tapToCapture => 'फ़ोटो खींचने के लिए दबाएं';
  @override
  String get retakePhoto => 'दोबारा फ़ोटो लें';
  @override
  String get confirmPhoto => 'पुष्टि करें और आगे बढ़ें';

  @override
  String get step2StoryBadge => 'चरण 2: शिल्प विवरण';
  @override
  String get step2Prompt => 'चरण 2: अपने शिल्प की कहानी बताएं';
  @override
  String get choiceAPhotoOnlyTag => '⚡ तुरंत AI दृष्टि';
  @override
  String get choiceAPhotoOnlyTitle => 'केवल फोटो से विवरण बनाएं';
  @override
  String get choiceAPhotoOnlySubtitle =>
      'मॉडल शिल्प शैली, रंग और सामग्री स्वतः पहचानता है।';
  @override
  String get choiceAPhotoOnlyButton => 'स्वतः विवरण बनाएं';
  @override
  String get choiceAPhotoOnlySpeech =>
      'एआई मॉडल फोटो देखकर विवरण तैयार कर रहा है...';
  @override
  String get choiceBVoiceTag => '🎙️ आपकी आवाज़';
  @override
  String get choiceBVoiceTitle => 'बोलकर कहानी बताएं';
  @override
  String get choiceBVoiceSubtitle =>
      'अपनी मातृभाषा में सहजता से बताएं कि आपने इसे कैसे बनाया।';
  @override
  String choiceBVoiceButton(bool isRecording) =>
      isRecording ? 'रिकॉर्डिंग रोकने के लिए दबाएं' : 'अपनी कहानी बोलें';
  @override
  String get recordingInProgress => 'सुन रहे हैं... अपने शिल्प के बारे में बोलें';
  @override
  String get descriptionPreviewTitle => 'शिल्प विवरण व विशेषताएं';
  @override
  String get listenDescription => 'विवरण सुनें';
  @override
  String get continueToPricingButton => 'उचित मूल्य निर्धारण पर जाएं';
  @override
  String get continueToPricingSubtitle => 'पारदर्शी न्यूनतम मूल्य की गणना करें';

  @override
  String get step3PricingBadge => 'चरण 3: मूल्य निर्धारण';
  @override
  String get step3Prompt => 'चरण 3: आपके शिल्प का उचित मूल्य';
  @override
  String get step3PricingSpeech =>
      'उचित मूल्य निर्धारण। कच्चे माल की लागत और मनचाहा मुनाफ़ा तय करें ताकि सरकारी न्यूनतम व बाज़ार दर दिख सके।';
  @override
  String get materialCostTitle => 'कच्चे माल की लागत';
  @override
  String get materialCostSubtitle => 'मिट्टी, लकड़ी, रंग, कपड़ा, ईंधन आदि';
  @override
  String get materialCostLabel => 'कच्चा माल';
  @override
  String get desiredProfitTitle => 'आपका मनचाहा मुनाफ़ा';
  @override
  String get desiredProfitSubtitle => 'कारीगरी व श्रम का उचित पारिश्रमिक';
  @override
  String get targetProfitLabel => 'लक्षित लाभ';
  @override
  String get costProfitAnalysisTitle => 'लागत व मुनाफ़ा विश्लेषण';
  @override
  String get tierFloorTitle => 'न्यूनतम उचित मूल्य';
  @override
  String get tierFloorBadge => 'कम से कम';
  @override
  String get tierFloorDesc =>
      'इस मूल्य से नीचे बेचने पर श्रम और सामग्री का नुकसान होता है।';
  @override
  String get tierSuggestedTitle => 'सुझाया गया बाज़ार मूल्य';
  @override
  String get tierSuggestedBadge => '⭐ सबसे सही';
  @override
  String get tierSuggestedDesc =>
      'स्वस्थ लाभ और बाज़ार की अच्छी मांग के बीच संतुलन।';
  @override
  String get tierStretchTitle => 'प्रीमियम मूल्य';
  @override
  String get tierStretchBadge => 'प्रीमियम';
  @override
  String get tierStretchDesc =>
      'शहरी प्रदर्शनियों, विदेशी खरीदारों व बुटीक के लिए।';
  @override
  String publishButton(bool isPublishing) =>
      isPublishing ? 'प्रकाशित हो रहा है...' : 'दुकान पर जोड़ें';
  @override
  String get publishSubtitle => 'अपने डिजिटल कैटलॉग में उत्पाद जोड़ें';
  @override
  String get listingPublishedSuccess =>
      'उत्पाद सफलतापूर्वक आपकी दुकान में जोड़ दिया गया है!';

  @override
  String catalogOverviewSpeech(int count) =>
      'आपके पास $count उत्पाद सूचीबद्ध हैं। किसी भी उत्पाद की जानकारी सुनने के लिए उस पर टैप करें।';
  @override
  String get myCraftShowroomTag => 'मेरा शिल्प शोरूम';
  @override
  String get myCraftShowroomTitle => 'हस्तनिर्मित\nसंग्रह';
  @override
  String get myCraftShowroomSubtitle =>
      'उचित मूल्य, सच्ची कहानी, प्रमाणित कारीगरी।';
  @override
  String get addNewCraftButton => 'नया शिल्प जोड़ें';
  @override
  String get statTotalCrafts => 'कुल उत्पाद';
  @override
  String get statFairTotal => 'उचित मूल्य कुल';
  @override
  String get statAvgMargin => 'औसत मुनाफ़ा';
  @override
  String get filterAll => 'सभी उत्पाद';
  @override
  String get filterPublished => 'लाइव';
  @override
  String get filterDrafts => 'ड्राफ्ट';
  @override
  String get emptyCatalogTitle => 'अभी कोई उत्पाद नहीं है';
  @override
  String get emptyCatalogSubtitle =>
      'पहला शिल्प जोड़ने के लिए नीचे दिए गए कैमरा बटन को दबाएं।';
  @override
  String get emptyCatalogButton => 'पहला शिल्प जोड़ें';
  @override
  String get fairWageBadge => 'उचित मूल्य प्रमाणित';
  @override
  String get suggestedPriceLabel => 'सुझाया गया मूल्य';
  @override
  String get inquiriesButton => 'पूछताछ देखें';

  @override
  String get ordersPrompt => 'खरीदार ऑर्डर व पूछताछ';
  @override
  String get filterAllOrders => 'सभी';
  @override
  String get filterPending => 'नए ऑर्डर';
  @override
  String get filterConfirmed => 'स्वीकृत';
  @override
  String get buyerOfferedPrice => 'खरीदार द्वारा प्रस्तावित मूल्य';
  @override
  String get replyWhatsApp => 'व्हाट्सएप पर उत्तर दें';
  @override
  String get callBuyer => 'खरीदार को कॉल करें';
  @override
  String get markCompleted => 'पूर्ण चिह्नित करें';
  @override
  String get noOrdersTitle => 'अभी कोई नया संदेश नहीं है';
  @override
  String get noOrdersSubtitle =>
      'जब खरीदार आपके उत्पाद देखेंगे, तब पूछताछ यहां दिखाई देगी।';

  @override
  String get appInfoTooltip => 'जानकारी और खाता';
  @override
  String get appInfoTitle => 'जानकारी और खाता';
  @override
  String get accountDetailsTitle => 'खाता विवरण';
  @override
  String get changeLanguageTile => 'ऐप की भाषा बदलें';
  @override
  String get changeLanguageSubtitle => 'अपनी मातृभाषा चुनें';
  @override
  String get offlineStatusTile => 'ऑफलाइन मोड';
  @override
  String get offlineStatusSubtitle => '100% सक्रिय, नेटवर्क मिलने पर सिंक होगा';
  @override
  String get aboutTile => 'शिल्पसेतु के बारे में';
  @override
  String get aboutSubtitle => 'भारत सरकार का डिजिटल कारीगर मंच';
  @override
  String get logoutTile => 'लॉग आउट';
  @override
  String get logoutConfirm => 'क्या आप वाकई लॉग आउट करना चाहते हैं?';
}

// ============================================================================
// BENGALI IMPLEMENTATION (বাংলা)
// ============================================================================
class _AppStringsBn extends AppStrings {
  const _AppStringsBn();

  @override
  String get appTitle => 'শিল্পসেতু';
  @override
  String get artisanFallback => 'কারিগর';
  @override
  String get continueButton => 'এগিয়ে যান';
  @override
  String get saveChanges => 'সংরক্ষণ করুন';
  @override
  String get cancelButton => 'বাতিল';
  @override
  String get retryButton => 'আবার চেষ্টা করুন';
  @override
  String get closeButton => 'বন্ধ করুন';
  @override
  String get editButton => 'সম্পাদনা';
  @override
  String get offlineBadge => 'অফলাইন প্রস্তুত';

  @override
  String get navHome => 'হোম';
  @override
  String get navCapture => 'ছবি';
  @override
  String get navCatalog => 'পণ্য';
  @override
  String get navOrders => 'অর্ডার';

  @override
  String get chooseLanguagePrompt => 'আপনার ভাষা বেছে নিন';
  @override
  String get setupProfile => 'আপনার কারিগর প্রোফাইল তৈরি করুন';

  @override
  String greeting(String name) => 'নমস্কার, $name';
  @override
  String get whatWillYouMake => 'আজ আপনি কী তৈরি করবেন?';
  @override
  String get homeOverviewTooltip => 'তথ্য শুনুন';
  @override
  String homeOverviewSpeech(String name) =>
      'নমস্কার, $name। আজ আপনি কী তৈরি করবেন? কথা বলে পণ্য যোগ করুন, ন্যায্য মূল্য জানুন বা শিল্প শনাক্ত করুন।';
  @override
  String get voiceCatalogingTag => 'ভয়েস দিয়ে ক্যাটালগ';
  @override
  String get voiceCatalogingTitle => 'আপনার শিল্প\nযোগ করুন';
  @override
  String get voiceCatalogingSubtitle =>
      'আপনার গল্প বলুন, বাকিটা আমরা সাজিয়ে দেব।';
  @override
  String get voiceCatalogingButton => 'কথা বলে শুরু করুন';
  @override
  String get voiceCatalogingSpeech =>
      'আপনার শিল্প যোগ করুন। গল্প বলুন, বাকি বিবরণ আমরা তৈরি করব।';
  @override
  String get smartArtisanTools => 'স্মার্ট কারিগর টুলস';
  @override
  String get priceCalculatorTag => '🛡️ সরকারি ন্যূনতম মজুরি ভিত্তিক';
  @override
  String get priceCalculatorTitle => 'ন্যায্য মূল্য\nক্যালকুলেটর';
  @override
  String get priceCalculatorSubtitle =>
      'আপনার শ্রমের সঠিক মূল্য জানুন। কম দামে কখনো বিক্রি করবেন না।';
  @override
  String get priceCalculatorButton => 'ন্যায্য মূল্য দেখুন';
  @override
  String get priceCalculatorSpeech =>
      'ন্যায্য মূল্য ক্যালকুলেটর। সরকারি ন্যূনতম মজুরির ভিত্তিতে সঠিক মূল্য জানুন।';
  @override
  String get offlineRecogTag => '📶 ১০০% অফলাইন শনাক্তকরণ';
  @override
  String get offlineRecogTitle => 'শিল্প\nশনাক্ত করুন';
  @override
  String get offlineRecogSubtitle =>
      'ছবি তুলুন, আমরা ইন্টারনেট ছাড়াই কৌশল চিনব।';
  @override
  String get offlineRecogButton => 'শিল্প শনাক্ত করুন';
  @override
  String get offlineRecogSpeech =>
      'শিল্প শনাক্তকরণ। ছবি তুলুন, এটি ইন্টারনেট ছাড়াই ১০০% কাজ করে।';
  @override
  String get studioTag => '⚡ ৩২০MS স্টুডিও ফিনিশ';
  @override
  String get studioTitle => 'স্টুডিও ফটো\nউন্নতকারী';
  @override
  String get studioSubtitle =>
      'ঘরের সাধারণ ছবিকে বাজারের মতো পরিষ্কার করুন।';
  @override
  String get studioButton => 'স্টুডিও খুলুন';
  @override
  String get studioSpeech =>
      'স্টুডিও ফটো উন্নতকারী। সাধারণ ছবিকে বাজারের মতো ঝকঝকে করুন।';

  @override
  String authPrompt(bool isRegister) => isRegister
      ? 'আপনার নাম এবং মোবাইল নম্বর দিন'
      : 'আপনার নিবন্ধিত মোবাইল নম্বর দিন';
  @override
  String authPromptSpeech(bool isRegister) => isRegister
      ? 'শিল্পসেতুতে যোগ দিতে দয়া করে আপনার পূর্ণ নাম এবং দশ সংখ্যার মোবাইল নম্বর দিন।'
      : 'লগ ইন করতে আপনার দশ সংখ্যার মোবাইল নম্বর দিন।';
  @override
  String get registerTab => 'নিবন্ধন';
  @override
  String get loginTab => 'লগ ইন';
  @override
  String get fullNameLabel => 'কারিগর পুরো নাম *';
  @override
  String get fullNameHint => 'উদাঃ রাধাবাই কুম্ভকার';
  @override
  String get phoneLabel => 'মোবাইল নম্বর *';
  @override
  String get phoneHint => '১০ সংখ্যার মোবাইল নম্বর';
  @override
  String get craftCategoryLabel => 'প্রধান শিল্প বিভাগ';
  @override
  List<String> get craftOptions => const [
        'মৃৎশিল্প ও মাটির কাজ',
        'তাঁত ও বয়নশিল্প',
        'কাঠ ও বাঁশশিল্প',
        'গহনা ও পুঁতির কাজ',
        'সূঁচিশিল্প ও বস্ত্রকলা',
        'ধাতব ও কাঁসা-পিতল শিল্প',
        'চামড়া ও পাটশিল্প',
        'পাথর খোদাই ও ভাস্কর্য',
        'অন্যান্য ঐতিহ্যবাহী হস্তশিল্প',
      ];
  @override
  String get joinShilpsetu => 'শিল্পসেতুতে যোগ দিন';
  @override
  String get loginButton => 'অ্যাকাউন্টে লগ ইন করুন';
  @override
  String get offlineSyncNotice =>
      'অফলাইনে কাজ করে • বিনামূল্যে সরকারি বাজার সেতু';
  @override
  String get nameError => 'সঠিক নাম লিখুন (কমপক্ষে ২টি অক্ষর)';
  @override
  String get phoneError => 'সঠিক ১০ সংখ্যার মোবাইল নম্বর লিখুন';
  @override
  String welcomeUser(String name) => '$name, শিল্পসেতুতে আপনাকে স্বাগতম!';

  @override
  String get capturePrompt => 'আপনি যা বানিয়েছেন তা দেখান';
  @override
  String get captureInstructionsTooltip => 'নির্দেশনা শুনুন';
  @override
  String get captureInstructionsSpeech =>
      'আপনি যা বানিয়েছেন তা দেখান। শিল্পকর্মটি ফ্রেমের মাঝে রাখুন এবং ছবি তুলতে ক্যামেরা বোতাম চাপুন।';
  @override
  String get capturePromptReplay =>
      'আপনি যা বানিয়েছেন তা দেখান। ফ্রেমের মাঝে রেখে বোতাম টিপুন।';
  @override
  String get pointCamera => 'ক্যামেরা আপনার শিল্পের দিকে রাখুন';
  @override
  String get qualityBlur => 'ছবিটি ঝাপসা। স্থির থাকুন।';
  @override
  String get qualityTooDark => 'অনেক অন্ধকার। উজ্জ্বল আলোতে যান।';
  @override
  String get qualityBacklight => 'আলো বস্তুর পেছনে। আলোর দিকে মুখ করুন।';
  @override
  String get qualityReady => 'ছবি তোলার জন্য প্রস্তুত';
  @override
  String get offlineMlActive => 'ডিভাইসে AI সক্রিয়';
  @override
  String get switchCamera => 'ক্যামেরা পরিবর্তন';
  @override
  String get tapToCapture => 'ছবি তুলতে ট্যাপ করুন';
  @override
  String get retakePhoto => 'আবার ছবি তুলুন';
  @override
  String get confirmPhoto => 'নিশ্চিত করুন এবং এগিয়ে যান';

  @override
  String get step2StoryBadge => 'ধাপ ২: শিল্পের বিবরণ';
  @override
  String get step2Prompt => 'ধাপ ২: আপনার শিল্পের গল্প বলুন';
  @override
  String get choiceAPhotoOnlyTag => '⚡ তাত্ক্ষণিক AI ভিশন';
  @override
  String get choiceAPhotoOnlyTitle => 'ছবি থেকে বিবরণ';
  @override
  String get choiceAPhotoOnlySubtitle =>
      'মডেল স্বয়ংক্রিয়ভাবে শৈলী, রঙ এবং উপাদান শনাক্ত করে।';
  @override
  String get choiceAPhotoOnlyButton => 'স্বয়ংক্রিয় বিবরণ তৈরি';
  @override
  String get choiceAPhotoOnlySpeech =>
      'AI মডেল ছবি দেখে বিবরণ প্রস্তুত করছে...';
  @override
  String get choiceBVoiceTag => '🎙️ আপনার কণ্ঠ';
  @override
  String get choiceBVoiceTitle => 'ভয়েস রেকর্ড করুন';
  @override
  String get choiceBVoiceSubtitle =>
      'কীভাবে তৈরি করেছেন তা মাতৃভাষায় সুন্দরভাবে বলুন।';
  @override
  String choiceBVoiceButton(bool isRecording) =>
      isRecording ? 'রেকর্ডিং বন্ধ করতে ট্যাপ করুন' : 'আপনার গল্প বলুন';
  @override
  String get recordingInProgress => 'শুনছি... আপনার শিল্প সম্পর্কে বলুন';
  @override
  String get descriptionPreviewTitle => 'শিল্পের বিবরণ ও গুণাবলী';
  @override
  String get listenDescription => 'বিবরণ শুনুন';
  @override
  String get continueToPricingButton => 'ন্যায্য মূল্য নির্ধারণে যান';
  @override
  String get continueToPricingSubtitle => 'স্বচ্ছ ন্যূনতম মূল্য গণনা করুন';

  @override
  String get step3PricingBadge => 'ধাপ ৩: মূল্য নির্ধারণ';
  @override
  String get step3Prompt => 'ধাপ ৩: ন্যায্য মূল্য মডেল';
  @override
  String get step3PricingSpeech =>
      'ন্যায্য মূল্য নির্ধারণ। কাঁচামালের খরচ এবং লাভ নির্ধারণ করে সরকারি ন্যূনতম ও বাজার মূল্য দেখুন।';
  @override
  String get materialCostTitle => 'কাঁচামালের খরচ';
  @override
  String get materialCostSubtitle => 'মাটি, কাঠ, রঙ, সুতো, জ্বালানি ইত্যাদি';
  @override
  String get materialCostLabel => 'কাঁচামাল';
  @override
  String get desiredProfitTitle => 'আপনার কাঙ্ক্ষিত লাভ';
  @override
  String get desiredProfitSubtitle => 'শ্রম ও দক্ষতার ন্যায্য মজুরি';
  @override
  String get targetProfitLabel => 'লক্ষ্য লাভ';
  @override
  String get costProfitAnalysisTitle => 'খরচ ও লাভ বিশ্লেষণ';
  @override
  String get tierFloorTitle => 'ন্যূনতম ন্যায্য মজুরি';
  @override
  String get tierFloorBadge => 'কমপক্ষে';
  @override
  String get tierFloorDesc =>
      'এর নিচে বিক্রি করলে কাঁচামাল ও শ্রমে ক্ষতি হবে।';
  @override
  String get tierSuggestedTitle => 'প্রস্তাবিত বাজার মূল্য';
  @override
  String get tierSuggestedBadge => '⭐ সেরা মূল্য';
  @override
  String get tierSuggestedDesc =>
      'ন্যায্য লাভ এবং বাজার চাহিদার সুন্দর ভারসাম্য।';
  @override
  String get tierStretchTitle => 'প্রিমিয়াম মূল্য';
  @override
  String get tierStretchBadge => 'প্রিমিয়াম';
  @override
  String get tierStretchDesc =>
      'শহুরে প্রদর্শনী, রপ্তানি এবং বিশেষ ক্রেতাদের জন্য।';
  @override
  String publishButton(bool isPublishing) =>
      isPublishing ? 'যুক্ত হচ্ছে...' : 'দোকানে যোগ করুন';
  @override
  String get publishSubtitle => 'ডিজিটাল ক্যাটালগে পণ্য যুক্ত করুন';
  @override
  String get listingPublishedSuccess =>
      'পণ্যটি সফলভাবে আপনার শো-রুমে যুক্ত হয়েছে!';

  @override
  String catalogOverviewSpeech(int count) =>
      'আপনার $countটি শিল্প পণ্য তালিকাভুক্ত আছে। বিস্তারিত শুনতে পণ্যে ট্যাপ করুন।';
  @override
  String get myCraftShowroomTag => 'আমার শিল্প শোরুম';
  @override
  String get myCraftShowroomTitle => 'হস্তশিল্প\nসংগ্রহ';
  @override
  String get myCraftShowroomSubtitle =>
      'ন্যায্য দাম, আসল গল্প, খাঁটি কারিগরি।';
  @override
  String get addNewCraftButton => 'নতুন শিল্প যোগ করুন';
  @override
  String get statTotalCrafts => 'মোট পণ্য';
  @override
  String get statFairTotal => 'মোট মূল্য';
  @override
  String get statAvgMargin => 'গড় লাভ';
  @override
  String get filterAll => 'সব পণ্য';
  @override
  String get filterPublished => 'লাইভ';
  @override
  String get filterDrafts => 'খসড়া';
  @override
  String get emptyCatalogTitle => 'এখনও কোনো পণ্য নেই';
  @override
  String get emptyCatalogSubtitle =>
      'প্রথম শিল্প যোগ করতে নিচের ক্যামেরা বোতাম টিপুন।';
  @override
  String get emptyCatalogButton => 'প্রথম ছবি তুলুন';
  @override
  String get fairWageBadge => 'ন্যায্য মজুরি প্রত্যয়িত';
  @override
  String get suggestedPriceLabel => 'প্রস্তাবিত মূল্য';
  @override
  String get inquiriesButton => 'জিজ্ঞাসাবাদ দেখুন';

  @override
  String get ordersPrompt => 'ক্রেতার অর্ডার ও জিজ্ঞাসা';
  @override
  String get filterAllOrders => 'সব';
  @override
  String get filterPending => 'নতুন অর্ডার';
  @override
  String get filterConfirmed => 'নিশ্চিত';
  @override
  String get buyerOfferedPrice => 'ক্রেতার প্রস্তাবিত দাম';
  @override
  String get replyWhatsApp => 'হোয়াটসঅ্যাপে উত্তর দিন';
  @override
  String get callBuyer => 'ক্রেতাকে কল করুন';
  @override
  String get markCompleted => 'সম্পূর্ণ হিসেবে চিহ্নিত করুন';
  @override
  String get noOrdersTitle => 'এখন কোনো নতুন বার্তা নেই';
  @override
  String get noOrdersSubtitle =>
      'ক্রেতারা যখন আপনার পণ্য দেখবেন, তখন অনুসন্ধান এখানে আসবে।';

  @override
  String get appInfoTooltip => 'তথ্য ও অ্যাকাউন্ট';
  @override
  String get appInfoTitle => 'তথ্য ও অ্যাকাউন্ট';
  @override
  String get accountDetailsTitle => 'অ্যাকাউন্ট বিবরণ';
  @override
  String get changeLanguageTile => 'অ্যাপের ভাষা পরিবর্তন';
  @override
  String get changeLanguageSubtitle => 'আপনার মাতৃভাষা বেছে নিন';
  @override
  String get offlineStatusTile => 'অফলাইন মোড';
  @override
  String get offlineStatusSubtitle => '১০০% সক্রিয়, নেটওয়ার্ক পেলেই সিঙ্ক হবে';
  @override
  String get aboutTile => 'শিল্পসেতু সম্পর্কে';
  @override
  String get aboutSubtitle => 'ভারত সরকারের ডিজিটাল কারিগর প্ল্যাটফর্ম';
  @override
  String get logoutTile => 'লগ আউট';
  @override
  String get logoutConfirm => 'আপনি কি সত্যিই লগ আউট করতে চান?';
}

// ============================================================================
// TELUGU IMPLEMENTATION (తెలుగు)
// ============================================================================
class _AppStringsTe extends AppStrings {
  const _AppStringsTe();

  @override
  String get appTitle => 'శిల్పసేతు';
  @override
  String get artisanFallback => 'శిల్పకారుడు';
  @override
  String get continueButton => 'ముందుకు సాగండి';
  @override
  String get saveChanges => 'మార్పులను సేవ్ చేయండి';
  @override
  String get cancelButton => 'రద్దు చేయి';
  @override
  String get retryButton => 'మళ్లీ ప్రయత్నించండి';
  @override
  String get closeButton => 'మూసివేయి';
  @override
  String get editButton => 'సవరించు';
  @override
  String get offlineBadge => 'ఆఫ్‌లైన్ సిద్ధం';

  @override
  String get navHome => 'హోమ్';
  @override
  String get navCapture => 'ఫోటో';
  @override
  String get navCatalog => 'ఉత్పత్తులు';
  @override
  String get navOrders => 'ఆర్డర్లు';

  @override
  String get chooseLanguagePrompt => 'మీ భాషను ఎంచుకోండి';
  @override
  String get setupProfile => 'మీ చేతివృత్తి ప్రొఫైల్‌ను సృష్టించండి';

  @override
  String greeting(String name) => 'నమస్కారం, $name';
  @override
  String get whatWillYouMake => 'ఈ రోజు మీరు ఏమి తయారు చేస్తారు?';
  @override
  String get homeOverviewTooltip => 'సమాచారం వినండి';
  @override
  String homeOverviewSpeech(String name) =>
      'నమస్కారం, $name. ఈ రోజు మీరు ఏమి తయారు చేస్తారు? వాయిస్‌తో ఉత్పత్తిని జోడించండి, సరసమైన ధరను తెలుసుకోండి.';
  @override
  String get voiceCatalogingTag => 'వాయిస్‌తో క్యాటలాగ్';
  @override
  String get voiceCatalogingTitle => 'మీ కళను\nజోడించండి';
  @override
  String get voiceCatalogingSubtitle =>
      'మీ కథ చెప్పండి, మిగతా వివరాలు మేము సిద్ధం చేస్తాము.';
  @override
  String get voiceCatalogingButton => 'వాయిస్‌తో ప్రారంభించండి';
  @override
  String get voiceCatalogingSpeech =>
      'మీ శిల్పాన్ని జోడించండి. మీ కథ చెప్పండి, వివరాలు మేము సిద్ధం చేస్తాము.';
  @override
  String get smartArtisanTools => 'స్మార్ట్ శిల్పకారుల టూల్స్';
  @override
  String get priceCalculatorTag => '🛡️ ప్రభుత్వ కనీస వేతన ఆధారం';
  @override
  String get priceCalculatorTitle => 'సమంజసమైన ధర\nకాలిక్యులేటర్';
  @override
  String get priceCalculatorSubtitle =>
      'మీ శ్రమకు తగిన విలువ తెలుసుకోండి. తక్కువకు ఎప్పుడూ అమ్మకండి.';
  @override
  String get priceCalculatorButton => 'ధరను తనిఖీ చేయండి';
  @override
  String get priceCalculatorSpeech =>
      'సమంజసమైన ధర కాలిక్యులేటర్. ప్రభుత్వ కనీస వేతనం ఆధారంగా సరైన ధరను తెలుసుకోండి.';
  @override
  String get offlineRecogTag => '📶 100% ఆఫ్‌లైన్ గుర్తింపు';
  @override
  String get offlineRecogTitle => 'శిల్పాన్ని\nగుర్తించండి';
  @override
  String get offlineRecogSubtitle =>
      'ఫోటో తీయండి, ఇంటర్నెట్ లేకుండా కళా నైపుణ్యాన్ని గుర్తిస్తాము.';
  @override
  String get offlineRecogButton => 'శిల్పం గుర్తించు';
  @override
  String get offlineRecogSpeech =>
      'శిల్పం గుర్తింపు. ఫోటో తీయండి, ఇది ఇంటర్నెట్ లేకుండా పనిచేస్తుంది.';
  @override
  String get studioTag => '⚡ 320MS స్టూడియో ఫినిష్';
  @override
  String get studioTitle => 'స్టూడియో ఫోటో\nఎన్‌హాన్సర్';
  @override
  String get studioSubtitle =>
      'ఇంటి సాధారణ ఫోటోలను మార్కెట్ తరహాగా మార్చండి.';
  @override
  String get studioButton => 'స్టూడియో తెరవండి';
  @override
  String get studioSpeech =>
      'స్టూడియో ఫోటో ఎన్‌హాన్సర్. ఫోటోను మార్కెట్ నాణ్యతతో శుభ్రం చేయండి.';

  @override
  String authPrompt(bool isRegister) => isRegister
      ? 'మీ పేరు మరియు మొబైల్ నంబర్ నమోదు చేయండి'
      : 'మీ నమోదిత మొబైల్ నంబర్ నమోదు చేయండి';
  @override
  String authPromptSpeech(bool isRegister) => isRegister
      ? 'శిల్పసేతులో చేరడానికి మీ పూర్తి పేరు మరియు పది అంకెల మొబైల్ నంబర్ నమోదు చేయండి.'
      : 'లాగిన్ చేయడానికి పది అంకెల మొబైల్ నంబర్ నమోదు చేయండి.';
  @override
  String get registerTab => 'రిజిస్టర్';
  @override
  String get loginTab => 'లాగిన్';
  @override
  String get fullNameLabel => 'పూర్తి పేరు *';
  @override
  String get fullNameHint => 'ఉదా: రాధాబాయి';
  @override
  String get phoneLabel => 'మొబైల్ సంఖ్య *';
  @override
  String get phoneHint => '10 అంకెల మొబైల్ సంఖ్య';
  @override
  String get craftCategoryLabel => 'ప్రధాన చేతివృత్తి వర్గం';
  @override
  List<String> get craftOptions => const [
        'కుండలు & మట్టి పని',
        'చేనేత & నేత పని',
        'చెక్క & వెదురు కళ',
        'నగలు & పూసల పని',
        'ఎంబ్రాయిడరీ & వస్త్ర కళ',
        'లోహపు & ఇత్తడి పని',
        'తోలు & జూట్ కళ',
        'రాతి శిల్పం & చెక్కడాలు',
        'ఇతర సాంప్రదాయ హస్తకళలు',
      ];
  @override
  String get joinShilpsetu => 'శిల్పసేతులో చేరండి';
  @override
  String get loginButton => 'ఖాతాలోకి లాగిన్ అవ్వండి';
  @override
  String get offlineSyncNotice =>
      'ఆఫ్‌లైన్‌లో పనిచేస్తుంది • ఉచిత ప్రభుత్వ మార్కెట్ వేదిక';
  @override
  String get nameError => 'దయచేసి సరైన పేరు నమోదు చేయండి (కనీసం 2 అక్షరాలు)';
  @override
  String get phoneError => 'దయచేసి సరైన 10 అంకెల మొబైల్ నంబర్ ఇవ్వండి';
  @override
  String welcomeUser(String name) => '$name, శిల్పసేతుకి స్వాగతం!';

  @override
  String get capturePrompt => 'మీరు చేసిన పనిని చూపించండి';
  @override
  String get captureInstructionsTooltip => 'సూచనలు వినండి';
  @override
  String get captureInstructionsSpeech =>
      'మీరు చేసిన పనిని చూపించండి. వస్తువును ఫ్రేమ్‌లో ఉంచి ఫోటో తీయండి.';
  @override
  String get capturePromptReplay =>
      'మీరు చేసిన పనిని చూపించండి. కెమెరా బటన్ నొక్కండి.';
  @override
  String get pointCamera => 'కెమెరాను మీ కళావస్తువు వైపు ఉంచండి';
  @override
  String get qualityBlur => 'ఫోటో మసకగా ఉంది. దయచేసి స్థిరంగా పట్టుకోండి.';
  @override
  String get qualityTooDark => 'చాలా చీకటిగా ఉంది. వెలుతురులోకి వెళ్ళండి.';
  @override
  String get qualityBacklight => 'వెలుతురు వస్తువు వెనకాల ఉంది.';
  @override
  String get qualityReady => 'ఫోటో తీయడానికి సిద్ధం';
  @override
  String get offlineMlActive => 'ఆఫ్‌లైన్ AI సక్రియం';
  @override
  String get switchCamera => 'కెమెరా మార్చండి';
  @override
  String get tapToCapture => 'ఫోటో తీయడానికి నొక్కండి';
  @override
  String get retakePhoto => 'మళ్లీ తీయండి';
  @override
  String get confirmPhoto => 'ధృవీకరించి ముందుకు సాగండి';

  @override
  String get step2StoryBadge => 'దశ 2: వస్తువు వివరాలు';
  @override
  String get step2Prompt => 'దశ 2: మీ చేతివృత్తి కథ చెప్పండి';
  @override
  String get choiceAPhotoOnlyTag => '⚡ తక్షణ AI విజన్';
  @override
  String get choiceAPhotoOnlyTitle => 'ఫోటోతో AI వివరాలు';
  @override
  String get choiceAPhotoOnlySubtitle =>
      'శైలి, రంగులు మరియు పదార్థాలను మోడల్ స్వయంచాలకంగా గుర్తిస్తుంది.';
  @override
  String get choiceAPhotoOnlyButton => 'ఆటో వివరాలు పొందండి';
  @override
  String get choiceAPhotoOnlySpeech =>
      'AI మోడల్ ఫోటోను విశ్లేషించి వివరాలను సిద్ధం చేస్తోంది...';
  @override
  String get choiceBVoiceTag => '🎙️ మీ వాయిస్ కథ';
  @override
  String get choiceBVoiceTitle => 'వాయిస్‌తో వివరించండి';
  @override
  String get choiceBVoiceSubtitle =>
      'దీన్ని ఎలా తయారు చేశారో మీ మాతృభాషలో సహజంగా చెప్పండి.';
  @override
  String choiceBVoiceButton(bool isRecording) =>
      isRecording ? 'రికార్డింగ్ ఆపడానికి నొక్కండి' : 'మీ కథ చెప్పండి';
  @override
  String get recordingInProgress => 'వింటున్నాము... మీ కళ గురించి మాట్లాడండి';
  @override
  String get descriptionPreviewTitle => 'వివరాలు & లక్షణాలు';
  @override
  String get listenDescription => 'వివరాలు వినండి';
  @override
  String get continueToPricingButton => 'ధర నిర్ణయానికి వెళ్ళండి';
  @override
  String get continueToPricingSubtitle => 'కనీస ధరను లెక్కించండి';

  @override
  String get step3PricingBadge => 'దశ 3: ధర నిర్ణయం';
  @override
  String get step3Prompt => 'దశ 3: సమంజసమైన ధర మోడల్';
  @override
  String get step3PricingSpeech =>
      'సమంజసమైన ధర నిర్ణయం. ముడి సరుకు ఖర్చు మరియు లాభాన్ని సెట్ చేయండి.';
  @override
  String get materialCostTitle => 'ముడి పదార్థాల ఖర్చు';
  @override
  String get materialCostSubtitle => 'మట్టి, చెక్క, రంగులు, గుడ్డ, ఇంధనం';
  @override
  String get materialCostLabel => 'ముడి సరుకు';
  @override
  String get desiredProfitTitle => 'మీ లాభం';
  @override
  String get desiredProfitSubtitle => 'శ్రమకు తగిన న్యాయమైన వేతనం';
  @override
  String get targetProfitLabel => 'లక్ష్య లాభం';
  @override
  String get costProfitAnalysisTitle => 'ఖర్చు & లాభాల విశ్లేషణ';
  @override
  String get tierFloorTitle => 'కనీస న్యాయమైన వేతనం';
  @override
  String get tierFloorBadge => 'కనీస ధర';
  @override
  String get tierFloorDesc =>
      'దీనికంటే తక్కువగా అమ్మితే శ్రమ మరియు సరుకులో నష్టం వస్తుంది.';
  @override
  String get tierSuggestedTitle => 'సూచించిన మార్కెట్ ధర';
  @override
  String get tierSuggestedBadge => '⭐ సిఫార్సు చేయబడింది';
  @override
  String get tierSuggestedDesc =>
      'మంచి లాభం మరియు మార్కెట్ గిరాకీకి సరైన సమతుల్యత.';
  @override
  String get tierStretchTitle => 'ప్రీమియం ధర';
  @override
  String get tierStretchBadge => 'ప్రీమియం';
  @override
  String get tierStretchDesc =>
      'నగర ప్రదర్శనలు మరియు ప్రత్యేక కొనుగోలుదారుల కోసం.';
  @override
  String publishButton(bool isPublishing) =>
      isPublishing ? 'ప్రచురిస్తోంది...' : 'జాబితాలో చేర్చండి';
  @override
  String get publishSubtitle => 'డిజిటల్ కేటలాగ్‌లో చేర్చండి';
  @override
  String get listingPublishedSuccess =>
      'ఉత్పత్తి విజయవంతంగా మీ కేటలాగ్‌లో చేర్చబడింది!';

  @override
  String catalogOverviewSpeech(int count) =>
      'మీ దగ్గర $count ఉత్పత్తులు ఉన్నాయి. వివరాల కోసం ఉత్పత్తిపై నొక్కండి.';
  @override
  String get myCraftShowroomTag => 'నా చేతివృత్తుల ప్రదర్శనశాల';
  @override
  String get myCraftShowroomTitle => 'హస్తకళా\nసేకరణ';
  @override
  String get myCraftShowroomSubtitle =>
      'సరసమైన ధరలు, నిజమైన కథలు, ప్రామాణిక కళ.';
  @override
  String get addNewCraftButton => 'కొత్త ఉత్పత్తిని జోడించండి';
  @override
  String get statTotalCrafts => 'మొత్తం వస్తువులు';
  @override
  String get statFairTotal => 'మొత్తం విలువ';
  @override
  String get statAvgMargin => 'సగటు లాభం';
  @override
  String get filterAll => 'అన్ని వస్తువులు';
  @override
  String get filterPublished => 'లైవ్';
  @override
  String get filterDrafts => 'డ్రాఫ్ట్‌లు';
  @override
  String get emptyCatalogTitle => 'ఇంకా ఉత్పత్తులు లేవు';
  @override
  String get emptyCatalogSubtitle =>
      'మొదటి ఉత్పత్తిని జోడించడానికి కెమెరా బటన్ నొక్కండి.';
  @override
  String get emptyCatalogButton => 'మొదటి ఫోటో తీయండి';
  @override
  String get fairWageBadge => 'న్యాయమైన వేతన సర్టిఫైడ్';
  @override
  String get suggestedPriceLabel => 'సూచించిన ధర';
  @override
  String get inquiriesButton => 'విచారణలు చూడండి';

  @override
  String get ordersPrompt => 'కొనుగోలుదారుల ఆర్డర్లు & విచారణలు';
  @override
  String get filterAllOrders => 'అన్నీ';
  @override
  String get filterPending => 'కొత్త ఆర్డర్లు';
  @override
  String get filterConfirmed => 'ధృవీకరించబడినవి';
  @override
  String get buyerOfferedPrice => 'కొనుగోలుదారు ప్రతిపాదించిన ధర';
  @override
  String get replyWhatsApp => 'వాట్సాప్‌లో సమాధానం ఇవ్వండి';
  @override
  String get callBuyer => 'కాల్ చేయండి';
  @override
  String get markCompleted => 'పూర్తయినట్లు గుర్తించండి';
  @override
  String get noOrdersTitle => 'ఇప్పుడు ఆర్డర్లు లేవు';
  @override
  String get noOrdersSubtitle =>
      'కొనుగోలుదారులు మీ వస్తువులను చూసినప్పుడు ఇక్కడ కనిపిస్తాయి.';

  @override
  String get appInfoTooltip => 'యాప్ సమాచారం & ఖాతా';
  @override
  String get appInfoTitle => 'యాప్ సమాచారం & ఖాతా';
  @override
  String get accountDetailsTitle => 'ఖాతా వివరాలు';
  @override
  String get changeLanguageTile => 'భాషను మార్చండి';
  @override
  String get changeLanguageSubtitle => 'మీ మాతృభాషను ఎంచుకోండి';
  @override
  String get offlineStatusTile => 'ఆఫ్‌లైన్ మోడ్';
  @override
  String get offlineStatusSubtitle => '100% ఆక్టివ్, నెట్‌వర్క్ రాగానే సింక్ అవుతుంది';
  @override
  String get aboutTile => 'శిల్పసేతు గురించి';
  @override
  String get aboutSubtitle => 'భారత ప్రభుత్వ డిజిటల్ శిల్పకారుల వేదిక';
  @override
  String get logoutTile => 'లాగ్ అవుట్';
  @override
  String get logoutConfirm => 'మీరు నిజంగా నిష్క్రమించాలనుకుంటున్నారా?';
}

// ============================================================================
// TAMIL IMPLEMENTATION (தமிழ்)
// ============================================================================
class _AppStringsTa extends AppStrings {
  const _AppStringsTa();

  @override
  String get appTitle => 'சில்பசேது';
  @override
  String get artisanFallback => 'கைவினைஞர்';
  @override
  String get continueButton => 'தொடரவும்';
  @override
  String get saveChanges => 'மாற்றங்களைச் சேமிக்கவும்';
  @override
  String get cancelButton => 'ரத்து செய்';
  @override
  String get retryButton => 'மீண்டும் முயற்சிக்கவும்';
  @override
  String get closeButton => 'மூடு';
  @override
  String get editButton => 'மாற்று';
  @override
  String get offlineBadge => 'ஆஃப்லைன் தயார்';

  @override
  String get navHome => 'முகப்பு';
  @override
  String get navCapture => 'படம்';
  @override
  String get navCatalog => 'தயாரிப்புகள்';
  @override
  String get navOrders => 'ஆர்டர்கள்';

  @override
  String get chooseLanguagePrompt => 'உங்கள் மொழியைத் தேர்ந்தெடுக்கவும்';
  @override
  String get setupProfile => 'உங்கள் கைவினை சுயவிவரத்தை அமைக்கவும்';

  @override
  String greeting(String name) => 'வணக்கம், $name';
  @override
  String get whatWillYouMake => 'இன்று நீங்கள் என்ன உருவாக்கப் போகிறீர்கள்?';
  @override
  String get homeOverviewTooltip => 'தகவலைக் கேளுங்கள்';
  @override
  String homeOverviewSpeech(String name) =>
      'வணக்கம், $name. இன்று என்ன செய்யப் போகிறீர்கள்? உங்கள் குரலால் தயாரிப்பைச் சேர்க்கவும், நியாயமான விலையை அறியவும்.';
  @override
  String get voiceCatalogingTag => 'குரல் வழி பட்டியல்';
  @override
  String get voiceCatalogingTitle => 'உங்கள் கைவினையை\nசேர்க்கவும்';
  @override
  String get voiceCatalogingSubtitle =>
      'உங்கள் கதையைக் கூறுங்கள், மீதியை நாங்கள் தயார் செய்கிறோம்.';
  @override
  String get voiceCatalogingButton => 'குரல் மூலம் தொடங்குங்கள்';
  @override
  String get voiceCatalogingSpeech =>
      'உங்கள் கைவினைப் பொருளைச் சேர்க்கவும். கதையைக் கூறுங்கள், விவரங்களை நாங்கள் உருவாக்குகிறோம்.';
  @override
  String get smartArtisanTools => 'திறமையான கைவினைஞர் கருவிகள்';
  @override
  String get priceCalculatorTag => '🛡️ அரசு குறைந்தபட்ச ஊதிய அடிப்படை';
  @override
  String get priceCalculatorTitle => 'நியாயமான விலை\nகால்குலேட்டர்';
  @override
  String get priceCalculatorSubtitle =>
      'உங்கள் உழைப்பின் உண்மையான மதிப்பை அறியுங்கள். குறைவாக விற்காதீர்கள்.';
  @override
  String get priceCalculatorButton => 'விலையை சரிபார்க்கவும்';
  @override
  String get priceCalculatorSpeech =>
      'நியாயமான விலை கால்குலேட்டர். அரசு குறைந்தபட்ச ஊதிய அடிப்படையில் உங்கள் உழைப்பின் மதிப்பை அறியுங்கள்.';
  @override
  String get offlineRecogTag => '📶 100% ஆஃப்லைன் அடையாளம்';
  @override
  String get offlineRecogTitle => 'கைவினையை\nஅடையாளம் காணுங்கள்';
  @override
  String get offlineRecogSubtitle =>
      'புகைப்படம் எடுங்கள், இணையம் இன்றியே நுட்பத்தை அறிவோம்.';
  @override
  String get offlineRecogButton => 'கைவினை அறிதல்';
  @override
  String get offlineRecogSpeech =>
      'கைவினை அடையாளம் காணுதல். இணையம் இல்லாமல் 100% ஆஃப்லைனில் செயல்படும்.';
  @override
  String get studioTag => '⚡ 320MS ஸ்டுடியோ பினிஷ்';
  @override
  String get studioTitle => 'ஸ்டுடியோ புகைப்பட\nமெருகூட்டல்';
  @override
  String get studioSubtitle =>
      'வீட்டு புகைப்படங்களை சந்தைத்தரமாக மாற்றவும்.';
  @override
  String get studioButton => 'ஸ்டுடியோவைத் திற';
  @override
  String get studioSpeech =>
      'ஸ்டுடியோ மெருகூட்டல். சாதாரண புகைப்படத்தை சந்தைத்தரமாக மாற்றவும்.';

  @override
  String authPrompt(bool isRegister) => isRegister
      ? 'உங்கள் பெயர் மற்றும் மொபைல் எண்ணை உள்ளிடவும்'
      : 'உங்கள் பதிவுசெய்த மொபைல் எண்ணை உள்ளிடவும்';
  @override
  String authPromptSpeech(bool isRegister) => isRegister
      ? 'சில்பசேதுவில் இணைய உங்கள் முழு பெயர் மற்றும் 10 இலக்க மொபைல் எண்ணை உள்ளிடவும்.'
      : 'உள்நுழைய உங்கள் 10 இலக்க மொபைல் எண்ணை உள்ளிடவும்.';
  @override
  String get registerTab => 'பதிவு செய்க';
  @override
  String get loginTab => 'உள்நுழை';
  @override
  String get fullNameLabel => 'முழுப் பெயர் *';
  @override
  String get fullNameHint => 'எ.கா: ராதாபாய்';
  @override
  String get phoneLabel => 'கைபேசி எண் *';
  @override
  String get phoneHint => '10 இலக்க மொபைல் எண்';
  @override
  String get craftCategoryLabel => 'முதன்மை கைவினைப் பிரிவு';
  @override
  List<String> get craftOptions => const [
        'மண்பாண்டம் & களிமண் கலை',
        'கைத்தறி & நெசவுக்கலை',
        'மரம் & மூங்கில் கைவினை',
        'நகைகள் & பாசி வேலைப்பாடு',
        'எம்பிராய்டரி & ஆடைக்கலை',
        'உலோகம் & பித்தளை வேலைப்பாடு',
        'தோல் & சணல் கைவினை',
        'கல் சிற்பம் & சிலை வடித்தல்',
        'பிற பாரம்பரியக் கைவினை',
      ];
  @override
  String get joinShilpsetu => 'சில்பசேதுவில் இணையுங்கள்';
  @override
  String get loginButton => 'கணக்கில் உள்நுழைக';
  @override
  String get offlineSyncNotice =>
      'ஆஃப்லைனில் செயல்படும் • இலவச அரசு சந்தை பாலம்';
  @override
  String get nameError => 'சரியான பெயரை உள்ளிடவும் (குறைந்தது 2 எழுத்துக்கள்)';
  @override
  String get phoneError => 'சரியான 10 இலக்க மொபைல் எண்ணை உள்ளிடவும்';
  @override
  String welcomeUser(String name) => '$name, சில்பசேதுவிற்கு நல்வரவு!';

  @override
  String get capturePrompt => 'நீங்கள் செய்ததை காட்டுங்கள்';
  @override
  String get captureInstructionsTooltip => 'அறிவுரைகளைக் கேளுங்கள்';
  @override
  String get captureInstructionsSpeech =>
      'நீங்கள் செய்ததை காட்டுங்கள். கேமராவை பொருளின் மீது வைத்து படம் எடுக்க பொத்தானை அழுத்தவும்.';
  @override
  String get capturePromptReplay =>
      'நீங்கள் செய்ததை காட்டுங்கள். கேமரா பொத்தானை அழுத்தவும்.';
  @override
  String get pointCamera => 'கேமராவை உங்கள் கைவினைப் பொருள் மீது வைக்கவும்';
  @override
  String get qualityBlur => 'புகைப்படம் மங்கலாக உள்ளது. நிலையாக பிடிக்கவும்.';
  @override
  String get qualityTooDark => 'மிகவும் இருட்டாக உள்ளது. வெளிச்சத்திற்கு செல்லுங்கள்.';
  @override
  String get qualityBacklight => 'வெளிச்சம் பொருளின் பின்னால் உள்ளது.';
  @override
  String get qualityReady => 'புகைப்படம் எடுக்க தயார்';
  @override
  String get offlineMlActive => 'ஆஃப்லைன் AI செயலில் உள்ளது';
  @override
  String get switchCamera => 'கேமராவை மாற்று';
  @override
  String get tapToCapture => 'படம் எடுக்கத் தொடவும்';
  @override
  String get retakePhoto => 'மீண்டும் படம் எடு';
  @override
  String get confirmPhoto => 'உறுதிசெய்து தொடரவும்';

  @override
  String get step2StoryBadge => 'படி 2: கைவினை விவரம்';
  @override
  String get step2Prompt => 'படி 2: உங்கள் கைவினை கதையைக் கூறுங்கள்';
  @override
  String get choiceAPhotoOnlyTag => '⚡ உடனடி AI பார்வை';
  @override
  String get choiceAPhotoOnlyTitle => 'புகைப்படத்திலிருந்து AI விவரம்';
  @override
  String get choiceAPhotoOnlySubtitle =>
      'கைவினை பாணி, நிறங்கள் மற்றும் பொருட்களை தானாகக் கண்டறியும்.';
  @override
  String get choiceAPhotoOnlyButton => 'தானாக விவரம் பெறுக';
  @override
  String get choiceAPhotoOnlySpeech =>
      'AI மாதிரி படத்தை ஆய்வு செய்து விவரங்களைத் தயாரிக்கிறது...';
  @override
  String get choiceBVoiceTag => '🎙️ உங்கள் குரல் கதை';
  @override
  String get choiceBVoiceTitle => 'குரல் பதிவு செய்க';
  @override
  String get choiceBVoiceSubtitle =>
      'எவ்வாறு உருவாக்கினீர்கள் என்பதை தாய்மொழியில் எளிதாகப் பேசுங்கள்.';
  @override
  String choiceBVoiceButton(bool isRecording) =>
      isRecording ? 'பதிவை நிறுத்தத் தொடவும்' : 'உங்கள் கதையைக் கூறுங்கள்';
  @override
  String get recordingInProgress => 'கேட்கிறோம்... உங்கள் கைவினையைப் பற்றி பேசுங்கள்';
  @override
  String get descriptionPreviewTitle => 'விவரங்கள் & சிறப்பம்சங்கள்';
  @override
  String get listenDescription => 'விவரத்தைக் கேளுங்கள்';
  @override
  String get continueToPricingButton => 'விலை நிர்ணயத்திற்குச் செல்க';
  @override
  String get continueToPricingSubtitle => 'நியாயமான குறைந்தபட்ச விலையைக் கணக்கிடுங்கள்';

  @override
  String get step3PricingBadge => 'படி 3: விலை நிர்ணயம்';
  @override
  String get step3Prompt => 'படி 3: நியாயமான விலை மாதிரி';
  @override
  String get step3PricingSpeech =>
      'நியாயமான விலை நிர்ணயம். மூலப்பொருள் மற்றும் லாபத்தை நிர்ணயித்து அரசு வழிகாட்டு விலையை அறியுங்கள்.';
  @override
  String get materialCostTitle => 'மூலப்பொருள் செலவு';
  @override
  String get materialCostSubtitle => 'களிமண், மரம், சாயம், துணி, எரிபொருள்';
  @override
  String get materialCostLabel => 'மூலப்பொருள்';
  @override
  String get desiredProfitTitle => 'உங்கள் லாபம்';
  @override
  String get desiredProfitSubtitle => 'உழைப்புக்கான நியாயமான ஊதியம்';
  @override
  String get targetProfitLabel => 'இலக்கு லாபம்';
  @override
  String get costProfitAnalysisTitle => 'செலவு & லாப பகுப்பாய்வு';
  @override
  String get tierFloorTitle => 'குறைந்தபட்ச நியாயமான ஊதியம்';
  @override
  String get tierFloorBadge => 'குறைந்தபட்சம்';
  @override
  String get tierFloorDesc =>
      'இதற்குக் கீழ் விற்றால் உழைப்பு மற்றும் மூலப்பொருளில் இழப்பு ஏற்படும்.';
  @override
  String get tierSuggestedTitle => 'பரிந்துரைக்கப்பட்ட சந்தை விலை';
  @override
  String get tierSuggestedBadge => '⭐ சிறந்தது';
  @override
  String get tierSuggestedDesc =>
      'நல்ல லாபம் மற்றும் சந்தை தேவைக்கு இடையிலான சமநிலை.';
  @override
  String get tierStretchTitle => 'பிரீமியம் விலை';
  @override
  String get tierStretchBadge => 'பிரீமியம்';
  @override
  String get tierStretchDesc =>
      'நகர கண்காட்சிகள் மற்றும் சிறப்பு வாங்குபவர்களுக்காக.';
  @override
  String publishButton(bool isPublishing) =>
      isPublishing ? 'வெளியிடப்படுகிறது...' : 'கடைக்குச் சேர்க்க';
  @override
  String get publishSubtitle => 'டிஜிட்டல் பட்டியலில் சேர்க்கவும்';
  @override
  String get listingPublishedSuccess =>
      'தயாரிப்பு வெற்றிகரமாக உங்கள் கடையில் சேர்க்கப்பட்டது!';

  @override
  String catalogOverviewSpeech(int count) =>
      'உங்களிடம் $count தயாரிப்புகள் உள்ளன. முழு விவரங்களைக் கேட்க தயாரிப்பைத் தொடவும்.';
  @override
  String get myCraftShowroomTag => 'எனது கைவினை அரங்கம்';
  @override
  String get myCraftShowroomTitle => 'கைவினைப்\nபொருட்கள்';
  @override
  String get myCraftShowroomSubtitle =>
      'நியாயமான விலை, உண்மையான கதை, சான்றளிக்கப்பட்ட கைவினை.';
  @override
  String get addNewCraftButton => 'புதிய கைவினை சேர்க்க';
  @override
  String get statTotalCrafts => 'மொத்தப் பொருட்கள்';
  @override
  String get statFairTotal => 'மொத்த மதிப்பு';
  @override
  String get statAvgMargin => 'சராசரி லாபம்';
  @override
  String get filterAll => 'அனைத்து பொருட்கள்';
  @override
  String get filterPublished => 'விற்பனையில்';
  @override
  String get filterDrafts => 'வரைவுகள்';
  @override
  String get emptyCatalogTitle => 'தயாரிப்புகள் எதுவும் இல்லை';
  @override
  String get emptyCatalogSubtitle =>
      'முதல் கைவினையைச் சேர்க்க கேமரா பொத்தானைத் தொடவும்.';
  @override
  String get emptyCatalogButton => 'முதல் படம் எடுங்கள்';
  @override
  String get fairWageBadge => 'நியாய ஊதியம் சான்றளிக்கப்பட்டது';
  @override
  String get suggestedPriceLabel => 'பரிந்துரைக்கப்பட்ட விலை';
  @override
  String get inquiriesButton => 'விசாரணைகளைக் காண்க';

  @override
  String get ordersPrompt => 'வாங்குபவர் ஆர்டர்கள் & விசாரணைகள்';
  @override
  String get filterAllOrders => 'அனைத்தும்';
  @override
  String get filterPending => 'புதிய ஆர்டர்கள்';
  @override
  String get filterConfirmed => 'உறுதிப்படுத்தப்பட்டது';
  @override
  String get buyerOfferedPrice => 'வாங்குபவர் கோரிய விலை';
  @override
  String get replyWhatsApp => 'வாட்ஸ்அப்பில் பதிலளிக்கவும்';
  @override
  String get callBuyer => 'வாங்குபவரை அழைக்கவும்';
  @override
  String get markCompleted => 'முடிந்ததாகக் குறிக்கவும்';
  @override
  String get noOrdersTitle => 'இப்போது புதிய செய்திகள் இல்லை';
  @override
  String get noOrdersSubtitle =>
      'வாங்குபவர்கள் உங்கள் பொருட்களைப் பார்க்கும்போது, விசாரணைகள் இங்கே தோன்றும்.';

  @override
  String get appInfoTooltip => 'பயன்பாட்டு தகவல் & கணக்கு';
  @override
  String get appInfoTitle => 'பயன்பாட்டு தகவல் & கணக்கு';
  @override
  String get accountDetailsTitle => 'கணக்கு விவரங்கள்';
  @override
  String get changeLanguageTile => 'மொழியை மாற்றுக';
  @override
  String get changeLanguageSubtitle => 'உங்கள் தாய்மொழியைத் தேர்ந்தெடுக்கவும்';
  @override
  String get offlineStatusTile => 'ஆஃப்லைன் முறை';
  @override
  String get offlineStatusSubtitle => '100% செயலில் உள்ளது, இணையம் கிடைத்ததும் ஒத்திசைக்கப்படும்';
  @override
  String get aboutTile => 'சில்பசேது பற்றி';
  @override
  String get aboutSubtitle => 'இந்திய அரசு டிஜிட்டல் கைவினைஞர் தளம்';
  @override
  String get logoutTile => 'வெளியேறு';
  @override
  String get logoutConfirm => 'நிச்சயமாக வெளியேற விரும்புகிறீர்களா?';
}

// ============================================================================
// ODIA IMPLEMENTATION (ଓଡ଼ିଆ)
// ============================================================================
class _AppStringsOr extends AppStrings {
  const _AppStringsOr();

  @override
  String get appTitle => 'ଶିଳ୍ପସେତୁ';
  @override
  String get artisanFallback => 'କାରିଗର';
  @override
  String get continueButton => 'ଆଗକୁ ବଢ଼ନ୍ତୁ';
  @override
  String get saveChanges => 'ପରିବର୍ତ୍ତନ ସାଇତନ୍ତୁ';
  @override
  String get cancelButton => 'ବାତିଲ୍';
  @override
  String get retryButton => 'ପୁନର୍ବାର ଚେଷ୍ଟା କରନ୍ତୁ';
  @override
  String get closeButton => 'ବନ୍ଦ କରନ୍ତୁ';
  @override
  String get editButton => 'ସଂଶୋଧନ';
  @override
  String get offlineBadge => 'ଅଫଲାଇନ ପ୍ରସ୍ତୁତ';

  @override
  String get navHome => 'ମୁଖ୍ୟ';
  @override
  String get navCapture => 'ଫଟୋ';
  @override
  String get navCatalog => 'ଉତ୍ପାଦ';
  @override
  String get navOrders => 'ଅର୍ଡର';

  @override
  String get chooseLanguagePrompt => 'ଆପଣଙ୍କ ଭାଷା ବାଛନ୍ତୁ';
  @override
  String get setupProfile => 'ଆପଣଙ୍କ କାରିଗରୀ ପ୍ରୋଫାଇଲ୍ ତିଆରି କରନ୍ତୁ';

  @override
  String greeting(String name) => 'ନମସ୍କାର, $name';
  @override
  String get whatWillYouMake => 'ଆଜି ଆପଣ କ’ଣ ତିଆରି କରିବେ?';
  @override
  String get homeOverviewTooltip => 'ସୂଚନା ଶୁଣନ୍ତୁ';
  @override
  String homeOverviewSpeech(String name) =>
      'ନମସ୍କାର, $name। ଆଜି ଆପଣ କ’ଣ ତିଆରି କରିବେ? କହି ଉତ୍ପାଦ ଯୋଡ଼ନ୍ତୁ, ଉଚିତ ମୂଲ୍ୟ ଜାଣନ୍ତୁ କିମ୍ବା ଶିଳ୍ପ ଚିହ୍ନଟ କରନ୍ତୁ।';
  @override
  String get voiceCatalogingTag => 'ସ୍ୱରରେ ତାଲିକାକରଣ';
  @override
  String get voiceCatalogingTitle => 'ଆପଣଙ୍କ ଶିଳ୍ପ\nଯୋଡ଼ନ୍ତୁ';
  @override
  String get voiceCatalogingSubtitle =>
      'ନିଜ କାହାଣୀ କୁହନ୍ତୁ, ବାକି ଆମେ ସଜାଡ଼ି ଦେବୁ।';
  @override
  String get voiceCatalogingButton => 'କହିବା ଆରମ୍ଭ କରନ୍ତୁ';
  @override
  String get voiceCatalogingSpeech =>
      'ଆପଣଙ୍କ ଶିଳ୍ପ ଯୋଡ଼ନ୍ତୁ। କାହାଣୀ କୁହନ୍ତୁ, ବାକି ବିବରଣୀ ଆମେ ପ୍ରସ୍ତୁତ କରିବୁ।';
  @override
  String get smartArtisanTools => 'ସ୍ମାର୍ଟ କାରିଗର ଟୁଲ୍ସ';
  @override
  String get priceCalculatorTag => '🛡️ ସରକାରୀ ସର୍ବନିମ୍ନ ମଜୁରୀ ଭିତ୍ତିକ';
  @override
  String get priceCalculatorTitle => 'ଉଚିତ ମୂଲ୍ୟ\nକାଲକୁଲେଟର';
  @override
  String get priceCalculatorSubtitle =>
      'ଆପଣଙ୍କ ଶ୍ରମର ସଠିକ ମୂଲ୍ୟ ଜାଣନ୍ତୁ। କମ ଦାମରେ କେବେ ବିକନ୍ତୁ ନାହିଁ।';
  @override
  String get priceCalculatorButton => 'ଉଚିତ ମୂଲ୍ୟ ଦେଖନ୍ତୁ';
  @override
  String get priceCalculatorSpeech =>
      'ଉଚିତ ମୂଲ୍ୟ କାଲକୁଲେଟର। ସରକାରୀ ସର୍ବନିମ୍ନ ମଜୁରୀ ଆଧାରରେ ଆପଣଙ୍କ ଶ୍ରମର ମୂଲ୍ୟ ଜାଣନ୍ତୁ।';
  @override
  String get offlineRecogTag => '📶 ୧୦୦% ଅଫଲାଇନ ଚିହ୍ନଟ';
  @override
  String get offlineRecogTitle => 'ଶିଳ୍ପ\nଚିହ୍ନଟ କରନ୍ତୁ';
  @override
  String get offlineRecogSubtitle =>
      'ଫଟୋ ଉଠାନ୍ତୁ, ବିନା ଇଣ୍ଟରନେଟରେ କଳା ଚିହ୍ନିବୁ।';
  @override
  String get offlineRecogButton => 'ଶିଳ୍ପ ଚିହ୍ନଟ';
  @override
  String get offlineRecogSpeech =>
      'ଶିଳ୍ପ ଚିହ୍ନଟ। ଫଟୋ ଉଠାନ୍ତୁ, ଏହା ବିନା ଇଣ୍ଟରନେଟରେ କାମ କରେ।';
  @override
  String get studioTag => '⚡ ୩୨୦MS ଷ୍ଟୁଡିଓ ଫିନିଶ';
  @override
  String get studioTitle => 'ଷ୍ଟୁଡିଓ ଫଟୋ\nସୁଧାର';
  @override
  String get studioSubtitle =>
      'ଘରର ସାଧାରଣ ଫଟୋକୁ ବଜାର ପରି ସଫା କରନ୍ତୁ।';
  @override
  String get studioButton => 'ଷ୍ଟୁଡିଓ ଖୋଲନ୍ତୁ';
  @override
  String get studioSpeech =>
      'ଷ୍ଟୁଡିଓ ଫଟୋ। ସାଧାରଣ ଫଟୋକୁ ବଜାର ଭଳି ପରିଷ୍କାର କରନ୍ତୁ।';

  @override
  String authPrompt(bool isRegister) => isRegister
      ? 'ଆପଣଙ୍କ ନାମ ଏବଂ ମୋବାଇଲ ନମ୍ବର ଦିଅନ୍ତୁ'
      : 'ଆପଣଙ୍କ ପଞ୍ଜୀକୃତ ମୋବାଇଲ ନମ୍ବର ଦିଅନ୍ତୁ';
  @override
  String authPromptSpeech(bool isRegister) => isRegister
      ? 'ଶିଳ୍ପସେତୁରେ ଯୋଡ଼ି ହେବା ପାଇଁ ଦୟାକରି ଆପଣଙ୍କ ପୂରା ନାମ ଏବଂ ୧୦ ଅଙ୍କର ମୋବାଇଲ ନମ୍ବର ଦିଅନ୍ତୁ।'
      : 'ଲଗଇନ କରିବା ପାଇଁ ୧୦ ଅଙ୍କର ମୋବାଇଲ ନମ୍ବର ଦିଅନ୍ତୁ।';
  @override
  String get registerTab => 'ପଞ୍ଜୀକରଣ';
  @override
  String get loginTab => 'ଲଗଇନ';
  @override
  String get fullNameLabel => 'ପୂରା ନାମ *';
  @override
  String get fullNameHint => 'ଯଥା: ରାଧା କୁମ୍ଭାର';
  @override
  String get phoneLabel => 'ମୋବାଇଲ ନମ୍ବର *';
  @override
  String get phoneHint => '୧୦ ଅଙ୍କର ମୋବାଇଲ ନମ୍ବର';
  @override
  String get craftCategoryLabel => 'ମୁଖ୍ୟ ଶିଳ୍ପ ବର୍ଗ';
  @override
  List<String> get craftOptions => const [
        'ମୃତ୍ତିକା ଓ ମାଟି କଳା',
        'ହସ୍ତତନ୍ତ ଓ ବୁଣାକାର ଶିଳ୍ପ',
        'କାଠ ଓ ବାଉଁଶ ଶିଳ୍ପ',
        'ଅଳଙ୍କାର ଓ ମୋତି କାମ',
        'ଏମ୍ବ୍ରୋଇଡାରୀ ଓ ବସ୍ତ୍ରକଳା',
        'ଧାତୁ ଓ ପିତ୍ତଳ କାମ',
        'ଚମଡ଼ା ଓ ଝୋଟ ଶିଳ୍ପ',
        'ପଥର ଖୋଦେଇ ଓ ମୂର୍ତ୍ତିକଳା',
        'ଅନ୍ୟ ପାରମ୍ପରିକ ହସ୍ତଶିଳ୍ପ',
      ];
  @override
  String get joinShilpsetu => 'ଶିଳ୍ପସେତୁରେ ଯୋଡ଼ି ହୁଅନ୍ତୁ';
  @override
  String get loginButton => 'ଖାତାରେ ଲଗଇନ କରନ୍ତୁ';
  @override
  String get offlineSyncNotice =>
      'ଅଫଲାଇନରେ କାମ କରେ • ମାଗଣା ସରକାରୀ ବଜାର ସେତୁ';
  @override
  String get nameError => 'ଦୟାକରି ସଠିକ ନାମ ଦିଅନ୍ତୁ (ଅତି କମରେ ୨ ଅକ୍ଷର)';
  @override
  String get phoneError => 'ଦୟାକରି ୧୦ ଅଙ୍କର ବୈଧ ମୋବାଇଲ ନମ୍ବର ଦିଅନ୍ତୁ';
  @override
  String welcomeUser(String name) => '$name, ଶିଳ୍ପସେତୁକୁ ଆପଣଙ୍କୁ ସ୍ୱାଗତ!';

  @override
  String get capturePrompt => 'ଆପଣ ଯାହା ତିଆରି କରିଛନ୍ତି ଦେଖାନ୍ତୁ';
  @override
  String get captureInstructionsTooltip => 'ନିର୍ଦ୍ଦେଶ ଶୁଣନ୍ତୁ';
  @override
  String get captureInstructionsSpeech =>
      'ଆପଣ ଯାହା ତିଆରି କରିଛନ୍ତି ଦେଖାନ୍ତୁ। କ୍ୟାମେରା ମଝିରେ ରଖି ଫଟୋ ନେବାକୁ ବଟନ ଦବାନ୍ତୁ।';
  @override
  String get capturePromptReplay =>
      'ଆପଣ ଯାହା ତିଆରି କରିଛନ୍ତି ଦେଖାନ୍ତୁ। କ୍ୟାମେରା ବଟନ ଦବାନ୍ତୁ।';
  @override
  String get pointCamera => 'କ୍ୟାମେରାକୁ ନିଜ ଶିଳ୍ପ ଆଡ଼କୁ ରଖନ୍ତୁ';
  @override
  String get qualityBlur => 'ଫଟୋ ଅସ୍ପଷ୍ଟ ଅଛି। ଦୟାକରି ସ୍ଥିର ରୁହନ୍ତୁ।';
  @override
  String get qualityTooDark => 'ବହୁତ ଅନ୍ଧାର। ଆଲୋକ ଥିବା ଜାଗାକୁ ଯାନ୍ତୁ।';
  @override
  String get qualityBacklight => 'ଆଲୋକ ବସ୍ତୁ ପଛରେ ଅଛି।';
  @override
  String get qualityReady => 'ଫଟୋ ନେବାକୁ ପ୍ରସ୍ତୁତ';
  @override
  String get offlineMlActive => 'ଡିଭାଇସରେ AI ସକ୍ରିୟ';
  @override
  String get switchCamera => 'କ୍ୟାମେରା ବଦଳାନ୍ତୁ';
  @override
  String get tapToCapture => 'ଫଟୋ ନେବାକୁ ଟ୍ୟାପ୍ କରନ୍ତୁ';
  @override
  String get retakePhoto => 'ପୁଣି ଫଟୋ ନିଅନ୍ତୁ';
  @override
  String get confirmPhoto => 'ନିଶ୍ଚିତ କରି ଆଗକୁ ବଢ଼ନ୍ତୁ';

  @override
  String get step2StoryBadge => 'ପାହାଚ ୨: ଶିଳ୍ପ ବିବରଣୀ';
  @override
  String get step2Prompt => 'ପାହାଚ ୨: ଆପଣଙ୍କ ଶିଳ୍ପର କାହାଣୀ କୁହନ୍ତୁ';
  @override
  String get choiceAPhotoOnlyTag => '⚡ ତତକ୍ଷଣାତ AI ଦୃଷ୍ଟି';
  @override
  String get choiceAPhotoOnlyTitle => 'କେବଳ ଫଟୋରୁ ବିବରଣୀ';
  @override
  String get choiceAPhotoOnlySubtitle =>
      'ମଡେଲ ଆପେ ଆପେ ଶୈଳୀ, ରଙ୍ଗ ଓ ସାମଗ୍ରୀ ଚିହ୍ନଟ କରେ।';
  @override
  String get choiceAPhotoOnlyButton => 'ସ୍ୱତଃ ବିବରଣୀ ପ୍ରସ୍ତୁତ';
  @override
  String get choiceAPhotoOnlySpeech =>
      'AI ମଡେଲ ଫଟୋ ଦେଖି ବିବରଣୀ ପ୍ରସ୍ତୁତ କରୁଛି...';
  @override
  String get choiceBVoiceTag => '🎙️ ଆପଣଙ୍କ କଣ୍ଠସ୍ୱର';
  @override
  String get choiceBVoiceTitle => 'ସ୍ୱର ରେକର୍ଡ କରନ୍ତୁ';
  @override
  String get choiceBVoiceSubtitle =>
      'ଏହାକୁ କିପରି ତିଆରି କଲେ ନିଜ ମାତୃଭାଷାରେ ସହଜରେ କୁହନ୍ତୁ।';
  @override
  String choiceBVoiceButton(bool isRecording) =>
      isRecording ? 'ରେକର୍ଡିଂ ବନ୍ଦ କରିବାକୁ ଦବାନ୍ତୁ' : 'ନିଜ କାହାଣୀ କୁହନ୍ତୁ';
  @override
  String get recordingInProgress => 'ଶୁଣୁଛୁ... ଆପଣଙ୍କ କଳା ବିଷୟରେ କୁହନ୍ତୁ';
  @override
  String get descriptionPreviewTitle => 'ବିବରଣୀ ଓ ବିଶେଷତା';
  @override
  String get listenDescription => 'ବିବରଣୀ ଶୁଣନ୍ତୁ';
  @override
  String get continueToPricingButton => 'ଉଚିତ ମୂଲ୍ୟ ଆଡ଼କୁ ଯାଆନ୍ତୁ';
  @override
  String get continueToPricingSubtitle => 'ସ୍ୱଚ୍ଛ ସର୍ବନିମ୍ନ ମୂଲ୍ୟ ଗଣନା କରନ୍ତୁ';

  @override
  String get step3PricingBadge => 'ପାହାଚ ୩: ମୂଲ୍ୟ ନିର୍ଦ୍ଧାରଣ';
  @override
  String get step3Prompt => 'ପାହାଚ ୩: ଉଚିତ ମୂଲ୍ୟ ମଡେଲ';
  @override
  String get step3PricingSpeech =>
      'ଉଚିତ ମୂଲ୍ୟ ନିର୍ଦ୍ଧାରଣ। କଞ୍ଚାମାଲ ଖର୍ଚ୍ଚ ଏବଂ ଲାଭ ସ୍ଥିର କରି ସରକାରୀ ସର୍ବନିମ୍ନ ମୂଲ୍ୟ ଜାଣନ୍ତୁ।';
  @override
  String get materialCostTitle => 'କଞ୍ଚାମାଲ ଖର୍ଚ୍ଚ';
  @override
  String get materialCostSubtitle => 'ମାଟି, କାଠ, ରଙ୍ଗ, କପଡ଼ା, ଇନ୍ଧନ ଇତ୍ୟାଦି';
  @override
  String get materialCostLabel => 'କଞ୍ଚାମାଲ';
  @override
  String get desiredProfitTitle => 'ଆପଣଙ୍କ ଲାଭ';
  @override
  String get desiredProfitSubtitle => 'ଶ୍ରମ ଓ ଦକ୍ଷତାର ଉଚିତ ପାରିଶ୍ରମିକ';
  @override
  String get targetProfitLabel => 'ଲକ୍ଷ୍ୟ ଲାଭ';
  @override
  String get costProfitAnalysisTitle => 'ଖର୍ଚ୍ଚ ଓ ଲାଭ ବିଶ୍ଳେଷଣ';
  @override
  String get tierFloorTitle => 'ସର୍ବନିମ୍ନ ଉଚିତ ମଜୁରୀ';
  @override
  String get tierFloorBadge => 'କମରେ କମ';
  @override
  String get tierFloorDesc =>
      'ଏହି ମୂଲ୍ୟରୁ କମ ବିକିଲେ ଶ୍ରମ ଓ ସାମଗ୍ରୀରେ କ୍ଷତି ହୁଏ।';
  @override
  String get tierSuggestedTitle => 'ପ୍ରସ୍ତାବିତ ବଜାର ଦର';
  @override
  String get tierSuggestedBadge => '⭐ ସର୍ବୋତ୍ତମ';
  @override
  String get tierSuggestedDesc =>
      'ଭଲ ଲାଭ ଏବଂ ବଜାର ଚାହିଦା ମଧ୍ୟରେ ଉତ୍ତମ ସନ୍ତୁଳନ।';
  @override
  String get tierStretchTitle => 'ପ୍ରିମିୟମ ଦର';
  @override
  String get tierStretchBadge => 'ପ୍ରିମିୟମ';
  @override
  String get tierStretchDesc =>
      'ସହରୀ ପ୍ରଦର୍ଶନୀ ଓ ବିଶେଷ ଗ୍ରାହକଙ୍କ ପାଇଁ।';
  @override
  String publishButton(bool isPublishing) =>
      isPublishing ? 'ପ୍ରକାଶିତ ହେଉଛି...' : 'ଦୋକାନରେ ଯୋଡ଼ନ୍ତୁ';
  @override
  String get publishSubtitle => 'ଡିଜିଟାଲ କାଟାଲଗ୍‌ରେ ଯୋଡ଼ନ୍ତୁ';
  @override
  String get listingPublishedSuccess =>
      'ଉତ୍ପାଦଟି ସଫଳତାର ସହ ଆପଣଙ୍କ ଦୋକାନରେ ଯୋଡ଼ାଗଲା!';

  @override
  String catalogOverviewSpeech(int count) =>
      'ଆପଣଙ୍କ ପାଖରେ $count ଉତ୍ପାଦ ଅଛି। ପୂରା ବିବରଣୀ ଶୁଣିବାକୁ ଉତ୍ପାଦ ଉପରେ ଟ୍ୟାପ୍ କରନ୍ତୁ।';
  @override
  String get myCraftShowroomTag => 'ମୋର ଶିଳ୍ପ ପ୍ରଦର୍ଶନୀ';
  @override
  String get myCraftShowroomTitle => 'ହସ୍ତଶିଳ୍ପ\nସଂଗ୍ରହ';
  @override
  String get myCraftShowroomSubtitle =>
      'ଉଚିତ ମୂଲ୍ୟ, ସତ କାହାଣୀ, ପ୍ରମାଣିତ କଳା।';
  @override
  String get addNewCraftButton => 'ନୂଆ ଶିଳ୍ପ ଯୋଡ଼ନ୍ତୁ';
  @override
  String get statTotalCrafts => 'ମୋଟ ଉତ୍ପାଦ';
  @override
  String get statFairTotal => 'ମୋଟ ମୂଲ୍ୟ';
  @override
  String get statAvgMargin => 'ହାରାହାରି ଲାଭ';
  @override
  String get filterAll => 'ସମସ୍ତ ଉତ୍ପାଦ';
  @override
  String get filterPublished => 'ଲାଇଭ୍';
  @override
  String get filterDrafts => 'ଡ୍ରାଫ୍ଟ';
  @override
  String get emptyCatalogTitle => 'କୌଣସି ଉତ୍ପାଦ ନାହିଁ';
  @override
  String get emptyCatalogSubtitle =>
      'ପ୍ରଥମ ଶିଳ୍ପ ଯୋଡ଼ିବାକୁ କ୍ୟାମେରା ବଟନ ଦବାନ୍ତୁ।';
  @override
  String get emptyCatalogButton => 'ପ୍ରଥମ ଫଟୋ ନିଅନ୍ତୁ';
  @override
  String get fairWageBadge => 'ଉଚିତ ମଜୁରୀ ପ୍ରମାଣିତ';
  @override
  String get suggestedPriceLabel => 'ପ୍ରସ୍ତାବିତ ମୂଲ୍ୟ';
  @override
  String get inquiriesButton => 'ପଚରାଉଚୁରା ଦେଖନ୍ତୁ';

  @override
  String get ordersPrompt => 'ଗ୍ରାହକ ଅର୍ଡର ଓ ପଚରାଉଚୁରା';
  @override
  String get filterAllOrders => 'ସମସ୍ତ';
  @override
  String get filterPending => 'ନୂଆ ଅର୍ଡର';
  @override
  String get filterConfirmed => 'ନିଶ୍ଚିତ';
  @override
  String get buyerOfferedPrice => 'ଗ୍ରାହକଙ୍କ ପ୍ରସ୍ତାବିତ ଦର';
  @override
  String get replyWhatsApp => 'ହ୍ୱାଟ୍ସଆପ୍‌ରେ ଉତ୍ତର ଦିଅନ୍ତୁ';
  @override
  String get callBuyer => 'କଲ୍ କରନ୍ତୁ';
  @override
  String get markCompleted => 'ସମ୍ପୂର୍ଣ୍ଣ ଚିହ୍ନଟ କରନ୍ତୁ';
  @override
  String get noOrdersTitle => 'ବର୍ତ୍ତମାନ କୌଣସି ନୂଆ ବାର୍ତ୍ତା ନାହିଁ';
  @override
  String get noOrdersSubtitle =>
      'ଯେତେବେଳେ ଗ୍ରାହକ ଆପଣଙ୍କ ଉତ୍ପାଦ ଦେଖିବେ, ଏଠାରେ ଅର୍ଡର ଦେଖାଯିବ।';

  @override
  String get appInfoTooltip => 'ଆପ୍ ସୂଚନା ଏବଂ ଖାତା';
  @override
  String get appInfoTitle => 'ଆପ୍ ସୂଚନା ଏବଂ ଖାତା';
  @override
  String get accountDetailsTitle => 'ଖାତା ବିବରଣୀ';
  @override
  String get changeLanguageTile => 'ଭାଷା ବଦଳାନ୍ତୁ';
  @override
  String get changeLanguageSubtitle => 'ଆପଣଙ୍କ ମାତୃଭାଷା ବାଛନ୍ତୁ';
  @override
  String get offlineStatusTile => 'ଅଫଲାଇନ ମୋଡ୍';
  @override
  String get offlineStatusSubtitle => '୧୦୦% ସକ୍ରିୟ, ନେଟୱାର୍କ ଆସିଲେ ସିଙ୍କ ହେବ';
  @override
  String get aboutTile => 'ଶିଳ୍ପସେତୁ ବିଷୟରେ';
  @override
  String get aboutSubtitle => 'ଭାରତ ସରକାରଙ୍କ ଡିଜିଟାଲ କାରିଗର ମଞ୍ଚ';
  @override
  String get logoutTile => 'ଲଗଆଉଟ୍';
  @override
  String get logoutConfirm => 'ଆପଣ ନିଶ୍ଚିତ ଭାବେ ବାହାରିବାକୁ ଚାହାଁନ୍ତି କି?';
}

// ============================================================================
// MARATHI IMPLEMENTATION (मराठी)
// ============================================================================
class _AppStringsMr extends AppStrings {
  const _AppStringsMr();

  @override
  String get appTitle => 'शिल्पसेतू';
  @override
  String get artisanFallback => 'कारागीर';
  @override
  String get continueButton => 'पुढे जा';
  @override
  String get saveChanges => 'बदल जतन करा';
  @override
  String get cancelButton => 'रद्द करा';
  @override
  String get retryButton => 'पुन्हा प्रयत्न करा';
  @override
  String get closeButton => 'बंद करा';
  @override
  String get editButton => 'संपादित करा';
  @override
  String get offlineBadge => 'ऑफलाइन तयार';

  @override
  String get navHome => 'होम';
  @override
  String get navCapture => 'फोटो';
  @override
  String get navCatalog => 'उत्पादने';
  @override
  String get navOrders => 'ऑर्डर्स';

  @override
  String get chooseLanguagePrompt => 'तुमची भाषा निवडा';
  @override
  String get setupProfile => 'तुमचे कारागीर प्रोफाइल तयार करा';

  @override
  String greeting(String name) => 'नमस्ते, $name';
  @override
  String get whatWillYouMake => 'आज आपण काय बनवणार आहात?';
  @override
  String get homeOverviewTooltip => 'माहिती ऐका';
  @override
  String homeOverviewSpeech(String name) =>
      'नमस्ते, $name. आज आपण काय बनवणार आहात? आवाजाने उत्पादन जोडा, योग्य दर जाणा किंवा हस्तकला ओळखा.';
  @override
  String get voiceCatalogingTag => 'आवाजाने कॅटलॉगिंग';
  @override
  String get voiceCatalogingTitle => 'आपली कला\nजोडा';
  @override
  String get voiceCatalogingSubtitle =>
      'आपली गोष्ट सांगा, बाकी आम्ही तयार करू.';
  @override
  String get voiceCatalogingButton => 'आवाजाने सुरू करा';
  @override
  String get voiceCatalogingSpeech =>
      'आपली हस्तकला जोडा. गोष्ट सांगा, उर्वरित माहिती आम्ही तयार करू.';
  @override
  String get smartArtisanTools => 'स्मार्ट कारागीर टूल्स';
  @override
  String get priceCalculatorTag => '🛡️ सरकारी किमान वेतन आधार';
  @override
  String get priceCalculatorTitle => 'योग्य दर\nकॅल्क्युलेटर';
  @override
  String get priceCalculatorSubtitle =>
      'आपल्या कष्टाचे खरे मूल्य जाणा. कमी भावात कधीही विकू नका.';
  @override
  String get priceCalculatorButton => 'योग्य दर तपासा';
  @override
  String get priceCalculatorSpeech =>
      'योग्य दर कॅल्क्युलेटर. सरकारी किमान वेतनाच्या आधारे आपल्या कष्टाचे खरे मूल्य जाणा.';
  @override
  String get offlineRecogTag => '📶 १००% ऑफलाइन ओळख';
  @override
  String get offlineRecogTitle => 'शिल्पकला\nओळखा';
  @override
  String get offlineRecogSubtitle =>
      'फोटो काढा, आम्ही इंटरनेटशिवाय तंत्रज्ञान ओळखू.';
  @override
  String get offlineRecogButton => 'शिल्प ओळखा';
  @override
  String get offlineRecogSpeech =>
      'शिल्प ओळख. फोटो काढा, हे इंटरनेटशिवाय १००% ऑफलाइन चालते.';
  @override
  String get studioTag => '⚡ ३२०MS स्टुडिओ फिनिश';
  @override
  String get studioTitle => 'स्टुडिओ फोटो\nसुधारक';
  @override
  String get studioSubtitle =>
      'घरातील सामान्य फोटो बाजारासारखा सुंदर बनवा.';
  @override
  String get studioButton => 'स्टुडिओ उघडा';
  @override
  String get studioSpeech =>
      'स्टुडिओ फोटो सुधारक. साध्या फोटोला बाजारासारखे स्वच्छ बनवा.';

  @override
  String authPrompt(bool isRegister) => isRegister
      ? 'आपले नाव आणि मोबाईल क्रमांक प्रविष्ट करा'
      : 'आपला नोंदणीकृत मोबाईल क्रमांक प्रविष्ट करा';
  @override
  String authPromptSpeech(bool isRegister) => isRegister
      ? 'शिल्पसेतूमध्ये सामील होण्यासाठी कृपया आपले पूर्ण नाव आणि १० अंकी मोबाईल नंबर प्रविष्ट करा.'
      : 'लॉग इन करण्यासाठी १० अंकी मोबाईल नंबर प्रविष्ट करा.';
  @override
  String get registerTab => 'नोंदणी';
  @override
  String get loginTab => 'लॉग इन';
  @override
  String get fullNameLabel => 'कारागिराचे पूर्ण नाव *';
  @override
  String get fullNameHint => 'उदा. राधाबाई कुंभार';
  @override
  String get phoneLabel => 'मोबाईल क्रमांक *';
  @override
  String get phoneHint => '१० अंकी मोबाईल क्रमांक';
  @override
  String get craftCategoryLabel => 'मुख्य हस्तकला प्रकार';
  @override
  List<String> get craftOptions => const [
        'मातीकाम व कुंभारकाम',
        'हातमाग व विणकाम',
        'लाकूड व बांबू हस्तकला',
        'दागिने व मणीकाम',
        'भरतकाम व वस्त्रकला',
        'धातूकाम व पितळ हस्तकला',
        'चर्मोद्योग व ज्यूट कला',
        'दगड कोरीव काम व मूर्तिकला',
        'इतर पारंपरिक हस्तकला',
      ];
  @override
  String get joinShilpsetu => 'शिल्पसेतूमध्ये सामील व्हा';
  @override
  String get loginButton => 'खात्यात लॉग इन करा';
  @override
  String get offlineSyncNotice =>
      'ऑफलाइन कार्य करते • विनामूल्य सरकारी बाजार सेतू';
  @override
  String get nameError => 'कृपया योग्य नाव प्रविष्ट करा (किमान २ अक्षरे)';
  @override
  String get phoneError => 'कृपया १० अंकांचा वैध मोबाईल क्रमांक प्रविष्ट करा';
  @override
  String welcomeUser(String name) => '$name, शिल्पसेतूमध्ये आपले स्वागत आहे!';

  @override
  String get capturePrompt => 'तुम्ही जे बनवले आहे ते दाखवा';
  @override
  String get captureInstructionsTooltip => 'सूचना ऐका';
  @override
  String get captureInstructionsSpeech =>
      'तुम्ही जे बनवले आहे ते दाखवा. वस्तू फ्रेमच्या मध्यभागी ठेवा आणि फोटो काढण्यासाठी कॅमेरा बटण दाबा.';
  @override
  String get capturePromptReplay =>
      'तुम्ही जे बनवले आहे ते दाखवा. कॅमेरा बटण दाबा.';
  @override
  String get pointCamera => 'कॅमेरा आपल्या कलेकडे धरा';
  @override
  String get qualityBlur => 'फोटो अस्पष्ट आहे. कृपया स्थिर ठेवा.';
  @override
  String get qualityTooDark => 'खूप अंधार आहे. उजळ प्रकाशात जा.';
  @override
  String get qualityBacklight => 'प्रकाश वस्तूच्या मागे आहे. प्रकाशाकडे तोंड करा.';
  @override
  String get qualityReady => 'फोटो काढण्यास तयार';
  @override
  String get offlineMlActive => 'डिव्हाइसवर AI सक्रिय';
  @override
  String get switchCamera => 'कॅमेरा बदला';
  @override
  String get tapToCapture => 'फोटो काढण्यासाठी दाबा';
  @override
  String get retakePhoto => 'पुन्हा फोटो घ्या';
  @override
  String get confirmPhoto => 'पुष्टी करा आणि पुढे जा';

  @override
  String get step2StoryBadge => 'टप्पा २: उत्पादनाचा तपशील';
  @override
  String get step2Prompt => 'टप्पा २: आपल्या कलेची गोष्ट सांगा';
  @override
  String get choiceAPhotoOnlyTag => '⚡ झटपट AI व्हिजन';
  @override
  String get choiceAPhotoOnlyTitle => 'केवळ फोटोवरून तपशील';
  @override
  String get choiceAPhotoOnlySubtitle =>
      'मॉडेल आपोआप शैली, रंग आणि साहित्य ओळखते.';
  @override
  String get choiceAPhotoOnlyButton => 'आपोआप तपशील तयार करा';
  @override
  String get choiceAPhotoOnlySpeech =>
      'AI मॉडेल फोटो पाहून माहिती तयार करत आहे...';
  @override
  String get choiceBVoiceTag => '🎙️ आपला आवाज';
  @override
  String get choiceBVoiceTitle => 'व्हॉइस नोट रेकॉर्ड करा';
  @override
  String get choiceBVoiceSubtitle =>
      'आपण ते कसे बनवले हे मातृभाषेत सहज सांगा.';
  @override
  String choiceBVoiceButton(bool isRecording) =>
      isRecording ? 'रेकॉर्डिंग थांबवण्यासाठी दाबा' : 'आपली गोष्ट सांगा';
  @override
  String get recordingInProgress => 'ऐकत आहोत... आपल्या कलेबद्दल बोला';
  @override
  String get descriptionPreviewTitle => 'तपशील व वैशिष्ट्ये';
  @override
  String get listenDescription => 'तपशील ऐका';
  @override
  String get continueToPricingButton => 'योग्य दर निश्चितीसाठी पुढे जा';
  @override
  String get continueToPricingSubtitle => 'पारदर्शक किमान दर मोजा';

  @override
  String get step3PricingBadge => 'टप्पा ३: दर निश्चिती';
  @override
  String get step3Prompt => 'टप्पा ३: योग्य दर मॉडेल';
  @override
  String get step3PricingSpeech =>
      'योग्य दर निश्चिती. कच्च्या मालाचा खर्च आणि अपेक्षित नफा निश्चित करून योग्य बाजारभाव पाहा.';
  @override
  String get materialCostTitle => 'कच्च्या मालाचा खर्च';
  @override
  String get materialCostSubtitle => 'माती, लाकूड, रंग, कापड, इंधन इत्यादी';
  @override
  String get materialCostLabel => 'कच्चा माल';
  @override
  String get desiredProfitTitle => 'आपला अपेक्षित नफा';
  @override
  String get desiredProfitSubtitle => 'कष्ट आणि कौशल्याचा योग्य मोबदला';
  @override
  String get targetProfitLabel => 'अपेक्षित नफा';
  @override
  String get costProfitAnalysisTitle => 'खर्च व नफा विश्लेषण';
  @override
  String get tierFloorTitle => 'किमान योग्य मोबदला';
  @override
  String get tierFloorBadge => 'किमान दर';
  @override
  String get tierFloorDesc =>
      'या दरापेक्षा कमी विकल्यास श्रम आणि साहित्यात तोटा होतो.';
  @override
  String get tierSuggestedTitle => 'शिफारस केलेला बाजारभाव';
  @override
  String get tierSuggestedBadge => '⭐ सर्वोत्तम';
  @override
  String get tierSuggestedDesc =>
      'चांगला नफा आणि बाजारातील मागणी यात उत्तम संतुलन.';
  @override
  String get tierStretchTitle => 'प्रीमियम दर';
  @override
  String get tierStretchBadge => 'प्रीमियम';
  @override
  String get tierStretchDesc =>
      'शहरी प्रदर्शने, विशेष ग्राहक आणि निर्यातीसाठी.';
  @override
  String publishButton(bool isPublishing) =>
      isPublishing ? 'प्रकाशित होत आहे...' : 'दुकानात जोडा';
  @override
  String get publishSubtitle => 'आपल्या कॅटलॉगमध्ये उत्पादन जोडा';
  @override
  String get listingPublishedSuccess =>
      'उत्पादन यशस्वीरीत्या आपल्या दुकानात जोडले गेले!';

  @override
  String catalogOverviewSpeech(int count) =>
      'आपल्याकडे $count उत्पादने आहेत. संपूर्ण माहिती ऐकण्यासाठी उत्पादनावर दाबा.';
  @override
  String get myCraftShowroomTag => 'माझे कला दालन';
  @override
  String get myCraftShowroomTitle => 'हस्तकला\nसंग्रह';
  @override
  String get myCraftShowroomSubtitle =>
      'योग्य भाव, खरी गोष्ट, अस्सल कारागिरी.';
  @override
  String get addNewCraftButton => 'नवीन उत्पादन जोडा';
  @override
  String get statTotalCrafts => 'एकूण उत्पादने';
  @override
  String get statFairTotal => 'एकूण मूल्य';
  @override
  String get statAvgMargin => 'सरासरी नफा';
  @override
  String get filterAll => 'सर्व उत्पादने';
  @override
  String get filterPublished => 'लाइव्ह';
  @override
  String get filterDrafts => 'मसुदा';
  @override
  String get emptyCatalogTitle => 'अद्याप कोणतीही उत्पादने नाहीत';
  @override
  String get emptyCatalogSubtitle =>
      'पहिले उत्पादन जोडण्यासाठी खालील कॅमेरा बटण दाबा.';
  @override
  String get emptyCatalogButton => 'पहिला फोटो काढा';
  @override
  String get fairWageBadge => 'योग्य वेतन प्रमाणित';
  @override
  String get suggestedPriceLabel => 'शिफारस केलेला दर';
  @override
  String get inquiriesButton => 'चौकशी पाहा';

  @override
  String get ordersPrompt => 'ग्राहकांच्या ऑर्डर्स व विचारणा';
  @override
  String get filterAllOrders => 'सर्व';
  @override
  String get filterPending => 'नवीन ऑर्डर्स';
  @override
  String get filterConfirmed => 'स्वीकृत';
  @override
  String get buyerOfferedPrice => 'ग्राहकाने दिलेला दर';
  @override
  String get replyWhatsApp => 'व्हॉट्सॲपवर उत्तर द्या';
  @override
  String get callBuyer => 'ग्राहकाला कॉल करा';
  @override
  String get markCompleted => 'पूर्ण म्हणून चिन्हांकित करा';
  @override
  String get noOrdersTitle => 'सध्या कोणताही नवीन संदेश नाही';
  @override
  String get noOrdersSubtitle =>
      'जेव्हा ग्राहक आपली उत्पादने पाहतील, तेव्हा विचारणा येथे दिसेल.';

  @override
  String get appInfoTooltip => 'माहिती व खाते';
  @override
  String get appInfoTitle => 'माहिती व खाते';
  @override
  String get accountDetailsTitle => 'खाते तपशील';
  @override
  String get changeLanguageTile => 'अॅपची भाषा बदला';
  @override
  String get changeLanguageSubtitle => 'आपली मातृभाषा निवडा';
  @override
  String get offlineStatusTile => 'ऑफलाइन मोड';
  @override
  String get offlineStatusSubtitle => '१००% सक्रिय, नेटवर्क आल्यावर सिंक होईल';
  @override
  String get aboutTile => 'शिल्पसेतूबद्दल';
  @override
  String get aboutSubtitle => 'भारत सरकारचा डिजिटल कारागीर मंच';
  @override
  String get logoutTile => 'लॉग आउट';
  @override
  String get logoutConfirm => 'आपण खरोखर बाहेर पडू इच्छिता?';
}
