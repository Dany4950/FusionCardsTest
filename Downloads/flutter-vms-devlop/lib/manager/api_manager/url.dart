abstract class BaseURL {
  static const String baseAPI = 'api.moksa.ai';

  static const baseURL = 'https://$baseAPI';
  static const socketBaseURL = 'wss://$baseAPI';
}

abstract class EndPoint {
  static const login = "auth/login";
  static const stream = "stream";
  static const getUserById = "auth/getUserByUserid";
  static const getStores = 'store/getStoreByStoreIdWithAllDetails';
  static const getAllStoresTotals = 'store/getAllStoresTotals';
  static const getAllStoresForDropdown = 'store/getAllStoresForDropdown';
  static const getEmployeeEfficiencyByStoreidDynamic =
      'store/storeEmployee/getEmployeeEfficiencyByStoreidDynamic';
  static const getStoreLiveEmployee =
      'store/storeEmployee/getEmployeeEfficiencyByStoreid';
  static const employeeEfficiency =
      'employeeEfficiency/getEmployeeEfficiencyByEmpid';
  static const getSafetyDetails =
      'store/storeEmployee/getSafetyDetailsOfAllEmployeesByStore';
  static const createHelp = 'customerComplaints/createHelpRequest';
  static const theftDetectionDetails = 'theft/theftDetectionDetailsByStoreid';
  static const theftTrendsOfAllTime = 'theft/theftTrendsOfAllTime';
  static const theftListBasedOnStoreId = 'theft/theftListBasedOnStoreId';
  static const getPeopleCount = 'people/getPeopleCount';
  static const String getPeopleCountLive = 'people/getPeopleCountLive';
  static const String updateFcmToken = 'auth/updateFcmToken';
  static const String removeFcmToken = 'auth/removeFcmToken';
  static const getAisleData = 'people/aisleCount/getAisleCountbyStoreId';
  static const getHeatMapFloorImage = 'heatmap/getHeatMapByTimeAndStoreIdApp';
  static const getHeatMapImagesbyCamera =
      'heatmap/getHeatMapByTimeAndCameraIdApp';
  static const getNotifications =
      'notification/getAllUnreadNotificationsByUserId';
  static const getCustomerProjections = 'people/getCustomerForecastGraph';
}
