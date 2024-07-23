// ---------- app config ----------
String ENV_CONFIG_SELECTED = productionRoute;
bool enableInspector = false;

int ENV_CONFIG_CLICKS = 0;
String apiRoute = devRoute;
String baseUrl = 'https://$apiRoute.helpooapp.net/api/';
String imagesBaseUrl = 'https://$apiRoute.helpooapp.net';
const String devRoute = 'apidev';
const String stagingRoute = 'apistaging';
const String productionRoute = 'api';

const String apiVersion = 'v2/';

// ---- auth end points ----
const String loginEndPoint = 'users/login';
const String registerEndPoint = 'users/signup';
const String sendOtpEndpoint = 'sms/sendOTP';
const String verifyOtpEndpoint = 'sms/verifyOTP';
const String sendOtpLoginEndpoint = 'sms/sendLoginOTP';
const String loginOtpEndpoint = 'users/loginWithOTP';
const String signUpOtpEndpoint = 'users/signupWithOTP';
const String forgotPasswordEndPoint = 'users/forgotPassword';
const String resetPasswordEndPoint = 'users/resetPassword';
const String checkIfUserExistEndPoint = 'users/checkExist';
const String profileEndPoint = 'users/me';
const String updateUserProfileEndPoint = 'users/updateMe';

// ---- Packages end points ----
const String getAllPackagesEndPoint = 'packages/getAll';
const String getPromoWithFilter = 'packagepromo/promoWithFilter';
const String getPromoStateEndPoint = 'packagepromo/promoWithValidation';
const String usePromoOnPackageEndPoint = 'packagepromo/useOnPackage';
const String useNormalPromoEndPoint = 'promoCode/assignPromo';
const String usePromoShellUrl = 'packagePromo/shellPromo';
const String checkPromoPackageOrNormalEndPoint = 'packagePromo/checkIfExists';
const String usePromoOnPackagesEndPoint = 'packagepromo/useOnPackage';
const String getMyPackagesEndPoint = 'packages/clientPackages';
const String getUnFilledPackagesEndPoint = 'packages/unFilledClientPackages';
const String getPackagesByCorporateEndPoint = 'packagePromo/byCorporate';
const String useByCorporateEndPoint = 'packagePromo/useByCorporate';

// ---- get Payment Iframe end points ----
const String getPaymentIframeEndPoint = 'paymob/getIframe';

const String getAllManufacturersEndPoint = 'manufacturers';
const String getInsuranceCompanyCarEndPoint = 'cars/getCarByVINNumber';
const String getModelsForManufacturerEndPoint = 'carModels/manufacturer/';

// ---- fnol ----

const String fnolRequiredImagesEndPoint = 'accidentTypes/images';
const String fnolupdateFnolCommentEndPoint = 'accidentReports/updateReport/';
const String getAllAccidentTypesEndPoint = 'accidentTypes';
const String getAllInsuranceCompaniesEndPoint = 'insuranceCompanies';
const String getLatestFnolsEndPoint = 'accidentReports/latestReports/';
const String uploadImagesEndPoint = 'inspections/uploadImages/';
const String uploadFnolBillEndPoint = 'accidentReports/submitBill/';
const String uploadImagesFnolEndPoint = 'accidentReports/uploadImages/';
const String updateStausFnolEndPoint = 'accidentReports/updateStatus/';
const String createFnolEndPoint = 'accidentReports';

const mapUrl = 'https://maps.googleapis.com/maps/api/';
const getPlacesDetailsUrl = 'place/details/json';
const getPlacesDetailsByCoordinatesUrl = 'geocode/json';
const String accidentReportsDetailsPoint = 'accidentReports/show';

// ----- Cars -----
const String getMyCarsEndPoint = 'cars/myCars';
const String subscribeCarToPackageEndPoint = 'packages/subscribeCar';
const String addCarEndPoint = 'cars/addCar';
const String editCarEndPoint = 'cars/updateCar/';
const String activateCarEndPoint = 'cars/confirmAndActivate/';

const String getConfigEndPoint = 'settings/allConfig';

// ----- Service requests -----
const String requestServiceEndPoint = 'serviceRequest/create';
const String requestOtherService = 'serviceRequest/createOtherServices';
const String getNearestDriverEndPoint = 'drivers/getDriver';
const String rateRequestEndPoint = 'serviceRequest/commentAndRate/create';

const String assignDriverToRequestEndPoint = 'drivers/assignDriver';
const String getUserLatestRequestsEndPoint =
    'serviceRequest/latestRequests/'; // .../{id}
const String getCorporateLatestRequestsEndPoint =
    'serviceRequest/latestCorpRequests/'; // .../{userId}
const String checkForCurrentActiveRequestEndPoint =
    'serviceRequest/check/'; // .../{id}
const String cancelRequestEndPoint = 'serviceRequest/cancel/'; // .../{id}
const String getRequestByIdEndPoint = 'serviceRequest/getOne/'; // .../{id}
const String getRequestTimeAndDistanceByIdEndPoint =
    'drivers/getDurationAndDistance/'; // .../{id}
const String getTimeAndDistanceOtherServices =
    'drivers/getDurationAndDistanceOtherServices';
const String getDriverLocationDetails = "drivers/getDriverOtherServices";
const String calculateTripFeesEndPoint = 'serviceRequest/calculateFees';
const String calculateTripFeesOtherService =
    '/serviceRequest/calculateFeesOtherServices';
const String updateOneServiceRequestUrl = 'serviceRequest/update';
const String logGoogleMapsApiUrl = 'trackinglogs';
const String decodedPointsUrl = 'settings/encodeString';
const createPdfReportCombineEndPoint = 'carAccidentReport/createPdfReport';

/// ---------------- map box -----------------

const mapBoxPK =
    "pk.eyJ1IjoiYW50b25pb3NhbXloZWxwb28iLCJhIjoiY2xuN2traWhjMTI1azJrb2hscXc4OXg0cSJ9.NVp_HaVL_NDBiQs3wWfLVg&zoomwheel=true&fresh=true#11/48.138/11.575";
const mapBoxSK =
    "sk.eyJ1IjoiYW50b25pb3NhbXloZWxwb28iLCJhIjoiY2xybml2bXUzMWR2ZTJrcXpkMWNldHN6dSJ9.7y_JGyPS-yRa-MvwMsfk4w";

/// ---------------- streaming -----------------

// const streamingUrlRTMPS = "https://grid.vindral.com/?core.url=https://lb.cdn.vindral.com&core.channelId=helpooegypt_winch101_ci_a915dbab-5805-4554-8244-c992e93b0c12";
const streamingUrlRTMPS =
    "https://embed.vindral.com/?core.url=https://lb.cdn.vindral.com&core.channelId=helpooegypt_winch101_ci_a915dbab-5805-4554-8244-c992e93b0c12";
