var ASPx = {};
(function () {
ASPx.EmptyObject = { };
ASPx.FalseFunction = function() { return false; }
ASPx.SSLSecureBlankUrl = '/DXR.axd?r=1_0-2_d2d';
ASPx.EmptyImageUrl = '/DXR.axd?r=1_35-2_d2d';
ASPx.VersionInfo = 'Version=\'16.1.4.0\', File Version=\'16.1.4.0\', Date Modified=\'7/5/2016 4:01:32 PM\'';
ASPx.InvalidDimension = -10000;
ASPx.InvalidPosition = -10000;
ASPx.AbsoluteLeftPosition = -10000;
ASPx.EmptyGuid = "00000000-0000-0000-0000-000000000000";
ASPx.CallbackSeparator = ":";
ASPx.ItemIndexSeparator = "i";
ASPx.CallbackResultPrefix = "/*DX*/";
ASPx.AccessibilityEmptyUrl = "javascript:;";
ASPx.PossibleNumberDecimalSeparators = [",", "."];
ASPx.CultureInfo = {
 twoDigitYearMax: 2029,
 ts: ":",
 ds: "/",
 am: "AM",
 pm: "PM",
 monthNames: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December", ""],
 genMonthNames: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December", ""],
 abbrMonthNames: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec", ""],
 abbrDayNames: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"],
 dayNames: ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"],
 numDecimalPoint: ".",
 numPrec: 2,
 numGroupSeparator: ",", 
 numGroups: [ 3 ],
 numNegPattern: 1,
 numPosInf: "Infinity", 
 numNegInf: "-Infinity", 
 numNan: "NaN",
 currency: "$",
 currDecimalPoint: ".",
 currPrec: 2,
 currGroupSeparator: ",",
 currGroups: [ 3 ],
 currPosPattern: 0,
 currNegPattern: 0,
 percentPattern: 0,
 shortTime: "h:mm tt",
 longTime: "h:mm:ss tt",
 shortDate: "M/d/yyyy",
 longDate: "dddd, MMMM d, yyyy",
 monthDay: "MMMM d",
 yearMonth: "MMMM yyyy"
};
ASPx.CultureInfo.genMonthNames = ASPx.CultureInfo.monthNames;
ASPx.Position = {
 Left: "Left",
 Right: "Right",
 Top: "Top",
 Bottom: "Bottom"
};
var DateUtils = { };
DateUtils.GetInvariantDateString = function(date) {
 if(!date)
  return "01/01/0001";
 var day = date.getDate();
 var month = date.getMonth() + 1;
 var year = date.getFullYear();
 var result = "";
 if(month < 10)
  result += "0";
 result += month.toString() + "/";
 if(day < 10)
  result += "0";
 result += day.toString() + "/";
 if(year < 1000)
  result += "0";
 result += year.toString();
 return result;
}
DateUtils.GetInvariantDateTimeString = function(date) {
 var dateTimeString = DateUtils.GetInvariantDateString(date);
 var time = {
  h: date.getHours(),
  m: date.getMinutes(),
  s: date.getSeconds()
 };
 for(var key in time) {
  var str = time[key].toString();
  if(str.length < 2)
   str = "0" + str;
  time[key] = str;
 }
 dateTimeString += " " + time.h + ":" + time.m + ":" + time.s;
 var msec = date.getMilliseconds();
 if(msec > 0)
  dateTimeString += "." + ("000" + msec.toString()).substr(-3);
 return dateTimeString;
}
DateUtils.ExpandTwoDigitYear = function(value) {
 value += 1900;
 if(value + 99 < ASPx.CultureInfo.twoDigitYearMax)
  value += 100;
 return value;  
}
DateUtils.ToUtcTime = function(date) {
 var result = new Date();
 result.setTime(date.valueOf() + 60000 * date.getTimezoneOffset());
 return result;
}
DateUtils.ToLocalTime = function(date) {
 var result = new Date();
 result.setTime(date.valueOf() - 60000 * date.getTimezoneOffset());
 return result; 
}
DateUtils.AreDatesEqualExact = function(date1, date2) {
 if(date1 == null && date2 == null)
  return true;
 if(date1 == null || date2 == null)
  return false;
 return date1.getTime() == date2.getTime(); 
}
DateUtils.FixTimezoneGap = function(oldDate, newDate) {
 var diff = newDate.getHours() - oldDate.getHours();
 if(diff == 0)
  return;
 var sign = (diff == 1 || diff == -23) ? -1 : 1;
 var trial = new Date(newDate.getTime() + sign * 3600000);
 if(sign > 0 || trial.getDate() == newDate.getDate())
  newDate.setTime(trial.getTime());
}
ASPx.DateUtils = DateUtils;
var Timer = { };
Timer.ClearTimer = function(timerID){
 if(timerID > -1)
  window.clearTimeout(timerID);
 return -1;
}
Timer.ClearInterval = function(timerID){
 if(timerID > -1)
  window.clearInterval(timerID);
 return -1;
}
var setControlBoundTimer = function(handler, control, setTimerFunction, clearTimerFunction, delay) {
 var timerId;
 var getTimerId = function() { return timerId };
 var boundHandler = function() {
  var controlExists = control && ASPx.GetControlCollection().Get(control.name) === control;
  if(controlExists)
   handler.aspxBind(control)();
  else
   clearTimerFunction(getTimerId());
 }
 timerId = setTimerFunction(boundHandler, delay);
 return timerId;
}
Timer.SetControlBoundTimeout = function(handler, control, delay) {
 return setControlBoundTimer(handler, control, window.setTimeout, Timer.ClearTimer, delay);
}
Timer.SetControlBoundInterval = function(handler, control, delay) {
 return setControlBoundTimer(handler, control, window.setInterval, Timer.ClearInterval, delay);
}
Timer.Throttle = function(func, delay) {
 var isThrottled = false,
   savedArgs,
   savedThis = this;
 function wrapper() {
  if(isThrottled) {
   savedArgs = arguments;
   savedThis = this;
   return;
  }
  func.apply(this, arguments);
  isThrottled = true;
  setTimeout(function() {
   isThrottled = false;
   if(savedArgs) {
    wrapper.apply(savedThis, savedArgs);
    savedArgs = null;
   }
  }, delay);
 }
 wrapper.cancel = function() {
  clearTimeout(delay);
  delay = savedArgs = savedThis = null;
 };
 return wrapper;
}
ASPx.Timer = Timer;
var Browser = { };
Browser.UserAgent = navigator.userAgent.toLowerCase();
Browser.Mozilla = false;
Browser.IE = false;
Browser.Firefox = false;
Browser.Netscape = false;
Browser.Safari = false;
Browser.Chrome = false;
Browser.Opera = false;
Browser.Edge = false;
Browser.Version = undefined; 
Browser.MajorVersion = undefined; 
Browser.WindowsPlatform = false;
Browser.MacOSPlatform = false;
Browser.MacOSMobilePlatform = false;
Browser.AndroidMobilePlatform = false;
Browser.PlaformMajorVersion = false;
Browser.WindowsPhonePlatform = false;
Browser.AndroidDefaultBrowser = false;
Browser.AndroidChromeBrowser = false;
Browser.SamsungAndroidDevice = false;
Browser.WebKitTouchUI = false;
Browser.MSTouchUI = false;
Browser.TouchUI = false;
Browser.WebKitFamily = false; 
Browser.NetscapeFamily = false; 
Browser.HardwareAcceleration = false;
Browser.VirtualKeyboardSupported = false;
Browser.Info = "";
function indentPlatformMajorVersion(userAgent) {
 var regex = /(?:(?:windows nt|macintosh|mac os|cpu os|cpu iphone os|android|windows phone|linux) )(\d+)(?:[-0-9_.])*/;
 var matches = regex.exec(userAgent);
 if(matches)
  Browser.PlaformMajorVersion = matches[1];
}
function getIECompatibleVersionString() {
 if(document.compatible) {
  for(var i = 0; i < document.compatible.length; i++)
   if(document.compatible[i].userAgent === "IE" && document.compatible[i].version)
    return document.compatible[i].version.toLowerCase();
 }
 return "";
}
Browser.IdentUserAgent = function(userAgent, ignoreDocumentMode) {
 var browserTypesOrderedList = [ "Mozilla", "IE", "Firefox", "Netscape", "Safari", "Chrome", "Opera", "Opera10", "Edge" ];
 var defaultBrowserType = "IE";
 var defaultPlatform = "Win";
 var defaultVersions = { Safari: 2, Chrome: 0.1, Mozilla: 1.9, Netscape: 8, Firefox: 2, Opera: 9, IE: 6, Edge: 12 };
 if(!userAgent || userAgent.length == 0) {
  fillUserAgentInfo(browserTypesOrderedList, defaultBrowserType, defaultVersions[defaultBrowserType], defaultPlatform);
  return;
 }
 userAgent = userAgent.toLowerCase();
 indentPlatformMajorVersion(userAgent);
 try {
  var platformIdentStrings = {
   "Windows": "Win",
   "Macintosh": "Mac",
   "Mac OS": "Mac",
   "Mac_PowerPC": "Mac",
   "cpu os": "MacMobile",
   "cpu iphone os": "MacMobile",
   "Android": "Android",
   "!Windows Phone": "WinPhone",
   "!WPDesktop": "WinPhone",
   "!ZuneWP": "WinPhone"
  };
  var optSlashOrSpace = "(?:/|\\s*)?";
  var version = "(\\d+)(?:\\.((?:\\d+?[1-9])|\\d)0*?)?";
  var optVersion = "(?:" + version + ")?";
  var patterns = {
   Safari: "applewebkit(?:.*?(?:version/" + version + "[\\.\\w\\d]*?(?:\\s+mobile\/\\S*)?\\s+safari))?",
   Chrome: "(?:chrome|crios)(?!frame)" + optSlashOrSpace + optVersion,
   Mozilla: "mozilla(?:.*rv:" + optVersion + ".*Gecko)?",
   Netscape: "(?:netscape|navigator)\\d*/?\\s*" + optVersion,
   Firefox: "firefox" + optSlashOrSpace + optVersion,
   Opera: "(?:opera|opr)" + optSlashOrSpace + optVersion,
   Opera10: "opera.*\\s*version" + optSlashOrSpace + optVersion,
   IE: "msie\\s*" + optVersion,
   Edge: "edge" + optSlashOrSpace + optVersion
  };
  var browserType;
  var version = -1;
  for(var i = 0; i < browserTypesOrderedList.length; i++) {
   var browserTypeCandidate = browserTypesOrderedList[i];
   var regExp = new RegExp(patterns[browserTypeCandidate], "i");
   if(regExp.compile)
    regExp.compile(patterns[browserTypeCandidate], "i");
   var matches = regExp.exec(userAgent);
   if(matches && matches.index >= 0) {
    if(browserType == "IE" && version >= 11 && browserTypeCandidate == "Safari") 
     continue;
    browserType = browserTypeCandidate;
    if(browserType == "Opera10")
     browserType = "Opera";
    var tridentPattern = "trident" + optSlashOrSpace + optVersion;
    version = Browser.GetBrowserVersion(userAgent, matches, tridentPattern, getIECompatibleVersionString());
    if(browserType == "Mozilla" && version >= 11)
     browserType = "IE";
   }
  }
  if(!browserType)
   browserType = defaultBrowserType;
  var browserVersionDetected = version != -1;
  if(!browserVersionDetected)
   version = defaultVersions[browserType];
  var platform;
  var minOccurenceIndex = Number.MAX_VALUE;
  for(var identStr in platformIdentStrings) {
   if(!platformIdentStrings.hasOwnProperty(identStr)) continue;
   var importantIdent = identStr.substr(0,1) == "!";
   var occurenceIndex = userAgent.indexOf((importantIdent ? identStr.substr(1) : identStr).toLowerCase());
   if(occurenceIndex >= 0 && (occurenceIndex < minOccurenceIndex || importantIdent)) {
    minOccurenceIndex = importantIdent ? 0 : occurenceIndex;
    platform = platformIdentStrings[identStr];
   }
  }
  var samsungPattern = "SM-[A-Z]";
  var matches = userAgent.toUpperCase().match(samsungPattern);
  var isSamsungAndroidDevice = matches && matches.length > 0;
  if(platform == "WinPhone" && version < 9)
   version = Math.floor(getVersionFromTrident(userAgent, "trident" + optSlashOrSpace + optVersion));
  if(!ignoreDocumentMode && browserType == "IE" && version > 7 && document.documentMode < version)
   version = document.documentMode;
  if(platform == "WinPhone")
   version = Math.max(9, version);
  if(!platform)
   platform = defaultPlatform;
  if(platform == platformIdentStrings["cpu os"] && !browserVersionDetected) 
   version = 4;
  fillUserAgentInfo(browserTypesOrderedList, browserType, version, platform, isSamsungAndroidDevice);
 } catch(e) {
  fillUserAgentInfo(browserTypesOrderedList, defaultBrowserType, defaultVersions[defaultBrowserType], defaultPlatform);
 }
}
function getVersionFromMatches(matches) {
 var result = -1;
 var versionStr = "";
 if(matches[1]) {
  versionStr += matches[1];
  if(matches[2])
   versionStr += "." + matches[2];
 }
 if(versionStr != "") {
  result = parseFloat(versionStr);
  if(result == NaN)
   result = -1;
 }
 return result;
}
function getVersionFromTrident(userAgent, tridentPattern) {
 var tridentDiffFromVersion = 4;
 var matches = new RegExp(tridentPattern, "i").exec(userAgent);
 return getVersionFromMatches(matches) + tridentDiffFromVersion;
}
Browser.GetBrowserVersion = function(userAgent, matches, tridentPattern, ieCompatibleVersionString) {
 var version = getVersionFromMatches(matches);
 if(ieCompatibleVersionString) {
  var versionFromTrident = getVersionFromTrident(userAgent, tridentPattern);
  if(ieCompatibleVersionString === "edge" || parseInt(ieCompatibleVersionString) === versionFromTrident)
   return versionFromTrident;
 }
 return version;
}
function fillUserAgentInfo(browserTypesOrderedList, browserType, version, platform, isSamsungAndroidDevice) {
 for(var i = 0; i < browserTypesOrderedList.length; i++) {
  var type = browserTypesOrderedList[i];
  Browser[type] = type == browserType;
 }
 Browser.Version = Math.floor(10.0 * version) / 10.0;
 Browser.MajorVersion = Math.floor(Browser.Version);
 Browser.WindowsPlatform = platform == "Win" || platform == "WinPhone";
 Browser.MacOSPlatform = platform == "Mac";
 Browser.MacOSMobilePlatform = platform == "MacMobile";
 Browser.AndroidMobilePlatform = platform == "Android";
 Browser.WindowsPhonePlatform = platform == "WinPhone";
 Browser.WebKitFamily = Browser.Safari || Browser.Chrome;
 Browser.NetscapeFamily = Browser.Netscape || Browser.Mozilla || Browser.Firefox;
 Browser.HardwareAcceleration = (Browser.IE && Browser.MajorVersion >= 9) || (Browser.Firefox && Browser.MajorVersion >= 4) || 
  (Browser.AndroidMobilePlatform && Browser.Chrome) || (Browser.Chrome && Browser.MajorVersion >= 37) || 
  (Browser.Safari && !Browser.WindowsPlatform) || Browser.Edge;
 Browser.WebKitTouchUI = Browser.MacOSMobilePlatform || Browser.AndroidMobilePlatform;
 var isIETouchUI = Browser.IE && Browser.MajorVersion > 9 && Browser.WindowsPlatform && Browser.UserAgent.toLowerCase().indexOf("touch") >= 0;
 Browser.MSTouchUI = isIETouchUI || (Browser.Edge && !!window.navigator.maxTouchPoints);
 Browser.TouchUI = Browser.WebKitTouchUI || Browser.MSTouchUI;
 Browser.MobileUI = Browser.WebKitTouchUI || Browser.WindowsPhonePlatform;
 Browser.AndroidDefaultBrowser = Browser.AndroidMobilePlatform && !Browser.Chrome;
 Browser.AndroidChromeBrowser = Browser.AndroidMobilePlatform && Browser.Chrome;
 if(isSamsungAndroidDevice)
  Browser.SamsungAndroidDevice = isSamsungAndroidDevice;
 if(Browser.MSTouchUI) {
  var isARMArchitecture = Browser.UserAgent.toLowerCase().indexOf("arm;") > -1;    
  Browser.VirtualKeyboardSupported = isARMArchitecture || Browser.WindowsPhonePlatform;   
 } else {
  Browser.VirtualKeyboardSupported = Browser.WebKitTouchUI;
 }
 fillDocumentElementBrowserTypeClassNames(browserTypesOrderedList);
}
function fillDocumentElementBrowserTypeClassNames(browserTypesOrderedList) {
 var documentElementClassName = "";
 var browserTypeslist = browserTypesOrderedList.concat(["WindowsPlatform", "MacOSPlatform", "MacOSMobilePlatform", "AndroidMobilePlatform",
   "WindowsPhonePlatform", "WebKitFamily", "WebKitTouchUI", "MSTouchUI", "TouchUI", "AndroidDefaultBrowser"]);
 for(var i = 0; i < browserTypeslist.length; i++) {
  var type = browserTypeslist[i];
  if(Browser[type])
   documentElementClassName += "dx" + type + " ";
 }
 documentElementClassName += "dxBrowserVersion-" + Browser.MajorVersion
 if(document && document.documentElement) {
  if(document.documentElement.className != "")
   documentElementClassName = " " + documentElementClassName;
  document.documentElement.className += documentElementClassName;
  Browser.Info = documentElementClassName;
 }
}
Browser.IdentUserAgent(Browser.UserAgent);
ASPx.Browser = Browser;
ASPx.BlankUrl = Browser.IE ? ASPx.SSLSecureBlankUrl : (Browser.Opera ? "about:blank" : "");
var Data = { };
Data.ArrayInsert = function(array, element, position){
 if(0 <= position && position < array.length){
  for(var i = array.length; i > position; i --)
   array[i] = array[i - 1];
  array[position] = element;
 }
 else
  array.push(element);
}
Data.ArrayRemove = function(array, element){
 var index = Data.ArrayIndexOf(array, element);
 if(index > -1) Data.ArrayRemoveAt(array, index);
}
Data.ArrayRemoveAt = function(array, index){
 if(index >= 0  && index < array.length){
  for(var i = index; i < array.length - 1; i++)
   array[i] = array[i + 1];
  array.pop();
 }
}
Data.ArrayClear = function(array){
 while(array.length > 0)
  array.pop();
}
Data.ArrayIndexOf = function(array, element, comparer) {
 if(!comparer) {
  for(var i = 0; i < array.length; i++) {
   if(array[i] == element)
    return i;
  }
 } else {
  for(var i = 0; i < array.length; i++) {
   if(comparer(array[i], element))
    return i;
  }
 }
 return -1;
}
Data.ArrayContains = function(array, element) { 
 return Data.ArrayIndexOf(array, element) >= 0;
}
Data.ArrayEqual = function(array1, array2) {
 var count1 = array1.length;
 var count2 = array2.length;
 if(count1 != count2)
  return false;
 for(var i = 0; i < count1; i++)
  if(array1[i] != array2[i])
   return false;
 return true;
}
Data.ArrayGetIntegerEdgeValues = function(array) {
 var arrayToSort = Data.CollectionToArray(array);
 Data.ArrayIntegerAscendingSort(arrayToSort);
 return {
  start: arrayToSort[0],
  end: arrayToSort[arrayToSort.length - 1]
 }
}
Data.ArrayIntegerAscendingSort = function(array){
 Data.ArrayIntegerSort(array);
}
Data.ArrayIntegerSort = function(array, desc) {
 array.sort(function(i1, i2) {
  var res = 0;
  if(i1 > i2)
   res = 1;
  else if(i1 < i2)
   res = -1;
  if(desc)
   res *= -1;
  return res;
 });
},
Data.CollectionsUnionToArray = function(firstCollection, secondCollection) {
 var result = [];
 var firstCollectionLength = firstCollection.length;
 var secondCollectionLength = secondCollection.length;
 for(var i = 0; i <  firstCollectionLength + secondCollectionLength; i++) {
  if(i < firstCollectionLength) 
   result.push(firstCollection[i]);
  else 
   result.push(secondCollection[i - firstCollectionLength]);
 }  
 return result;
}
Data.CollectionToArray = function(collection) {
 var array = [];
 for(var i = 0; i < collection.length; i++)
  array.push(collection[i]);
 return array;
}
Data.CreateHashTableFromArray = function(array) {
 var hash = [];
 for(var i = 0; i < array.length; i++)
  hash[array[i]] = 1;
 return hash;
}
Data.CreateIndexHashTableFromArray = function(array) {
 var hash = [];
 for(var i = 0; i < array.length; i++)
  hash[array[i]] = i;
 return hash;
}
var defaultBinarySearchComparer = function(array, index, value) {
 var arrayElement = array[index];
 if(arrayElement == value)
  return 0;
 else
  return arrayElement < value ? -1 : 1;
};
Data.NearestLeftBinarySearchComparer = function(array, index, value) { 
 var arrayElement = array[index];
 var leftPoint = arrayElement < value;
 var lastLeftPoint = leftPoint && index == array.length - 1;
 var nearestLeftPoint = lastLeftPoint || (leftPoint && array[index + 1] >= value)
 if(nearestLeftPoint)
  return 0;
 else
  return arrayElement < value ? -1 : 1;
};
Data.ArrayBinarySearch = function(array, value, binarySearchComparer, startIndex, length) {
 if(!binarySearchComparer)
  binarySearchComparer = defaultBinarySearchComparer;
 if(!ASPx.IsExists(startIndex))
  startIndex = 0;
 if(!ASPx.IsExists(length))
  length = array.length - startIndex;  
 var endIndex = (startIndex + length) - 1;
 while(startIndex <= endIndex) {
  var middle =  (startIndex + ((endIndex - startIndex) >> 1));
  var compareResult = binarySearchComparer(array, middle, value);
  if(compareResult == 0)
   return middle;
  if(compareResult < 0)
   startIndex = middle + 1;
  else
   endIndex = middle - 1;
 }
 return -(startIndex + 1);
},
Data.ArrayFlattern = function(arrayOfArrays) {
 return [].concat.apply([], arrayOfArrays);
},
Data.GetDistinctArray = function(array) {
 var resultArray = [];
 for(var i = 0; i < array.length; i++) {
  var currentEntry = array[i];
  if(Data.ArrayIndexOf(resultArray, currentEntry) == -1) {
     resultArray.push(currentEntry);
  }
 }
 return resultArray;
}
Data.ForEach = function(arr, callback) {
 if(Array.prototype.forEach) {
  Array.prototype.forEach.call(arr, callback);
 } else {
  for(var i = 0, len = arr.length; i < len; i++) {
   callback(arr[i], i, arr);
  }
 }
},
ASPx.Data = Data;
var Cookie = { };
Cookie.DelCookie = function(name){
 setCookieInternal(name, "", new Date(1970, 1, 1));
}
Cookie.GetCookie = function(name) {
 name = escape(name);
 var cookies = document.cookie.split(';');
 for(var i = 0; i < cookies.length; i++) {
  var cookie = Str.Trim(cookies[i]);
  if(cookie.indexOf(name + "=") == 0)
   return unescape(cookie.substring(name.length + 1, cookie.length));
  else if(cookie.indexOf(name + ";") == 0 || cookie === name)
   return "";
 }
 return null;
}
Cookie.SetCookie = function(name, value, expirationDate){
 if(!ASPx.IsExists(value)) {
  Cookie.DelCookie(name);
  return;
 }
 if(!ASPx.Ident.IsDate(expirationDate)) {
  expirationDate = new Date();
  expirationDate.setFullYear(expirationDate.getFullYear() + 1);
 }
 setCookieInternal(name, value, expirationDate);
}
function setCookieInternal(name, value, date){
 document.cookie = escape(name) + "=" + escape(value.toString()) + "; expires=" + date.toGMTString() + "; path=/";
}
ASPx.Cookie = Cookie;
ASPx.ImageUtils = {
 GetImageSrc: function (image){
  return image.src;
 },
 SetImageSrc: function(image, src){
  image.src = src;
 },
 SetSize: function(image, width, height){
  image.style.width = width + "px";
  image.style.height = height + "px";
 },
 GetSize: function(image, isWidth){
  return (isWidth ? image.offsetWidth : image.offsetHeight);
 }
};
var Str = { };
Str.ApplyReplacement = function(text, replecementTable) {
 if(typeof(text) != "string")
  text = text.toString();
 for(var i = 0; i < replecementTable.length; i++) {
  var replacement = replecementTable[i];
  text = text.replace(replacement[0], replacement[1]);
 }
 return text;
}
Str.CompleteReplace = function(text, regexp, newSubStr) {
 if(typeof(text) != "string")
  text = text.toString();
 var textPrev;
 do {
  textPrev = text;
  text = text.replace(regexp, newSubStr);
 } while(text != textPrev);
 return text;
}
Str.EncodeHtml = function(html) {
 return Str.ApplyReplacement(html, [
  [ /&amp;/g,  '&ampx;'  ], [ /&/g, '&amp;'  ],
  [ /&quot;/g, '&quotx;' ], [ /"/g, '&quot;' ],
  [ /&lt;/g,   '&ltx;'   ], [ /</g, '&lt;'   ],
  [ /&gt;/g,   '&gtx;'   ], [ />/g, '&gt;'   ]
 ]);
}
Str.DecodeHtml = function(html) {
 return Str.ApplyReplacement(html, [
  [ /&gt;/g,   '>' ], [ /&gtx;/g,  '&gt;'   ],
  [ /&lt;/g,   '<' ], [ /&ltx;/g,  '&lt;'   ],
  [ /&quot;/g, '"' ], [ /&quotx;/g,'&quot;' ],
  [ /&amp;/g,  '&' ], [ /&ampx;/g, '&amp;'  ]
 ]);
}
Str.TrimStart = function(str) { 
 return trimInternal(str, true);
}
Str.TrimEnd = function(str) { 
 return trimInternal(str, false, true);
}
Str.Trim = function(str) { 
 return trimInternal(str, true, true); 
}
var whiteSpaces = { 
 0x0009: 1, 0x000a: 1, 0x000b: 1, 0x000c: 1, 0x000d: 1, 0x0020: 1, 0x0085: 1, 
 0x00a0: 1, 0x1680: 1, 0x180e: 1, 0x2000: 1, 0x2001: 1, 0x2002: 1, 0x2003: 1, 
 0x2004: 1, 0x2005: 1, 0x2006: 1, 0x2007: 1, 0x2008: 1, 0x2009: 1, 0x200a: 1, 
 0x200b: 1, 0x2028: 1, 0x2029: 1, 0x202f: 1, 0x205f: 1, 0x3000: 1
};
var caretWidth = 1;
function trimInternal(source, trimStart, trimEnd) {
 var len = source.length;
 if(!len)
  return source;
 if(len < 0xBABA1) { 
  var result = source;
  if(trimStart) {
   result = result.replace(/^\s+/, "");
  }
  if(trimEnd) {
   result = result.replace(/\s+$/, "");
  }
  return result;  
 } else {
  var start = 0;
  if(trimEnd) {   
   while(len > 0 && whiteSpaces[source.charCodeAt(len - 1)]) {
    len--;
   }
  }
  if(trimStart && len > 0) {
   while(start < len && whiteSpaces[source.charCodeAt(start)]) { 
    start++; 
   }   
  }
  return source.substring(start, len);
 }
}
Str.Insert = function(str, subStr, index) { 
 var leftText = str.slice(0, index);
 var rightText = str.slice(index);
 return leftText + subStr + rightText;
}
Str.InsertEx = function(str, subStr, startIndex, endIndex) { 
 var leftText = str.slice(0, startIndex);
 var rightText = str.slice(endIndex);
 return leftText + subStr + rightText;
}
var greekSLFSigmaChar = String.fromCharCode(962);
var greekSLSigmaChar = String.fromCharCode(963);
Str.PrepareStringForFilter = function(s){
 s = s.toLowerCase();
 if(ASPx.Browser.WebKitFamily) {
  return s.replace(new RegExp(greekSLFSigmaChar, "g"), greekSLSigmaChar);
 }
 return s;
}
Str.GetCoincideCharCount = function(text, filter, textMatchingDelegate) {
 var coincideText = ASPx.Str.PrepareStringForFilter(filter);
 var originText = ASPx.Str.PrepareStringForFilter(text);
 while(coincideText != "" && !textMatchingDelegate(originText, coincideText)) {
  coincideText = coincideText.slice(0, -1);
 }
 return coincideText.length;
}
ASPx.Str = Str;
var Xml = { };
Xml.Parse = function(xmlStr) {
 if(window.DOMParser) {
  var parser = new DOMParser();
  return parser.parseFromString(xmlStr, "text/xml");
 }
 else if(window.ActiveXObject) {
  var xmlDoc = new window.ActiveXObject("Microsoft.XMLDOM");
  if(xmlDoc) {
   xmlDoc.async = false;
   xmlDoc.loadXML(xmlStr);
   return xmlDoc;
  }
 }
 return null;
}
ASPx.Xml = Xml;
ASPx.Key = {
 F1     : 112,
 F2     : 113,
 F3     : 114,
 F4     : 115,
 F5     : 116,
 F6     : 117,
 F7     : 118,
 F8     : 119,
 F9     : 120,
 F10    : 121,
 F11    : 122,
 F12    : 123,
 Ctrl   : 17,
 Shift  : 16,
 Alt    : 18,
 Enter  : 13,
 Home   : 36,
 End    : 35,
 Left   : 37,
 Right  : 39,
 Up     : 38,
 Down   : 40,
 PageUp    : 33,
 PageDown  : 34,
 Esc    : 27,
 Space  : 32,
 Tab    : 9,
 Backspace : 8,
 Delete    : 46,
 Insert    : 45,
 ContextMenu  : 93,
 Windows   : 91,
 Decimal   : 110
};
ASPx.ScrollBarMode = { Hidden: 0, Visible: 1, Auto: 2 };
ASPx.ColumnResizeMode = { None: 0, Control: 1, NextColumn: 2 };
var Selection = { };
Selection.Set = function(input, startPos, endPos, scrollToSelection) {
 if(!ASPx.IsExistsElement(input))
  return;
 if(Browser.VirtualKeyboardSupported && (ASPx.GetActiveElement() !== input || ASPx.VirtualKeyboardUI.getInputNativeFocusLocked()))
  return;
 var textLen = input.value.length;
 startPos = ASPx.GetDefinedValue(startPos, 0);
 endPos = ASPx.GetDefinedValue(endPos, textLen);
 if(startPos < 0)
  startPos = 0;
 if(endPos < 0 || endPos > textLen)
  endPos = textLen;
 if(startPos > endPos)
  startPos = endPos;
 var makeReadOnly = false;
 if(Browser.WebKitFamily && input.readOnly) {
  input.readOnly = false;
  makeReadOnly = true;
 }
 try {
  if(Browser.Firefox && Browser.Version >= 8) 
   input.setSelectionRange(startPos, endPos, "backward");
  else if(Browser.IE && input.createTextRange) {
   var range = input.createTextRange();
   range.collapse(true);
   range.moveStart("character", startPos);
   range.moveEnd("character", endPos - startPos);
   range.select();
  } else {
   forceScrollToSelectionRange(input, startPos, endPos);
   input.setSelectionRange(startPos, endPos);
  }
  if(Browser.Opera || Browser.Firefox || Browser.Chrome) 
   input.focus();
 } catch(e) { 
 }
 if(scrollToSelection && input.tagName == 'TEXTAREA') {
  var scrollHeight = input.scrollHeight;
  var approxCaretPos = startPos;
  var scrollTop = Math.max(Math.round(approxCaretPos * scrollHeight / textLen  - input.clientHeight / 2), 0);
  input.scrollTop = scrollTop;
 }
 if(makeReadOnly)
  input.readOnly = true;
}
var getTextWidthBeforePos = function(input, pos) {
 return ASPx.GetSizeOfText(input.value.toString().substr(0, pos), ASPx.GetCurrentStyle(input)).width;
}
var forceScrollToSelectionRange = function(input, startPos, endPos) {
 var widthBeforeStartPos = getTextWidthBeforePos(input, startPos) - caretWidth;
 var widthBeforeEndPos = getTextWidthBeforePos(input, endPos) + caretWidth;
 var inputRawWidth = input.offsetWidth - ASPx.GetLeftRightBordersAndPaddingsSummaryValue(input);
 if(input.scrollLeft < widthBeforeEndPos - inputRawWidth)
  input.scrollLeft = widthBeforeEndPos - inputRawWidth;
 else if(input.scrollLeft > widthBeforeStartPos)
  input.scrollLeft = widthBeforeStartPos;
}
Selection.GetInfo = function(input) {
 var start, end;
 if(Browser.IE && Browser.Version < 9) {
  var range = document.selection.createRange();
  var rangeCopy = range.duplicate();
  range.move('character', -input.value.length);
  range.setEndPoint('EndToStart', rangeCopy);
  start = range.text.length;
  end = start + rangeCopy.text.length;
 } else {
  try {
   start = input.selectionStart;
   end = input.selectionEnd;
  } catch (e) {
  }
 }
 return { startPos: start, endPos: end };
}
Selection.GetExtInfo = function(input) {
 var start = 0, end = 0, textLen = 0;
 if(Browser.IE && Browser.Version < 9) {
  var normalizedValue;
  var range, textInputRange, textInputEndRange;
  range = document.selection.createRange();
  if(range && range.parentElement() == input) {
   textLen = input.value.length;
   normalizedValue = input.value.replace(/\r\n/g, "\n");
   textInputRange = input.createTextRange();
   textInputRange.moveToBookmark(range.getBookmark());
   textInputEndRange = input.createTextRange();
   textInputEndRange.collapse(false);
   if(textInputRange.compareEndPoints("StartToEnd", textInputEndRange) > -1) {
    start = textLen;
    end = textLen;
   } else {
    start = normalizedValue.slice(0, start).split("\n").length - textInputRange.moveStart("character", -textLen) -1;
    if(textInputRange.compareEndPoints("EndToEnd", textInputEndRange) > -1)
     end = textLen;
    else
     end = normalizedValue.slice(0, end).split("\n").length - textInputRange.moveEnd("character", -textLen) - 1;    
   }
  }
  return {startPos: start, endPos: end};
 }
 try {
  start = input.selectionStart;
  end = input.selectionEnd;
 } catch (e) {
 }
 return {startPos: start, endPos: end}; 
}
Selection.SetCaretPosition = function(input, caretPos) {
 if(typeof caretPos === "undefined" || caretPos < 0)
  caretPos = input.value.length;
 Selection.Set(input, caretPos, caretPos, true);
}
Selection.GetCaretPosition = function(element, isDialogMode) {
 var pos = 0;
 if("selectionStart" in element) {
  pos = element.selectionStart;
 } else if("selection" in document) {
  element.focus();
  var sel = document.selection.createRange(),
   selLength = document.selection.createRange().text.length;
  sel.moveStart("character", -element.value.length);
  pos = sel.text.length - selLength;
 }
 if(isDialogMode && !pos) {
  pos = element.value.length - 1;
 }
 return pos;
}
Selection.Clear = function() {
 try {
  if(window.getSelection) {
   window.getSelection().removeAllRanges();
  }
  else if(document.selection) {
   if(document.selection.empty)
    document.selection.empty();
   else if(document.selection.clear)
    document.selection.clear();
  }
 } catch(e) {
 }
}
Selection.ClearOnMouseMove = function(evt) {
 if(!Browser.IE || (evt.button != 0)) 
  Selection.Clear();
}
Selection.SetElementSelectionEnabled = function(element, value) {
 var userSelectValue = value ? "" : "none";
 var func = value ? Evt.DetachEventFromElement : Evt.AttachEventToElement;
 if(Browser.Firefox)
  element.style.MozUserSelect = userSelectValue;
 else if(Browser.WebKitFamily)
  element.style.webkitUserSelect = userSelectValue;
 else if(Browser.Opera)
  func(element, "mousemove", Selection.Clear);
 else {
  func(element, "selectstart", ASPx.FalseFunction);
  func(element, "mousemove", Selection.Clear);
 }
}
Selection.SetElementAsUnselectable = function(element, isWithChild, recursive) {
 if(element && element.nodeType == 1) {
  element.unselectable = "on";
  if(Browser.NetscapeFamily)
   element.onmousedown = ASPx.FalseFunction;
  if((Browser.IE && Browser.Version >= 9) || Browser.WebKitFamily)
   Evt.AttachEventToElement(element, "mousedown", Evt.PreventEventAndBubble);
  if(isWithChild === true){
   for(var j = 0; j < element.childNodes.length; j ++)
    Selection.SetElementAsUnselectable(element.childNodes[j], (!!recursive ? true : false), (!!recursive));
  }
 }
}
ASPx.Selection = Selection;
var MouseScroller = { };
MouseScroller.MinimumOffset = 10;
MouseScroller.Create = function(getElement, getScrollXElement, getScrollYElement, needPreventScrolling, vertRecursive, onMouseDown, onMouseMove, onMouseUp, onMouseUpMissed) {
 var element = getElement();
 if(!element) 
  return;
 if(!element.dxMouseScroller)
  element.dxMouseScroller = new MouseScroller.Extender(getElement, getScrollXElement, getScrollYElement, needPreventScrolling, vertRecursive, onMouseDown, onMouseMove, onMouseUp, onMouseUpMissed);
 return element.dxMouseScroller;
}
MouseScroller.Extender = function(getElement, getScrollXElement, getScrollYElement, needPreventScrolling, vertRecursive, onMouseDown, onMouseMove, onMouseUp, onMouseUpMissed) {
 this.getElement = getElement;
 this.getScrollXElement = getScrollXElement;
 this.getScrollYElement = getScrollYElement;
 this.needPreventScrolling = needPreventScrolling;
 this.vertRecursive = !!vertRecursive;
 this.createHandlers(onMouseDown || function() { }, onMouseMove || function() { }, onMouseUp || function() { }, onMouseUpMissed || function() { });
 this.update()
};
MouseScroller.Extender.prototype = {
 update: function() {
  if(this.element)
   Evt.DetachEventFromElement(this.element, ASPx.TouchUIHelper.touchMouseDownEventName, this.mouseDownHandler);
  this.element = this.getElement();
  Evt.AttachEventToElement(this.element, ASPx.TouchUIHelper.touchMouseDownEventName, this.mouseDownHandler);  
  Evt.AttachEventToElement(this.element, "click", this.mouseClickHandler);   
  if(Browser.MSTouchUI && this.element.className.indexOf(ASPx.TouchUIHelper.msTouchDraggableClassName) < 0)
   this.element.className += " " + ASPx.TouchUIHelper.msTouchDraggableClassName;
  this.scrollXElement = this.getScrollXElement();
  this.scrollYElement = this.getScrollYElement();
 },
 createHandlers: function(onMouseDown, onMouseMove, onMouseUp, onMouseUpMissed) {
  var mouseDownCounter = 0;
  this.onMouseDown = onMouseDown;
  this.onMouseMove = onMouseMove;
  this.onMouseUp = onMouseUp;  
  this.mouseDownHandler = function(e) {
   if(mouseDownCounter++ > 0) {
    this.finishScrolling();
    onMouseUpMissed();
   }
   var eventSource = Evt.GetEventSource(e);
   var requirePreventCustonScroll = ASPx.IsExists(ASPx.TouchUIHelper.RequirePreventCustomScroll) && ASPx.TouchUIHelper.RequirePreventCustomScroll(eventSource, this.element);
   if(requirePreventCustonScroll || this.needPreventScrolling && this.needPreventScrolling(eventSource))
    return;
   this.scrollableTreeLine = this.GetScrollableElements();
   this.firstX = this.prevX = Evt.GetEventX(e);
   this.firstY = this.prevY = this.GetEventY(e);
   Evt.AttachEventToDocument(ASPx.TouchUIHelper.touchMouseMoveEventName, this.mouseMoveHandler);
   Evt.AttachEventToDocument(ASPx.TouchUIHelper.touchMouseUpEventName, this.mouseUpHandler);
   this.onMouseDown(e);
  }.aspxBind(this);
  this.mouseMoveHandler = function(e) {
   if(ASPx.TouchUIHelper.isGesture)
    return;
   var x = Evt.GetEventX(e);
   var y = this.GetEventY(e);
   var xDiff = this.prevX - x;
   var yDiff = this.prevY - y;
   if(this.vertRecursive) {
    var isTopDirection = yDiff < 0;
    this.scrollYElement = this.GetElementForVertScrolling(isTopDirection, this.prevIsTopDirection, this.scrollYElement);
    this.prevIsTopDirection = isTopDirection;
   }
   if(this.scrollXElement && xDiff != 0)
    this.scrollXElement.scrollLeft += xDiff;
   if(this.scrollYElement && yDiff != 0)
    this.scrollYElement.scrollTop += yDiff;
   this.prevX = x;
   this.prevY = y;
   e.preventDefault();
   this.onMouseMove(e);
  }.aspxBind(this);
  this.mouseUpHandler = function(e) {
   this.finishScrolling();
   this.onMouseUp(e);
  }.aspxBind(this);
  this.mouseClickHandler = function(e){
   if(this.needPreventScrolling && this.needPreventScrolling(Evt.GetEventSource(e)))
    return;
   var xDiff = this.firstX - Evt.GetEventX(e);
   var yDiff = this.firstY - Evt.GetEventY(e);
   if(xDiff > MouseScroller.MinimumOffset || yDiff > MouseScroller.MinimumOffset)
    return Evt.PreventEventAndBubble(e);
  }.aspxBind(this);
  this.finishScrolling = function() {
   Evt.DetachEventFromDocument(ASPx.TouchUIHelper.touchMouseMoveEventName, this.mouseMoveHandler);
   Evt.DetachEventFromDocument(ASPx.TouchUIHelper.touchMouseUpEventName, this.mouseUpHandler);
   this.scrollableTreeLine = [];
   this.prevIsTopDirection = null;
   mouseDownCounter--;
  };
 },
 GetEventY: function(e) {
  return Evt.GetEventY(e) - ASPx.GetDocumentScrollTop();
 },
 GetScrollableElements: function() {
  var result = [ ];
  var el = this.element;
  while(el && el != document && this.vertRecursive) {
   if(this.CanVertScroll(el) || el.tagName == "HTML")
    result.push(el);
   el = el.parentNode;
  }
  return result;
 },
 CanVertScroll: function(element) {
  var style = ASPx.GetCurrentStyle(element);
  return style.overflow == "scroll" || style.overflow == "auto" || style.overflowY == "scroll" || style.overflowY == "auto";
 },
 GetElementForVertScrolling: function(currentIsTop, prevIsTop, prevElement) {
  if(prevElement && currentIsTop === prevIsTop && this.GetVertScrollExcess(prevElement, currentIsTop) > 0)
   return prevElement;
  for(var i = 0; i < this.scrollableTreeLine.length; i++) {
   var element = this.scrollableTreeLine[i];
   var excess = this.GetVertScrollExcess(element, currentIsTop);
   if(excess > 0)
    return element;
  }
  return null;
 },
 GetVertScrollExcess: function(element, isTop) {
  if(isTop)
   return element.scrollTop;
  return element.scrollHeight - element.clientHeight - element.scrollTop;
 }
}
ASPx.MouseScroller = MouseScroller;
var Evt = { };
Evt.GetEvent = function(evt){
 return (typeof(event) != "undefined" && event != null && Browser.IE) ? event : evt; 
}
Evt.IsEventPrevented = function(evt) {
 return evt.defaultPrevented || evt.returnValue === false;
}
Evt.PreventEvent = function(evt){
 if(evt.preventDefault)
  evt.preventDefault();
 else
  evt.returnValue = false;
 return false;
}
Evt.PreventEventAndBubble = function(evt){
 Evt.PreventEvent(evt);
 if(evt.stopPropagation)
  evt.stopPropagation();
 evt.cancelBubble = true;
 return false;
}
Evt.CancelBubble = function(evt){
 evt.cancelBubble = true;
 return false;
}
Evt.PreventImageDragging = function(image) {
 if(image) {
  if(Browser.NetscapeFamily)
   image.onmousedown = function(evt) {
    evt.cancelBubble = true;
    return false;
   };
  else
   image.ondragstart = function() {
    return false;
   };
 }
}
Evt.PreventDragStart = function(evt) {
 evt = Evt.GetEvent(evt);
 var element = Evt.GetEventSource(evt);
 if(element.releaseCapture)
  element.releaseCapture(); 
 return false;
}
Evt.PreventElementDrag = function(element) {
 if(Browser.IE)
  Evt.AttachEventToElement(element, "dragstart", Evt.PreventEvent);
 else
  Evt.AttachEventToElement(element, "mousedown", Evt.PreventEvent);
}
Evt.PreventElementDragAndSelect = function(element, skipMouseMove, skipIESelect){
 if(Browser.WebKitFamily)
  Evt.AttachEventToElement(element, "selectstart", Evt.PreventEventAndBubble);
 if(Browser.IE){
  if(!skipIESelect)
   Evt.AttachEventToElement(element, "selectstart", ASPx.FalseFunction);
  if(!skipMouseMove)
   Evt.AttachEventToElement(element, "mousemove", Selection.ClearOnMouseMove);
  Evt.AttachEventToElement(element, "dragstart", Evt.PreventDragStart);
 }
}
Evt.GetEventSource = function(evt){
 if(!ASPx.IsExists(evt)) return null; 
 return evt.srcElement ? evt.srcElement : evt.target;
}
Evt.GetKeyCode = function(srcEvt) {
 return Browser.NetscapeFamily || Browser.Opera ? srcEvt.which : srcEvt.keyCode;
}
function clientEventRequiresDocScrollCorrection() {
 var isSafariVerLess3 = Browser.Safari && Browser.Version < 3,
  isMacOSMobileVerLess51 = Browser.MacOSMobilePlatform && Browser.Version < 5.1,
  isAndroidChrome = Browser.AndroidMobilePlatform && Browser.Chrome;
 return Browser.AndroidDefaultBrowser || !(isSafariVerLess3 || isMacOSMobileVerLess51 || isAndroidChrome);
}
Evt.GetEventX = function(evt){
 if(ASPx.TouchUIHelper.isTouchEvent(evt))
  return ASPx.TouchUIHelper.getEventX(evt);
 if(Browser.AndroidMobilePlatform && Browser.Chrome && evt.pageX !== undefined)
  return evt.pageX;
 return evt.clientX + (clientEventRequiresDocScrollCorrection() ? ASPx.GetDocumentScrollLeft() : 0);
}
Evt.GetEventY = function(evt){
 if(ASPx.TouchUIHelper.isTouchEvent(evt))
  return ASPx.TouchUIHelper.getEventY(evt);
 if(Browser.AndroidMobilePlatform && Browser.Chrome && evt.pageY !== undefined)
  return evt.pageY;
 return evt.clientY + (clientEventRequiresDocScrollCorrection() ? ASPx.GetDocumentScrollTop() : 0 );
}
Evt.IsLeftButtonPressed = function(evt){
 if(ASPx.TouchUIHelper.isTouchEvent(evt)) 
  return true;
 evt = Evt.GetEvent(evt);
 if(!evt) return false;
 if(Browser.IE && Browser.Version < 11){
  if(Browser.MSTouchUI)
   return true;
  return evt.button % 2 == 1; 
 }
 else if(Browser.NetscapeFamily || Browser.WebKitFamily || (Browser.IE && Browser.Version >= 11) || Browser.Edge)
  return evt.which == 1;
 else if(Browser.Opera)
  return evt.button == 0;  
 return true;  
}
Evt.IsRightButtonPressed = function(evt){
 evt = Evt.GetEvent(evt);
 if(!ASPx.IsExists(evt)) return false;
 if(Browser.IE || Browser.Edge)
  return evt.button == 2;
 else if(Browser.NetscapeFamily || Browser.WebKitFamily)
  return evt.which == 3;
 else if (Browser.Opera)
  return evt.button == 1;
 return true;
}
Evt.GetWheelDelta = function(evt){
 var ret = Browser.NetscapeFamily ? -evt.detail : evt.wheelDelta;
 if(Browser.Opera && Browser.Version < 9)
  ret = -ret;
 return ret;
}
Evt.AttachEventToElement = function(element, eventName, func, onlyBubbling) {
 if(element.addEventListener)
  element.addEventListener(eventName, func, !onlyBubbling);
 else
  element.attachEvent("on" + eventName, func);
}
Evt.DetachEventFromElement = function(element, eventName, func) {
 if(element.removeEventListener)
  element.removeEventListener(eventName, func, true);
 else
  element.detachEvent("on" + eventName, func);
}
Evt.AttachEventToDocument = function(eventName, func) {
 var attachingAllowed = ASPx.TouchUIHelper.onEventAttachingToDocument(eventName, func);
 if(attachingAllowed)
  Evt.AttachEventToDocumentCore(eventName, func);
}
Evt.AttachEventToDocumentCore = function(eventName, func) {
 Evt.AttachEventToElement(document, eventName, func);
}
Evt.DetachEventFromDocument = function(eventName, func) {
 Evt.DetachEventFromDocumentCore(eventName, func);
 ASPx.TouchUIHelper.onEventDettachedFromDocument(eventName, func);
}
Evt.DetachEventFromDocumentCore = function(eventName, func){
 Evt.DetachEventFromElement(document, eventName, func);
}
Evt.GetMouseWheelEventName = function(){
 return Browser.NetscapeFamily ? "DOMMouseScroll" : "mousewheel";
}
Evt.AttachMouseEnterToElement = function (element, onMouseOverHandler, onMouseOutHandler) {
 Evt.AttachEventToElement(element, ASPx.TouchUIHelper.pointerEnabled ? ASPx.TouchUIHelper.pointerOverEventName : "mouseover", function (evt) { mouseEnterHandler(evt, element, onMouseOverHandler, onMouseOutHandler); });
 Evt.AttachEventToElement(element, ASPx.TouchUIHelper.pointerEnabled ? ASPx.TouchUIHelper.pointerOutEventName : "mouseout", function (evt) { mouseEnterHandler(evt, element, onMouseOverHandler, onMouseOutHandler); });
}
Evt.GetEventRelatedTarget = function(evt, isMouseOverEvent) {
 return evt.relatedTarget || (isMouseOverEvent ? evt.srcElement : evt.toElement);
}
function mouseEnterHandler(evt, element, onMouseOverHandler, onMouseOutHandler) {
 var isMouseOverExecuted = !!element.dxMouseOverExecuted;
 var isMouseOverEvent = (evt.type == "mouseover" || evt.type == ASPx.TouchUIHelper.pointerOverEventName);
 if(isMouseOverEvent && isMouseOverExecuted || !isMouseOverEvent && !isMouseOverExecuted)
  return;
 var source = Evt.GetEventRelatedTarget(evt, isMouseOverEvent);
 if(!ASPx.GetIsParent(element, source)) {
  element.dxMouseOverExecuted = isMouseOverEvent;
  if(isMouseOverEvent)
   onMouseOverHandler(element);
  else
   onMouseOutHandler(element);
 }
 else if(isMouseOverEvent && !isMouseOverExecuted) {
  element.dxMouseOverExecuted = true;
  onMouseOverHandler(element);
 }
}
Evt.DispatchEvent = function(target, eventName, canBubble, cancellable) {
 var event;
 if(Browser.IE && Browser.Version < 9) {
  eventName = "on" + eventName;
  if(eventName in target) {
   event = document.createEventObject();
   target.fireEvent("on" + eventName, event);
  }
 } else {
  event = document.createEvent("Event");
  event.initEvent(eventName, canBubble || false, cancellable || false);
  target.dispatchEvent(event);
 }
}
Evt.EmulateDocumentOnMouseDown = function(evt) {
 Evt.EmulateOnMouseDown(document, evt);
}
Evt.EmulateOnMouseDown = function(element, evt) {
 if(Browser.IE && Browser.Version < 9)
  element.fireEvent("onmousedown", evt);
 else if(!Browser.WebKitFamily){
  var emulatedEvt = document.createEvent("MouseEvents");
  emulatedEvt.initMouseEvent("mousedown", true, true, window, 0, evt.screenX, evt.screenY, 
   evt.clientX, evt.clientY, evt.ctrlKey, evt.altKey, evt.shiftKey, false, 0, null);
  element.dispatchEvent(emulatedEvt);
 }
}
Evt.EmulateOnMouseEvent = function (type, element, evt) {
 evt.type = type;
 var emulatedEvt = document.createEvent("MouseEvents");
 emulatedEvt.initMouseEvent(type, true, true, window, 0, evt.screenX, evt.screenY,
  evt.clientX, evt.clientY, evt.ctrlKey, evt.altKey, evt.shiftKey, false, 0, null);
 emulatedEvt.target = element;
 element.dispatchEvent(emulatedEvt);
}
Evt.EmulateMouseClick = function (element, evt) {
 var x = element.offsetWidth / 2;
 var y = element.offsetHeight / 2;
 if (!evt)
  evt = {
   bubbles: true,
   cancelable: true,
   view: window,
   detail: 1,
   screenX: 0,
   screenY: 0,
   clientX: x,
   clientY: y,
   ctrlKey: false,
   altKey: false,
   shiftKey: false,
   metaKey: false,
   button: 0,
   relatedTarget: null
  };
 Evt.EmulateOnMouseEvent("mousedown", element, evt);
 Evt.EmulateOnMouseEvent("mouseup", element, evt);
 Evt.EmulateOnMouseEvent("click", element, evt);
}
Evt.DoElementClick = function(element) {
 try{
  element.click();
 }
 catch(e){ 
 }
}
ASPx.Evt = Evt;
var Attr = { };
Attr.GetAttribute = function(obj, attrName){
 if(obj.getAttribute)
  return obj.getAttribute(attrName);
 else if(obj.getPropertyValue)
  return obj.getPropertyValue(attrName);
 return null;
}
Attr.SetAttribute = function(obj, attrName, value){
 if(obj.setAttribute)
  obj.setAttribute(attrName, value);
 else if(obj.setProperty)
  obj.setProperty(attrName, value, "");
}
Attr.RemoveAttribute = function(obj, attrName){
 if(obj.removeAttribute)
  obj.removeAttribute(attrName);
 else if(obj.removeProperty)
  obj.removeProperty(attrName);
}
Attr.IsExistsAttribute = function(obj, attrName){
 var value = Attr.GetAttribute(obj, attrName);
 return (value != null) && (value !== "");
}
Attr.SetOrRemoveAttribute = function(obj, attrName, value) {
 if(!value)
  Attr.RemoveAttribute(obj, attrName);
 else
  Attr.SetAttribute(obj, attrName, value);
}
Attr.SaveAttribute = function(obj, attrName, savedObj, savedAttrName){
 if(!Attr.IsExistsAttribute(savedObj, savedAttrName)){
  var oldValue = Attr.IsExistsAttribute(obj, attrName) ? Attr.GetAttribute(obj, attrName) : ASPx.EmptyObject;
  Attr.SetAttribute(savedObj, savedAttrName, oldValue);
 }
}
Attr.SaveStyleAttribute = function(obj, attrName){
 Attr.SaveAttribute(obj.style, attrName, obj, "saved" + attrName);
}
Attr.ChangeAttributeExtended = function(obj, attrName, savedObj, savedAttrName, newValue){
 Attr.SaveAttribute(obj, attrName, savedObj, savedAttrName);
 Attr.SetAttribute(obj, attrName, newValue);
}
Attr.ChangeAttribute = function(obj, attrName, newValue){
 Attr.ChangeAttributeExtended(obj, attrName, obj, "saved" + attrName, newValue);
}
Attr.ChangeStyleAttribute = function(obj, attrName, newValue){
 Attr.ChangeAttributeExtended(obj.style, attrName, obj, "saved" + attrName, newValue);
}
Attr.ResetAttributeExtended = function(obj, attrName, savedObj, savedAttrName){
 Attr.SaveAttribute(obj, attrName, savedObj, savedAttrName);
 Attr.SetAttribute(obj, attrName, "");
 Attr.RemoveAttribute(obj, attrName);
}
Attr.ResetAttribute = function(obj, attrName){
 Attr.ResetAttributeExtended(obj, attrName, obj, "saved" + attrName);
}
Attr.ResetStyleAttribute = function(obj, attrName){
 Attr.ResetAttributeExtended(obj.style, attrName, obj, "saved" + attrName);
}
Attr.RestoreAttributeExtended = function(obj, attrName, savedObj, savedAttrName){
 if(Attr.IsExistsAttribute(savedObj, savedAttrName)){
  var oldValue = Attr.GetAttribute(savedObj, savedAttrName);
  if(oldValue != ASPx.EmptyObject)
   Attr.SetAttribute(obj, attrName, oldValue);
  else
   Attr.RemoveAttribute(obj, attrName);
  Attr.RemoveAttribute(savedObj, savedAttrName);
  return true;
 }
 return false;
}
Attr.RestoreAttribute = function(obj, attrName){
 return Attr.RestoreAttributeExtended(obj, attrName, obj, "saved" + attrName);
}
Attr.RestoreStyleAttribute = function(obj, attrName){
 return Attr.RestoreAttributeExtended(obj.style, attrName, obj, "saved" + attrName);
}
Attr.CopyAllAttributes = function(sourceElem, destElement) {
 var attrs = sourceElem.attributes;
 for(var n = 0; n < attrs.length; n++) {
  var attr = attrs[n];
  if(attr.specified) {
   var attrName = attr.nodeName;
   var attrValue = sourceElem.getAttribute(attrName, 2);
   if(attrValue == null)
    attrValue = attr.nodeValue;
   destElement.setAttribute(attrName, attrValue, 0); 
  }
 }
 if(sourceElem.style.cssText !== '')
  destElement.style.cssText = sourceElem.style.cssText;
}
Attr.RemoveAllAttributes = function(element, excludedAttributes) {
 var excludedAttributesHashTable = {};
 if(excludedAttributes)
  excludedAttributesHashTable = Data.CreateHashTableFromArray(excludedAttributes);
 if(element.attributes) {
  var attrArray = element.attributes;
  for(var i = 0; i < attrArray.length; i++) {
   var attrName = attrArray[i].name;
   if(!ASPx.IsExists(excludedAttributesHashTable[attrName.toLowerCase()])) {
    try {
     attrArray.removeNamedItem(attrName);
    } catch (e) { }
   }
  }
 }
}
Attr.RemoveStyleAttribute = function(element, attrName) {
 if(element.style) {
  if(Browser.Firefox && element.style[attrName]) 
   element.style[attrName] = "";
  if(element.style.removeAttribute && element.style.removeAttribute != "")
   element.style.removeAttribute(attrName);
  else if(element.style.removeProperty && element.style.removeProperty != "")
   element.style.removeProperty(attrName);
 }
}
Attr.RemoveAllStyles = function(element) {
 if(element.style) {
  for(var key in element.style)
   Attr.RemoveStyleAttribute(element, key);
    Attr.RemoveAttribute(element, "style");
 }
}
Attr.GetTabIndexAttributeName = function(){
 return Browser.IE  ? "tabIndex" : "tabindex";
}
Attr.ChangeTabIndexAttribute = function(element){
 var attribute = Attr.GetTabIndexAttributeName(); 
 if(Attr.GetAttribute(element, attribute) != -1)
    Attr.ChangeAttribute(element, attribute, -1);
}
Attr.SaveTabIndexAttributeAndReset = function(element) {
 var attribute = Attr.GetTabIndexAttributeName();
 Attr.SaveAttribute(element, attribute, element, "saved" + attribute);
 Attr.SetAttribute(element, attribute, -1);
}
Attr.RestoreTabIndexAttribute = function(element){
 var attribute = Attr.GetTabIndexAttributeName();
 if(Attr.IsExistsAttribute(element, attribute)) {
  if(Attr.GetAttribute(element, attribute) == -1) {
   if(Attr.IsExistsAttribute(element, "saved" + attribute)){
    var oldValue = Attr.GetAttribute(element, "saved" + attribute);
    if(oldValue != ASPx.EmptyObject)
     Attr.SetAttribute(element, attribute, oldValue);
    else {
     if(Browser.WebKitFamily) 
      Attr.SetAttribute(element, attribute, 0); 
     Attr.RemoveAttribute(element, attribute);   
    }
    Attr.RemoveAttribute(element, "saved" + attribute); 
   }
  }
 }
}
Attr.ChangeAttributesMethod = function(enabled){
 return enabled ? Attr.RestoreAttribute : Attr.ResetAttribute;
}
Attr.InitiallyChangeAttributesMethod = function(enabled){
 return enabled ? Attr.ChangeAttribute : Attr.ResetAttribute;
}
Attr.ChangeStyleAttributesMethod = function(enabled){
 return enabled ? Attr.RestoreStyleAttribute : Attr.ResetStyleAttribute;
}
Attr.InitiallyChangeStyleAttributesMethod = function(enabled){
 return enabled ? Attr.ChangeStyleAttribute : Attr.ResetStyleAttribute;
}
Attr.ChangeEventsMethod = function(enabled){
 return enabled ? Evt.AttachEventToElement : Evt.DetachEventFromElement;
}
Attr.ChangeDocumentEventsMethod = function(enabled){
 return enabled ? Evt.AttachEventToDocument : Evt.DetachEventFromDocument;
}
ASPx.Attr = Attr;
var Color = { };
function _aspxToHex(d) {
 return (d < 16) ? ("0" + d.toString(16)) : d.toString(16);
}
Color.ColorToHexadecimal = function(colorValue) {
 if(typeof(colorValue) == "number") {
  var r = colorValue & 0xFF;
  var g = (colorValue >> 8) & 0xFF;
  var b = (colorValue >> 16) & 0xFF;
  return "#" + _aspxToHex(r) + _aspxToHex(g) + _aspxToHex(b);
 }
 if(colorValue && (colorValue.substr(0, 3).toLowerCase() == "rgb")) {
  var re = /rgb\s*\(\s*([0-9]+)\s*,\s*([0-9]+)\s*,\s*([0-9]+)\s*\)/;
  var regResult = colorValue.toLowerCase().match(re);
  if(regResult) {
   var r = parseInt(regResult[1]);
   var g = parseInt(regResult[2]);
   var b = parseInt(regResult[3]);
   return "#" + _aspxToHex(r) + _aspxToHex(g) + _aspxToHex(b);
  }
  return null;
 } 
 if(colorValue && (colorValue.charAt(0) == "#"))
  return colorValue;
 return null;
}
ASPx.Color = Color;
var Url = { };
Url.Navigate = function(url, target) {
 var javascriptPrefix = "javascript:";
 if(url == "")
  return;
 else if(url.indexOf(javascriptPrefix) != -1) 
  eval(url.substr(javascriptPrefix.length));
 else {
  try{
   if(target != "")
    navigateTo(url, target);
   else
    location.href = url;
  }
  catch(e){
  }
 }
}
Url.NavigateByLink = function(linkElement) {
 Url.Navigate(Attr.GetAttribute(linkElement, "href"), linkElement.target);
}
Url.GetAbsoluteUrl = function(url) {
 if(url)
  url = Url.getURLObject(url).href;
 return url;
}
var absolutePathPrefixes = 
 [ "about:", "file:///", "ftp://", "gopher://", "http://", "https://", "javascript:", "mailto:", "news:", "res://", "telnet://", "view-source:" ];
Url.isAbsoluteUrl = function(url) {
 if (url) {
  for (var i = 0; i < absolutePathPrefixes.length; i++) {
   if(url.indexOf(absolutePathPrefixes[i]) == 0)
    return true;
  }
 }
 return false;
}
Url.getURLObject = function(url) {
 var link = document.createElement('A');
 link.href = url || "";
 return { 
  href: link.href,
  protocol: link.protocol,
  host: link.host,
  port: link.port,
  pathname: link.pathname,
  search: link.search,
  hash: link.hash
 }; 
}
Url.getRootRelativeUrl = function(url) {
 return getRelativeUrl(url, !Url.isRootRelativeUrl(url), true); 
}
Url.getPathRelativeUrl = function(url) {
 return getRelativeUrl(url, !Url.isPathRelativeUrl(url), false);
}
function getRelativeUrl(url, isValid, isRootRelative) {
 if(url && !(/data:([^;]+\/?[^;]*)(;charset=[^;]*)?(;base64,)/.test(url)) && isValid) {
  var urlObject = Url.getURLObject(url);
  var baseUrlObject = Url.getURLObject();
  if(!Url.isAbsoluteUrl(url) || urlObject.host === baseUrlObject.host && urlObject.protocol === baseUrlObject.protocol) {
   url = urlObject.pathname;
   if(!isRootRelative)
    url = getPathRelativeUrl(baseUrlObject.pathname, url);
   url = url + urlObject.search + urlObject.hash;
  }
 }
 return url;   
}
function getPathRelativeUrl(baseUrl, url) {
 var requestSegments = getSegments(baseUrl, false);
 var urlSegments = getSegments(url, true);
 return buildPathRelativeUrl(requestSegments, urlSegments, 0, 0, "");
}
function getSegments(url, addTail) {
 var segments = [];
 var startIndex = 0;
 var endIndex = -1;
 while ((endIndex = url.indexOf("/", startIndex)) != -1) {
  segments.push(url.substring(startIndex, ++endIndex));
  startIndex = endIndex;
 }
 if(addTail && startIndex < url.length)
  segments.push(url.substring(startIndex, url.length)); 
 return segments;
}
function buildPathRelativeUrl(requestSegments, urlSegments, reqIndex, urlIndex, buffer) {
 if(urlIndex >= urlSegments.length)
  return buffer;
 if(reqIndex >= requestSegments.length)
  return buildPathRelativeUrl(requestSegments, urlSegments, reqIndex, urlIndex + 1, buffer + urlSegments[urlIndex]);
 if(requestSegments[reqIndex] === urlSegments[urlIndex] && urlIndex === reqIndex)
  return buildPathRelativeUrl(requestSegments, urlSegments, reqIndex + 1, urlIndex + 1, buffer);
 return buildPathRelativeUrl(requestSegments, urlSegments, reqIndex + 1, urlIndex, buffer + "../");
}
Url.isPathRelativeUrl = function(url) {
 return !!url && !Url.isAbsoluteUrl(url) && url.indexOf("/") != 0;  
}
Url.isRootRelativeUrl = function(url) {
 return !!url && !Url.isAbsoluteUrl(url) && url.indexOf("/") == 0 && url.indexOf("//") != 0;
}
function navigateTo(url, target) {
 var lowerCaseTarget = target.toLowerCase();
 if("_top" == lowerCaseTarget)
  top.location.href = url;
 else if("_self" == lowerCaseTarget)
  location.href = url;
 else if("_search" == lowerCaseTarget)
  window.open(url, '_blank');
 else if("_media" == lowerCaseTarget)
  window.open(url, '_blank');
 else if("_parent" == lowerCaseTarget)
  window.parent.location.href = url;
 else if("_blank" == lowerCaseTarget)
  window.open(url, '_blank');
 else {
  var frame = getFrame(top.frames, target);
  if(frame != null)
   frame.location.href = url;
  else
   window.open(url, '_blank');
 }
}
ASPx.Url = Url;
var Office = {}
Office.getHandlerResourceUrl = function(pageUrl) {
 var url = pageUrl ? pageUrl : document.URL;
 if(url.indexOf("?") != -1)
  url = url.substring(0, url.indexOf("?"));
 if(url.indexOf("#") != -1) 
  url = url.substring(0, url.indexOf("#"));
 if(/.*\.aspx$/.test(url))
  url = url.substring(0, url.lastIndexOf("/") + 1);
 else if(url.lastIndexOf("/") != url.length - 1)
  url += "/";
 return url;
}
ASPx.Office = Office;
var Json = { };
function isValid(JsonString) {
 return !(/[^,:{}\[\]0-9.\-+Eaeflnr-u \n\r\t]/.test(JsonString.replace(/"(\\.|[^"\\])*"/g, '')))
}
Json.Eval = function(jsonString, controlName) {
 if(isValid(jsonString))
  return eval("(" + jsonString + ")");
 else
  throw new Error(controlName + " received incorrect JSON-data: " + jsonString);
}
Json.ToJson = function(param){
 var paramType = typeof(param);
 if((paramType == "undefined") || (param == null))
  return null;
 if((paramType == "object") && (typeof(param.__toJson) == "function"))
  return param.__toJson();
 if((paramType == "number") || (paramType == "boolean"))
  return param;
 if(param.constructor == Date)
  return dateToJson(param);
 if(paramType == "string") {
  var result = param.replace(/\\/g, "\\\\");
  result = result.replace(/"/g, "\\\"");
  result = result.replace(/\n/g, "\\n");
  result = result.replace(/\r/g, "\\r");
  result = result.replace(/</g, "\\u003c");
  result = result.replace(/>/g, "\\u003e");
  return "\"" + result + "\"";
 }
 if(param.constructor == Array){
  var values = [];
  for(var i = 0; i < param.length; i++) {
   var jsonValue = Json.ToJson(param[i]);
   if(jsonValue === null)
    jsonValue = "null";
   values.push(jsonValue);
  }
  return "[" + values.join(",") + "]";
 }
 var exceptKeys = {};
 if(ASPx.Ident.IsArray(param.__toJsonExceptKeys))
  exceptKeys = Data.CreateHashTableFromArray(param.__toJsonExceptKeys);
 exceptKeys["__toJsonExceptKeys"] = 1;
 var values = [];
 for(var key in param){
  if(ASPx.IsFunction(param[key]))
   continue;
  if(exceptKeys[key] == 1)
   continue;
  values.push(Json.ToJson(key) + ":" + Json.ToJson(param[key]));
 }
 return "{" + values.join(",") + "}";
}
function dateToJson(date) {
 var result = [ 
  date.getFullYear(),
  date.getMonth(),
  date.getDate()
 ];
 var time = {
  h: date.getHours(),
  m: date.getMinutes(),
  s: date.getSeconds(),
  ms: date.getMilliseconds()
 };
 if(time.h || time.m || time.s || time.ms)
  result.push(time.h);
 if(time.m || time.s || time.ms)
  result.push(time.m);
 if(time.s || time.ms)
  result.push(time.s);
 if(time.ms)
  result.push(time.ms);
 return "new Date(" + result.join() + ")";
}
ASPx.Json = Json;
ASPx.CreateClass = function(parentClass, properties) {
 var ret = function() {
  if(ret.preparing) 
   return delete(ret.preparing);
  if(ret.constr) {
   this.constructor = ret;
   ret.constr.apply(this, arguments);
  }
 }
 ret.prototype = {};
 if(parentClass) {
  parentClass.preparing = true;
  for(var name in parentClass) {
   if(parentClass.hasOwnProperty(name) && name != 'constr' && ASPx.IsFunction(parentClass[name]) && !ret[name])
    ret[name] = parentClass[name].aspxBind(parentClass);
  }
  ret.prototype = new parentClass;
  ret.prototype.constructor = parentClass;
  ret.constr = parentClass;
 }
 if(properties) {
  var constructorName = "constructor";
  for(var name in properties){
   if(name != constructorName) 
    ret.prototype[name] = properties[name];
  }
  if(properties[constructorName] && properties[constructorName] != Object)
   ret.constr = properties[constructorName];
 }
 return ret;
}
ASPx.FormatCallbackArg = function(prefix, arg) {
 if(prefix == null && arg == null)
  return ""; 
 if(prefix == null) prefix = "";
 if(arg == null) arg = "";
 if(arg != null && !ASPx.IsExists(arg.length) && ASPx.IsExists(arg.value))
  arg = arg.value;
 arg = arg.toString();
 return [prefix, '|', arg.length, '|' , arg].join('');
}
ASPx.FormatCallbackArgs = function(callbackData) {
 var sb = [ ];
 for(var i = 0; i < callbackData.length; i++)
  sb.push(ASPx.FormatCallbackArg(callbackData[i][0], callbackData[i][1]));
 return sb.join("");
}
ASPx.ParseShortcutString = function(shortcutString) {
 if(!shortcutString)
  return 0;
 var isCtrlKey = false;
 var isShiftKey = false;
 var isAltKey = false;
 var isMetaKey = false;
 var keyCode = null;
 var shcKeys = shortcutString.toString().split("+");
 if(shcKeys.length > 0) {
  for(var i = 0; i < shcKeys.length; i++) {
   var key = Str.Trim(shcKeys[i].toUpperCase());
   switch (key) {
    case "CTRL":
     isCtrlKey = true;
     break;
    case "SHIFT":
     isShiftKey = true;
     break;
    case "ALT":
     isAltKey = true;
     break;
    case "CMD":
     isMetaKey = true;
     break;
    case "F1": keyCode = ASPx.Key.F1; break;
    case "F2": keyCode = ASPx.Key.F2; break;
    case "F3": keyCode = ASPx.Key.F3; break;
    case "F4": keyCode = ASPx.Key.F4; break;
    case "F5": keyCode = ASPx.Key.F5; break;
    case "F6": keyCode = ASPx.Key.F6; break;
    case "F7": keyCode = ASPx.Key.F7; break;
    case "F8": keyCode = ASPx.Key.F8; break;
    case "F9": keyCode = ASPx.Key.F9; break;
    case "F10":   keyCode = ASPx.Key.F10; break;
    case "F11":   keyCode = ASPx.Key.F11; break;
    case "F12":   keyCode = ASPx.Key.F12; break;
    case "ENTER": keyCode = ASPx.Key.Enter; break;
    case "HOME":  keyCode = ASPx.Key.Home; break;
    case "END":   keyCode = ASPx.Key.End; break;
    case "LEFT":  keyCode = ASPx.Key.Left; break;
    case "RIGHT": keyCode = ASPx.Key.Right; break;
    case "UP": keyCode = ASPx.Key.Up; break;
    case "DOWN":  keyCode = ASPx.Key.Down; break;
    case "PAGEUP": keyCode = ASPx.Key.PageUp; break;
    case "PAGEDOWN": keyCode = ASPx.Key.PageDown; break;
    case "SPACE": keyCode = ASPx.Key.Space; break;
    case "TAB":   keyCode = ASPx.Key.Tab; break;
    case "BACK":  keyCode = ASPx.Key.Backspace; break;
    case "CONTEXT": keyCode = ASPx.Key.ContextMenu; break;
    case "ESCAPE":
    case "ESC":
     keyCode = ASPx.Key.Esc;
     break;
    case "DELETE":
    case "DEL":
     keyCode = ASPx.Key.Delete;
     break;
    case "INSERT":
    case "INS":
     keyCode = ASPx.Key.Insert;
     break;
    case "PLUS":
     keyCode = "+".charCodeAt(0);
     break;
    default:
     keyCode = key.charCodeAt(0);
     break;
   }
  }
 } else
  alert("Invalid shortcut");
 return ASPx.GetShortcutCode(keyCode, isCtrlKey, isShiftKey, isAltKey, isMetaKey);
}
ASPx.GetShortcutCode = function(keyCode, isCtrlKey, isShiftKey, isAltKey, isMetaKey) {
 var value = keyCode & 0xFFFF;
 var flags = 0;
 flags |= isCtrlKey ? 1 << 0 : 0;
 flags |= isShiftKey ? 1 << 2 : 0;
 flags |= isAltKey ? 1 << 4 : 0;
 flags |= isMetaKey ? 1 << 8 : 0;
 value |= flags << 16;
 return value;
}
ASPx.GetShortcutCodeByEvent = function(evt) {
 return ASPx.GetShortcutCode(Evt.GetKeyCode(evt), evt.ctrlKey, evt.shiftKey, evt.altKey, ASPx.Browser.MacOSPlatform ? evt.metaKey : false);
}
ASPx.IsPasteShortcut = function(evt) {
 if(evt.type === "paste")
  return true;
 var keyCode = Evt.GetKeyCode(evt);
 if(Browser.NetscapeFamily && evt.which == 0)  
  keyCode = evt.keyCode;
 return (evt.ctrlKey && (keyCode == 118  || (keyCode == 86))) ||
     (evt.shiftKey && !evt.ctrlKey && !evt.altKey &&
     (keyCode == ASPx.Key.Insert)) ;
}
ASPx.SetFocus = function(element, selectAction) {
 function focusCore(element, selectAction){
  try {
    element.focus();
    if(Browser.IE && document.activeElement != element)
     element.focus();
    if(selectAction) {
     var currentSelection = Selection.GetInfo(element);
     if(currentSelection.startPos == currentSelection.endPos) {
      switch(selectAction) {
       case "start":
        Selection.SetCaretPosition(element, 0);
        break;
       case "all":
        Selection.Set(element);
        break;
      }
     }
    }
   } catch (e) {
  }
 }
 if(ASPxClientUtils.iOSPlatform) 
  focusCore(element, selectAction);
 else {
  window.setTimeout(function() { 
   focusCore(element, selectAction);
  }, 100);
 }
}
ASPx.IsFocusableCore = function(element, skipContainerVisibilityCheck) {
 var current = element;
 while(current && current.nodeType == 1) {
  if(current == element || !skipContainerVisibilityCheck(current)) {
   if(current.tagName == "BODY")
    return true;
   if(current.disabled || !ASPx.GetElementDisplay(current) || !ASPx.GetElementVisibility(current))
    return false;
  }
  current = current.parentNode;
 }
 return true;
}
ASPx.IsFocusable = function(element) {
 return ASPx.IsFocusableCore(element, ASPx.FalseFunction);
}
ASPx.FindChildActionElement = function (container, predicate) {
 var result = null;
 if(!container) return result;
 var actionElements = (ASPx.GetNodes(container, function(el) { 
  var tabIndex = ASPx.Attr.GetAttribute(el, ASPx.Attr.GetTabIndexAttributeName());
  return (!predicate || predicate(el)) &&
      ((el.tagName !== "INPUT" && tabIndex && parseInt(tabIndex) >= 0) ||
      (el.tagName === "INPUT" && el.type.toLowerCase() !== "hidden" && parseInt(tabIndex) != -1) ||
      (el.tagName === "A" && el.href && parseInt(tabIndex) != -1));
 }));
 if(actionElements.length > 0) {
  var tabIndexElements = actionElements.filter(function(x) { return parseInt(ASPx.Attr.GetAttribute(x, "tabindex")) > 0; });
  tabIndexElements.sort(function(x, y) {
   xTabIndex = parseInt(ASPx.Attr.GetAttribute(x, "tabindex"));
   yTabIndex = parseInt(ASPx.Attr.GetAttribute(y, "tabindex"));
   return xTabIndex - yTabIndex;
  });
  result = tabIndexElements[0] || actionElements[0];
 }
 return result;
}
ASPx.IsExists = function(obj){
 return (typeof(obj) != "undefined") && (obj != null);
}
ASPx.IsFunction = function(obj){
 return typeof(obj) == "function";
}
ASPx.IsNumber = function(str) {
 return !isNaN(parseFloat(str)) && isFinite(str);
}
ASPx.GetDefinedValue = function(value, defaultValue){
 return (typeof(value) != "undefined") ? value : defaultValue;
}
ASPx.CorrectJSFloatNumber = function(number) {
 var ret = 21; 
 var numString = number.toPrecision(21);
 numString = numString.replace("-", ""); 
 var integerDigitsCount = numString.indexOf(ASPx.PossibleNumberDecimalSeparators[0]);
 if(integerDigitsCount < 0)
  integerDigitsCount = numString.indexOf(ASPx.PossibleNumberDecimalSeparators[1]);
 var floatDigitsCount = numString.length - integerDigitsCount - 1;
 if(floatDigitsCount < 10)
  return number;
 if(integerDigitsCount > 0) {
  ret = integerDigitsCount + 12;
 }
 var toPrecisionNumber = Math.min(ret, 21);
 var newValueString = number.toPrecision(toPrecisionNumber);
 return parseFloat(newValueString, 10);
}
ASPx.CorrectRounding = function(number, step) { 
 var regex = /[,|.](.*)/,
  isFloatValue = regex.test(number),
  isFloatStep = regex.test(step);
 if(isFloatValue || isFloatStep) {
  var valueAccuracy = (isFloatValue) ? regex.exec(number)[0].length - 1 : 0,
   stepAccuracy = (isFloatStep) ? regex.exec(step)[0].length - 1 : 0,
   accuracy = Math.max(valueAccuracy, stepAccuracy);
  var multiplier = Math.pow(10, accuracy);
  number = Math.round((number + step) * multiplier) / multiplier;
  return number;
 }
 return number + step;
}
ASPx.GetActiveElement = function() {
 try{ return document.activeElement; } catch(e) { return null; }
}
var verticalScrollBarWidth;
ASPx.GetVerticalScrollBarWidth = function() {
 if(typeof(verticalScrollBarWidth) == "undefined") {
  var container = document.createElement("DIV");
  container.style.cssText = "position: absolute; top: 0px; left: 0px; visibility: hidden; width: 200px; height: 150px; overflow: hidden; box-sizing: content-box";
  document.body.appendChild(container);
  var child = document.createElement("P");
  container.appendChild(child);
  child.style.cssText = "width: 100%; height: 200px;";
  var widthWithoutScrollBar = child.offsetWidth;
  container.style.overflow = "scroll";
  var widthWithScrollBar = child.offsetWidth;
  if(widthWithoutScrollBar == widthWithScrollBar)
   widthWithScrollBar = container.clientWidth;
  verticalScrollBarWidth = widthWithoutScrollBar - widthWithScrollBar;
  document.body.removeChild(container);
 }
 return verticalScrollBarWidth;
}
function hideScrollBarCore(element, scrollName) {
 if(element.tagName == "IFRAME") {
  if((element.scrolling == "yes") || (element.scrolling == "auto")) {
   Attr.ChangeAttribute(element, "scrolling", "no");
   return true;
  }
 }
 else if(element.tagName == "DIV") {
  if((element.style[scrollName] == "scroll") || (element.style[scrollName] == "auto")) {
   Attr.ChangeStyleAttribute(element, scrollName, "hidden");
   return true;
  }
 }
 return false;
}
function restoreScrollBarCore(element, scrollName) {
 if(element.tagName == "IFRAME")
  return Attr.RestoreAttribute(element, "scrolling");
 else if(element.tagName == "DIV")
  return Attr.RestoreStyleAttribute(element, scrollName);
 return false;
}
ASPx.SetScrollBarVisibilityCore = function(element, scrollName, isVisible) {
 return isVisible ? restoreScrollBarCore(element, scrollName) : hideScrollBarCore(element, scrollName);
}
ASPx.SetScrollBarVisibility = function(element, isVisible) {
 if(ASPx.SetScrollBarVisibilityCore(element, "overflow", isVisible)) 
  return true;
 var result = ASPx.SetScrollBarVisibilityCore(element, "overflowX", isVisible)
  || ASPx.SetScrollBarVisibilityCore(element, "overflowY", isVisible);
 return result;
}
ASPx.SetInnerHtml = function(element, html) {
 if(Browser.IE) {
  element.innerHTML = "<em>&nbsp;</em>" + html;
  element.removeChild(element.firstChild);
 } else
  element.innerHTML = html;
}
ASPx.GetInnerText = function(container) {
 if(Browser.Safari && Browser.MajorVersion <= 5) {
  var filter = getHtml2PlainTextFilter();
  filter.innerHTML = container.innerHTML;
  ASPx.SetElementDisplay(filter, true);
  var innerText = filter.innerText;
  ASPx.SetElementDisplay(filter, false);
  return innerText;
 } else if(Browser.NetscapeFamily || Browser.WebKitFamily || (Browser.IE && Browser.Version >= 9)) {
  return container.textContent;
 } else
  return container.innerText;
}
var html2PlainTextFilter = null;
function getHtml2PlainTextFilter() {
 if(html2PlainTextFilter == null) {
  html2PlainTextFilter = document.createElement("DIV");
  html2PlainTextFilter.style.width = "0";
  html2PlainTextFilter.style.height = "0";
  html2PlainTextFilter.style.overflow = "visible";
  ASPx.SetElementDisplay(html2PlainTextFilter, false);
  document.body.appendChild(html2PlainTextFilter);
 }
 return html2PlainTextFilter;
}
ASPx.CreateHiddenField = function(name, id) {
 var input = document.createElement("INPUT");
 input.setAttribute("type", "hidden");
 if(name)
  input.setAttribute("name", name);
 if(id)
  input.setAttribute("id", id);
 return input;
}
ASPx.CloneObject = function(srcObject) {
  if(typeof(srcObject) != 'object' || srcObject == null)
 return srcObject;
  var newObject = { };
  for(var i in srcObject) 
 newObject[i] = srcObject[i];
  return newObject;
}
ASPx.IsPercentageSize = function(size) {
 return size && size.indexOf('%') != -1;
}
ASPx.GetElementById = function(id) {
 if(document.getElementById)
  return document.getElementById(id);
 else
  return document.all[id];
}
ASPx.GetInputElementById = function(id) {
 var elem = ASPx.GetElementById(id);
 if(!Browser.IE)
  return elem;
 if(elem) {
  if(elem.id == id)
   return elem;
  else {
   for(var i = 1; i < document.all[id].length; i++) {
    if(document.all[id][i].id == id)
     return document.all[id][i];
   }
  }
 }
 return null;
}
ASPx.GetElementByIdInDocument = function(documentObj, id) {
 if(documentObj.getElementById)
  return documentObj.getElementById(id);
 else
  return documentObj.all[id];
}
ASPx.GetIsParent = function(parentElement, element) {
 if(!parentElement || !element)
  return false;
 while(element){
  if(element === parentElement)
   return true;
  if(element.tagName === "BODY")
   return false;
  element = element.parentNode;
 }
 return false;
}
ASPx.GetParentById = function(element, id) {
 element = element.parentNode;
 while(element){
  if(element.id === id)
   return element;
  element = element.parentNode;
 }
 return null;
}
ASPx.GetParentByPartialId = function(element, idPart){
 while(element && element.tagName != "BODY") {
  if(element.id && element.id.match(idPart)) 
   return element;
  element = element.parentNode;
 }
 return null;
}
ASPx.GetParentByTagName = function(element, tagName) {
 tagName = tagName.toUpperCase();
 while(element) {
  if(element.tagName === "BODY")
   return null;
  if(element.tagName === tagName)
   return element;
  element = element.parentNode;
 }
 return null;
}
function getParentByClassNameInternal(element, className, selector) {
 while(element != null) {
  if(element.tagName == "BODY")
   return null;
  if(selector(element, className))
   return element;
  element = element.parentNode;
 }
 return null;
}
ASPx.GetParentByPartialClassName = function(element, className) {
 return getParentByClassNameInternal(element, className, ASPx.ElementContainsCssClass);
}
ASPx.GetParentByClassName = function(element, className) {
 return getParentByClassNameInternal(element, className, ASPx.ElementHasCssClass);
}
ASPx.GetParentByTagNameAndAttributeValue = function(element, tagName, attrName, attrValue) {
 tagName = tagName.toUpperCase();
 while(element != null) {
  if(element.tagName == "BODY")
   return null;
  if(element.tagName == tagName && element[attrName] == attrValue)
   return element;
  element = element.parentNode;
 }
 return null;
}
ASPx.GetParent = function(element, testFunc){
 if (!ASPx.IsExists(testFunc)) return null;
 while(element != null && element.tagName != "BODY"){
  if(testFunc(element))
   return element;
  element = element.parentNode;
 }
 return null;
}
ASPx.GetPreviousSibling = function(el) {
 if(el.previousElementSibling) {
  return el.previousElementSibling;
 } else {
  while(el = el.previousSibling) {
   if(el.nodeType === 1)
    return el;
  }
 }
}
ASPx.ElementHasCssClass = function(element, className) {
 try {
  var classList = element.classList;
  var classNames = className.split(" ");
  if(!classList)
   var elementClasses = element.className.split(" ");
  for(var i = classNames.length - 1; i >= 0; i--) {
   if(classList) {
    if(!classList.contains(classNames[i]))
     return false;
    continue;
   }
   if(Data.ArrayIndexOf(elementClasses, classNames[i]) < 0)
    return false;
  }
  return true;
 } catch(e) {
  return false;
 }
}
ASPx.ElementContainsCssClass = function(element, className) {
 try {
  return element.className.indexOf(className) != -1;
 } catch(e) {
  return false;
 }
}
ASPx.AddClassNameToElement = function (element, className) {
 if(!element) return;
 if (!ASPx.ElementHasCssClass(element, className))
  element.className = (element.className === "") ? className : element.className + " " + className;
}
ASPx.RemoveClassNameFromElement = function(element, className) {
 if(!element) return;
 var updClassName = " " + element.className + " ";
 var newClassName = updClassName.replace(" " + className + " ", " ");
 if(updClassName.length != newClassName.length)
  element.className = Str.Trim(newClassName);
}
function nodeListToArray(nodeList, filter) {
 var result = [];
 for(var i = 0, element; element = nodeList[i]; i++) {
  if(filter && !filter(element))
   continue;
  result.push(element);
 }
 return result;
}
function getItemByIndex(collection, index) {
 if(!index) index = 0;
 if(collection != null && collection.length > index)
  return collection[index];
 return null;
}
ASPx.GetChildNodesByClassName = function(parent, className) {
 if(parent.querySelectorAll) {
  var children = parent.querySelectorAll('.' + className);
  return nodeListToArray(children, function(element) { 
   return element.parentNode === parent;
  });
 }
 return ASPx.GetChildNodes(parent, function(elem) { return elem.className && ASPx.ElementHasCssClass(elem, className); });
}
ASPx.GetChildNodesByPartialClassName = function(element, className) {
 return ASPx.GetChildElementNodesByPredicate(element,
  function(child) {
   return ASPx.ElementContainsCssClass(child, className);
  });
}
ASPx.GetChildByPartialClassName = function(element, className, index) {
 if(element != null){    
  var collection = ASPx.GetChildNodesByPartialClassName(element, className);
  return getItemByIndex(collection, index);
 }
 return null;
}
ASPx.GetChildByClassName = function(element, className, index) {
 if(element != null){    
  var collection = ASPx.GetChildNodesByClassName(element, className);
  return getItemByIndex(collection, index);
 }
 return null;
}
ASPx.GetNodesByPartialClassName = function(element, className) {
 if(element.querySelectorAll) {
  var list = element.querySelectorAll('*[class*=' + className + ']');
  return nodeListToArray(list);
 }
 var collection = element.all || element.getElementsByTagName('*');
 var ret = [ ];
 if(collection != null) {
  for(var i = 0; i < collection.length; i ++) {
   if(ASPx.ElementContainsCssClass(collection[i], className))
    ret.push(collection[i]);
  }
 }
 return ret;
}
ASPx.GetNodesByClassName = function(parent, className) {
 if(parent.querySelectorAll) {
  var children = parent.querySelectorAll('.' + className);
  return nodeListToArray(children);
 }
 return ASPx.GetNodes(parent, function(elem) { return elem.className && ASPx.ElementHasCssClass(elem, className); });
}
ASPx.GetNodeByClassName = function(element, className, index) {
 if(element != null){    
  var collection = ASPx.GetNodesByClassName(element, className);
  return getItemByIndex(collection, index);
 }
 return null;
}
ASPx.GetChildById = function(element, id) {
 if(element.all) {
  var child = element.all[id];
  if(!child) {
   child = element.all(id); 
   if(!child)
    return Browser.IE ? document.getElementById(id) : null; 
  } 
  if(!ASPx.IsExists(child.length)) 
   return child;
  else
   return ASPx.GetElementById(id);
 }
 else
  return ASPx.GetElementById(id);
}
ASPx.GetNodesByPartialId = function(element, partialName, list) {
 if(element.id && element.id.indexOf(partialName) > -1) 
  list.push(element);
 if(element.childNodes) {
  for(var i = 0; i < element.childNodes.length; i ++) 
   ASPx.GetNodesByPartialId(element.childNodes[i], partialName, list);
 }
}
ASPx.GetNodesByTagName = function(element, tagName) {
 tagName = tagName.toUpperCase();
 if(element) {
  if(element.getElementsByTagName) 
   return element.getElementsByTagName(tagName);
  else if(element.all && element.all.tags !== undefined)
   return Browser.Netscape ? element.all.tags[tagName] : element.all.tags(tagName);
 }
 return null;
}
ASPx.GetNodeByTagName = function(element, tagName, index) {
 if(element != null){    
  var collection = ASPx.GetNodesByTagName(element, tagName);
  return getItemByIndex(collection, index);
 }
 return null;
}
ASPx.GetChildNodesByTagName = function(parent, tagName) {
 return ASPx.GetChildNodes(parent, function (child) { return child.tagName === tagName; });
}
ASPx.GetChildByTagName = function(element, tagName, index) {
 if(element != null){    
  var collection = ASPx.GetChildNodesByTagName(element, tagName);
  return getItemByIndex(collection, index);
 }
 return null;
}
ASPx.RetrieveByPredicate = function(scourceCollection, predicate) {
 var result = [];
 for(var i = 0; i < scourceCollection.length; i++) {
  var element = scourceCollection[i];
  if(!predicate || predicate(element)) 
   result.push(element);
 }
 return result;
}
ASPx.GetChildNodes = function(parent, predicate) {
 return ASPx.RetrieveByPredicate(parent.childNodes, predicate);
}
ASPx.GetNodes = function(parent, predicate) {
 var c = parent.all || parent.getElementsByTagName('*');
 return ASPx.RetrieveByPredicate(c, predicate);
}
ASPx.GetChildElementNodes = function(parent) {
 if(!parent) return null;
 return ASPx.GetChildNodes(parent, function(e) { return e.nodeType == 1 })
}
ASPx.GetChildElementNodesByPredicate = function(parent, predicate) {
 if(!parent) return null;
 if(!predicate) return ASPx.GetChildElementNodes(parent);
 return ASPx.GetChildNodes(parent, function(e) { return e.nodeType == 1 && predicate(e); })
}
ASPx.GetTextNode = function(element, index) {
 if(element != null){
  var collection = [ ];
  ASPx.GetTextNodes(element, collection);
  return getItemByIndex(collection, index);
 }
 return null;
}
ASPx.GetTextNodes = function(element, collection) {
 for(var i = 0; i < element.childNodes.length; i ++){
  var childNode = element.childNodes[i];
  if(ASPx.IsExists(childNode.nodeValue))
   collection.push(childNode);
  ASPx.GetTextNodes(childNode, collection);
 }
}
ASPx.GetElementDocument = function(element) {
 return element.document || element.ownerDocument;
}
ASPx.RemoveElement = function(element) {
 if(element && element.parentNode)
  element.parentNode.removeChild(element);
}
ASPx.ReplaceTagName = function(element, newTagName, cloneChilds) {
 if(element.nodeType != 1)
  return null;
 if(element.nodeName == newTagName)
  return element;
 cloneChilds = cloneChilds !== undefined ? cloneChilds : true;
 var doc = element.ownerDocument;
 var newElem = doc.createElement(newTagName);
 Attr.CopyAllAttributes(element, newElem);
 if(cloneChilds) {
  for(var i = 0; i < element.childNodes.length; i++)
   newElem.appendChild(element.childNodes[i].cloneNode(true));
 }
 else {
  for(var child; child = element.firstChild; )
   newElem.appendChild(child);
 }
 element.parentNode.replaceChild(newElem, element);
 return newElem;
}
ASPx.RemoveOuterTags = function(element) {
 if(ASPx.Browser.IE) {
  element.insertAdjacentHTML( 'beforeBegin', element.innerHTML ) ;
  ASPx.RemoveElement(element);
 } else {
  var docFragment = element.ownerDocument.createDocumentFragment();
  for(var i = 0; i < element.childNodes.length; i++)
   docFragment.appendChild(element.childNodes[i].cloneNode(true));
  element.parentNode.replaceChild(docFragment, element);
 }
}
ASPx.WrapElementInNewElement = function(element, newElementTagName) { 
 var wrapElement = null;
 if(Browser.IE) {
  var wrapElement = element.ownerDocument.createElement(newElementTagName);
  wrapElement.appendChild(element.cloneNode(true));
  element.parentNode.insertBefore(wrapElement, element);
  element.parentNode.removeChild(element);
 } else {
  var docFragment = element.ownerDocument.createDocumentFragment();
  wrapElement = element.ownerDocument.createElement(newElementTagName);
  docFragment.appendChild(wrapElement);
  wrapElement.appendChild(element.cloneNode(true));
  element.parentNode.replaceChild(docFragment, element);
 }
 return wrapElement;
}
ASPx.InsertElementAfter = function(newElement, targetElement) {
 var parentElem = targetElement.parentNode;
 if(parentElem.childNodes[parentElem.childNodes.length - 1] == targetElement)
  parentElem.appendChild(newElement);
 else
  parentElem.insertBefore(newElement, targetElement.nextSibling);
}
ASPx.SetElementOpacity = function(element, value) {
  var useOpacityStyle = !Browser.IE || Browser.Version > 8;
  if(useOpacityStyle){
   element.style.opacity = value;
  } else {
   if(typeof(element.filters) === "object" && element.filters["DXImageTransform.Microsoft.Alpha"])
    element.filters.item("DXImageTransform.Microsoft.Alpha").Opacity = value*100;
   else
   element.style.filter = "alpha(opacity=" + (value * 100) + ")";
  }
}
ASPx.GetElementOpacity = function(element) {
 var useOpacityStyle = !Browser.IE || Browser.Version > 8;
 if(useOpacityStyle)
  return parseFloat(ASPx.GetCurrentStyle(element).opacity);
 else {
  if(typeof(element.filters) === "object" && element.filters["DXImageTransform.Microsoft.Alpha"]){
   return element.filters.item("DXImageTransform.Microsoft.Alpha").Opacity / 100;
  } else {
   var alphaValue = ASPx.GetCurrentStyle(element).filter;
   var value = alphaValue.replace("alpha(opacity=", "");
   value = value.replace(")", "");
   return parseInt(value) / 100;
  }
  return 100;
 }
}
ASPx.GetElementDisplay = function(element, isCurrentStyle) {
 if (isCurrentStyle)
  return ASPx.GetCurrentStyle(element).display != "none";
 return element.style.display != "none";
}
ASPx.SetElementDisplay = function(element, value) {
 if(!element) return;
 element.style.display = value ? "" : "none";
}
ASPx.GetElementVisibility = function(element, isCurrentStyle) {
 if(isCurrentStyle)
  return ASPx.GetCurrentStyle(element).visibility != "hidden";
 return element.style.visibility != "hidden";
}
ASPx.SetElementVisibility = function(element, value) {
 if(!element) return;
 element.style.visibility = value ? "visible" : "hidden";
}
ASPx.IsElementVisible = function(element, isCurrentStyle) {
 while(element && element.tagName != "BODY") {
  if(!ASPx.GetElementDisplay(element, isCurrentStyle) || (!ASPx.GetElementVisibility(element, isCurrentStyle) && !Attr.IsExistsAttribute(element, "errorFrame")))
     return false;
  element = element.parentNode;
 }
 return true;
}
ASPx.IsElementDisplayed = function(element) {
 while(element && element.tagName != "BODY") {
  if(!ASPx.GetElementDisplay(element))
     return false;
  element = element.parentNode;
 }
 return true;
}
ASPx.AddStyleSheetLinkToDocument = function(doc, linkUrl) {
 var newLink = createStyleLink(doc, linkUrl);
 var head = ASPx.GetHeadElementOrCreateIfNotExist(doc);
 head.appendChild(newLink);
}
ASPx.GetHeadElementOrCreateIfNotExist = function(doc) {
 var elements = ASPx.GetNodesByTagName(doc, "head");
 var head = null;
 if(elements.length == 0) {
  head = doc.createElement("head");
  head.visibility = "hidden";
  doc.insertBefore(head, doc.body);
 } else
  head = elements[0];
 return head;
}
function createStyleLink(doc, url) {
 var newLink = doc.createElement("link");
 Attr.SetAttribute(newLink, "href", url);
 Attr.SetAttribute(newLink, "type", "text/css");
 Attr.SetAttribute(newLink, "rel", "stylesheet");
 return newLink;
}
ASPx.GetCurrentStyle = function(element) {
 if(element.currentStyle)
  return element.currentStyle;
 else if(document.defaultView && document.defaultView.getComputedStyle) { 
  var result = document.defaultView.getComputedStyle(element, null);
  if(!result && Browser.Firefox && window.frameElement) {
   var changes = [];
   var curElement = window.frameElement;
   while(!(result = document.defaultView.getComputedStyle(element, null))) {
    changes.push([curElement, curElement.style.display]);
    ASPx.SetStylesCore(curElement, "display", "block", true);
    curElement = curElement.tagName == "BODY" ? curElement.ownerDocument.defaultView.frameElement : curElement.parentNode;
   }
   result = ASPx.CloneObject(result);
   for(var ch, i = 0; ch = changes[i]; i++)
    ASPx.SetStylesCore(ch[0], "display", ch[1]);
   var reflow = document.body.offsetWidth; 
  }
  return result;
 }
 return window.getComputedStyle(element, null);
}
ASPx.CreateStyleSheetInDocument = function(doc) {
 if(doc.createStyleSheet) {
  try {
   return doc.createStyleSheet();
  }
  catch(e) {
   var message = "The CSS link limit (31) has been exceeded. Please enable CSS merging or reduce the number of CSS files on the page. For details, see http://www.devexpress.com/Support/Center/p/K18487.aspx.";
   throw new Error(message);
  }
 }
 else {
  var styleSheet = doc.createElement("STYLE");
  ASPx.GetNodeByTagName(doc, "HEAD", 0).appendChild(styleSheet);
  return styleSheet.sheet;
 }
}
ASPx.currentStyleSheet = null;
ASPx.GetCurrentStyleSheet = function() {
 if(!ASPx.currentStyleSheet)
  ASPx.currentStyleSheet = ASPx.CreateStyleSheetInDocument(document);
 return ASPx.currentStyleSheet;
}
function getStyleSheetRules(styleSheet){
 try {
  return Browser.IE && Browser.Version == 8 ? styleSheet.rules : styleSheet.cssRules;
 }
 catch(e) {
  return null;
 }
}
ASPx.cachedCssRules = { };
ASPx.GetStyleSheetRules = function (className, stylesStorageDocument) {
 var doc = stylesStorageDocument || document;
 if(ASPx.cachedCssRules[className]) {
  if(ASPx.cachedCssRules[className] != ASPx.EmptyObject)
   return ASPx.cachedCssRules[className];
  return null;
 }
 for(var i = 0; i < doc.styleSheets.length; i ++){
  var styleSheet = doc.styleSheets[i];
  var rules = getStyleSheetRules(styleSheet);
  if(rules != null){
   for(var j = 0; j < rules.length; j ++){
    if(rules[j].selectorText == "." + className){
     ASPx.cachedCssRules[className] = rules[j];
     return rules[j];
    }
   }
  }
 }
 ASPx.cachedCssRules[className] = ASPx.EmptyObject;
 return null;
}
ASPx.ClearCachedCssRules = function(){
 ASPx.cachedCssRules = { };
}
var styleCount = 0;
var styleNameCache = { };
ASPx.CreateImportantStyleRule = function(styleSheet, cssText, postfix, prefix) {
 styleSheet = styleSheet || ASPx.GetCurrentStyleSheet();
 var cacheKey = (postfix ? postfix + "||" : "") + cssText + (prefix ? "||" + prefix : "");
 if(styleNameCache[cacheKey])
  return styleNameCache[cacheKey];
 prefix = prefix ? prefix + " " : "";
 var className = "dxh" + styleCount + (postfix ? postfix : "");
 ASPx.AddStyleSheetRule(styleSheet, prefix + "." + className, ASPx.CreateImportantCssText(cssText));
 styleCount++;
 styleNameCache[cacheKey] = className;
 return className; 
}
ASPx.CreateImportantCssText = function(cssText) {
 var newText = "";
 var attributes = cssText.split(";");
 for(var i = 0; i < attributes.length; i++){
  if(attributes[i] != "")
   newText += attributes[i] + " !important;";
 }
 return newText;
}
ASPx.AddStyleSheetRule = function(styleSheet, selector, cssText){
 if(!cssText) return;
 if(Browser.IE)
  styleSheet.addRule(selector, cssText);
 else
  styleSheet.insertRule(selector + " { " + cssText + " }", styleSheet.cssRules.length);
}
ASPx.GetPointerCursor = function() {
 return "pointer";
}
ASPx.SetPointerCursor = function(element) {
 if(element.style.cursor == "")
  element.style.cursor = ASPx.GetPointerCursor();
}
ASPx.SetElementFloat = function(element, value) {
 if(ASPx.IsExists(element.style.cssFloat))
  element.style.cssFloat = value;
 else if(ASPx.IsExists(element.style.styleFloat))
  element.style.styleFloat = value;
 else
  Attr.SetAttribute(element.style, "float", value);
}
ASPx.GetElementFloat = function(element) {
 var currentStyle = ASPx.GetCurrentStyle(element);
 if(ASPx.IsExists(currentStyle.cssFloat))
  return currentStyle.cssFloat;
 if(ASPx.IsExists(currentStyle.styleFloat))
  return currentStyle.styleFloat;
 return Attr.GetAttribute(currentStyle, "float");
}
function getElementDirection(element) {
 return ASPx.GetCurrentStyle(element).direction;
}
ASPx.IsElementRightToLeft = function(element) {
 return getElementDirection(element) == "rtl";
}
ASPx.AdjustVerticalMarginsInContainer = function(container) {
 var containerBorderAndPaddings = ASPx.GetTopBottomBordersAndPaddingsSummaryValue(container);
 var flowElements = [], floatElements = [], floatTextElements = [];
 var maxHeight = 0, maxFlowHeight = 0;
 for(var i = 0; i < container.childNodes.length; i++) {
  var element = container.childNodes[i];
  if(!element.offsetHeight) continue;
  ASPx.ClearVerticalMargins(element);
 }
 for(var i = 0; i < container.childNodes.length; i++) {
  var element = container.childNodes[i];
  if(!element.offsetHeight) continue;
  var float = ASPx.GetElementFloat(element);
  var isFloat = (float === "left" || float === "right");
  if(isFloat)
   floatElements.push(element)
  else {
   flowElements.push(element);
   if(element.tagName !== "IMG"){
    if(!ASPx.IsTextWrapped(element))
     element.style.verticalAlign = 'baseline'; 
    floatTextElements.push(element);
   }
   if(element.tagName === "DIV")
    Attr.ChangeStyleAttribute(element, "float", "left"); 
  }
  if(element.offsetHeight > maxHeight) 
   maxHeight = element.offsetHeight;
  if(!isFloat && element.offsetHeight > maxFlowHeight) 
   maxFlowHeight = element.offsetHeight;
 }
 for(var i = 0; i < flowElements.length; i++) 
  Attr.RestoreStyleAttribute(flowElements[i], "float");
 var containerBorderAndPaddings = ASPx.GetTopBottomBordersAndPaddingsSummaryValue(container);
 var containerHeight = container.offsetHeight - containerBorderAndPaddings;
 if(maxHeight == containerHeight) {
  var verticalAlign = ASPx.GetCurrentStyle(container).verticalAlign;
  for(var i = 0; i < floatTextElements.length; i++)
   floatTextElements[i].style.verticalAlign = '';
  containerHeight = container.offsetHeight - containerBorderAndPaddings;
  for(var i = 0; i < floatElements.length; i++)
   adjustVerticalMarginsCore(floatElements[i], containerHeight, verticalAlign, true);
  for(var i = 0; i < flowElements.length; i++) {
   if(maxFlowHeight != maxHeight)
    adjustVerticalMarginsCore(flowElements[i], containerHeight, verticalAlign);
  }
 }
}
ASPx.AdjustVerticalMargins = function(element) {
 ASPx.ClearVerticalMargins(element);
 var parentElement = element.parentNode;
 var parentHeight = parentElement.offsetHeight - ASPx.GetTopBottomBordersAndPaddingsSummaryValue(parentElement);
 adjustVerticalMarginsCore(element, parentHeight, ASPx.GetCurrentStyle(parentElement).verticalAlign);
}
function adjustVerticalMarginsCore(element, parentHeight, verticalAlign, toBottom) {
 var marginTop;
 if(verticalAlign == "top")
  marginTop = 0;
 else if(verticalAlign == "bottom")
  marginTop = parentHeight - element.offsetHeight;
 else
  marginTop = (parentHeight - element.offsetHeight) / 2;
 if(marginTop !== 0){
  var marginAttr = (toBottom ? Math.ceil(marginTop) : Math.floor(marginTop)) + "px"
  element.style.marginTop = marginAttr;
 }
}
ASPx.ClearVerticalMargins = function(element) {
 element.style.marginTop = "";
 element.style.marginBottom = "";
}
ASPx.AdjustHeightInContainer = function(container) {
 var height = container.offsetHeight - ASPx.GetTopBottomBordersAndPaddingsSummaryValue(container);
 for(var i = 0; i < container.childNodes.length; i++) {
  var element = container.childNodes[i];
  if(!element.offsetHeight) continue;
  ASPx.ClearHeight(element);
 }
 var elements = [];
 var childrenHeight = 0;
 for(var i = 0; i < container.childNodes.length; i++) {
  var element = container.childNodes[i];
  if(!element.offsetHeight) continue;
  childrenHeight += element.offsetHeight + ASPx.GetTopBottomMargins(element);
  elements.push(element);
 }
 if(elements.length > 0 && childrenHeight < height) {
  var correctedHeight = 0;
  for(var i = 0; i < elements.length; i++) {
   var elementHeight = 0;
   if(i < elements.length - 1){
    var elementHeight = Math.floor(height / elements.length);
    correctedHeight += elementHeight;
   }
   else{
    var elementHeight = height - correctedHeight;
    if(elementHeight < 0) elementHeight = 0;
   }
   adjustHeightCore(elements[i], elementHeight);
  }
 }
}
ASPx.AdjustHeight = function(element) {
 ASPx.ClearHeight(element);
 var parentElement = element.parentNode;
 var height = parentElement.offsetHeight - ASPx.GetTopBottomBordersAndPaddingsSummaryValue(parentElement);
 adjustHeightCore(element, height);
}
function adjustHeightCore(element, height) {
 var height = height - ASPx.GetTopBottomBordersAndPaddingsSummaryValue(element);
 if(height < 0) height = 0;
 element.style.height = height + "px";
}
ASPx.ClearHeight = function(element) {
 element.style.height = "";
}
ASPx.ShrinkWrappedTextInContainer = function(container) {
 if(!container) return;
 for(var i = 0; i < container.childNodes.length; i++){
  var child = container.childNodes[i];
  if(child.style && ASPx.IsTextWrapped(child)) {
   Attr.ChangeStyleAttribute(child, "width", "1px");
   child.shrinkedTextContainer = true;
  }
 }
}
ASPx.AdjustWrappedTextInContainer = function(container) {
 if(!container) return;
 var textContainer, leftWidth = 0, rightWidth = 0;
 for(var i = 0; i < container.childNodes.length; i++){
  var child = container.childNodes[i];
  if(child.tagName === "BR")
   return;
  if(!child.tagName)
   continue;
  if(child.tagName !== "IMG"){
   textContainer = child;
   if(ASPx.IsTextWrapped(textContainer)){
    if(!textContainer.shrinkedTextContainer)
     textContainer.style.width = "";
    textContainer.style.marginRight = "";
   }
  }
  else {
   if(child.offsetWidth === 0){
    Evt.AttachEventToElement(child, "load", function (evt) {
     ASPx.AdjustWrappedTextInContainer(container);
    });
    return;
   }
   var width = child.offsetWidth + ASPx.GetLeftRightMargins(child);
   if(textContainer)
    rightWidth += width;
   else
    leftWidth += width;
  }
 }
 if(textContainer && ASPx.IsTextWrapped(textContainer)) {
  var containerWidth = container.offsetWidth - ASPx.GetLeftRightBordersAndPaddingsSummaryValue(container);
  if(textContainer.shrinkedTextContainer) {
   Attr.RestoreStyleAttribute(textContainer, "width");
   Attr.ChangeStyleAttribute(container, "width", containerWidth + "px");
  }
  if(textContainer.offsetWidth + leftWidth + rightWidth >= containerWidth) {
    if(rightWidth > 0 && !textContainer.shrinkedTextContainer)
    textContainer.style.width = (containerWidth - rightWidth) + "px";
   else if(leftWidth > 0){
    if(ASPx.IsElementRightToLeft(container))
     textContainer.style.marginLeft = leftWidth + "px";
    else
     textContainer.style.marginRight = leftWidth + "px";
   }
  }
 }
}
ASPx.IsTextWrapped = function(element) {
 return element && ASPx.GetCurrentStyle(element).whiteSpace !== "nowrap";
}
ASPx.IsValidPosition = function(pos){
 return pos != ASPx.InvalidPosition && pos != -ASPx.InvalidPosition;
}
ASPx.getSpriteMainElement = function(element) {
 var cssClassMarker = "dx-acc";
 if(ASPx.ElementContainsCssClass(element, cssClassMarker))
  return element;
 if(element.parentNode && ASPx.ElementContainsCssClass(element.parentNode, cssClassMarker))
  return element.parentNode;
 return element;
}
ASPx.GetAbsoluteX = function(curEl){
 return ASPx.GetAbsolutePositionX(curEl);
}
ASPx.GetAbsoluteY = function(curEl){
 return ASPx.GetAbsolutePositionY(curEl);
}
ASPx.SetAbsoluteX = function(element, x){
 element.style.left = ASPx.PrepareClientPosForElement(x, element, true) + "px";
}
ASPx.SetAbsoluteY = function(element, y){
 element.style.top = ASPx.PrepareClientPosForElement(y, element, false) + "px";
}
ASPx.GetAbsolutePositionX = function(element){
 if(Browser.IE)
  return getAbsolutePositionX_IE(element);
 else if(Browser.Firefox && Browser.Version >= 3)
  return getAbsolutePositionX_FF3(element);
 else if(Browser.Opera)
  return getAbsolutePositionX_Opera(element);
 else if(Browser.NetscapeFamily && (!Browser.Firefox || Browser.Version < 3))
  return getAbsolutePositionX_NS(element);
 else if(Browser.WebKitFamily || Browser.Edge)
  return getAbsolutePositionX_FF3(element);
 else
  return getAbsolutePositionX_Other(element);
}
function getAbsolutePositionX_Opera(curEl){
 var isFirstCycle = true;
 var pos = getAbsoluteScrollOffset_OperaFF(curEl, true);
 while(curEl != null) {
  pos += curEl.offsetLeft;
  if(!isFirstCycle)
   pos -= curEl.scrollLeft;
  curEl = curEl.offsetParent;
  isFirstCycle = false;
 }
 pos += document.body.scrollLeft;
 return pos;
}
function getAbsolutePositionX_IE(element){
 if(element == null || Browser.IE && element.parentNode == null) return 0; 
 return element.getBoundingClientRect().left + ASPx.GetDocumentScrollLeft();
}
function getAbsolutePositionX_FF3(element){
 if(element == null) return 0;
 var x = element.getBoundingClientRect().left + ASPx.GetDocumentScrollLeft();
 return Math.round(x);
}
function getAbsolutePositionX_NS(curEl){
 var pos = getAbsoluteScrollOffset_OperaFF(curEl, true);
 var isFirstCycle = true;
 while(curEl != null) {
  pos += curEl.offsetLeft;
  if(!isFirstCycle && curEl.offsetParent != null)
   pos -= curEl.scrollLeft;
  if(!isFirstCycle && Browser.Firefox){
   var style = ASPx.GetCurrentStyle(curEl);
   if(curEl.tagName == "DIV" && style.overflow != "visible")
    pos += ASPx.PxToInt(style.borderLeftWidth);
  }
  isFirstCycle = false;
  curEl = curEl.offsetParent;
 }
 return pos;
}
function getAbsolutePositionX_Safari(curEl){
 var pos = getAbsoluteScrollOffset_WebKit(curEl, true);
 var isSafariVerNonLessThan3OrChrome = Browser.Safari && Browser.Version >= 3 || Browser.Chrome;
 if(curEl != null){
  var isFirstCycle = true;
  if(isSafariVerNonLessThan3OrChrome && curEl.tagName == "TD") {
   pos += curEl.offsetLeft;
   curEl = curEl.offsetParent;
   isFirstCycle = false;
  }
  var hasNonStaticElement = false;
  while (curEl != null) {
   pos += curEl.offsetLeft;
   var style = ASPx.GetCurrentStyle(curEl);
   var isNonStatic = style.position !== "" && style.position !== "static";
   if(isNonStatic)
    hasNonStaticElement = true;
   var safariDisplayTable = Browser.Safari && Browser.Version >= 8 && style.display === "table";
   var posDiv = curEl.tagName == "DIV" && isNonStatic && !safariDisplayTable;
   if(!isFirstCycle && (curEl.tagName == "TD" || curEl.tagName == "TABLE" || posDiv))
    pos += curEl.clientLeft;
   isFirstCycle = false;
   curEl = curEl.offsetParent;
  }
  if(!hasNonStaticElement && (document.documentElement.style.position === "" || document.documentElement.style.position === "static"))
   pos += document.documentElement.offsetLeft;
 }
 return pos;
}
function getAbsolutePositionX_Other(curEl){
 var pos = 0;
 var isFirstCycle = true;
 while(curEl != null) {
  pos += curEl.offsetLeft;
  if(!isFirstCycle && curEl.offsetParent != null)
   pos -= curEl.scrollLeft;
  isFirstCycle = false;
  curEl = curEl.offsetParent;
 }
 return pos;
}
ASPx.GetAbsolutePositionY = function(element){
 if(Browser.IE)
  return getAbsolutePositionY_IE(element);
 else if(Browser.Firefox && Browser.Version >= 3)
  return getAbsolutePositionY_FF3(element);
 else if(Browser.Opera)
  return getAbsolutePositionY_Opera(element);
 else if(Browser.NetscapeFamily && (!Browser.Firefox || Browser.Version < 3))
  return getAbsolutePositionY_NS(element);
 else if(Browser.WebKitFamily || Browser.Edge)
  return getAbsolutePositionY_FF3(element);
 else
  return getAbsolutePositionY_Other(element);
}
function getAbsolutePositionY_Opera(curEl){
 var isFirstCycle = true;
 if(curEl && curEl.tagName == "TR" && curEl.cells.length > 0)
  curEl = curEl.cells[0];
 var pos = getAbsoluteScrollOffset_OperaFF(curEl, false);
 while(curEl != null) {
  pos += curEl.offsetTop;
  if(!isFirstCycle)
   pos -= curEl.scrollTop;
  curEl = curEl.offsetParent;
  isFirstCycle = false;
 }
 pos += document.body.scrollTop;
 return pos;
}
function getAbsolutePositionY_IE(element){
 if(element == null || Browser.IE && element.parentNode == null) return 0; 
 return element.getBoundingClientRect().top + ASPx.GetDocumentScrollTop();
}
function getAbsolutePositionY_FF3(element){
 if(element == null) return 0;
 var y = element.getBoundingClientRect().top + ASPx.GetDocumentScrollTop();
 return Math.round(y);
}
function getAbsolutePositionY_NS(curEl){
 var pos = getAbsoluteScrollOffset_OperaFF(curEl, false);
 var isFirstCycle = true;
 while(curEl != null) {
  pos += curEl.offsetTop;
  if(!isFirstCycle && curEl.offsetParent != null)
   pos -= curEl.scrollTop;
  if(!isFirstCycle && Browser.Firefox){
   var style = ASPx.GetCurrentStyle(curEl);
   if(curEl.tagName == "DIV" && style.overflow != "visible")
    pos += ASPx.PxToInt(style.borderTopWidth);
  }
  isFirstCycle = false;
  curEl = curEl.offsetParent;
 }
 return pos;
}
var WebKit3TDRealInfo = {
 GetOffsetTop: function(tdElement){
  switch(ASPx.GetCurrentStyle(tdElement).verticalAlign){
   case "middle":
    return Math.round(tdElement.offsetTop - (tdElement.offsetHeight - tdElement.clientHeight )/2 + tdElement.clientTop);
   case "bottom":
    return tdElement.offsetTop - tdElement.offsetHeight + tdElement.clientHeight + tdElement.clientTop;
  }
  return tdElement.offsetTop;
 },
 GetClientHeight: function(tdElement){
  var valign = ASPx.GetCurrentStyle(tdElement).verticalAlign;
  switch(valign){
   case "middle":
    return tdElement.clientHeight + tdElement.offsetTop * 2;
   case "top":
    return tdElement.offsetHeight - tdElement.clientTop * 2;
   case "bottom":
    return tdElement.clientHeight + tdElement.offsetTop;
  }
  return tdElement.clientHeight;
 }
}
function getAbsolutePositionY_Safari(curEl){
 var pos = getAbsoluteScrollOffset_WebKit(curEl, false);
 var isSafariVerNonLessThan3OrChrome = Browser.Safari && Browser.Version >= 3 || Browser.Chrome;
 if(curEl != null){
  var isFirstCycle = true;
  if(isSafariVerNonLessThan3OrChrome && curEl.tagName == "TD") {
   pos += WebKit3TDRealInfo.GetOffsetTop(curEl);
   curEl = curEl.offsetParent;
   isFirstCycle = false;
  }
  var hasNonStaticElement = false;
  while (curEl != null) {
   pos += curEl.offsetTop;
   var style = ASPx.GetCurrentStyle(curEl);
   var isNonStatic = style.position !== "" && style.position !== "static";
   if(isNonStatic)
    hasNonStaticElement = true;
   var safariDisplayTable = Browser.Safari && Browser.Version >= 8 && style.display === "table";
   var posDiv = curEl.tagName == "DIV" && isNonStatic && !safariDisplayTable;
   if(!isFirstCycle && (curEl.tagName == "TD" || curEl.tagName == "TABLE" || posDiv))
    pos += curEl.clientTop;
   isFirstCycle = false;
   curEl = curEl.offsetParent;
  }
  if(!hasNonStaticElement && (document.documentElement.style.position === "" || document.documentElement.style.position === "static"))
   pos += document.documentElement.offsetTop;
 }
 return pos;
}
function getAbsoluteScrollOffset_OperaFF(curEl, isX) {
 var pos = 0;   
 var isFirstCycle = true;
 while(curEl != null) {
  if(curEl.tagName == "BODY")
   break;
  var style = ASPx.GetCurrentStyle(curEl);
  if(style.position == "absolute")
   break;
  if(!isFirstCycle && curEl.tagName == "DIV" && (style.position == "" || style.position == "static"))
   pos -= isX ? curEl.scrollLeft : curEl.scrollTop;
  curEl = curEl.parentNode;
  isFirstCycle = false;
 }
 return pos; 
}
function getAbsoluteScrollOffset_WebKit(curEl, isX) {
 var pos = 0;   
 var isFirstCycle = true;
 var step = 0;
 var absoluteWasFoundAtStep = -1;
 var isThereFixedParent = false;
 while(curEl != null) {
  if(curEl.tagName == "BODY")
   break;
  var style = ASPx.GetCurrentStyle(curEl);
  var positionIsDefault = style.position == "" || style.position == "static";
  var absoluteWasFoundAtPreviousStep = absoluteWasFoundAtStep >= 0 && absoluteWasFoundAtStep < step;
  var canHaveScrolls = curEl.tagName == "DIV" || curEl.tagName == "SECTION" || curEl.tagName == "FORM";
  if(!isFirstCycle && canHaveScrolls && (!positionIsDefault || !absoluteWasFoundAtPreviousStep))
   pos -= isX ? curEl.scrollLeft : curEl.scrollTop;
  if(style.position == "absolute")
   absoluteWasFoundAtStep = step;
  else if(style.position == "relative")
   absoluteWasFoundAtStep = -1;
  else if(style.position == "fixed")
   isThereFixedParent = true;
  curEl = curEl.parentNode;
  isFirstCycle = false;
  step ++;
 }
 if(isThereFixedParent)
  pos += isX ? ASPx.GetDocumentScrollLeft() : ASPx.GetDocumentScrollTop();
 return pos; 
}
function getAbsolutePositionY_Other(curEl){
 var pos = 0;
 var isFirstCycle = true;
 while(curEl != null) {
  pos += curEl.offsetTop;
  if(!isFirstCycle && curEl.offsetParent != null)
   pos -= curEl.scrollTop;
  isFirstCycle = false;
  curEl = curEl.offsetParent;
 }
 return pos;
}
function createElementMock(element) {
 var div = document.createElement('DIV');
 div.style.top = "0px";
 div.style.left = "0px";
 div.visibility = "hidden";
 div.style.position = ASPx.GetCurrentStyle(element).position;
 return div;
}
ASPx.PrepareClientPosElementForOtherParent = function(pos, element, otherParent, isX) {
 if(element.parentNode == otherParent)
  return ASPx.PrepareClientPosForElement(pos, element, isX);
 var elementMock = createElementMock(element);
 otherParent.appendChild(elementMock); 
 var preparedPos = ASPx.PrepareClientPosForElement(pos, elementMock, isX);
 otherParent.removeChild(elementMock);
 return preparedPos;
}
ASPx.PrepareClientPosForElement = function(pos, element, isX) {
 pos -= ASPx.GetPositionElementOffset(element, isX);
 return pos;
}
function getExperimentalPositionOffset(element, isX) {
 var div = createElementMock(element);
 if(div.style.position == "static")
  div.style.position = "absolute";
 element.parentNode.appendChild(div); 
 var realPos = isX ? ASPx.GetAbsoluteX(div) : ASPx.GetAbsoluteY(div);
 element.parentNode.removeChild(div);
 return Math.round(realPos);
}
ASPx.GetPositionElementOffset = function(element, isX) {
 return getExperimentalPositionOffset(element, isX);
}
function getPositionElementOffsetCore(element, isX) {
 var curEl = element.offsetParent;
 var offset = 0;
 var scroll = 0;
 var isThereFixedParent = false;
 var isFixed = false;
 var hasDisplayTableParent = false;
 var position = "";
 while(curEl != null) {
  var tagName = curEl.tagName;
  if(tagName == "HTML"){
   break;
  }
  if(tagName == "BODY"){
   if(!Browser.Opera && !Browser.Chrome && !Browser.Edge){
    var style = ASPx.GetCurrentStyle(curEl);
    if(style.position != "" && style.position != "static"){
     offset += ASPx.PxToInt(isX ? style.left : style.top);
     offset += ASPx.PxToInt(isX ? style.marginLeft : style.marginTop);
    }
   }
   break;
  }
  var style = ASPx.GetCurrentStyle(curEl);
  isFixed = style.position == "fixed";
  if(isFixed) {
   isThereFixedParent = true;
   if(Browser.IE) 
    return getExperimentalPositionOffset(element, isX); 
  }
  hasDisplayTableParent = style.display == "table" && (style.position == "absolute" || style.position == "relative");
  if(hasDisplayTableParent && Browser.IE)
   return getExperimentalPositionOffset(element, isX);
  if(style.position == "absolute" || isFixed || style.position == "relative") {
   offset += isX ? curEl.offsetLeft : curEl.offsetTop;
   offset += ASPx.PxToInt(isX ? style.borderLeftWidth : style.borderTopWidth);
  }
  if(style.position == "relative") 
   scroll += getElementChainScroll(curEl, curEl.offsetParent, isX);
  scroll += isX ? curEl.scrollLeft : curEl.scrollTop;
  curEl = curEl.offsetParent;
 }
 offset -= scroll; 
 if((Browser.IE || Browser.Firefox && Browser.Version >= 3 || Browser.WebKitFamily || Browser.Edge) && isThereFixedParent)
  offset += isX ? ASPx.GetDocumentScrollLeft() : ASPx.GetDocumentScrollTop();
 return offset;
}
function getElementChainScroll(startElement, endElement, isX){
 var curEl = startElement.parentNode;
 var scroll = 0;
 while(curEl != endElement){
  scroll += isX ? curEl.scrollLeft : curEl.scrollTop;
  curEl = curEl.parentNode;
 }
 return scroll;
}
ASPx.GetSizeOfText = function(text, textCss) {
 var testContainer = document.createElement("tester");
 var defaultLineHeight = ASPx.Browser.Firefox ? "1" : "";
 testContainer.style.fontSize = textCss.fontSize;
 testContainer.style.fontFamily = textCss.fontFamily;
 testContainer.style.fontWeight = textCss.fontWeight;
 testContainer.style.letterSpacing = textCss.letterSpacing;
 testContainer.style.lineHeight = textCss.lineHeight || defaultLineHeight;
 testContainer.style.position = "absolute";
 testContainer.style.top = ASPx.InvalidPosition + "px";
 testContainer.style.left = ASPx.InvalidPosition + "px";
 testContainer.style.width = "auto";
 testContainer.style.whiteSpace = "nowrap";
 testContainer.appendChild(document.createTextNode(text));
 var testElement = document.body.appendChild(testContainer);
 var size = {
  "width": testElement.offsetWidth,
  "height": testElement.offsetHeight
 };
 document.body.removeChild(testElement);
 return size;
}
ASPx.PointToPixel = function(points, addPx) {  
 var result = 0;
 try {
  var indexOfPt = points.toLowerCase().indexOf("pt");
  if(indexOfPt > -1)
   result = parseInt(points.substr(0, indexOfPt)) * 96 / 72;
  else
   result = parseInt(points) * 96 / 72;
  if(addPx)
   result = result + "px";
 } catch(e) {}
 return result;
}
ASPx.PixelToPoint = function(pixels, addPt) { 
 var result = 0;
 try {
  var indexOfPx = pixels.toLowerCase().indexOf("px");
  if(indexOfPx > -1)
   result = parseInt(pixels.substr(0, indexOfPx)) * 72 / 96;
  else
   result = parseInt(pixels) * 72 / 96;
  if(addPt)
   result = result + "pt";
 } catch(e) {}
 return result;         
}
ASPx.PxToInt = function(px) {
 return pxToNumber(px, parseInt);
}
ASPx.PxToFloat = function(px) {
 return pxToNumber(px, parseFloat);
}
function pxToNumber(px, parseFunction) {
 var result = 0;
 if(px != null && px != "") {
  try {
   var indexOfPx = px.indexOf("px");
   if(indexOfPx > -1)
    result = parseFunction(px.substr(0, indexOfPx));
  } catch(e) { }
 }
 return result;
}
ASPx.PercentageToFloat = function(perc) {
 var result = 0;
 if(perc != null && perc != "") {
  try {
   var indexOfPerc = perc.indexOf("%");
   if(indexOfPerc > -1)
    result = parseFloat(perc.substr(0, indexOfPerc)) / 100;
  } catch(e) { }
 }
 return result;
}
ASPx.CreateGuid = function() {
 return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) { 
   var r = Math.random()*16|0,v=c=='x'?r:r&0x3|0x8;
  return v.toString(16);
 });
}
ASPx.GetLeftRightBordersAndPaddingsSummaryValue = function(element, currentStyle) {
 return ASPx.GetLeftRightPaddings(element, currentStyle) + ASPx.GetHorizontalBordersWidth(element, currentStyle);
}
ASPx.GetTopBottomBordersAndPaddingsSummaryValue = function(element, currentStyle) {
 return ASPx.GetTopBottomPaddings(element, currentStyle) + ASPx.GetVerticalBordersWidth(element, currentStyle);
}
ASPx.GetVerticalBordersWidth = function(element, style) {
 if(!ASPx.IsExists(style))
  style = (Browser.IE && Browser.MajorVersion != 9 && window.getComputedStyle) ? window.getComputedStyle(element) : ASPx.GetCurrentStyle(element);
 var res = 0;
 if(style.borderTopStyle != "none") {
  res += ASPx.PxToFloat(style.borderTopWidth);
  if(Browser.IE && Browser.MajorVersion < 9)
   res += getIe8BorderWidthFromText(style.borderTopWidth);
 }
 if(style.borderBottomStyle != "none") {
  res += ASPx.PxToFloat(style.borderBottomWidth);
  if(Browser.IE && Browser.MajorVersion < 9)
   res += getIe8BorderWidthFromText(style.borderBottomWidth);
 }
 return res;
}
ASPx.GetHorizontalBordersWidth = function(element, style) {
 if(!ASPx.IsExists(style))
  style = (Browser.IE && window.getComputedStyle) ? window.getComputedStyle(element) : ASPx.GetCurrentStyle(element);
 var res = 0;
 if(style.borderLeftStyle != "none") {
  res += ASPx.PxToFloat(style.borderLeftWidth);
  if(Browser.IE && Browser.MajorVersion < 9)
   res += getIe8BorderWidthFromText(style.borderLeftWidth);
 }
 if(style.borderRightStyle != "none") {
  res += ASPx.PxToFloat(style.borderRightWidth);
  if(Browser.IE && Browser.MajorVersion < 9)
   res += getIe8BorderWidthFromText(style.borderRightWidth);
 }
 return res;
}
function getIe8BorderWidthFromText(textWidth) {
 var availableWidth = { "thin": 1, "medium" : 3, "thick": 5 };
 var width = availableWidth[textWidth];
 return width ? width : 0;
}
ASPx.GetTopBottomPaddings = function(element, style) {
 var currentStyle = style ? style : ASPx.GetCurrentStyle(element);
 return ASPx.PxToInt(currentStyle.paddingTop) + ASPx.PxToInt(currentStyle.paddingBottom);
}
ASPx.GetLeftRightPaddings = function(element, style) {
 var currentStyle = style ? style : ASPx.GetCurrentStyle(element);
 return ASPx.PxToInt(currentStyle.paddingLeft) + ASPx.PxToInt(currentStyle.paddingRight);
}
ASPx.GetTopBottomMargins = function(element, style) {
 var currentStyle = style ? style : ASPx.GetCurrentStyle(element);
 return ASPx.PxToInt(currentStyle.marginTop) + ASPx.PxToInt(currentStyle.marginBottom);
}
ASPx.GetLeftRightMargins = function(element, style) {
 var currentStyle = style ? style : ASPx.GetCurrentStyle(element);
 return ASPx.PxToInt(currentStyle.marginLeft) + ASPx.PxToInt(currentStyle.marginRight);
}
ASPx.GetClearClientWidth = function(element) {
 return element.offsetWidth - ASPx.GetLeftRightBordersAndPaddingsSummaryValue(element);
}
ASPx.GetClearClientHeight = function(element) {
 return element.offsetHeight - ASPx.GetTopBottomBordersAndPaddingsSummaryValue(element);
}
ASPx.SetOffsetWidth = function(element, widthValue, currentStyle) {
 if(!ASPx.IsExists(currentStyle))
  currentStyle = ASPx.GetCurrentStyle(element);
 var value = widthValue - ASPx.PxToInt(currentStyle.marginLeft) - ASPx.PxToInt(currentStyle.marginRight);
  value -= ASPx.GetLeftRightBordersAndPaddingsSummaryValue(element, currentStyle);
 if(value > -1)
  element.style.width = value + "px";
}
ASPx.SetOffsetHeight = function(element, heightValue, currentStyle) {
 if(!ASPx.IsExists(currentStyle))
  currentStyle = ASPx.GetCurrentStyle(element);
 var value = heightValue - ASPx.PxToInt(currentStyle.marginTop) - ASPx.PxToInt(currentStyle.marginBottom);
  value -= ASPx.GetTopBottomBordersAndPaddingsSummaryValue(element, currentStyle);
 if(value > -1)
  element.style.height = value + "px";
}
ASPx.FindOffsetParent = function(element) {
 var currentElement = element.parentNode;
 while(ASPx.IsExistsElement(currentElement) && currentElement.tagName != "BODY") {
  if(currentElement.offsetWidth > 0 && currentElement.offsetHeight > 0)
   return currentElement;
  currentElement = currentElement.parentNode;
 }
 return document.body;
}
ASPx.GetDocumentScrollTop = function(){
 var isScrollBodyIE = Browser.IE && ASPx.GetCurrentStyle(document.body).overflow == "hidden" && document.body.scrollTop > 0;
 if(Browser.WebKitFamily || Browser.Edge || isScrollBodyIE) {
  if(Browser.MacOSMobilePlatform) 
   return window.pageYOffset;
  else 
   return document.body.scrollTop;
 }
 else
  return document.documentElement.scrollTop;
}
ASPx.SetDocumentScrollTop = function(scrollTop) {
 if(Browser.WebKitFamily || Browser.Edge) {
  if(Browser.MacOSMobilePlatform) 
   window.pageYOffset = scrollTop;
  else 
   document.body.scrollTop = scrollTop;
 }
 else
  document.documentElement.scrollTop = scrollTop;
}
ASPx.GetDocumentScrollLeft = function(){
 var isScrollBodyIE = Browser.IE && ASPx.GetCurrentStyle(document.body).overflow == "hidden" && document.body.scrollLeft > 0;
 if(Browser.WebKitFamily || Browser.Edge || isScrollBodyIE)
  return document.body.scrollLeft;
 return document.documentElement.scrollLeft;
}
ASPx.SetDocumentScrollLeft = function(scrollLeft) {
 if(Browser.WebKitFamily || Browser.Edge) {
  if(Browser.MacOSMobilePlatform)
   window.pageXOffset = scrollLeft;
  else 
   document.body.scrollLeft = scrollLeft;
 }
 else
  document.documentElement.scrollLeft = scrollLeft;
}
ASPx.GetDocumentClientWidth = function(){
 if(document.documentElement.clientWidth == 0)
  return document.body.clientWidth;
 else
  return document.documentElement.clientWidth;
}
ASPx.GetDocumentClientHeight = function() {
 if(Browser.Firefox && window.innerHeight - document.documentElement.clientHeight > ASPx.GetVerticalScrollBarWidth()) {
  return window.innerHeight;
 } else if(Browser.Opera && Browser.Version < 9.6 || document.documentElement.clientHeight == 0) {
   return document.body.clientHeight
 }
 return document.documentElement.clientHeight;
}
ASPx.GetDocumentWidth = function(){
 var bodyWidth = document.body.offsetWidth;
 var docWidth = Browser.IE ? document.documentElement.clientWidth : document.documentElement.offsetWidth;
 var bodyScrollWidth = document.body.scrollWidth;
 var docScrollWidth = document.documentElement.scrollWidth;
 return getMaxDimensionOf(bodyWidth, docWidth, bodyScrollWidth, docScrollWidth);
}
ASPx.GetDocumentHeight = function(){
 var bodyHeight = document.body.offsetHeight;
 var docHeight = Browser.IE ? document.documentElement.clientHeight : document.documentElement.offsetHeight;
 var bodyScrollHeight = document.body.scrollHeight;
 var docScrollHeight = document.documentElement.scrollHeight;
 var maxHeight = getMaxDimensionOf(bodyHeight, docHeight, bodyScrollHeight, docScrollHeight);
 if(Browser.Opera && Browser.Version >= 9.6){
  if(Browser.Version < 10)
   maxHeight = getMaxDimensionOf(bodyHeight, docHeight, bodyScrollHeight);
  var visibleHeightOfDocument = document.documentElement.clientHeight;
  if(maxHeight > visibleHeightOfDocument)
   maxHeight = getMaxDimensionOf(window.outerHeight, maxHeight);
  else
   maxHeight = document.documentElement.clientHeight;
  return maxHeight;
 }
 return maxHeight;
}
ASPx.GetDocumentMaxClientWidth = function(){
 var bodyWidth = document.body.offsetWidth;
 var docWidth = document.documentElement.offsetWidth;
 var docClientWidth = document.documentElement.clientWidth;
 return getMaxDimensionOf(bodyWidth, docWidth, docClientWidth);
}
ASPx.GetDocumentMaxClientHeight = function(){
 var bodyHeight = document.body.offsetHeight;
 var docHeight = document.documentElement.offsetHeight;
 var docClientHeight = document.documentElement.clientHeight;
 return getMaxDimensionOf(bodyHeight, docHeight, docClientHeight);
}
ASPx.verticalScrollIsNotHidden = null;
ASPx.horizontalScrollIsNotHidden = null;
ASPx.GetVerticalScrollIsNotHidden = function() {
 if(!ASPx.IsExists(ASPx.verticalScrollIsNotHidden))
  ASPx.verticalScrollIsNotHidden = ASPx.GetCurrentStyle(document.body).overflowY !== "hidden"
   && ASPx.GetCurrentStyle(document.documentElement).overflowY !== "hidden";
 return ASPx.verticalScrollIsNotHidden;
}
ASPx.GetHorizontalScrollIsNotHidden = function() {
 if(!ASPx.IsExists(ASPx.horizontalScrollIsNotHidden))
  ASPx.horizontalScrollIsNotHidden = ASPx.GetCurrentStyle(document.body).overflowX !== "hidden"
   && ASPx.GetCurrentStyle(document.documentElement).overflowX !== "hidden";
 return ASPx.horizontalScrollIsNotHidden;
}
ASPx.GetCurrentDocumentWidth = function() {
 var result = ASPx.GetDocumentClientWidth();
 if(!ASPx.Browser.Safari && ASPx.GetVerticalScrollIsNotHidden() && ASPx.GetDocumentHeight() > ASPx.GetDocumentClientHeight())
  result += ASPx.GetVerticalScrollBarWidth();
 return result;
}
ASPx.GetCurrentDocumentHeight = function() {
 var result = ASPx.GetDocumentClientHeight();
 if(!ASPx.Browser.Safari && ASPx.GetHorizontalScrollIsNotHidden() && ASPx.GetDocumentWidth() > ASPx.GetDocumentClientWidth())
  result += ASPx.GetVerticalScrollBarWidth();
 return result;
}
function getMaxDimensionOf(){
 var max = ASPx.InvalidDimension;
 for(var i = 0; i < arguments.length; i++){
  if(max < arguments[i])
   max = arguments[i];
 }
 return max;
}
ASPx.GetClientLeft = function(element){
 return ASPx.IsExists(element.clientLeft) ? element.clientLeft : (element.offsetWidth - element.clientWidth) / 2;
}
ASPx.GetClientTop = function(element){
 return ASPx.IsExists(element.clientTop) ? element.clientTop : (element.offsetHeight - element.clientHeight) / 2;
}
ASPx.SetStyles = function(element, styles, makeImportant) {
 if(ASPx.IsExists(styles.cssText))
  element.style.cssText = styles.cssText;
 if(ASPx.IsExists(styles.className))
  element.className = styles.className;
 for(var property in styles) {
  if(!styles.hasOwnProperty(property))
   continue;
  var value = styles[property];
  switch (property) {
   case "cssText":
   case "className":
    break;
   case "float":
    ASPx.SetElementFloat(element, value);
    break;
   case "opacity":
    ASPx.SetElementOpacity(element, value);
    break;
   case "zIndex":
    ASPx.SetStylesCore(element, property, value, makeImportant);
    break;
   case "fontWeight":
    if(ASPx.Browser.IE && ASPx.Browser.Version < 9 && typeof(styles[property]) == "number")
     value = styles[property].toString();
   default:
    ASPx.SetStylesCore(element, property, value + (typeof (value) == "number" ? "px" : ""), makeImportant);
  }
 }
}
ASPx.SetStylesCore = function(element, property, value, makeImportant) {
 if(makeImportant) {
  var index = property.search("[A-Z]");
  if(index != -1)
   property = property.replace(property.charAt(index), "-" + property.charAt(index).toLowerCase());
  if(element.style.setProperty)
   element.style.setProperty(property, value, "important");
  else 
   element.style.cssText += ";" + property + ":" + value + "!important";
 }
 else
  element.style[property] = value;
}
ASPx.RemoveBordersAndShadows = function(el) {
 if(!el || !el.style)
  return;
 el.style.borderWidth = 0;
 if(ASPx.IsExists(el.style.boxShadow))
  el.style.boxShadow = "none";
 else if(ASPx.IsExists(el.style.MozBoxShadow))
  el.style.MozBoxShadow = "none";
 else if(ASPx.IsExists(el.style.webkitBoxShadow))
  el.style.webkitBoxShadow = "none";
}
ASPx.GetCellSpacing = function(element) {
 var val = parseInt(element.cellSpacing);
 if(!isNaN(val)) return val;
 val = parseInt(ASPx.GetCurrentStyle(element).borderSpacing);
 if(!isNaN(val)) return val;
 return 0;
}
ASPx.GetInnerScrollPositions = function(element) {
 var scrolls = [];
 getInnerScrollPositionsCore(element, scrolls);
 return scrolls;
}
function getInnerScrollPositionsCore(element, scrolls) {
 for(var child = element.firstChild; child; child = child.nextSibling) {
  var scrollTop = child.scrollTop,
   scrollLeft = child.scrollLeft;
  if(scrollTop > 0 || scrollLeft > 0)
   scrolls.push([child, scrollTop, scrollLeft]);
  getInnerScrollPositionsCore(child, scrolls);
 }
}
ASPx.RestoreInnerScrollPositions = function(scrolls) {
 for(var i = 0, scrollArr; scrollArr = scrolls[i]; i++) {
  if(scrollArr[1] > 0)
   scrollArr[0].scrollTop = scrollArr[1];
  if(scrollArr[2] > 0)
   scrollArr[0].scrollLeft = scrollArr[2];
 }
}
ASPx.GetOuterScrollPosition = function(element) {
 while(element.tagName !== "BODY") {
  var scrollTop = element.scrollTop,
   scrollLeft = element.scrollLeft;
  if(scrollTop > 0 || scrollLeft > 0) {
   return {
    scrollTop: scrollTop,
    scrollLeft: scrollLeft,
    element: element
   };
  }
  element = element.parentNode;
 }
 return {
  scrollTop: ASPx.GetDocumentScrollTop(),
  scrollLeft: ASPx.GetDocumentScrollLeft()
 };
}
ASPx.RestoreOuterScrollPosition = function(scrollInfo) {
 if(scrollInfo.element) {
  if(scrollInfo.scrollTop > 0)
   scrollInfo.element.scrollTop = scrollInfo.scrollTop;
  if(scrollInfo.scrollLeft > 0)
   scrollInfo.element.scrollLeft = scrollInfo.scrollLeft;
 }
 else {
  if(scrollInfo.scrollTop > 0)
   ASPx.SetDocumentScrollTop(scrollInfo.scrollTop);
  if(scrollInfo.scrollLeft > 0)
   ASPx.SetDocumentScrollLeft(scrollInfo.scrollLeft);
 }
}
ASPx.ChangeElementContainer = function(element, container, savePreviousContainer) {
 if(element.parentNode != container) {
  var parentNode = element.parentNode;
  parentNode.removeChild(element);
  container.appendChild(element);
  if(savePreviousContainer)
   element.previousContainer = parentNode;
 }
}
ASPx.RestoreElementContainer = function(element) {
 if(element.previousContainer) {
  ASPx.ChangeElementContainer(element, element.previousContainer, false);
  element.previousContainer = null;
 }
}
ASPx.MoveChildrenToElement = function(sourceElement, destinationElement){
 while(sourceElement.childNodes.length > 0)
  destinationElement.appendChild(sourceElement.childNodes[0]);
}
ASPx.GetScriptCode = function(script) {
 var useFirstChildElement = Browser.Chrome && Browser.Version < 11 || Browser.Safari && Browser.Version < 5; 
 var text = useFirstChildElement ? script.firstChild.data : script.text;
 var comment = "<!--";
 var pos = text.indexOf(comment);
 if(pos > -1)
  text = text.substr(pos + comment.length);
 return text;
}
ASPx.AppendScript = function(script) {
 var parent = document.getElementsByTagName("head")[0];
 if(!parent)
  parent = document.body;
 if(parent)
  parent.appendChild(script);
}
function getFrame(frames, name) {
 if(frames[name])
  return frames[name];
 for(var i = 0; i < frames.length; i++) {
  try {
   var frame = frames[i];
   if(frame.name == name) 
    return frame; 
   frame = getFrame(frame.frames, name);
   if(frame != null)   
    return frame; 
  } catch(e) {
  } 
 }
 return null;
}
ASPx.IsValidElement = function(element) {
 if(!element) 
  return false;
 if(!(Browser.Firefox && Browser.Version < 4)) {
  if(element.ownerDocument && element.ownerDocument.body.compareDocumentPosition)
   return element.ownerDocument.body.compareDocumentPosition(element) % 2 === 0;
 }
 if(!Browser.Opera && !(Browser.IE && Browser.Version < 9) && element.offsetParent && element.parentNode.tagName)
  return true;
 while(element != null){
  if(element.tagName == "BODY")
   return true;
  element = element.parentNode;
 }
 return false;
}
ASPx.IsValidElements = function(elements) {
 if(!elements)
  return false; 
 for(var i = 0; i < elements.length; i++) {
  if(elements[i] && !ASPx.IsValidElement(elements[i]))
   return false;
 }
 return true;
}
ASPx.IsExistsElement = function(element) {
 return element && ASPx.IsValidElement(element);
}
ASPx.CreateHtmlElementFromString = function(str) {
 var dummy = ASPx.CreateHtmlElement();
 dummy.innerHTML = str;
 return dummy.firstChild;
}
ASPx.CreateHtmlElement = function(tagName, styles) {
 var element = document.createElement(tagName || "DIV");
 if(styles)
  ASPx.SetStyles(element, styles);
 return element;
}
ASPx.RestoreElementOriginalWidth = function(element) {
 if(!ASPx.IsExistsElement(element)) 
  return;
 element.style.width = element.dxOrigWidth = ASPx.GetElementOriginalWidth(element);
}
ASPx.GetElementOriginalWidth = function(element) {
 if(!ASPx.IsExistsElement(element)) 
  return null;
 var width;
 if(!ASPx.IsExists(element.dxOrigWidth)) {
   width = String(element.style.width).length > 0
  ? element.style.width
  : element.offsetWidth + "px";
 } else {
  width = element.dxOrigWidth;
 }
 return width;
}
ASPx.DropElementOriginalWidth = function(element) {
 if(ASPx.IsExists(element.dxOrigWidth))
  element.dxOrigWidth = null;
}
ASPx.GetObjectKeys = function(obj) {
 if(!obj) return [ ];
 if(Object.keys)
  return Object.keys(obj);
 var keys = [ ];
 for(var key in obj) {
  if(obj.hasOwnProperty(key))
   keys.push(key);
 }
 return keys;
}
ASPx.IsInteractiveControl = function(element, extremeParent) {
 return Data.ArrayIndexOf(["A", "INPUT", "SELECT", "OPTION", "TEXTAREA", "BUTTON", "IFRAME"], element.tagName) > -1;
}
ASPx.IsUrlContainsClientScript = function(url) {
 return url.toLowerCase().indexOf("javascript:") !== -1;
}
Function.prototype.aspxBind = function(scope) {
 var func = this;
 return function() {
  return func.apply(scope, arguments);
 };
};
var FilteringUtils = { };
FilteringUtils.EventKeyCodeChangesTheInput = function(evt) {
 if(ASPx.IsPasteShortcut(evt))
  return true;
 else if(evt.ctrlKey && !evt.altKey)
  return false;
 if(ASPx.Browser.AndroidMobilePlatform || ASPx.Browser.MacOSMobilePlatform) return true; 
 var keyCode = ASPx.Evt.GetKeyCode(evt);
 var isSystemKey = ASPx.Key.Windows <= keyCode && keyCode <= ASPx.Key.ContextMenu;
 var isFKey = ASPx.Key.F1 <= keyCode && keyCode <= 127; 
 return ASPx.Key.Delete <= keyCode && !isSystemKey && !isFKey || keyCode == ASPx.Key.Backspace || keyCode == ASPx.Key.Space;
}
FilteringUtils.FormatCallbackArg = function(prefix, arg) {
 return (ASPx.IsExists(arg) ? prefix + "|" + arg.length + ';' + arg + ';' : "");
}
ASPx.FilteringUtils = FilteringUtils;
var FormatStringHelper = { };
FormatStringHelper.PlaceHolderTemplateStruct = function(startIndex, length, index, placeHolderString){
 this.startIndex = startIndex;
 this.realStartIndex = 0;
 this.length = length;
 this.realLength = 0;
 this.index = index;
 this.placeHolderString = placeHolderString;
}
FormatStringHelper.GetPlaceHolderTemplates = function(formatString){
 formatString = this.CollapseDoubleBrackets(formatString);
 var templates = this.CreatePlaceHolderTemplates(formatString);
 return templates;
}
FormatStringHelper.CreatePlaceHolderTemplates = function(formatString){
 var templates = [];
 var templateStrings = formatString.match(/{[^}]+}/g);
 if(templateStrings != null){
  var pos = 0;
  for(var i = 0; i < templateStrings.length; i++){
   var tempString = templateStrings[i];
   var startIndex = formatString.indexOf(tempString, pos);
   var length = tempString.length;
   var indexString = tempString.slice(1).match(/^[0-9]+/);
   var index = parseInt(indexString);
   templates.push(new this.PlaceHolderTemplateStruct(startIndex, length, index, tempString));
   pos = startIndex + length;
  }
 }
 return templates;
}
FormatStringHelper.CollapseDoubleBrackets = function(formatString){
 formatString = this.CollapseOpenDoubleBrackets(formatString);
 formatString = this.CollapseCloseDoubleBrackets(formatString);
 return formatString;
}
FormatStringHelper.CollapseOpenDoubleBrackets = function(formatString){
 return formatString.replace(/{{/g, "_");
}
FormatStringHelper.CollapseCloseDoubleBrackets = function(formatString){
 while(true){
  var index = formatString.lastIndexOf("}}");
  if(index == -1) 
   break;
  else
   formatString = formatString.substr(0, index) + "_" + formatString.substr(index + 2);
 }
 return formatString;
}
ASPx.FormatStringHelper = FormatStringHelper;
var StartWithFilteringUtils = { };
StartWithFilteringUtils.HighlightSuggestedText = function(input, suggestedText, control){
 if(this.NeedToLockAndoidKeyEvents(control))
  control.LockAndroidKeyEvents();
 var selInfo = ASPx.Selection.GetInfo(input);
 var currentTextLenght = ASPx.Str.GetCoincideCharCount(suggestedText, input.value, 
  function(text, filter) { 
   return text.indexOf(filter) == 0;
  });
 var suggestedTextLenght = suggestedText.length;
 var isSelected = selInfo.startPos == 0 && selInfo.endPos == currentTextLenght && 
  selInfo.endPos == suggestedTextLenght && input.value == suggestedText;
 if(!isSelected) { 
  input.value = suggestedText;
  if(this.NeedToLockAndoidKeyEvents(control)) {
   window.setTimeout(function() {
    this.SelectText(input, currentTextLenght, suggestedTextLenght);
    control.UnlockAndroidKeyEvents();
   }.aspxBind(this), control.adroidSamsungBugTimeout);
  } else
   this.SelectText(input, currentTextLenght, suggestedTextLenght);
 }
}
StartWithFilteringUtils.SelectText = function(input, startPos, stopPos) {
 if(startPos < stopPos)
  ASPx.Selection.Set(input, startPos, stopPos);
}
StartWithFilteringUtils.RollbackOneSuggestedChar = function(input){
 var currentText = input.value;
 var cutText = currentText.slice(0, -1);
 if(cutText != currentText)
  input.value = cutText;
}
StartWithFilteringUtils.NeedToLockAndoidKeyEvents = function(control) {
 return ASPx.Browser.AndroidMobilePlatform && control && control.LockAndroidKeyEvents;
}
ASPx.StartWithFilteringUtils = StartWithFilteringUtils;
var ContainsFilteringUtils = { };
ContainsFilteringUtils.ColumnSelectionStruct = function(index, startIndex, length){
 this.index = index;
 this.length = length;
 this.startIndex = startIndex;
}
ContainsFilteringUtils.IsFilterCrossPlaseHolder = function(filterStartIndex, filterEndIndex, template) {
 var left = Math.max(filterStartIndex, template.realStartIndex);
 var right = Math.min(filterEndIndex,  template.realStartIndex + template.realLength);
 return left < right;
}
ContainsFilteringUtils.GetColumnSelectionsForItem = function(itemValues, formatString, filterString) {
 if(formatString == "") 
  return this.GetSelectionForSingleColumnItem(itemValues, filterString); 
 var result = [];
 var formatedString = ASPx.Formatter.Format(formatString, itemValues);
 var filterStartIndex = ASPx.Str.PrepareStringForFilter(formatedString).indexOf(ASPx.Str.PrepareStringForFilter(filterString));
 if(filterStartIndex == -1) return result;
 var filterEndIndex = filterStartIndex + filterString.length;
 var templates = FormatStringHelper.GetPlaceHolderTemplates(formatString);
 this.SupplyTemplatesWithRealValues(itemValues, templates);
 for(var i = 0; i < templates.length ; i++) {
  if(this.IsFilterCrossPlaseHolder(filterStartIndex, filterEndIndex, templates[i])) 
   result.push(this.GetColumnSelectionsForItemValue(templates[i], filterStartIndex, filterEndIndex));
 }
 return result;
}
ContainsFilteringUtils.GetColumnSelectionsForItemValue = function(template, filterStartIndex, filterEndIndex) {
 var selectedTextStartIndex = filterStartIndex < template.realStartIndex ? 0 :
  filterStartIndex - template.realStartIndex;
 var selectedTextEndIndex = filterEndIndex >  template.realStartIndex + template.realLength ? template.realLength :
  filterEndIndex - template.realStartIndex;
 var selectedTextLength = selectedTextEndIndex - selectedTextStartIndex;
  return new this.ColumnSelectionStruct(template.index, selectedTextStartIndex, selectedTextLength);
},
ContainsFilteringUtils.GetSelectionForSingleColumnItem = function(itemValues, filterString) {
 var selectedTextStartIndex = ASPx.Str.PrepareStringForFilter(itemValues[0]).indexOf(ASPx.Str.PrepareStringForFilter(filterString));
 var selectedTextLength = filterString.length;
 return [new this.ColumnSelectionStruct(0, selectedTextStartIndex, selectedTextLength)];
}
ContainsFilteringUtils.ResetFormatStringIndex = function(formatString, index) {
 if(index != 0)
  return formatString.replace(index.toString(), "0");
 return formatString;
},
ContainsFilteringUtils.SupplyTemplatesWithRealValues = function(itemValues, templates) {
 var shift = 0;
 for(var i = 0; i < templates.length; i++) {
  var formatString = this.ResetFormatStringIndex(templates[i].placeHolderString, templates[i].index);
  var currentItemValue = itemValues[templates[i].index];
  templates[i].realLength = ASPx.Formatter.Format(formatString, currentItemValue).length;
  templates[i].realStartIndex  += templates[i].startIndex + shift; 
  shift += templates[i].realLength - templates[i].placeHolderString.length; 
 }
}
ContainsFilteringUtils.PrepareElementText = function(itemText) {
 return itemText ? itemText.replace(/\&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;") : '';
}
ContainsFilteringUtils.UnselectContainsTextInElement = function(element, selection) {
 var currentText =  ASPx.Attr.GetAttribute (element, "DXText");
 if(ASPx.IsExists(currentText)) {
  currentText = ContainsFilteringUtils.PrepareElementText(currentText);
  ASPx.SetInnerHtml(element, currentText === "" ? "&nbsp;" : currentText);
 }
}
ContainsFilteringUtils.ReselectContainsTextInElement = function(element, selection) {
 var currentText = ASPx.GetInnerText(element);
 if(currentText.indexOf("</em>") != -1)
  ContainsFilteringUtils.UnselectContainsTextInElement(element, selection);
 return ContainsFilteringUtils.SelectContainsTextInElement(element, selection);
}
ContainsFilteringUtils.SelectContainsTextInElement = function(element, selection) {
 if(selection.startIndex == -1) return;
 var currentText =  ASPx.Attr.GetAttribute (element, "DXText");
 if(!ASPx.IsExists(currentText)) ASPx.Attr.SetAttribute (element, "DXText", ASPx.GetInnerText(element));
 var oldInnerText = ASPx.GetInnerText(element);
 var newInnerText = ContainsFilteringUtils.PrepareElementText(oldInnerText.substr(0, selection.startIndex)) + "<em>" + 
      oldInnerText.substr(selection.startIndex, selection.length) + "</em>" + 
      ContainsFilteringUtils.PrepareElementText(oldInnerText.substr(selection.startIndex + selection.length));
 ASPx.SetInnerHtml(element, newInnerText);
}
ASPx.ContainsFilteringUtils = ContainsFilteringUtils;
ASPx.MakeEqualControlsWidth = function(name1, name2){
 var control1 = ASPx.GetControlCollection().Get(name1);
 var control2 = ASPx.GetControlCollection().Get(name2);
 if(control1 && control2){
  var width = Math.max(control1.GetWidth(), control2.GetWidth());
  control1.SetWidth(width);
  control2.SetWidth(width);
 }
}
var AccessibilityUtils = {
 highContrastCssClassMarker: "dxHighContrast",
 highContrastThemeActive: false,
 initialize: function() {
  this.detectHighContrastTheme(); 
 },
 detectHighContrastTheme: function() {
  var testElement = document.createElement("DIV");
  ASPx.SetStyles(testElement, {
   backgroundImage: "url('" + ASPx.EmptyImageUrl + "')",
   display: "none"
  }, true);
  var docElement = document.documentElement;
  docElement.appendChild(testElement);
  var actualBackgroundImg = ASPx.GetCurrentStyle(testElement).backgroundImage;
  docElement.removeChild(testElement);
  if(actualBackgroundImg === "none") {
   this.highContrastThemeActive = true;
   ASPx.AddClassNameToElement(docElement, this.highContrastCssClassMarker);
  }
 }
};
AccessibilityUtils.initialize();
ASPx.AccessibilityUtils = AccessibilityUtils;
var AnimationTransitionBase = ASPx.CreateClass(null, {
 constructor: function(element, options) {
  if(element) {
   AnimationTransitionBase.Cancel(element);
   this.element = element;
   this.element.aspxTransition = this;
  }
  this.duration = options.duration || AnimationConstants.Durations.DEFAULT;
  this.transition = options.transition || AnimationConstants.Transitions.SINE;
  this.property = options.property;
  this.unit = options.unit || "";
  this.onComplete = options.onComplete;
  this.to = null;
  this.from = null;
 },
 Start: function(from, to) {
  if(to != undefined) {
   this.to = to;
   this.from = from;
   this.SetValue(this.from);
  }
  else
   this.to = from;
 },
 Cancel: function() {
  if(!this.element)
   return;
  try {
   delete this.element.aspxTransition;
  } catch(e) {
   this.element.aspxTransition = undefined;
  }
 },
 GetValue: function() {
  return this.getValueInternal(this.element, this.property);
 },
 SetValue: function(value) {
  this.setValueInternal(this.element, this.property, this.unit, value);
 },
 setValueInternal: function(element, property, unit, value) {
  if(property == "opacity")
   AnimationUtils.setOpacity(element, value);
  else
   element.style[property] = value + unit;
 },
 getValueInternal: function(element, property) {
  if(property == "opacity")
   return ASPx.GetElementOpacity(element);
  var value = parseFloat(element.style[property]);
  return isNaN(value) ? 0 : value;
 },
 performOnComplete: function() {
  if(this.onComplete)
   this.onComplete(this.element);
 },
 getTransition: function() {
  return this.transition;
 }
});
AnimationTransitionBase.Cancel = function(element) {
 if(element.aspxTransition)
  element.aspxTransition.Cancel();
};
var AnimationConstants = {};
AnimationConstants.Durations = {
 SHORT: 200,
 DEFAULT: 400,
 LONG: 600
};
AnimationConstants.Transitions = {
 LINER: {
  Css: "cubic-bezier(0.250, 0.250, 0.750, 0.750)",
  Js: function(progress) { return progress; }
 },
 SINE: {
  Css: "cubic-bezier(0.470, 0.000, 0.745, 0.715)",
  Js: function(progress) { return Math.sin(progress * 1.57); }
 },
 POW: {
  Css: "cubic-bezier(0.755, 0.050, 0.855, 0.060)",
  Js: function(progress) { return Math.pow(progress, 4); }
 },
 POW_EASE_OUT: {
  Css: "cubic-bezier(0.165, 0.840, 0.440, 1.000)",
  Js: function(progress) { return 1 - AnimationConstants.Transitions.POW.Js(1 - progress); }
 },
 RIPPLE: {
  Css: "cubic-bezier(0.47, 0.06, 0.23, 0.99)",
  Js: function(progress) {
   return Math.pow((progress), 3) * 0.47 + 3 * progress * Math.pow((1 - progress), 2) * 0.06 + 3 * Math.pow(progress, 2) *
    (1 - progress) * 0.23 + 0.99 * Math.pow(progress, 3);
  }
 }
};
var JsAnimationTransition = ASPx.CreateClass(AnimationTransitionBase, {
 constructor: function(element, options) {
  this.constructor.prototype.constructor.call(this, element, options);
  this.onStep = options.onStep;
  this.fps = 60;
  this.startTime = null;
 },
 Start: function(from, to) {
  if(from == to) {
   this.from = this.to = from;
   setTimeout(this.complete.aspxBind(this), 0);
  }
  else {
   AnimationTransitionBase.prototype.Start.call(this, from, to);
   if(to == undefined)
    this.from = this.GetValue();
   this.initTimer();
  }
 },
 Cancel: function() {
  AnimationTransitionBase.prototype.Cancel.call(this);
  if(this.timerId)
   clearInterval(this.timerId);
 },
 initTimer: function() {
  this.startTime = new Date();
  this.timerId = window.setInterval(function() { this.onTick(); }.aspxBind(this), 1000 / this.fps);
 },
 onTick: function() {
  var progress = (new Date() - this.startTime) / this.duration;
  if(progress >= 1)
   this.complete();
  else {
   this.update(progress);
   if(this.onStep)
    this.onStep();
  }
 },
 update: function(progress) {
  this.SetValue(this.gatCalculatedValue(this.from, this.to, progress));
 },
 complete: function() {
  this.Cancel();
  this.update(1);
  this.performOnComplete();
 },
 gatCalculatedValue: function(from, to, progress) {
  if(progress == 1)
   return to;
  return from + (to - from) * this.getTransition()(progress);
 },
 getTransition: function() {
  return this.transition.Js;
 }
});
var SimpleAnimationTransition = ASPx.CreateClass(JsAnimationTransition, {
 constructor: function(options) {
  this.constructor.prototype.constructor.call(this, null, options);
  this.transition = options.transition || AnimationConstants.Transitions.POW_EASE_OUT;
  this.onUpdate = options.onUpdate;
  this.lastValue = 0;
 },
 SetValue: function(value) {
  this.onUpdate(value - this.lastValue);
  this.lastValue = value;
 },
 GetValue: function() {
  return this.lastValue;
 },
 performOnComplete: function() {
  if(this.onComplete)
   this.onComplete();
 }
});
var MultipleJsAnimationTransition = ASPx.CreateClass(JsAnimationTransition, {
 constructor: function(element, options) {
  this.constructor.prototype.constructor.call(this, element, options);
  this.properties = {};
 },
 Start: function(properties) {
  this.initProperties(properties);
  this.initTimer();
 },
 initProperties: function(properties) {
  this.properties = properties;
  for(var propName in this.properties)
   if(properties[propName].from == undefined)
    properties[propName].from = this.getValueInternal(this.element, propName);
 },
 update: function(progress) {
  for(var propName in this.properties) {
   var property = this.properties[propName];
   if(property.from != property.to)
    this.setValueInternal(this.element, propName, property.unit, this.gatCalculatedValue(property.from, property.to, progress));
  }
 }
});
var CssAnimationTransition = ASPx.CreateClass(AnimationTransitionBase, {
 constructor: function(element, options) {
  this.constructor.prototype.constructor.call(this, element, options);
  this.transitionPropertyName = AnimationUtils.CurrentTransition.property;
  this.eventName = AnimationUtils.CurrentTransition.event;
 },
 Start: function(from, to) {
  AnimationTransitionBase.prototype.Start.call(this, from, to);
  this.startTimerId = window.setTimeout(function() {
   if(this.from == this.to)
    this.onTransitionEnd();
   else {
    var isHidden = this.element.offsetHeight == 0 && this.element.offsetWidth == 0; 
    if(!isHidden)
     this.prepareElementBeforeAnimation();
    this.SetValue(this.to);
    if(isHidden)
     this.onTransitionEnd();
   }
  }.aspxBind(this), 0);
 },
 Cancel: function() {
  window.clearTimeout(this.startTimerId);
  AnimationTransitionBase.prototype.Cancel.call(this);
  ASPx.Evt.DetachEventFromElement(this.element, this.eventName, CssAnimationTransition.transitionEnd);
  this.stopAnimation();
  this.setValueInternal(this.element, this.transitionPropertyName, "", "");
 },
 prepareElementBeforeAnimation: function() {
  ASPx.Evt.AttachEventToElement(this.element, this.eventName, CssAnimationTransition.transitionEnd);
  var tmpH = this.element.offsetHeight; 
  this.element.style[this.transitionPropertyName] = this.getTransitionCssString();
  if(ASPx.Browser.Safari && ASPx.Browser.MacOSMobilePlatform && ASPx.Browser.MajorVersion >= 8) 
   setTimeout(function() {
    if(this.element && this.element.aspxTransition) {
     this.element.style[this.transitionPropertyName] = "";
     this.element.aspxTransition.onTransitionEnd();
    }
   }.aspxBind(this), this.duration + 100);
 },
 stopAnimation: function() {
  this.SetValue(ASPx.GetCurrentStyle(this.element)[this.property]);
 },
 onTransitionEnd: function() {
  this.Cancel();
  this.performOnComplete();
 },
 getTransition: function() {
  return this.transition.Css;
 },
 getTransitionCssString: function() {
  return this.getTransitionCssStringInternal(this.getCssName(this.property));
 },
 getTransitionCssStringInternal: function(cssProperty) {
  return cssProperty + " " + this.duration + "ms " + this.getTransition();
 },
 getCssName: function(property) {
  switch(property) {
   case "marginLeft":
    return "margin-left";
   case "marginTop":
    return "margin-top"
  }
  return property;
 }
});
var MultipleCssAnimationTransition = ASPx.CreateClass(CssAnimationTransition, {
 constructor: function(element, options) {
  this.constructor.prototype.constructor.call(this, element, options);
  this.properties = null;
 },
 Start: function(properties) {
  this.properties = properties;
  this.forEachProperties(function(property, propName) {
   if(property.from !== undefined)
    this.setValueInternal(this.element, propName, property.unit, property.from);
  }.aspxBind(this));
  this.prepareElementBeforeAnimation();
  this.forEachProperties(function(property, propName) {
   this.setValueInternal(this.element, propName, property.unit, property.to);
  }.aspxBind(this));
 },
 stopAnimation: function() {
  var style = ASPx.GetCurrentStyle(this.element);
  this.forEachProperties(function(property, propName) {
   this.setValueInternal(this.element, propName, "", style[propName]);
  }.aspxBind(this));
 },
 getTransitionCssString: function() {
  var str = "";
  this.forEachProperties(function(property, propName) {
   str += this.getTransitionCssStringInternal(this.getCssName(propName)) + ",";
  }.aspxBind(this));
  str = str.substring(0, str.length - 1);
  return str;
 },
 forEachProperties: function(func) {
  for(var propName in this.properties) {
   var property = this.properties[propName];
   if(property.from == undefined)
    property.from = this.getValueInternal(this.element, propName);
   if(property.from != property.to)
    func(property, propName);
  }
 }
});
CssAnimationTransition.transitionEnd = function(evt) {
 var element = evt.target;
 if(element && element.aspxTransition)
  element.aspxTransition.onTransitionEnd();
}
var AnimationUtils = {
 CanUseCssTransition: function() { return ASPx.EnableCssAnimation && this.CurrentTransition },
 CanUseCssTransform: function() { return this.CanUseCssTransition() && this.CurrentTransform },
 CurrentTransition: (function() {
  if(ASPx.Browser.IE) 
   return null;
  var transitions = [
   { property: "webkitTransition", event: "webkitTransitionEnd" },
   { property: "MozTransition", event: "transitionend" },
   { property: "OTransition", event: "oTransitionEnd" },
   { property: "transition", event: "transitionend" }
  ]
  var fakeElement = document.createElement("DIV");
  for(var i = 0; i < transitions.length; i++)
   if(transitions[i].property in fakeElement.style)
    return transitions[i];
 })(),
 CurrentTransform: (function() {
  var transforms = ["transform", "MozTransform", "-webkit-transform", "msTransform", "OTransform"];
  var fakeElement = document.createElement("DIV");
  for(var i = 0; i < transforms.length; i++)
   if(transforms[i] in fakeElement.style)
    return transforms[i];
 })(),
 SetTransformValue: function(element, position, isTop) {
  if(this.CanUseCssTransform())
   element.style[this.CurrentTransform] = this.GetTransformCssText(position, isTop);
  else
   element.style[!isTop ? "left" : "top"] = position + "px";
 },
 GetTransformValue: function(element, isTop) {
  if(this.CanUseCssTransform()) {
   var cssValue = element.style[this.CurrentTransform];
   return cssValue ? Number(cssValue.replace('matrix(1, 0, 0, 1,', '').replace(')', '').split(',')[!isTop ? 0 : 1]) : 0;
  }
  else
   return !isTop ? element.offsetLeft : element.offsetTop;
 },
 GetTransformCssText: function(position, isTop) {
  return "matrix(1, 0, 0, 1," + (!isTop ? position : 0) + ", " + (!isTop ? 0 : position) + ")";
 },
 createMultipleAnimationTransition: function (element, options) {
  return this.CanUseCssTransition() && !options.onStep ? new MultipleCssAnimationTransition(element, options) : new MultipleJsAnimationTransition(element, options);
 },
 createSimpleAnimationTransition: function(options) {
  return new SimpleAnimationTransition(options);
 },
 createJsAnimationTransition: function(element, options) {
  return new JsAnimationTransition(element, options);
 },
 createCssAnimationTransition: function(element, options) {
  return new CssAnimationTransition(element, options);
 },
 setOpacity: function(element, value) {
  ASPx.SetElementOpacity(element, value);
 }
};
ASPxClientUtils = {};
ASPxClientUtils.agent = Browser.UserAgent;
ASPxClientUtils.opera = Browser.Opera;
ASPxClientUtils.opera9 = Browser.Opera && Browser.MajorVersion == 9;
ASPxClientUtils.safari = Browser.Safari;
ASPxClientUtils.safari3 = Browser.Safari && Browser.MajorVersion == 3;
ASPxClientUtils.safariMacOS = Browser.Safari && Browser.MacOSPlatform;
ASPxClientUtils.chrome = Browser.Chrome;
ASPxClientUtils.ie = Browser.IE;
;
ASPxClientUtils.ie7 = Browser.IE && Browser.MajorVersion == 7;
ASPxClientUtils.firefox = Browser.Firefox;
ASPxClientUtils.firefox3 = Browser.Firefox && Browser.MajorVersion == 3;
ASPxClientUtils.mozilla = Browser.Mozilla;
ASPxClientUtils.netscape = Browser.Netscape;
ASPxClientUtils.browserVersion = Browser.Version;
ASPxClientUtils.browserMajorVersion = Browser.MajorVersion;
ASPxClientUtils.macOSPlatform = Browser.MacOSPlatform;
ASPxClientUtils.windowsPlatform = Browser.WindowsPlatform;
ASPxClientUtils.webKitFamily = Browser.WebKitFamily;
ASPxClientUtils.netscapeFamily = Browser.NetscapeFamily;
ASPxClientUtils.touchUI = Browser.TouchUI;
ASPxClientUtils.webKitTouchUI = Browser.WebKitTouchUI;
ASPxClientUtils.msTouchUI = Browser.MSTouchUI;
ASPxClientUtils.iOSPlatform = Browser.MacOSMobilePlatform;
ASPxClientUtils.androidPlatform = Browser.AndroidMobilePlatform;
ASPxClientUtils.ArrayInsert = Data.ArrayInsert;
ASPxClientUtils.ArrayRemove = Data.ArrayRemove;
ASPxClientUtils.ArrayRemoveAt = Data.ArrayRemoveAt;
ASPxClientUtils.ArrayClear = Data.ArrayClear;
ASPxClientUtils.ArrayIndexOf = Data.ArrayIndexOf;
ASPxClientUtils.AttachEventToElement = Evt.AttachEventToElement;
ASPxClientUtils.DetachEventFromElement = Evt.DetachEventFromElement;
ASPxClientUtils.GetEventSource = Evt.GetEventSource;
ASPxClientUtils.GetEventX = Evt.GetEventX;
ASPxClientUtils.GetEventY = Evt.GetEventY;
ASPxClientUtils.GetKeyCode = Evt.GetKeyCode;
ASPxClientUtils.PreventEvent = Evt.PreventEvent;
ASPxClientUtils.PreventEventAndBubble = Evt.PreventEventAndBubble;
ASPxClientUtils.PreventDragStart = Evt.PreventDragStart;
ASPxClientUtils.ClearSelection = Selection.Clear;
ASPxClientUtils.IsExists = ASPx.IsExists;
ASPxClientUtils.IsFunction = ASPx.IsFunction;
ASPxClientUtils.GetAbsoluteX = ASPx.GetAbsoluteX;
ASPxClientUtils.GetAbsoluteY = ASPx.GetAbsoluteY;
ASPxClientUtils.SetAbsoluteX = ASPx.SetAbsoluteX;
ASPxClientUtils.SetAbsoluteY = ASPx.SetAbsoluteY;
ASPxClientUtils.GetDocumentScrollTop = ASPx.GetDocumentScrollTop;
ASPxClientUtils.GetDocumentScrollLeft = ASPx.GetDocumentScrollLeft;
ASPxClientUtils.GetDocumentClientWidth = ASPx.GetDocumentClientWidth;
ASPxClientUtils.GetDocumentClientHeight = ASPx.GetDocumentClientHeight;
ASPxClientUtils.GetIsParent = ASPx.GetIsParent;
ASPxClientUtils.GetParentById = ASPx.GetParentById;
ASPxClientUtils.GetParentByTagName = ASPx.GetParentByTagName;
ASPxClientUtils.GetParentByClassName = ASPx.GetParentByPartialClassName;
ASPxClientUtils.GetChildById = ASPx.GetChildById;
ASPxClientUtils.GetChildByTagName = ASPx.GetChildByTagName;
ASPxClientUtils.SetCookie = Cookie.SetCookie;
ASPxClientUtils.GetCookie = Cookie.GetCookie;
ASPxClientUtils.DeleteCookie = Cookie.DelCookie;
ASPxClientUtils.GetShortcutCode = ASPx.GetShortcutCode; 
ASPxClientUtils.GetShortcutCodeByEvent = ASPx.GetShortcutCodeByEvent;
ASPxClientUtils.StringToShortcutCode = ASPx.ParseShortcutString;
ASPxClientUtils.Trim = Str.Trim; 
ASPxClientUtils.TrimStart = Str.TrimStart;
ASPxClientUtils.TrimEnd = Str.TrimEnd;
window.ASPxClientUtils = ASPxClientUtils;
ASPx.AnimationUtils = AnimationUtils;
ASPx.AnimationTransitionBase = AnimationTransitionBase;
ASPx.AnimationConstants = AnimationConstants;
})();
   
(function () {
ASPx.classesScriptParsed = false;
ASPx.documentLoaded = false; 
ASPx.CallbackType = {
 Data: "d",
 Common: "c"
};
ASPx.callbackState = {
 aborted: "aborted",
 inTurn: "inTurn",
 sent: "sent"
};
var ASPxClientEvent = ASPx.CreateClass(null, {
 constructor: function() {
  this.handlerInfoList = [];
 },
 AddHandler: function(handler, executionContext) {
  if(typeof(executionContext) == "undefined")
   executionContext = null;
  this.RemoveHandler(handler, executionContext);
  var handlerInfo = ASPxClientEvent.CreateHandlerInfo(handler, executionContext);
  this.handlerInfoList.push(handlerInfo);
 },
 RemoveHandler: function(handler, executionContext) {
  this.removeHandlerByCondition(function(handlerInfo) {
   return handlerInfo.handler == handler && 
    (!executionContext || handlerInfo.executionContext == executionContext);
  });
 },
 removeHandlerByCondition: function(predicate) {
   for(var i = this.handlerInfoList.length - 1; i >= 0; i--) {
   var handlerInfo = this.handlerInfoList[i];
   if(predicate(handlerInfo))
    ASPx.Data.ArrayRemoveAt(this.handlerInfoList, i);
  }
 },
 removeHandlerByControlName: function(controlName) {
  this.removeHandlerByCondition(function(handlerInfo) {
   return handlerInfo.executionContext &&  
    handlerInfo.executionContext.name === controlName;
  });
 },
 ClearHandlers: function() {
  this.handlerInfoList.length = 0;
 },
 FireEvent: function(obj, args) {
  for(var i = 0; i < this.handlerInfoList.length; i++) {
   var handlerInfo = this.handlerInfoList[i];
   handlerInfo.handler.call(handlerInfo.executionContext, obj, args);
  }
 },
 InsertFirstHandler: function(handler, executionContext){
  if(typeof(executionContext) == "undefined")
   executionContext = null;
  var handlerInfo = ASPxClientEvent.CreateHandlerInfo(handler, executionContext);
  ASPx.Data.ArrayInsert(this.handlerInfoList, handlerInfo, 0);
 },
 IsEmpty: function() {
  return this.handlerInfoList.length == 0;
 }
});
ASPxClientEvent.CreateHandlerInfo = function(handler, executionContext) {
 return {
  handler: handler,
  executionContext: executionContext
 };
};
var ASPxClientEventArgs = ASPx.CreateClass(null, {
 constructor: function() {
 }
});
ASPxClientEventArgs.Empty = new ASPxClientEventArgs();
var ASPxClientCancelEventArgs = ASPx.CreateClass(ASPxClientEventArgs, {
 constructor: function(){
  this.constructor.prototype.constructor.call(this);
  this.cancel = false;
 }
});
var ASPxClientProcessingModeEventArgs = ASPx.CreateClass(ASPxClientEventArgs, {
 constructor: function(processOnServer){
  this.constructor.prototype.constructor.call(this);
  this.processOnServer = processOnServer;
 }
});
var ASPxClientProcessingModeCancelEventArgs = ASPx.CreateClass(ASPxClientProcessingModeEventArgs, {
 constructor: function(processOnServer){
  this.constructor.prototype.constructor.call(this, processOnServer);
  this.cancel = false;
 }
});
var OrderedMap = ASPx.CreateClass(null, {
 constructor: function(){
  this.entries = {};
  this.firstEntry = null;
  this.lastEntry = null;
 },
 add: function(key, element) {
  var entry = this.addEntry(key, element);
  this.entries[key] = entry;
 },
 remove: function(key) {
  var entry = this.entries[key];
  if(entry === undefined)
   return;
  this.removeEntry(entry);
  delete this.entries[key];
 },
 clear: function() {
  this.markAllEntriesAsRemoved();
  this.entries = {};
  this.firstEntry = null;
  this.lastEntry = null;
 },
 get: function(key) {
  var entry = this.entries[key];
  return entry ? entry.value : undefined;
 },
 forEachEntry: function(processFunc, context) {
  context = context || this;
  for(var entry = this.firstEntry; entry; entry = entry.next) {
   if(entry.removed)
    continue;
   if(processFunc.call(context, entry.key, entry.value))
    return;
  }
 },
 addEntry: function(key, element) {
  var entry = { key: key, value: element, next: null, prev: null };
  if(!this.firstEntry)
   this.firstEntry = entry;
  else {
   entry.prev = this.lastEntry;
   this.lastEntry.next = entry;
  }
  this.lastEntry = entry;
  return entry;
 },
 removeEntry: function(entry) {
  if(this.firstEntry == entry)
   this.firstEntry = entry.next;
  if(this.lastEntry == entry)
   this.lastEntry = entry.prev;
  if(entry.prev)
   entry.prev.next = entry.next;
  if(entry.next)
   entry.next.prev = entry.prev;
  entry.removed = true;
 },
 markAllEntriesAsRemoved: function() {
  for(var entry = this.firstEntry; entry; entry = entry.next)
   entry.removed = true;
 }
});
var CollectionBase = ASPx.CreateClass(null, {
 constructor: function(){
  this.elementsMap = new OrderedMap();
  this.isASPxClientCollection = true;
 },
 Add: function(key, element) {
  this.elementsMap.add(key, element);
 },
 Remove: function(key) {
  this.elementsMap.remove(key);
 },
 Clear: function(){
  this.elementsMap.clear();
 },
 Get: function(key){
  return this.elementsMap.get(key);
 }
});
var GarbageCollector = ASPx.CreateClass(null, {
 constructor: function() {
  this.interval = 5000;
  this.intervalID = window.setInterval(function(){ this.CollectObjects(); }.aspxBind(this), this.interval);
 },
 CollectObjects: function(){
  if(ASPx.GetControlCollection().InCallback()) return;
  ASPx.GetControlCollectionCollection().RemoveDisposedControls();
  if(typeof(ASPx.GetStateController) != "undefined")
   ASPx.GetStateController().RemoveDisposedItems();
  if(ASPx.Ident.scripts.ASPxClientRatingControl)
   ASPxClientRatingControl.RemoveDisposedElementUnderCursor();
  var postHandler = aspxGetPostHandler();
  if(postHandler)
   postHandler.RemoveDisposedFormsFromCache();
 }
});
var gcCollector = new GarbageCollector(); 
var ControlTree = ASPx.CreateClass(null, {
 constructor: function(controlCollection, container) {
  this.container = container;
  this.domMap = { };
  this.rootNode = this.createNode(null, null);
  this.createControlTree(controlCollection, container);
 },
 forEachControl: function(collapseControls, processFunc) {
  var observer = _aspxGetDomObserver();
  observer.pause(this.container, true);
  var documentScrollInfo;
  if(collapseControls) {
   documentScrollInfo = ASPx.GetOuterScrollPosition(document.body);
   this.collapseControls(this.rootNode);
  }
  var adjustNodes = [], 
   autoHeightNodes = [];
  var requireReAdjust = this.forEachControlCore(this.rootNode, collapseControls, processFunc, adjustNodes, autoHeightNodes);
  if(requireReAdjust)
   this.forEachControlsBackward(adjustNodes, collapseControls, processFunc);
  else {
   for(var i = 0, node; node = autoHeightNodes[i]; i++)
    node.control.AdjustAutoHeight();
  }
  if(collapseControls)
   ASPx.RestoreOuterScrollPosition(documentScrollInfo);
  observer.resume(this.container, true);
 },
 forEachControlCore: function(node, collapseControls, processFunc, adjustNodes, autoHeightNodes) {
  var requireReAdjust = false,
   size, newSize;
  if(node.control) {
   var checkReadjustment = collapseControls && node.control.IsControlCollapsed() && node.control.CanCauseReadjustment();
   if(checkReadjustment)
    size = node.control.GetControlPercentMarkerSize(false, true);
   if(node.control.IsControlCollapsed() && !node.control.IsExpandableByAdjustment())
    node.control.ExpandControl();
   node.control.isInsideHierarchyAdjustment = true;
   processFunc(node.control);
   node.control.isInsideHierarchyAdjustment = false;
   if(checkReadjustment) {
    newSize = node.control.GetControlPercentMarkerSize(false, true);
    requireReAdjust = size.width !== newSize.width;
   }
   if(node.control.sizingConfig.supportAutoHeight)
    autoHeightNodes.push(node);
   node.control.ResetControlPercentMarkerSize();
  }
  for(var childNode, i = 0; childNode = node.children[i]; i++)
   requireReAdjust = this.forEachControlCore(childNode, collapseControls, processFunc, adjustNodes, autoHeightNodes) || requireReAdjust;
  adjustNodes.push(node);
  return requireReAdjust;
 },
 forEachControlsBackward: function(adjustNodes, collapseControls, processFunc) {
  for(var i = 0, node; node = adjustNodes[i]; i++)
   this.forEachControlsBackwardCore(node, collapseControls, processFunc);
 },
 forEachControlsBackwardCore: function(node, collapseControls, processFunc) {
  if(node.control)
   processFunc(node.control);
  if(node.children.length > 1) {
   for(var i = 0, childNode; childNode = node.children[i]; i++) {
    if(childNode.control)
     processFunc(childNode.control);
   }
  }
 },
 collapseControls: function(node) {
  for(var childNode, i = 0; childNode = node.children[i]; i++)
   this.collapseControls(childNode);
  if(node.control && node.control.NeedCollapseControl())
   node.control.CollapseControl();
 },
 createControlTree: function(controlCollection, container) {
  controlCollection.ProcessControlsInContainer(container, function(control) {
   control.RegisterInControlTree(this);
  }.aspxBind(this));
  var fixedNodes = [];
  var fixedNodesChildren = [];
  for(var domElementID in this.domMap) {
   if(!this.domMap.hasOwnProperty(domElementID)) continue;
   var node = this.domMap[domElementID];
   var controlOwner = node.control ? node.control.controlOwner : null;
   if(controlOwner && this.domMap[controlOwner.name])
    continue;
   if(this.isFixedNode(node))
    fixedNodes.push(node);
   else {
    var parentNode = this.findParentNode(domElementID);
    parentNode = parentNode || this.rootNode;
    if(this.isFixedNode(parentNode))
     fixedNodesChildren.push(node);
    else {
     var childNode = node.mainNode || node;
     this.addChildNode(parentNode, childNode);
    }
   }
  }
  for(var i = fixedNodes.length - 1; i >= 0; i--)
   this.insertChildNode(this.rootNode, fixedNodes[i], 0);
  for(var i = fixedNodesChildren.length - 1; i >= 0; i--)
   this.insertChildNode(this.rootNode, fixedNodesChildren[i], 0);
 },
 findParentNode: function(id) {
  var element = document.getElementById(id).parentNode;
  while(element && element.tagName !== "BODY") {
   if(element.id) {
    var parentNode = this.domMap[element.id];
    if(parentNode)
     return parentNode;
   }
   element = element.parentNode;
  }
  return null;
 },
 addChildNode: function(node, childNode) {
  if(!childNode.parentNode) {
   node.children.push(childNode);
   childNode.parentNode = node;
  }
 },
 insertChildNode: function(node, childNode, index) {
  if(!childNode.parentNode) {
   ASPx.Data.ArrayInsert(node.children, childNode, index);
   childNode.parentNode = node;
  }
 },
 addRelatedNode: function(node, relatedNode) {
  this.addChildNode(node, relatedNode);
  relatedNode.mainNode = node;
 },
 isFixedNode: function(node) {
  var control = node.mainNode ? node.mainNode.control : node.control;
  return control && control.HasFixedPosition();
 },
 createNode: function(domElementID, control) {
  var node = {
   control: control,
   children: [],
   parentNode: null,
   mainNode: null
  };
  if(domElementID)
   this.domMap[domElementID] = node;
  return node;
 }
});
function _aspxFunctionIsInCallstack(currentCallee, targetFunction, depthLimit) {
 var candidate = currentCallee;
 var depth = 0;
 while(candidate && depth <= depthLimit) {
  candidate = candidate.caller;
  if(candidate == targetFunction)
   return true;
  depth++;
 }
 return false;
}
ASPx.Evt.AttachEventToElement(window, "load", aspxClassesWindowOnLoad);
function aspxClassesWindowOnLoad(evt){
 ASPx.documentLoaded = true;
 _aspxSweepDuplicatedLinks();
 ResourceManager.SynchronizeResources();
 var externalScriptProcessor = GetExternalScriptProcessor();
 if(externalScriptProcessor)
  externalScriptProcessor.ShowErrorMessages();
 ASPx.GetControlCollection().Initialize();
 _aspxInitializeScripts();
 _aspxInitializeLinks();
 _aspxInitializeFocus();
}
Ident = { };
Ident.IsDate = function(obj) {
 return obj && obj.constructor == Date;
};
Ident.IsRegExp = function(obj) {
 return obj && obj.constructor === RegExp;
};
Ident.IsArray = function(obj) {
 return obj && obj.constructor == Array;
};
Ident.IsASPxClientCollection = function(obj) {
 return obj && obj.isASPxClientCollection;
};
Ident.IsASPxClientControl = function(obj) {
 return obj && obj.isASPxClientControl;
};
Ident.IsASPxClientEdit = function(obj) {
 return obj && obj.isASPxClientEdit;
};
Ident.IsFocusableElementRegardlessTabIndex = function (element) {
 var tagName = element.tagName;
 return tagName == "TEXTAREA" || tagName == "INPUT" || tagName == "A" || 
  tagName == "SELECT" || tagName == "IFRAME" || tagName == "OBJECT";
};
Ident.isDialogInvisibleControl = function(control) {
 return !!ASPx.Dialog && ASPx.Dialog.isDialogInvisibleControl(control);
};
Ident.scripts = {};
if(ASPx.IsFunction(window.WebForm_InitCallbackAddField)) {
 (function() {
  var original = window.WebForm_InitCallbackAddField;
  window.WebForm_InitCallbackAddField = function(name, value) {
   if(typeof(name) == "string" && name)
    original.apply(null, arguments);
  };
 })();
}
ASPx.FireDefaultButton = function(evt, buttonID) {
 if(_aspxIsDefaultButtonEvent(evt, buttonID)) {
  var defaultButton = ASPx.GetElementById(buttonID);
  if(defaultButton && defaultButton.click) {
   if(ASPx.IsFocusable(defaultButton))
    defaultButton.focus();
   ASPx.Evt.DoElementClick(defaultButton);
   ASPx.Evt.PreventEventAndBubble(evt);
   return false;
  }
 }
 return true;
}
function _aspxIsDefaultButtonEvent(evt, defaultButtonID) {
 if(evt.keyCode != ASPx.Key.Enter)
  return false;
 var srcElement = ASPx.Evt.GetEventSource(evt);
 if(!srcElement || srcElement.id === defaultButtonID)
  return true;
 var tagName = srcElement.tagName;
 var type = srcElement.type;
 return tagName != "TEXTAREA" && tagName != "BUTTON" && tagName != "A" &&
  (tagName != "INPUT" || type != "checkbox" && type != "radio" && type != "button" && type != "submit" && type != "reset");
}
var PostHandler = ASPx.CreateClass(null, {
 constructor: function() {
  this.Post = new ASPxClientEvent();
  this.PostFinalization = new ASPxClientEvent();
  this.observableForms = [];
  this.dxCallbackTriggers = {};
  this.lastSubmitElementName = null;
  this.ReplaceGlobalPostFunctions();
  this.HandleDxCallbackBeginning();
  this.HandleMSAjaxRequestBeginning();
 },
 Update: function() {
  this.ReplaceFormsSubmit(true);
 },
 ProcessPostRequest: function(ownerID, isCallback, isMSAjaxRequest, isDXCallback) {
  this.cancelPostProcessing = false;
  this.isMSAjaxRequest = isMSAjaxRequest;
  if(this.SkipRaiseOnPost(ownerID, isCallback, isDXCallback))
   return;
  var args = new PostHandlerOnPostEventArgs(ownerID, isCallback, isMSAjaxRequest, isDXCallback);
  this.Post.FireEvent(this, args);
  this.cancelPostProcessing = args.cancel;
  if(!args.cancel)
   this.PostFinalization.FireEvent(this, args);
 },
 SkipRaiseOnPost: function(ownerID, isCallback, isDXCallback) { 
  if(!isCallback)
   return false;
  var dxOwner = isDXCallback && ASPx.GetControlCollection().GetByName(ownerID);
  if(dxOwner) {
   this.dxCallbackTriggers[dxOwner.uniqueID] = true;
   return false;
  }
  if(this.dxCallbackTriggers[ownerID]) {
   this.dxCallbackTriggers[ownerID] = false;
   return true;
  }
  return false;
 },
 ReplaceGlobalPostFunctions: function() {
  if(ASPx.IsFunction(window.__doPostBack))
   this.ReplaceDoPostBack();
  if(ASPx.IsFunction(window.WebForm_DoCallback))
   this.ReplaceDoCallback();
  this.ReplaceFormsSubmit();
 },
 HandleDxCallbackBeginning: function() {
  ASPx.GetControlCollection().BeforeInitCallback.AddHandler(function(s, e) {
   aspxRaisePostHandlerOnPost(e.callbackOwnerID, true, false, true); 
  });
 },
 HandleMSAjaxRequestBeginning: function() {
  if(window.Sys && Sys.WebForms && Sys.WebForms.PageRequestManager && Sys.WebForms.PageRequestManager.getInstance) {
   var pageRequestManager = Sys.WebForms.PageRequestManager.getInstance();
   if(pageRequestManager != null && Ident.IsArray(pageRequestManager._onSubmitStatements)) {
    pageRequestManager._onSubmitStatements.unshift(function() {
     var postbackSettings = Sys.WebForms.PageRequestManager.getInstance()._postBackSettings;
     var postHandler = aspxGetPostHandler();
     aspxRaisePostHandlerOnPost(postbackSettings.asyncTarget, true, true);
     return !postHandler.cancelPostProcessing;
    });
   }
  }
 },
 ReplaceDoPostBack: function() {
  var original = __doPostBack;
  __doPostBack = function(eventTarget, eventArgument) {
   var postHandler = aspxGetPostHandler();
   aspxRaisePostHandlerOnPost(eventTarget);
   if(postHandler.cancelPostProcessing)
    return;
   ASPxClientControl.postHandlingLocked = true;
   original(eventTarget, eventArgument);
   delete ASPxClientControl.postHandlingLocked;
  };
 },
 ReplaceDoCallback: function() {
  var original = WebForm_DoCallback;
  WebForm_DoCallback = function(eventTarget, eventArgument, eventCallback, context, errorCallback, useAsync) {
   var postHandler = aspxGetPostHandler();
   aspxRaisePostHandlerOnPost(eventTarget, true);
   if(postHandler.cancelPostProcessing)
    return;
   return original(eventTarget, eventArgument, eventCallback, context, errorCallback, useAsync);
  };
 },
 ReplaceFormsSubmit: function(checkObservableCollection) {
  for(var i = 0; i < document.forms.length; i++) { 
   var form = document.forms[i];
   if(checkObservableCollection && ASPx.Data.ArrayIndexOf(this.observableForms, form) >= 0)
    continue;
   if(form.submit)
    this.ReplaceFormSubmit(form);
   this.ReplaceFormOnSumbit(form);
   this.observableForms.push(form);
  }
 },
 ReplaceFormSubmit: function(form) {
  var originalSubmit = form.submit;
  form.submit = function() {
   var postHandler = aspxGetPostHandler();
   aspxRaisePostHandlerOnPost();
   if(postHandler.cancelPostProcessing)
    return false;
   var callee = arguments.callee;
   this.submit = originalSubmit;
   var submitResult = this.submit();
   this.submit = callee;
   return submitResult;
  };
  form = null;
 },
 ReplaceFormOnSumbit: function(form) {
  var originalSubmit = form.onsubmit;
  form.onsubmit = function() {
   var postHandler = aspxGetPostHandler();
   if(postHandler.isMSAjaxRequest)
    postHandler.isMsAjaxRequest = false;
   else
    aspxRaisePostHandlerOnPost(postHandler.GetLastSubmitElementName());
   if(postHandler.cancelPostProcessing)
    return false;
   return ASPx.IsFunction(originalSubmit)
    ? originalSubmit.apply(this, arguments)
    : true;
  };
  form = null;
 },
 SetLastSubmitElementName: function(elementName) {
  this.lastSubmitElementName = elementName;
 },
 GetLastSubmitElementName: function() {
  return this.lastSubmitElementName;
 },
 RemoveDisposedFormsFromCache: function(){
  for(var i = 0; this.observableForms && i < this.observableForms.length; i++){
   var form = this.observableForms[i];
   if(!ASPx.IsExistsElement(form)){
    ASPx.Data.ArrayRemove(this.observableForms, form);
    i--;
   }
  }
 }
});
function aspxRaisePostHandlerOnPost(ownerID, isCallback, isMSAjaxRequest, isDXCallback) {
 if(ASPxClientControl.postHandlingLocked) return;
 var postHandler = aspxGetPostHandler();
 if(postHandler)
  postHandler.ProcessPostRequest(ownerID, isCallback, isMSAjaxRequest, isDXCallback);
}
var aspxPostHandler;
function aspxGetPostHandler() {
 if(!aspxPostHandler)
  aspxPostHandler = new PostHandler();
 return aspxPostHandler;
}
var PostHandlerOnPostEventArgs = ASPx.CreateClass(ASPxClientCancelEventArgs, {
 constructor: function(ownerID, isCallback, isMSAjaxCallback, isDXCallback){
  this.constructor.prototype.constructor.call(this);
  this.ownerID = ownerID;
  this.isCallback = !!isCallback;
  this.isDXCallback = !!isDXCallback;
  this.isMSAjaxCallback = !!isMSAjaxCallback;
 }
});
var ResourceManager = {
 HandlerStr: "DXR.axd?r=",
 ResourceHashes: {},
 SynchronizeResources: function(method){
  if(!method){
   method = function(name, resource) { 
    this.UpdateInputElements(name, resource); 
   }.aspxBind(this);
  }
  var resources = this.GetResourcesData();
  for(var name in resources)
   method(name, resources[name]);
 },
 GetResourcesData: function(){
  return {
   DXScript: this.GetResourcesElementsString(_aspxGetIncludeScripts(), "src", "DXScript"),
   DXCss: this.GetResourcesElementsString(_aspxGetLinks(), "href", "DXCss")
  };
 },
 GetResourcesElementsString: function(elements, urlAttr, id){
  if(!this.ResourceHashes[id]) 
   this.ResourceHashes[id] = {};
  var hash = this.ResourceHashes[id];
  for(var i = 0; i < elements.length; i++) {
   var resourceUrl = ASPx.Attr.GetAttribute(elements[i], urlAttr);
   if(resourceUrl) {
    var pos = resourceUrl.indexOf(this.HandlerStr);
    if(pos > -1){
     var list = resourceUrl.substr(pos + this.HandlerStr.length);
     var ampPos = list.lastIndexOf("-");
     if(ampPos > -1)
      list = list.substr(0, ampPos);
     var indexes = list.split(",");
     for(var j = 0; j < indexes.length; j++)
      hash[indexes[j]] = indexes[j];
    }
    else
     hash[resourceUrl] = resourceUrl;
   }
  }
  var array = [];
  for(var key in hash) 
   array.push(key);
  return array.join(",");
 },
 UpdateInputElements: function(typeName, list){
  for(var i = 0; i < document.forms.length; i++){
   var inputElement = document.forms[i][typeName];
   if(!inputElement)
    inputElement = this.CreateInputElement(document.forms[i], typeName);
   inputElement.value = list;
  }
 },
 CreateInputElement: function(form, typeName){
  var inputElement = ASPx.CreateHiddenField(typeName, typeName);
  form.appendChild(inputElement);
  return inputElement;
 }
};
ASPx.includeScriptPrefix = "dxis_";
ASPx.startupScriptPrefix = "dxss_";
var includeScriptsCache = {};
var createdIncludeScripts = [];
var appendedScriptsCount = 0;
var callbackOwnerNames = [];
var scriptsRestartHandlers = { };
function _aspxIsKnownIncludeScript(script) {
 return !!includeScriptsCache[script.src];
}
function _aspxCacheIncludeScript(script) {
 includeScriptsCache[script.src] = 1;
}
function _aspxProcessScriptsAndLinks(ownerName, isCallback) {
 if(!ASPx.documentLoaded) return; 
 _aspxProcessScripts(ownerName, isCallback);
 getLinkProcessor().process();
 ASPx.ClearCachedCssRules();
}
function _aspxGetStartupScripts() {
 return _aspxGetScriptsCore(ASPx.startupScriptPrefix);
}
function _aspxGetIncludeScripts() {
 return _aspxGetScriptsCore(ASPx.includeScriptPrefix);
}
function _aspxGetScriptsCore(prefix) {
 var result = [];
 var scripts = document.getElementsByTagName("SCRIPT");
 for(var i = 0; i < scripts.length; i++) {
  if(scripts[i].id.indexOf(prefix) == 0)
   result.push(scripts[i]);
 }
 return result;
}
function _aspxGetLinks() {
 var result = [];
 var links = document.getElementsByTagName("LINK");;
 for(var i = 0; i < links.length; i++) 
  result[i] = links[i];
 return result;
}
function _aspxIsLinksLoaded() {
 var links = _aspxGetLinks();
 for(var i = 0, link; link = links[i]; i++) {
  if(link.readyState && link.readyState.toLowerCase() == "loading")
    return false;
  }
 return true;
}
function _aspxInitializeLinks() {
 var links = _aspxGetLinks();
 for(var i = 0; i < links.length; i++)
  links[i].loaded = true; 
}
function _aspxInitializeScripts() {
 var scripts = _aspxGetIncludeScripts();
 for(var i = 0; i < scripts.length; i++)
  _aspxCacheIncludeScript(scripts[i]);   
 var startupScripts = _aspxGetStartupScripts();
 for(var i = 0; i < startupScripts.length; i++)
  startupScripts[i].executed = true; 
}
function _aspxSweepDuplicatedLinks() {
 var hash = { };
 var links = _aspxGetLinks();
 for(var i = 0; i < links.length; i++) {
  var href = links[i].href;
  if(!href)
   continue;
  if(hash[href]){
   if((ASPx.Browser.IE || !hash[href].loaded) && links[i].loaded) {
    ASPx.RemoveElement(hash[href]);
    hash[href] = links[i];
   }
   else
    ASPx.RemoveElement(links[i]);
  }
  else
   hash[href] = links[i];
 }
}
function _aspxSweepDuplicatedScripts() {
 var hash = { };
 var scripts = _aspxGetIncludeScripts();
 for(var i = 0; i < scripts.length; i++) {
  var src = scripts[i].src;
  if(!src) continue;
  if(hash[src])
   ASPx.RemoveElement(scripts[i]);
  else
   hash[src] = scripts[i];
 }
}
function _aspxProcessScripts(ownerName, isCallback) {
 var scripts = _aspxGetIncludeScripts();
 var previousCreatedScript = null;
 var firstCreatedScript = null;
 for(var i = 0; i < scripts.length; i++) {
  var script = scripts[i];
  if(script.src == "") continue; 
  if(_aspxIsKnownIncludeScript(script))
   continue;
  var createdScript = document.createElement("script");
  createdScript.type = "text/javascript";
  createdScript.src = script.src;
  createdScript.id = script.id;
  function AreScriptsEqual(script1, script2) {
   return script1.src == script2.src;
  }
  if(ASPx.Data.ArrayIndexOf(createdIncludeScripts, createdScript, AreScriptsEqual) >= 0)
   continue;
  createdIncludeScripts.push(createdScript);
  ASPx.RemoveElement(script);
  if(ASPx.Browser.IE && ASPx.Browser.Version < 9) {
   createdScript.onreadystatechange = new Function("ASPx.OnScriptReadyStateChangedCallback(this, " + isCallback + ");");
  } else if(ASPx.Browser.Edge || ASPx.Browser.WebKitFamily || (ASPx.Browser.Firefox && ASPx.Browser.Version >= 4) || ASPx.Browser.IE && ASPx.Browser.Version >= 9) {
   createdScript.onload = new Function("ASPx.OnScriptLoadCallback(this, " + isCallback + ");");
   if(firstCreatedScript == null)
    firstCreatedScript = createdScript;
   createdScript.nextCreatedScript = null;
   if(previousCreatedScript != null)
    previousCreatedScript.nextCreatedScript = createdScript;
   previousCreatedScript = createdScript;
  } else {
   createdScript.onload = new Function("ASPx.OnScriptLoadCallback(this);");
   ASPx.AppendScript(createdScript);
   _aspxCacheIncludeScript(createdScript);
  }
 }
 if(firstCreatedScript != null) {
  ASPx.AppendScript(firstCreatedScript);
  _aspxCacheIncludeScript(firstCreatedScript);
 }
 if(isCallback)
  callbackOwnerNames.push(ownerName);
 if(createdIncludeScripts.length == 0) {
  var newLinks = ASPx.GetNodesByTagName(document.body, "link");
  var needProcessLinks = isCallback && newLinks.length > 0;
  if(needProcessLinks)
   needProcessLinks = getLinkProcessor().addLinks(newLinks);
  if(!needProcessLinks)
   ASPx.FinalizeScriptProcessing(isCallback);
 }
}
ASPx.FinalizeScriptProcessing = function(isCallback) {
 createdIncludeScripts = [];
 appendedScriptsCount = 0;
 var linkProcessor = getLinkProcessor();
 if(linkProcessor.hasLinks())
  _aspxSweepDuplicatedLinks();
 linkProcessor.reset();
 _aspxSweepDuplicatedScripts();
 _aspxRunStartupScripts(isCallback);
 ResourceManager.SynchronizeResources();
}
var startupScriptsRunning = false;
function _aspxRunStartupScripts(isCallback) {
 startupScriptsRunning = true;
 try {
  _aspxRunStartupScriptsCore();
 }
 finally {
  startupScriptsRunning = false;
 }
 if(ASPx.documentLoaded) {
  ASPx.GetControlCollection().InitializeElements(isCallback);
  for(var key in scriptsRestartHandlers)
   scriptsRestartHandlers[key]();
  _aspxRunEndCallbackScript();
 }
}
function _aspxIsStartupScriptsRunning(isCallback) {
 return startupScriptsRunning;
}
function _aspxRunStartupScriptsCore() {
 var scripts = _aspxGetStartupScripts();
 var code;
 for(var i = 0; i < scripts.length; i++){
  if(!scripts[i].executed) {
   code = ASPx.GetScriptCode(scripts[i]);
   eval(code);
   scripts[i].executed = true;
  }
 }
}
function _aspxRunEndCallbackScript() {
 while(callbackOwnerNames.length > 0) {
  var callbackOwnerName = callbackOwnerNames.pop();
  var callbackOwner = ASPx.GetControlCollection().Get(callbackOwnerName);
  if(callbackOwner)
   callbackOwner.DoEndCallback();
 }
}
ASPx.OnScriptReadyStateChangedCallback = function(scriptElement, isCallback) {
 if(scriptElement.readyState == "loaded") {
  _aspxCacheIncludeScript(scriptElement);
  for(var i = 0; i < createdIncludeScripts.length; i++) {
   var script = createdIncludeScripts[i];
   if(_aspxIsKnownIncludeScript(script)) {
    if(!script.executed) {
     script.executed = true;
     ASPx.AppendScript(script);
     appendedScriptsCount++;
    }
   } else
    break;
  }
  if(createdIncludeScripts.length == appendedScriptsCount)
   ASPx.FinalizeScriptProcessing(isCallback);
 }
}
ASPx.OnScriptLoadCallback = function(scriptElement, isCallback) {
 appendedScriptsCount++;
 if(scriptElement.nextCreatedScript) {
  ASPx.AppendScript(scriptElement.nextCreatedScript);
  _aspxCacheIncludeScript(scriptElement.nextCreatedScript);
 }
 if(createdIncludeScripts.length == appendedScriptsCount)
  ASPx.FinalizeScriptProcessing(isCallback);
}
function _aspxAddScriptsRestartHandler(objectName, handler) {
 scriptsRestartHandlers[objectName] = handler;
}
function _aspxMoveLinkElements() {
 var head = ASPx.GetNodesByTagName(document, "head")[0];
 var bodyLinks = ASPx.GetNodesByTagName(document.body, "link");
 if(head && bodyLinks.length > 0){
  var headLinks = ASPx.GetNodesByTagName(head, "link");
  var dxLinkAnchor = head.firstChild;
  for(var i = 0; i < headLinks.length; i++){
   if(headLinks[i].href.indexOf(ResourceManager.HandlerStr) > -1)
    dxLinkAnchor = headLinks[i].nextSibling;
  }
  while(bodyLinks.length > 0) 
   head.insertBefore(bodyLinks[0], dxLinkAnchor);
 }
}
var LinkProcessor = ASPx.CreateClass(null, {
 constructor: function() {
  this.loadedLinkCount = 0;
  this.linkInfos = [];
  this.loadingObservationTimerID = -1;
 },
 process: function() {
  if(this.hasLinks()) {
   if(this.isLinkLoadEventSupported())
    this.processViaLoadEvent();
   else
    this.processViaTimer();
  }
  else
   _aspxSweepDuplicatedLinks();
  _aspxMoveLinkElements();
 },
 addLinks: function(links) {
  var prevLinkCount = this.linkInfos.length;
  for(var i = 0; i < links.length; i++) {
   var link = links[i];
   if(link.loaded || link.rel != "stylesheet" || link.type != "text/css" || link.href.toLowerCase().indexOf("dxr.axd?r=") == -1)
    continue;
   var linkInfo = {
    link: link,
    href: link.href
   };
   this.linkInfos.push(linkInfo);
  }
  return prevLinkCount != this.linkInfos.length;
 },
 hasLinks: function() {
  return this.linkInfos.length > 0;
 },
 reset: function() {
  this.linkInfos = [];
  this.loadedLinkCount = 0;
 },
 processViaLoadEvent: function() {
  for(var i = 0, linkInfo; linkInfo = this.linkInfos[i]; i++) {
   if(ASPx.Browser.IE && ASPx.Browser.Version < 9) {
    var that = this;
    linkInfo.link.onreadystatechange = function() { that.onLinkReadyStateChanged(this); };
   }
   else
    linkInfo.link.onload = this.onLinkLoad.aspxBind(this);
  }
 },
 isLinkLoadEventSupported: function() {
  return !(ASPx.Browser.Chrome && ASPx.Browser.MajorVersion < 19 || ASPx.Browser.Firefox && ASPx.Browser.MajorVersion < 9 ||
   ASPx.Browser.Safari && ASPx.Browser.MajorVersion < 6 || ASPx.Browser.AndroidDefaultBrowser && ASPx.Browser.MajorVersion < 4.4);
 },
 processViaTimer: function() {
  if(this.loadingObservationTimerID == -1)
   this.onLinksLoadingObserve();
 },
 onLinksLoadingObserve: function() {
  if(this.getIsAllLinksLoaded()) {
   this.loadingObservationTimerID = -1;
   this.onAllLinksLoad();
  }
  else
   this.loadingObservationTimerID = window.setTimeout(this.onLinksLoadingObserve.aspxBind(this), 100);
 },
 getIsAllLinksLoaded: function() {
  var styleSheets = document.styleSheets;
  var loadedLinkHrefs = { };
  for(var i = 0; i < styleSheets.length; i++) {
   var styleSheet = styleSheets[i];
   try {
    if(styleSheet.cssRules)
     loadedLinkHrefs[styleSheet.href] = 1;
   }
   catch(ex) { }
  }
  var loadedLinksCount = 0;
  for(var i = 0, linkInfo; linkInfo = this.linkInfos[i]; i++) {
   if(loadedLinkHrefs[linkInfo.href])
    loadedLinksCount++;
  }
  return loadedLinksCount == this.linkInfos.length;
 },
 onAllLinksLoad: function() {
  this.reset();
  _aspxSweepDuplicatedLinks();
  if(createdIncludeScripts.length == 0)
   ASPx.FinalizeScriptProcessing(true);
 },
 onLinkReadyStateChanged: function(linkElement) {
  if(linkElement.readyState == "complete")
   this.onLinkLoadCore(linkElement);
 },
 onLinkLoad: function(evt) {
  var linkElement = ASPx.Evt.GetEventSource(evt);
  this.onLinkLoadCore(linkElement);
 },
 onLinkLoadCore: function(linkElement) {
  if(!this.hasLinkElement(linkElement)) return;
  this.loadedLinkCount++;
  if(!ASPx.Browser.Firefox && this.loadedLinkCount == this.linkInfos.length || 
   ASPx.Browser.Firefox && this.loadedLinkCount == 2 * this.linkInfos.length) {
   this.onAllLinksLoad();
  }
 },
 hasLinkElement: function(linkElement) {
  for(var i = 0, linkInfo; linkInfo = this.linkInfos[i]; i++) {
   if(linkInfo.link == linkElement)
    return true;
  }
  return false;
 }
});
var linkProcessor = null;
function getLinkProcessor() {
 if(linkProcessor == null)
  linkProcessor = new LinkProcessor();
 return linkProcessor;
}
var IFrameHelper = ASPx.CreateClass(null, {
 constructor: function(params) {
  this.params = params || {};
  this.params.src = this.params.src || "";
  this.CreateElements();
 },
 CreateElements: function() {
  var elements = IFrameHelper.Create(this.params);
  this.containerElement = elements.container;
  this.iframeElement = elements.iframe;
  this.AttachOnLoadHandler(this, this.iframeElement);
  this.SetLoading(true);
  if(this.params.onCreate)
   this.params.onCreate(this.containerElement, this.iframeElement);
 },
 AttachOnLoadHandler: function(instance, element) {
  ASPx.Evt.AttachEventToElement(element, "load", function() {
   instance.OnLoad(element);
  });
 },
 OnLoad: function(element) {
  this.SetLoading(false, element);
  if(!element.preventCustomOnLoad && this.params.onLoad)
   this.params.onLoad();
 },
 IsLoading: function(element) {
  element = element || this.iframeElement;
  if(element)
   return element.loading;
  return false;
 },
 SetLoading: function(value, element) {
  element = element || this.iframeElement;
  if(element)
   element.loading = value;
 },
 GetContentUrl: function() {
  return this.params.src;
 },
 SetContentUrl: function(url, preventBrowserCaching) {
  if(url) {
   this.params.src = url;
   if(preventBrowserCaching)
    url = IFrameHelper.AddRandomParamToUrl(url);
   this.SetLoading(true);
   this.iframeElement.src = url;
  }
 },
 RefreshContentUrl: function() {
  if(this.IsLoading())
   return;
  this.SetLoading(true);
  var oldContainerElement = this.containerElement;
  var oldIframeElement = this.iframeElement;
  var postfix = "_del" + Math.floor(Math.random()*100000).toString();
  if(this.params.id)
   oldIframeElement.id = this.params.id + postfix;
  if(this.params.name)
   oldIframeElement.name = this.params.name + postfix;
  ASPx.SetStyles(oldContainerElement, { height: 0 });
  this.CreateElements();
  oldIframeElement.preventCustomOnLoad = true;
  oldIframeElement.src = ASPx.BlankUrl;
  window.setTimeout(function() {
   oldContainerElement.parentNode.removeChild(oldContainerElement);
  }, 10000); 
 }
});
IFrameHelper.Create = function(params) {
 var iframeHtmlStringParts = [ "<iframe frameborder='0'" ];
 if(params) {
  if(params.id)
   iframeHtmlStringParts.push(" id='", params.id, "'");
  if(params.name)
   iframeHtmlStringParts.push(" name='", params.name, "'");
  if(params.title)
   iframeHtmlStringParts.push(" title='", params.title, "'");
  if(params.scrolling)
   iframeHtmlStringParts.push(" scrolling='", params.scrolling, "'");
  if(params.src)
   iframeHtmlStringParts.push(" src='", params.src, "'");
 }
 iframeHtmlStringParts.push("></iframe>");
 var containerElement = ASPx.CreateHtmlElementFromString("<div style='border-width: 0px; padding: 0px; margin: 0px'></div>");
 var iframeElement = ASPx.CreateHtmlElementFromString(iframeHtmlStringParts.join(""));
 containerElement.appendChild(iframeElement);
 return {
  container: containerElement,
  iframe: iframeElement
 };
};
IFrameHelper.AddRandomParamToUrl = function(url) {
 var prefix = url.indexOf("?") > -1
  ? "&"
  : "?";
 var param = prefix + Math.floor(Math.random()*100000).toString();
 var anchorIndex = url.indexOf("#");
 return anchorIndex == -1
  ? url + param
  : url.substr(0, anchorIndex) + param + url.substr(anchorIndex);
};
IFrameHelper.GetWindow = function(name) {
 if(ASPx.Browser.IE)
  return window.frames[name].window;
 else{
  var frameElement = document.getElementById(name);
  return (frameElement != null) ? frameElement.contentWindow : null;
 }
};
IFrameHelper.GetDocument = function(name) {
 var frameElement;
 if(ASPx.Browser.IE) {
  frameElement = window.frames[name];
  return (frameElement != null) ? frameElement.document : null;
 }
 else {
  frameElement = document.getElementById(name);
  return (frameElement != null) ? frameElement.contentDocument : null;
 }
};
IFrameHelper.GetDocumentBody = function(name) {
 var doc = IFrameHelper.GetDocument(name);
 return (doc != null) ? doc.body : null;
};
IFrameHelper.GetDocumentHead = function (name) {
 var doc = IFrameHelper.GetDocument(name);
 return (doc != null) ? doc.head || doc.getElementsByTagName('head')[0] : null;
};
IFrameHelper.GetElement = function(name) {
 if(ASPx.Browser.IE)
  return window.frames[name].window.frameElement;
 else
  return document.getElementById(name);
};
var KbdHelper = ASPx.CreateClass(null, {
 constructor: function(control) {
  this.control = control;
 },
 Init: function() {
  KbdHelper.GlobalInit();
  var elements = this.getFocusableElements();
  for(var i = 0; i < elements.length; i++) {
   var element = elements[i];
   element.tabIndex = Math.max(element.tabIndex, 0);
   var instance = this;
   ASPx.Evt.AttachEventToElement(element, "click", function(e) {
    instance.HandleClick(e);
   });  
   ASPx.Evt.AttachEventToElement(element, "focus", function(e) {    
    if(!instance.CanFocus(e))
     return true;
    KbdHelper.active = instance;
   });
   ASPx.Evt.AttachEventToElement(element, "blur", function () {
    instance.onBlur();
   }); 
  }   
 },
 getFocusableElements: function() {
  return [this.GetFocusableElement()]; 
 },
 GetFocusableElement: function() { return this.control.GetMainElement(); },
 canHandleNoFocusAction: function() { 
  var focusableElements = this.getFocusableElements();
  for(var i = 0; i < focusableElements.length; i++) {
   if(focusableElements[i] === _aspxGetFocusedElement())
    return false;
  }
  return true;
 },
 CanFocus: function(e) {
  var tag = ASPx.Evt.GetEventSource(e).tagName;
  if(tag == "A" || tag == "TEXTAREA" || tag == "INPUT" || tag == "SELECT" || tag == "IFRAME" || tag == "OBJECT")
   return false; 
  return true;
 },
 HandleClick: function(e) {
  if(!this.CanFocus(e))
   return;
  this.Focus();
 },
 Focus: function() {
  try {
   this.GetFocusableElement().focus();   
  } catch(e) {
  }
 },
 onBlur: function(){
  delete KbdHelper.active;
 },
 HandleKeyDown: function(e) { }, 
 HandleKeyPress: function(e) { }, 
 HandleKeyUp: function (e) { },
 HandleNoFocusAction: function(e) { },
 FocusByAccessKey: function () { }
});
KbdHelper.GlobalInit = function() {
 if(KbdHelper.ready)
  return;
 ASPx.Evt.AttachEventToDocument("keydown", KbdHelper.OnKeyDown);
 ASPx.Evt.AttachEventToDocument("keypress", KbdHelper.OnKeyPress);
 ASPx.Evt.AttachEventToDocument("keyup", KbdHelper.OnKeyUp);
 KbdHelper.ready = true; 
};
KbdHelper.swallowKey = false;
KbdHelper.accessKeys = { };
KbdHelper.ProcessKey = function(e, actionName) {
 if(!KbdHelper.active) 
  return;
 if (KbdHelper.active.canHandleNoFocusAction()) {
  KbdHelper.active["HandleNoFocusAction"](e, actionName);
  return;
 }
 var ctl = KbdHelper.active.control;
 if(ctl !== ASPx.GetControlCollection().Get(ctl.name)) {
  delete KbdHelper.active;
  return;
 }
 if(!KbdHelper.swallowKey) 
  KbdHelper.swallowKey = KbdHelper.active[actionName](e);
 if(KbdHelper.swallowKey)
  ASPx.Evt.PreventEvent(e);
};
KbdHelper.OnKeyDown = function(e) {
 KbdHelper.swallowKey = false;
 if(KbdHelper.TryAccessKey(KbdHelper.getKeyName(e)))
  ASPx.Evt.PreventEvent(e);
 else if(e.ctrlKey && e.shiftKey && KbdHelper.TryAccessKey(ASPx.Evt.GetKeyCode(e)))
  ASPx.Evt.PreventEvent(e);
 else 
  KbdHelper.ProcessKey(e, "HandleKeyDown"); 
};
KbdHelper.OnKeyPress = function(e) { KbdHelper.ProcessKey(e, "HandleKeyPress"); };
KbdHelper.OnKeyUp = function(e) { KbdHelper.ProcessKey(e, "HandleKeyUp"); };
KbdHelper.RegisterAccessKey = function(obj) {
 var key = obj.accessKey || obj.keyTipModeShortcut;
 if(!key) return;
 KbdHelper.accessKeys[key.toLowerCase()] = obj.name;
};
KbdHelper.TryAccessKey = function(code) {
 var key = code.toLowerCase ? code.toLowerCase() : String.fromCharCode(code).toLowerCase();
 var name = KbdHelper.accessKeys[key];
 if(!name) return false;
 var obj = ASPx.GetControlCollection().Get(name);
 return KbdHelper.ClickAccessKey(obj);
};
KbdHelper.ClickAccessKey = function (control) {
 if (!control) return false;
 var el = control.GetMainElement();
 if (!el) return false;
 el.focus();
 setTimeout(function () {
  if (KbdHelper.active && KbdHelper.active.FocusByAccessKey)
   KbdHelper.active.FocusByAccessKey();
 }.aspxBind(this), 100);
 return true;
};
KbdHelper.getKeyName = function(e) {
 var name = "";
 if(e.altKey)
  name += "Alt";
 if(e.ctrlKey)
  name += "Ctrl";
 if(e.shiftKey)
  name += "Shift";
 var keyCode = e.key || e.code || String.fromCharCode(ASPx.Evt.GetKeyCode(e));
 if(keyCode.match(/key/i))
  name += keyCode.replace(/key/i, "");
 else if(keyCode.match(/digit/i))
  name += keyCode.replace(/digit/i, "");
 else if(keyCode.match(/arrow/i))
  name += keyCode.replace(/arrow/i, "");
 else if(keyCode.match(/ins/i))
  name += "Ins"
 else if(keyCode.match(/del/i))
  name += "Del"
 else if(keyCode.match(/back/i))
  name += "Back"
 else if(!keyCode.match(/alt/i) && !keyCode.match(/control/i) && !keyCode.match(/shift/i))
  name += keyCode;
 return name.replace(/^a-zA-Z0-9/, "");
};
AccessKeysHelper = ASPx.CreateClass(KbdHelper, {
 constructor: function (control) {
  this.constructor.prototype.constructor.call(this, control);
  this.accessKeysVisible = false;
  this.activeKey = null;
  this.accessKey = new AccessKey(control.accessKey);
  this.accessKeys = this.accessKey.accessKeys;
  this.charIndex = 0;
  this.onFocusByAccessKey = null;
  this.onClose = null;
  this.manualStopProcessing = false;
  this.isActive = false;
 },
 Init: function (control) {
  KbdHelper.prototype.Init.call(this);
  KbdHelper.RegisterAccessKey(control);   
 },
 Add: function (accessKey) {
  this.accessKey.Add(accessKey);
 },
 HandleKeyDown: function (e) {
  var control = this.control;
  var keyCode = ASPx.Evt.GetKeyCode(e);
  var restoreFocus = false;
  var stopProcessing = this.processKeyDown(keyCode);
  if (stopProcessing) {
   this.stopProcessing();
   if (this.onClosedOnEscape && keyCode == ASPx.Key.Esc)
    this.onClosedOnEscape();
  }
  return stopProcessing;
 },
 HandleNoFocusAction: function (e, actionName) {
  var keyCode = ASPx.Evt.GetKeyCode(e);
  if (this.onClosedOnEscape && keyCode == ASPx.Key.Esc && actionName == "HandleKeyDown")
   this.onClosedOnEscape();
 },
 Activate: function () {
  KbdHelper.ClickAccessKey(this.control);
 },
 Stop: function() {
  this.stopProcessing();
 },
 stopProcessing: function () {
  this.HideAccessKeys();
  if (KbdHelper.active && this.isActive) {
   this.isActive = false;
   KbdHelper.active.control.GetMainElement().blur();
   delete KbdHelper.active;
  }
 },
 onBlur: function () {
  if (this.manualStopProcessing) {
   this.manualStopProcessing = false;
   return;
  }
  this.HideAccessKeys();
  KbdHelper.prototype.onBlur.call(this);
 },
 processKeyDown: function (keyCode) {
  switch (keyCode) {
   case ASPx.Key.Left:
    this.TryMoveFocusLeft();
    return false;
   case ASPx.Key.Right:
    this.TryMoveFocusRight();
    return false;
   case ASPx.Key.Esc:
    if(this.control.hideAllPopups)
     this.control.hideAllPopups(true, true);
    this.activeKey = this.activeKey.Return();
    this.charIndex = 0;
    if (!this.activeKey)
     return true;
    break;
   case ASPx.Key.Enter:
    return true;
   default:
    var char = String.fromCharCode(keyCode).toUpperCase();
    var needToContinue = { value: false };
    if(this.activeKey)
     var keyResult = this.activeKey.TryAccessKey(char, this.charIndex, needToContinue);
    if (needToContinue.value) {
     this.charIndex++;
     return false;
    }
    this.charIndex = 0;
    if(keyResult !== undefined)
     this.activeKey = keyResult;    
    if (!this.activeKey || !this.activeKey.accessKeys || this.activeKey.accessKeys.length == 0) {
     if (this.activeKey && this.activeKey.manualStopProcessing) {
      this.manualStopProcessing = true;
      break;
     }
     return true;
    }
  }
  return false;
 },
 TryMoveFocusLeft: function (modifier) {},
 TryMoveFocusRight: function (modifier) {},
 TryMoveFocusUp: function (modifier) {},
 TryMoveFocusDown: function (modifier) {},
 FocusByAccessKey: function () {
  if (this.onFocusByAccessKey)
   this.onFocusByAccessKey();
  this.HideAccessKeys();
  KbdHelper.prototype.FocusByAccessKey.call(this);
  this.activeKey = this.accessKey;
  this.activeKey.execute();
  this.isActive = true;
 },
 HideAccessKeys: function(){
  this.hideAccessKeys(this.accessKey);
 }, 
 hideAccessKeys: function (accessKey) {
  for (var i = 0, ak; ak = accessKey.accessKeys[i]; i++) {
   this.hideAccessKeys(ak);
  }
  if (accessKey)
   accessKey.hide();
 },
 HandleClick: function(e) {
  KbdHelper.prototype.HandleClick.call(this, e);
  this.stopProcessing();
 }
});
AccessKey = ASPx.CreateClass(null, {
 constructor: function (popupItem, getPopupElement, keyTipElement, key, onlyClick, manualStopProcessing) {
  this.key = key ? key : keyTipElement ? ASPxClientUtils.Trim(ASPx.GetInnerText(keyTipElement)) : null;
  this.popupItem = popupItem;
  this.getPopupElement = getPopupElement;
  this.keyTipElement = keyTipElement;
  this.accessKeys = [];
  this.needShowChilds = true;
  this.parent = null;
  this.onlyClick = onlyClick;
  this.manualStopProcessing = manualStopProcessing;
 },
 Add: function (accessKey) {
  this.accessKeys.push(accessKey);
  accessKey.parent = this;
 },
 TryAccessKey: function (char, index, needToContinue) {
  if (!this.accessKeys || this.accessKeys.length == 0)
   return;
  for (var i = 0, accessKey; accessKey = this.accessKeys[i]; i++) {
   if (accessKey.key[index] == char && accessKey.isVisible()) {
    if (accessKey.key[index + 1]) {
     needToContinue.value = true;
    }
    else {
     accessKey.execute();
     return accessKey;
    }
   } else {
    accessKey.hide();
   }
  }
  for (var i = 0, accessKey; accessKey = this.accessKeys[i]; i++) {
   var key = accessKey.TryAccessKey(char, index, needToContinue);
   if (key)
    return key;
  }
  return;
 },
 isVisible: function(){
  return ASPx.GetElementVisibility(this.keyTipElement);
 },
 Return: function () {
  this.hideChildAccessKeys();
  if (this.parent) {
   this.parent.showAccessKeys(true);
  }  
  return this.parent;
 },
 execute: function () {
  this.hideAll();
  if (this.popupItem && this.popupItem.accessKeyClick && !this.onlyClick)
   this.popupItem.accessKeyClick();
  if (this.getPopupElement && this.onlyClick)
   ASPx.Evt.EmulateMouseClick(this.getPopupElement());
  if (this.accessKeys)
   setTimeout(function () {
    this.showAccessKeys(true);
   }.aspxBind(this), 100);
 },
 showAccessKeys: function (directShow) {
  if (!directShow && !this.needShowChilds)
   return;
  for (var i = 0; i < this.accessKeys.length; i++) {
   var accessKey = this.accessKeys[i];
   if (accessKey) {
    var popupElement = accessKey.getPopupElement ? accessKey.getPopupElement() : null;
    if (popupElement && ASPx.IsElementVisible(popupElement, true)) {
     this.show(accessKey);
    }
    accessKey.showAccessKeys();
   }
  }
 },
 show: function (accessKey) {
  var keyTipElement = accessKey.keyTipElement;
  var popupElement = accessKey.getPopupElement();
  var top = ASPx.GetAbsolutePositionY(popupElement);
  var left = ASPx.GetAbsolutePositionX(popupElement);
  if (accessKey.popupItem.getAccessKeyPosition)
   switch (accessKey.popupItem.getAccessKeyPosition()) {
    case "AboveRight":
     left = left + popupElement.offsetWidth - keyTipElement.offsetWidth / 3;
     top = top - keyTipElement.offsetHeight / 2;
     break;
    case "Right":
     left = left + popupElement.offsetWidth - keyTipElement.offsetWidth / 3;
     top = top + popupElement.offsetHeight / 2 - keyTipElement.offsetHeight / 2;
     break;
    case "BelowRight":
     left = left + popupElement.offsetWidth - keyTipElement.offsetWidth / 3;
     top = top + keyTipElement.offsetHeight / 2;
     break;
    default:
     top = top + popupElement.offsetHeight;
     left = left + popupElement.offsetWidth / 2 - keyTipElement.offsetWidth / 2;
     break;
   }
  else {
   top = top + popupElement.offsetHeight;
   left = left + popupElement.offsetWidth / 2 - keyTipElement.offsetWidth / 2;
  }
  ASPx.SetAbsoluteY(keyTipElement, top);
  ASPx.SetAbsoluteX(keyTipElement, left);
  ASPx.SetElementVisibility(keyTipElement, true); 
 },
 hide: function () {
  if (this.keyTipElement)
   ASPx.SetElementVisibility(this.keyTipElement, false);
 },
 hideChildAccessKeys: function () {
  this.hideAccessKeys(this.accessKeys);
 },
 hideAccessKeys: function (accessKeys) {
  if (accessKeys) {
   for (var i = 0, accessKey; accessKey = accessKeys[i]; i++) {
    if (accessKey.keyTipElement)
     accessKey.hide();
    accessKey.hideChildAccessKeys();
   }
  }
 },
 hideAll: function () {
  this.getRoot(this).hideChildAccessKeys();
 },
 getRoot: function (accessKey) {
  if (!accessKey.parent)
   return accessKey;
  return this.getRoot(accessKey.parent);
 }
});
var focusedElement = null;
function aspxOnElementFocused(evt) {
 evt = ASPx.Evt.GetEvent(evt);
 if(evt && evt.target)
  focusedElement = evt.target;
}
function _aspxInitializeFocus() {
 if(!ASPx.GetActiveElement())
  ASPx.Evt.AttachEventToDocument("focus", aspxOnElementFocused);
}
function _aspxGetFocusedElement() {
 var activeElement = ASPx.GetActiveElement();
 return activeElement ? activeElement : focusedElement;
}
CheckBoxCheckState = {
 Checked : "Checked",
 Unchecked : "Unchecked",
 Indeterminate : "Indeterminate"
};
CheckBoxInputKey = { 
 Checked : "C",
 Unchecked : "U",
 Indeterminate : "I"
};
var CheckableElementStateController = ASPx.CreateClass(null, {
 constructor: function(imageProperties) {
  this.checkBoxStates = [];
  this.imageProperties = imageProperties;
 },
 GetValueByInputKey: function(inputKey) {
  return this.GetFirstValueBySecondValue("Value", "StateInputKey", inputKey);
 },
 GetInputKeyByValue: function(value) {
  return this.GetFirstValueBySecondValue("StateInputKey", "Value", value);
 },
 GetImagePropertiesNumByInputKey: function(value) {
  return this.GetFirstValueBySecondValue("ImagePropertiesNumber", "StateInputKey", value);
 },
 GetNextCheckBoxValue: function(currentValue, allowGrayed) {
  var currentInputKey = this.GetInputKeyByValue(currentValue);
  var nextInputKey = '';
  switch(currentInputKey) {
   case CheckBoxInputKey.Checked:
    nextInputKey = CheckBoxInputKey.Unchecked; break;
   case CheckBoxInputKey.Unchecked:
    nextInputKey = allowGrayed ? CheckBoxInputKey.Indeterminate : CheckBoxInputKey.Checked; break;
   case CheckBoxInputKey.Indeterminate:
    nextInputKey = CheckBoxInputKey.Checked; break;
  }
  return this.GetValueByInputKey(nextInputKey);
 },
 GetCheckStateByInputKey: function(inputKey) {
  switch(inputKey) {
   case CheckBoxInputKey.Checked: 
    return CheckBoxCheckState.Checked;
   case CheckBoxInputKey.Unchecked: 
    return CheckBoxCheckState.Unchecked;
   case CheckBoxInputKey.Indeterminate: 
    return CheckBoxCheckState.Indeterminate;
  }
 },
 GetValueByCheckState: function(checkState) {
  switch(checkState) {
   case CheckBoxCheckState.Checked: 
    return this.GetValueByInputKey(CheckBoxInputKey.Checked);
   case CheckBoxCheckState.Unchecked: 
    return this.GetValueByInputKey(CheckBoxInputKey.Unchecked);
   case CheckBoxCheckState.Indeterminate: 
    return this.GetValueByInputKey(CheckBoxInputKey.Indeterminate);
  }
 },
 GetFirstValueBySecondValue: function(firstValueName, secondValueName, secondValue) {
  return this.GetValueByFunc(firstValueName, 
   function(checkBoxState) { return checkBoxState[secondValueName] === secondValue; });
 },
 GetValueByFunc: function(valueName, func) {
  for(var i = 0; i < this.checkBoxStates.length; i++) {
   if(func(this.checkBoxStates[i]))
    return this.checkBoxStates[i][valueName];
  }  
 },
 AssignElementClassName: function(element, cssClassPropertyKey, disabledCssClassPropertyKey, assignedClassName) {
  var classNames = [ ];
  for(var i = 0; i < this.imageProperties[cssClassPropertyKey].length; i++) {
   classNames.push(this.imageProperties[disabledCssClassPropertyKey][i]);
   classNames.push(this.imageProperties[cssClassPropertyKey][i]);
  }
  var elementClassName = element.className;
  for(var i = 0; i < classNames.length; i++) {
   var className = classNames[i];
   var index = elementClassName.indexOf(className);
   if(index > -1)
    elementClassName = elementClassName.replace((index == 0 ? '' : ' ') + className, "");
  }
  elementClassName += " " + assignedClassName;
  element.className = elementClassName;
 },
 UpdateInternalCheckBoxDecoration: function(mainElement, inputKey, enabled) {
  var imagePropertiesNumber = this.GetImagePropertiesNumByInputKey(inputKey);
  for(var imagePropertyKey in this.imageProperties) {
   var propertyValue = this.imageProperties[imagePropertyKey][imagePropertiesNumber];
   propertyValue = propertyValue || !isNaN(propertyValue) ? propertyValue : "";
   switch(imagePropertyKey) {
    case "0" : mainElement.title = propertyValue; break;
    case "1" : mainElement.style.width = propertyValue + (propertyValue != "" ? "px" : ""); break;
    case "2" : mainElement.style.height = propertyValue + (propertyValue != "" ? "px" : ""); break;
   }
   if(enabled) {
    switch(imagePropertyKey) {
     case "3" : this.SetImageSrc(mainElement, propertyValue); break;
     case "4" : 
      this.AssignElementClassName(mainElement, "4", "8", propertyValue);
      break;
     case "5" : this.SetBackgroundPosition(mainElement, propertyValue, true); break;
     case "6" : this.SetBackgroundPosition(mainElement, propertyValue, false); break;
    }
   } else {
     switch(imagePropertyKey) {
     case "7" : this.SetImageSrc(mainElement, propertyValue); break;
     case "8" : 
      this.AssignElementClassName(mainElement, "4", "8", propertyValue);
      break;
     case "9" : this.SetBackgroundPosition(mainElement, propertyValue, true); break;
     case "10" : this.SetBackgroundPosition(mainElement, propertyValue, false); break;
    }
   }
  }
 },
 SetImageSrc: function(mainElement, src) {
  if(src === ""){
   mainElement.style.backgroundImage = "";
   mainElement.style.backgroundPosition = "";
  }
  else{
   mainElement.style.backgroundImage = "url('" + src + "')";
   this.SetBackgroundPosition(mainElement, 0, true);
   this.SetBackgroundPosition(mainElement, 0, false);
  }
 },
 SetBackgroundPosition: function(element, value, isX) {
  if(value === "") {
   element.style.backgroundPosition = value;
   return;
  }
  if(element.style.backgroundPosition === "")
   element.style.backgroundPosition = isX ? "-" + value.toString() + "px 0px" : "0px -" + value.toString() + "px";
  else {
   var position = element.style.backgroundPosition.split(' ');
   element.style.backgroundPosition = isX ? '-' + value.toString() + "px " + position[1] :  position[0] + " -" + value.toString() + "px";
  }
 },
 AddState: function(value, stateInputKey, imagePropertiesNumber) {
  this.checkBoxStates.push({
   "Value" : value, 
   "StateInputKey" : stateInputKey, 
   "ImagePropertiesNumber" : imagePropertiesNumber
  });
 },
 GetAriaCheckedValue: function(state) {
  switch(state) {
   case ASPx.CheckBoxCheckState.Checked: return "true";
   case ASPx.CheckBoxCheckState.Unchecked: return "false";
   case ASPx.CheckBoxCheckState.Indeterminate: return "mixed";
   default: return "";
  }
 }
});
CheckableElementStateController.Create = function(imageProperties, valueChecked, valueUnchecked, valueGrayed, allowGrayed) {
 var stateController = new CheckableElementStateController(imageProperties);
 stateController.AddState(valueChecked, CheckBoxInputKey.Checked, 0);
 stateController.AddState(valueUnchecked, CheckBoxInputKey.Unchecked, 1);
 if(typeof(valueGrayed) != "undefined")
  stateController.AddState(valueGrayed, CheckBoxInputKey.Indeterminate, allowGrayed ? 2 : 1);
 stateController.allowGrayed = allowGrayed;
 return stateController;
};
var CheckableElementHelper = ASPx.CreateClass(null, {
 InternalCheckBoxInitialize: function(internalCheckBox) {
  this.AttachToMainElement(internalCheckBox);
  this.AttachToInputElement(internalCheckBox);
 },
 AttachToMainElement: function(internalCheckBox) {
  var instance = this;
  if(internalCheckBox.mainElement) {
    ASPx.Evt.AttachEventToElement(internalCheckBox.mainElement, "click",
    function (evt) { 
     instance.InvokeClick(internalCheckBox, evt);
     if(!internalCheckBox.disableCancelBubble)
      return ASPx.Evt.PreventEventAndBubble(evt);
    }
   );
   ASPx.Evt.AttachEventToElement(internalCheckBox.mainElement, "mousedown",
    function (evt) {
     internalCheckBox.Refocus();
    }
   );
   ASPx.Evt.PreventElementDragAndSelect(internalCheckBox.mainElement, true);
  }
 },
 AttachToInputElement: function(internalCheckBox) {
  var instance = this;
  if(internalCheckBox.inputElement && internalCheckBox.mainElement) {
   var checkableElement = internalCheckBox.accessibilityCompliant ? internalCheckBox.mainElement : internalCheckBox.inputElement;
   ASPx.Evt.AttachEventToElement(checkableElement, "focus",
    function (evt) { 
     if(!internalCheckBox.enabled)
      checkableElement.blur();
     else
      internalCheckBox.OnFocus();
    }
   );
   ASPx.Evt.AttachEventToElement(checkableElement, "blur", 
    function (evt) { 
     internalCheckBox.OnLostFocus();
    }
   );
   ASPx.Evt.AttachEventToElement(checkableElement, "keyup",
    function (evt) { 
     if(ASPx.Evt.GetKeyCode(evt) == ASPx.Key.Space)
      instance.InvokeClick(internalCheckBox, evt);
    }
   );
   ASPx.Evt.AttachEventToElement(checkableElement, "keydown",
    function (evt) { 
     if(ASPx.Evt.GetKeyCode(evt) == ASPx.Key.Space)
      return ASPx.Evt.PreventEvent(evt);
    }
   );
  }
 },
 IsKBSInputWrapperExist: function() {
  return ASPx.Browser.Opera || ASPx.Browser.WebKitFamily;
 },
 GetICBMainElementByInput: function(icbInputElement) {
  return this.IsKBSInputWrapperExist() ? icbInputElement.parentNode.parentNode : icbInputElement.parentNode;
 },
 InvokeClick: function(internalCheckBox, evt) {
   if(internalCheckBox.enabled && !internalCheckBox.readOnly) {
   var inputElementValue = internalCheckBox.inputElement.value;
   var focusableElement = internalCheckBox.accessibilityCompliant ? internalCheckBox.mainElement : internalCheckBox.inputElement; 
   focusableElement.focus();
   if(!ASPx.Browser.IE) 
    internalCheckBox.inputElement.value = inputElementValue;
   this.InvokeClickCore(internalCheckBox, evt)
   }
 },
 InvokeClickCore: function(internalCheckBox, evt) {
  internalCheckBox.OnClick(evt);
 }
});
CheckableElementHelper.Instance = new CheckableElementHelper();
var CheckBoxInternal = ASPx.CreateClass(null, {
 constructor: function(inputElement, stateController, allowGrayed, allowGrayedByClick, helper, container, storeValueInInput, key, disableCancelBubble,
  accessibilityCompliant) {
  this.inputElement = inputElement;
  this.mainElement = helper.GetICBMainElementByInput(this.inputElement);
  this.name = (key ? key : this.inputElement.id) + CheckBoxInternal.GetICBMainElementPostfix();
  this.mainElement.id = this.name;
  this.stateController = stateController;
  this.container = container;
  this.allowGrayed = allowGrayed;
  this.allowGrayedByClick = allowGrayedByClick;
  this.autoSwitchEnabled = true;
  this.storeValueInInput = !!storeValueInInput;
  this.storedInputKey = !this.storeValueInInput ? this.inputElement.value : null;
  this.disableCancelBubble = !!disableCancelBubble;
  this.accessibilityCompliant = accessibilityCompliant;
  this.focusDecoration = null;
  this.focused = false;
  this.focusLocked = false;
  this.enabled = !this.mainElement.className.match(/dxWeb_\w+Disabled(\b|_)/);
  this.readOnly = false;
  this.CheckedChanged = new ASPxClientEvent();
  this.Focus = new ASPxClientEvent();
  this.LostFocus = new ASPxClientEvent();
  helper.InternalCheckBoxInitialize(this);
 },
 ChangeInputElementTabIndex: function() {  
  var changeMethod = this.enabled ? ASPx.Attr.RestoreTabIndexAttribute : ASPx.Attr.SaveTabIndexAttributeAndReset;
  changeMethod(this.inputElement);
 },
 CreateFocusDecoration: function(focusedStyle) {
   this.focusDecoration = new EditorStyleDecoration(this);
   this.focusDecoration.AddStyle('F', focusedStyle[0], focusedStyle[1]);
   this.focusDecoration.AddPostfix("");
 },
 UpdateFocusDecoration: function() {
  this.focusDecoration.Update();
 },  
 StoreInputKey: function(inputKey) {
  if(this.storeValueInInput)
   this.inputElement.value = inputKey;
  else
   this.storedInputKey = inputKey;
 },
 GetStoredInputKey: function() {
  if(this.storeValueInInput)
   return this.inputElement.value;
  else
   return this.storedInputKey;
 },
 OnClick: function(e) {
  if(this.autoSwitchEnabled) {
   var currentValue = this.GetValue();
   var value = this.stateController.GetNextCheckBoxValue(currentValue, this.allowGrayedByClick && this.allowGrayed);
   this.SetValue(value);
  }
  this.CheckedChanged.FireEvent(this, e);
 },
 OnFocus: function() {
  if(!this.IsFocusLocked()) {
   this.focused = true;
   this.UpdateFocusDecoration();
   this.Focus.FireEvent(this, null);
  } else
   this.UnlockFocus();
 },
 OnLostFocus: function() {
   if(!this.IsFocusLocked()) {
   this.focused = false;
   this.UpdateFocusDecoration();
   this.LostFocus.FireEvent(this, null);
  }
 },
 Refocus: function() {
  if(this.focused) {
   this.LockFocus();
   this.inputElement.blur();
   if(ASPx.Browser.MacOSMobilePlatform) {
    window.setTimeout(function() {
     ASPx.SetFocus(this.inputElement);
    }, 100);
   } else {
    ASPx.SetFocus(this.inputElement);
   }
  }
 },
 LockFocus: function() {
  this.focusLocked = true;
 },
 UnlockFocus: function() {
  this.focusLocked = false;
 },
 IsFocusLocked: function() {
  if(!!ASPx.Attr.GetAttribute(this.mainElement, ASPx.Attr.GetTabIndexAttributeName()))
   return false;
  return this.focusLocked;
 },
 SetValue: function(value) {
  var currentValue = this.GetValue();
  if(currentValue !== value) {
   var newInputKey = this.stateController.GetInputKeyByValue(value);
   if(newInputKey) {
    this.StoreInputKey(newInputKey);   
    this.stateController.UpdateInternalCheckBoxDecoration(this.mainElement, newInputKey, this.enabled);
   }
  }
  if(this.accessibilityCompliant) {
   var state = this.GetCurrentCheckState();
   var value = this.stateController.GetAriaCheckedValue(state);
   if(this.mainElement.attributes["aria-checked"] !== undefined)
    this.mainElement.setAttribute("aria-checked", value); 
   if(this.mainElement.attributes["aria-selected"] !== undefined)
    this.mainElement.setAttribute("aria-selected", value); 
  }
 },
 GetValue: function() {
  return this.stateController.GetValueByInputKey(this.GetCurrentInputKey());
 },
 GetCurrentCheckState: function() {
  return this.stateController.GetCheckStateByInputKey(this.GetCurrentInputKey());
 },
 GetCurrentInputKey: function() {
  return this.GetStoredInputKey();
 },
 GetChecked: function() {
  return this.GetCurrentInputKey() === CheckBoxInputKey.Checked;
 },
 SetChecked: function(checked) {
  var newValue = this.stateController.GetValueByCheckState(checked ? CheckBoxCheckState.Checked : CheckBoxCheckState.Unchecked);
  this.SetValue(newValue);
 },
 SetEnabled: function(enabled) {
  if(this.enabled != enabled) {
   this.enabled = enabled;
   this.stateController.UpdateInternalCheckBoxDecoration(this.mainElement, this.GetCurrentInputKey(), this.enabled);
   this.ChangeInputElementTabIndex();
  }
 },
 GetEnabled: function() {
  return this.enabled;
 }
});
CheckBoxInternal.GetICBMainElementPostfix = function() {
 return "_D";
};
var CheckBoxInternalCollection = ASPx.CreateClass(CollectionBase, {
 constructor: function(imageProperties, allowGrayed, storeValueInInput, helper, disableCancelBubble, accessibilityCompliant) {
  this.constructor.prototype.constructor.call(this);
  this.stateController = allowGrayed 
   ? CheckableElementStateController.Create(imageProperties, CheckBoxInputKey.Checked, CheckBoxInputKey.Unchecked, CheckBoxInputKey.Indeterminate, true)
   : CheckableElementStateController.Create(imageProperties, CheckBoxInputKey.Checked, CheckBoxInputKey.Unchecked);
  this.helper = helper || CheckableElementHelper.Instance;
  this.storeValueInInput = !!storeValueInInput;
  this.disableCancelBubble = !!disableCancelBubble;
  this.accessibilityCompliant = accessibilityCompliant;
 },
 Add: function(key, inputElement, container) {
  this.Remove(key);
  var checkBox = this.CreateInternalCheckBox(key, inputElement, container);
  CollectionBase.prototype.Add.call(this, key, checkBox);
  return checkBox;
 },
 SetImageProperties: function(imageProperties) {
  this.stateController.imageProperties = imageProperties;
 },
 CreateInternalCheckBox: function(key, inputElement, container) {
  return new CheckBoxInternal(inputElement, this.stateController, this.stateController.allowGrayed, false, this.helper, container, 
   this.storeValueInInput, key, this.disableCancelBubble, this.accessibilityCompliant);
 }
});
var EditorStyleDecoration = ASPx.CreateClass(null, {
 constructor: function(editor) {
  this.editor = editor;
  this.postfixList = [ ];
  this.styles = { };
  this.innerStyles = { };
  this.nullTextClassName = "";
 },
 GetStyleSheet: function() {
  return ASPx.GetCurrentStyleSheet();
 },
 AddPostfix: function(value, applyClass, applyBorders, applyBackground) {
  this.postfixList.push(value);
 },
 AddStyle: function(key, className, cssText) {
  this.styles[key] = this.CreateRule(className, cssText);
  this.innerStyles[key] = this.CreateRule("", this.FilterInnerCss(cssText));
 },
 CreateRule: function(className, cssText) {
  return ASPx.Str.Trim(className + " " + ASPx.CreateImportantStyleRule(this.GetStyleSheet(), cssText));
 },
 Update: function() {
  for(var i = 0; i < this.postfixList.length; i++) {
   var postfix = this.postfixList[i];
   var inner = postfix.length > 0;
   var element = ASPx.GetElementById(this.editor.name + postfix);
   if(!element) continue;
   if(this.HasDecoration("I")) {
    var isValid = this.editor.GetIsValid();
    this.ApplyDecoration("I", element, inner, !isValid);
   }
   if(this.HasDecoration("F"))
    this.ApplyDecoration("F", element, inner, this.editor.focused);
   if(this.HasDecoration("N")) {
    var apply = !this.editor.focused;
    if(apply) {
     if(this.editor.CanApplyNullTextDecoration) {
      apply = this.editor.CanApplyNullTextDecoration();
     } else {
      var value = this.editor.GetValue();
      apply = apply && (value == null || value === "");
     }
    }
    if(apply)
     ASPx.Attr.ChangeAttribute(element, "spellcheck", "false");
    else
     ASPx.Attr.RestoreAttribute(element, "spellcheck");
    this.ApplyDecoration("N", element, inner, apply);
   }
  }
 },
 HasDecoration: function(key) {
  return !!this.styles[key];
 },
 ApplyNullTextClassName: function(active) {
  var nullTextClassName = this.GetNullTextClassName();
  var editorMainElement = this.editor.GetMainElement();
  if (active)
   ASPx.AddClassNameToElement(editorMainElement, nullTextClassName);
  else
   ASPx.RemoveClassNameFromElement(editorMainElement, nullTextClassName);
 },
 GetNullTextClassName: function () {
  if (!this.nullTextClassName)
   this.InitializeNullTextClassName();
  return this.nullTextClassName;
 },
 InitializeNullTextClassName: function () {
  var nullTextStyle = this.styles["N"];
  if (nullTextStyle) {
   var nullTextStyleClassNames = nullTextStyle.split(" ");
   for (var i = 0; i < nullTextStyleClassNames.length; i++)
    if (nullTextStyleClassNames[i].match("dxeNullText"))
     this.nullTextClassName = nullTextStyleClassNames[i];
  }
 },
 ApplyDecoration: function(key, element, inner, active) {
  var value = inner ? this.innerStyles[key] : this.styles[key];
  ASPx.RemoveClassNameFromElement(element, value);
  if(ASPx.Browser.IE && ASPx.Browser.MajorVersion >= 11)
   var reflow = element.offsetWidth; 
  if(active) {
   ASPx.AddClassNameToElement(element, value);
   if(ASPx.Browser.IE && ASPx.Browser.Version > 10 && element.border != null) { 
    var border = parseInt(element.border) || 0;
    element.border = 1;
    element.border = border;
   }
  }
 },
 FilterInnerCss: function(css) {
  return css.replace(/(border|background-image)[^:]*:[^;]+/gi, "");
 }
});
var TouchUIHelper = {
 isGesture: false,
 isMouseEventFromScrolling: false,
 isNativeScrollingAllowed: true,
 clickSensetivity: 10,
 documentTouchHandlers: {},
 documentEventAttachingAllowed: true,
 msTouchDraggableClassName: "dxMSTouchDraggable",
 touchMouseDownEventName: ASPx.Browser.WebKitTouchUI ? "touchstart" : "mousedown",
 touchMouseUpEventName:   ASPx.Browser.WebKitTouchUI ? "touchend"   : "mouseup",
 touchMouseMoveEventName: ASPx.Browser.WebKitTouchUI ? "touchmove"  : "mousemove",
 isTouchEvent: function(evt) { 
  return ASPx.Browser.WebKitTouchUI && ASPx.IsExists(evt.changedTouches); 
 },
 isTouchEventName: function(eventName) {
  return ASPx.Browser.WebKitTouchUI && (eventName.indexOf("touch") > -1 || eventName.indexOf("gesture") > -1);
 },
 getEventX: function(evt) { 
  return ASPx.Browser.IE ? evt.pageX : evt.changedTouches[0].pageX; 
 },
 getEventY: function (evt) { 
  return ASPx.Browser.IE ? evt.pageY :evt.changedTouches[0].pageY; 
 },
 getWebkitMajorVersion: function(){
  if(!this.webkitMajorVersion){
   var regExp = new RegExp("applewebkit/(\\d+)", "i");
   var matches = regExp.exec(ASPx.Browser.UserAgent);
   if(matches && matches.index >= 1)
    this.webkitMajorVersion = matches[1];
  }
  return this.webkitMajorVersion;
 },
 getIsLandscapeOrientation: function(){
  if(ASPx.Browser.MacOSMobilePlatform || ASPx.Browser.AndroidMobilePlatform)
   return Math.abs(window.orientation) == 90;
  return ASPx.GetDocumentClientWidth() > ASPx.GetDocumentClientHeight();
 },
 nativeScrollingSupported: function() {
  var allowedSafariVersion = ASPx.Browser.Version >= 5.1 && ASPx.Browser.Version < 8; 
  var allowedWebKitVersion = this.getWebkitMajorVersion() > 533 && (ASPx.Browser.Chrome || this.getWebkitMajorVersion() < 600);
  return (ASPx.Browser.MacOSMobilePlatform && (allowedSafariVersion || allowedWebKitVersion))
   || (ASPx.Browser.AndroidMobilePlatform && ASPx.Browser.PlaformMajorVersion >= 3) || (ASPx.Browser.MSTouchUI && (!ASPx.Browser.WindowsPhonePlatform || !ASPx.Browser.IE));
 },
 makeScrollableIfRequired: function(element, options) {
  if(ASPx.Browser.WebKitTouchUI && element) {
   var overflow = ASPx.GetCurrentStyle(element).overflow;
   if(element.tagName == "DIV" &&  overflow != "hidden" && overflow != "visible" ){
    return this.MakeScrollable(element);
   }
  }
 },
 preventScrollOnEvent: function(evt){
 },
 handleFastTapIfRequired: function(evt, action, preventCommonClickEvents) {
  if(ASPx.Browser.WebKitTouchUI && evt.type == 'touchstart' && action) {
   this.FastTapHelper.HandleFastTap(evt, action, preventCommonClickEvents);
   return true;
  }
  return false;
 },
 ensureDocumentSizesCorrect: function (){
  return (document.documentElement.clientWidth - document.documentElement.clientHeight) / (screen.width - screen.height) > 0;
 },
 ensureOrientationChanged: function(onOrientationChangedFunction){
  if(ASPxClientUtils.iOSPlatform || this.ensureDocumentSizesCorrect())
   onOrientationChangedFunction();
  else {
   window.setTimeout(function(){
    this.ensureOrientationChanged(onOrientationChangedFunction);
   }.aspxBind(this), 100);
  }
 },
 onEventAttachingToDocument: function(eventName, func){
  if(ASPx.Browser.MacOSMobilePlatform && this.isTouchEventName(eventName)) {
   if(!this.documentTouchHandlers[eventName])
    this.documentTouchHandlers[eventName] = [];
   this.documentTouchHandlers[eventName].push(func);
   return this.documentEventAttachingAllowed;
  }
  return true;
 },
 onEventDettachedFromDocument: function(eventName, func){
  if(ASPx.Browser.MacOSMobilePlatform && this.isTouchEventName(eventName)) {
   var handlers = this.documentTouchHandlers[eventName];
   if(handlers)
    ASPx.Data.ArrayRemove(handlers, func);
  }
 },
 processDocumentTouchEventHandlers: function(proc) {
  var touchEventNames = ["touchstart", "touchend", "touchmove", "gesturestart", "gestureend"];
  for(var i = 0; i < touchEventNames.length; i++) {
   var eventName = touchEventNames[i];
   var handlers = this.documentTouchHandlers[eventName];
   if(handlers) {
    for(var j = 0; j < handlers.length; j++) {
     proc(eventName,handlers[j]);
    }
   }
  }
 },
 removeDocumentTouchEventHandlers: function() {
  if(ASPx.Browser.MacOSMobilePlatform) {
   this.documentEventAttachingAllowed = false;
   this.processDocumentTouchEventHandlers(ASPx.Evt.DetachEventFromDocumentCore);
  }
 },
 restoreDocumentTouchEventHandlers: function () {
  if(ASPx.Browser.MacOSMobilePlatform) {
   this.documentEventAttachingAllowed = true;
   this.processDocumentTouchEventHandlers(ASPx.Evt.AttachEventToDocumentCore);
  }
 },
 IsNativeScrolling: function() {
  return TouchUIHelper.nativeScrollingSupported() && TouchUIHelper.isNativeScrollingAllowed;
 },
 pointerEnabled: !!(window.PointerEvent || window.MSPointerEvent),
 pointerDownEventName: window.PointerEvent ? "pointerdown" : "MSPointerDown",
 pointerUpEventName: window.PointerEvent ? "pointerup" : "MSPointerUp",
 pointerCancelEventName: window.PointerEvent ? "pointercancel" : "MSPointerCancel",
 pointerMoveEventName: window.PointerEvent ? "pointermove" : "MSPointerMove",
 pointerOverEventName: window.PointerEvent ? "pointerover" : "MSPointerOver",
 pointerOutEventName: window.PointerEvent ? "pointerout" : "MSPointerOut",
 pointerType: {
  Touch: (ASPx.Browser.IE && ASPx.Browser.Version == 10) ? 2 : "touch",
  Pen: (ASPx.Browser.IE && ASPx.Browser.Version == 10) ? 3 : "pen",
  Mouse: (ASPx.Browser.IE && ASPx.Browser.Version == 10) ? 4 : "mouse"
 },
 msGestureEnabled: !!(window.PointerEvent || window.MSPointerEvent) && typeof(MSGesture) != "undefined",
 msTouchCreateGesturesWrapper: function(element, onTap){
  if(!TouchUIHelper.msGestureEnabled) 
   return;
  var gesture = new MSGesture();
  gesture.target = element;
  ASPx.Evt.AttachEventToElement(element, TouchUIHelper.pointerDownEventName, function(evt){
   gesture.addPointer(evt.pointerId);
  });
  ASPx.Evt.AttachEventToElement(element, TouchUIHelper.pointerUpEventName, function(evt){
   gesture.stop();
  });
  if(onTap)
   ASPx.Evt.AttachEventToElement(element, "MSGestureTap", onTap);
  return gesture;
 }
};
var CacheHelper = {};
CacheHelper.GetCachedValueCore = function(obj, key, func, cacheObj, fillValueMethod) {
 if(!cacheObj)
  cacheObj = obj;
 if(!cacheObj.cache)
  cacheObj.cache = {};
 if(!key) 
  key = "default";
 fillValueMethod(obj, key, func, cacheObj);
 return cacheObj.cache[key];
};
CacheHelper.GetCachedValue = function(obj, key, func, cacheObj) {
 return CacheHelper.GetCachedValueCore(obj, key, func, cacheObj, 
  function(obj, key, func, cacheObj) {
   if(!ASPx.IsExists(cacheObj.cache[key]))
    cacheObj.cache[key] = func.apply(obj, []);
  });
};
CacheHelper.GetCachedElement = function(obj, key, func, cacheObj) {
 return CacheHelper.GetCachedValueCore(obj, key, func, cacheObj, 
  function(obj, key, func, cacheObj) {
   if(!ASPx.IsValidElement(cacheObj.cache[key]))
    cacheObj.cache[key] = func.apply(obj, []);
  });
};
CacheHelper.GetCachedElements = function(obj, key, func, cacheObj) {
 return CacheHelper.GetCachedValueCore(obj, key, func, cacheObj, 
  function(obj, key, func, cacheObj) {
   if(!ASPx.IsValidElements(cacheObj.cache[key])){
    var elements = func.apply(obj, []);
    if(!Ident.IsArray(elements))
     elements = [elements];
    cacheObj.cache[key] = elements;
   }
  });
};
CacheHelper.GetCachedElementById = function(obj, id, cacheObj) {
 return CacheHelper.GetCachedElement(obj, id, function() { return ASPx.GetElementById(id); }, cacheObj);
};
CacheHelper.GetCachedChildById = function(obj, parent, id, cacheObj) {
 return CacheHelper.GetCachedElement(obj, id, function() { return ASPx.GetChildById(parent, id); }, cacheObj);
};
CacheHelper.DropCachedValue = function(cacheObj, key) {
 cacheObj.cache[key] = null;
};  
CacheHelper.DropCache = function(cacheObj) {
 cacheObj.cache = null;
};  
var DomObserver = ASPx.CreateClass(null, {
 constructor: function() {
  this.items = { };
 },
 subscribe: function(elementID, callbackFunc) {
  var item = this.items[elementID];
  if(item)
   this.unsubscribe(elementID);
  item = {
   elementID: elementID,
   callbackFunc: callbackFunc,
   pauseCount: 0
  };
  this.prepareItem(item);
  this.items[elementID] = item;
 },
 prepareItem: function(item) {
 },
 unsubscribe: function(elementID) {
  this.items[elementID] = null;
 },
 getItemElement: function(item) {
  var element = this.getElementById(item.elementID);
  if(element)
   return element;
  this.unsubscribe(item.elementID);
  return null;
 },
 getElementById: function(elementID) {
  var element = document.getElementById(elementID);
  return element && ASPx.IsValidElement(element) ? element : null;
 },
 pause: function(element, includeSubtree) {
  this.changeItemsState(element, includeSubtree, true);
 },
 resume: function(element, includeSubtree) {
  this.changeItemsState(element, includeSubtree, false);
 },
 forEachItem: function(processFunc, context) {
  context = context || this;
  for(var itemName in this.items) {
   if(!this.items.hasOwnProperty(itemName))
    continue;
   var item = this.items[itemName];
   if(item) {
    var needBreak = processFunc.call(context, item);
    if(needBreak)
     return;
   }
  }
 },
 changeItemsState: function(element, includeSubtree, pause) {
  this.forEachItem(function(item) {
   if(!element)
    this.changeItemState(item, pause);
   else {
    var itemElement = this.getItemElement(item);
    if(itemElement && (element == itemElement || (includeSubtree && ASPx.GetIsParent(element, itemElement)))) {
     this.changeItemState(item, pause);
     if(!includeSubtree)
      return true;
    }
   }
  }.aspxBind(this));
 },
 changeItemState: function(item, pause) {
  if(pause)
   this.pauseItem(item)
  else
   this.resumeItem(item);
 },
 pauseItem: function(item) {
  item.paused = true;
  item.pauseCount++;
 },
 resumeItem: function(item) {
  if(item.pauseCount > 0) {
   if(item.pauseCount == 1)
    item.paused = false;
   item.pauseCount--;
  }
 }
});
DomObserver.IsMutationObserverAvailable = function() {
 return !!window.MutationObserver;
};
var TimerObserver = ASPx.CreateClass(DomObserver, {
 constructor: function() {
  this.constructor.prototype.constructor.call(this);
  this.timerID = -1;
  this.observationTimeout = 300;
 },
 subscribe: function(elementID, callbackFunc) {
  DomObserver.prototype.subscribe.call(this, elementID, callbackFunc);
  if(!this.isActivated())
   this.startObserving();
 },
 isActivated: function() {
  return this.timerID !== -1;
 },
 startObserving: function() {
  if(this.isActivated())
   window.clearTimeout(this.timerID);
  this.timerID = window.setTimeout(this.onTimeout, this.observationTimeout);
 },
 onTimeout: function() {
  var observer = _aspxGetDomObserver();
  observer.doObserve();
  observer.startObserving();
 },
 doObserve: function() {
  if(!ASPx.documentLoaded) return;
  this.forEachItem(function(item) {
   if(!item.paused)
    this.doObserveForItem(item);
  }.aspxBind(this));
 },
 doObserveForItem: function(item) {
  var element = this.getItemElement(item);
  if(element)
   item.callbackFunc.call(this, element);
 }
});
var MutationObserver = ASPx.CreateClass(DomObserver, {
 constructor: function() {
  this.constructor.prototype.constructor.call(this);
  this.callbackTimeout = 10;
 },
 prepareItem: function(item) {
  item.callbackTimerID = -1;
  var target = this.getElementById(item.elementID);
  if(!target)
   return;
  var observerCallbackFunc = function() {
   if(item.callbackTimerID === -1) {
    var timeoutHander = function() {
     item.callbackTimerID = -1;
     item.callbackFunc.call(this, target);
    }.aspxBind(this);
    item.callbackTimerID = window.setTimeout(timeoutHander, this.callbackTimeout);
   }
  }.aspxBind(this);
  var observer = new window.MutationObserver(observerCallbackFunc);
  var config = { attributes: true, childList: true, characterData: true, subtree: true };
  observer.observe(target, config);
  item.observer = observer;
  item.config = config;
 },
 unsubscribe: function(elementID) {
  var item = this.items[elementID];
  if(item) {
   item.observer.disconnect();
   item.observer = null;
  }
  DomObserver.prototype.unsubscribe.call(this, elementID);
 },
 pauseItem: function(item) {
  DomObserver.prototype.pauseItem.call(this, item);
  item.observer.disconnect();
 },
 resumeItem: function(item) {
  DomObserver.prototype.resumeItem.call(this, item);
  if(!item.paused) {
   var target = this.getItemElement(item);
   if(target)
    item.observer.observe(target, item.config);
  }
 }
});
var domObserver = null;
function _aspxGetDomObserver() {
 if(domObserver == null)
  domObserver = DomObserver.IsMutationObserverAvailable() ? new MutationObserver() : new TimerObserver();
 return domObserver;
};
var ControlUpdateWatcher = ASPx.CreateClass(null, {
 constructor: function() {
  this.helpers = { };
  this.clearLockerTimerID = -1;
  this.clearLockerTimerDelay = 15;
  this.postProcessing = false;
  this.init();
 },
 init: function() {
  var postHandler = aspxGetPostHandler();
  postHandler.Post.AddHandler(this.OnPost, this);
 },
 Add: function(helper) {
  this.helpers[helper.GetName()] = helper;
 },
 CanSendCallback: function(dxCallbackOwner, arg) {
  this.LockConfirmOnBeforeWindowUnload();
  var modifiedHelpers = this.FilterModifiedHelpersByDXCallbackOwner(this.GetModifiedHelpers(), dxCallbackOwner, arg);
  if(modifiedHelpers.length === 0) return true;
  var modifiedHelpersInfo = this.GetToConfirmAndToResetLists(modifiedHelpers, dxCallbackOwner.name);
  if(!modifiedHelpersInfo) return true;
  if(modifiedHelpersInfo.toConfirm.length === 0) {
   this.ResetClientChanges(modifiedHelpersInfo.toReset);
   return true;
  }
  var helper = modifiedHelpersInfo.toConfirm[0];
  if(!confirm(helper.GetConfirmUpdateText()))
   return false;
  this.ResetClientChanges(modifiedHelpersInfo.toReset);
  return true;
 },
 OnPost: function(s, e) {
  if(e.isDXCallback) return;
  this.postProcessing = true;
  this.LockConfirmOnBeforeWindowUnload();
  var modifiedHelpersInfo = this.GetModifedHelpersInfo(e);
  if(!modifiedHelpersInfo) return;
  if(modifiedHelpersInfo.toConfirm.length === 0) {
   this.ResetClientChanges(modifiedHelpersInfo.toReset);
   return;
  }
  var helper = modifiedHelpersInfo.toConfirm[0];
  if(!confirm(helper.GetConfirmUpdateText())) {
   e.cancel = true;
   this.finishPostProcessing();
  }
  if(!e.cancel)
   this.ResetClientChanges(modifiedHelpersInfo.toReset);
 },
 finishPostProcessing: function() {
  this.postProcessing = false;
 },
 GetModifedHelpersInfo: function(e) {
  var modifiedHelpers = this.FilterModifiedHelpers(this.GetModifiedHelpers(), e);
  if(modifiedHelpers.length === 0) return;
  return this.GetToConfirmAndToResetLists(modifiedHelpers, e && e.ownerID);
 },
 GetToConfirmAndToResetLists: function(modifiedHelpers, ownerID) {
  var resetList = [ ];
  var confirmList = [ ];
  for(var i = 0; i < modifiedHelpers.length; i++) {
   var helper = modifiedHelpers[i];
   if(!helper.GetConfirmUpdateText()) { 
    resetList.push(helper);
    continue;
   }
   if(helper.CanShowConfirm(ownerID)) { 
    resetList.push(helper);
    confirmList.push(helper);
   }
  }
  return { toConfirm: confirmList, toReset: resetList };
 },
 FilterModifiedHelpers: function(modifiedHelpers, e) {
  if(modifiedHelpers.length === 0)
   return [ ];
  if(this.RequireProcessUpdatePanelCallback(e))
   return this.FilterModifiedHelpersByUpdatePanels(modifiedHelpers);
  if(this.postProcessing)
   return this.FilterModifiedHelpersByPostback(modifiedHelpers);
  return modifiedHelpers;
 },
 FilterModifiedHelpersByDXCallbackOwner: function(modifiedHelpers, dxCallbackOwner, arg) {
  var result = [ ];
  for(var i = 0; i < modifiedHelpers.length; i++) {
   var helper = modifiedHelpers[i];
   if(helper.NeedConfirmOnCallback(dxCallbackOwner, arg))
    result.push(helper);
  }
  return result;
 },
 FilterModifiedHelpersByUpdatePanels: function(modifiedHelpers) {
  var result = [ ];
  var updatePanels = this.GetUpdatePanelsWaitedForUpdate();
  for(var i = 0; i < updatePanels.length; i++) {
   var panelID = updatePanels[i].replace(/\$/g, "_");
   var panel = ASPx.GetElementById(panelID);
   if(!panel) continue;
   for(var j = 0; j < modifiedHelpers.length; j++) {
    var helper = modifiedHelpers[j];
    if(ASPx.GetIsParent(panel, helper.GetControlMainElement()))
     result.push(helper);
   }
  }
  return result;
 },
 FilterModifiedHelpersByPostback: function(modifiedHelpers) {
  var result = [ ];
  for(var i = 0; i < modifiedHelpers.length; i++) {
   var helper = modifiedHelpers[i];
   if(helper.NeedConfirmOnPostback())
    result.push(helper);
  }
  return result;
 },
 RequireProcessUpdatePanelCallback: function(e) {
  var rManager = this.GetMSRequestManager();
  if(rManager && e && e.isMSAjaxCallback)
   return rManager._postBackSettings.async;
  return false;
 },
 GetUpdatePanelsWaitedForUpdate: function() {
  var rManager = this.GetMSRequestManager();
  if(!rManager) return [ ];
  var panelUniqueIDs = rManager._postBackSettings.panelsToUpdate || [ ];
  var panelClientIDs = [ ];
  for(var i = 0; i < panelUniqueIDs.length; i++) {
   var index = ASPx.Data.ArrayIndexOf(rManager._updatePanelIDs, panelUniqueIDs[i]);
   if(index >= 0)
    panelClientIDs.push(rManager._updatePanelClientIDs[index]);
  }
  return panelClientIDs;
 },
 GetMSRequestManager: function() {
  if(window.Sys && Sys.WebForms && Sys.WebForms.PageRequestManager && Sys.WebForms.PageRequestManager.getInstance)
   return Sys.WebForms.PageRequestManager.getInstance();
  return null;
 },
 GetModifiedHelpers: function() {
  var result = [ ];
  for(var key in this.helpers) { 
   var helper = this.helpers[key];
   if(helper.HasChanges())
    result.push(helper);
  }
  return result;
 },
 ResetClientChanges: function(modifiedHelpers) {
  for(var i = 0; i < modifiedHelpers.length; i++)
   modifiedHelpers[i].ResetClientChanges();
 },
 GetConfirmUpdateMessage: function() {
  if(this.confirmOnWindowUnloadLocked) return;
  var modifiedHelpersInfo = this.GetModifedHelpersInfo();
  if(!modifiedHelpersInfo || modifiedHelpersInfo.toConfirm.length === 0) 
   return;
  var helper = modifiedHelpersInfo.toConfirm[0];
  return helper.GetConfirmUpdateText();
 },
 LockConfirmOnBeforeWindowUnload: function() {
  this.confirmOnWindowUnloadLocked = true;
  this.clearLockerTimerID = ASPx.Timer.ClearTimer(this.clearLockerTimerID);
  this.clearLockerTimerID = window.setTimeout(function() {
   this.confirmOnWindowUnloadLocked = false;
  }.aspxBind(this), this.clearLockerTimerDelay);
 },
 OnWindowBeforeUnload: function(e) {
  var confirmMessage = this.GetConfirmUpdateMessage();
  if(confirmMessage)
   e.returnValue = confirmMessage;
  this.finishPostProcessing();
  return confirmMessage;
 },
 OnWindowUnload: function(e) {
  if(this.confirmOnWindowUnloadLocked) return;
  var modifiedHelpersInfo = this.GetModifedHelpersInfo();
  if(!modifiedHelpersInfo) return;
  this.ResetClientChanges(modifiedHelpersInfo.toReset);
 },
 OnMouseDown: function(e) {
  if(ASPx.Browser.IE)
   this.PreventBeforeUnloadOnLinkClick(e);
 },
 OnFocusIn: function(e) {
  if(ASPx.Browser.IE)
   this.PreventBeforeUnloadOnLinkClick(e);
 },
 PreventBeforeUnloadOnLinkClick: function(e) {
  if(ASPx.GetObjectKeys(this.helpers).length == 0)
   return;
  var link = ASPx.GetParentByTagName(ASPx.Evt.GetEventSource(e), "A");
  if(!link || link.dxgvLinkClickHanlderAssigned)
   return;
  var url = ASPx.Attr.GetAttribute(link, "href");
  if(!url || url.indexOf("javascript:") < 0)
   return;
  ASPx.Evt.AttachEventToElement(link, "click", function(ev) { return ASPx.Evt.PreventEvent(ev); });
  link.dxgvLinkClickHanlderAssigned = true;
 }
});
ControlUpdateWatcher.Instance = null;
ControlUpdateWatcher.getInstance = function () {
 if (!ControlUpdateWatcher.Instance) {
  ControlUpdateWatcher.Instance = new ControlUpdateWatcher();
  ASPx.Evt.AttachEventToElement(window, "beforeunload", function(e) {
   return ControlUpdateWatcher.Instance.OnWindowBeforeUnload(e);
  });
  ASPx.Evt.AttachEventToElement(window, "unload", function(e) {
   ControlUpdateWatcher.Instance.OnWindowUnload(e);
  });
  ASPx.Evt.AttachEventToDocument("mousedown", function(e) {
   ControlUpdateWatcher.Instance.OnMouseDown(e);
  });
  ASPx.Evt.AttachEventToDocument("focusin", function(e) {
   ControlUpdateWatcher.Instance.OnFocusIn(e);
  });
 }
 return ControlUpdateWatcher.Instance;
};
var UpdateWatcherHelper = ASPx.CreateClass(null, {
 constructor: function(owner) {
  this.owner = owner;
  this.ownerWatcher = ControlUpdateWatcher.getInstance();
  this.ownerWatcher.Add(this);
 },
 GetName: function() {
  return this.owner.name;
 },
 GetControlMainElement: function() {
  return this.owner.GetMainElement();
 },
 CanShowConfirm: function(requestOwnerID) {
  return true;
 },
 HasChanges: function() {
  return false;
 },
 GetConfirmUpdateText: function() {
  return "";
 },
 NeedConfirmOnCallback: function(dxCallbackOwner) {
  return true;
 },
 NeedConfirmOnPostback: function() {
  return true;
 },
 ResetClientChanges: function() {
 },
 ConfirmOnCustomControlEvent: function() {
  var confirmMessage = this.GetConfirmUpdateText();
  if(confirmMessage)
   return confirm(confirmMessage);
  return false;
 }
});
var ControlCallbackHandlersQueue = ASPx.CreateClass(null, {
 constructor: function (owner) {
  this.owner = owner;
  this.handlers = [];
 },
 addCallbackHandler: function (handle) {
  this.handlers.push(handle);
 },
 executeCallbacksHandlers: function () {
  for (var i = 0, handler; handler = this.handlers[i]; i++)
   handler.call(this.owner);
  this.handlers = [];
 }
});
var ControlCallbackQueueHelper = ASPx.CreateClass(null, {
 constructor: function (owner) {
  this.owner = owner;
  this.pendingCallbacks = [];
  this.receivedCallbacks = [];
  this.attachEvents();
 },
 showLoadingElements: function () {
  this.owner.ShowLoadingDiv();
  if (this.owner.IsCallbackAnimationEnabled())
   this.owner.StartBeginCallbackAnimation();
  else
   this.owner.ShowLoadingElementsInternal();
 },
 attachEvents: function () {
  this.owner.EndCallback.AddHandler(this.onEndCallback.aspxBind(this));
  this.owner.CallbackError.AddHandler(this.onCallbackError.aspxBind(this));
 },
 detachEvents: function () {
  this.owner.EndCallback.RemoveHandler(this.onEndCallback);
  this.owner.CallbackError.RemoveHandler(this.onCallbackError);
 },
 onCallbackError: function (owner, result) {
  this.sendErrorToChildControl(result);
 },
 ignoreDuplicates: function () {
  return true;
 },
 hasDuplicate: function (arg) {
  for (var i in this.pendingCallbacks) {
   if (this.pendingCallbacks[i].arg == arg && this.pendingCallbacks[i].state != ASPx.callbackState.aborted)
    return true;
  }
  return false;
 },
 getToken: function (halperContext, callbackInfo) {
  return {
   cancel: function () {
    if (callbackInfo.state == ASPx.callbackState.sent) {
     callbackInfo.state = ASPx.callbackState.aborted;
     halperContext.sendNext();
    }
    if (callbackInfo.state == ASPx.callbackState.inTurn)
     ASPx.Data.ArrayRemove(halperContext.pendingCallbacks, callbackInfo);
   },
   callbackId: -1
  }
 },
 sendCallback: function (arg, handlerContext, handler) {
  if (this.ignoreDuplicates() && this.hasDuplicate(arg))
   return false;
  var handlerContext = handlerContext || this.owner;
  var callbackInfo = {
   arg: arg,
   handlerContext: handlerContext,
   handler: handler || handlerContext.OnCallback,
   state: ASPx.callbackState.inTurn, callbackId: -1
  };
  this.pendingCallbacks.push(callbackInfo);
  if (!this.hasActiveCallback()) {
   callbackInfo.callbackId = this.owner.CreateCallback(arg);
   callbackInfo.state = ASPx.callbackState.sent;
  }
  return this.getToken(this, callbackInfo);
 },
 hasActiveCallback: function () {
  return this.getCallbacksInfoByState(ASPx.callbackState.sent).length > 0;
 },
 sendNext: function () {
  var nextCallbackInfo = this.getCallbacksInfoByState(ASPx.callbackState.inTurn)[0];
  if (nextCallbackInfo) {
   nextCallbackInfo.callbackId = this.owner.CreateCallback(nextCallbackInfo.arg);
   nextCallbackInfo.state = ASPx.callbackState.sent;
   return nextCallbackInfo.callbackId;
  }
 },
 onEndCallback: function () {
  if (!this.owner.isErrorOnCallback && this.hasPendingCallbacks()) {
   var curCallbackId;
   var curCallbackInfo;
   var handlerContext;
   for (var i in this.receivedCallbacks) {
    curCallbackId = this.receivedCallbacks[i];
    curCallbackInfo = this.getCallbackInfoById(curCallbackId);
    if (curCallbackInfo.state != ASPx.callbackState.aborted) {
     handlerContext = curCallbackInfo.handlerContext;
     if (handlerContext.OnEndCallback)
      handlerContext.OnEndCallback();
     this.sendNext();
    }
    ASPx.Data.ArrayRemove(this.pendingCallbacks, curCallbackInfo);
   }
   ASPx.Data.ArrayClear(this.receivedCallbacks);
  }
 },
 hasPendingCallbacks: function () {
  return this.pendingCallbacks && this.pendingCallbacks.length && this.pendingCallbacks.length > 0;
 },
 processCallback: function (result, callbackId) {
  this.receivedCallbacks.push(callbackId);
  if (this.hasPendingCallbacks()) {
   var callbackInfo = this.getCallbackInfoById(callbackId);
   if (callbackInfo.state != ASPx.callbackState.aborted)
    callbackInfo.handler.call(callbackInfo.handlerContext, result);
  }
 },
 getCallbackInfoById: function (id) {
  for (var i in this.pendingCallbacks) {
   if (this.pendingCallbacks[i].callbackId == id)
    return this.pendingCallbacks[i];
  }
 },
 getCallbacksInfoByState: function (state) {
  var result = [];
  for (var i in this.pendingCallbacks) {
   if (this.pendingCallbacks[i].state == state)
    result.push(this.pendingCallbacks[i]);
  }
  return result;
 },
 sendErrorToChildControl: function (callbackObj) {
  if (this.hasPendingCallbacks()) {
   var callbackInfo = this.getCallbackInfoById(callbackObj.callbackId);
   if (callbackInfo) {
    var hasChildControlHandler = (callbackInfo.handlerContext != this.owner) && callbackInfo.handlerContext.OnCallbackError;
    if (hasChildControlHandler)
     callbackInfo.handlerContext.OnCallbackError.call(callbackInfo.handlerContext, callbackObj.message, callbackObj.data);
   }
  }
 }
});
var AccessibilityHelperBase = ASPx.CreateClass(null, {
 constructor: function(control) {
  this.control = control;
  this.timerID = -1;
  this.pronounceMessageTimeout = 500;
  this.activeItem = this.getItems()[0];
  this.pronounceIsStarted = false;
 },
 PronounceMessage: function(text, activeItemArgs, inactiveItemArgs, mainElementArgs, ownerMainElement) {   
  this.timerID = ASPx.Timer.ClearTimer(this.timerID);
  this.pronounceIsStarted = true;
  this.timerID = window.setTimeout(function() {
   this.PronounceMessageCore(text, activeItemArgs, inactiveItemArgs, mainElementArgs, ownerMainElement);
  }.aspxBind(this), this.getPronounceTimeout());
 },
 PronounceMessageCore: function(text, activeItemArgs, inactiveItemArgs, mainElementArgs, ownerMainElement) {
  this.toogleItem();
  var mainElement = this.getMainElement();
  var activeItem = this.getItem(true);
  var inactiveItem = this.getItem();
  if(ASPx.Attr.GetAttribute(mainElement, "role") != "application")
   mainElementArgs = this.addArguments(mainElementArgs, { "aria-activedescendant"   : activeItem.id });
  activeItemArgs = this.addArguments(activeItemArgs,    { "aria-label"     : text });
  inactiveItemArgs = this.addArguments(inactiveItemArgs,   { "aria-label"     : "" });
  if(!!this.control.GetErrorCell()) {
   var errorTextElement = this.control.GetAccessibilityErrorTextElement();
   activeItemArgs = this.addArguments(activeItemArgs,   {"aria-invalid"  : !this.control.isValid ? "true" : "" });
   mainElementArgs = this.addArguments(mainElementArgs, { "aria-invalid" : "" });
   inactiveItemArgs = this.addArguments(inactiveItemArgs,  { "aria-invalid" : "" });
  }
  this.changeActivityAttributes(activeItem, activeItemArgs);
  if(!!this.control.GetErrorCell()) {
   this.control.SetOrRemoveAccessibilityAdditionalText([activeItem], errorTextElement, !this.control.isValid, false, true);
   this.control.SetOrRemoveAccessibilityAdditionalText([mainElement, inactiveItem], errorTextElement, false, false, false);
  }
  this.changeActivityAttributes(mainElement, mainElementArgs);
  if(!!ownerMainElement && ASPx.Attr.GetAttribute(ownerMainElement, "role") != "application")
   this.changeActivityAttributes(ownerMainElement, { "aria-activedescendant": activeItem.id });
  this.changeActivityAttributes(inactiveItem, inactiveItemArgs);
  this.pronounceIsStarted = false;
 },
 GetActiveElement: function(inputIsMainElement) {
  if(this.pronounceIsStarted) return null;
  var mainElement = inputIsMainElement ? this.control.GetInputElement() : this.getMainElement();
  var activeElementId = ASPx.Attr.GetAttribute(mainElement, 'aria-activedescendant');
  return activeElementId ? ASPx.GetElementById(activeElementId) : mainElement;
 },
 getMainElement: function() {
  if(!ASPx.IsExistsElement(this.mainElement))
   this.mainElement = this.control.GetAccessibilityServiceElement();
  return this.mainElement;
 },
 getItems: function() {
  if(!ASPx.IsExistsElement(this.items))
   this.items = ASPx.GetChildElementNodes(this.getMainElement());
  return this.items;
 },
 getItem: function(isActive) {
  if(isActive)
   return this.activeItem;
  var items = this.getItems();
  return items[0] === this.activeItem ? items[1] : items[0];
 },
 getPronounceTimeout: function() { return this.pronounceMessageTimeout; },
 toogleItem: function() {
  this.activeItem = this.getItem();
 },
 addArguments: function(targetArgs, newArgs) {
  if(!targetArgs) targetArgs = { };
  for(key in newArgs) {
   if(!targetArgs.hasOwnProperty(key))
    targetArgs[key] = newArgs[key];
  }
  return targetArgs;
 },
 changeActivityAttributes: function(element, args) {
  for(key in args) {
   var value = args[key];
   var action = value !== "" ? ASPx.Attr.SetAttribute : ASPx.Attr.RemoveAttribute;
   action(element, key, value);
  }
 }
});
var EventStorage = ASPx.CreateClass(null, {
 constructor: function() {
  this.bag = { };
 },
 Save: function(e, data, overwrite) {
  var key = this.getEventKey(e);
  if(this.bag.hasOwnProperty(key) && !overwrite)
   return;
  this.bag[key] = data;
  window.setTimeout(function() { delete this.bag[key]; }.aspxBind(this), 100);
 },
 Load: function(e) {
  var key = this.getEventKey(e);
  return this.bag[key];
 },
 getEventKey: function(e) {
  if(ASPx.IsExists(e.timeStamp))
   return e.timeStamp.toString();
  var eventSource = ASPx.Evt.GetEventSource(e);
  var type = e.type.toString();
  return eventSource ? type + "_" + eventSource.uniqueID.toString() : type;
 }
});
EventStorage.Instance = null;
EventStorage.getInstance = function() {
 if(!EventStorage.Instance)
  EventStorage.Instance = new EventStorage();
 return EventStorage.Instance;
};
var GetGlobalObject = function(objectName) {
 var fields = objectName.split('.');
 var obj = window[fields[0]];
 for(var i = 1; obj && i < fields.length; i++) {
  obj = obj[fields[i]];
 }
 return obj;
}
var GetExternalScriptProcessor = function() {
 return ASPx.ExternalScriptProcessor ? ASPx.ExternalScriptProcessor.getInstance() : null;
}
var ThemesWithRipple = ['Material'];
var RippleHelper = {
 rippleTargetClassName: "dxRippleTarget",
 externalRippleTargetClassName: "dxRoundRippleTarget",
 rippleContainerClassName: "dxRippleContainer",
 rippleClassName: "dxRipple",
 expandedRippleClassName: "dxRippleExpanded",
 rippleTargetSelectorList: [
  ".dxgvControl_{0} .dxgvTable_{0} .dxgvHeader_{0}",
  ".dxgvControl_{0} .dxgvCustomization_{0} .dxgvHeader_{0}",
  ".dxvgControl_{0} .dxvgTable_{0} .dxvgHeader_{0}",
  ".dxvgControl_{0} .dxvgCustomization_{0} .dxvgHeader_{0}",
  ".dxcvControl_{0} .dxcvHeaderPanel_{0} .dxcvHeader_{0}",
  ".dxcvControl_{0} .dxcvCustomization_{0} .dxcvHeader_{0}",
  ".dxpgControl_{0} .dxpgRowArea_{0} .dxpgHeaderTable_{0}",
  ".dxpgControl_{0} .dxpgCustomizationFieldsContent_{0} .dxpgHeaderTable_{0}",
  ".dxtlControl_{0} .dxtlDataTable .dxtlHeader_{0}",
  ".dxtlControl_{0} .dxpcLite_{0} .dxpc-content .dxtlHeader_{0}",
  ".dxbButton_{0}.dxbTSys",
  ".dxeListBox_{0} .dxlbd .dxeListBoxItem_{0}",
  ".dxmLite_{0} .dxm-main .dxm-item:not(.dxm-tmpl)",
  ".dxnbLite_{0} .dxnb-header",
  ".dxnbLite_{0} .dxnb-headerCollapsed",
  ".dxnbLite_{0} .dxnb-content .dxnb-item",
  ".dxnbLite_{0} .dxnb-content .dxnb-large",
  ".dxnbLite_{0} .dxnb-content .dxnb-bullet",
  ".dxrControl_{0} .dxr-item:not(.dxr-edtItem):not(.dxr-glrBarItem)",
  ".dxrControl_{0} .dxr-grExpBtn",
  ".dxrControl_{0} .dxr-olmGrExpBtn",
  ".dxpcLite_{0} .dxpc-header > div:not(.dxpc-headerContent):not(.dxpc-maximizeBtn)",
  ".dxICheckBox_{0}.dxichSys",
  ".dxeIRadioButton_{0}.dxichSys",
  ".dxeColorTablesMainDiv_{0} .dxeCustomColorButton_{0}",
  ".dxeCalendarButton_{0}",
  ".dxpLite_{0} .dxp-num",
  ".dxpLite_{0} .dxp-button:not(.dxp-disabledButton)",
  ".dxeTrackBar_{0} .dxeTBDecBtn_{0}",
  ".dxeTrackBar_{0} .dxeTBIncBtn_{0}"
 ],
 getRippleTargetElements: function(targetElementsSelector) {
  var targetElements = document.querySelectorAll(targetElementsSelector);
  return Array.prototype.slice.call(targetElements);
 },
 needToAddRoundRippleClassName: function(targetElement) {
  return ASPx.ElementContainsCssClass(targetElement, "dxichSys") || ASPx.ElementContainsCssClass(targetElement.parentNode, "dxpc-header") ||
   ASPx.ElementContainsCssClass(targetElement, "dxp-num") ||
    ASPx.ElementContainsCssClass(targetElement, "dxp-button") ||
    ASPx.ElementContainsCssClass(targetElement, "dxeTBDecBtn") ||
    ASPx.ElementContainsCssClass(targetElement, "dxeTBIncBtn");
 },
 addRippleTargetClassNames: function(targetElement) {
  if(targetElement.className.indexOf(RippleHelper.rippleTargetClassName) !== -1) return;
  if(targetElement.initialClassName)
   targetElement.initialClassName += " " + RippleHelper.rippleTargetClassName;
  if(RippleHelper.needToAddRoundRippleClassName(targetElement))
   ASPx.AddClassNameToElement(targetElement, RippleHelper.externalRippleTargetClassName);
  ASPx.AddClassNameToElement(targetElement, RippleHelper.rippleTargetClassName);
 },
 attachRippleTargetClassNames: function() {
  setTimeout(RippleHelper.attachRippleTargetClassNamesInternal, 0);
 },
 attachRippleTargetClassNamesInternal: function() {
  if(!RippleHelper.getIsRippleFunctionalityEnabled())
   return;
  for(var j = 0; j < ThemesWithRipple.length; j++) {
   var targetElementList = [];
   for(var i = 0; i < RippleHelper.rippleTargetSelectorList.length; i++) {
    var resultSelector = RippleHelper.rippleTargetSelectorList[i].split("{0}").join(ThemesWithRipple[j]);
    targetElementList = targetElementList.concat(RippleHelper.getRippleTargetElements(resultSelector));
   }
   for(var i = 0; i < targetElementList.length; i++) {
    RippleHelper.addRippleTargetClassNames(targetElementList[i]);
   }
  }
 },
 isRippleFunctionalityEnabled: null,
 checkRippleFunctionality: function() {
  try {
   if(document.styleSheets) {
    for(var i = 0; i < document.styleSheets.length; i++) {
     var styleSheet = document.styleSheets[i];
     if(styleSheet.cssRules) {
      for(var j = 0; j < styleSheet.cssRules.length; j++)
       for(var k = 0; k < ThemesWithRipple.length; k++)
        if(styleSheet.cssRules[j].cssText.indexOf(ThemesWithRipple[k]) !== -1)
        return true;
     }
    }
   }
  }
  catch(err) { }
  return false;
 },
 getIsRippleFunctionalityEnabled: function() {
  if(!ASPx.IsExists(RippleHelper.isRippleFunctionalityEnabled))
   RippleHelper.isRippleFunctionalityEnabled = RippleHelper.checkRippleFunctionality();
  return RippleHelper.isRippleFunctionalityEnabled;
 },
 reset: function() {
  RippleHelper.isRippleFunctionalityEnabled = null;
  ASPx.RippleHelper.attachRippleTargetClassNames();
 },
 onDocumentMouseDown: function(evt) {
  if(RippleHelper.getIsRippleFunctionalityEnabled()) {    
   RippleHelper.processMouseDown(evt);
  }
 },
 needToProcessRipple: function(rippleTarget, evtSource) {
  return rippleTarget && ASPx.AnimationUtils && !ASPx.GetParentByPartialClassName(rippleTarget, "Disabled") && 
   !ASPx.ElementContainsCssClass(rippleTarget, "dxgvBatchEditCell") && 
   !ASPx.ElementContainsCssClass(rippleTarget, "dxcvEditForm") &&
   !ASPx.GetParentByPartialClassName(evtSource, "dxcvFocusedCell");
 },
 processMouseDown: function(evt) {
  var evtSource = ASPx.Evt.GetEventSource(evt);
  var rippleTarget = ASPx.GetParentByClassName(evtSource, RippleHelper.rippleTargetClassName);
  if(RippleHelper.needToProcessRipple(rippleTarget, evtSource))
   RippleHelper.processRipple(rippleTarget, evt);
 },
 getRippleTargetParentScrollAreaElement: function(rippleTarget) {
  var result = ASPx.GetParent(rippleTarget, function(element) {
   var elementStyle = ASPx.GetCurrentStyle(element);
   return elementStyle && (elementStyle.overflowY == "scroll" || elementStyle.overflowX == "scroll");
  });
  return result;
 },
 getRippleContainerAbsoluteYAndHeight: function(rippleTarget, scrollParent, isExternalRipple) {
  var rippleTargetY = ASPx.GetAbsoluteY(rippleTarget);
  var resultHeight = rippleTarget.offsetHeight;
  var resultY = rippleTargetY;
  if(!isExternalRipple && ASPx.IsExists(scrollParent) && ASPx.GetCurrentStyle(scrollParent).overflowY == "scroll") {
   var scrollAreaY = ASPx.GetAbsoluteY(scrollParent);
   var isElementHiddenByScrollArea = scrollAreaY > rippleTargetY;
   resultY = isElementHiddenByScrollArea ? scrollAreaY : rippleTargetY;
   var visibleHeight = isElementHiddenByScrollArea ? rippleTarget.offsetHeight + rippleTargetY - scrollAreaY :
   scrollParent.offsetHeight + scrollParent.scrollTop - rippleTarget.offsetTop;
   resultHeight = (rippleTarget.offsetHeight > visibleHeight ? visibleHeight : rippleTarget.offsetHeight);
  }
  return { height: resultHeight, y: resultY };
 },
 getRippleContainerAbsoluteXAndWidth: function(rippleTarget, scrollParent, isExternalRipple) {
  var rippleTargetX = ASPx.GetAbsoluteX(rippleTarget);
  var resultWidth = rippleTarget.offsetWidth;
  var resultX = rippleTargetX;
  if(!isExternalRipple && ASPx.IsExists(scrollParent) && ASPx.GetCurrentStyle(scrollParent).overflowX == "scroll") {
   var scrollAreaX = ASPx.GetAbsoluteX(scrollParent);
   var isElementHiddenByScrollArea = scrollAreaX > rippleTargetX;
   resultX = isElementHiddenByScrollArea ? scrollAreaX : rippleTargetX;
   var visibleWidth = isElementHiddenByScrollArea ? rippleTarget.offsetWidth + rippleTargetX - scrollAreaX :
   scrollParent.offsetWidth + scrollParent.scrollLeft - rippleTarget.offsetLeft;
   resultWidth = (rippleTarget.offsetWidth > visibleWidth ? visibleWidth : rippleTarget.offsetWidth);
  }
  return { width: resultWidth, x: resultX};
 },
 calculateRippleContainerSize: function(rippleTarget, isExternalRipple) {
  var scrollParent = RippleHelper.getRippleTargetParentScrollAreaElement(rippleTarget);
  var horSize = RippleHelper.getRippleContainerAbsoluteXAndWidth(rippleTarget, scrollParent, isExternalRipple);
  var vertSize = RippleHelper.getRippleContainerAbsoluteYAndHeight(rippleTarget, scrollParent, isExternalRipple);
  return { x: horSize.x, width: horSize.width, y: vertSize.y, height: vertSize.height };
 },
 createRippleTransition: function(container, element, radius) {
  var transitionProperties = {
   width: { from: 0, to: 2 * radius, transition: ASPx.AnimationConstants.Transitions.RIPPLE, propName: "width", unit: "px" },
   height: { from: 0, to: 2 * radius, transition: ASPx.AnimationConstants.Transitions.RIPPLE, propName: "height", unit: "px" },
   marginLeft: { from: 0, to: -radius, transition: ASPx.AnimationConstants.Transitions.RIPPLE, propName: "marginLeft", unit: "px" },
   marginTop: { from: 0, to: -radius, transition: ASPx.AnimationConstants.Transitions.RIPPLE, propName: "marginTop", unit: "px" },
   opacity: { from: 1, to: 0.1, transition: ASPx.AnimationConstants.Transitions.RIPPLE, propName: "opacity", unit: "%" }
  }
  var rippleTransition = ASPx.AnimationUtils.createMultipleAnimationTransition(element, {
   transition: ASPx.AnimationConstants.Transitions.RIPPLE,
   duration: 550,
   onComplete: function() {
    if(ASPx.IsExists(container.parentNode))
     container.parentNode.removeChild(container);
   }
  }).Start(transitionProperties);
 },
 processRipple: function(target, evt) {
  var isExternalRipple = ASPx.ElementContainsCssClass(target, RippleHelper.externalRippleTargetClassName);
  var posX = isExternalRipple ? ASPx.GetAbsoluteX(target) + target.offsetWidth / 2 : ASPxClientUtils.GetEventX(evt);
  var posY = isExternalRipple ? ASPx.GetAbsoluteY(target) + target.offsetHeight / 2 : ASPxClientUtils.GetEventY(evt);
  var container = document.createElement("DIV");
  container.className = RippleHelper.rippleContainerClassName;
  target.appendChild(container);
  var containerRect = RippleHelper.calculateRippleContainerSize(target, isExternalRipple);
  ASPx.SetStyles(container, {
   height: containerRect.height,
   width: containerRect.width,
   left: ASPx.PrepareClientPosForElement(containerRect.x, container, true),
   top: ASPx.PrepareClientPosForElement(containerRect.y, container, false)
  });
  var element = document.createElement("DIV");
  element.className = RippleHelper.rippleClassName;
  container.appendChild(element);
  ASPxClientUtils.SetAbsoluteX(element, posX);
  ASPxClientUtils.SetAbsoluteY(element, posY);
  var radius = -1;
  if(isExternalRipple) {
   radius = Math.max(container.offsetHeight, container.offsetWidth);
  } else {
   var width1 = posX - containerRect.x;
   var width2 = container.offsetWidth - width1;
   var height1 = posY - containerRect.y;
   var height2 = container.offsetHeight - height1;
   var rippleWidth = Math.max(width1, width2);
   var rippleHeight = Math.max(height1, height2);
   radius = Math.sqrt(Math.pow(rippleHeight, 2) + Math.pow(rippleWidth, 2));
  }
  RippleHelper.createRippleTransition(container, element, radius);
  setTimeout(function() {
   if(ASPx.IsExists(container.parentNode))
    container.parentNode.removeChild(container);
  }, 750);
 }
}
var AccessibilitySR = {
 AddStringResources: function(stringResourcesObj) {
  if(stringResourcesObj) {
   for(var key in stringResourcesObj)
    this[key] = stringResourcesObj[key];
  }
 }
};
ASPx.CollectionBase = CollectionBase;
ASPx.FunctionIsInCallstack = _aspxFunctionIsInCallstack;
ASPx.RaisePostHandlerOnPost = aspxRaisePostHandlerOnPost;
ASPx.GetPostHandler = aspxGetPostHandler;
ASPx.ProcessScriptsAndLinks = _aspxProcessScriptsAndLinks;
ASPx.InitializeLinks = _aspxInitializeLinks;
ASPx.InitializeScripts = _aspxInitializeScripts;
ASPx.RunStartupScripts = _aspxRunStartupScripts;
ASPx.IsStartupScriptsRunning = _aspxIsStartupScriptsRunning;
ASPx.AddScriptsRestartHandler = _aspxAddScriptsRestartHandler;
ASPx.GetFocusedElement = _aspxGetFocusedElement;
ASPx.GetDomObserver = _aspxGetDomObserver;
ASPx.CacheHelper = CacheHelper;
ASPx.ControlTree = ControlTree;
ASPx.ControlCallbackHandlersQueue = ControlCallbackHandlersQueue;
ASPx.ResourceManager = ResourceManager;
ASPx.UpdateWatcherHelper = UpdateWatcherHelper;
ASPx.EventStorage = EventStorage;
ASPx.GetGlobalObject = GetGlobalObject;
ASPx.GetExternalScriptProcessor = GetExternalScriptProcessor;
ASPx.CheckBoxCheckState = CheckBoxCheckState;
ASPx.CheckBoxInputKey = CheckBoxInputKey;
ASPx.CheckableElementStateController = CheckableElementStateController;
ASPx.CheckableElementHelper = CheckableElementHelper;
ASPx.CheckBoxInternal = CheckBoxInternal;
ASPx.CheckBoxInternalCollection = CheckBoxInternalCollection;
ASPx.ControlCallbackQueueHelper = ControlCallbackQueueHelper;
ASPx.EditorStyleDecoration = EditorStyleDecoration;
ASPx.AccessibilitySR = AccessibilitySR;
ASPx.KbdHelper = KbdHelper;
ASPx.AccessKeysHelper = AccessKeysHelper;
ASPx.AccessKey = AccessKey;
ASPx.IFrameHelper = IFrameHelper;
ASPx.Ident = Ident;
ASPx.TouchUIHelper = TouchUIHelper;
ASPx.ControlUpdateWatcher = ControlUpdateWatcher;
ASPx.AccessibilityHelperBase = AccessibilityHelperBase;
ASPx.RippleHelper = RippleHelper;
ASPx.ThemesWithRipple = ThemesWithRipple;
window.ASPxClientEvent = ASPxClientEvent;
window.ASPxClientEventArgs = ASPxClientEventArgs;
window.ASPxClientCancelEventArgs = ASPxClientCancelEventArgs;
window.ASPxClientProcessingModeEventArgs = ASPxClientProcessingModeEventArgs;
window.ASPxClientProcessingModeCancelEventArgs = ASPxClientProcessingModeCancelEventArgs;
ASPx.Evt.AttachEventToDocument(TouchUIHelper.touchMouseDownEventName, RippleHelper.onDocumentMouseDown);
ASPx.classesScriptParsed = true;
})();
(function () {
ASPx.StateItemsExist = false;
ASPx.FocusedItemKind = "FocusedStateItem";
ASPx.HoverItemKind = "HoverStateItem";
ASPx.PressedItemKind = "PressedStateItem";
ASPx.SelectedItemKind = "SelectedStateItem";
ASPx.DisabledItemKind = "DisabledStateItem";
ASPx.CachedStatePrefix = "cached";
ASPxStateItem = ASPx.CreateClass(null, {
 constructor: function(name, classNames, cssTexts, postfixes, imageObjs, imagePostfixes, kind, disableApplyingStyleToLink){
  this.name = name;
  this.classNames = classNames;
  this.customClassNames = [];
  this.resultClassNames = [];
  this.cssTexts = cssTexts;
  this.postfixes = postfixes;
  this.imageObjs = imageObjs;
  this.imagePostfixes = imagePostfixes;
  this.kind = kind;
  this.classNamePostfix = kind.substr(0, 1).toLowerCase();
  this.enabled = true;
  this.needRefreshBetweenElements = false;
  this.elements = null;
  this.images = null;
  this.links = [];
  this.linkColor = null;
  this.linkTextDecoration = null;
  this.disableApplyingStyleToLink = !!disableApplyingStyleToLink; 
 },
 GetCssText: function(index){
  if(ASPx.IsExists(this.cssTexts[index]))
   return this.cssTexts[index];
  return this.cssTexts[0];
 },
 CreateStyleRule: function(index){
  if(this.GetCssText(index) == "") return "";
  var styleSheet = ASPx.GetCurrentStyleSheet();
  if(styleSheet)
   return ASPx.CreateImportantStyleRule(styleSheet, this.GetCssText(index), this.classNamePostfix);  
  return ""; 
 },
 GetClassName: function(index){
  if(ASPx.IsExists(this.classNames[index]))
   return this.classNames[index];
  return this.classNames[0];
 },
 GetResultClassName: function(index){
  if(!ASPx.IsExists(this.resultClassNames[index])) {
   if(!ASPx.IsExists(this.customClassNames[index]))
    this.customClassNames[index] = this.CreateStyleRule(index);
   if(this.GetClassName(index) != "" && this.customClassNames[index] != "")
    this.resultClassNames[index] = this.GetClassName(index) + " " + this.customClassNames[index];
   else if(this.GetClassName(index) != "")
    this.resultClassNames[index] = this.GetClassName(index);
   else if(this.customClassNames[index] != "")
    this.resultClassNames[index] = this.customClassNames[index];
   else
    this.resultClassNames[index] = "";
  }
  return this.resultClassNames[index];
 },
 GetElements: function(element){
  if(!this.elements || !ASPx.IsValidElements(this.elements)){
   if(this.postfixes && this.postfixes.length > 0){
    this.elements = [ ];
    var parentNode = element.parentNode;
    if(parentNode){
     for(var i = 0; i < this.postfixes.length; i++){
      var id = this.name + this.postfixes[i];
      this.elements[i] = ASPx.GetChildById(parentNode, id);
      if(!this.elements[i])
       this.elements[i] = ASPx.GetElementById(id);
     }
    }
   }
   else
    this.elements = [element];
  }
  return this.elements;
 },
 GetImages: function(element){
  if(!this.images || !ASPx.IsValidElements(this.images)){
   this.images = [ ];
   if(this.imagePostfixes && this.imagePostfixes.length > 0){
    var elements = this.GetElements(element);
    for(var i = 0; i < this.imagePostfixes.length; i++){
     var id = this.name + this.imagePostfixes[i];
     for(var j = 0; j < elements.length; j++){
      if(!elements[j]) continue;
      if(elements[j].id == id)
       this.images[i] = elements[j];
      else
       this.images[i] = ASPx.GetChildById(elements[j], id);
      if(this.images[i])
       break;
     }
    }
   }
  }
  return this.images;
 },
 Apply: function(element){
  if(!this.enabled) return;
  try{
   this.ApplyStyle(element);
   if(this.imageObjs && this.imageObjs.length > 0)
    this.ApplyImage(element);
   if(ASPx.Browser.IE && ASPx.Browser.MajorVersion >= 11)
    this.ForceRedrawAppearance(element);
  }
  catch(e){
  }
 },
 ApplyStyle: function(element){
  var elements = this.GetElements(element);
  for(var i = 0; i < elements.length; i++){
   if(!elements[i]) continue;
   var className = elements[i].className.replace(this.GetResultClassName(i), "");
   elements[i].className = ASPx.Str.Trim(className) + " " + this.GetResultClassName(i);
   if(!ASPx.Browser.Opera || ASPx.Browser.Version >= 9)
    this.ApplyStyleToLinks(elements, i);
  }
 },
 ApplyStyleToLinks: function(elements, index){
  if(this.disableApplyingStyleToLink)
   return;
  if(!ASPx.IsValidElements(this.links[index]))
   this.links[index] = ASPx.GetNodesByTagName(elements[index], "A");
  for(var i = 0; i < this.links[index].length; i++)
   this.ApplyStyleToLinkElement(this.links[index][i], index);
 },
 ApplyStyleToLinkElement: function(link, index){
  if(this.GetLinkColor(index) != "")
   ASPx.Attr.ChangeAttributeExtended(link.style, "color", link, "saved" + this.kind + "Color", this.GetLinkColor(index));
  if(this.GetLinkTextDecoration(index) != "")
   ASPx.Attr.ChangeAttributeExtended(link.style, "textDecoration", link, "saved" + this.kind + "TextDecoration", this.GetLinkTextDecoration(index));
 },
 ApplyImage: function(element){
  var images = this.GetImages(element);
  for(var i = 0; i < images.length; i++){
   if(!images[i] || !this.imageObjs[i]) continue;
   var useSpriteImage = typeof(this.imageObjs[i]) != "string";
   var newUrl = "", newCssClass = "", newBackground = "";
   if(useSpriteImage){
    newUrl = ASPx.EmptyImageUrl;           
    if(this.imageObjs[i].spriteCssClass) 
     newCssClass = this.imageObjs[i].spriteCssClass;
    if(this.imageObjs[i].spriteBackground)
     newBackground = this.imageObjs[i].spriteBackground;
   }
   else{
    newUrl = this.imageObjs[i];
    if(ASPx.Attr.IsExistsAttribute(images[i].style, "background"))   
     newBackground = " ";
   }
   if(newUrl != "")
    ASPx.Attr.ChangeAttributeExtended(images[i], "src", images[i], "saved" + this.kind + "Src", newUrl);
   if(newCssClass != "")
    this.ApplyImageClassName(images[i], newCssClass);
   if(newBackground != ""){
    if(ASPx.Browser.WebKitFamily) {
     var savedBackground = ASPx.Attr.GetAttribute(images[i].style, "background");
     if(!useSpriteImage)
      savedBackground += " " + images[i].style["backgroundPosition"];
     ASPx.Attr.SetAttribute(images[i], "saved" + this.kind + "Background", savedBackground);
     ASPx.Attr.SetAttribute(images[i].style, "background", newBackground);
    }
    else
     ASPx.Attr.ChangeAttributeExtended(images[i].style, "background", images[i], "saved" + this.kind + "Background", newBackground);
   }     
  }
 },
 ApplyImageClassName: function(element, newClassName){
  var className = element.className.replace(newClassName, "");
  ASPx.Attr.SetAttribute(element, "saved" + this.kind + "ClassName", className);
  element.className = className + " " + newClassName;
 },
 Cancel: function(element){
  if(!this.enabled) return;
  try{  
   if(this.imageObjs && this.imageObjs.length > 0)
    this.CancelImage(element);
   this.CancelStyle(element);
  }
  catch(e){
  }
 },
 CancelStyle: function(element){
  var elements = this.GetElements(element);
  for(var i = 0; i < elements.length; i++){
   if(!elements[i]) continue;
   var className = ASPx.Str.Trim(elements[i].className.replace(this.GetResultClassName(i), ""));
   elements[i].className = className;
   if(!ASPx.Browser.Opera || ASPx.Browser.Version >= 9)
    this.CancelStyleFromLinks(elements, i);
  }
 },
 CancelStyleFromLinks: function(elements, index){
  if(this.disableApplyingStyleToLink)
   return;
  if(!ASPx.IsValidElements(this.links[index]))
   this.links[index] = ASPx.GetNodesByTagName(elements[index], "A");
  for(var i = 0; i < this.links[index].length; i++)
   this.CancelStyleFromLinkElement(this.links[index][i], index);
 },
 CancelStyleFromLinkElement: function(link, index){
  if(this.GetLinkColor(index) != "")
   ASPx.Attr.RestoreAttributeExtended(link.style, "color", link, "saved" + this.kind + "Color");
  if(this.GetLinkTextDecoration(index) != "")
   ASPx.Attr.RestoreAttributeExtended(link.style, "textDecoration", link, "saved" + this.kind + "TextDecoration");
 },
 CancelImage: function(element){
  var images = this.GetImages(element);
  for(var i = 0; i < images.length; i++){
   if(!images[i] || !this.imageObjs[i]) continue;
   ASPx.Attr.RestoreAttributeExtended(images[i], "src", images[i], "saved" + this.kind + "Src");
   this.CancelImageClassName(images[i]);
   ASPx.Attr.RestoreAttributeExtended(images[i].style, "background", images[i], "saved" + this.kind + "Background");
  }
 },
 CancelImageClassName: function(element){
  var savedClassName = ASPx.Attr.GetAttribute(element, "saved" + this.kind + "ClassName");
  if(ASPx.IsExists(savedClassName)) {
   element.className = savedClassName;
   ASPx.Attr.RemoveAttribute(element, "saved" + this.kind + "ClassName");
  }
 },
 Clone: function(){
  return new ASPxStateItem(this.name, this.classNames, this.cssTexts, this.postfixes, 
   this.imageObjs, this.imagePostfixes, this.kind, this.disableApplyingStyleToLink);
 },
 IsChildElement: function(element){
  if(element != null){
   var elements = this.GetElements(element);
   for(var i = 0; i < elements.length; i++){
    if(!elements[i]) continue;
    if(ASPx.GetIsParent(elements[i], element)) 
     return true;
   }
  }
  return false;
 },
 ForceRedrawAppearance: function(element) {
  if(!aspxGetStateController().IsForceRedrawAppearanceLocked()) {
   var value = element.style.opacity;
   element.style.opacity = "0.7777";
   var dummy = element.offsetWidth;
   element.style.opacity = value;
  }
 },
 GetLinkColor: function(index){
  if(!ASPx.IsExists(this.linkColor)){
   var rule = ASPx.GetStyleSheetRules(this.customClassNames[index]);
   this.linkColor = rule ? rule.style.color : null;
   if(!ASPx.IsExists(this.linkColor)){
    var rule = ASPx.GetStyleSheetRules(this.GetClassName(index));
    this.linkColor = rule ? rule.style.color : null;
   }
   if(this.linkColor == null) 
    this.linkColor = "";
  }
  return this.linkColor;
 },
 GetLinkTextDecoration: function(index){
  if(!ASPx.IsExists(this.linkTextDecoration)){
   var rule = ASPx.GetStyleSheetRules(this.customClassNames[index]);
   this.linkTextDecoration = rule ? rule.style.textDecoration : null;
   if(!ASPx.IsExists(this.linkTextDecoration)){
    var rule = ASPx.GetStyleSheetRules(this.GetClassName(index));
    this.linkTextDecoration = rule ? rule.style.textDecoration : null;
   }
   if(this.linkTextDecoration == null) 
    this.linkTextDecoration = "";
  }
  return this.linkTextDecoration;
 }
});
ASPxClientStateEventArgs = ASPx.CreateClass(null, {
 constructor: function(item, element){
  this.item = item;
  this.element = element;
  this.toElement = null;
  this.fromElement = null;
  this.htmlEvent = null;
 }
});
ASPxStateController = ASPx.CreateClass(null, {
 constructor: function(){
  this.focusedItems = { };
  this.hoverItems = { };
  this.pressedItems = { };
  this.selectedItems = { };
  this.disabledItems = { };
  this.disabledScheme = {};
  this.currentFocusedElement = null;
  this.currentFocusedItemName = null;
  this.currentHoverElement = null;
  this.currentHoverItemName = null;
  this.currentPressedElement = null;
  this.currentPressedItemName = null;
  this.savedCurrentPressedElement = null;
  this.savedCurrentMouseMoveSrcElement = null;
  this.forceRedrawAppearanceLockCount = 0;
  this.AfterSetFocusedState = new ASPxClientEvent();
  this.AfterClearFocusedState = new ASPxClientEvent();
  this.AfterSetHoverState = new ASPxClientEvent();
  this.AfterClearHoverState = new ASPxClientEvent();
  this.AfterSetPressedState = new ASPxClientEvent();
  this.AfterClearPressedState = new ASPxClientEvent();
  this.AfterDisabled = new ASPxClientEvent();
  this.AfterEnabled = new ASPxClientEvent();
  this.BeforeSetFocusedState = new ASPxClientEvent();
  this.BeforeClearFocusedState = new ASPxClientEvent();
  this.BeforeSetHoverState = new ASPxClientEvent();
  this.BeforeClearHoverState = new ASPxClientEvent();
  this.BeforeSetPressedState = new ASPxClientEvent();
  this.BeforeClearPressedState = new ASPxClientEvent();
  this.BeforeDisabled = new ASPxClientEvent();
  this.BeforeEnabled = new ASPxClientEvent();
  this.FocusedItemKeyDown = new ASPxClientEvent();
 }, 
 AddHoverItem: function(name, classNames, cssTexts, postfixes, imageObjs, imagePostfixes, disableApplyingStyleToLink){
  this.AddItem(this.hoverItems, name, classNames, cssTexts, postfixes, imageObjs, imagePostfixes, ASPx.HoverItemKind, disableApplyingStyleToLink);
  this.AddItem(this.focusedItems, name, classNames, cssTexts, postfixes, imageObjs, imagePostfixes, ASPx.FocusedItemKind, disableApplyingStyleToLink);
 },
 AddPressedItem: function(name, classNames, cssTexts, postfixes, imageObjs, imagePostfixes ,disableApplyingStyleToLink){
  this.AddItem(this.pressedItems, name, classNames, cssTexts, postfixes, imageObjs, imagePostfixes, ASPx.PressedItemKind, disableApplyingStyleToLink);
 },
 AddSelectedItem: function(name, classNames, cssTexts, postfixes, imageObjs, imagePostfixes, disableApplyingStyleToLink){
  this.AddItem(this.selectedItems, name, classNames, cssTexts, postfixes, imageObjs, imagePostfixes, ASPx.SelectedItemKind, disableApplyingStyleToLink);
 },
 AddDisabledItem: function (name, classNames, cssTexts, postfixes, imageObjs, imagePostfixes, disableApplyingStyleToLink, rootId) {
  this.AddItem(this.disabledItems, name, classNames, cssTexts, postfixes, imageObjs, imagePostfixes,
   ASPx.DisabledItemKind, disableApplyingStyleToLink, this.addIdToDisabledItemScheme, rootId);
 },
 addIdToDisabledItemScheme: function(rootId, childId) {
  if (!rootId)
   return;
  if (!this.disabledScheme[rootId])
   this.disabledScheme[rootId] = [rootId];
  if (childId && (rootId != childId) && ASPx.Data.ArrayIndexOf(this.disabledScheme[rootId], childId) == -1)
   this.disabledScheme[rootId].push(childId);
 },
 removeIdFromDisabledItemScheme: function(rootId, childId) {
  if (!rootId || !this.disabledScheme[rootId])
   return;
  ASPx.Data.ArrayRemove(this.disabledScheme[rootId], childId);
  if (this.disabledScheme[rootId].length == 0)
   delete this.disabledScheme[rootId];
 },
 AddItem: function (items, name, classNames, cssTexts, postfixes, imageObjs, imagePostfixes, kind, disableApplyingStyleToLink, onAdd, rootId) {
  var stateItem = new ASPxStateItem(name, classNames, cssTexts, postfixes, imageObjs, imagePostfixes, kind, disableApplyingStyleToLink);
  if (postfixes && postfixes.length > 0) {
   for (var i = 0; i < postfixes.length; i++) {
    items[name + postfixes[i]] = stateItem;
    if (onAdd)
     onAdd.call(this, rootId, name + postfixes[i]);
   }
  }
  else {
   if (onAdd)
    onAdd.call(this, rootId, name);
   items[name] = stateItem;
  }
  ASPx.StateItemsExist = true;
 },
 RemoveHoverItem: function(name, postfixes){
  this.RemoveItem(this.hoverItems, name, postfixes);
  this.RemoveItem(this.focusedItems, name, postfixes);
 },
 RemovePressedItem: function(name, postfixes){
  this.RemoveItem(this.pressedItems, name, postfixes);
 },
 RemoveSelectedItem: function(name, postfixes){
  this.RemoveItem(this.selectedItems, name, postfixes);
 },
 RemoveDisabledItem: function (name, postfixes, rootId) {
  this.RemoveItem(this.disabledItems, name, postfixes, this.removeIdFromDisabledItemScheme, rootId);
 },
 RemoveItem: function (items, name, postfixes, onRemove, rootId) {
  if (postfixes && postfixes.length > 0) {
   for (var i = 0; i < postfixes.length; i++) {
    delete items[name + postfixes[i]];
    if (onRemove)
     onRemove.call(this, rootId, name + postfixes[i]);
   }
  }
  else {
   delete items[name];
   if (onRemove)
    onRemove.call(this, rootId, name);
  }
 },
 RemoveDisposedItems: function(){
  this.RemoveDisposedItemsByType(this.hoverItems);
  this.RemoveDisposedItemsByType(this.pressedItems);
  this.RemoveDisposedItemsByType(this.focusedItems);
  this.RemoveDisposedItemsByType(this.selectedItems);
  this.RemoveDisposedItemsByType(this.disabledItems);
  this.RemoveDisposedItemsByType(this.disabledScheme);
 },
 RemoveDisposedItemsByType: function(items){
  for(var key in items) {
   var item = items[key];
   var element = document.getElementById(key);
   if(!element || !ASPx.IsValidElement(element))
    delete items[key];
   try{
    if(item && item.elements) {
     for(var i = 0; i < item.elements.length; i++) {
      if(!ASPx.IsValidElements(item.links[i]))
       item.links[i] = null;
     }
    }
   }
   catch(e){
   }
  }
 },
 GetFocusedElement: function(srcElement){
  return this.GetItemElement(srcElement, this.focusedItems, ASPx.FocusedItemKind);
 },
 GetHoverElement: function(srcElement){
  return this.GetItemElement(srcElement, this.hoverItems, ASPx.HoverItemKind);
 },
 GetPressedElement: function(srcElement){
  return this.GetItemElement(srcElement, this.pressedItems, ASPx.PressedItemKind);
 },
 GetSelectedElement: function(srcElement){
  return this.GetItemElement(srcElement, this.selectedItems, ASPx.SelectedItemKind);
 },
 GetDisabledElement: function(srcElement){
  return this.GetItemElement(srcElement, this.disabledItems, ASPx.DisabledItemKind);
 },
 GetItemElement: function(srcElement, items, kind){
  if(srcElement && srcElement[ASPx.CachedStatePrefix + kind]){
   var cachedElement = srcElement[ASPx.CachedStatePrefix + kind];
   if(cachedElement != ASPx.EmptyObject)
    return cachedElement;
   return null;
  }
  var element = srcElement;
  while(element != null) {
   var item = items[element.id];
   if(item){
    this.CacheItemElement(srcElement, kind, element);
    element[kind] = item;
    return element;
   }
   element = element.parentNode;
  }
  this.CacheItemElement(srcElement, kind, ASPx.EmptyObject);
  return null;
 },
 CacheItemElement: function(srcElement, kind, value){
  if(srcElement && !srcElement[ASPx.CachedStatePrefix + kind])
   srcElement[ASPx.CachedStatePrefix + kind] = value;
 },
 DoSetFocusedState: function(element, fromElement){
  var item = element[ASPx.FocusedItemKind];
  if(item){
   var args = new ASPxClientStateEventArgs(item, element);
   args.fromElement = fromElement;
   this.BeforeSetFocusedState.FireEvent(this, args);
   item.Apply(element);
   this.AfterSetFocusedState.FireEvent(this, args);
  }
 },
 DoClearFocusedState: function(element, toElement){
  var item = element[ASPx.FocusedItemKind];
  if(item){
   var args = new ASPxClientStateEventArgs(item, element);
   args.toElement = toElement;
   this.BeforeClearFocusedState.FireEvent(this, args);
   item.Cancel(element);
   this.AfterClearFocusedState.FireEvent(this, args);
  }
 },
 DoSetHoverState: function(element, fromElement){
  var item = element[ASPx.HoverItemKind];
  if(item){
   var args = new ASPxClientStateEventArgs(item, element);
   args.fromElement = fromElement;
   this.BeforeSetHoverState.FireEvent(this, args);
   item.Apply(element);
   this.AfterSetHoverState.FireEvent(this, args);
  }
 },
 DoClearHoverState: function(element, toElement){
  var item = element[ASPx.HoverItemKind];
  if(item){
   var args = new ASPxClientStateEventArgs(item, element);
   args.toElement = toElement;
   this.BeforeClearHoverState.FireEvent(this, args);
   item.Cancel(element);
   this.AfterClearHoverState.FireEvent(this, args);
  }
 },
 DoSetPressedState: function(element){
  var item = element[ASPx.PressedItemKind];
  if(item){
   var args = new ASPxClientStateEventArgs(item, element);
   this.BeforeSetPressedState.FireEvent(this, args);
   item.Apply(element);
   this.AfterSetPressedState.FireEvent(this, args);
  }
 },
 DoClearPressedState: function(element){
  var item = element[ASPx.PressedItemKind];
  if(item){
   var args = new ASPxClientStateEventArgs(item, element);
   this.BeforeClearPressedState.FireEvent(this, args);
   item.Cancel(element);
   this.AfterClearPressedState.FireEvent(this, args);
  }
 },
 SetCurrentFocusedElement: function(element){
  if(this.currentFocusedElement && !ASPx.IsValidElement(this.currentFocusedElement)){
   this.currentFocusedElement = null;
   this.currentFocusedItemName = "";
  }
  if(this.currentFocusedElement != element){
   var oldCurrentFocusedElement = this.currentFocusedElement;
   var item = (element != null) ? element[ASPx.FocusedItemKind] : null;
   var itemName = (item != null) ? item.name : "";
   if(this.currentFocusedItemName != itemName){
    if(this.currentHoverItemName != "")
     this.SetCurrentHoverElement(null);
    if(this.currentFocusedElement != null)
     this.DoClearFocusedState(this.currentFocusedElement, element);
    this.currentFocusedElement = element;
    item = (element != null) ? element[ASPx.FocusedItemKind] : null;
    this.currentFocusedItemName = (item != null) ? item.name : "";
    if(this.currentFocusedElement != null)
     this.DoSetFocusedState(this.currentFocusedElement, oldCurrentFocusedElement);
   }
  }
 },
 SetCurrentHoverElement: function(element){
  if(this.currentHoverElement && !ASPx.IsValidElement(this.currentHoverElement)){
   this.currentHoverElement = null;
   this.currentHoverItemName = "";
  }
  var item = (element != null) ? element[ASPx.HoverItemKind] : null;
  if(item && !item.enabled) { 
   element = this.GetItemElement(element.parentNode, this.hoverItems, ASPx.HoverItemKind);
   item = (element != null) ? element[ASPx.HoverItemKind] : null;
  }
  if(this.currentHoverElement != element){
   var oldCurrentHoverElement = this.currentHoverElement,
    itemName = (item != null) ? item.name : "";
   if(this.currentHoverItemName != itemName || (item != null && item.needRefreshBetweenElements)){
    if(this.currentHoverElement != null)
     this.DoClearHoverState(this.currentHoverElement, element);
    item = (element != null) ? element[ASPx.HoverItemKind] : null;
    if(item == null || item.enabled){
     this.currentHoverElement = element;
     this.currentHoverItemName = (item != null) ? item.name : "";
     if(this.currentHoverElement != null)
      this.DoSetHoverState(this.currentHoverElement, oldCurrentHoverElement);
    }
   }
  }
 },
 SetCurrentPressedElement: function(element){
  if(this.currentPressedElement && !ASPx.IsValidElement(this.currentPressedElement)){
   this.currentPressedElement = null;
   this.currentPressedItemName = "";
  }
  if(this.currentPressedElement != element){
   if(this.currentPressedElement != null)
    this.DoClearPressedState(this.currentPressedElement);
   var item = (element != null) ? element[ASPx.PressedItemKind] : null;
   if(item == null || item.enabled){
    this.currentPressedElement = element;
    this.currentPressedItemName = (item != null) ? item.name : "";
    if(this.currentPressedElement != null)
     this.DoSetPressedState(this.currentPressedElement);
   }
  }
 },
 SetCurrentFocusedElementBySrcElement: function(srcElement){
  var element = this.GetFocusedElement(srcElement);
  this.SetCurrentFocusedElement(element);
 },
 SetCurrentHoverElementBySrcElement: function(srcElement){
  var element = this.GetHoverElement(srcElement);
  this.SetCurrentHoverElement(element);
 },
 SetCurrentPressedElementBySrcElement: function(srcElement){
  var element = this.GetPressedElement(srcElement);
  this.SetCurrentPressedElement(element);
 },
 SetPressedElement: function (element) {
  this.SetCurrentHoverElement(null);
  this.SetCurrentPressedElementBySrcElement(element);
  this.savedCurrentPressedElement = this.currentPressedElement;
 },
 SelectElement: function (element) {
  var item = element[ASPx.SelectedItemKind];
  if(item)
   item.Apply(element);
 }, 
 SelectElementBySrcElement: function(srcElement){
  var element = this.GetSelectedElement(srcElement);
  if(element != null) this.SelectElement(element);
 }, 
 DeselectElement: function(element){
  var item = element[ASPx.SelectedItemKind];
  if(item)
   item.Cancel(element);
 }, 
 DeselectElementBySrcElement: function(srcElement){
  var element = this.GetSelectedElement(srcElement);
  if(element != null) this.DeselectElement(element);
 },
 SetElementEnabled: function(element, enable){
  if(enable)
   this.EnableElement(element);
  else
   this.DisableElement(element);
 },
 SetElementWithChildNodesEnabled: function (parentName, enabled) {
  var procFunct = (enabled ? this.EnableElement : this.DisableElement);
  var childItems = this.disabledScheme[parentName];
  if (childItems && childItems.length > 0)
   for (var i = 0; i < childItems.length; i++) {
    procFunct.call(this, document.getElementById(childItems[i]));
   }
 },
 DisableElement: function (element) {
  var element = this.GetDisabledElement(element);
  if(element != null) {
   var item = element[ASPx.DisabledItemKind];
   if(item){
    var args = new ASPxClientStateEventArgs(item, element);
    this.BeforeDisabled.FireEvent(this, args);
    if(item.name == this.currentPressedItemName)
     this.SetCurrentPressedElement(null);
    if(item.name == this.currentHoverItemName)
     this.SetCurrentHoverElement(null);
    item.Apply(element);
    this.SetMouseStateItemsEnabled(item.name, item.postfixes, false);
    this.AfterDisabled.FireEvent(this, args);
   }
  }
 }, 
 EnableElement: function(element){
  var element = this.GetDisabledElement(element);
  if(element != null) {
   var item = element[ASPx.DisabledItemKind];
   if(item){
    var args = new ASPxClientStateEventArgs(item, element);
    this.BeforeEnabled.FireEvent(this, args);
    item.Cancel(element);
    this.SetMouseStateItemsEnabled(item.name, item.postfixes, true);
    this.AfterEnabled.FireEvent(this, args);
   }
  }
 }, 
 SetMouseStateItemsEnabled: function(name, postfixes, enabled){   
  if(postfixes && postfixes.length > 0){
   for(var i = 0; i < postfixes.length; i ++){
    this.SetItemsEnabled(this.hoverItems, name + postfixes[i], enabled);
    this.SetItemsEnabled(this.pressedItems, name + postfixes[i], enabled);
    this.SetItemsEnabled(this.focusedItems, name + postfixes[i], enabled);
   }
  }
  else{
   this.SetItemsEnabled(this.hoverItems, name, enabled);
   this.SetItemsEnabled(this.pressedItems, name, enabled);
   this.SetItemsEnabled(this.focusedItems, name, enabled);
  }  
 },
 SetItemsEnabled: function(items, name, enabled){   
  if(items[name])
   items[name].enabled = enabled;
 },
 OnFocusMove: function(evt){
  var element = ASPx.Evt.GetEventSource(evt);
  aspxGetStateController().SetCurrentFocusedElementBySrcElement(element);
 },
 OnMouseMove: function(evt, checkElementChanged){
  var srcElement = ASPx.Evt.GetEventSource(evt);
  if(checkElementChanged && srcElement == this.savedCurrentMouseMoveSrcElement) return;
  this.savedCurrentMouseMoveSrcElement = srcElement;
  if(ASPx.Browser.IE && !ASPx.Evt.IsLeftButtonPressed(evt) && this.savedCurrentPressedElement != null)
   this.ClearSavedCurrentPressedElement();
  if(this.savedCurrentPressedElement == null)
   this.SetCurrentHoverElementBySrcElement(srcElement);
  else{
   var element = this.GetPressedElement(srcElement);
   if(element != this.currentPressedElement){
    if(element == this.savedCurrentPressedElement)
     this.SetCurrentPressedElement(this.savedCurrentPressedElement);
    else
     this.SetCurrentPressedElement(null);
   }
  }
 },
 OnMouseDown: function(evt){
  if(!ASPx.Evt.IsLeftButtonPressed(evt)) return;
  var srcElement = ASPx.Evt.GetEventSource(evt);
  this.OnMouseDownOnElement(srcElement);
 },
 OnMouseDownOnElement: function (element) {
  if(this.GetPressedElement(element) == null) return;
  this.SetPressedElement(element);
 },
 OnMouseUp: function(evt){
  var srcElement = ASPx.Evt.GetEventSource(evt);
  this.OnMouseUpOnElement(srcElement);
 },
 OnMouseUpOnElement: function(element){
  if(this.savedCurrentPressedElement == null) return;
  this.ClearSavedCurrentPressedElement();
  this.SetCurrentHoverElementBySrcElement(element);
 },
 OnMouseOver: function(evt){
  var element = ASPx.Evt.GetEventSource(evt);
  if(element && element.tagName == "IFRAME")
   this.OnMouseMove(evt, true);
 },
 OnKeyDown: function(evt){
  var element = this.GetFocusedElement(ASPx.Evt.GetEventSource(evt));
  if(element != null && element == this.currentFocusedElement) {
   var item = element[ASPx.FocusedItemKind];
   if(item){
    var args = new ASPxClientStateEventArgs(item, element);
    args.htmlEvent = evt;
    this.FocusedItemKeyDown.FireEvent(this, args);
   }
  }
 },
 OnSelectStart: function(evt){
  if(this.savedCurrentPressedElement) {
   ASPx.Selection.Clear();
   return false;
  }
 },
 ClearSavedCurrentPressedElement: function() {
  this.savedCurrentPressedElement = null;
  this.SetCurrentPressedElement(null);
 },
 ClearCache: function(srcElement, kind) {
  if(srcElement[ASPx.CachedStatePrefix + kind])
   srcElement[ASPx.CachedStatePrefix + kind] = null;
 },
 ClearElementCache: function(srcElement) {
  this.ClearCache(srcElement, ASPx.FocusedItemKind);
  this.ClearCache(srcElement, ASPx.HoverItemKind);
  this.ClearCache(srcElement, ASPx.PressedItemKind);
  this.ClearCache(srcElement, ASPx.SelectedItemKind);
  this.ClearCache(srcElement, ASPx.DisabledItemKind);
 },
 LockForceRedrawAppearance: function() {
  this.forceRedrawAppearanceLockCount++;
 },
 UnlockForceRedrawAppearance: function() {
  this.forceRedrawAppearanceLockCount--;
 },
 IsForceRedrawAppearanceLocked: function() {
  return this.forceRedrawAppearanceLockCount > 0;
 }
});
var stateController = null;
function aspxGetStateController(){
 if(stateController == null)
  stateController = new ASPxStateController();
 return stateController;
}
function aspxAddStateItems(method, namePrefix, classes, disableApplyingStyleToLink){
 for(var i = 0; i < classes.length; i ++){
  for(var j = 0; j < classes[i][2].length; j ++) {
   var name = namePrefix;
   if(classes[i][2][j])
    name += "_" + classes[i][2][j];
   var postfixes = classes[i][3] || null;
   var imageObjs = (classes[i][4] && classes[i][4][j]) || null;
   var imagePostfixes = classes[i][5] || null;
   method.call(aspxGetStateController(), name, classes[i][0], classes[i][1], postfixes, imageObjs, imagePostfixes, disableApplyingStyleToLink, namePrefix);
  }
 }
}
ASPx.AddHoverItems = function(namePrefix, classes, disableApplyingStyleToLink){
 aspxAddStateItems(aspxGetStateController().AddHoverItem, namePrefix, classes, disableApplyingStyleToLink);
}
ASPx.AddPressedItems = function(namePrefix, classes, disableApplyingStyleToLink){
 aspxAddStateItems(aspxGetStateController().AddPressedItem, namePrefix, classes, disableApplyingStyleToLink);
}
ASPx.AddSelectedItems = function(namePrefix, classes, disableApplyingStyleToLink){
 aspxAddStateItems(aspxGetStateController().AddSelectedItem, namePrefix, classes, disableApplyingStyleToLink);
}
ASPx.AddDisabledItems = function(namePrefix, classes, disableApplyingStyleToLink){
 aspxAddStateItems(aspxGetStateController().AddDisabledItem, namePrefix, classes, disableApplyingStyleToLink);
}
function aspxRemoveStateItems(method, namePrefix, classes){
 for(var i = 0; i < classes.length; i ++){
  for(var j = 0; j < classes[i][0].length; j ++) {
   var name = namePrefix;
   if(classes[i][0][j])
    name += "_" + classes[i][0][j];
   method.call(aspxGetStateController(), name, classes[i][1], namePrefix);
  }
 }
}
ASPx.RemoveHoverItems = function(namePrefix, classes){
 aspxRemoveStateItems(aspxGetStateController().RemoveHoverItem, namePrefix, classes);
}
ASPx.RemovePressedItems = function(namePrefix, classes){
 aspxRemoveStateItems(aspxGetStateController().RemovePressedItem, namePrefix, classes);
}
ASPx.RemoveSelectedItems = function(namePrefix, classes){
 aspxRemoveStateItems(aspxGetStateController().RemoveSelectedItem, namePrefix, classes);
}
ASPx.RemoveDisabledItems = function(namePrefix, classes){
 aspxRemoveStateItems(aspxGetStateController().RemoveDisabledItem, namePrefix, classes);
}
ASPx.AddAfterClearFocusedState = function(handler){
 aspxGetStateController().AfterClearFocusedState.AddHandler(handler);
}
ASPx.AddAfterSetFocusedState = function(handler){
 aspxGetStateController().AfterSetFocusedState.AddHandler(handler);
}
ASPx.AddAfterClearHoverState = function(handler){
 aspxGetStateController().AfterClearHoverState.AddHandler(handler);
}
ASPx.AddAfterSetHoverState = function(handler){
 aspxGetStateController().AfterSetHoverState.AddHandler(handler);
}
ASPx.AddAfterClearPressedState = function(handler){
 aspxGetStateController().AfterClearPressedState.AddHandler(handler);
}
ASPx.AddAfterSetPressedState = function(handler){
 aspxGetStateController().AfterSetPressedState.AddHandler(handler);
}
ASPx.AddAfterDisabled = function(handler){
 aspxGetStateController().AfterDisabled.AddHandler(handler);
}
ASPx.AddAfterEnabled = function(handler){
 aspxGetStateController().AfterEnabled.AddHandler(handler);
}
ASPx.AddBeforeClearFocusedState = function(handler){
 aspxGetStateController().BeforeClearFocusedState.AddHandler(handler);
}
ASPx.AddBeforeSetFocusedState = function(handler){
 aspxGetStateController().BeforeSetFocusedState.AddHandler(handler);
}
ASPx.AddBeforeClearHoverState = function(handler){
 aspxGetStateController().BeforeClearHoverState.AddHandler(handler);
}
ASPx.AddBeforeSetHoverState = function(handler){
 aspxGetStateController().BeforeSetHoverState.AddHandler(handler);
}
ASPx.AddBeforeClearPressedState = function(handler){
 aspxGetStateController().BeforeClearPressedState.AddHandler(handler);
}
ASPx.AddBeforeSetPressedState = function(handler){
 aspxGetStateController().BeforeSetPressedState.AddHandler(handler);
}
ASPx.AddBeforeDisabled = function(handler){
 aspxGetStateController().BeforeDisabled.AddHandler(handler);
}
ASPx.AddBeforeEnabled = function(handler){
 aspxGetStateController().BeforeEnabled.AddHandler(handler);
}
ASPx.AddFocusedItemKeyDown = function(handler){
 aspxGetStateController().FocusedItemKeyDown.AddHandler(handler);
}
ASPx.SetHoverState = function(element){
 aspxGetStateController().SetCurrentHoverElementBySrcElement(element);
}
ASPx.ClearHoverState = function(evt){
 aspxGetStateController().SetCurrentHoverElementBySrcElement(null);
}
ASPx.UpdateHoverState = function(evt){
 aspxGetStateController().OnMouseMove(evt, false);
}
ASPx.SetFocusedState = function(element){
 aspxGetStateController().SetCurrentFocusedElementBySrcElement(element);
}
ASPx.ClearFocusedState = function(evt){
 aspxGetStateController().SetCurrentFocusedElementBySrcElement(null);
}
ASPx.UpdateFocusedState = function(evt){
 aspxGetStateController().OnFocusMove(evt);
}
ASPx.AccessibilityMarkerClass = "dxalink";
ASPx.AssignAccessibilityEventsToChildrenLinks = function(container, clearFocusedStateOnMouseOut){
 var links = ASPx.GetNodesByPartialClassName(container, ASPx.AccessibilityMarkerClass);
 for(var i = 0; i < links.length; i++)
  ASPx.AssignAccessibilityEventsToLink(links[i], clearFocusedStateOnMouseOut);
}
ASPx.AssignAccessibilityEventsToLink = function(link, clearFocusedStateOnMouseOut) {
 if(!ASPx.ElementContainsCssClass(link, ASPx.AccessibilityMarkerClass))
  return;
 ASPx.Evt.AttachEventToElement(link, "focus", function(e) { ASPx.UpdateFocusedState(e); });
 var clearFocusedStateHandler = function(e) { ASPx.ClearFocusedState(e); };
 ASPx.Evt.AttachEventToElement(link, "blur", clearFocusedStateHandler);
 if(clearFocusedStateOnMouseOut)
  ASPx.Evt.AttachEventToElement(link, "mouseout", clearFocusedStateHandler);
}
ASPx.Evt.AttachEventToDocument("mousemove", function(evt) {
 if(ASPx.classesScriptParsed && ASPx.StateItemsExist)
  aspxGetStateController().OnMouseMove(evt, true);
});
ASPx.Evt.AttachEventToDocument(ASPx.TouchUIHelper.touchMouseDownEventName, function(evt) {
 if(ASPx.classesScriptParsed && ASPx.StateItemsExist)
  aspxGetStateController().OnMouseDown(evt);
});
ASPx.Evt.AttachEventToDocument(ASPx.TouchUIHelper.touchMouseUpEventName, function(evt) {
 if(ASPx.classesScriptParsed && ASPx.StateItemsExist)
  aspxGetStateController().OnMouseUp(evt);
});
ASPx.Evt.AttachEventToDocument("mouseover", function(evt) {
 if(ASPx.classesScriptParsed && ASPx.StateItemsExist)
  aspxGetStateController().OnMouseOver(evt);
});
ASPx.Evt.AttachEventToDocument("keydown", function(evt) {
 if(ASPx.classesScriptParsed && ASPx.StateItemsExist)
  aspxGetStateController().OnKeyDown(evt);
});
ASPx.Evt.AttachEventToDocument("selectstart", function(evt) {
 if(ASPx.classesScriptParsed && ASPx.StateItemsExist)
  return aspxGetStateController().OnSelectStart(evt);
});
ASPx.GetStateController = aspxGetStateController;
})();
(function () {
 if (typeof ASPx == "undefined") {
  window.ASPx = {};
 }
 ASPx.ASPxImageLoad = {};
 ASPx.ASPxImageLoad.dxDefaultLoadingImageCssClass = "dxe-loadingImage";
 ASPx.ASPxImageLoad.OnLoad = function (image, customLoadingImage, isOldIE, customBackgroundImageUrl) {
  image.dxCustomBackgroundImageUrl = "";
  image.dxShowLoadingImage = true;
  image.dxCustomLoadingImage = customLoadingImage;
  if (customBackgroundImageUrl != "")
   image.dxCustomBackgroundImageUrl = "url('" + customBackgroundImageUrl + "')";
  ASPx.ASPxImageLoad.prepareImageBackground(image, isOldIE);
  ASPx.ASPxImageLoad.removeHandlers(image);
  image.className = image.className.replace(ASPx.ASPxImageLoad.dxDefaultLoadingImageCssClass, "");
 };
 ASPx.ASPxImageLoad.removeASPxImageBackground = function (image, isOldIE) {
  if (isOldIE) 
   image.style.removeAttribute("background-image");
  else 
   image.style.backgroundImage = "";
 };
 ASPx.ASPxImageLoad.prepareImageBackground = function (image, isOldIE) {
  ASPx.ASPxImageLoad.removeASPxImageBackground(image, isOldIE);
  if (image.dxCustomBackgroundImageUrl != "")
   image.style.backgroundImage = image.dxCustomBackgroundImageUrl;
 };
 ASPx.ASPxImageLoad.removeHandlers = function (image) {
  image.removeAttribute("onload");
  image.removeAttribute("onabort");
  image.removeAttribute("onerror");
 };
})();
(function () {
var ASPxClientBeginCallbackEventArgs = ASPx.CreateClass(ASPxClientEventArgs, {
 constructor: function(command){
  this.constructor.prototype.constructor.call(this);
  this.command = command;
 }
});
var ASPxClientGlobalBeginCallbackEventArgs = ASPx.CreateClass(ASPxClientBeginCallbackEventArgs, {
 constructor: function(control, command){
  this.constructor.prototype.constructor.call(this, command);
  this.control = control;
 }
});
var ASPxClientEndCallbackEventArgs = ASPx.CreateClass(ASPxClientEventArgs, {
 constructor: function(){
  this.constructor.prototype.constructor.call(this);
 }
});
var ASPxClientGlobalEndCallbackEventArgs = ASPx.CreateClass(ASPxClientEndCallbackEventArgs, {
 constructor: function(control){
  this.constructor.prototype.constructor.call(this);
  this.control = control;
 }
});
var ASPxClientCustomDataCallbackEventArgs = ASPx.CreateClass(ASPxClientEventArgs, {
 constructor: function(result) {
  this.constructor.prototype.constructor.call(this);
  this.result = result;
 }
});
var ASPxClientCallbackErrorEventArgs = ASPx.CreateClass(ASPxClientEventArgs, {
 constructor: function (message, callbackId) {
  this.constructor.prototype.constructor.call(this);
  this.message = message;
  this.handled = false;
  this.callbackId = callbackId;
 }
});
var ASPxClientGlobalCallbackErrorEventArgs = ASPx.CreateClass(ASPxClientCallbackErrorEventArgs, {
 constructor: function (control, message, callbackId) {
  this.constructor.prototype.constructor.call(this, message, callbackId);
  this.control = control;
 }
});
var ASPxClientValidationCompletedEventArgs = ASPx.CreateClass(ASPxClientEventArgs, {
 constructor: function (container, validationGroup, invisibleControlsValidated, isValid, firstInvalidControl, firstVisibleInvalidControl) {
  this.constructor.prototype.constructor.call(this);
  this.container = container;
  this.validationGroup = validationGroup;
  this.invisibleControlsValidated = invisibleControlsValidated;
  this.isValid = isValid;
  this.firstInvalidControl = firstInvalidControl;
  this.firstVisibleInvalidControl = firstVisibleInvalidControl;
 }
});
var ASPxClientControlsInitializedEventArgs = ASPx.CreateClass(ASPxClientEventArgs, {
 constructor: function(isCallback) {
  this.isCallback = isCallback;
 }
});
var BeforeInitCallbackEventArgs = ASPx.CreateClass(ASPxClientEventArgs, {
 constructor: function(callbackOwnerID){
  this.constructor.prototype.constructor.call(this);
  this.callbackOwnerID = callbackOwnerID;
 }
});
var ASPxClientControlBase = ASPx.CreateClass(null, {
 constructor: function(name){
  this.name = name;
  this.uniqueID = name;   
  this.globalName = name;
  this.stateObject = null;
  this.encodeHtml = true;
  this.enabled = true;
  this.clientEnabled = true;
  this.savedClientEnabled = true;
  this.clientVisible = true;
  this.accessibilityCompliant = false;
  this.autoPostBack = false;
  this.allowMultipleCallbacks = true;
  this.callBack = null;
  this.enableCallbackAnimation = false;
  this.enableSlideCallbackAnimation = false;
  this.slideAnimationDirection = null;
  this.beginCallbackAnimationProcessing = false;
  this.endCallbackAnimationProcessing = false;
  this.savedCallbackResult = null;
  this.savedCallbacks = null;
  this.isCallbackAnimationPrevented = false;
  this.lpDelay = 300;
  this.lpTimer = -1;
  this.requestCount = 0;
  this.enableSwipeGestures = false;
  this.supportGestures = false;
  this.repeatedGestureValue = 0;
  this.repeatedGestureCount = 0;
  this.isInitialized = false;
  this.initialFocused = false;
  this.leadingAfterInitCall = ASPxClientControl.LeadingAfterInitCallConsts.None; 
  this.serverEvents = [];
  this.loadingPanelElement = null;
  this.loadingDivElement = null;  
  this.hasPhantomLoadingElements = false;
  this.mainElement = null;
  this.touchUIMouseScroller = null;
  this.hiddenFields = { };
  this.callbackHandlersQueue = new ASPx.ControlCallbackHandlersQueue(this);
  this.Init = new ASPxClientEvent();
  this.BeginCallback = new ASPxClientEvent();
  this.EndCallback = new ASPxClientEvent();
  this.EndCallbackAnimationStart = new ASPxClientEvent();
  this.CallbackError = new ASPxClientEvent();
  this.CustomDataCallback = new ASPxClientEvent();
 },
 Initialize: function() {
  if(this.callBack != null)
   this.InitializeCallBackData();
  if (this.useCallbackQueue())
   this.callbackQueueHelper = new ASPx.ControlCallbackQueueHelper(this);
 },
 InlineInitialize: function() {
  this.savedClientEnabled = this.clientEnabled;
 },
 InitializeGestures: function() {
  if(this.enableSwipeGestures && this.supportGestures) {
   ASPx.GesturesHelper.AddSwipeGestureHandler(this.name, 
    function() { return this.GetCallbackAnimationElement(); }.aspxBind(this), 
    function(evt) { return this.CanHandleGestureCore(evt); }.aspxBind(this), 
    function(value) { return this.AllowStartGesture(); }.aspxBind(this),
    function(value) { return this.StartGesture(); }.aspxBind(this),
    function(value) { return this.AllowExecuteGesture(value); }.aspxBind(this),
    function(value) { this.ExecuteGesture(value); }.aspxBind(this),
    function(value) { this.CancelGesture(value); }.aspxBind(this),
    this.GetDefaultanimationEngineType()
   );
   if(ASPx.Browser.MSTouchUI)
    this.touchUIMouseScroller = ASPx.MouseScroller.Create(
     function() { return this.GetCallbackAnimationElement(); }.aspxBind(this),
     function() { return null; },
     function() { return this.GetCallbackAnimationElement(); }.aspxBind(this),
     function(element) { return this.NeedPreventTouchUIMouseScrolling(element); }.aspxBind(this),
     true
    );
  }
 },
 InitGlobalVariable: function(varName){
  if(!window) return;
  this.globalName = varName;
  window[varName] = this;
 },
 SetProperties: function(properties, obj){
  if(!obj) obj = this;
  for(var name in properties){
   if(properties.hasOwnProperty(name))
    obj[name] = properties[name];
  }
 },
 SetEvents: function(events, obj){
  if(!obj) obj = this;
  for(var name in events){
   if(events.hasOwnProperty(name) && obj[name] && obj[name].AddHandler)
    obj[name].AddHandler(events[name]);
  }
 },
 InitializeProperties: function(properties){
 },
 useCallbackQueue: function(){
  return false;
 },
 NeedPreventTouchUIMouseScrolling: function(element) {
  return false;
 },
 InitailizeFocus: function() {
  if(this.initialFocused && this.IsVisible())
   this.Focus();
 },
 AfterCreate: function() { 
  this.InlineInitialize();
  this.InitializeGestures();
 },
 AfterInitialize: function() {
  this.initializeAriaDescriptor();
  this.InitailizeFocus();
  this.isInitialized = true;
  this.RaiseInit();
  if(this.savedCallbacks) {
   for(var i = 0; i < this.savedCallbacks.length; i++) 
    this.CreateCallbackInternal(this.savedCallbacks[i].arg, this.savedCallbacks[i].command, 
     false, this.savedCallbacks[i].callbackInfo);
   this.savedCallbacks = null;
  }
 },
 InitializeCallBackData: function() {
 },
 IsDOMDisposed: function() { 
  return !ASPx.IsExistsElement(this.GetMainElement());
 },
 initializeAriaDescriptor: function() {
  if(this.ariaDescription) {
   var descriptionObject = ASPx.Json.Eval(this.ariaDescription)
   if(descriptionObject) {
    this.ariaDescriptor = new AriaDescriptor(this, descriptionObject);
    this.applyAccessibilityAttributes(this.ariaDescriptor); 
   }
  }
 },
 applyAccessibilityAttributes: function() { },
 setAriaDescription: function(selector, argsList) {
  if(this.ariaDescriptor)
   this.ariaDescriptor.setDescription(selector, argsList || [[]]);
 },
 HtmlEncode: function(text) {
  return this.encodeHtml ? ASPx.Str.EncodeHtml(text) : text;
 },
 IsServerEventAssigned: function(eventName){
  return ASPx.Data.ArrayIndexOf(this.serverEvents, eventName) >= 0;
 },
 OnPost: function(args){
  this.UpdateStateObject();
  if(this.stateObject != null) 
   this.UpdateStateHiddenField();
 },
 OnPostFinalization: function(args){
 },
 UpdateStateObject: function(){
 },
 UpdateStateObjectWithObject: function(obj){
  if(!obj) return;
  if(!this.stateObject)
   this.stateObject = { };
  for(var key in obj)
   this.stateObject[key] = obj[key];
 },
 UpdateStateHiddenField: function(){
  var stateHiddenField = this.GetStateHiddenField()
  if(stateHiddenField) {
   var stateObjectStr = ASPx.Json.ToJson(this.stateObject);
   stateHiddenField.value = ASPx.Str.EncodeHtml(stateObjectStr);
  }
 },
 GetStateHiddenField: function() {
  return this.GetHiddenField(this.GetStateHiddenFieldName(), this.GetStateHiddenFieldID(), 
   this.GetStateHiddenFieldParent(), this.GetStateHiddenFieldOrigin());
 },
 GetStateHiddenFieldName: function() {
  return this.uniqueID;
 },
 GetStateHiddenFieldID: function() {
  return this.name + "_State";
 },
 GetStateHiddenFieldOrigin: function() {
  return this.GetMainElement();
 },
 GetStateHiddenFieldParent: function() {
  var element = this.GetStateHiddenFieldOrigin();
  return element ? element.parentNode : null;
 },
 GetHiddenField: function(name, id, parent, beforeElement) {
  var hiddenField = this.hiddenFields[id];
  if(!hiddenField || !ASPx.IsValidElement(hiddenField)) {
   if(parent) {
    var existingHiddenField = ASPx.GetElementById(this.GetStateHiddenFieldID());
    this.hiddenFields[id] = hiddenField = existingHiddenField || ASPx.CreateHiddenField(name, id);
    if(existingHiddenField)
     return existingHiddenField;
    if(beforeElement)
     parent.insertBefore(hiddenField, beforeElement)
    else
     parent.appendChild(hiddenField);
   }
  }
  return hiddenField;
 },
 GetChildElement: function(idPostfix){
  var mainElement = this.GetMainElement();
  if(idPostfix.charAt && idPostfix.charAt(0) !== "_")
   idPostfix = "_" + idPostfix;
  return mainElement ? ASPx.CacheHelper.GetCachedChildById(this, mainElement, this.name + idPostfix) : null;
 },
 getChildControl: function(idPostfix) {
  var result = null;
  var childControlId = this.getChildControlUniqueID(idPostfix);
  ASPx.GetControlCollection().ProcessControlsInContainer(this.GetMainElement(), function(control) {
   if(control.uniqueID == childControlId)
    result = control;
  });
  return result;  
 },
 getChildControlUniqueID: function(idPostfix) {
  idPostfix = idPostfix.split("_").join("$");
  if(idPostfix.charAt && idPostfix.charAt(0) !== "$")
   idPostfix = "$" + idPostfix;
  return this.uniqueID + idPostfix;  
 },
 getInnerControl: function(idPostfix) {
  var name = this.name + idPostfix;
  var result = window[name];
  return result && Ident.IsASPxClientControl(result)
   ? result
   : null;
 },
 GetParentForm: function(){
  return ASPx.GetParentByTagName(this.GetMainElement(), "FORM");
 },
 GetMainElement: function(){
  if(!ASPx.IsExistsElement(this.mainElement))
   this.mainElement = ASPx.GetElementById(this.name);
  return this.mainElement;
 },
 IsLoadingContainerVisible: function(){
  return this.IsVisible();
 },
 GetLoadingPanelElement: function(){
  return ASPx.GetElementById(this.name + "_LP");
 },
 GetClonedLoadingPanel: function(){
  return document.getElementById(this.GetLoadingPanelElement().id + "V"); 
 },
 CloneLoadingPanel: function(element, parent) {
  var clone = element.cloneNode(true);
  clone.id = element.id + "V";
  parent.appendChild(clone);
  return clone;
 },
 CreateLoadingPanelWithoutBordersInsideContainer: function(container) {
  var loadingPanel = this.CreateLoadingPanelInsideContainer(container, false, true, true);
  var contentStyle = ASPx.GetCurrentStyle(container);
  if(!loadingPanel || !contentStyle)
   return;
  var elements = [ ];
  elements.push(loadingPanel.tagName == "TABLE" ? loadingPanel : ASPx.GetNodeByTagName(loadingPanel, "TABLE", 0));
  var cells = ASPx.GetNodesByTagName(loadingPanel, "TD");
  if(!cells) cells = [ ];
  for(var i = 0; i < cells.length; i++)
   elements.push(cells[i]);
  for(var i = 0; i < elements.length; i++) {
   var el = elements[i];
   el.style.backgroundColor = contentStyle.backgroundColor;
   ASPx.RemoveBordersAndShadows(el);
  }
 },
 CreateLoadingPanelInsideContainer: function(parentElement, hideContent, collapseHeight, collapseWidth) {
  if(this.ShouldHideExistingLoadingElements())
   this.HideLoadingPanel();
  if(parentElement == null)
   return null;
  if(!this.IsLoadingContainerVisible()) {
   this.hasPhantomLoadingElements = true;
   return null;
  }
  var element = this.GetLoadingPanelElement();
  if(element != null){
   var width = collapseWidth ? 0 : ASPx.GetClearClientWidth(parentElement);
   var height = collapseHeight ? 0 : ASPx.GetClearClientHeight(parentElement);
   if(hideContent){
    for(var i = parentElement.childNodes.length - 1; i > -1; i--){
     if(parentElement.childNodes[i].style)
      parentElement.childNodes[i].style.display = "none";
     else if(parentElement.childNodes[i].nodeType == 3) 
      parentElement.removeChild(parentElement.childNodes[i]);
    }
   }
   else
    parentElement.innerHTML = "";
   var table = document.createElement("TABLE");
   parentElement.appendChild(table);
   table.border = 0;
   table.cellPadding = 0;
   table.cellSpacing = 0;
   ASPx.SetStyles(table, {
    width: (width > 0) ? width : "100%",
    height: (height > 0) ? height : "100%"
   });
   var tbody = document.createElement("TBODY");
   table.appendChild(tbody);
   var tr = document.createElement("TR");
   tbody.appendChild(tr);
   var td = document.createElement("TD");
   tr.appendChild(td);
   td.align = "center";
   td.vAlign = "middle";
   element = this.CloneLoadingPanel(element, td);
   ASPx.SetElementDisplay(element, true);
   this.loadingPanelElement = element;
   return element;
  } else
   parentElement.innerHTML = "&nbsp;";
  return null;
 },
 CreateLoadingPanelWithAbsolutePosition: function(parentElement, offsetElement) {
  if(this.ShouldHideExistingLoadingElements())
   this.HideLoadingPanel();
  if(parentElement == null)
   return null;
  if(!this.IsLoadingContainerVisible()) {
   this.hasPhantomLoadingElements = true;
   return null;
  }
  if(!offsetElement)
   offsetElement = parentElement;
  var element = this.GetLoadingPanelElement();
  if(element != null) {
   element = this.CloneLoadingPanel(element, parentElement);
   ASPx.SetStyles(element, {
    position: "absolute",
    display: ""
   });
   this.SetLoadingPanelLocation(offsetElement, element);
   this.loadingPanelElement = element;
   return element;
  }
  return null;
 },
 CreateLoadingPanelInline: function(parentElement){
  if(this.ShouldHideExistingLoadingElements())
   this.HideLoadingPanel();
  if(parentElement == null)
   return null;
  if(!this.IsLoadingContainerVisible()) {
   this.hasPhantomLoadingElements = true;
   return null;
  }
  var element = this.GetLoadingPanelElement();
  if(element != null) {
   element = this.CloneLoadingPanel(element, parentElement);
   ASPx.SetElementDisplay(element, true);
   this.loadingPanelElement = element;
   return element;
  }
  return null;
 },
 ShowLoadingPanel: function() {
 },
 ShowLoadingElements: function() {
  if(this.InCallback() || this.lpTimer > -1) return;
  this.ShowLoadingDiv();
  if(this.IsCallbackAnimationEnabled())
   this.StartBeginCallbackAnimation();
  else
   this.ShowLoadingElementsInternal();
 },
 ShowLoadingElementsInternal: function() {
  if(this.lpDelay > 0 && !this.IsCallbackAnimationEnabled()) 
   this.lpTimer = window.setTimeout(function() { 
    this.ShowLoadingPanelOnTimer(); 
   }.aspxBind(this), this.lpDelay);
  else {
   this.RestoreLoadingDivOpacity();
   this.ShowLoadingPanel();
  }
 },
 GetLoadingPanelOffsetElement: function (baseElement) {
  if(this.IsCallbackAnimationEnabled()) {
   var element = this.GetLoadingPanelCallbackAnimationOffsetElement();
   if(element) {
    var container = typeof(ASPx.AnimationHelper) != "undefined" ? ASPx.AnimationHelper.findSlideAnimationContainer(element) : null;
    if(container)
     return container.parentNode.parentNode;
    else
     return element;
   }
  }
  return baseElement;
 },
 GetLoadingPanelCallbackAnimationOffsetElement: function () {
  return this.GetCallbackAnimationElement();
 },
 IsCallbackAnimationEnabled: function () {
  return (this.enableCallbackAnimation || this.enableSlideCallbackAnimation) && !this.isCallbackAnimationPrevented;
 },
 GetDefaultanimationEngineType: function() {
  return ASPx.AnimationEngineType.DEFAULT;
 },
 StartBeginCallbackAnimation: function () {
  this.beginCallbackAnimationProcessing = true;
  this.isCallbackFinished = false;
  var element = this.GetCallbackAnimationElement();
  if(element && this.enableSlideCallbackAnimation && this.slideAnimationDirection) 
   ASPx.AnimationHelper.slideOut(element, this.slideAnimationDirection, this.FinishBeginCallbackAnimation.aspxBind(this), this.GetDefaultanimationEngineType());
  else if(element && this.enableCallbackAnimation) 
   ASPx.AnimationHelper.fadeOut(element, this.FinishBeginCallbackAnimation.aspxBind(this));
  else
   this.FinishBeginCallbackAnimation();
 },
 CancelBeginCallbackAnimation: function() {
  if(this.beginCallbackAnimationProcessing) {
   this.beginCallbackAnimationProcessing = false;
   var element = this.GetCallbackAnimationElement();
   ASPx.AnimationHelper.cancelAnimation(element);
  }
 },
 FinishBeginCallbackAnimation: function () {
  this.beginCallbackAnimationProcessing = false;
  if(!this.isCallbackFinished)
   this.ShowLoadingElementsInternal();
  else {
   this.DoCallback(this.savedCallbackResult);
   this.savedCallbackResult = null;
  }
 },
 CheckBeginCallbackAnimationInProgress: function(callbackResult) {
  if(this.beginCallbackAnimationProcessing) {
   this.savedCallbackResult = callbackResult;
   this.isCallbackFinished = true;
   return true;
  }
  return false;
 },
 StartEndCallbackAnimation: function () {
  this.HideLoadingPanel();
  this.SetInitialLoadingDivOpacity();
  this.RaiseEndCallbackAnimationStart();
  this.endCallbackAnimationProcessing = true;
  var element = this.GetCallbackAnimationElement();
  if(element && this.enableSlideCallbackAnimation && this.slideAnimationDirection) 
   ASPx.AnimationHelper.slideIn(element, this.slideAnimationDirection, this.FinishEndCallbackAnimation.aspxBind(this), this.GetDefaultanimationEngineType());
  else if(element && this.enableCallbackAnimation) 
   ASPx.AnimationHelper.fadeIn(element, this.FinishEndCallbackAnimation.aspxBind(this));
  else
   this.FinishEndCallbackAnimation();
  this.slideAnimationDirection = null;
 },
 FinishEndCallbackAnimation: function () {
  this.DoEndCallback();
  this.endCallbackAnimationProcessing = false;
  this.CheckRepeatGesture();
 },
 CheckEndCallbackAnimationNeeded: function() {
  if(!this.endCallbackAnimationProcessing && this.requestCount == 1) {
   this.StartEndCallbackAnimation();
   return true;
  }
  return false;
 },
 PreventCallbackAnimation: function() {
  this.isCallbackAnimationPrevented = true;
 },
 GetCallbackAnimationElement: function() {
  return null;
 },
 AssignSlideAnimationDirectionByPagerArgument: function(arg, currentPageIndex) {
  this.slideAnimationDirection = null;
  if(this.enableSlideCallbackAnimation && typeof(ASPx.AnimationHelper) != "undefined") {
   if(arg == PagerCommands.Next || arg == PagerCommands.Last)
    this.slideAnimationDirection = ASPx.AnimationHelper.SLIDE_LEFT_DIRECTION;
   else if(arg == PagerCommands.First || arg == PagerCommands.Prev)
    this.slideAnimationDirection = ASPx.AnimationHelper.SLIDE_RIGHT_DIRECTION;
   else if(!isNaN(currentPageIndex) && arg.indexOf(PagerCommands.PageNumber) == 0) {
    var newPageIndex = parseInt(arg.substring(2));
    if(!isNaN(newPageIndex))
     this.slideAnimationDirection = newPageIndex < currentPageIndex ? ASPx.AnimationHelper.SLIDE_RIGHT_DIRECTION : ASPx.AnimationHelper.SLIDE_LEFT_DIRECTION;
   }
  }
 },
 TryShowPhantomLoadingElements: function () {
  if(this.hasPhantomLoadingElements && this.InCallback()) {
   this.hasPhantomLoadingElements = false;
   this.ShowLoadingDivAndPanel();
  }
 },
 ShowLoadingDivAndPanel: function () {
  this.ShowLoadingDiv();
  this.RestoreLoadingDivOpacity();
  this.ShowLoadingPanel();
 },
 HideLoadingElements: function() {
  this.CancelBeginCallbackAnimation();
  this.HideLoadingPanel();
  this.HideLoadingDiv();
 },
 ShowLoadingPanelOnTimer: function() {
  this.ClearLoadingPanelTimer();
  if(!this.IsDOMDisposed()) {
   this.RestoreLoadingDivOpacity();
   this.ShowLoadingPanel();
  }
 },
 ClearLoadingPanelTimer: function() {
  this.lpTimer = ASPx.Timer.ClearTimer(this.lpTimer);  
 },
 HideLoadingPanel: function() {
  this.ClearLoadingPanelTimer();
  this.hasPhantomLoadingElements = false;
  if(ASPx.IsExistsElement(this.loadingPanelElement)) {
   ASPx.RemoveElement(this.loadingPanelElement);
   this.loadingPanelElement = null;
  }
 },
 SetLoadingPanelLocation: function(offsetElement, loadingPanel, x, y, offsetX, offsetY) {
  if(!ASPx.IsExists(x) || !ASPx.IsExists(y)){
   var x1 = ASPx.GetAbsoluteX(offsetElement);
   var y1 = ASPx.GetAbsoluteY(offsetElement);
   var x2 = x1;
   var y2 = y1;
   if(offsetElement == document.body){
    x2 += ASPx.GetDocumentMaxClientWidth();
    y2 += ASPx.GetDocumentMaxClientHeight();
   }
   else{
    x2 += offsetElement.offsetWidth;
    y2 += offsetElement.offsetHeight;
   }
   if(x1 < ASPx.GetDocumentScrollLeft())
    x1 = ASPx.GetDocumentScrollLeft();
   if(y1 < ASPx.GetDocumentScrollTop())
    y1 = ASPx.GetDocumentScrollTop();
   if(x2 > ASPx.GetDocumentScrollLeft() + ASPx.GetDocumentClientWidth())
    x2 = ASPx.GetDocumentScrollLeft() + ASPx.GetDocumentClientWidth();
   if(y2 > ASPx.GetDocumentScrollTop() + ASPx.GetDocumentClientHeight())
    y2 = ASPx.GetDocumentScrollTop() + ASPx.GetDocumentClientHeight();
   x = x1 + ((x2 - x1 - loadingPanel.offsetWidth) / 2);
   y = y1 + ((y2 - y1 - loadingPanel.offsetHeight) / 2);
  }
  if(ASPx.IsExists(offsetX) && ASPx.IsExists(offsetY)){
   x += offsetX;
   y += offsetY;
  }
  x = ASPx.PrepareClientPosForElement(x, loadingPanel, true);
  y = ASPx.PrepareClientPosForElement(y, loadingPanel, false);
  if(ASPx.Browser.IE && ASPx.Browser.Version > 8 && (y - Math.floor(y) === 0.5))
   y = Math.ceil(y);
  ASPx.SetStyles(loadingPanel, { left: x, top: y });
 },
 GetLoadingDiv: function(){
  return ASPx.GetElementById(this.name + "_LD");
 },
 CreateLoadingDiv: function(parentElement, offsetElement){
  if(this.ShouldHideExistingLoadingElements())
   this.HideLoadingDiv();
  if(parentElement == null) 
   return null;
  if(!this.IsLoadingContainerVisible()) {
   this.hasPhantomLoadingElements = true;
   return null;
  }
  if(!offsetElement)
   offsetElement = parentElement;
  var div = this.GetLoadingDiv();
  if(div != null){
   div = div.cloneNode(true);
   parentElement.appendChild(div);
   ASPx.SetElementDisplay(div, true);
   ASPx.Evt.AttachEventToElement(div, ASPx.TouchUIHelper.touchMouseDownEventName, ASPx.Evt.PreventEvent);
   ASPx.Evt.AttachEventToElement(div, ASPx.TouchUIHelper.touchMouseMoveEventName, ASPx.Evt.PreventEvent);
   ASPx.Evt.AttachEventToElement(div, ASPx.TouchUIHelper.touchMouseUpEventName, ASPx.Evt.PreventEvent);
   this.SetLoadingDivBounds(offsetElement, div);
   this.loadingDivElement = div;
   this.SetInitialLoadingDivOpacity();
   return div;
  }
  return null;
 },
 SetInitialLoadingDivOpacity: function() {
  if(!this.loadingDivElement) return;
  ASPx.Attr.SaveStyleAttribute(this.loadingDivElement, "opacity");
  ASPx.Attr.SaveStyleAttribute(this.loadingDivElement, "filter");
  ASPx.SetElementOpacity(this.loadingDivElement, 0.01);
 },
 RestoreLoadingDivOpacity: function() {
  if(!this.loadingDivElement) return;
  ASPx.Attr.RestoreStyleAttribute(this.loadingDivElement, "opacity");
  ASPx.Attr.RestoreStyleAttribute(this.loadingDivElement, "filter");
 },
 SetLoadingDivBounds: function(offsetElement, loadingDiv) {
  var absX = (offsetElement == document.body) ? 0 : ASPx.GetAbsoluteX(offsetElement);
  var absY = (offsetElement == document.body) ? 0 : ASPx.GetAbsoluteY(offsetElement);
  ASPx.SetStyles(loadingDiv, {
   left: ASPx.PrepareClientPosForElement(absX, loadingDiv, true),
   top: ASPx.PrepareClientPosForElement(absY, loadingDiv, false)
  });
  var width = (offsetElement == document.body) ? ASPx.GetDocumentWidth() : offsetElement.offsetWidth;
  var height = (offsetElement == document.body) ? ASPx.GetDocumentHeight() : offsetElement.offsetHeight;
  if(height < 0) 
   height = 0;
  ASPx.SetStyles(loadingDiv, { width: width, height: height });
  var correctedWidth = 2 * width - loadingDiv.offsetWidth;
  if(correctedWidth <= 0) correctedWidth = width;
  var correctedHeight = 2 * height - loadingDiv.offsetHeight;
  if(correctedHeight <= 0) correctedHeight = height;
  ASPx.SetStyles(loadingDiv, { width: correctedWidth, height: correctedHeight });
 },
 ShowLoadingDiv: function() {
 },
 HideLoadingDiv: function() {
  this.hasPhantomLoadingElements = false;
  if(ASPx.IsExistsElement(this.loadingDivElement)){
   ASPx.RemoveElement(this.loadingDivElement);
   this.loadingDivElement = null;
  }
 },
 CanHandleGesture: function(evt) {
  return false;
 },
 CanHandleGestureCore: function(evt) {
  var source = ASPx.Evt.GetEventSource(evt);
  if(ASPx.GetIsParent(this.loadingPanelElement, source) || ASPx.GetIsParent(this.loadingDivElement, source))
   return true; 
  var callbackAnimationElement = this.GetCallbackAnimationElement();
  if(!callbackAnimationElement)
   return false;
  var animationContainer = ASPx.AnimationHelper.getSlideAnimationContainer(callbackAnimationElement, false, false);
  if(animationContainer && ASPx.GetIsParent(animationContainer, source) && !ASPx.GetIsParent(animationContainer.childNodes[0], source))
   return true; 
  return this.CanHandleGesture(evt); 
 },
 AllowStartGesture: function() {
  return !this.beginCallbackAnimationProcessing && !this.endCallbackAnimationProcessing;
 },
 StartGesture: function() {
 },
 AllowExecuteGesture: function(value) {
  return false;
 },
 ExecuteGesture: function(value) {
 },
 CancelGesture: function(value) {
  if(this.repeatedGestureCount === 0) {
   this.repeatedGestureValue = value;
   this.repeatedGestureCount = 1;
  }
  else {
   if(this.repeatedGestureValue * value > 0)
    this.repeatedGestureCount++;
   else
    this.repeatedGestureCount--;
   if(this.repeatedGestureCount === 0)
    this.repeatedGestureCount = 0;
  }
 },
 CheckRepeatGesture: function() {
  if(this.repeatedGestureCount !== 0) {
   if(this.AllowExecuteGesture(this.repeatedGestureValue))
    this.ExecuteGesture(this.repeatedGestureValue, this.repeatedGestureCount);
   this.repeatedGestureValue = 0;
   this.repeatedGestureCount = 0;
  }
 },
 AllowExecutePagerGesture: function (pageIndex, pageCount, value) {
  if(pageIndex < 0) return false;
  if(pageCount <= 1) return false;
  if(value > 0 && pageIndex === 0) return false;
  if(value < 0 && pageIndex === pageCount - 1) return false;
  return true;
 },
 ExecutePagerGesture: function(pageIndex, pageCount, value, count, method) {
  if(!count) count = 1;
  var pageIndex = pageIndex + (value < 0 ? count : -count);
  if(pageIndex < 0) pageIndex = 0;
  if(pageIndex > pageCount - 1) pageIndex = pageCount - 1;
  method(PagerCommands.PageNumber + pageIndex);
 },
 RaiseInit: function(){
  if(!this.Init.IsEmpty()){
   var args = new ASPxClientEventArgs();
   this.Init.FireEvent(this, args);
  }
 },
 RaiseBeginCallbackInternal: function(command){
  if(!this.BeginCallback.IsEmpty()){
   var args = new ASPxClientBeginCallbackEventArgs(command);
   this.BeginCallback.FireEvent(this, args);
  }
 },
 RaiseEndCallbackInternal: function() {
  if(!this.EndCallback.IsEmpty()){
   var args = new ASPxClientEndCallbackEventArgs();
   this.EndCallback.FireEvent(this, args);
  }
 },
 RaiseCallbackErrorInternal: function(message, callbackId) {
  if(!this.CallbackError.IsEmpty()) {
   var args = new ASPxClientCallbackErrorEventArgs(message, callbackId);
   this.CallbackError.FireEvent(this, args);
   if(args.handled)
    return { isHandled: true, errorMessage: args.message };
  }
 },
 RaiseBeginCallback: function(command){
  this.RaiseBeginCallbackInternal(command);    
  aspxGetControlCollection().RaiseBeginCallback(this, command);
 },
 RaiseEndCallback: function(){
  this.RaiseEndCallbackInternal();
  aspxGetControlCollection().RaiseEndCallback(this);
 },
 RaiseCallbackError: function (message, callbackId) {
  var result = this.RaiseCallbackErrorInternal(message, callbackId);
  if(!result) 
   result = aspxGetControlCollection().RaiseCallbackError(this, message, callbackId);
  return result;
 },
 RaiseEndCallbackAnimationStart: function(){
  if(!this.EndCallbackAnimationStart.IsEmpty()){
   var args = new ASPxClientEventArgs();
   this.EndCallbackAnimationStart.FireEvent(this, args);
  }
 },
 IsVisible: function() {
  var element = this.GetMainElement();
  return ASPx.IsElementVisible(element);
 },
 IsDisplayedElement: function(element) {
  while(element && element.tagName != "BODY") {
   if(!ASPx.GetElementDisplay(element)) 
    return false;
   element = element.parentNode;
  }
  return true;
 },
 IsDisplayed: function() {
  return this.IsDisplayedElement(this.GetMainElement());
 },
 IsHiddenElement: function(element) {
  return element && element.offsetWidth == 0 && element.offsetHeight == 0;
 },
 IsHidden: function() {
  return this.IsHiddenElement(this.GetMainElement());
 },
 Focus: function() {
 },
 GetClientVisible: function(){
  return this.GetVisible();
 },
 SetClientVisible: function(visible){
  this.SetVisible(visible);
 },
 GetVisible: function(){
  return this.clientVisible;
 },
 SetVisible: function(visible){
  if(this.clientVisible != visible){
   this.clientVisible = visible;
   ASPx.SetElementDisplay(this.GetMainElement(), visible);
   if(visible) {
    this.AdjustControl();
    var mainElement = this.GetMainElement();
    if(mainElement)
     aspxGetControlCollection().AdjustControls(mainElement);
   }
  }
 },
 GetEnabled: function() {
  return this.clientEnabled;
 },
 SetEnabled: function(enabled) {
  this.clientEnabled = enabled;
  if(ASPxClientControl.setEnabledLocked)
   return;
  else
   ASPxClientControl.setEnabledLocked = true;
  this.savedClientEnabled = enabled;
  aspxGetControlCollection().ProcessControlsInContainer(this.GetMainElement(), function(control) {
   if(ASPx.IsFunction(control.SetEnabled))
    control.SetEnabled(enabled && control.savedClientEnabled);
  });
  delete ASPxClientControl.setEnabledLocked;
 },
 InCallback: function() {
  return this.requestCount > 0;
 },
 DoBeginCallback: function(command) {
  this.RaiseBeginCallback(command || "");
  aspxGetControlCollection().Before_WebForm_InitCallback(this.name);
  if(typeof(WebForm_InitCallback) != "undefined" && WebForm_InitCallback) {
   __theFormPostData = "";
   __theFormPostCollection = [ ];
   this.ClearPostBackEventInput("__EVENTTARGET");
   this.ClearPostBackEventInput("__EVENTARGUMENT");
   WebForm_InitCallback();
   this.savedFormPostData = __theFormPostData;   
   this.savedFormPostCollection = __theFormPostCollection;
  }
 },
 ClearPostBackEventInput: function(id){
  var element = ASPx.GetElementById(id);
  if(element != null) element.value = "";
 },
 PerformDataCallback: function(arg, handler) {
  this.CreateCustomDataCallback(arg, "", handler);
 },
 sendCallbackViaQueue: function (prefix, arg, showLoadingPanel, context, handler) {
  if (!this.useCallbackQueue())
   return false;
  var context = context || this;
  var token = this.callbackQueueHelper.sendCallback(ASPx.FormatCallbackArg(prefix, arg), context, handler || context.OnCallback);
  if (showLoadingPanel)
   this.callbackQueueHelper.showLoadingElements();
  return token;
 },
 CreateCallback: function (arg, command, handler) {
  var callbackInfo = this.CreateCallbackInfo(ASPx.CallbackType.Common, handler || null);
  var callbackID = this.CreateCallbackByInfo(arg, command, callbackInfo);
  return callbackID;
 },
 CreateCustomDataCallback: function(arg, command, handler) {
  var callbackInfo = this.CreateCallbackInfo(ASPx.CallbackType.Data, handler);
  this.CreateCallbackByInfo(arg, command, callbackInfo);
 },
 CreateCallbackByInfo: function(arg, command, callbackInfo) {
  if(!this.CanCreateCallback()) return;
  var callbackID;
  if(typeof(WebForm_DoCallback) != "undefined" && WebForm_DoCallback && ASPx.documentLoaded)
   callbackID = this.CreateCallbackInternal(arg, command, true, callbackInfo);
  else {
   if(!this.savedCallbacks)
    this.savedCallbacks = [];
   var callbackInfo = { arg: arg, command: command, callbackInfo: callbackInfo };
   if(this.allowMultipleCallbacks)
    this.savedCallbacks.push(callbackInfo);
   else
    this.savedCallbacks[0] = callbackInfo;
  }
  return callbackID;
 },
 CreateCallbackInternal: function(arg, command, viaTimer, callbackInfo) {
  var watcher = ASPx.ControlUpdateWatcher.getInstance();
  if(watcher && !watcher.CanSendCallback(this, arg)) {
   this.CancelCallbackInternal();
   return;
  }
  this.requestCount++;
  this.DoBeginCallback(command);
  if(typeof(arg) == "undefined")
   arg = "";
  if(typeof(command) == "undefined")
   command = "";
  var callbackID = this.SaveCallbackInfo(callbackInfo);
  if(viaTimer)
   window.setTimeout(function() { this.CreateCallbackCore(arg, command, callbackID); }.aspxBind(this), 0);
  else
   this.CreateCallbackCore(arg, command, callbackID);
  return callbackID;
 },
 CancelCallbackInternal: function() {
  this.CancelCallbackCore();
  this.HideLoadingElements();
 },
 CancelCallbackCore: function() {
 },
 CreateCallbackCore: function(arg, command, callbackID) {
  var callBackMethod = this.GetCallbackMethod(command);
  __theFormPostData = this.savedFormPostData;
  __theFormPostCollection = this.savedFormPostCollection;
  callBackMethod.call(this, this.GetSerializedCallbackInfoByID(callbackID) + arg);
 },
 GetCallbackMethod: function(command){
  return this.callBack;
 },
 CanCreateCallback: function() {
  return !this.InCallback() || (this.allowMultipleCallbacks && !this.beginCallbackAnimationProcessing && !this.endCallbackAnimationProcessing);
 },
 DoLoadCallbackScripts: function() {
  ASPx.ProcessScriptsAndLinks(this.name, true);
 },
 DoEndCallback: function() {
  if(this.IsCallbackAnimationEnabled() && this.CheckEndCallbackAnimationNeeded()) 
   return;
  this.requestCount--;
  if (this.requestCount < 1) 
   this.callbackHandlersQueue.executeCallbacksHandlers();
  if(this.HideLoadingPanelOnCallback() && this.requestCount < 1) 
   this.HideLoadingElements();
  if(this.enableSwipeGestures && this.supportGestures) {
   ASPx.GesturesHelper.UpdateSwipeAnimationContainer(this.name);
   if(this.touchUIMouseScroller)
    this.touchUIMouseScroller.update();
  }
  this.isCallbackAnimationPrevented = false;
  this.OnCallbackFinalized();
  this.RaiseEndCallback();
 },
 DoFinalizeCallback: function() {
 },
 OnCallbackFinalized: function() {
 },
 HideLoadingPanelOnCallback: function() {
  return true;
 },
 ShouldHideExistingLoadingElements: function() {
  return true;
 },
 EvalCallbackResult: function(resultString){
  return eval(resultString)
 },
 DoCallback: function(result) {
  if(this.IsCallbackAnimationEnabled() && this.CheckBeginCallbackAnimationInProgress(result))
   return;
  result = ASPx.Str.Trim(result);
  if(result.indexOf(ASPx.CallbackResultPrefix) != 0) 
   this.ProcessCallbackGeneralError(result);
  else {
   var resultObj = null;
   try {
    resultObj = this.EvalCallbackResult(result);
   } 
   catch(e) {
   }
   if(resultObj) {
    ASPx.CacheHelper.DropCache(this);
    if(resultObj.redirect){
     if(!ASPx.Browser.IE)
      window.location.href = resultObj.redirect;
     else { 
      var fakeLink = document.createElement("a");
      fakeLink.href = resultObj.redirect;
      document.body.appendChild(fakeLink); 
      try { fakeLink.click(); } catch(e){ } 
     }
    }
    else if(ASPx.IsExists(resultObj.generalError)){
     this.ProcessCallbackGeneralError(resultObj.generalError);
    }
    else {
     var errorObj = resultObj.error;
     if(errorObj)
      this.ProcessCallbackError(errorObj,resultObj.id);
     else {
      if(resultObj.cp) {
       for(var name in resultObj.cp)
        this[name] = resultObj.cp[name];
      }
      var callbackInfo = this.DequeueCallbackInfo(resultObj.id);
      if(callbackInfo && callbackInfo.type == ASPx.CallbackType.Data)
       this.ProcessCustomDataCallback(resultObj.result, callbackInfo);
      else {
       if (this.useCallbackQueue() && this.callbackQueueHelper.getCallbackInfoById(resultObj.id))
        this.callbackQueueHelper.processCallback(resultObj.result, resultObj.id);
       else {
        this.ProcessCallback(resultObj.result, resultObj.id);
        if (callbackInfo && callbackInfo.handler)
         this.callbackHandlersQueue.addCallbackHandler(callbackInfo.handler);
       }
      }
     }
    }
   } 
  }
  this.DoLoadCallbackScripts();
 },
 DoCallbackError: function(result) {
  this.HideLoadingElements();
  this.ProcessCallbackGeneralError(result); 
 },
 DoControlClick: function(evt) {
  this.OnControlClick(ASPx.Evt.GetEventSource(evt), evt);
 },
 ProcessCallback: function (result, callbackId) {
  this.OnCallback(result, callbackId);
 },
 ProcessCustomDataCallback: function(result, callbackInfo) {
  if(callbackInfo.handler != null)
   callbackInfo.handler(this, result);
  this.RaiseCustomDataCallback(result);
 },
 RaiseCustomDataCallback: function(result) {
  if(!this.CustomDataCallback.IsEmpty()) {
   var arg = new ASPxClientCustomDataCallbackEventArgs(result);
   this.CustomDataCallback.FireEvent(this, arg);
  }
 },
 OnCallback: function(result) {
 },
 CreateCallbackInfo: function(type, handler) {
  return { type: type, handler: handler };
 },
 GetSerializedCallbackInfoByID: function(callbackID) {
  return this.GetCallbackInfoByID(callbackID).type + callbackID + ASPx.CallbackSeparator;
 },
 SaveCallbackInfo: function(callbackInfo) {
  var activeCallbacksInfo = this.GetActiveCallbacksInfo();
  for(var i = 0; i < activeCallbacksInfo.length; i++) {
   if(activeCallbacksInfo[i] == null) {
    activeCallbacksInfo[i] = callbackInfo;
    return i;
   }
  }
  activeCallbacksInfo.push(callbackInfo);
  return activeCallbacksInfo.length - 1;
 },
 GetActiveCallbacksInfo: function() {
  var persistentProperties = this.GetPersistentProperties();
  if(!persistentProperties.activeCallbacks)
   persistentProperties.activeCallbacks = [ ];
  return persistentProperties.activeCallbacks;
 },
 GetPersistentProperties: function() {
  var storage = _aspxGetPersistentControlPropertiesStorage();
  var persistentProperties = storage[this.name];
  if(!persistentProperties) {
   persistentProperties = { };
   storage[this.name] = persistentProperties;
  }
  return persistentProperties;
 },
 GetCallbackInfoByID: function(callbackID) {
  return this.GetActiveCallbacksInfo()[callbackID];
 },
 DequeueCallbackInfo: function(index) {
  var activeCallbacksInfo = this.GetActiveCallbacksInfo();
  if(index < 0 || index >= activeCallbacksInfo.length)
   return null;
  var result = activeCallbacksInfo[index];
  activeCallbacksInfo[index] = null;
  return result;
 },
 ProcessCallbackError: function (errorObj, callbackId) {
  var data = ASPx.IsExists(errorObj.data) ? errorObj.data : null;
  var result = this.RaiseCallbackError(errorObj.message, callbackId);
  if(result.isHandled)
   this.OnCallbackErrorAfterUserHandle(result.errorMessage, data); 
  else
   this.OnCallbackError(result.errorMessage, data); 
 },
 OnCallbackError: function(errorMessage, data) {
  if(errorMessage)
   alert(errorMessage);
 },
 OnCallbackErrorAfterUserHandle: function(errorMessage, data) {
 },
 ProcessCallbackGeneralError: function(errorMessage) {
  var result = this.RaiseCallbackError(errorMessage);
  if(!result.isHandled)
   this.OnCallbackGeneralError(result.errorMessage);
 },
 OnCallbackGeneralError: function(errorMessage) {
  this.OnCallbackError(errorMessage, null);
 },
 SendPostBack: function(params) {
  if(typeof(__doPostBack) != "undefined")
   __doPostBack(this.uniqueID, params);
  else{
   var form = this.GetParentForm();
   if(form) form.submit();
  }
 },
 IsValidInstance: function () {
  return aspxGetControlCollection().GetByName(this.name) === this;
 },
 OnDispose: function() { 
  var varName = this.globalName;
  if(varName && varName !== "" && window && window[varName] && window[varName] == this){
   try{
    delete window[varName];
   }
   catch(e){  }
  }
  if(this.callbackQueueHelper)
   this.callbackQueueHelper.detachEvents();
 },
 OnGlobalControlsInitialized: function(args) { 
 },
 OnGlobalBrowserWindowResized: function(args) { 
 },
 OnGlobalBeginCallback: function(args) { 
 },
 OnGlobalEndCallback: function(args) { 
 },
 OnGlobalCallbackError: function(args) { 
 },
 OnGlobalValidationCompleted: function(args) { 
 }
});
ASPxClientControlBase.Cast = function(obj) {
 if(typeof obj == "string")
  return window[obj];
 return obj;
};
var persistentControlPropertiesStorage = null;
function _aspxGetPersistentControlPropertiesStorage() {
 if(persistentControlPropertiesStorage == null)
  persistentControlPropertiesStorage = { };
 return persistentControlPropertiesStorage;
}
var ASPxClientControl = ASPx.CreateClass(ASPxClientControlBase, {
 constructor: function(name){
  this.constructor.prototype.constructor.call(this, name);
  this.isASPxClientControl = true;
  this.rtl = false;
  this.enableEllipsis = false;
  this.isNative = false;
  this.isControlCollapsed = false;
  this.isInsideHierarchyAdjustment = false;
  this.controlOwner = null;
  this.adjustedSizes = { };
  this.dialogContentHashTable = { };
  this.renderIFrameForPopupElements = false;
  this.widthValueSetInPercentage = false;
  this.heightValueSetInPercentage = false;
  this.verticalAlignedElements = { };
  this.wrappedTextContainers = { };
  this.scrollPositionState = { };
  this.sizingConfig = {
   allowSetWidth: true,
   allowSetHeight: true,
   correction : false,
   adjustControl : false,
   supportPercentHeight: false,
   supportAutoHeight: false
  };
  this.percentSizeConfig = {
   width: -1,
   height: -1,
   markerWidth: -1,
   markerHeight: -1
  };
  aspxGetControlCollection().Add(this);  
 },
 InlineInitialize: function() {
  this.InitializeDOM();
  ASPxClientControlBase.prototype.InlineInitialize.call(this);
 },
 AfterCreate: function() { 
  ASPxClientControlBase.prototype.AfterCreate.call(this);
  if(!this.CanInitializeAdjustmentOnDOMContentLoaded() || ASPx.IsStartupScriptsRunning())
   this.InitializeAdjustment();
 },
 DOMContentLoaded: function() {
  if(this.CanInitializeAdjustmentOnDOMContentLoaded()) 
   this.InitializeAdjustment();
 },
 CanInitializeAdjustmentOnDOMContentLoaded: function() {
  return !ASPx.Browser.IE || ASPx.Browser.Version >= 10; 
 },
 InitializeAdjustment: function() {
  this.UpdateAdjustmentFlags();
  this.AdjustControl();
 },
 AfterInitialize: function() {
  this.AdjustControl();
  ASPxClientControlBase.prototype.AfterInitialize.call(this);
 },
 IsStateControllerEnabled: function(){
  return typeof(ASPx.GetStateController) != "undefined" && ASPx.GetStateController();
 },
 InitializeDOM: function() {
  var mainElement = this.GetMainElement();
  if(mainElement)
   mainElement["dxinit"] = true;
 },
 IsDOMInitialized: function() {
  var mainElement = this.GetMainElement();
  return mainElement && mainElement["dxinit"];
 },
 GetWidth: function() {
  return this.GetMainElement().offsetWidth;
 },
 GetHeight: function() {
  return this.GetMainElement().offsetHeight;
 },
 SetWidth: function(width) {
  if(this.sizingConfig.allowSetWidth)
   this.SetSizeCore("width", width, "GetWidth", false);
 },
 SetHeight: function(height) {
  if(this.sizingConfig.allowSetHeight)
   this.SetSizeCore("height", height, "GetHeight", false);
 },
 SetSizeCore: function(sizePropertyName, size, getFunctionName, corrected) {
  if(size < 0)
   return;
  this.GetMainElement().style[sizePropertyName] = size + "px";
  this.UpdateAdjustmentFlags(sizePropertyName);
  if(this.sizingConfig.adjustControl)
   this.AdjustControl(true);
  if(this.sizingConfig.correction && !corrected) {
   var realSize = this[getFunctionName]();
   if(realSize != size) {
    var correctedSize = size - (realSize - size);
    this.SetSizeCore(sizePropertyName, correctedSize, getFunctionName, true);
   }
  }
 },
 AdjustControl: function(nestedCall) {
  if(this.IsAdjustmentRequired() && (!ASPxClientControl.adjustControlLocked || nestedCall)) {
   ASPxClientControl.adjustControlLocked = true;
   try {
    if(!this.IsAdjustmentAllowed())
     return;
    this.AdjustControlCore();
    this.UpdateAdjustedSizes();
   } 
   finally {
    delete ASPxClientControl.adjustControlLocked;
   }
  }
  this.TryShowPhantomLoadingElements();
 },
 ResetControlAdjustment: function () {
  this.adjustedSizes = { };
 },
 UpdateAdjustmentFlags: function(sizeProperty) {
  var mainElement = this.GetMainElement();
  if(mainElement) {
   var mainElementStyle = ASPx.GetCurrentStyle(mainElement);
   this.UpdatePercentSizeConfig([mainElementStyle.width, mainElement.style.width], [mainElementStyle.height, mainElement.style.height], sizeProperty);
  }
 },
 UpdatePercentSizeConfig: function(widths, heights, modifyStyleProperty) {
  switch(modifyStyleProperty) {
   case "width":
    this.UpdatePercentWidthConfig(widths);
    break;
   case "height":
    this.UpdatePercentHeightConfig(heights);
    break;
   default:
    this.UpdatePercentWidthConfig(widths);
    this.UpdatePercentHeightConfig(heights);
    break;
  }
  this.ResetControlPercentMarkerSize();
 },
 UpdatePercentWidthConfig: function(widths) {
  this.widthValueSetInPercentage = false;
  for(var i = 0; i < widths.length; i++) {
   if(ASPx.IsPercentageSize(widths[i])) {
    this.percentSizeConfig.width = widths[i];
    this.widthValueSetInPercentage = true;
    break;
   }
  }
 },
 UpdatePercentHeightConfig: function(heights) {
  this.heightValueSetInPercentage = false;
    for(var i = 0; i < heights.length; i++) {
   if(ASPx.IsPercentageSize(heights[i])) {
    this.percentSizeConfig.height = heights[i];
    this.heightValueSetInPercentage = true;
    break;
   }
  }
 },
 GetAdjustedSizes: function() {
  var mainElement = this.GetMainElement();
  if(mainElement) 
   return { width: mainElement.offsetWidth, height: mainElement.offsetHeight };
  return { width: 0, height: 0 };
 },
 IsAdjusted: function() {
  return (this.adjustedSizes.width && this.adjustedSizes.width > 0) && (this.adjustedSizes.height && this.adjustedSizes.height > 0);
 },
 IsAdjustmentRequired: function() {
  if(!this.IsAdjusted())
   return true;
  if(this.widthValueSetInPercentage)
   return true;
  if(this.heightValueSetInPercentage)
   return true;
  var sizes = this.GetAdjustedSizes();
  for(var name in sizes){
   if(this.adjustedSizes[name] !== sizes[name])
    return true;
  }
  return false;
 },
 IsAdjustmentAllowed: function() {
  var mainElement = this.GetMainElement();
  return mainElement && this.IsDisplayed() && !this.IsHidden() && this.IsDOMInitialized();
 },
 UpdateAdjustedSizes: function() {
  var sizes = this.GetAdjustedSizes();
  for(var name in sizes)
   this.adjustedSizes[name] = sizes[name];
 },
 AdjustControlCore: function() {
 },
 AdjustAutoHeight: function() {
 },
 IsControlCollapsed: function() {
  return this.isControlCollapsed;
 },
 NeedCollapseControl: function() {
  return this.NeedCollapseControlCore() && this.IsAdjustmentRequired() && this.IsAdjustmentAllowed();
 },
 NeedCollapseControlCore: function() {
  return false;
 },
 CollapseEditor: function() {
 },
 CollapseControl: function() {
  this.SaveScrollPositions();
  var mainElement = this.GetMainElement(),
   marker = this.GetControlPercentSizeMarker();
  marker.style.height = this.heightValueSetInPercentage && this.sizingConfig.supportPercentHeight
   ? this.percentSizeConfig.height 
   : (mainElement.offsetHeight + "px");
  mainElement.style.display = "none";
  this.isControlCollapsed = true;
 },
 ExpandControl: function() {
  var mainElement = this.GetMainElement();
  mainElement.style.display = "";
  this.GetControlPercentSizeMarker().style.height = "0px";
  this.isControlCollapsed = false;
  this.RestoreScrollPositions();
 },
 CanCauseReadjustment: function() {
  return this.NeedCollapseControlCore();
 },
 IsExpandableByAdjustment: function() {
  return false;
 },
 HasFixedPosition: function() {
  return false;
 },
 SaveScrollPositions: function() {
  var mainElement = this.GetMainElement();
  this.scrollPositionState.outer = ASPx.GetOuterScrollPosition(mainElement.parentNode);
  this.scrollPositionState.inner = ASPx.GetInnerScrollPositions(mainElement);
 },
 RestoreScrollPositions: function() {
  ASPx.RestoreOuterScrollPosition(this.scrollPositionState.outer);
  ASPx.RestoreInnerScrollPositions(this.scrollPositionState.inner);
 },
 GetControlPercentSizeMarker: function() {
  if(this.percentSizeMarker === undefined) {
   this.percentSizeMarker = ASPx.CreateHtmlElementFromString("<div style='height:0px;font-size:0px;line-height:0;width:100%;'></div>");
   ASPx.InsertElementAfter(this.percentSizeMarker, this.GetMainElement());
  }
  return this.percentSizeMarker;
 },
 KeepControlPercentSizeMarker: function(needCollapse, needCalculateHeight) {
  var mainElement = this.GetMainElement(),
   marker = this.GetControlPercentSizeMarker(),
   markerHeight;
  if(needCollapse)
   this.CollapseControl();
  if(this.widthValueSetInPercentage && marker.style.width !== this.percentSizeConfig.width)
   marker.style.width = this.percentSizeConfig.width;
  if(needCalculateHeight) {
   if(this.IsControlCollapsed())
    markerHeight = marker.style.height;
   marker.style.height = this.percentSizeConfig.height;
  }
  this.percentSizeConfig.markerWidth = marker.offsetWidth;
  if(needCalculateHeight) {
   this.percentSizeConfig.markerHeight = marker.offsetHeight;
   if(this.IsControlCollapsed())
    marker.style.height = markerHeight;
   else
    marker.style.height = "0px";
  }
  if(needCollapse)
   this.ExpandControl();
 },
 ResetControlPercentMarkerSize: function() {
  this.percentSizeConfig.markerWidth = -1;
  this.percentSizeConfig.markerHeight = -1;
 },
 GetControlPercentMarkerSize: function(hideControl, force) {
  var needCalculateHeight = this.heightValueSetInPercentage && this.sizingConfig.supportPercentHeight;
  if(force || this.percentSizeConfig.markerWidth < 1 || (needCalculateHeight && this.percentSizeConfig.markerHeight < 1))
   this.KeepControlPercentSizeMarker(hideControl && !this.IsControlCollapsed(), needCalculateHeight);
  return {
   width: this.percentSizeConfig.markerWidth,
   height: this.percentSizeConfig.markerHeight
  };
 },
 AssignEllipsisToolTips: function() {
  if(this.RequireAssignToolTips())
   this.AssignEllipsisToolTipsCore();
 },
 AssignEllipsisToolTipsCore: function() {
  var requirePaddingManipulation = ASPx.Browser.IE || ASPx.Browser.Edge || ASPx.Browser.Firefox;
  var ellipsisNodes = ASPx.GetNodesByClassName(this.GetMainElement(), "dx-ellipsis");
  var nodeInfos = [];
  var nodesCount = ellipsisNodes.length;
  for(var i = 0; i < nodesCount; i++) {
   var node = ellipsisNodes[i];
   var info = { node: node };
   if(requirePaddingManipulation) {
    var style = ASPx.GetCurrentStyle(node);
    info.paddingLeft = node.style.paddingLeft;
    info.totalPadding = ASPx.GetLeftRightPaddings(node, style);
   }
   nodeInfos.push(info);
  }
  if(requirePaddingManipulation) {
   for(var i = 0; i < nodesCount; i++) {
    var info = nodeInfos[i];
    ASPx.SetStyles(info.node, { paddingLeft: info.totalPadding }, true);
   }
  }
  for(var i = 0; i < nodesCount; i++) {
   var info = nodeInfos[i];
   var node = info.node;
   info.isTextShortened = node.scrollWidth > node.clientWidth;
   info.hasTitle = !!node.title;
   info.title = !info.hasTitle && this.GetTooltipText(node);
  }
  for(var i = 0; i < nodesCount; i++) {
   var info = nodeInfos[i];
   var node = info.node;
   if(info.isTextShortened && !info.hasTitle)
    node.title = info.title;
   if(!info.isTextShortened && info.hasTitle)
    node.removeAttribute("title");
  }
  if(requirePaddingManipulation) {
   for(var i = 0; i < nodesCount; i++) {
    var info = nodeInfos[i];
    var node = info.node;
    node.style.paddingLeft = info.paddingLeft;
   }
  }
 },
 GetTooltipText: function(elem) {
  return elem.innerText || ASPx.GetInnerText(elem);
 },
 AssignEllipsisToolTip: function(elem) {
  var isTextShortened = elem.scrollWidth > elem.clientWidth;
  if(isTextShortened && !elem.title)
   elem.title = ASPx.GetInnerText(elem);
  if(!isTextShortened && elem.title)
   elem.removeAttribute("title");
 },
 RequireAssignToolTips: function() {
  return this.enableEllipsis && !ASPx.Browser.TouchUI;
 },
 OnBrowserWindowResize: function(e) {
 },
 OnBrowserWindowResizeInternal: function(e){
  if(this.BrowserWindowResizeSubscriber()) 
   this.OnBrowserWindowResize(e);
 },
 BrowserWindowResizeSubscriber: function() {
  return this.widthValueSetInPercentage || !this.IsAdjusted();
 },
 ShrinkWrappedText: function(getElements, key, reCorrect) {
  if(!ASPx.Browser.Safari) return;
  var elements = ASPx.CacheHelper.GetCachedElements(this, key, getElements, this.wrappedTextContainers);
  for(var i = 0; i < elements.length; i++)
   this.ShrinkWrappedTextInContainer(elements[i], reCorrect);
 },
 ShrinkWrappedTextInContainer: function(container, reCorrect) {
  if(!ASPx.Browser.Safari || !container || (container.dxWrappedTextShrinked && !reCorrect) || container.offsetWidth === 0) return;
  ASPx.ShrinkWrappedTextInContainer(container);
  container.dxWrappedTextShrinked = true;
 },
 CorrectWrappedText: function(getElements, key, reCorrect) {
  var elements = ASPx.CacheHelper.GetCachedElements(this, key, getElements, this.wrappedTextContainers);
  for(var i = 0; i < elements.length; i++)
   this.CorrectWrappedTextInContainer(elements[i], reCorrect);
 },
 CorrectWrappedTextInContainer: function(container, reCorrect) {
  if(!container || (container.dxWrappedTextCorrected && !reCorrect) || container.offsetWidth === 0) return;
  ASPx.AdjustWrappedTextInContainer(container);
  container.dxWrappedTextCorrected = true;
 },
 CorrectVerticalAlignment: function(alignMethod, getElements, key, reAlign) {
  var elements = ASPx.CacheHelper.GetCachedElements(this, key, getElements, this.verticalAlignedElements);
  for(var i = 0; i < elements.length; i++)
   this.CorrectElementVerticalAlignment(alignMethod, elements[i], reAlign);
 },
 CorrectElementVerticalAlignment: function(alignMethod, element, reAlign) {
  if(!element || (element.dxVerticalAligned && !reAlign) || element.offsetHeight === 0) return;
  alignMethod(element);
  element.dxVerticalAligned = true;
 },
 ClearVerticalAlignedElementsCache: function() {
  ASPx.CacheHelper.DropCache(this.verticalAlignedElements);
 },
 ClearWrappedTextContainersCache: function() {
  ASPx.CacheHelper.DropCache(this.wrappedTextContainers);
 },
 AdjustPagerControls: function() {
  if(typeof(ASPx.GetPagersCollection) != "undefined")
   ASPx.GetPagersCollection().AdjustControls(this.GetMainElement());
 },
 RegisterInControlTree: function(tree) {
  var mainElement = this.GetMainElement();
  if(mainElement && mainElement.id)
   tree.createNode(mainElement.id, this);
 },
 GetItemElementName: function(element) {
  var name = "";
  if(element.id)
   name = element.id.substring(this.name.length + 1);
  return name;
 },
 GetLinkElement: function(element) {
  if(element == null) return null;
  return (element.tagName == "A") ? element : ASPx.GetNodeByTagName(element, "A", 0);
 },
 GetInternalHyperlinkElement: function(parentElement, index) {
  var element = ASPx.GetNodeByTagName(parentElement, "A", index);
  if(element == null) 
   element = ASPx.GetNodeByTagName(parentElement, "SPAN", index);
  return element;
 },
 OnControlClick: function(clickedElement, htmlEvent) {
 }
});
ASPxClientControl.Cast = function(obj) {
 if(typeof obj == "string")
  return window[obj];
 return obj;
};
ASPxClientControl.AdjustControls = function(container, collapseControls){
 aspxGetControlCollection().AdjustControls(container, collapseControls);
};
ASPxClientControl.GetControlCollection = function(){
 return aspxGetControlCollection();
}
ASPxClientControl.LeadingAfterInitCallConsts = {
 None: 0,
 Direct: 1,
 Reverse: 2
};
var ASPxClientComponent = ASPx.CreateClass(ASPxClientControl, {
 constructor: function (name) {
  this.constructor.prototype.constructor.call(this, name);
 },
 IsDOMDisposed: function() { 
  return false;
 }
});
var ASPxClientControlCollection = ASPx.CreateClass(ASPx.CollectionBase, {
 constructor: function(){
  this.constructor.prototype.constructor.call(this);
  this.prevWndWidth = "";
  this.prevWndHeight = "";
  this.requestCountInternal = 0; 
  this.BeforeInitCallback = new ASPxClientEvent();
  this.ControlsInitialized = new ASPxClientEvent();
  this.BrowserWindowResized = new ASPxClientEvent();
  this.BeginCallback = new ASPxClientEvent();
  this.EndCallback = new ASPxClientEvent();
  this.CallbackError = new ASPxClientEvent();
  this.ValidationCompleted = new ASPxClientEvent();
  aspxGetControlCollectionCollection().Add(this);
 },
 Add: function(element) {
  var existsElement = this.Get(element.name);
  if(existsElement && existsElement !== element) 
   this.Remove(existsElement);
  ASPx.CollectionBase.prototype.Add.call(this, element.name, element);
 },
 Remove: function(element) {
  if(element && element instanceof ASPxClientControl)
   element.OnDispose();
  ASPx.CollectionBase.prototype.Remove.call(this, element.name);
 },
 GetGlobal: function(name) {
  var result = window[name];
  return result && Ident.IsASPxClientControl(result)
   ? result
   : null;
 },
 GetByName: function(name){
  return this.Get(name) || this.GetGlobal(name);
 },
 GetCollectionType: function(){
  return ASPxClientControlCollection.BaseCollectionType;
 },
 ForEachControl: function(processFunc, context) {
  context = context || this;
  this.elementsMap.forEachEntry(function(name, control) {
   if(Ident.IsASPxClientControl(control))
    return processFunc.call(context, control);
  }, context);
 },
 forEachControlHierarchy: function(container, context, collapseControls, processFunc) {
  context = context || this;
  var controlTree = new ASPx.ControlTree(this, container);
  controlTree.forEachControl(collapseControls, function(control) {
   processFunc.call(context, control);
  });
 },
 AdjustControls: function(container, collapseControls) {
  container = container || null;
  window.setTimeout(function() {
   this.AdjustControlsCore(container, collapseControls);
  }.aspxBind(this), 0);
 },
 AdjustControlsCore: function(container, collapseControls) {
  this.forEachControlHierarchy(container, this, collapseControls, function(control) {
   control.AdjustControl();
  });
 },
 CollapseControls: function(container) {
  this.ProcessControlsInContainer(container, function(control) {
   if(control.isASPxClientEdit)
    control.CollapseEditor();
   else if(!!window.ASPxClientRibbon && control instanceof ASPxClientRibbon)
    control.CollapseControl();
  });
 },
 AtlasInitialize: function(isCallback) {
  if(ASPx.Browser.IE && ASPx.Browser.MajorVersion < 9) {
   var func = function() {
    if(_aspxIsLinksLoaded())
     ASPx.ProcessScriptsAndLinks("", isCallback); 
    else
     setTimeout(func, 100);
   }   
   func();
  }
  else
   ASPx.ProcessScriptsAndLinks("", isCallback);
 },
 DOMContentLoaded: function() {
  this.ForEachControl(function(control){
    control.DOMContentLoaded();
  });
 },
 Initialize: function() {
  ASPx.GetPostHandler().Post.AddHandler(
   function(s, e) { this.OnPost(e); }.aspxBind(this)
  );
  ASPx.GetPostHandler().PostFinalization.AddHandler(
   function(s, e) { this.OnPostFinalization(e); }.aspxBind(this)
  );
  this.InitializeElements(false );
  if(typeof(Sys) != "undefined" && typeof(Sys.Application) != "undefined") {
   var checkIsInitialized = function() {
    if(Sys.Application.get_isInitialized())
     Sys.Application.add_load(aspxCAInit);
    else
     setTimeout(checkIsInitialized, 0);
   }
   checkIsInitialized();
  }
  this.InitWindowSizeCache();
 },
 InitializeElements: function(isCallback) {
  this.ForEachControl(function(control){
   if(!control.isInitialized)
    control.Initialize();
  });
  this.AfterInitializeElementsLeadingCall();
  this.AfterInitializeElements();
  this.RaiseControlsInitialized(isCallback);
 },
 AfterInitializeElementsLeadingCall: function() {
  var controls = {};
  controls[ASPxClientControl.LeadingAfterInitCallConsts.Direct] = [];
  controls[ASPxClientControl.LeadingAfterInitCallConsts.Reverse] = [];
  this.ForEachControl(function(control) {
   if(control.leadingAfterInitCall != ASPxClientControl.LeadingAfterInitCallConsts.None && !control.isInitialized)
    controls[control.leadingAfterInitCall].push(control);
  });
  var directInitControls = controls[ASPxClientControl.LeadingAfterInitCallConsts.Direct],
   reverseInitControls = controls[ASPxClientControl.LeadingAfterInitCallConsts.Reverse];
  for(var i = 0, control; control = directInitControls[i]; i++)
   control.AfterInitialize();
  for(var i = reverseInitControls.length - 1, control; control = reverseInitControls[i]; i--)
   control.AfterInitialize();
 },
 AfterInitializeElements: function() {
  this.ForEachControl(function(control) {
   if(control.leadingAfterInitCall == ASPxClientControl.LeadingAfterInitCallConsts.None && !control.isInitialized)
    control.AfterInitialize();
  });
  ASPx.RippleHelper.attachRippleTargetClassNames();
 },
 DoFinalizeCallback: function() {
  this.ForEachControl(function(control){
   control.DoFinalizeCallback();
  });
 },
 ProcessControlsInContainer: function(container, processFunc) {
  this.ForEachControl(function(control){
   if(!container || this.IsControlInContainer(container, control))
    processFunc(control);
  });
 },
 IsControlInContainer: function(container, control) {
  if(control.GetMainElement) {
   var mainElement = control.GetMainElement();
   if(mainElement && (mainElement != container)) {
    if(ASPx.GetIsParent(container, mainElement))
     return true;
   }
  }
  return false;
 },
 RaiseControlsInitialized: function(isCallback) {
  if(typeof(isCallback) == "undefined")
   isCallback = true;
  var args = new ASPxClientControlsInitializedEventArgs(isCallback);
  if(!this.ControlsInitialized.IsEmpty())  
   this.ControlsInitialized.FireEvent(this, args);
  this.ForEachControl(function(control){
   control.OnGlobalControlsInitialized(args);
  });
 },
 RaiseBrowserWindowResized: function() {
  var args = new ASPxClientEventArgs();
  if(!this.BrowserWindowResized.IsEmpty())
   this.BrowserWindowResized.FireEvent(this, args);
  this.ForEachControl(function(control){
   control.OnGlobalBrowserWindowResized(args);
  });
 },
 RaiseBeginCallback: function (control, command) {
  var args = new ASPxClientGlobalBeginCallbackEventArgs(control, command);
  if(!this.BeginCallback.IsEmpty())
   this.BeginCallback.FireEvent(this, args);
  this.ForEachControl(function(control){
   control.OnGlobalBeginCallback(args);
  });
  this.IncrementRequestCount();
 },
 RaiseEndCallback: function (control) {
  var args = new ASPxClientGlobalEndCallbackEventArgs(control);
  if (!this.EndCallback.IsEmpty()) 
   this.EndCallback.FireEvent(this, args);
  this.ForEachControl(function(control){
   control.OnGlobalEndCallback(args);
  });
  this.DecrementRequestCount();
 },
 InCallback: function() {
  return this.requestCountInternal > 0;
 },
 RaiseCallbackError: function (control, message, callbackId) {
  var args = new ASPxClientGlobalCallbackErrorEventArgs(control, message, callbackId);
  if (!this.CallbackError.IsEmpty()) 
   this.CallbackError.FireEvent(this, args);
  this.ForEachControl(function(control){
   control.OnGlobalCallbackError(args);
  });
  if(args.handled)
   return { isHandled: true, errorMessage: args.message };  
  return { isHandled: false, errorMessage: message };
 },
 RaiseValidationCompleted: function (container, validationGroup, invisibleControlsValidated, isValid, firstInvalidControl, firstVisibleInvalidControl) {
  var args = new ASPxClientValidationCompletedEventArgs(container, validationGroup, invisibleControlsValidated, isValid, firstInvalidControl, firstVisibleInvalidControl);
  if (!this.ValidationCompleted.IsEmpty()) 
   this.ValidationCompleted.FireEvent(this, args);
  this.ForEachControl(function(control){
   control.OnGlobalValidationCompleted(args);
  });
 },
 Before_WebForm_InitCallback: function(callbackOwnerID){
  var args = new BeforeInitCallbackEventArgs(callbackOwnerID);
  this.BeforeInitCallback.FireEvent(this, args);
 },
 InitWindowSizeCache: function(){
  this.prevWndWidth = ASPx.GetDocumentClientWidth();
  this.prevWndHeight = ASPx.GetDocumentClientHeight();
 },
 OnBrowserWindowResize: function(evt){
  var shouldIgnoreNestedEvents = ASPx.Browser.IE && ASPx.Browser.MajorVersion == 8;
  if(shouldIgnoreNestedEvents) {
   if(this.prevWndWidth === "" || this.prevWndHeight === "" || this.browserWindowResizeLocked)
    return;
   this.browserWindowResizeLocked = true;
  }
  this.OnBrowserWindowResizeCore(evt);
  if(shouldIgnoreNestedEvents)
   this.browserWindowResizeLocked = false;
 },
 OnBrowserWindowResizeCore: function(htmlEvent){
  var args = this.CreateOnBrowserWindowResizeEventArgs(htmlEvent);
  if(this.CalculateIsBrowserWindowSizeChanged()) {
   this.forEachControlHierarchy(null, this, true, function(control) {
    if(control.IsDOMInitialized())
     control.OnBrowserWindowResizeInternal(args);
   });
   this.RaiseBrowserWindowResized();
  }
 },
 CreateOnBrowserWindowResizeEventArgs: function(htmlEvent){
  return {
   htmlEvent: htmlEvent,
   wndWidth: ASPx.GetDocumentClientWidth(),
   wndHeight: ASPx.GetDocumentClientHeight(),
   prevWndWidth: this.prevWndWidth,
   prevWndHeight: this.prevWndHeight
  }
 },
 CalculateIsBrowserWindowSizeChanged: function(){
  var wndWidth = ASPx.GetDocumentClientWidth();
  var wndHeight = ASPx.GetDocumentClientHeight();
  var isBrowserWindowSizeChanged = (this.prevWndWidth != wndWidth) || (this.prevWndHeight != wndHeight);
  if(isBrowserWindowSizeChanged){
   this.prevWndWidth = wndWidth;
   this.prevWndHeight = wndHeight;
   return true;
  }
  return false;
 },
 OnPost: function(args){
  this.ForEachControl(function(control) {
   control.OnPost(args);
  }, null);
 },
 OnPostFinalization: function(args){
  this.ForEachControl(function(control) {
   control.OnPostFinalization(args);
  }, null);
 },
 IncrementRequestCount: function() {
  this.requestCountInternal++;
 },
 DecrementRequestCount: function() {
  this.requestCountInternal--;
 }
});
ASPxClientControlCollection.BaseCollectionType = "Control";
var controlCollection = null;
function aspxGetControlCollection(){
 if(controlCollection == null) 
  controlCollection = new ASPxClientControlCollection();
 return controlCollection;
}
var ControlCollectionCollection = ASPx.CreateClass(ASPx.CollectionBase, {
 constructor: function(){
  this.constructor.prototype.constructor.call(this);
 },
 Add: function(element) {
  var key = element.GetCollectionType();
  if(!key) throw "The collection type isn't specified.";
  if(this.Get(key)) throw "The collection with type='" + key + "' already exists.";
  ASPx.CollectionBase.prototype.Add.call(this, key, element);
 },
 RemoveDisposedControls: function(){
  var baseCollection = this.Get(ASPxClientControlCollection.BaseCollectionType);
  var disposedControls = [];
  baseCollection.elementsMap.forEachEntry(function(name, control) {
   if(!ASPx.Ident.IsASPxClientControl(control)) return;
   if(control.IsDOMDisposed())
    disposedControls.push(control);
  });
  for(var i = 0; i < disposedControls.length; i++) {
   this.elementsMap.forEachEntry(function(key, collection) {
    if(ASPx.Ident.IsASPxClientCollection(collection))
     collection.Remove(disposedControls[i]);
   });
  }
 }
});
var controlCollectionCollection = null;
function aspxGetControlCollectionCollection(){
 if(controlCollectionCollection == null)
  controlCollectionCollection = new ControlCollectionCollection();
 return controlCollectionCollection;
}
var AriaDescriptionAttributes = {
 Role: "0",
 AriaLabel: "1",
 TabIndex: "2",
 AriaOwns: "3",
 AriaDescribedBy: "4",
 AriaDisabled: "5",
 AriaHasPopup: "6",
 AriaLevel: "7"
};
var AriaDescriptor = ASPx.CreateClass(null, {
 constructor: function(ownerControl, description) {
  this.ownerControl = ownerControl;
  this.rootElement = ownerControl.GetMainElement();
  this.description = description;
 },
 setDescription: function(name, argList) {
  var description = this.findChildDescription(name);
  if(description) {
   var elements = name ? this.rootElement.querySelectorAll(this.getDescriptionSelector(description)) : [this.rootElement];
   for(var i = 0; i < elements.length; i++)
    this.applyDescriptionToElement(elements[i], description, argList[i] || argList[0]);
  }
 },
 getDescriptionName: function(description) {
  return description.n;
 },
 getDescriptionSelector: function(description) {
  return description.s;
 },
 findChildDescription: function(name) {
  if(name === this.getDescriptionName(this.description))
   return this.description;
  var childCollection = this.description.c || [];
  for(var i = 0; i < childCollection.length; i++) {
   var childDescription = childCollection[i];
   if(this.getDescriptionName(childDescription) === name)
    return childDescription;
  }
  return null;
 },
 applyDescriptionToElement: function(element, description, args) {
  if(!description || !element)
   return;
  this.trySetAriaOwnsAttribute(element, description);
  this.trySetAriaDescribedByAttribute(element, description);
  this.trySetAttribute(element, description, AriaDescriptionAttributes.Role, "role");
  this.trySetAttribute(element, description, AriaDescriptionAttributes.TabIndex, "tabindex");
  this.trySetAttribute(element, description, AriaDescriptionAttributes.AriaLevel, "aria-level");
  this.executeOnDescription(description, AriaDescriptionAttributes.AriaLabel, function(value) {
   ASPx.Attr.SetAttribute(element, "aria-label", ASPx.Str.ApplyReplacement(value, args));
  });
  this.executeOnDescription(description, AriaDescriptionAttributes.AriaDisabled, function(value) {
   ASPx.Attr.SetAttribute(element, "aria-disabled", !!value); 
  });
  this.executeOnDescription(description, AriaDescriptionAttributes.AriaHasPopup, function(value) {
   ASPx.Attr.SetAttribute(element, "aria-haspopup", !!value);
  });
 },
 trySetAriaDescribedByAttribute: function(element, description) {
  this.executeOnDescription(description, AriaDescriptionAttributes.AriaDescribedBy, function(selectorInfo) {
   var descriptor = this.getNodesBySelector(element, selectorInfo.descriptorSelector)[0];
   var target = this.getNodesBySelector(element, selectorInfo.targetSelector)[0];
   if(!target || !descriptor)
    return;
   ASPx.Attr.SetAttribute(target, "aria-describedby", this.getNodeId(descriptor));
  });
 },
 trySetAriaOwnsAttribute: function(element, description) {
  this.executeOnDescription(description, AriaDescriptionAttributes.AriaOwns, function(selector) {
   var ownedNodes = this.getNodesBySelector(element, selector);
   var ariaOwnsAttributeValue = "";
   for(var i = 0; i < ownedNodes.length; i++)
    ariaOwnsAttributeValue += (this.getNodeId(ownedNodes[i]) + (i != ownedNodes.length - 1 ? " " : ""));
   ASPx.Attr.SetAttribute(element, "aria-owns", ariaOwnsAttributeValue);
  });
 },
 trySetAttribute: function(element, description, ariaAttribute, attributeName) {
  this.executeOnDescription(description, ariaAttribute, function(value) { 
   ASPx.Attr.SetAttribute(element, attributeName, description[ariaAttribute]); 
  });
 },
 executeOnDescription: function(description, ariaDescAttr, callback) {
  var descInfo = description[ariaDescAttr];
  if(ASPx.IsExists(descInfo))
   callback.aspxBind(this)(descInfo);
 },
 getNodesBySelector: function(element, selector) {
  var id = element.id || "";
  var childNodes = element.querySelectorAll("#" + this.getNodeId(element) + " > " + selector);
  ASPx.Attr.SetOrRemoveAttribute(element, "id", id);
  return childNodes;
 },
 getNodeId: function(node) {
  if(!node.id)
   node.id = this.createRandomId();
  return node.id; 
 },
 createRandomId: function() {
  return "r" + ASPx.CreateGuid();
 }
});
PagerCommands = {
 Next : "PBN",
 Prev : "PBP",
 Last : "PBL",
 First : "PBF",
 PageNumber : "PN",
 PageSize : "PSP"
};
ASPx.Callback = function(result, context){
 var collection = aspxGetControlCollection();
 collection.DoFinalizeCallback();
 var control = collection.Get(context);
 if(control != null)
  control.DoCallback(result);
 ASPx.RippleHelper.reset();
}
ASPx.CallbackError = function(result, context){
 var control = aspxGetControlCollection().Get(context);
 if(control != null)
  control.DoCallbackError(result, false);
}
ASPx.CClick = function(name, evt) {
 var control = aspxGetControlCollection().Get(name);
 if(control != null) control.DoControlClick(evt);
}
function aspxCAInit() {
 var isAppInit = typeof(Sys$_Application$initialize) != "undefined" &&
  ASPx.FunctionIsInCallstack(arguments.callee, Sys$_Application$initialize, 10 );
 aspxGetControlCollection().AtlasInitialize(!isAppInit);
}
ASPx.Evt.AttachEventToElement(window, "resize", aspxGlobalWindowResize);
function aspxGlobalWindowResize(evt){
 aspxGetControlCollection().OnBrowserWindowResize(evt); 
}
ASPx.Evt.AttachEventToElement(window.document, "DOMContentLoaded", aspxClassesDOMContentLoaded);
function aspxClassesDOMContentLoaded(evt){
 aspxGetControlCollection().DOMContentLoaded();
}
ASPx.GetControlCollection = aspxGetControlCollection;
ASPx.GetControlCollectionCollection = aspxGetControlCollectionCollection;
ASPx.GetPersistentControlPropertiesStorage = _aspxGetPersistentControlPropertiesStorage;
ASPx.PagerCommands = PagerCommands;
window.ASPxClientBeginCallbackEventArgs = ASPxClientBeginCallbackEventArgs;
window.ASPxClientGlobalBeginCallbackEventArgs = ASPxClientGlobalBeginCallbackEventArgs;
window.ASPxClientEndCallbackEventArgs = ASPxClientEndCallbackEventArgs;
window.ASPxClientGlobalEndCallbackEventArgs = ASPxClientGlobalEndCallbackEventArgs;
window.ASPxClientCallbackErrorEventArgs = ASPxClientCallbackErrorEventArgs;
window.ASPxClientGlobalCallbackErrorEventArgs = ASPxClientGlobalCallbackErrorEventArgs;
window.ASPxClientCustomDataCallbackEventArgs = ASPxClientCustomDataCallbackEventArgs;
window.ASPxClientValidationCompletedEventArgs = ASPxClientValidationCompletedEventArgs;
window.ASPxClientControlsInitializedEventArgs = ASPxClientControlsInitializedEventArgs;
window.ASPxClientControlCollection = ASPxClientControlCollection;
window.ASPxClientControlBase = ASPxClientControlBase;
window.ASPxClientControl = ASPxClientControl;
window.ASPxClientComponent = ASPxClientComponent;
})();
(function () {
 ASPx.EnableCssAnimation = true;
 var PositionAnimationTransition = ASPx.CreateClass(ASPx.AnimationTransitionBase, {
  constructor: function (element, options) {
   this.constructor.prototype.constructor.call(this, element, options);
   this.direction = options.direction;
   this.animationTransition = this.createAnimationTransition();
   AnimationHelper.appendWKAnimationClassNameIfRequired(this.element);
  },
  Start: function (to) {
   var from = this.GetValue();
   if(ASPx.AnimationUtils.CanUseCssTransform()) {
    from = this.convertPosToCssTransformPos(from);
    to = this.convertPosToCssTransformPos(to);
   }
   this.animationTransition.Start(from, to);
  },
  SetValue: function (value) {
   ASPx.AnimationUtils.SetTransformValue(this.element, value, this.direction == AnimationHelper.SLIDE_VERTICAL_DIRECTION);
  },
  GetValue: function () {
   return ASPx.AnimationUtils.GetTransformValue(this.element, this.direction == AnimationHelper.SLIDE_VERTICAL_DIRECTION);
  },
  createAnimationTransition: function () {
   var transition = ASPx.AnimationUtils.CanUseCssTransform() ? this.createTransformAnimationTransition() : this.createPositionAnimationTransition();
   transition.transition = ASPx.AnimationConstants.Transitions.POW_EASE_OUT;
   return transition;
  },
  createTransformAnimationTransition: function () {
   return ASPx.AnimationUtils.createCssAnimationTransition(this.element, {
    property: ASPx.AnimationUtils.CanUseCssTransform(),
    duration: this.duration,
    onComplete: this.onComplete
   });
  },
  createPositionAnimationTransition: function () {
   return AnimationHelper.createAnimationTransition(this.element, {
    property: this.direction == AnimationHelper.SLIDE_VERTICAL_DIRECTION ? "top" : "left",
    unit: "px",
    duration: this.duration,
    onComplete: this.onComplete
   });
  },
  convertPosToCssTransformPos: function (position) {
   return ASPx.AnimationUtils.GetTransformCssText(position, this.direction == AnimationHelper.SLIDE_VERTICAL_DIRECTION);
  }
 });
 var AnimationHelper = {
  SLIDE_HORIZONTAL_DIRECTION: 0,
  SLIDE_VERTICAL_DIRECTION: 1,
  SLIDE_TOP_DIRECTION: 0,
  SLIDE_RIGHT_DIRECTION: 1,
  SLIDE_BOTTOM_DIRECTION: 2,
  SLIDE_LEFT_DIRECTION: 3,
  SLIDE_CONTAINER_CLASS: "dxAC",
  MAXIMUM_DEPTH: 3,
  createAnimationTransition: function (element, options) {
   if(options.onStep) 
    options.animationEngine = "js";
   switch (options.animationEngine) {
    case "js":
     return ASPx.AnimationUtils.createJsAnimationTransition(element, options);
    case "css":
     return ASPx.AnimationUtils.createCssAnimationTransition(element, options);
    default:
     return ASPx.AnimationUtils.CanUseCssTransition() ? ASPx.AnimationUtils.createCssAnimationTransition(element, options) :
      ASPx.AnimationUtils.createJsAnimationTransition(element, options);
   }
  },
  createMultipleAnimationTransition: function (element, options) {
   return ASPx.AnimationUtils.createMultipleAnimationTransition(element, options);
  },
  createSimpleAnimationTransition: function (options) {
   return ASPx.AnimationUtils.createSimpleAnimationTransition(options);
  },
  cancelAnimation: function (element) {
   ASPx.AnimationTransitionBase.Cancel(element);
  },
  fadeIn: function (element, onComplete, duration) {
   AnimationHelper.fadeTo(element, {
    from: 0, to: 1,
    onComplete: onComplete,
    duration: duration || ASPx.AnimationConstants.Durations.DEFAULT
   });
  },
  fadeOut: function (element, onComplete, duration) {
   AnimationHelper.fadeTo(element, {
    from: ASPx.GetElementOpacity(element), to: 0,
    onComplete: onComplete,
    duration: duration || ASPx.AnimationConstants.Durations.DEFAULT
   });
  },
  fadeTo: function (element, options) {
   options.property = "opacity";
   if(!options.duration)
    options.duration = ASPx.AnimationConstants.Durations.SHORT;
   var transition = AnimationHelper.createAnimationTransition(element, options);
   if(!ASPx.IsExists(options.from))
    options.from = transition.GetValue();
   transition.Start(options.from, options.to);
  },
  slideIn: function (element, direction, onComplete, animationEngineType) {
   AnimationHelper.setOpacity(element, 1);
   var animationContainer = AnimationHelper.getSlideAnimationContainer(element, true, true);
   var pos = AnimationHelper.getSlideInStartPos(animationContainer, direction);
   var transition = AnimationHelper.createSlideTransition(animationContainer, direction,
    function (el) {
     AnimationHelper.resetSlideAnimationContainerSize(animationContainer);
     if(onComplete)
      onComplete(el);
    }, animationEngineType);
   transition.Start(pos, 0);
  },
  slideOut: function (element, direction, onComplete, animationEngineType) {
   var animationContainer = AnimationHelper.getSlideAnimationContainer(element, true, true);
   var pos = AnimationHelper.getSlideOutFinishPos(animationContainer, direction);
   var transition = AnimationHelper.createSlideTransition(animationContainer, direction,
    function (el) {
     AnimationHelper.setOpacity(el.firstChild, 0);
     if(onComplete)
      onComplete(el);
    }, animationEngineType);
   transition.Start(pos);
  },
  slideTo: function (element, options) {
   if(!ASPx.IsExists(options.direction))
    options.direction = AnimationHelper.SLIDE_HORIZONTAL_DIRECTION;
   var transition = new PositionAnimationTransition(element, options);
   transition.Start(options.to);
  },
  setOpacity: function (element, value) {
   ASPx.AnimationUtils.setOpacity(element, value);
  },
  appendWKAnimationClassNameIfRequired: function (element) {
   if(ASPx.AnimationUtils.CanUseCssTransform() && ASPx.Browser.WebKitFamily && !ASPx.ElementHasCssClass(element, "dx-wbv"))
    element.className += " dx-wbv";
  },
  findSlideAnimationContainer: function (element) {
   var container = element
   for(var i = 0; i < AnimationHelper.MAXIMUM_DEPTH; i++) {
    if(container.tagName == "BODY")
     return null;
    if(ASPx.ElementHasCssClass(container, AnimationHelper.SLIDE_CONTAINER_CLASS))
     return container;
    container = container.parentNode;
   }
   return null;
  },
  createSlideAnimationContainer: function (element) {
   var rootContainer = document.createElement("DIV");
   ASPx.SetStyles(rootContainer, {
    className: AnimationHelper.SLIDE_CONTAINER_CLASS,
    overflow: "hidden"
   });
   var elementContainer = document.createElement("DIV");
   rootContainer.appendChild(elementContainer);
   var parentNode = element.parentNode;
   parentNode.insertBefore(rootContainer, element);
   elementContainer.appendChild(element);
   return rootContainer;
  },
  getSlideAnimationContainer: function (element, create, fixSize) {
   if(!element) return;
   var width = element.offsetWidth;
   var height = element.offsetHeight;
   var container;
   if(element.className == AnimationHelper.SLIDE_CONTAINER_CLASS)
    container = element;
   if(!container)
    container = AnimationHelper.findSlideAnimationContainer(element);
   if(!container && create)
    container = AnimationHelper.createSlideAnimationContainer(element);
   if(container && fixSize) {
    ASPx.SetStyles(container, {
     width: width, height: height
    });
    ASPx.SetStyles(container.firstChild, {
     width: width, height: height
    });
   }
   return container;
  },
  resetSlideAnimationContainerSize: function (container) {
   ASPx.SetStyles(container, {
    width: "", height: ""
   });
   ASPx.SetStyles(container.firstChild, {
    width: "", height: ""
   });
  },
  getModifyProperty: function (direction) {
   if(direction == AnimationHelper.SLIDE_TOP_DIRECTION || direction == AnimationHelper.SLIDE_BOTTOM_DIRECTION)
    return "marginTop";
   return "marginLeft";
  },
  createSlideTransition: function (animationContainer, direction, complete, animationEngineType) {
   var animationEngine = "";
   switch(animationEngineType) {
    case AnimationEngineType.JS:
     animationEngine = "js";
     break;
    case AnimationEngineType.CSS:
     animationEngine = "css";
     break;
   }
   return AnimationHelper.createAnimationTransition(animationContainer.firstChild, {
    unit: "px",
    property: AnimationHelper.getModifyProperty(direction),
    onComplete: complete,
    animationEngine: animationEngine
   });
  },
  getSlideInStartPos: function (animationContainer, direction) {
   switch (direction) {
    case AnimationHelper.SLIDE_TOP_DIRECTION:
     return animationContainer.offsetHeight;
    case AnimationHelper.SLIDE_LEFT_DIRECTION:
     return animationContainer.offsetWidth;
    case AnimationHelper.SLIDE_RIGHT_DIRECTION:
     return -animationContainer.offsetWidth;
    case AnimationHelper.SLIDE_BOTTOM_DIRECTION:
     return -animationContainer.offsetHeight;
   }
  },
  getSlideOutFinishPos: function (animationContainer, direction) {
   switch (direction) {
    case AnimationHelper.SLIDE_TOP_DIRECTION:
     return -animationContainer.offsetHeight;
    case AnimationHelper.SLIDE_LEFT_DIRECTION:
     return -animationContainer.offsetWidth;
    case AnimationHelper.SLIDE_RIGHT_DIRECTION:
     return animationContainer.offsetWidth;
    case AnimationHelper.SLIDE_BOTTOM_DIRECTION:
     return animationContainer.offsetHeight;
   }
  }
 };
 var GestureHandler = ASPx.CreateClass(null, {
  constructor: function (getAnimationElement, canHandle, allowStart) {
   this.getAnimationElement = getAnimationElement;
   this.canHandle = canHandle;
   this.allowStart = allowStart;
   this.startMousePosX = 0;
   this.startMousePosY = 0;
   this.startTime = null;
   this.isEventsPrevented = false;
   this.savedElements = [];
  },
  OnSelectStart: function(evt) {
   ASPx.Evt.PreventEvent(evt); 
  },
  OnDragStart: function(evt) {
   ASPx.Evt.PreventEvent(evt);  
  },
  OnMouseDown: function (evt) {
   this.startMousePosX = ASPx.Evt.GetEventX(evt);
   this.startMousePosY = ASPx.Evt.GetEventY(evt);
   this.startTime = new Date();
  },
  OnMouseMove: function(evt) {
   if(!ASPx.Browser.MobileUI)
    ASPx.Selection.Clear();
   if(Math.abs(this.GetCurrentDistanceX(evt)) < GestureHandler.SLIDER_MIN_START_DISTANCE && Math.abs(this.GetCurrentDistanceY(evt)) < GestureHandler.SLIDER_MIN_START_DISTANCE)
    GesturesHelper.isExecutedGesture = false;
  },
  OnMouseUp: function (evt) {
  },
  CanHandleEvent: function (evt) {
   return !this.canHandle || this.canHandle(evt);
  },
  IsStartAllowed: function (value) {
   return !this.allowStart || this.allowStart(value);
  },
  RollbackGesture: function () {
  },
  GetRubberPosition: function (position) {
   return position / GestureHandler.FACTOR_RUBBER;
  },
  GetCurrentDistanceX: function (evt) {
   return ASPx.Evt.GetEventX(evt) - this.startMousePosX;
  },
  GetCurrentDistanceY: function (evt) {
   return ASPx.Evt.GetEventY(evt) - this.startMousePosY;
  },
  GetDistanceLimit: function () {
   return (new Date() - this.startTime) < GestureHandler.MAX_TIME_SPAN ? GestureHandler.MIN_DISTANCE_LIMIT : GestureHandler.MAX_DISTANCE_LIMIT;
  },
  GetContainerElement: function () {
  },
  AttachPreventEvents: function (evt) {
   if(!this.isEventsPrevented) {
    var element = ASPx.Evt.GetEventSource(evt);
    var container = this.GetContainerElement();
    while(element && element != container) {
     ASPx.Evt.AttachEventToElement(element, "mouseup", ASPx.Evt.PreventEvent);
     ASPx.Evt.AttachEventToElement(element, "click", ASPx.Evt.PreventEvent);
     this.savedElements.push(element);
     element = element.parentNode;
    }
    this.isEventsPrevented = true;
   }
  },
  DetachPreventEvents: function () {
   if(this.isEventsPrevented) {
    window.setTimeout(function () {
     while(this.savedElements.length > 0) {
      var element = this.savedElements.pop();
      ASPx.Evt.DetachEventFromElement(element, "mouseup", ASPx.Evt.PreventEvent);
      ASPx.Evt.DetachEventFromElement(element, "click", ASPx.Evt.PreventEvent);
     }
    }.aspxBind(this), 0);
    this.isEventsPrevented = false;
   }
  }
 });
 GestureHandler.MAX_DISTANCE_LIMIT = 70;
 GestureHandler.MIN_DISTANCE_LIMIT = 10;
 GestureHandler.MIN_START_DISTANCE = 0;
 GestureHandler.SLIDER_MIN_START_DISTANCE = 5;
 GestureHandler.MAX_TIME_SPAN = 300;
 GestureHandler.FACTOR_RUBBER = 4;
 GestureHandler.RETURN_ANIMATION_DURATION = 150;
 var SwipeSlideGestureHandler = ASPx.CreateClass(GestureHandler, {
  constructor: function (getAnimationElement, direction, canHandle, backward, forward, rollback, move) {
   this.constructor.prototype.constructor.call(this, getAnimationElement, canHandle);
   this.slideElement = this.getAnimationElement();
   this.container = this.slideElement.parentNode;
   this.direction = direction;
   this.backward = backward;
   this.forward = forward;
   this.rollback = rollback;
   this.slideElementSize = 0;
   this.containerElementSize = 0;
   this.startSliderElementPosition = 0;
   this.centeredSlideElementPosition = 0;
  },
  OnMouseDown: function (evt) {
   GestureHandler.prototype.OnMouseDown.call(this, evt);
   this.slideElementSize = this.GetElementSize();
   this.startSliderElementPosition = this.GetElementPosition();
   this.containerElementSize = this.GetContainerElementSize();
   if(this.slideElementSize <= this.containerElementSize)
    this.centeredSlideElementPosition = (this.containerElementSize - this.slideElementSize) / 2;
  },
  OnMouseMove: function (evt) {
   GestureHandler.prototype.OnMouseMove.call(this, evt);
   if(!ASPx.Browser.TouchUI && !ASPx.GetIsParent(this.container, ASPx.Evt.GetEventSource(evt))) {
    GesturesHelper.OnDocumentMouseUp(evt);
    return;
   }
   var distance = this.GetCurrentDistance(evt);
   if(Math.abs(distance) < GestureHandler.SLIDER_MIN_START_DISTANCE || ASPx.TouchUIHelper.isGesture)
    return;
   this.SetElementPosition(this.GetCalculatedPosition(distance));
   this.AttachPreventEvents(evt);
   ASPx.Evt.PreventEvent(evt);
  },
  GetCalculatedPosition: function (distance) {
   ASPx.AnimationTransitionBase.Cancel(this.slideElement);
   var position = this.startSliderElementPosition + distance,
    maxPosition = -(this.slideElementSize - this.containerElementSize),
    minPosition = 0;
   if(this.centeredSlideElementPosition > 0)
    position = this.GetRubberPosition(distance) + this.centeredSlideElementPosition;
   else if(position > minPosition)
    position = this.GetRubberPosition(distance);
   else if(position < maxPosition)
    position = this.GetRubberPosition(distance) + maxPosition;
   return position;
  },
  OnMouseUp: function (evt) {
   this.DetachPreventEvents();
   if(this.GetCurrentDistance(evt) != 0)
    this.OnMouseUpCore(evt);
  },
  OnMouseUpCore: function (evt) {
   var distance = this.GetCurrentDistance(evt);
   if(this.centeredSlideElementPosition > 0 || this.CheckSlidePanelIsOutOfBounds())
    this.PerformRollback();
   else
    this.PerformAction(distance);
  },
  PerformAction: function (distance) {
   if(Math.abs(distance) < this.GetDistanceLimit())
    this.PerformRollback();
   else if(distance < 0)
    this.PerformForward();
   else
    this.PerformBackward();
  },
  PerformBackward: function () {
   this.backward();
  },
  PerformForward: function () {
   this.forward();
  },
  PerformRollback: function () {
   this.rollback();
  },
  CheckSlidePanelIsOutOfBounds: function () {
   var minOffset = -(this.slideElementSize - this.containerElementSize), maxOffset = 0;
   var position = null, slideElementPos = this.GetElementPosition();
   if(slideElementPos > maxOffset || slideElementPos < minOffset)
    return true;
   return false;
  },
  GetContainerElement: function () {
   return this.container;
  },
  GetElementSize: function () {
   return this.IsHorizontalDirection() ? this.slideElement.offsetWidth : this.slideElement.offsetHeight;
  },
  GetContainerElementSize: function () {
   return this.IsHorizontalDirection() ? ASPx.GetClearClientWidth(this.container) : ASPx.GetClearClientHeight(this.container);
  },
  GetCurrentDistance: function (evt) {
   return this.IsHorizontalDirection() ? this.GetCurrentDistanceX(evt) : this.GetCurrentDistanceY(evt);
  },
  GetElementPosition: function () {
   return ASPx.AnimationUtils.GetTransformValue(this.slideElement, !this.IsHorizontalDirection());
  },
  SetElementPosition: function (position) {
   ASPx.AnimationUtils.SetTransformValue(this.slideElement, position, !this.IsHorizontalDirection());
  },
  IsHorizontalDirection: function () {
   return this.direction == AnimationHelper.SLIDE_HORIZONTAL_DIRECTION;
  }
 });
 var SwipeSimpleSlideGestureHandler = ASPx.CreateClass(SwipeSlideGestureHandler, {
  constructor: function (getAnimationElement, direction, canHandle, backward, forward, rollback, updatePosition) {
   this.constructor.prototype.constructor.call(this, getAnimationElement, direction, canHandle, backward, forward, rollback);
   this.container = this.slideElement;
   this.updatePosition = updatePosition;
   this.prevDistance = 0;
  },
  OnMouseDown: function (evt) {
   GestureHandler.prototype.OnMouseDown.call(this, evt);
   this.prevDistance = 0;
  },
  OnMouseUpCore: function (evt) {
   this.PerformAction(this.GetCurrentDistance(evt));
  },
  PerformAction: function (distance) {
   if(Math.abs(distance) < this.GetDistanceLimit())
    this.PerformRollback();
   else if(distance < 0)
    this.PerformForward();
   else
    this.PerformBackward();
  },
  GetCalculatedPosition: function (distance) {
   var position = distance - this.prevDistance;
   this.prevDistance = distance;
   return position;
  },
  SetElementPosition: function (position) {
   this.updatePosition(position);
  }
 });
 var SwipeGestureHandler = ASPx.CreateClass(GestureHandler, {
  constructor: function (getAnimationElement, canHandle, allowStart, start, allowComplete, complete, cancel, animationEngineType) {
   this.constructor.prototype.constructor.call(this, getAnimationElement, canHandle, allowStart);
   this.start = start;
   this.allowComplete = allowComplete;
   this.complete = complete;
   this.cancel = cancel;
   this.animationTween = null;
   this.currentDistanceX = 0;
   this.currentDistanceY = 0;
   this.tryStartGesture = false;
   this.tryStartScrolling = false;
   this.animationEngineType = animationEngineType;
   this.UpdateAnimationContainer();
  },
  UpdateAnimationContainer: function () {
   this.animationContainer = AnimationHelper.getSlideAnimationContainer(this.getAnimationElement(), true, false);
  },
  CanHandleEvent: function (evt) {
   if(GestureHandler.prototype.CanHandleEvent.call(this, evt))
    return true;
   return this.animationTween && this.animationContainer && ASPx.GetIsParent(this.animationContainer, ASPx.Evt.GetEventSource(evt));
  },
  OnMouseDown: function (evt) {
   GestureHandler.prototype.OnMouseDown.call(this, evt);
   if(this.animationTween)
    this.animationTween.Cancel();
   this.currentDistanceX = 0;
   this.currentDistanceY = 0;
   this.tryStartGesture = false;
   this.tryStartScrolling = false;
  },
  OnMouseMove: function (evt) {
   GestureHandler.prototype.OnMouseMove.call(this, evt);
   this.currentDistanceX = this.GetCurrentDistanceX(evt);
   this.currentDistanceY = this.GetCurrentDistanceY(evt);
   if(!this.animationTween && !this.tryStartScrolling && (Math.abs(this.currentDistanceX) > GestureHandler.MIN_START_DISTANCE || Math.abs(this.currentDistanceY) > GestureHandler.MIN_START_DISTANCE)) {
    if(Math.abs(this.currentDistanceY) < Math.abs(this.currentDistanceX)) {
     this.tryStartGesture = true;
     if(this.IsStartAllowed(this.currentDistanceX)) {
      this.animationContainer = AnimationHelper.getSlideAnimationContainer(this.getAnimationElement(), true, true);
      this.animationTween = AnimationHelper.createSlideTransition(this.animationContainer, AnimationHelper.SLIDE_LEFT_DIRECTION,
       function () {
        AnimationHelper.resetSlideAnimationContainerSize(this.animationContainer);
        this.animationContainer = null;
        this.animationTween = null;
       }.aspxBind(this), this.animationEngineType);
      this.PerformStart(this.currentDistanceX);
      this.AttachPreventEvents(evt);
     }
    }
    else
     this.tryStartScrolling = true;
   }
   if(this.animationTween) {
    if(this.allowComplete && !this.allowComplete(this.currentDistanceX))
     this.currentDistanceX = this.GetRubberPosition(this.currentDistanceX);
    this.animationTween.SetValue(this.currentDistanceX);
   }
   if(!this.tryStartScrolling && !ASPx.TouchUIHelper.isGesture && evt.touches && evt.touches.length < 2)
    ASPx.Evt.PreventEvent(evt);
  },
  OnMouseUp: function (evt) {
   if(!this.animationTween) {
    if(this.tryStartGesture)
     this.PerformCancel(this.currentDistanceX);
   }
   else {
    if(Math.abs(this.currentDistanceX) < this.GetDistanceLimit())
     this.RollbackGesture();
    else {
     if(this.IsCompleteAllowed(this.currentDistanceX)) {
      this.PerformComplete(this.currentDistanceX);
      this.animationContainer = null;
      this.animationTween = null;
     }
     else
      this.RollbackGesture();
    }
   }
   this.DetachPreventEvents();
   this.tryStartGesture = false;
   this.tryStartScrolling = false;
  },
  PerformStart: function (value) {
   if(this.start)
    this.start(value);
  },
  IsCompleteAllowed: function (value) {
   return !this.allowComplete || this.allowComplete(value);
  },
  PerformComplete: function (value) {
   if(this.complete)
    this.complete(value);
  },
  PerformCancel: function (value) {
   if(this.cancel)
    this.cancel(value);
  },
  RollbackGesture: function () {
   this.animationTween.Start(this.currentDistanceX, 0);
  },
  GetContainerElement: function () {
   return this.animationContainer;
  }
 });
 var GesturesHelper = {
  handlers: {},
  activeHandler: null,
  isAttachedEvents: false,
  isExecutedGesture: false,
  AddSwipeGestureHandler: function (id, getAnimationElement, canHandle, allowStart, start, allowComplete, complete, cancel, animationEngineType) {
   this.handlers[id] = new SwipeGestureHandler(getAnimationElement, canHandle, allowStart, start, allowComplete, complete, cancel, animationEngineType);
  },
  UpdateSwipeAnimationContainer: function (id) {
   if(this.handlers[id])
    this.handlers[id].UpdateAnimationContainer();
  },
  AddSwipeSlideGestureHandler: function (id, getAnimationElement, direction, canHandle, backward, forward, rollback, updatePosition) {
   if(updatePosition)
    this.handlers[id] = new SwipeSimpleSlideGestureHandler(getAnimationElement, direction, canHandle, backward, forward, rollback, updatePosition);
   else
    this.handlers[id] = new SwipeSlideGestureHandler(getAnimationElement, direction, canHandle, backward, forward, rollback);
  },
  canHandleMouseDown: function(evt) {
   if(!ASPx.Evt.IsLeftButtonPressed(evt))
    return false;
   var element = ASPx.Evt.GetEventSource(evt);
   var dxFocusedEditor = ASPx.Ident.scripts.ASPxClientEdit && ASPx.GetFocusedEditor();
   if(dxFocusedEditor && dxFocusedEditor.IsEditorElement(element))
    return false;
   var isTextEditor = element.tagName == "TEXTAREA" || element.tagName == "INPUT" && ASPx.Attr.GetAttribute(element, "type") == "text";
   if(isTextEditor && document.activeElement == element)
    return false;
   return true;  
  },
  OnDocumentDragStart: function(evt) {
   if(GesturesHelper.activeHandler)
    GesturesHelper.activeHandler.OnDragStart(evt);
  },
  OnDocumentSelectStart: function(evt) {
   if(GesturesHelper.activeHandler)
    GesturesHelper.activeHandler.OnSelectStart(evt);
  },
  OnDocumentMouseDown: function (evt) {
   if(!GesturesHelper.canHandleMouseDown(evt))
    return;
   GesturesHelper.activeHandler = GesturesHelper.FindHandler(evt);
   if(GesturesHelper.activeHandler)
    GesturesHelper.activeHandler.OnMouseDown(evt);
  },
  OnDocumentMouseMove: function (evt) {
   if(GesturesHelper.activeHandler) {
    GesturesHelper.isExecutedGesture = true;
    GesturesHelper.activeHandler.OnMouseMove(evt);
   }
  },
  OnDocumentMouseUp: function (evt) {
   if(GesturesHelper.activeHandler) {
    GesturesHelper.activeHandler.OnMouseUp(evt);
    GesturesHelper.activeHandler = null;
    window.setTimeout(function () { GesturesHelper.isExecutedGesture = false; }, 0);
   }
  },
  AttachEvents: function () {
   if(!GesturesHelper.isAttachedEvents) {
    GesturesHelper.Attach(ASPx.Evt.AttachEventToElement);
    GesturesHelper.isAttachedEvents = true;
   }
  },
  DetachEvents: function () {
   if(GesturesHelper.isAttachedEvents) {
    GesturesHelper.Attach(ASPx.Evt.DetachEventFromElement);
    GesturesHelper.isAttachedEvents = false;
   }
  },
  Attach: function (changeEventsMethod) {
   var doc = window.document;
   changeEventsMethod(doc, ASPx.TouchUIHelper.touchMouseDownEventName, GesturesHelper.OnDocumentMouseDown);
   changeEventsMethod(doc, ASPx.TouchUIHelper.touchMouseMoveEventName, GesturesHelper.OnDocumentMouseMove);
   changeEventsMethod(doc, ASPx.TouchUIHelper.touchMouseUpEventName, GesturesHelper.OnDocumentMouseUp);
   if(!ASPx.Browser.MobileUI) {
    changeEventsMethod(doc, "selectstart", GesturesHelper.OnDocumentSelectStart);
    changeEventsMethod(doc, "dragstart", GesturesHelper.OnDocumentDragStart);
   }
  },
  FindHandler: function (evt) {
   var handlers = [];
   for(var id in GesturesHelper.handlers) {
    var handler = GesturesHelper.handlers[id];
    if(handler.CanHandleEvent && handler.CanHandleEvent(evt))
     handlers.push(handler);
   }
   if(!handlers.length)
    return null;
   handlers.sort(function (a, b) {
    return ASPx.GetIsParent(a.getAnimationElement(), b.getAnimationElement()) ? 1 : -1;
   });
   return handlers[0];
  },
  IsExecutedGesture: function () {
   return GesturesHelper.isExecutedGesture;
  }
 };
 GesturesHelper.AttachEvents();
 var AnimationEngineType = {
  "JS": 0,
  "CSS": 1,
  "DEFAULT" : 2
 }
 ASPx.AnimationEngineType = AnimationEngineType;
 ASPx.AnimationHelper = AnimationHelper;
 ASPx.GesturesHelper = GesturesHelper;
})();
(function () {
var PopupUtils = {
 NotSetAlignIndicator: "NotSet",
 InnerAlignIndicator: "Sides",
 OutsideLeftAlignIndicator: "OutsideLeft",
 LeftSidesAlignIndicator: "LeftSides",
 RightSidesAlignIndicator: "RightSides",
 OutsideRightAlignIndicator: "OutsideRight",
 CenterAlignIndicator: "Center",
 AboveAlignIndicator: "Above",
 TopSidesAlignIndicator: "TopSides",
 MiddleAlignIndicator: "Middle",
 BottomSidesAlignIndicator: "BottomSides",
 BelowAlignIndicator: "Below",
 WindowCenterAlignIndicator: "WindowCenter",
 LeftAlignIndicator: "Left",
 RightAlignIndicator: "Right",
 TopAlignIndicator: "Top",
 BottomAlignIndicator: "Bottom",
 WindowLeftAlignIndicator: "WindowLeft",
 WindowRightAlignIndicator: "WindowRight",
 WindowTopAlignIndicator: "WindowTop",
 WindowBottomAlignIndicator: "WindowBottom",
 IsAlignNotSet: function (align) {
  return align == PopupUtils.NotSetAlignIndicator;
 },
 IsInnerAlign: function (align) {
  return align.indexOf(PopupUtils.InnerAlignIndicator) != -1;
 },
 IsRightSidesAlign: function(align) {
  return align == PopupUtils.RightSidesAlignIndicator;
 },
 IsOutsideRightAlign: function(align) {
  return align == PopupUtils.OutsideRightAlignIndicator;
 },
 IsCenterAlign: function(align) {
  return align == PopupUtils.CenterAlignIndicator;
 },
 FindPopupElementById: function (id) {
  if(id == "")
   return null; 
  var popupElement = ASPx.GetElementById(id);
  if(!ASPx.IsExistsElement(popupElement)) {
   var idParts = id.split("_");
   var uniqueId = idParts.join("$");
   popupElement = ASPx.GetElementById(uniqueId);
  }
  return popupElement;
 },
 FindEventSourceParentByTestFunc: function (evt, testFunc) {
  return ASPx.GetParent(ASPx.Evt.GetEventSource(evt), testFunc);
 },
 PreventContextMenu: function (evt) {
  if(evt.stopPropagation)
   evt.stopPropagation();
  if(evt.preventDefault)
   evt.preventDefault();
  if(ASPx.Browser.WebKitFamily)
   evt.returnValue = false;
 },
 GetDocumentClientWidthForPopup: function () {
  return ASPx.Browser.WebKitTouchUI ? ASPx.GetDocumentWidth() : ASPx.GetDocumentClientWidth(); 
 },
 GetDocumentClientHeightForPopup: function() {
  return ASPx.Browser.WebKitTouchUI ? ASPx.GetDocumentHeight() : ASPx.GetDocumentClientHeight(); 
 },
 AdjustPositionToClientScreen: function (element, pos, rtl, isX) {
  var min = isX ? ASPx.GetDocumentScrollLeft() : ASPx.GetDocumentScrollTop(),
   viewPortWidth = ASPx.Browser.WebKitTouchUI ? window.innerWidth : ASPx.GetDocumentClientWidth(),
   max = min + (isX ? viewPortWidth : ASPx.GetDocumentClientHeight());
  max -= (isX ? element.offsetWidth : element.offsetHeight);
  if(rtl) {
   if(pos < min) pos = min;
   if(pos > max) pos = max;
  } else {
   if(pos > max) pos = max;
   if(pos < min) pos = min;
  }
  return pos;
 },
 GetPopupAbsoluteX: function(element, popupElement, hAlign, hOffset, x, left, rtl, isPopupFullCorrectionOn) {
  return PopupUtils.getPopupAbsolutePos(element, popupElement, hAlign, hOffset, x, left, rtl, isPopupFullCorrectionOn, true);
 },
 GetPopupAbsoluteY: function (element, popupElement, vAlign, vOffset, y, top, isPopupFullCorrectionOn) {
  return PopupUtils.getPopupAbsolutePos(element, popupElement, vAlign, vOffset, y, top, false, isPopupFullCorrectionOn, false);
 },
 getPopupAbsolutePos: function(element, popupElement, align, offset, startPos, startPosInit, rtl, isPopupFullCorrectionOn, isHorizontal) {
  var calculator = getPositionCalculator();
  calculator.applyParams(element, popupElement, align, offset, startPos, startPosInit, rtl, isPopupFullCorrectionOn, isHorizontal);
  var position = calculator.getPopupAbsolutePos();
  calculator.disposeState();
  return position;
 },
 RemoveFocus: function (parent) {
  var div = document.createElement('div');
  div.tabIndex = "-1";
  PopupUtils.ConcealDivElement(div);
  parent.appendChild(div);
  if(ASPx.IsFocusable(div))
   div.focus();
  ASPx.RemoveElement(div);
 },
 ConcealDivElement: function (div) {
  div.style.position = "absolute";
  div.style.left = 0;
  div.style.top = 0;
  if(ASPx.Browser.WebKitFamily) {
   div.style.opacity = 0;
   div.style.width = 1;
   div.style.height = 1;
  } else {
   div.style.border = 0;
   div.style.width = 0;
   div.style.height = 0;
  }
 },
 InitAnimationDiv: function (element, x, y, onAnimStopCallString, skipSizeInit) {
  PopupUtils.InitAnimationDivCore(element);
  element.popuping = true;
  element.onAnimStopCallString = onAnimStopCallString;
  if(!skipSizeInit)
   ASPx.SetStyles(element, { width: element.offsetWidth, height: element.offsetHeight });
  ASPx.SetStyles(element, { left: x, top: y });
 },
 InitAnimationDivCore: function (element) {
  ASPx.SetStyles(element, {
   overflow: "hidden",
   position: "absolute"
  });
 },
 StartSlideAnimation: function (animationDivElement, element, iframeElement, duration, preventChangingWidth, preventChangingHeight) {
  if(iframeElement) {
   var endLeft = ASPx.PxToInt(iframeElement.style.left);
   var endTop = ASPx.PxToInt(iframeElement.style.top);
   var startLeft = ASPx.PxToInt(element.style.left) < 0 ? endLeft : animationDivElement.offsetLeft + animationDivElement.offsetWidth;
   var startTop = ASPx.PxToInt(element.style.top) < 0 ? endTop : animationDivElement.offsetTop + animationDivElement.offsetHeight;
   var properties = {
    left: { from: startLeft, to: endLeft, unit: "px" },
    top: { from: startTop, to: endTop, unit: "px" }
   };
   if(!preventChangingWidth)
    properties["width"] = { to: element.offsetWidth, unit: "px" };
   if(!preventChangingHeight)
    properties["height"] = { to: element.offsetHeight, unit: "px" };
   ASPx.AnimationHelper.createMultipleAnimationTransition(iframeElement, {
    duration: duration
   }).Start(properties);
  }
  ASPx.AnimationHelper.createMultipleAnimationTransition(element, {
   duration: duration,
   onComplete: function () { PopupUtils.AnimationFinished(animationDivElement, element); }
  }).Start({
   left: { to: 0, unit: "px" },
   top: { to: 0, unit: "px" }
  });
 },
 AnimationFinished: function (animationDivElement, element) {
  if(PopupUtils.StopAnimation(animationDivElement, element) && ASPx.IsExists(animationDivElement.onAnimStopCallString) &&
   animationDivElement.onAnimStopCallString !== "") {
   window.setTimeout(animationDivElement.onAnimStopCallString, 0);
  }
 },
 StopAnimation: function (animationDivElement, element) {
  if(animationDivElement.popuping) {
   ASPx.AnimationHelper.cancelAnimation(element);
   animationDivElement.popuping = false;
   animationDivElement.style.overflow = "visible";
   return true;
  }
  return false;
 },
 GetAnimationHorizontalDirection: function (popupPosition, horizontalAlign, verticalAlign, rtl) {
  if(PopupUtils.IsInnerAlign(horizontalAlign)
   && !PopupUtils.IsInnerAlign(verticalAlign)
   && !PopupUtils.IsAlignNotSet(verticalAlign))
   return 0;
  var toTheLeft = (horizontalAlign == PopupUtils.OutsideLeftAlignIndicator || horizontalAlign == PopupUtils.RightSidesAlignIndicator || (horizontalAlign == PopupUtils.NotSetAlignIndicator && rtl)) ^ popupPosition.isInverted;
  return toTheLeft ? 1 : -1;
 },
 GetAnimationVerticalDirection: function (popupPosition, horizontalAlign, verticalAlign) {
  if(PopupUtils.IsInnerAlign(verticalAlign)
   && !PopupUtils.IsInnerAlign(horizontalAlign)
   && !PopupUtils.IsAlignNotSet(horizontalAlign))
   return 0;
  var toTheTop = (verticalAlign == PopupUtils.AboveAlignIndicator || verticalAlign == PopupUtils.BottomSidesAlignIndicator) ^ popupPosition.isInverted;
  return toTheTop ? 1 : -1;
 },
 IsVerticalScrollExists: function () {
  var scrollIsNotHidden = ASPx.GetCurrentStyle(document.body).overflowY !== "hidden" && ASPx.GetCurrentStyle(document.documentElement).overflowY !== "hidden";
  return (scrollIsNotHidden && ASPx.GetDocumentHeight() > ASPx.GetDocumentClientHeight());
 },
 CoordinatesInDocumentRect: function (x, y) {
  var docScrollLeft = ASPx.GetDocumentScrollLeft();
  var docScrollTop = ASPx.GetDocumentScrollTop();
  return (x > docScrollLeft && y > docScrollTop &&
   x < ASPx.GetDocumentClientWidth() + docScrollLeft &&
   y < ASPx.GetDocumentClientHeight() + docScrollTop);
 },
 GetElementZIndexArray: function (element) {
  var currentElement = element;
  var zIndexesArray = [0];
  while(currentElement && currentElement.tagName != "BODY") {
   if(currentElement.style) {
    if(typeof (currentElement.style.zIndex) != "undefined" && currentElement.style.zIndex != "")
     zIndexesArray.unshift(currentElement.style.zIndex);
   }
   currentElement = currentElement.parentNode;
  }
  return zIndexesArray;
 },
 IsHigher: function (higherZIndexArrat, zIndexArray) {
  if(zIndexArray == null) return true;
  var count = (higherZIndexArrat.length >= zIndexArray.length) ? higherZIndexArrat.length : zIndexArray.length;
  for(var i = 0; i < count; i++)
   if(typeof (higherZIndexArrat[i]) != "undefined" && typeof (zIndexArray[i]) != "undefined") {
    var higherZIndexArrayCurrentElement = parseInt(higherZIndexArrat[i].toString());
    var zIndexArrayCurrentElement = parseInt(zIndexArray[i].toString());
    if(higherZIndexArrayCurrentElement != zIndexArrayCurrentElement)
     return higherZIndexArrayCurrentElement > zIndexArrayCurrentElement;
   } else return typeof (zIndexArray[i]) == "undefined";
  return true;
 },
 TestIsPopupElement: function (element) {
  return !!element.DXPopupElementControl;
 }
}
PopupUtils.OverControl = {
 GetPopupElementByEvt: function (evt) {
  return PopupUtils.FindEventSourceParentByTestFunc(evt, PopupUtils.TestIsPopupElement);
 },
 OnMouseEvent: function (evt, mouseOver) {
  var popupElement = PopupUtils.OverControl.GetPopupElementByEvt(evt);
  if(mouseOver)
   popupElement.DXPopupElementControl.OnPopupElementMouseOver(evt, popupElement);
  else
   popupElement.DXPopupElementControl.OnPopupElementMouseOut(evt, popupElement);
 },
 OnMouseOut: function (evt) {
  PopupUtils.OverControl.OnMouseEvent(evt, false);
 },
 OnMouseOver: function (evt) {
  PopupUtils.OverControl.OnMouseEvent(evt, true);
 }
}
PopupUtils.BodyScrollHelper = (function () {
 var windowScrollLock = {};
 function lockWindowScroll(windowId) {
  windowScrollLock[windowId] = true;
 }
 function unlockWindowScroll(windowId) {
  windowScrollLock[windowId] = false;
 }
 function isAnyWindowScrollLocked() {
  for(var key in windowScrollLock) 
   if(windowScrollLock[key])
    return true;
  return false;
 }
 function fixScrollsBug() {
  var scrollTop = document.body.scrollTop;
  var scrollLeft = document.body.scrollLeft;
  document.body.scrollTop++;
  document.body.scrollTop--;
  document.body.scrollLeft++;
  document.body.scrollLeft--;
  document.body.scrollLeft = scrollLeft;
  document.body.scrollTop = scrollTop;
 }
 return {
  HideBodyScroll: function(windowId) {
   if(ASPx.Browser.WebKitTouchUI)
    return;
   if(isAnyWindowScrollLocked()) { 
    lockWindowScroll(windowId);
    return;
   }
   lockWindowScroll(windowId);
   var verticalScrollMustBeReplacedByMargin = PopupUtils.IsVerticalScrollExists();
   if(ASPx.Browser.IE) {
    ASPx.Attr.ChangeAttribute(document.body, "scroll", "no");
    ASPx.Attr.ChangeStyleAttribute(document.documentElement, "overflow", "hidden");
   } else if(ASPx.Browser.Firefox && ASPx.Browser.Version < 3) { 
    var scrollTop = document.documentElement.scrollTop;
    ASPx.Attr.ChangeStyleAttribute(document.body, "overflow", "hidden");
    document.documentElement.scrollTop = scrollTop;
   } else {
    ASPx.Attr.ChangeStyleAttribute(document.documentElement, "overflow", "hidden");
    var documentHeight = ASPx.GetDocumentHeight();
    var documentWidth = ASPx.GetDocumentWidth();
    if(window.pageYOffset > 0 && ASPx.PxToInt(window.getComputedStyle(document.body, null)) != documentHeight)
     ASPx.Attr.ChangeStyleAttribute(document.body, "height", documentHeight + "px");
    if(window.pageXOffset > 0 && ASPx.PxToInt(window.getComputedStyle(document.body, null)) != documentWidth)
     ASPx.Attr.ChangeStyleAttribute(document.body, "width", documentWidth + "px");
    if(ASPx.Browser.Chrome) {
     fixScrollsBug();
    }
   }
   if(verticalScrollMustBeReplacedByMargin) {
    var currentBodyStyle = ASPx.GetCurrentStyle(document.body),
     marginWidth = ASPx.GetVerticalScrollBarWidth() + ASPx.PxToInt(currentBodyStyle.marginRight);
    ASPx.Attr.ChangeStyleAttribute(document.body, "margin-right", marginWidth + "px");
   }
  },
  RestoreBodyScroll: function (windowId) {
   if(ASPx.Browser.WebKitTouchUI)
    return;
   unlockWindowScroll(windowId);
   if(isAnyWindowScrollLocked())
    return;
   if(ASPx.Browser.IE) {
    ASPx.Attr.RestoreAttribute(document.body, "scroll");
    ASPx.Attr.RestoreStyleAttribute(document.documentElement, "overflow");
   } else {
    ASPx.Attr.RestoreStyleAttribute(document.documentElement, "overflow");
   }
   ASPx.Attr.RestoreStyleAttribute(document.body, "margin-right");
   ASPx.Attr.RestoreStyleAttribute(document.body, "height");
   ASPx.Attr.RestoreStyleAttribute(document.body, "width");
   if(ASPx.Browser.WebKitFamily) { 
    fixScrollsBug();
   }
  }
 }
})();
var PositionAlignConsts = {
 NOT_SET: 0,
 OUTSIDE_START: 1,
 NEAR_BOUND_START: 2,
 INNER_START: 3,
 CENTER: 4,
 INNER_END: 5,
 NEAR_BOUND_END: 6,
 OUTSIDE_END: 7,
 WINDOW_CENTER: 8,
 WINDOW_START: 9,
 WINDOW_END: 10
};
var AlignIndicatorTable = {};
var PositionCalculator = ASPx.CreateClass(null, {
 constructor: function() {
  this.element = null;
  this.popupElement = null;
  this.align = 0;
  this.offset = 0;
  this.startPos = 0;
  this.startPosInit = 0;
  this.rtl = false;
  this.isPopupFullCorrectionOn = false;
  this.isHorizontal = true;
  this.size = 0;
  this.bodySize = 0;
  this.actualBodySize = 0;
  this.elementStartPos = 0;
  this.scrollStartPos = 0;
  this.isInverted = false;
  this.popupElementSize = 0;
  this.boundStartPos = 0;
  this.boundEndPos = 0;
  this.innerBoundStartPos = 0;
  this.innerBoundEndPos = 0;
  this.isMoreFreeSpaceLeft = false;
  this.nearBoundOverlapRate = 0.25;
  this.functionsTable = {};
  this.initializeFunctionsTable();
 },
 applyParams: function(element, popupElement, align, offset, startPos, startPosInit, rtl, isPopupFullCorrectionOn, isHorizontal) {
  this.isHorizontal = isHorizontal;
  this.element = element;
  this.popupElement = popupElement;
  this.align = this.getAlignValueFromIndicator(align);
  this.offset = offset;
  this.startPos = startPos;
  this.startPosInit = startPosInit;
  this.rtl = rtl;
  this.isPopupFullCorrectionOn = isPopupFullCorrectionOn;
  this.calculateParams();
 },
 disposeState: function() {
  this.element = null;
  this.popupElement = null;
 },
 getPopupAbsolutePos: function() {
  if(this.isWindowAlign()) {
   var showAtPos = this.startPos != ASPx.InvalidPosition && !this.popupElement;
   if(showAtPos)
    this.align = PositionAlignConsts.NOT_SET;
   else
    return this.getWindowAlignPos();
  }
  if(this.popupElement)
   this.calculatePopupElement();
  else
   this.align = PositionAlignConsts.NOT_SET;
  return this.getPopupAbsolutePosCore();
 },
 initializeFunctionsTable: function() {
  var table = this.functionsTable;
  table[PositionAlignConsts.NOT_SET] = this.calculateNotSet;
  table[PositionAlignConsts.OUTSIDE_START] = this.calculateOutsideStart;
  table[PositionAlignConsts.INNER_START] = this.calculateInnerStart;
  table[PositionAlignConsts.CENTER] = this.calculateCenter;
  table[PositionAlignConsts.INNER_END] = this.calculateInnerEnd;
  table[PositionAlignConsts.OUTSIDE_END] = this.calculateOutsideEnd;
  table[PositionAlignConsts.NEAR_BOUND_START] = this.calculateNearBoundStart;
  table[PositionAlignConsts.NEAR_BOUND_END] = this.calculateNearBoundEnd;
  table[PositionAlignConsts.WINDOW_CENTER] = this.calculateWindowCenter;
  table[PositionAlignConsts.WINDOW_START] = this.calculateWindowStart;
  table[PositionAlignConsts.WINDOW_END] = this.calculateWindowEnd;
 },
 calculateParams: function() {
  this.size = this.getElementSize();
  if(this.isHorizontal) {
   this.bodySize = ASPx.GetDocumentClientWidth();
   this.elementStartPos = ASPx.GetAbsoluteX(this.popupElement);
   this.scrollStartPos = ASPx.GetDocumentScrollLeft();
  }
  else {
   this.bodySize = ASPx.GetDocumentClientHeight();
   this.elementStartPos = ASPx.GetAbsoluteY(this.popupElement);
   this.scrollStartPos = ASPx.GetDocumentScrollTop();
  }
 },
 isWindowAlign: function() {
  return this.align == PositionAlignConsts.WINDOW_CENTER || this.align == PositionAlignConsts.WINDOW_START ||
   this.align == PositionAlignConsts.WINDOW_END;
 },
 getWindowAlignPos: function() {
  this.actualBodySize = ASPx.Browser.WebKitTouchUI ? this.getWindowInnerSize() : this.bodySize;
  return this.getPopupAbsolutePosCore();
 },
 getPopupAbsolutePosCore: function() {
  var calculationFunc = this.functionsTable[this.align];
  calculationFunc.call(this);
  return new ASPx.PopupPosition(this.startPos, this.isInverted);
 },
 calculateWindowCenter: function() {
  this.startPos = Math.ceil(this.actualBodySize / 2 - this.size / 2) + this.scrollStartPos + this.offset;
 },
 calculateWindowStart: function() {
  this.startPos = this.scrollStartPos + this.offset;
 },
 calculateWindowEnd: function() {
  this.startPos = this.scrollStartPos + this.actualBodySize - this.size + this.offset;
 },
 calculatePopupElement: function() {
  this.popupElementSize = this.getPopupElementSize();
  this.boundStartPos = this.elementStartPos - this.size;
  this.boundEndPos = this.elementStartPos + this.popupElementSize;
  this.innerBoundStartPos = this.elementStartPos;
  this.innerBoundEndPos = this.elementStartPos + this.popupElementSize - this.size;
  this.isMoreFreeSpaceLeft = this.bodySize - (this.boundEndPos + this.size) < this.boundStartPos - 2 * this.scrollStartPos;
 },
 calculateOutsideStart: function() {
  this.isInverted = this.isPopupFullCorrectionOn && (!(this.boundStartPos - this.scrollStartPos > 0 || this.isMoreFreeSpaceLeft));
  if(this.isInverted)
   this.startPos = this.boundEndPos - this.offset;
  else
   this.startPos = this.boundStartPos + this.offset;
 },
 calculateInnerStart: function() {
  this.startPos = this.innerBoundStartPos + this.offset;
  if(this.isPopupFullCorrectionOn)
   this.startPos = PopupUtils.AdjustPositionToClientScreen(this.element, this.startPos, this.rtl, true);
 },
 calculateCenter: function() {
  this.startPos = this.elementStartPos + Math.round((this.popupElementSize - this.size) / 2) + this.offset;
 },
 calculateInnerEnd: function() {
  this.startPos = this.innerBoundEndPos + this.offset;
  if(this.isPopupFullCorrectionOn)
   this.startPos = PopupUtils.AdjustPositionToClientScreen(this.element, this.startPos, this.rtl, true);
 },
 calculateOutsideEnd: function() {
  this.isInverted = this.isPopupFullCorrectionOn && (!(this.boundEndPos + this.size < this.bodySize + this.scrollStartPos || !this.isMoreFreeSpaceLeft));
  if(this.isInverted)
   this.startPos = this.boundStartPos - this.offset;
  else
   this.startPos = this.boundEndPos + this.offset;
 },
 calculateNotSet: function() {
  if(this.rtl)
   this.calculateNotSetRightToLeft();
  else
   this.calculateNotSetLeftToRight();
 },
 calculateNotSetLeftToRight: function() {
  if(!ASPx.IsValidPosition(this.startPos)) {
   if(this.popupElement)
    this.startPos = this.elementStartPos;
   else if(this.offset)
    this.startPos = 0;
   else
    this.startPos = this.startPosInit;
  }
  this.isInverted = this.isPopupFullCorrectionOn && (this.startPos - this.scrollStartPos + this.size > this.bodySize && this.startPos - this.scrollStartPos > this.bodySize / 2);
  if(this.isInverted)
   this.startPos = this.startPos - this.size - this.offset;
  else
   this.startPos = this.startPos + this.offset;
 },
 calculateNotSetRightToLeft: function() {
  if(!ASPx.IsValidPosition(this.startPos)) {
   if(this.popupElement)
    this.startPos = this.innerBoundEndPos;
   else if(this.offset)
    this.startPos = 0;
   else
    this.startPos = this.startPosInit;
  }
  else
   this.startPos -= this.size;
  this.isInverted = this.isPopupFullCorrectionOn && (this.startPos < this.scrollStartPos && this.startPos - this.scrollStartPos < this.bodySize / 2);
  if(this.isInverted)
   this.startPos = this.startPos + this.size + this.offset;
  else
   this.startPos = this.startPos - this.offset;
 },
 calculateNearBoundStart: function() {
  this.startPos = this.boundStartPos + this.offset + this.size * this.nearBoundOverlapRate;
  if(this.isPopupFullCorrectionOn)
   this.startPos = PopupUtils.AdjustPositionToClientScreen(this.element, this.startPos, this.rtl, true);
 },
 calculateNearBoundEnd: function() {
  this.startPos = this.boundEndPos + this.offset - this.size * this.nearBoundOverlapRate;
  if(this.isPopupFullCorrectionOn)
   this.startPos = PopupUtils.AdjustPositionToClientScreen(this.element, this.startPos, this.rtl, true);
 },
 getAlignValueFromIndicator: function(alignIndicator) {
  var alignValue = AlignIndicatorTable[alignIndicator];
  if(alignValue === undefined)
   throw "Incorrect align indicator.";
  return alignValue;
 },
 getElementSize: function() {
  return this.getCustomElementSize(this.element);
 },
 getPopupElementSize: function() {
  return this.getCustomElementSize(this.popupElement);
 },
 getCustomElementSize: function(customElement) {
  return this.isHorizontal ? customElement.offsetWidth : customElement.offsetHeight;
 },
 getWindowInnerSize: function() {
  return this.isHorizontal ? window.innerWidth : window.innerHeight;
 }
});
var positionCalculator = null;
function getPositionCalculator() {
 if(positionCalculator == null)
  positionCalculator = new PositionCalculator();
 return positionCalculator;
}
function initializeAlignIndicatorTable() {
 AlignIndicatorTable[PopupUtils.NotSetAlignIndicator] = PositionAlignConsts.NOT_SET;
 AlignIndicatorTable[PopupUtils.OutsideLeftAlignIndicator] = PositionAlignConsts.OUTSIDE_START;
 AlignIndicatorTable[PopupUtils.AboveAlignIndicator] = PositionAlignConsts.OUTSIDE_START;
 AlignIndicatorTable[PopupUtils.LeftAlignIndicator] = PositionAlignConsts.NEAR_BOUND_START;
 AlignIndicatorTable[PopupUtils.TopAlignIndicator] = PositionAlignConsts.NEAR_BOUND_START;
 AlignIndicatorTable[PopupUtils.LeftSidesAlignIndicator] = PositionAlignConsts.INNER_START;
 AlignIndicatorTable[PopupUtils.TopSidesAlignIndicator] = PositionAlignConsts.INNER_START;
 AlignIndicatorTable[PopupUtils.CenterAlignIndicator] = PositionAlignConsts.CENTER;
 AlignIndicatorTable[PopupUtils.MiddleAlignIndicator] = PositionAlignConsts.CENTER;
 AlignIndicatorTable[PopupUtils.RightSidesAlignIndicator] = PositionAlignConsts.INNER_END;
 AlignIndicatorTable[PopupUtils.BottomSidesAlignIndicator] = PositionAlignConsts.INNER_END;
 AlignIndicatorTable[PopupUtils.RightAlignIndicator] = PositionAlignConsts.NEAR_BOUND_END;
 AlignIndicatorTable[PopupUtils.BottomAlignIndicator] = PositionAlignConsts.NEAR_BOUND_END;
 AlignIndicatorTable[PopupUtils.OutsideRightAlignIndicator] = PositionAlignConsts.OUTSIDE_END;
 AlignIndicatorTable[PopupUtils.BelowAlignIndicator] = PositionAlignConsts.OUTSIDE_END;
 AlignIndicatorTable[PopupUtils.WindowCenterAlignIndicator] = PositionAlignConsts.WINDOW_CENTER;
 AlignIndicatorTable[PopupUtils.WindowLeftAlignIndicator] = PositionAlignConsts.WINDOW_START;
 AlignIndicatorTable[PopupUtils.WindowTopAlignIndicator] = PositionAlignConsts.WINDOW_START;
 AlignIndicatorTable[PopupUtils.WindowRightAlignIndicator] = PositionAlignConsts.WINDOW_END;
 AlignIndicatorTable[PopupUtils.WindowBottomAlignIndicator] = PositionAlignConsts.WINDOW_END;
}
initializeAlignIndicatorTable();
ASPx.PopupPosition = function(position, isInverted) {
 this.position = position;
 this.isInverted = isInverted;
}
ASPx.PopupSize = function(width, height) {
 this.width = width;
 this.height = height;
}
ASPx.PopupUtils = PopupUtils;
})();
(function(){
 ScrollingManager = ASPx.CreateClass(null, {
  constructor: function(owner, scrollableArea, orientation, onBeforeScrolling, onAfterScrolling, forseEmulation) {
   this.owner = owner;
   this.scrollableArea = scrollableArea;
   this.orientation = orientation;
   this.animationDelay = 1;
   this.animationStep = 2;
   this.animationOffset = 5;
   this.animationAcceleration = 0;
   this.scrollSessionInterval = 10;
   this.stopScrolling = true;
   this.busy = false;
   this.currentAcceleration = 0;
   this.startPos;
   this.onBeforeScrolling = onBeforeScrolling;
   this.onAfterScrolling = onAfterScrolling;
   this.emulationMode = forseEmulation === true || !ASPx.Browser.TouchUI; 
   this.Initialize();
  },
  Initialize: function(){
   this.setParentNodeOverflow();
   if(this.emulationMode){
    this.wrapper = new ScrollingManager.scrollWrapper(this.scrollableArea);
   } else {
    this.wrapper = new ScrollingManager.scrollWrapperTouchUI(this.scrollableArea, function(direction){
     if(this.onAfterScrolling)
      this.onAfterScrolling(this, direction);
    }.aspxBind(this)); 
   }
  },
  setParentNodeOverflow: function() {
   if(ASPx.Browser.MSTouchUI){
    this.scrollableArea.parentNode.style.overflow = "auto";
    this.scrollableArea.parentNode.style["-ms-overflow-style"] = "-ms-autohiding-scrollbar";
   } 
  },
  GetScrolledAreaPosition: function() {
   return this.wrapper.GetScrollLeft() * this.orientation[0]
    + this.wrapper.GetScrollTop() * this.orientation[1];
  },
  SetScrolledAreaPosition: function(pos) {
   this.wrapper.SetScrollLeft(pos * this.orientation[0]);
   this.wrapper.SetScrollTop(pos * this.orientation[1]);
  },
  PrepareForScrollAnimation: function() {
   if(!this.scrollableArea)
    return;  
   this.currentAcceleration = 0;
   this.startPos = this.GetScrolledAreaPosition();
   this.busy = false;
  },
  GetAnimationStep: function(dir) {
   var step = dir * (this.animationStep + this.currentAcceleration);
   var newPos = this.GetScrolledAreaPosition() + step;
   var requiredPos = this.startPos + dir * this.animationOffset;
   if((dir == 1 && newPos >= requiredPos) || (dir == -1 && newPos <= requiredPos)) {
    step = requiredPos - this.GetScrolledAreaPosition();
   } 
   return step;
  },
  DoScrollSessionAnimation: function(direction) {
   if(!this.scrollableArea)
    return;
   this.SetScrolledAreaPosition(this.GetScrolledAreaPosition() + this.GetAnimationStep(direction));
   var self = this;
   if(!this.ShouldStopScrollSessionAnimation()) {
    this.busy = true;
    this.currentAcceleration += this.animationAcceleration;
    window.setTimeout(function() { self.DoScrollSessionAnimation(direction); }, this.animationDelay);
   } else {
    if(this.onAfterScrolling)
     this.onAfterScrolling(this, -direction);   
    this.busy = false;
    this.currentAcceleration = 0;
    window.setTimeout(function() { self.DoScroll(direction); }, this.scrollSessionInterval);
   }
  },
  ShouldStopScrollSessionAnimation: function() {
   return (Math.abs(this.GetScrolledAreaPosition() - this.startPos) >= Math.abs(this.animationOffset));
  },
  DoScroll: function(direction) {
   if(!this.scrollableArea)
    return; 
   if(!this.busy && !this.stopScrolling) {
    if(this.onBeforeScrolling)
     this.onBeforeScrolling(this, -direction);
    if(this.stopScrolling) return;
    this.PrepareForScrollAnimation();
    this.DoScrollSessionAnimation(direction);
   } 
  },
  StartScrolling: function(direction, delay, step) {
   this.stopScrolling = false;
   this.animationDelay = delay;
   this.animationStep = step;
   this.DoScroll(-direction);
  },
  StopScrolling: function() {
   this.stopScrolling = true;
  },
  IsStopped: function() {
   return this.stopScrolling;
  }
 });
 ScrollingManager.scrollWrapper = function(scrollableArea){
  this.scrollableArea = scrollableArea;
  this.Initialize();
 };
 ScrollingManager.scrollWrapper.prototype = {
  Initialize: function(){
   this.scrollableArea.style.position = "relative";
   this.scrollableArea.parentNode.style.position = "relative";
  },
  GetScrollLeft: function(){ return ASPx.PxToFloat(this.scrollableArea.style.left); },
  GetScrollTop:  function(){ return ASPx.PxToFloat(this.scrollableArea.style.top); },
  SetScrollLeft: function(value){ this.scrollableArea.style.left = value + "px"; },
  SetScrollTop:  function(value){ this.scrollableArea.style.top  = value + "px"; }
 };
 ScrollingManager.scrollWrapperTouchUI = function(scrollableArea, onScroll){
  this.scrollableArea = scrollableArea;
  this.scrollTimerId = -1;
  this.onScroll = onScroll;
  this.Initialize(onScroll);
 };
 ScrollingManager.scrollWrapperTouchUI.prototype = {
  Initialize: function(){
   var div = this.scrollableArea.parentNode;
   var timeout = ASPx.Browser.MSTouchUI ? 500 : 1000;
   var nativeScrollSupported = ASPx.TouchUIHelper.nativeScrollingSupported();
   this.onScrollCore = function(){
     ASPx.Timer.ClearTimer(this.scrollTimerId);
     if(this.onScrollLocked) return;
     this.scrollTimerId = window.setTimeout(this.onScrollByTimer, timeout);
    }.aspxBind(this);
   this.onScrollByTimer = function(){
     if(this.onScrollLocked) return;
     var direction = this.lastScrollTop < div.scrollTop ? 1 : -1;
     this.lastScrollTop = div.scrollTop;
     this.onScrollLocked = true;
     this.onScroll(direction);
     this.onScrollLocked = false;
    }.aspxBind(this);
   this.lastScrollTop = div.scrollTop;
   var onscroll = nativeScrollSupported ? this.onScrollCore : this.onScrollByTimer;
   ASPx.Evt.AttachEventToElement(div, "scroll", onscroll);
   if(ASPx.Browser.WebKitTouchUI)
    this.scrollExtender = ASPx.TouchUIHelper.MakeScrollable(div, {showHorizontalScrollbar: false});
  },
  GetScrollLeft: function(){ return -this.scrollableArea.parentNode.scrollLeft; },
  GetScrollTop:  function(){ return -this.scrollableArea.parentNode.scrollTop; },
  SetScrollLeft: function(value){ 
   this.onScrollLocked = true;
   this.scrollableArea.parentNode.scrollLeft = -value; 
   this.onScrollLocked = false;
  },
  SetScrollTop:  function(value){ 
   this.onScrollLocked = true;
   this.scrollableArea.parentNode.scrollTop  = -value; 
   this.onScrollLocked = false;
  }
 };
 ASPx.ScrollingManager = ScrollingManager;
})();
(function() {
var Constants = {
 MIIdSuffix: "_DXI",
 MMIdSuffix: "_DXM",
 SBIdSuffix: "_DXSB",
 SBUIdEnd: "_U",
 SBDIdEnd: "_D",
 ATSIdSuffix: "_ATS",
 SampleCssClassNameForImageElement: "SAMPLE_CSS_CLASS"
}
var MenuItemInfo = ASPx.CreateClass(null, {
 constructor: function(menu, indexPath) {
  var itemElement = menu.GetItemElement(indexPath);
  this.clientHeight = itemElement.clientHeight;
  this.clientWidth = itemElement.clientWidth;
  this.clientTop = ASPx.GetClientTop(itemElement);
  this.clientLeft = ASPx.GetClientLeft(itemElement);
  this.offsetHeight = itemElement.offsetHeight;
  this.offsetWidth = itemElement.offsetWidth;
  this.offsetTop = 0;
  this.offsetLeft = 0;
 }
});
var MenuCssClasses = {};
MenuCssClasses.Prefix = "dxm-";
MenuCssClasses.Menu = "dxmLite";
MenuCssClasses.BorderCorrector = "dxmBrdCor";
MenuCssClasses.Disabled = MenuCssClasses.Prefix + "disabled";
MenuCssClasses.MainMenu = MenuCssClasses.Prefix + "main";
MenuCssClasses.PopupMenu = MenuCssClasses.Prefix + "popup";
MenuCssClasses.HorizontalMenu = MenuCssClasses.Prefix + "horizontal";
MenuCssClasses.VerticalMenu = MenuCssClasses.Prefix + "vertical";
MenuCssClasses.NoWrapMenu = MenuCssClasses.Prefix + "noWrap";
MenuCssClasses.AutoWidthMenu = MenuCssClasses.Prefix + "autoWidth";
MenuCssClasses.DX = "dx";
MenuCssClasses.Separator = MenuCssClasses.Prefix + "separator";
MenuCssClasses.Spacing = MenuCssClasses.Prefix + "spacing";
MenuCssClasses.Gutter = MenuCssClasses.Prefix + "gutter";
MenuCssClasses.WithoutImages = MenuCssClasses.Prefix + "noImages";
MenuCssClasses.Item = MenuCssClasses.Prefix + "item";
MenuCssClasses.ItemHovered = MenuCssClasses.Prefix + "hovered";
MenuCssClasses.ItemSelected = MenuCssClasses.Prefix + "selected";
MenuCssClasses.ItemChecked = MenuCssClasses.Prefix + "checked";
MenuCssClasses.ItemWithoutImage = MenuCssClasses.Prefix + "noImage";
MenuCssClasses.ItemWithSubMenu = MenuCssClasses.Prefix + "subMenu";
MenuCssClasses.ItemDropDownMode = MenuCssClasses.Prefix + "dropDownMode";
MenuCssClasses.ItemWithoutSubMenu = MenuCssClasses.Prefix + "noSubMenu"; 
MenuCssClasses.AdaptiveMenuItem = MenuCssClasses.Prefix + "ami";
MenuCssClasses.AdaptiveMenuItemSpacing = MenuCssClasses.Prefix + "amis";
MenuCssClasses.AdaptiveMenu = MenuCssClasses.Prefix + "am";
MenuCssClasses.AdaptiveMenuHiddenElement = MenuCssClasses.Prefix + "amhe";
MenuCssClasses.ContentContainer = MenuCssClasses.Prefix + "content";
MenuCssClasses.Image = MenuCssClasses.Prefix + "image";
MenuCssClasses.PopOutContainer = MenuCssClasses.Prefix + "popOut";
MenuCssClasses.PopOutImage = MenuCssClasses.Prefix + "pImage";
MenuCssClasses.ImageLeft = MenuCssClasses.Prefix + "image-l";
MenuCssClasses.ImageRight = MenuCssClasses.Prefix + "image-r";
MenuCssClasses.ImageTop = MenuCssClasses.Prefix + "image-t";
MenuCssClasses.ImageBottom = MenuCssClasses.Prefix + "image-b";
MenuCssClasses.ScrollArea = MenuCssClasses.Prefix + "scrollArea";
MenuCssClasses.ScrollUpButton = MenuCssClasses.Prefix + "scrollUpBtn";
MenuCssClasses.ScrollDownButton = MenuCssClasses.Prefix + "scrollDownBtn";
MenuCssClasses.ItemClearElement = MenuCssClasses.DX + "-clear";
MenuCssClasses.ItemTextElement = MenuCssClasses.DX + "-vam";
var MenuRenderHelper = {};
MenuRenderHelper.InlineInitializeElements = function(menu) {
 if(!menu.isPopupMenu)
  this.InlineInitializeMainMenuElements(menu, menu.GetMainElement());
 var commonContainer = menu.GetMainElement().parentNode;
 var subMenuElements = ASPx.GetChildNodesByTagName(commonContainer, "DIV");
 for(var i = 0; i < subMenuElements.length; i++) {
  if(!menu.isPopupMenu && subMenuElements[i] == menu.GetMainElement())
   continue;
  this.InlineInitializeSubMenuElements(menu, subMenuElements[i]);
 }
};
MenuRenderHelper.InlineInitializeScrollElements = function(menu, indexPath, menuElement) {
 var scrollArea = ASPx.GetNodeByClassName(menuElement, MenuCssClasses.ScrollArea);
 if(scrollArea) scrollArea.id = menu.GetScrollAreaId(indexPath);
 var scrollUpButton = ASPx.GetNodeByClassName(menuElement, MenuCssClasses.ScrollUpButton);
 if(scrollUpButton) scrollUpButton.id = menu.GetScrollUpButtonId(indexPath);
 var scrollDownButton = ASPx.GetNodeByClassName(menuElement, MenuCssClasses.ScrollDownButton);
 if(scrollDownButton) scrollDownButton.id = menu.GetScrollDownButtonId(indexPath);
};
MenuRenderHelper.InlineInitializeMainMenuElements = function(menu, menuElement) {
 menu.CheckElementsCache(menuElement);
 var contentElement = this.GetContentElement(menuElement);
 if(contentElement.className.indexOf("dxm-ti") > 1)
  menu.itemLinkMode = "TextAndImage";
 else if(contentElement.className.indexOf("dxm-t") > -1)
  menu.itemLinkMode = "TextOnly";
 var itemElements = this.GetItemElements(menuElement);
 for(var i = 0; i < itemElements.length; i++)
  this.InlineInitializeItemElement(menu, itemElements[i], "", i);
 this.InlineInitializeScrollElements(menu, "", menuElement);
};
MenuRenderHelper.InlineInitializeSubMenuElements = function(menu, parentElement) {
 parentElement.style.position = "absolute";
 var indexPath = menu.GetMenuIndexPathById(parentElement.id);
 var borderCorrectorElement = ASPx.GetNodeByClassName(parentElement, MenuCssClasses.BorderCorrector);
 if(borderCorrectorElement != null) {
  borderCorrectorElement.id = menu.GetMenuBorderCorrectorElementId(indexPath);
  borderCorrectorElement.style.position = "absolute";
  parentElement.removeChild(borderCorrectorElement);
  parentElement.parentNode.appendChild(borderCorrectorElement);
 }
 this.InlineInitializeSubMenuMenuElement(menu, parentElement);
};
MenuRenderHelper.InlineInitializeSubMenuMenuElement = function(menu, parentElement) {
 var menuElement = ASPx.GetNodeByClassName(parentElement, MenuCssClasses.PopupMenu);
 var indexPath = menu.GetMenuIndexPathById(parentElement.id);
 menuElement.id = menu.GetMenuMainElementId(indexPath);
 menu.CheckElementsCache(menuElement);
 var contentElement = this.GetContentElement(menuElement);
 if(contentElement != null) {
  var itemElements = this.GetItemElements(menuElement);
  var parentIndexPath = parentElement == menu.GetMainElement() ? "" : indexPath;
  for(var i = 0; i < itemElements.length; i++) {
   var itemElementId = itemElements[i].id;
   if(itemElementId && aspxGetMenuCollection().GetMenu(itemElementId) != menu)
    continue;
   this.InlineInitializeItemElement(menu, itemElements[i], parentIndexPath, i);
  }
 }
 this.InlineInitializeScrollElements(menu, indexPath, menuElement);
};
MenuRenderHelper.HasSubMenuTemplate = function(menuElement) {
 var contentElement = this.GetContentElement(menuElement);
 return contentElement && (contentElement.tagName != "UL" || !ASPx.GetNodesByPartialClassName(contentElement, MenuCssClasses.ContentContainer).length);
};
MenuRenderHelper.InlineInitializeItemElement = function(menu, itemElement, parentIndexPath, visibleIndex) {
 function getItemIndex(visibleIndex) {
  var itemData = parentItemData[Math.max(visibleIndex, 0)];
  return itemData.constructor == Array
   ? itemData[0]
   : itemData;
 }
 var parentItemData = menu.renderData[parentIndexPath],
  prepareItemOnClick = parentItemData[visibleIndex].constructor == Array,
  indexPathPrefix = parentIndexPath + (parentIndexPath != "" ? ASPx.ItemIndexSeparator : ""),
  indexPath = indexPathPrefix + getItemIndex(visibleIndex),
  prevIndexPath = indexPathPrefix + getItemIndex(visibleIndex - 1);
 itemElement.id = menu.GetItemElementId(indexPath);
 ASPx.AssignAccessibilityEventsToChildrenLinks(itemElement);
 var separatorElement = itemElement.previousSibling;
 if(separatorElement && separatorElement.className) {
  if(ASPx.ElementContainsCssClass(separatorElement, MenuCssClasses.Spacing))
   separatorElement.id = menu.GetItemIndentElementId(indexPath);
  else if(ASPx.ElementContainsCssClass(separatorElement, MenuCssClasses.Separator))
   separatorElement.id = menu.GetItemSeparatorElementId(indexPath);
 }
 var contentElement = this.GetItemContentElement(itemElement);
 if(contentElement != null) {
  contentElement.id = menu.GetItemContentElementId(indexPath);
  var imageElement = ASPx.GetNodeByClassName(contentElement, MenuCssClasses.Image);
  if(imageElement == null) {
   var hyperLinkElement = ASPx.GetNodeByClassName(contentElement, MenuCssClasses.DX);
   if(hyperLinkElement != null)
    imageElement = ASPx.GetNodeByClassName(hyperLinkElement, MenuCssClasses.Image);
  }
  if(imageElement != null)
   imageElement.id = menu.GetItemImageId(indexPath);
 }
 else
  prepareItemOnClick = false;
 var popOutElement = this.GetItemPopOutElement(itemElement);
 if(popOutElement != null) {
  popOutElement.id = menu.GetItemPopOutElementId(indexPath);
  var popOutImageElement = ASPx.GetNodeByClassName(popOutElement, MenuCssClasses.PopOutImage);
  if(popOutImageElement != null)
   popOutImageElement.id = menu.GetItemPopOutImageId(indexPath);
 }
 if(prepareItemOnClick)
  this.InlineInitializeItemOnClick(menu, itemElement, indexPath);
};
MenuRenderHelper.InlineInitializeItemOnClick = function(menu, itemElement, indexPath) {
 var name = menu.name;
 var onclick = this.GetItemOnClick(menu, name, itemElement, indexPath);
 var assignElementOnClick = function(element, method) {
  switch(menu.itemLinkMode){
   case "ContentBounds":
    ASPx.Evt.AttachEventToElement(element, "click", method);
    break;
   case "TextOnly":
    var textElement = ASPx.GetNodeByTagName(element, "A");
    if(!textElement)
     textElement = ASPx.GetNodeByTagName(element, "SPAN");
    if(textElement)
     ASPx.Evt.AttachEventToElement(textElement, "click", method);
    break;
   case "TextAndImage":
    var linkElement = ASPx.GetNodeByTagName(element, "A");
    if(linkElement)
     ASPx.Evt.AttachEventToElement(linkElement, "click", method);
    else{
     var textElement = ASPx.GetNodeByTagName(element, "SPAN");
     if(textElement)
      ASPx.Evt.AttachEventToElement(textElement, "click", method);
     var imageElement = ASPx.GetNodeByTagName(element, "IMG");
     if(imageElement)
      ASPx.Evt.AttachEventToElement(imageElement, "click", method);
    }
    break;
  }
 };
 if(menu.IsDropDownItem(indexPath)) {
  var contentElement = menu.GetItemContentElement(indexPath);
  var dropDownElement = menu.GetItemPopOutElement(indexPath);
  var dropDownOnclick = this.GetItemDropdownOnClick(name, itemElement, indexPath);
  assignElementOnClick(contentElement, onclick);
  assignElementOnClick(dropDownElement, dropDownOnclick);
 }
 else
  assignElementOnClick(itemElement, onclick);
};
MenuRenderHelper.GetItemOnClick = function(menu, name, itemElement, indexPath) { 
 var sendPostBackHandler = function() {
  menu.SendPostBack("CLICK:" + indexPath);
 };
 var itemClickHandler = function(e) {
  ASPx.MIClick(e, name, indexPath);
 };
 var handler = menu.autoPostBack && !menu.IsClientSideEventsAssigned() && !ASPx.GetNodeByTagName(itemElement, "A")
  ? sendPostBackHandler
  : itemClickHandler;
 return function(e) {
  if(!itemElement.clientDisabled)
   handler(e);
 };
};
MenuRenderHelper.GetItemDropdownOnClick = function(name, itemElement, indexPath) {
 return function(e) {
  if(!itemElement.clientDisabled)
   ASPx.MIDDClick(e, name, indexPath);
 };
};
MenuRenderHelper.ChangeItemEnabledAttributes = function(itemElement, enabled, accessibilityCompliant) {
 if(!itemElement) return;
 itemElement.clientDisabled = !enabled;
 ASPx.Attr.ChangeStyleAttributesMethod(enabled)(itemElement, "cursor");
 var hyperLink = ASPx.GetNodeByTagName(itemElement, "A");
 if(hyperLink) {
  if(accessibilityCompliant) {
   var action = enabled ? ASPx.Attr.RemoveAttribute : ASPx.Attr.SetAttribute;
   action(hyperLink, "aria-disabled", "true");
  }
  ASPx.Attr.ChangeAttributesMethod(enabled)(hyperLink, "href");
  if(accessibilityCompliant && !enabled && itemElement.enabled)
   hyperLink.href = ASPx.AccessibilityEmptyUrl;
 }
};
MenuRenderHelper.GetContentElement = function(menuElement) {
 return ASPx.CacheHelper.GetCachedElement(this, "contentElement", 
  function() {
   var contentElement = ASPx.GetNodeByTagName(menuElement, "DIV", 0);
   if(contentElement && contentElement.className == MenuCssClasses.DX && contentElement.parentNode == menuElement) 
    return contentElement;
   contentElement = ASPx.GetNodeByTagName(menuElement, "UL", 0);
   if(contentElement)
    return contentElement;
   return ASPx.GetNodeByTagName(menuElement, "TABLE", 0); 
  }, menuElement);
};
MenuRenderHelper.GetItemElements = function(menuElement) {
 return ASPx.CacheHelper.GetCachedElements(this, "itemElements", 
  function() {
   var contentElement = this.GetContentElement(menuElement);
   return contentElement ? ASPx.GetNodesByClassName(contentElement, MenuCssClasses.Item) : null;
  }, menuElement);
};
MenuRenderHelper.GetSpacingElements = function(menuElement) {
 return ASPx.CacheHelper.GetCachedElements(this, "spacingElements", 
  function() {
   var contentElement = this.GetContentElement(menuElement);
   return contentElement ? ASPx.GetNodesByClassName(contentElement, MenuCssClasses.Spacing) : null;
  }, menuElement);
};
MenuRenderHelper.GetSeparatorElements = function(menuElement) {
 return ASPx.CacheHelper.GetCachedElements(this, "separatorElements", 
  function() {
   var contentElement = this.GetContentElement(menuElement);
   return contentElement ? ASPx.GetNodesByClassName(contentElement, MenuCssClasses.Separator) : null;
  }, menuElement);
};
MenuRenderHelper.GetItemContentElement = function(itemElement) {
 return ASPx.CacheHelper.GetCachedElement(this, "contentElement", 
  function() {
   return ASPx.GetNodeByClassName(itemElement, MenuCssClasses.ContentContainer);
  }, itemElement);
};
MenuRenderHelper.GetItemPopOutElement = function(itemElement) {
 return ASPx.CacheHelper.GetCachedElement(this, "popOutElement", 
  function() {
   return ASPx.GetNodeByClassName(itemElement, MenuCssClasses.PopOutContainer);
  }, itemElement);
};
MenuRenderHelper.GetAdaptiveMenuItemElement = function(menuElement) {
 return ASPx.CacheHelper.GetCachedElement(this, "adaptiveMenuItemElement", 
  function() {
   var contentElement = this.GetContentElement(menuElement);
   return contentElement ? ASPx.GetNodeByClassName(contentElement, MenuCssClasses.AdaptiveMenuItem) : null;
  }, menuElement);
};
MenuRenderHelper.GetAdaptiveMenuItemSpacingElement = function(menuElement) {
 return ASPx.CacheHelper.GetCachedElement(this, "adaptiveMenuItemSpacingElement", 
  function() {
   var contentElement = this.GetContentElement(menuElement);
   return contentElement ? ASPx.GetNodeByClassName(contentElement, MenuCssClasses.AdaptiveMenuItemSpacing) : null;
  }, menuElement);
};
MenuRenderHelper.GetAdaptiveMenuElement = function(menu, menuElement) {
 return ASPx.CacheHelper.GetCachedElement(this, "adaptiveMenuElement", 
  function() {
   var adaptiveItemElement = this.GetAdaptiveMenuItemElement(menuElement);
   if(adaptiveItemElement){
    var adaptiveItemIndexPath = menu.GetIndexPathById(adaptiveItemElement.id);
    var adaptiveMenuParentElement = menu.GetMenuElement(adaptiveItemIndexPath);
    if(adaptiveMenuParentElement) 
     return menu.GetMenuMainElement(adaptiveMenuParentElement);
   }
   return null;
  }, menuElement);
};
MenuRenderHelper.GetAdaptiveMenuContentElement = function(menu, menuElement) {
 return ASPx.CacheHelper.GetCachedElement(this, "adaptiveMenuContentElement", 
  function() {
   var adaptiveMenuElement = this.GetAdaptiveMenuElement(menu, menuElement);
   return adaptiveMenuElement ? this.GetContentElement(adaptiveMenuElement) : null;
  }, menuElement);
};
MenuRenderHelper.CalculateMenuControl = function(menu, menuElement, recalculate) {
 if(menuElement.offsetWidth === 0) return;
 this.PrecalculateMenuPopOuts(menuElement);
 var isVertical = menu.IsVertical("");
 var isAutoWidth = ASPx.ElementContainsCssClass(menuElement, MenuCssClasses.AutoWidthMenu);
 var isNoWrap = ASPx.ElementContainsCssClass(menuElement, MenuCssClasses.NoWrapMenu);
 var contentElement = this.GetContentElement(menuElement);
 if(menu.enableAdaptivity) 
  this.CalculateAdaptiveMainMenu(menu, menuElement, contentElement, isVertical, isAutoWidth, isNoWrap, recalculate);
 else
  this.CalculateMainMenu(menu, menuElement, contentElement, isVertical, isAutoWidth, isNoWrap, recalculate);
};
MenuRenderHelper.CalculateMainMenu = function(menu, menuElement, contentElement, isVertical, isAutoWidth, isNoWrap, recalculate) {
 var itemElements = this.GetItemElements(menuElement);
 this.PrecalculateMenuItems(menuElement, itemElements, recalculate);
 this.CalculateMenuItemsAutoWidth(menuElement, itemElements, isVertical, isAutoWidth);
 this.CalculateMinSize(menuElement, contentElement, itemElements, isVertical, isAutoWidth, isNoWrap, recalculate);
 this.CalculateMenuItems(menuElement, contentElement, itemElements, isVertical, recalculate);
 this.CalculateSeparatorsAndSpacers(menuElement, itemElements, contentElement, isVertical);
};
MenuRenderHelper.PrecalculateMenuPopOuts = function(menuElement) {
 if(menuElement.popOutsPreCalculated) return;
 var elements = this.GetItemElements(menuElement);
 for(var i = 0; i < elements.length; i++) {
  var popOutElement = this.GetItemPopOutElement(elements[i]);
  if(popOutElement) popOutElement.style.display = "block";
 }
 menuElement.popOutsPreCalculated = true;
};
MenuRenderHelper.PrecalculateMenuItems = function(menuElement, itemElements, recalculate) {
 if(!recalculate) return;
 for(var i = 0; i < itemElements.length; i++) {
  var itemContentElement = this.GetItemContentElement(itemElements[i]);
  if(!itemContentElement || itemContentElement.offsetWidth === 0) continue;
  ASPx.SetElementFloat(itemContentElement, "");
  ASPx.Attr.RestoreStyleAttribute(itemContentElement, "padding-left");
  ASPx.Attr.RestoreStyleAttribute(itemContentElement, "padding-right");
    this.ReCalculateMenuItemContent(itemElements[i], itemContentElement);
 }
};
MenuRenderHelper.ReCalculateMenuItemContent = function(itemElement, itemContentElement) {
 for(var j = 0; j < itemElement.childNodes.length; j++) {
  var child = itemElement.childNodes[j];
  if(!child.offsetWidth) continue;
  if(child !== itemContentElement) {
   if(ASPx.Browser.IE && ASPx.Browser.Version == 8)
    ASPx.Attr.RestoreStyleAttribute(child, "margin");
   else{
    ASPx.Attr.RestoreStyleAttribute(child, "margin-top");
    ASPx.Attr.RestoreStyleAttribute(child, "margin-bottom");
   }
  }
 }
};
MenuRenderHelper.CalculateMenuItemsAutoWidth = function(menuElement, itemElements, isVertical, isAutoWidth) {
 if(!isAutoWidth) return;
 for(var i = 0; i < itemElements.length; i++) 
  ASPx.Attr.RestoreStyleAttribute(itemElements[i], "width");
 if(!isVertical) {
  var autoWidthItemCount = 0;
  for(var i = 0; i < itemElements.length; i++) {
   if(ASPx.GetElementDisplay(itemElements[i]) && !ASPx.ElementHasCssClass(itemElements[i], MenuCssClasses.AdaptiveMenuItem))
    autoWidthItemCount++;
  }
  for(var i = 0; i < itemElements.length; i++) {
   if(autoWidthItemCount > 0 && !ASPx.ElementHasCssClass(itemElements[i], MenuCssClasses.AdaptiveMenuItem) && (itemElements[i].style.width === "" || itemElements[i].autoWidth)) { 
    ASPx.Attr.ChangeStyleAttribute(itemElements[i], "width", (100 / autoWidthItemCount) + "%");
    itemElements[i].autoWidth = true;
   }
  }
 }
};
MenuRenderHelper.CalculateMenuItems = function(menuElement, contentElement, itemElements, isVertical, recalculate) {
 if(contentElement.itemsCalculated && recalculate)
  contentElement.itemsCalculated = false;
 if(menuElement.offsetWidth === 0) return;
 if(contentElement.style.margin === "0px auto")
  ASPx.SetStyles(contentElement, { width: contentElement.offsetWidth, float: "none" }); 
 var menuWidth = ASPx.GetCurrentStyle(menuElement).width;
 var menuRequireItemCorrection = isVertical && menuWidth;
 for(var i = 0; i < itemElements.length; i++) {
  if(!itemElements[i].style.width && !menuRequireItemCorrection) continue;
  if(ASPx.IsPercentageSize(itemElements[i].style.width) && contentElement.style.width === "")
   contentElement.style.width = "100%"; 
  var itemContentElement = this.GetItemContentElement(itemElements[i]);
  if(!itemContentElement || itemContentElement.offsetWidth === 0) continue;
  if(!contentElement.itemsCalculated) {
   ASPx.Attr.RestoreStyleAttribute(itemContentElement, "padding-left");
   ASPx.Attr.RestoreStyleAttribute(itemContentElement, "padding-right");
   ASPx.SetElementFloat(itemContentElement, "none");
   var itemContentCurrentStyle = ASPx.GetCurrentStyle(itemContentElement);
   if(!isVertical || (itemContentCurrentStyle.textAlign != "center" && menuWidth)) {
    var originalPaddingLeft = parseInt(itemContentCurrentStyle.paddingLeft);
    var originalPaddingRight = parseInt(itemContentCurrentStyle.paddingRight);
    var leftChildrenWidth = 0, rightChildrenWidth = 0;
    for(var j = 0; j < itemElements[i].childNodes.length; j++) {
     var child = itemElements[i].childNodes[j];
     if(!child.offsetWidth) continue;
     if(child !== itemContentElement) {
      if(ASPx.GetElementFloat(child) === "right")
       rightChildrenWidth += child.offsetWidth + ASPx.GetLeftRightMargins(child);
      else if(ASPx.GetElementFloat(child) === "left")
       leftChildrenWidth += child.offsetWidth + ASPx.GetLeftRightMargins(child);
     }
    }
    if(leftChildrenWidth > 0 || rightChildrenWidth > 0){
     ASPx.Attr.ChangeStyleAttribute(itemContentElement, "padding-left", (leftChildrenWidth + originalPaddingLeft) + "px");
     ASPx.Attr.ChangeStyleAttribute(itemContentElement, "padding-right", (rightChildrenWidth + originalPaddingRight) + "px");
    }
   }
  }
  ASPx.AdjustWrappedTextInContainer(itemContentElement);
  this.CalculateMenuItemContent(itemElements[i], itemContentElement);
 }
 contentElement.itemsCalculated = true;
};
MenuRenderHelper.CalculateMenuItemContent = function(itemElement, itemContentElement) {
 var itemContentFound = false;
 for(var j = 0; j < itemElement.childNodes.length; j++) {
  var child = itemElement.childNodes[j];
  if(!child.offsetWidth) continue;
  var contentHeight = itemContentElement.offsetHeight;
  if(child !== itemContentElement) {
   if(itemContentFound){
    if(ASPx.Browser.IE && ASPx.Browser.Version == 8)
     ASPx.Attr.ChangeStyleAttribute(child, "margin", "-" + contentHeight + "px 0 0");
    else
     ASPx.Attr.ChangeStyleAttribute(child, "margin-top", "-" + contentHeight + "px");
   }
   else{
    if(ASPx.Browser.IE && ASPx.Browser.Version == 8)
     ASPx.Attr.ChangeStyleAttribute(child, "margin", "0 0 -" + contentHeight + "px");
    else
     ASPx.Attr.ChangeStyleAttribute(child, "margin-bottom", "-" + contentHeight + "px");
   }
  }
  else
   itemContentFound = true;
 }
};
MenuRenderHelper.CalculateSubMenu = function(menu, parentElement, recalculate) {
 var menuElement = menu.GetMenuMainElement(parentElement);
 var contentElement = this.GetContentElement(menuElement);
 if(!parentElement.isSubMenuCalculated || recalculate) {
  menuElement.style.width = "";
  menuElement.style.display = "table";
  menuElement.style.borderSpacing = "0px";
  parentElement.isSubMenuCalculated = true;
  if(contentElement.tagName === "UL") {
   if(contentElement.offsetWidth > 0) {
    if(ASPx.Browser.IE && ASPx.ElementHasCssClass(menuElement, MenuCssClasses.AdaptiveMenu))
     menuElement.style.width = "0px";
    menuElement.style.width = contentElement.offsetWidth + "px";
    menuElement.style.display = "";
    if(ASPx.IsPercentageSize(contentElement.style.width))
     contentElement.style.width = menuElement.style.width;
   }
   else
    parentElement.isSubMenuCalculated = false;
  }
 }
 this.CalculateSubMenuItems(menuElement, contentElement, recalculate);
};
MenuRenderHelper.CalculateSubMenuItems = function(menuElement, contentElement, recalculate) {
 var itemElements = this.GetItemElements(menuElement);
 this.PrecalculateMenuItems(menuElement, itemElements, recalculate);
 this.CalculateMenuItems(menuElement, contentElement, itemElements, true, recalculate);
};
MenuRenderHelper.CalculateMinSize = function(menuElement, contentElement, itemElements, isVertical, isAutoWidth, isNoWrap, recalculate) {
 if(menuElement.isMinSizeCalculated && !recalculate) return;
 if(isVertical) {
  menuElement.style.minWidth = "";
  ASPx.Attr.ChangeStyleAttribute(contentElement, "width", "1px");
  for(var i = 0; i < itemElements.length; i++) {
   var itemContentElement = this.GetItemContentElement(itemElements[i]);
   if(!itemContentElement || itemElements[i].offsetWidth === 0) continue;
   this.CalculateItemMinSize(itemElements[i], recalculate);
  }
  ASPx.Attr.RestoreStyleAttribute(contentElement, "width");
 }
 else {
  ASPx.RemoveClassNameFromElement(menuElement, MenuCssClasses.NoWrapMenu);
  ASPx.RemoveClassNameFromElement(menuElement, MenuCssClasses.AutoWidthMenu);
  ASPx.Attr.ChangeStyleAttribute(menuElement, "width", "1px");
  for(var i = 0; i < itemElements.length; i++) {
   var itemContentElement = this.GetItemContentElement(itemElements[i]);
   if(!itemContentElement || itemElements[i].offsetWidth === 0) continue;
   var textContainer = ASPx.GetNodeByTagName(itemContentElement, "SPAN", 0);
   if(textContainer && ASPx.GetCurrentStyle(textContainer).whiteSpace !== "nowrap")
    ASPx.AdjustWrappedTextInContainer(itemContentElement);
   this.CalculateItemMinSize(itemElements[i], recalculate);
  }
  if(isAutoWidth)
   ASPx.AddClassNameToElement(menuElement, MenuCssClasses.AutoWidthMenu);
  if(isNoWrap)
   ASPx.AddClassNameToElement(menuElement, MenuCssClasses.NoWrapMenu);
  if(isAutoWidth || isNoWrap)
   menuElement.style.minWidth = (contentElement.offsetWidth + ASPx.GetLeftRightBordersAndPaddingsSummaryValue(menuElement)) + "px";
  ASPx.Attr.RestoreStyleAttribute(menuElement, "width");
 }
 menuElement.isMinSizeCalculated = true;
};
MenuRenderHelper.CalculateItemMinSize = function(itemElement, recalculate) {
 if(itemElement.isMinSizeCalculated && !recalculate) return;
 var sizeCorrection = ASPx.Browser.HardwareAcceleration ? 1 : 0;
 itemElement.style.minWidth = "";
 var childrenWidth = 0;
 for(var j = 0; j < itemElement.childNodes.length; j++) {
  var child = itemElement.childNodes[j];
  if(!child.offsetWidth) continue;
  var float = ASPx.GetElementFloat(child);
  if(float === "none") {
   childrenWidth = child.offsetWidth;
   break;
  }
  else
   childrenWidth += child.offsetWidth + sizeCorrection;
 }
 itemElement.style.minWidth = childrenWidth + "px";
 itemElement.isMinSizeCalculated = true;
};
MenuRenderHelper.CalculateSeparatorsAndSpacers = function(menuElement, itemElements, contentElement, isVertical, isAutoWidth, isNoWrap) {
 var spacerElements = this.GetSpacingElements(menuElement);
 var spacerAndSeparatorElements = spacerElements.concat(this.GetSeparatorElements(menuElement));
 for(var i = 0; i < spacerAndSeparatorElements.length; i++)
  ASPx.Attr.RestoreStyleAttribute(spacerAndSeparatorElements[i], "height");
 if(!isVertical && itemElements) {
  var menuHeight = 0;
  if(!isAutoWidth && !isNoWrap) {
   for(var i=0; i < itemElements.length; i++) {
    var newHeight = itemElements[i].offsetHeight;
    if(newHeight > menuHeight)
     menuHeight = newHeight;
   }
  }
  for(var i = 0; i < spacerAndSeparatorElements.length; i++){
   var separatorHeight = menuHeight - ASPx.GetTopBottomBordersAndPaddingsSummaryValue(spacerAndSeparatorElements[i]) - ASPx.GetTopBottomMargins(spacerAndSeparatorElements[i]);
   ASPx.Attr.ChangeStyleAttribute(spacerAndSeparatorElements[i], "height", separatorHeight + "px");
  }
  for(var i = 0; i < spacerElements.length; i++){
   if(!ASPx.ElementContainsCssClass(spacerElements[i], MenuCssClasses.AdaptiveMenuItemSpacing))
    spacerElements[i].style.minWidth = spacerElements[i].style.width; 
  }
 }
};
MenuRenderHelper.CalculateAdaptiveMainMenu = function(menu, menuElement, contentElement, isVertical, isAutoWidth, isNoWrap, recalculate) {
 var adaptiveItemElement = this.GetAdaptiveMenuItemElement(menuElement);
 if(!adaptiveItemElement) return;
 var adaptiveItemSpacing = this.GetAdaptiveMenuItemSpacingElement(menuElement);
 if(adaptiveItemSpacing) adaptiveItemSpacing.style.width = "";
 var adaptiveMenuElement = this.GetAdaptiveMenuElement(menu, menuElement);
 if(!adaptiveMenuElement) return;
 var adaptiveMenuContentElement = this.GetAdaptiveMenuContentElement(menu, menuElement);
 if(!contentElement.adaptiveInfo)
  this.InitAdaptiveInfo(contentElement);
 var wasAdaptivity = contentElement.adaptiveInfo.hasAdaptivity;
 if(wasAdaptivity)
  this.RestoreAdaptiveItems(adaptiveItemSpacing || adaptiveItemElement, contentElement, isVertical);
 if(!isVertical) {
  ASPx.SetElementDisplay(adaptiveItemElement, true);
  if(adaptiveItemSpacing) ASPx.SetElementDisplay(adaptiveItemSpacing, true);
  ASPx.RemoveClassNameFromElement(menuElement, MenuCssClasses.NoWrapMenu);
  menuElement.style.minWidth = "";
  var menuWidth = menuElement.offsetWidth - ASPx.GetLeftRightBordersAndPaddingsSummaryValue(menuElement) - adaptiveItemElement.offsetWidth;
  if(adaptiveItemSpacing) menuWidth -= adaptiveItemSpacing.offsetWidth;
  var hasAdaptivity = this.HideAdaptiveItems(menu, menuWidth, contentElement, adaptiveMenuContentElement);
  contentElement.adaptiveInfo.hasAdaptivity = hasAdaptivity;
  ASPx.SetElementDisplay(adaptiveItemElement, hasAdaptivity);
  if(adaptiveItemSpacing) ASPx.SetElementDisplay(adaptiveItemSpacing, hasAdaptivity);
  contentElement.style.width = hasAdaptivity ? "100%" : "";
  if(hasAdaptivity){
   ASPx.CacheHelper.DropCache(adaptiveMenuElement);
   this.CalculateSubMenu(menu, adaptiveMenuElement, true);
   this.CalculateSeparatorsAndSpacers(adaptiveMenuElement, null, adaptiveMenuContentElement, true);
  }
  if(isNoWrap) {
   ASPx.AddClassNameToElement(menuElement, MenuCssClasses.NoWrapMenu);
   if(adaptiveItemSpacing) adaptiveItemSpacing.style.width = hasAdaptivity ? "100%" : "";
  }
 }
 else {
  ASPx.SetElementDisplay(adaptiveItemElement, false);
  if(adaptiveItemSpacing) ASPx.SetElementDisplay(adaptiveItemSpacing, false);
 }
 if(wasAdaptivity || contentElement.adaptiveInfo.hasAdaptivity)
  ASPx.CacheHelper.DropCache(menuElement);
 this.CalculateMainMenu(menu, menuElement, contentElement, isVertical, isAutoWidth, isNoWrap, wasAdaptivity || contentElement.adaptiveInfo.hasAdaptivity || recalculate);
};
MenuRenderHelper.InitAdaptiveInfo = function(contentElement) {
 if(contentElement.adaptiveInfo) return;
 contentElement.adaptiveInfo = { };
 contentElement.adaptiveInfo.elements = MenuRenderHelper.CreateAdaptiveElementsArray(contentElement);
 contentElement.adaptiveInfo.hasAdaptivity = false;
};
MenuRenderHelper.RestoreAdaptiveItems = function(previousSibling, contentElement, isVertical) {
 for(var i = 0; i < contentElement.adaptiveInfo.elements.length; i++) {
  var element = contentElement.adaptiveInfo.elements[i];
  if(ASPx.Browser.IE)
   ASPx.RemoveElement(element)
  contentElement.insertBefore(element, previousSibling);
  ASPx.Attr.RestoreStyleAttribute(element, "width");
  if(!isVertical)
   this.SetItemItemPopOutImageHorizontal(element);
  if(ASPx.ElementContainsCssClass(element, MenuCssClasses.Separator) || ASPx.ElementContainsCssClass(element, MenuCssClasses.Spacing))
   ASPx.RemoveClassNameFromElement(element, MenuCssClasses.AdaptiveMenuHiddenElement);
 }
};
MenuRenderHelper.CreateAdaptiveElementsArray = function(contentElement) {
 var result = [];
 var elements = ASPx.GetChildElementNodes(contentElement);
 for(var i = 0; i < elements.length; i++) {
  if(!ASPx.ElementHasCssClass(elements[i], MenuCssClasses.AdaptiveMenuItem) && !ASPx.ElementHasCssClass(elements[i], MenuCssClasses.AdaptiveMenuItemSpacing)) 
   result.push(elements[i]);
 }
 return result;
};
MenuRenderHelper.SetItemItemPopOutImageHorizontal = function(element) {
 var popOutElements = ASPx.GetNodesByPartialClassName(element, "dxWeb_mVerticalPopOut");
 for(var i = 0; i < popOutElements.length; i++)
  popOutElements[i].className = popOutElements[i].className.replace("Vertical", "Horizontal");
};
MenuRenderHelper.CheckAdaptiveItemsWidth = function(contentElement, width) {
 var itemsWidth = 0;
 var sizeCorrection = ASPx.Browser.HardwareAcceleration ? 1 : 0;
 var elements = ASPx.GetChildElementNodes(contentElement);
 for(var i = 0; i < elements.length; i++) {
  if(!ASPx.ElementHasCssClass(elements[i], MenuCssClasses.AdaptiveMenuItem) && 
   !ASPx.ElementHasCssClass(elements[i], MenuCssClasses.AdaptiveMenuItemSpacing) && elements[i].offsetWidth > 0) {
   if(elements[i].style.minWidth !== "")
    itemsWidth += parseInt(elements[i].style.minWidth) + ASPx.GetHorizontalBordersWidth(elements[i]);
   else
    itemsWidth += elements[i].offsetWidth;
  }
  if(itemsWidth > width)
   return false;
 }
 return true;
};
MenuRenderHelper.HideAdaptiveItems = function(menu, menuWidth, contentElement, adaptiveMenuContentElement) {
 if(MenuRenderHelper.CheckAdaptiveItemsWidth(contentElement, menuWidth))
  return false;
 var elementsToHide = [];
 var addToHide = function(index, itemElement, separatorElement, indentElement) {
  if(!itemElement) return;
  if(separatorElement && ASPx.ElementHasCssClass(separatorElement, MenuCssClasses.AdaptiveMenuItemSpacing))
   separatorElement = null;
  if(indentElement && ASPx.ElementHasCssClass(indentElement, MenuCssClasses.AdaptiveMenuItemSpacing))
   indentElement = null;
  elementsToHide[index] = { itemElement: itemElement, separatorElement: separatorElement, indentElement: indentElement };
  ASPx.Attr.ChangeStyleAttribute(itemElement, "display", "none");
  if(separatorElement)
   ASPx.Attr.ChangeStyleAttribute(separatorElement, "display", "none");
  if(indentElement)
   ASPx.Attr.ChangeStyleAttribute(indentElement, "display", "none");
 };
 for(var i = 0; i < menu.adaptiveItemsOrder.length; i++){
  var indexPath = menu.adaptiveItemsOrder[i];
  var index = parseInt(indexPath, 10);
  addToHide(index, menu.GetItemElement(indexPath), menu.GetItemSeparatorElement(indexPath), menu.GetItemIndentElement(indexPath));
  if(MenuRenderHelper.CheckAdaptiveItemsWidth(contentElement, menuWidth))
   break;
 }
 var hasImages = false;
 for(var i = 0; i < elementsToHide.length; i++) {
  if(!elementsToHide[i]) continue;
  ASPx.Attr.RestoreStyleAttribute(elementsToHide[i].itemElement, "display");
  if(elementsToHide[i].separatorElement)
   ASPx.Attr.RestoreStyleAttribute(elementsToHide[i].separatorElement, "display");
  if(elementsToHide[i].indentElement)
   ASPx.Attr.RestoreStyleAttribute(elementsToHide[i].indentElement, "display");
  if(elementsToHide[i].indentElement)
   adaptiveMenuContentElement.appendChild(elementsToHide[i].indentElement);
  if(elementsToHide[i].separatorElement)
   adaptiveMenuContentElement.appendChild(elementsToHide[i].separatorElement);
  adaptiveMenuContentElement.appendChild(elementsToHide[i].itemElement);
  ASPx.Attr.ChangeStyleAttribute(elementsToHide[i].itemElement, "width", "auto");
  if(ASPx.GetNodeByClassName(elementsToHide[i].itemElement, "dxm-image"))
   hasImages = true;
  this.SetItemPopOutImageVertical(elementsToHide[i].itemElement);
 }
 for(var i = 0; i < elementsToHide.length; i++) {
  if(!elementsToHide[i]) continue;
  if(elementsToHide[i].separatorElement) 
   ASPx.AddClassNameToElement(elementsToHide[i].separatorElement, MenuCssClasses.AdaptiveMenuHiddenElement);
  if(elementsToHide[i].indentElement) 
   ASPx.AddClassNameToElement(elementsToHide[i].indentElement, MenuCssClasses.AdaptiveMenuHiddenElement);
  break;
 }
 var elements = ASPx.GetChildElementNodes(contentElement);
 for(var i = 0; i < elements.length; i++) {
  if(ASPx.ElementContainsCssClass(elements[i], MenuCssClasses.Separator) || ASPx.ElementContainsCssClass(elements[i], MenuCssClasses.Spacing))
   ASPx.AddClassNameToElement(elements[i], MenuCssClasses.AdaptiveMenuHiddenElement);
  else
   break;
 }
 if(hasImages)
  ASPx.RemoveClassNameFromElement(adaptiveMenuContentElement, MenuCssClasses.WithoutImages);
 else
  ASPx.AddClassNameToElement(adaptiveMenuContentElement, MenuCssClasses.WithoutImages);
 return elementsToHide.length > 0;
};
MenuRenderHelper.SetItemPopOutImageVertical = function(element) {
 var popOutElements = ASPx.GetNodesByPartialClassName(element, "dxWeb_mHorizontalPopOut");
 for(var i = 0; i < popOutElements.length; i++)
  popOutElements[i].className = popOutElements[i].className.replace("Horizontal", "Vertical");
};
MenuRenderHelper.ChangeItemsPopOutImages = function(menuElement, isVertical) {
 var itemElements = this.GetItemElements(menuElement);
 for(var i = 0; i < itemElements.length; i++){
  if(isVertical)
   this.SetItemPopOutImageVertical(itemElements[i]);
  else
   this.SetItemItemPopOutImageHorizontal(itemElements[i]);
 }
};
MenuRenderHelper.ChangeOrientaion = function(isVertical, menu, menuElement) {
 var oldCssSelector = isVertical ? MenuCssClasses.HorizontalMenu : MenuCssClasses.VerticalMenu;
 var newCssSelector = isVertical ? MenuCssClasses.VerticalMenu : MenuCssClasses.HorizontalMenu;
 menuElement.className = menuElement.className.replace(oldCssSelector, newCssSelector);
 this.ChangeItemsPopOutImages(menuElement, isVertical);
 this.CalculateMenuControl(menu, menuElement, true);
 this.ChangeItemsPopOutImages(menuElement, isVertical);
};
var MenuScrollingManager = ASPx.CreateClass(ASPx.ScrollingManager, {
 constructor: function(menuScrollHelper) {
  this.constructor.prototype.constructor.call(this, menuScrollHelper, menuScrollHelper.scrollingAreaElement, [0, 1],
   function(manager, direction) {
    manager.owner.OnBeforeScrolling(direction);
   },
   function(manager, direction) {
    manager.owner.OnAfterScrolling(direction);
   }
  );
 },
 setParentNodeOverflow: function() { 
  if(ASPx.Browser.MSTouchUI) {
   this.scrollableArea.parentNode.style.overflow = "auto";
   this.scrollableArea.parentNode.style["-ms-overflow-style"] = "none";
  }  
 }
});
var MenuScrollHelper = ASPx.CreateClass(null, {
 constructor: function(menu, indexPath) {
  this.menu = menu;
  this.indexPath = indexPath;
  this.scrollingAreaElement = null;
  this.manager = null;
  this.initialized = false;
  this.visibleItems = [];
  this.itemsHeight = 0;
  this.scrollHeight = 0;
  this.scrollUpButtonHeight = 0;
  this.scrollDownButtonHeight = 0;
  this.scrollAreaHeight = null;
  this.scrollUpButtonVisible = false;
  this.scrollDownButtonVisible = false;
 },
 Initialize: function() {
  if(this.initialized) return;
  this.scrollingAreaElement = this.menu.GetScrollContentItemsContainer(this.indexPath);
  this.manager = new MenuScrollingManager(this);
  this.ShowScrollButtons();
  var scrollUpButton = this.menu.GetScrollUpButtonElement(this.indexPath);
  if(scrollUpButton) {
   this.scrollUpButtonHeight = this.GetScrollButtonHeight(scrollUpButton)
   ASPx.Selection.SetElementSelectionEnabled(scrollUpButton, false);
  }
  var scrollDownButton = this.menu.GetScrollDownButtonElement(this.indexPath);
  if(scrollDownButton) {
   this.scrollDownButtonHeight = this.GetScrollButtonHeight(scrollDownButton);
   ASPx.Selection.SetElementSelectionEnabled(scrollDownButton, false);
  }
  if(ASPx.Browser.WebKitTouchUI) {
   var preventDefault = function(event) { event.preventDefault(); };
   ASPx.Evt.AttachEventToElement(scrollUpButton, "touchstart", preventDefault);
   ASPx.Evt.AttachEventToElement(scrollDownButton, "touchstart", preventDefault);
  }
  this.HideScrollButtons();
  this.initialized = true;
 },
 GetScrollButtonHeight: function(button) {
  var style = ASPx.GetCurrentStyle(button);
  return button.offsetHeight + ASPx.PxToInt(style.marginTop) + ASPx.PxToInt(style.marginBottom);
 },
 FillVisibleItemsList: function() {
  var index = 0;
  this.visibleItems = [];
  while(true) {
   var childIndexPath = (this.indexPath != "" ? this.indexPath + ASPx.ItemIndexSeparator : "") + index;
   var itemElement = this.menu.GetItemElement(childIndexPath);
   if(itemElement == null)
    break;
   if(ASPx.GetElementDisplay(itemElement))
    this.visibleItems.push(itemElement);
   index++;
  }
 },
 CanCalculate: function() {
  return this.scrollingAreaElement && ASPx.IsElementDisplayed(this.scrollingAreaElement);
 },
 Calculate: function(scrollHeight) {
  if(!this.CanCalculate()) return;
  this.FillVisibleItemsList();
  this.itemsHeight = 0;
  this.scrollHeight = scrollHeight;
  var itemsContainer = this.menu.GetScrollContentItemsContainer(this.indexPath);
  if(itemsContainer) this.itemsHeight = itemsContainer.offsetHeight;
  this.SetPosition(0);
  this.CalculateScrollingElements(-1);
 },
 GetPosition: function() {
  return -this.manager.GetScrolledAreaPosition();
 },
 SetPosition: function(pos) {
  this.manager.SetScrolledAreaPosition(-pos);
 },
 CalculateScrollingElements: function(direction) {
  if(this.itemsHeight <= this.scrollHeight) {
   this.scrollUpButtonVisible = false;
   this.scrollDownButtonVisible = false;
   this.scrollAreaHeight = null;
   this.SetPosition(0);
  }
  else {
   var scrollTop = this.GetPosition();
   this.scrollAreaHeight = this.scrollHeight;
   if(direction > 0) {
    var showScrollUpButton = !this.scrollUpButtonVisible;
    this.scrollUpButtonVisible = true;
    this.scrollAreaHeight -= this.scrollUpButtonHeight;
    this.scrollDownButtonVisible = this.itemsHeight - this.scrollAreaHeight - scrollTop > this.scrollDownButtonHeight;
    if(this.scrollDownButtonVisible) {
     this.scrollAreaHeight -= this.scrollDownButtonHeight;
     if(showScrollUpButton)
      this.SetPosition(this.GetPosition() + this.scrollUpButtonHeight);
    }
    else {
     this.SetPosition(this.itemsHeight - this.scrollAreaHeight);
    }
   }
   else {
    this.scrollDownButtonVisible = true;
    this.scrollAreaHeight -= this.scrollDownButtonHeight;
    this.scrollUpButtonVisible = scrollTop > this.scrollUpButtonHeight;
    if(this.scrollUpButtonVisible)
     this.scrollAreaHeight -= this.scrollUpButtonHeight;
    else
     this.SetPosition(0);
   }
   if(this.scrollAreaHeight < 1) this.scrollAreaHeight = 1;
  }
  this.UpdateScrollingElements();
 },
 UpdateScrollingElements: function() {
  this.UpdateScrollAreaHeight();
  this.UpdateScrollButtonsVisibility();
 },
 UpdateScrollAreaHeight: function() {
  var scrollAreaElement = this.menu.GetScrollAreaElement(this.indexPath);
  if(scrollAreaElement)
   scrollAreaElement.style.height = (this.scrollAreaHeight) ? (this.scrollAreaHeight + "px") : "";
 },
 UpdateScrollButtonsVisibility: function() {
  var scrollUpButton = this.menu.GetScrollUpButtonElement(this.indexPath);
  if(scrollUpButton) ASPx.SetElementDisplay(scrollUpButton, this.scrollUpButtonVisible);
  var scrollDownButton = this.menu.GetScrollDownButtonElement(this.indexPath);
  if(scrollDownButton) ASPx.SetElementDisplay(scrollDownButton, this.scrollDownButtonVisible);
 },
 ChangeScrollButtonsVisibility: function(visible) {
  this.scrollUpButtonVisible = visible;
  this.scrollDownButtonVisible = visible;
  this.UpdateScrollButtonsVisibility();
 },
 ShowScrollButtons: function() {
  this.ChangeScrollButtonsVisibility(true);
 },
 HideScrollButtons: function() {
  this.ChangeScrollButtonsVisibility(false);
 },
 ResetScrolling: function() {
  if(!this.initialized)
   return;
  this.HideScrollButtons();
  this.SetPosition(0);
  this.scrollAreaHeight = null;
  this.UpdateScrollAreaHeight();
 },
 GetScrollAreaHeight: function() {
  var scrollAreaElement = this.menu.GetScrollAreaElement(this.indexPath);
  if(scrollAreaElement)
   return scrollAreaElement.offsetHeight;
  return 0;
 },
 OnAfterScrolling: function(direction) {
  this.CalculateScrollingElements(direction);
 },
 OnBeforeScrolling: function(direction) {
  var scrollButton = (direction > 0) ? this.menu.GetScrollDownButtonElement(this.indexPath) :
   this.menu.GetScrollUpButtonElement(this.indexPath);
  if(!scrollButton || !ASPx.GetElementDisplay(scrollButton))
   this.manager.StopScrolling();
 },
 StartScrolling: function(direction, delay, step) {
  this.manager.StartScrolling(direction, delay, step);
 },
 StopScrolling: function() {
  this.manager.StopScrolling();
 }
});
MenuScrollHelper.GetMenuByScrollButtonId = function(id) {
 var menuName = aspxGetMenuCollection().GetMenuNameBySuffixes(id, [Constants.SBIdSuffix]);
 return aspxGetMenuCollection().Get(menuName);
}
var ASPxClientMenuBase = ASPx.CreateClass(ASPxClientControl, {
 constructor: function(name) {
  this.constructor.prototype.constructor.call(this, name);
  this.renderData = null;
  this.rootMenuSample = null;
  this.sampleEmptyItemElement = null;
  this.sampleContentElement = null;
  this.sampleTextElementForItem = null;
  this.sampleImageElementForItem = null;
  this.sampleClearElement = null;
  this.samplePopOutElement = null;
  this.sampleSubMenuElement = null;
  this.sampleSpacingElement = null;
  this.sampleSeparatorElement = null;
  this.dropElementsCache = false;
  this.allowSelectItem = false;
  this.allowCheckItems = false;
  this.allowMultipleCallbacks = false;
  this.appearAfter = 300;
  this.slideAnimationDuration = 60;
  this.disappearAfter = 500;
  this.enableAnimation = true;
  this.enableAdaptivity = false;
  this.adaptiveItemsOrder = [];
  this.enableSubMenuFullWidth = false;
  this.checkedItems = [];
  this.isVertical = true;
  this.itemCheckedGroups = [];
  this.itemLinkMode = "ContentBounds";
  this.lockHoverEvents = false;
  this.popupToLeft = false;
  this.popupCount = 0;
  this.rootItem = null;
  this.showSubMenus = false;
  this.savedCallbackHoverItem = null;
  this.savedCallbackHoverElement = null;
  this.selectedItemIndexPath = "";
  this.checkedState = null;
  this.scrollInfo = [];
  this.scrollHelpers = {};
  this.scrollVertOffset = 1;
  this.keyboardHelper = null;
  this.isContextMenu = false;
  this.accessibleFocusElement = null;
  this.rootSubMenuFIXOffset = 0;
  this.rootSubMenuFIYOffset = 0;
  this.rootSubMenuLIXOffset = 0;
  this.rootSubMenuLIYOffset = 0;
  this.rootSubMenuXOffset = 0;
  this.rootSubMenuYOffset = 0;
  this.subMenuFIXOffset = 0;
  this.subMenuFIYOffset = 0;
  this.subMenuLIXOffset = 0;
  this.subMenuLIYOffset = 0;
  this.subMenuXOffset = 0;
  this.subMenuYOffset = 0;
  this.maxHorizontalOverlap = -3;
  this.sizingConfig.allowSetHeight = false;
  this.ItemClick = new ASPxClientEvent();
  this.ItemMouseOver = new ASPxClientEvent();
  this.ItemMouseOut = new ASPxClientEvent();
  this.PopUp = new ASPxClientEvent();
  this.CloseUp = new ASPxClientEvent();
  aspxGetMenuCollection().Add(this);
 },
 InitializeProperties: function(properties){
  if(properties.items)
   this.CreateItems(properties.items);
 },
 InlineInitialize: function() {
  ASPxClientControl.prototype.InlineInitialize.call(this);
  if(!this.NeedCreateItemsOnClientSide())
   MenuRenderHelper.InlineInitializeElements(this);
  this.InitializeInternal(true);
  if(this.IsCallbacksEnabled()) {
   this.showSubMenus = this.GetLoadingPanelElement() != null;
   this.CreateCallback("DXMENUCONTENT");
  }
  else
   this.showSubMenus = true;
  this.popupToLeft = this.rtl;
 },
 InitializeInternal: function(inline) {
  if(!this.NeedCreateItemsOnClientSide()) {
   this.InitializeCheckedItems();
   this.InitializeSelectedItem();
  }
  this.InitializeEnabledAndVisible(!inline || !this.IsCallbacksEnabled());
  if(!this.IsCallbacksEnabled())
   this.InitializeScrollableMenus();
  this.InitializeKeyboardHelper();
 },
 InitializeSampleMenuElement: function() {
  var wrapper = document.createElement("DIV");
  wrapper.innerHTML = this.sampleMenuHTML;
  return wrapper.childNodes[0];
 },
 InitializeMenuSamplesInternal: function(menuElement) {
  this.sampleSpacingElement = ASPx.GetNodeByClassName(menuElement, MenuCssClasses.Spacing, 0)
  this.sampleSeparatorElement = ASPx.GetNodeByClassName(menuElement, MenuCssClasses.Separator, 0);
 },
 InitializeEnabledAndVisible: function(recursive) {
  if(this.rootItem == null) return;
  for(var i = 0; i < this.rootItem.items.length; i++)
   this.rootItem.items[i].InitializeEnabledAndVisible(recursive);
 },
 InitializeScrollableMenus: function() {
  var info = eval(this.scrollInfo);
  this.scrollHelpers = {};
  for(var i = 0; i < info.length; i++)
   this.scrollHelpers[info[i]] = new MenuScrollHelper(this, info[i]);
 },
 InitializeKeyboardHelper: function() {
  this.keyboardHelper = new ASPxMenuKeyboardHelper(this);
 },
 InitializeItemSamples: function(itemsContainer) {
  this.sampleImageElementForItem =  ASPx.GetNodeByClassName(itemsContainer, MenuCssClasses.Image, 0);
  this.sampleTextElementForItem = ASPx.GetNodeByClassName(itemsContainer, MenuCssClasses.ItemTextElement, 0);
  this.sampleContentElement = ASPx.GetNodeByClassName(itemsContainer, MenuCssClasses.ContentContainer, 0);
  this.sampleContentElement.innerHTML = "";
  this.sampleClearElement  =  ASPx.GetNodeByClassName(itemsContainer, MenuCssClasses.ItemClearElement, 0);
  this.samplePopOutElement = ASPx.GetNodeByClassName(itemsContainer, MenuCssClasses.PopOutContainer, 0);
  this.sampleEmptyItemElement = ASPx.GetNodeByClassName(itemsContainer, MenuCssClasses.Item, 0);
  this.sampleEmptyItemElement.innerHTML = "";
 },
 InitializeSubMenuSample: function(subMenuElement) {
  ASPx.RemoveElement(ASPx.GetNodeByTagName(subMenuElement, "LI", 0));
  this.sampleSubMenuElement = subMenuElement;
 },
 CheckElementsCache: function(menuElement){
  if(this.dropElementsCache) {
   ASPx.CacheHelper.DropCache(menuElement);
   this.dropElementsCache = false;
  }
 },
 NeedCreateItemsOnClientSide: function() {
  return false;
 },
 IsClientSideEventsAssigned: function() {
  return !this.ItemClick.IsEmpty()
   || !this.ItemMouseOver.IsEmpty()
   || !this.ItemMouseOut.IsEmpty()
   || !this.PopUp.IsEmpty()
   || !this.CloseUp.IsEmpty()
   || !this.Init.IsEmpty();
 },
 IsCallbacksEnabled: function() {
  return ASPx.IsFunction(this.callBack);
 },
 ShouldHideExistingLoadingElements: function() {
  return false;
 },
 GetMenuElementId: function(indexPath) {
  return this.name + Constants.MMIdSuffix + indexPath + "_";
 },
 GetMenuMainElementId: function(indexPath) {
  return this.name + "_DXME" + indexPath + "_";
 },
 GetMenuBorderCorrectorElementId: function(indexPath) {
  return this.name + "_DXMBC" + indexPath + "_";
 },
 GetMenuIFrameElementId: function(indexPath) {
  return this.name + "_DXMIF" + this.GetMenuLevel(indexPath);
 },
 GetScrollAreaId: function(indexPath) {
  return this.name + "_DXSA" + indexPath;
 },
 GetMenuTemplateContainerID: function(indexPath) {
  return this.name + "_MTCNT" + indexPath;
 },
 GetItemTemplateContainerID: function(indexPath) {
  return this.name + "_ITCNT" + indexPath;
 },
 GetScrollUpButtonId: function(indexPath) {
  return this.name + Constants.SBIdSuffix + indexPath + Constants.SBUIdEnd;
 },
 GetScrollDownButtonId: function(indexPath) {
  return this.name + Constants.SBIdSuffix + indexPath + Constants.SBDIdEnd;
 },
 GetItemElementId: function(indexPath) {
  return this.name + Constants.MIIdSuffix + indexPath + "_";
 },
 GetItemContentElementId: function(indexPath) {
  return this.GetItemElementId(indexPath) + "T";
 },
 GetItemPopOutElementId: function(indexPath) {
  return this.GetItemElementId(indexPath) + "P";
 },
 GetItemImageId: function(indexPath) {
  return this.GetItemElementId(indexPath) + "Img";
 },
 GetItemPopOutImageId: function(indexPath) {
  return this.GetItemElementId(indexPath) + "PImg";
 },
 GetItemIndentElementId: function(indexPath) {
  return this.GetItemElementId(indexPath) + "II";
 },
 GetItemSeparatorElementId: function(indexPath) {
  return this.GetItemElementId(indexPath) + "IS";
 },
 GetMenuElement: function (indexPath) { 
  if(indexPath == "")
   return this.GetMainElement();
  return ASPx.CacheHelper.GetCachedElementById(this, this.GetMenuElementId(indexPath));
 },
 GetMenuIFrameElement: function(indexPath) {
  var elementId = this.GetMenuIFrameElementId(indexPath);
  var element = ASPx.GetElementById(elementId);
  if(!element && this.renderIFrameForPopupElements)
   return this.CreateIFrameElement(elementId);
  return element;
 },
 CreateIFrameElement: function(elementId) {
  var element = document.createElement("IFRAME");
  ASPx.Attr.SetAttribute(element, "id", elementId);
  ASPx.Attr.SetAttribute(element, "src", "javascript:false");
  ASPx.Attr.SetAttribute(element, "scrolling", "no");
  ASPx.Attr.SetAttribute(element, "frameborder", "0");
  if(ASPx.IsExists(ASPx.AccessibilitySR.AccessibilityIFrameTitle))
   ASPx.Attr.SetAttribute(element, "title", ASPx.AccessibilitySR.AccessibilityIFrameTitle);
  element.style.position = "absolute";
  element.style.display = "none";
  element.style.zIndex = "19997";
  element.style.filter = "progid:DXImageTransform.Microsoft.Alpha(Style=0, Opacity=0)";
  ASPx.InsertElementAfter(element, this.GetMainElement());
  return element;
 },
 GetMenuBorderCorrectorElement: function(indexPath) {
  return ASPx.CacheHelper.GetCachedElementById(this, this.GetMenuBorderCorrectorElementId(indexPath));
 },
 GetMenuMainElement: function(element) {
  var indexPath = this.GetIndexPathById(element.id, true);
  return ASPx.CacheHelper.GetCachedElement(this, "menuMainElement" + indexPath, 
   function() { 
    var shadowTable = ASPx.GetElementById(this.GetMenuMainElementId(indexPath));
    return shadowTable != null ? shadowTable : element;
   });
 },
 GetScrollAreaElement: function(indexPath) {
  return ASPx.CacheHelper.GetCachedElementById(this, this.GetScrollAreaId(indexPath));
 },
 GetScrollContentItemsContainer: function(indexPath) {
  return ASPx.CacheHelper.GetCachedElement(this, "scrollContentItemsContainer" + indexPath, 
   function() { 
    return ASPx.GetNodeByTagName(this.GetScrollAreaElement(indexPath), "UL", 0);
   });
 },
 GetScrollUpButtonElement: function(indexPath) {
  return ASPx.CacheHelper.GetCachedElementById(this, this.GetScrollUpButtonId(indexPath));
 },
 GetScrollDownButtonElement: function(indexPath) {
  return ASPx.CacheHelper.GetCachedElementById(this, this.GetScrollDownButtonId(indexPath));
 },
 GetItemElement: function(indexPath) {
  return ASPx.CacheHelper.GetCachedElementById(this, this.GetItemElementId(indexPath));
 },
 GetItemTemplateElement: function(indexPath) { 
  return this.GetItemTextTemplateContainer(indexPath);
 },
 GetItemTemplateContainer: function(indexPath) {
  return this.GetItemElement(indexPath);
 },
 GetItemTextTemplateContainer: function(indexPath) {
  return this.GetItemContentElement(indexPath);
 },
 GetItemContentElement: function(indexPath) {
  return ASPx.CacheHelper.GetCachedElementById(this, this.GetItemContentElementId(indexPath));
 },
 GetItemPopOutElement: function(indexPath) {
  return ASPx.CacheHelper.GetCachedElementById(this, this.GetItemPopOutElementId(indexPath));
 },
 GetPopOutElements: function() {
  return ASPx.GetNodesByClassName(this.GetMainElement().parentNode, "dxm-popOut");
 },
 GetPopOutImages: function() {
  return ASPx.GetNodesByClassName(this.GetMainElement().parentNode, "dxm-pImage");
 },
 GetSubMenuXPosition: function(indexPath, isVertical) {
  var itemElement = this.GetItemElement(indexPath);
  var pos = ASPx.GetAbsoluteX(itemElement) + (isVertical ? itemElement.clientWidth + itemElement.clientLeft : 0);
  if(ASPx.Browser.WebKitFamily && !this.IsParentElementPositionStatic(indexPath))
   pos -= document.body.offsetLeft;
  return pos;
 },
 GetSubMenuYPosition: function(indexPath, isVertical) {
  var position = 0;
  var element = this.GetItemElement(indexPath);
  if(element != null) {
   if(isVertical) {
    position = ASPx.GetAbsoluteY(element); 
   }
   else {
    if(ASPx.Browser.NetscapeFamily || ASPx.Browser.Opera && ASPx.Browser.Version >= 9 || ASPx.Browser.Safari && ASPx.Browser.Version >= 3 || ASPx.Browser.Chrome || ASPx.Browser.AndroidDefaultBrowser)
     position = ASPx.GetAbsoluteY(element) + element.offsetHeight - ASPx.GetClientTop(element);
    else if(ASPx.Browser.WebKitFamily)
     position = ASPx.GetAbsoluteY(element) + element.offsetHeight + element.offsetTop - ASPx.GetClientTop(element);
    else
     position = ASPx.GetAbsoluteY(element) + element.clientHeight + ASPx.GetClientTop(element);
   }
  }
  if(ASPx.Browser.WebKitFamily && !this.IsParentElementPositionStatic(indexPath))
   position -= document.body.offsetTop;
  return position;
 },
 GetClientSubMenuXPosition: function(element, x, indexPath, isVertical) {
  var itemInfo = new MenuItemInfo(this, indexPath);
  var itemWidth = itemInfo.clientWidth;
  var itemOffsetWidth = itemInfo.offsetWidth;
  var subMenuWidth = this.GetMenuMainElement(element).offsetWidth;
  var docClientWidth = ASPx.GetDocumentClientWidth();
  if(isVertical) {
   var left = x - ASPx.GetDocumentScrollLeft();
   var right = left + subMenuWidth;
   var toLeftX = x - subMenuWidth - itemWidth;
   var toLeftLeft = left - subMenuWidth - itemWidth;
   var toLeftRight = right - subMenuWidth - itemWidth;
   if(this.IsCorrectionDisableMethodRequired(indexPath)) {
    return this.GetCorrectionDisabledResult(x, toLeftX);
   }
   if(this.popupToLeft) {
    if(toLeftLeft > this.maxHorizontalOverlap) {
     return toLeftX;
    }
    if(docClientWidth - right > this.maxHorizontalOverlap || !this.rtl) {
     this.popupToLeft = false;
     return x;
    }
    if(isVertical)
     return ASPx.InvalidPosition;
    return toLeftX;
   }
   else {
    if(docClientWidth - right > this.maxHorizontalOverlap) {
     return x;
    }
    if(toLeftLeft > this.maxHorizontalOverlap || this.rtl) {
     this.popupToLeft = true;
     return toLeftX;
    }
    if(isVertical)
     return ASPx.InvalidPosition;
    return x;
   }
  }
  else {
   var left = x - ASPx.GetDocumentScrollLeft();
   var right = left + subMenuWidth;
   var toLeftX = x - subMenuWidth + itemOffsetWidth;
   var toLeftLeft = left - subMenuWidth + itemOffsetWidth;
   var toLeftRight = right - subMenuWidth + itemOffsetWidth;
   if(this.popupToLeft) {
    if(toLeftLeft < 0 && toLeftLeft < docClientWidth - right) {
     this.popupToLeft = false;
     return x;
    }
    else
     return toLeftX;
   }
   else {
    if(docClientWidth - right < 0 && docClientWidth - right < toLeftLeft) {
     this.popupToLeft = true;
     return toLeftX;
    }
    else
     return x;
   }
  }
 },
 GetClientSubMenuYPosition: function(element, y, indexPath, isVertical) {
  var itemInfo = new MenuItemInfo(this, indexPath);
  var itemHeight = itemInfo.offsetHeight;
  var itemOffsetHeight = itemInfo.offsetHeight;
  var subMenuHeight = this.GetMenuMainElement(element).offsetHeight;
  var menuItemTop = y - ASPx.GetDocumentScrollTop();
  var subMenuBottom = menuItemTop + subMenuHeight;
  var docClientHeight = ASPx.GetDocumentClientHeight();
  var clientSubMenuYPos = y;
  if(isVertical) {
   var notEnoughSpaceToShowDown = subMenuBottom > docClientHeight;
   var menuItemBottom = menuItemTop + itemHeight;
   if(menuItemBottom > docClientHeight) {
    menuItemBottom = docClientHeight;
    itemHeight = menuItemBottom - menuItemTop;
   }
   var notEnoughSpaceToShowUp = menuItemBottom < subMenuHeight;
   var subMenuIsFitToDisplayFrames = docClientHeight >= subMenuHeight;
   if(!subMenuIsFitToDisplayFrames) clientSubMenuYPos = y - menuItemTop;
   else if(notEnoughSpaceToShowDown) {
    if(notEnoughSpaceToShowUp) {
     var docClientBottom = ASPx.GetDocumentScrollTop() + docClientHeight;
     clientSubMenuYPos = docClientBottom - subMenuHeight;
    } else
     clientSubMenuYPos = y + itemHeight - subMenuHeight;
   }
  }
  else {
   if(this.IsHorizontalSubmenuNeedInversion(subMenuBottom, docClientHeight, menuItemTop, subMenuHeight, itemHeight))
    clientSubMenuYPos = y - subMenuHeight - itemHeight;
  }
  return clientSubMenuYPos;
 },
 IsHorizontalSubmenuNeedInversion: function(subMenuBottom, docClientHeight, menuItemTop, subMenuHeight, itemHeight) {
  return subMenuBottom > docClientHeight && menuItemTop - subMenuHeight - itemHeight > docClientHeight - subMenuBottom;
 },
 IsCorrectionDisableMethodRequired: function(indexPath) {
  return false;
 },
 HasChildren: function(indexPath) {
  return (this.GetMenuElement(indexPath) != null);
 },
 IsVertical: function(indexPath) {
  return true;
 },
 IsRootItem: function(indexPath) {
  return this.GetMenuLevel(indexPath) <= 1;
 },
 IsParentElementPositionStatic: function(indexPath) {
  return this.IsRootItem(indexPath);
 },
 GetItemIndexPath: function(indexes) {
  return aspxGetMenuCollection().GetItemIndexPath(indexes);
 },
 GetItemIndexes: function(indexPath) {
  return aspxGetMenuCollection().GetItemIndexes(indexPath);
 },
 GetItemIndexPathById: function(id) {
  return aspxGetMenuCollection().GetIndexPathById(id, Constants.MIIdSuffix);
 },
 GetMenuIndexPathById: function(id) {
  return aspxGetMenuCollection().GetIndexPathById(id, Constants.MMIdSuffix);
 },
 GetScrollButtonIndexPathById: function(id) {
  return aspxGetMenuCollection().GetIndexPathById(id, Constants.SBIdSuffix);
 },
 GetIndexPathById: function(id, checkMenu) {
  var indexPath = this.GetItemIndexPathById(id);
  if(indexPath == "" && checkMenu)
   indexPath = this.GetMenuIndexPathById(id);
  return indexPath;
 },
 GetMenuLevelInternal: function(indexPath) {
  if(indexPath == "")
   return 0;
  else {
   var indexes = this.GetItemIndexes(indexPath);
   return indexes.length;
  }
 },
 GetMenuLevel: function(indexPath) {
  var level = this.GetMenuLevelInternal(indexPath);
  if(this.IsAdaptiveMenuItem(indexPath))
   level ++;
  return level;
 },
 IsAdaptiveMenuItem: function(indexPath){
  var level = this.GetMenuLevelInternal(indexPath);
  while(level > 1){
   indexPath = this.GetParentIndexPath(indexPath);
   level = this.GetMenuLevelInternal(indexPath);
  }
  var itemElement = this.GetItemElement(indexPath);
  if(itemElement && ASPx.GetParentByClassName(itemElement, MenuCssClasses.AdaptiveMenu))
   return true;
  return false;
 },
 IsAdaptiveItem: function(indexPath){
  var itemElement = this.GetItemElement(indexPath);
  if(itemElement && ASPx.ElementContainsCssClass(itemElement, MenuCssClasses.AdaptiveMenuItem))
   return true;
  return false;
 },
 GetParentIndexPath: function(indexPath) {
  var indexes = this.GetItemIndexes(indexPath);
  indexes.length--;
  return (indexes.length > 0) ? this.GetItemIndexPath(indexes) : "";
 },
 IsLastElement: function(element) {
  return element && (!element.nextSibling || !element.nextSibling.tagName);
 },
 IsLastItem: function(indexPath) {
  var itemElement = this.GetItemElement(indexPath);
  return this.IsLastElement(itemElement);
 },
 IsFirstElement: function(element) {
  return element && (!element.previousSibling || !element.previousSibling.tagName);
 },
 IsFirstItem: function(indexPath) {
  var itemElement = this.GetItemElement(indexPath);
  return this.IsFirstElement(itemElement);
 },
 GetClientSubMenuPos: function(element, indexPath, pos, isVertical, isXPos) {
  if(!ASPx.IsValidPosition(pos)) {
   pos = isXPos ? this.GetSubMenuXPosition(indexPath, isVertical) : this.GetSubMenuYPosition(indexPath, isVertical);
  }
  var clientPos = isXPos ? this.GetClientSubMenuXPosition(element, pos, indexPath, isVertical) : this.GetClientSubMenuYPosition(element, pos, indexPath, isVertical);
  var isInverted = pos != clientPos;
  if(clientPos !== ASPx.InvalidPosition){
   var offset = isXPos ? this.GetSubMenuXOffset(indexPath) : this.GetSubMenuYOffset(indexPath);
   clientPos += isInverted ? -offset : offset;
   clientPos -= ASPx.GetPositionElementOffset(this.GetMenuElement(indexPath), isXPos);
  }
  return new ASPx.PopupPosition(clientPos, isInverted);
 },
 GetSubMenuXOffset: function(indexPath) {
  if(indexPath == "")
   return 0;
  else if(this.IsRootItem(indexPath)) {
   if(this.IsFirstItem(indexPath))
    return this.rootSubMenuFIXOffset;
   else if(this.IsLastItem(indexPath))
    return this.rootSubMenuLIXOffset;
   else
    return this.rootSubMenuXOffset;
  }
  else {
   if(this.IsFirstItem(indexPath))
    return this.subMenuFIXOffset;
   else if(this.IsLastItem(indexPath))
    return this.subMenuLIXOffset;
   else
    return this.subMenuXOffset;
  }
 },
 GetSubMenuYOffset: function(indexPath) {
  if(indexPath == "")
   return 0;
  else if(this.IsRootItem(indexPath)) {
   if(this.IsFirstItem(indexPath))
    return this.rootSubMenuFIYOffset;
   else if(this.IsLastItem(indexPath))
    return this.rootSubMenuLIYOffset;
   else
    return this.rootSubMenuYOffset;
  }
  else {
   if(this.IsFirstItem(indexPath))
    return this.subMenuFIYOffset;
   else if(this.IsLastItem(indexPath))
    return this.subMenuLIYOffset;
   else
    return this.subMenuYOffset;
  }
 },
 StartScrolling: function(buttonId, delay, step) {
  var indexPath = this.GetScrollButtonIndexPathById(buttonId);
  var level = this.GetMenuLevel(indexPath);
  aspxGetMenuCollection().DoHidePopupMenus(null, level, this.name, false, "");
  var direction = (buttonId.lastIndexOf(Constants.SBDIdEnd) == buttonId.length - Constants.SBDIdEnd.length) ? 1 : -1;
  var scrollHelper = this.scrollHelpers[indexPath];
  if(scrollHelper) scrollHelper.StartScrolling(direction, delay, step);
 },
 StopScrolling: function(buttonId) {
  var indexPath = this.GetScrollButtonIndexPathById(buttonId);
  var scrollHelper = this.scrollHelpers[indexPath];
  if(scrollHelper) scrollHelper.StopScrolling();
 },
 ClearAppearTimer: function() {
  aspxGetMenuCollection().ClearAppearTimer();
 },
 ClearDisappearTimer: function() {
  aspxGetMenuCollection().ClearDisappearTimer();
 },
 IsAppearTimerActive: function() {
  return aspxGetMenuCollection().IsAppearTimerActive();
 },
 IsDisappearTimerActive: function() {
  return aspxGetMenuCollection().IsDisappearTimerActive();
 },
 SetAppearTimer: function(indexPath, preventSubMenu) {
  aspxGetMenuCollection().SetAppearTimer(this.name, indexPath, this.appearAfter, preventSubMenu);
 },
 SetDisappearTimer: function() {
  aspxGetMenuCollection().SetDisappearTimer(this.name, this.disappearAfter);
 },
 IsDropDownItem: function(indexPath) {
  return ASPx.ElementContainsCssClass(this.GetItemElement(indexPath), MenuCssClasses.ItemDropDownMode);
 },
 DoItemClick: function(indexPath, hasItemLink, htmlEvent) {
  var processOnServer = this.RaiseItemClick(indexPath, htmlEvent);
  if(processOnServer && !hasItemLink)
   this.SendPostBack("CLICK:" + indexPath);
  else {
   this.ClearDisappearTimer();
   this.ClearAppearTimer();
   if(!this.HasChildren(indexPath) || this.IsDropDownItem(indexPath))
    aspxGetMenuCollection().DoHidePopupMenus(null, -1, this.name, false, "");
   else if(this.IsItemEnabled(indexPath) && !this.IsDropDownItem(indexPath))
    this.ShowSubMenu(indexPath);
  }
 },
 HasContent: function(mainCell) {
  for(var i = 0; i < mainCell.childNodes.length; i++)
   if(mainCell.childNodes[i].tagName)
    return true;
  return false;
 },
 DoShowPopupMenu: function(element, x, y, indexPath) {
  var parent = this.GetItemByIndexPath(indexPath);
  var menuElement = this.GetMenuMainElement(element);
  var popupMenuHasVisibleContent = menuElement && (MenuRenderHelper.HasSubMenuTemplate(menuElement) || 
   ASPx.ElementContainsCssClass(menuElement, MenuCssClasses.AdaptiveMenu)) || 
   parent && this.HasVisibleItems(parent);
  if(popupMenuHasVisibleContent === false)
   return;
  if(element && this.IsCallbacksEnabled())
   this.ShowLoadingPanelInMenu(element);
  if(ASPx.GetElementVisibility(element))
   ASPx.SetStyles(element, { left: ASPx.InvalidPosition, top: ASPx.InvalidPosition });
  ASPx.SetElementDisplay(element, true);
  if(parent) {
   for(var i = 0; i < parent.GetItemCount() ; i++) {
    var item = parent.GetItem(i);
    this.SetPopOutElementVisible(item.indexPath, this.HasVisibleItems(item));
   }
  }
  MenuRenderHelper.CalculateSubMenu(this, element, false);
  if(this.popupCount == 0) this.popupToLeft = this.rtl;
  var isVertical = this.IsVertical(indexPath);
  var horizontalPopupPosition = this.GetClientSubMenuPos(element, indexPath, x, isVertical, true);
  if(horizontalPopupPosition.position === ASPx.InvalidPosition) {
   isVertical = !isVertical;
   horizontalPopupPosition = this.GetClientSubMenuPos(element, indexPath, x, isVertical, true);
  }
  var verticalPopupPosition = this.GetClientSubMenuPos(element, indexPath, y, isVertical, false);
  var clientX = horizontalPopupPosition.position;
  var clientY = verticalPopupPosition.position;
  var toTheLeft = horizontalPopupPosition.isInverted;
  var toTheTop = verticalPopupPosition.isInverted;
  var scrollHelper = this.scrollHelpers[indexPath];
  if(scrollHelper) {
   var yClientCorrection = this.GetScrollSubMenuYCorrection(element, scrollHelper, clientY);
   if(yClientCorrection > 0) {
    clientY += yClientCorrection;
    verticalPopupPosition.position = clientY;
   }
  }
  var parentElement = this.GetItemContentElement(indexPath);
  var prevParentPos = ASPx.GetAbsoluteX(parentElement);
  ASPx.SetStyles(element, {
   left: clientX, top: clientY
  });
  if(ASPx.Browser.IE && ASPx.IsElementRightToLeft(document.body)) {
   ASPx.SetElementDisplay(element, false);
   ASPx.SetElementDisplay(element, true);
  }
  clientX += ASPx.GetAbsoluteX(parentElement) - prevParentPos;
  if(this.enableAnimation) {
   this.StartAnimation(element, indexPath, horizontalPopupPosition, verticalPopupPosition, isVertical);
  }
  else {
   ASPx.SetStyles(element, { left: clientX, top: clientY });
   ASPx.SetElementVisibility(element, true);
   if(this.enableSubMenuFullWidth)
    this.ApplySubMenuFullWidth(element);
   this.DoShowPopupMenuIFrame(element, clientX, clientY, ASPx.InvalidDimension, ASPx.InvalidDimension, indexPath);
   this.DoShowPopupMenuBorderCorrector(element, clientX, clientY, indexPath, toTheLeft, toTheTop);
  }
  aspxGetMenuCollection().RegisterVisiblePopupMenu(this.name, element.id);
  this.popupCount++;
  ASPx.GetControlCollection().AdjustControls(element);
  this.CorrectVerticalAlignment(ASPx.AdjustHeight, this.GetPopOutElements, "PopOut");
  this.CorrectVerticalAlignment(ASPx.AdjustVerticalMargins, this.GetPopOutImages, "PopOutImg");
  this.RaisePopUp(indexPath);
 },
 ShowLoadingPanelInMenu: function(element) {
  var lpParent = this.GetMenuMainElement(element);
  if(lpParent && !this.HasContent(lpParent))
   this.CreateLoadingPanelInsideContainer(lpParent);
 },
 GetScrollSubMenuYCorrection: function(element, scrollHelper, clientY) {
  var absoluteClientY = clientY + ASPx.GetPositionElementOffset(element);
  var excessTop = this.GetScrollExcessTop(absoluteClientY);
  var excessBottom = this.GetScrollExcessBottom(element, absoluteClientY);
  var correction = 0;
  if(excessTop > 0)
   correction += excessTop + this.scrollVertOffset;
  if(excessBottom > 0 && (absoluteClientY + correction == ASPx.GetDocumentScrollTop())) {
   excessBottom += this.scrollVertOffset;
   correction += this.scrollVertOffset;
  }
  this.PrepareScrolling(element, scrollHelper, excessTop, excessBottom);
  return correction;
 },
 GetScrollExcessTop: function(clientY) {
  return ASPx.GetDocumentScrollTop() - clientY;
 },
 GetScrollExcessBottom: function(element, clientY) {
  ASPx.SetElementDisplay(element, false);
  var docHeight = ASPx.GetDocumentClientHeight();
  ASPx.SetElementDisplay(element, true);
  return clientY + element.offsetHeight - ASPx.GetDocumentScrollTop() - docHeight;
 },
 PrepareScrolling: function(element, scrollHelper, excessTop, excessBottom) {
  scrollHelper.Initialize();
  var corrector = element.offsetHeight - scrollHelper.GetScrollAreaHeight() + this.scrollVertOffset;
  if(excessTop > 0)
   scrollHelper.Calculate(element.offsetHeight - excessTop - corrector);
  if(excessBottom > 0)
   scrollHelper.Calculate(element.offsetHeight - excessBottom - corrector);
 },
 ApplySubMenuFullWidth: function(element) {
  ASPx.SetStyles(element, { left: 0, right: 0, width: "auto" });
  var menuElement = this.GetMenuMainElement(element);
  ASPx.SetStyles(menuElement, { width: "100%", "box-sizing": "border-box" });
  var templateElement = ASPx.GetChildByClassName(menuElement, "dx");
  if(templateElement) ASPx.SetStyles(templateElement, { width: "100%" });
 },
 DoShowPopupMenuIFrame: function(element, x, y, width, height, indexPath) {
  if(!this.renderIFrameForPopupElements) return;
  var iFrame = element.overflowElement;
  if(!iFrame) {
   iFrame = this.GetMenuIFrameElement(indexPath);
   element.overflowElement = iFrame;
  }
  if(iFrame) {
   var menuElement = this.GetMenuMainElement(element);
   if(width < 0)
    width = menuElement.offsetWidth;
   if(height < 0)
    height = menuElement.offsetHeight;
   ASPx.SetStyles(iFrame, {
    width: width, height: height,
    left: x, top: y, display: ""
   });
  }
 },
 DoShowPopupMenuBorderCorrector: function(element, x, y, indexPath, toTheLeft, toTheTop) {
  var borderCorrectorElement = this.GetMenuBorderCorrectorElement(indexPath);
  if(borderCorrectorElement) {
   var params = this.GetPopupMenuBorderCorrectorPositionAndSize(element, x, y, indexPath, toTheLeft, toTheTop);
   var itemCell = this.GetItemContentElement(indexPath);
   var popOutImageCell = this.GetItemPopOutElement(indexPath);
   if(ASPx.Browser.IE && ASPx.Browser.MajorVersion == 9) { 
    var isVertical = this.IsVertical(indexPath);
    var itemBoundCoord = itemCell.getBoundingClientRect()[isVertical ? 'bottom' : 'right'];
    var itemBorderWidth = ASPx.PxToInt(ASPx.GetCurrentStyle(itemCell)[isVertical ? 'borderBottomWidth' : 'borderRightWidth']);
    if(popOutImageCell != null) {
     var popOutImageBoundCoord = popOutImageCell.getBoundingClientRect()[isVertical ? 'bottom' : 'right'];
     if(popOutImageBoundCoord > itemBoundCoord) {
      itemBoundCoord = popOutImageBoundCoord;
      itemBorderWidth = ASPx.PxToInt(ASPx.GetCurrentStyle(popOutImageCell)[isVertical ? 'borderBottomWidth' : 'borderRightWidth']);
     }
    }
    var menu = this.GetMainElement();
    itemBoundCoord -= Math.min(menu.getBoundingClientRect()[isVertical ? 'top' : 'left'], ASPx.GetPositionElementOffset(menu, !isVertical));
    if(isVertical) {
     var bottomsDifference = this.GetItemElement(indexPath).getBoundingClientRect().bottom -
      this.GetMenuElement(indexPath).getBoundingClientRect().bottom;
     itemBoundCoord -= bottomsDifference > 0 && bottomsDifference;
    }
    var borderCorrectorBoundCoord = isVertical ? params.top + params.height : params.left + params.width;
    if(itemBoundCoord - borderCorrectorBoundCoord != itemBorderWidth) {
     borderCorrectorBoundCoord = itemBoundCoord - itemBorderWidth;
     if(isVertical)
      params.height = borderCorrectorBoundCoord - params.top;
     else
      params.width = borderCorrectorBoundCoord - params.left;
    }
   }
   ASPx.SetStyles(borderCorrectorElement, {
    width: params.width, height: params.height,
    left: params.left, top: params.top,
    display: "", visibility: "visible"
   });
   element.borderCorrectorElement = borderCorrectorElement;
  }
 },
 GetPopupMenuBorderCorrectorPositionAndSize: function(element, x, y, indexPath, toTheLeft, toTheTop) {
  var result = {};
  var itemInfo = new MenuItemInfo(this, indexPath);
  var menuXOffset = ASPx.GetClientLeft(this.GetMenuMainElement(element));
  var menuYOffset = ASPx.GetClientTop(this.GetMenuMainElement(element));
  var menuElement = this.GetMenuMainElement(element);
  var menuClientWidth = menuElement.clientWidth;
  var menuClientHeight = menuElement.clientHeight;
  if(this.IsVertical(indexPath)) {
   var commonClientHeight = itemInfo.clientHeight < menuClientHeight
    ? itemInfo.clientHeight
    : menuClientHeight;
   result.width = menuXOffset;
   result.height = commonClientHeight + itemInfo.clientTop - menuYOffset;
   result.left = x;
   if(toTheLeft)
    result.left += menuClientWidth + menuXOffset;
   result.top = y + menuYOffset;
   if(toTheTop)
    result.top += menuClientHeight - result.height;
  }
  else {
   var itemWidth = itemInfo.clientWidth;
   if(this.IsDropDownItem(indexPath))
    itemWidth = this.GetItemContentElement(indexPath).clientWidth;
   var commonClientWidth = itemWidth < menuClientWidth
    ? itemWidth
    : menuClientWidth;
   result.width = commonClientWidth + itemInfo.clientLeft - menuXOffset;
   result.height = menuYOffset;
   result.left = x + menuXOffset;
   if(toTheLeft)
    result.left += menuClientWidth - result.width;
   result.top = y;
   if(toTheTop)
    result.top += menuClientHeight + menuYOffset;
  }
  return result;
 },
 DoHidePopupMenu: function(evt, element) {
  this.DoHidePopupMenuBorderCorrector(element);
  this.DoHidePopupMenuIFrame(element);
  var menuElement = this.GetMenuMainElement(element);
  ASPx.PopupUtils.StopAnimation(element, menuElement);
  ASPx.SetElementVisibility(element, false);
  ASPx.SetElementDisplay(element, false);
  this.CancelSubMenuItemHoverItem(element);
  aspxGetMenuCollection().UnregisterVisiblePopupMenu(this.name, element.id);
  this.popupCount--;
  var indexPath = this.GetIndexPathById(element.id, true);
  var scrollHelper = this.scrollHelpers[indexPath];
  if(scrollHelper) {
   element.style.height = "";
   scrollHelper.ResetScrolling();
  }
  this.RaiseCloseUp(indexPath);
 },
 DoHidePopupMenuIFrame: function(element) {
  if(!this.renderIFrameForPopupElements) return;
  var iFrame = element.overflowElement;
  if(iFrame)
   ASPx.SetElementDisplay(iFrame, false);
 },
 DoHidePopupMenuBorderCorrector: function(element) {
  var borderCorrectorElement = element.borderCorrectorElement;
  if(borderCorrectorElement) {
   ASPx.SetElementVisibility(borderCorrectorElement, false);
   ASPx.SetElementDisplay(borderCorrectorElement, false);
   element.borderCorrectorElement = null;
  }
 },
 SetHoverElement: function(element) {
  if(!this.IsStateControllerEnabled()) return;
  this.lockHoverEvents = true;
  ASPx.GetStateController().SetCurrentHoverElementBySrcElement(element);
  this.lockHoverEvents = false;
 },
 ApplySubMenuItemHoverItem: function(element, hoverItem, hoverElement) {
  if(!element.hoverItem && ASPx.GetElementDisplay(element)) {
   var newHoverItem = hoverItem.Clone();
   element.hoverItem = newHoverItem;
   element.hoverElement = hoverElement;
   newHoverItem.Apply(hoverElement);
  }
 },
 CancelSubMenuItemHoverItem: function(element) {
  if(element.hoverItem) {
   element.hoverItem.Cancel(element.hoverElement);
   element.hoverItem = null;
   element.hoverElement = null;
  }
 },
 ShowSubMenu: function(indexPath) {
  var element = this.GetMenuElement(indexPath);
  if(element != null) {
   var level = this.GetMenuLevel(indexPath);
   aspxGetMenuCollection().DoHidePopupMenus(null, level - 1, this.name, false, element.id);
   if(!ASPx.GetElementDisplay(element) && this.IsItemEnabled(indexPath))
    this.DoShowPopupMenu(element, ASPx.InvalidPosition, ASPx.InvalidPosition, indexPath);
  }
  this.ClearAppearTimer();
 },
 SelectItem: function(indexPath) {
  if(!this.IsStateControllerEnabled()) return;
  var element = this.GetItemContentElement(indexPath);
  if(element != null)
   ASPx.GetStateController().SelectElementBySrcElement(element);
 },
 DeselectItem: function(indexPath) {
  if(!this.IsStateControllerEnabled()) return;
  var element = this.GetItemContentElement(indexPath);
  if(element != null) {
   var hoverItem = null;
   var hoverElement = null;
   var menuElement = this.GetMenuElement(indexPath);
   if(menuElement && menuElement.hoverItem) {
    hoverItem = menuElement.hoverItem;
    hoverElement = menuElement.hoverElement;
    this.CancelSubMenuItemHoverItem(menuElement);
   }
   ASPx.GetStateController().DeselectElementBySrcElement(element);
   if(menuElement != null && hoverItem != null)
    this.ApplySubMenuItemHoverItem(menuElement, hoverItem, hoverElement);
  }
 },
 InitializeSelectedItem: function() {
  if(!this.allowSelectItem) return;
  this.SelectItem(this.GetSelectedItemIndexPath());
 },
 GetSelectedItemIndexPath: function() {
  return this.selectedItemIndexPath;
 },
 SetSelectedItemInternal: function(indexPath, modifyHotTrackSelection) {
  if(modifyHotTrackSelection)
   this.SetHoverElement(null);
  this.DeselectItem(this.selectedItemIndexPath);
  this.selectedItemIndexPath = indexPath;
  var item = this.GetItemByIndexPath(indexPath);
  if(item == null || item.GetEnabled())
   this.SelectItem(this.selectedItemIndexPath);
  if(modifyHotTrackSelection) {
   var element = this.GetItemContentElement(indexPath);
   if(element != null)
    this.SetHoverElement(element);
  }
 },
 InitializeCheckedItems: function() {
  if(!this.allowCheckItems) return;
  var indexPathes = this.checkedState.split(";");
  for(var i = 0; i < indexPathes.length; i++) {
   if(indexPathes[i] != "") {
    this.checkedItems.push(indexPathes[i]);
    this.SelectItem(indexPathes[i]);
   }
  }
 },
 ChangeCheckedItem: function(indexPath) {
  this.SetHoverElement(null);
  var itemsGroup = this.GetItemsGroup(indexPath);
  if(itemsGroup != null) {
   if(itemsGroup.length > 1) {
    if(!this.IsCheckedItem(indexPath)) {
     for(var i = 0; i < itemsGroup.length; i++) {
      if(itemsGroup[i] == indexPath) continue;
      if(this.IsCheckedItem(itemsGroup[i])) {
       ASPx.Data.ArrayRemove(this.checkedItems, itemsGroup[i]);
       this.DeselectItem(itemsGroup[i]);
      }
     }
     this.SelectItem(indexPath);
     this.checkedItems.push(indexPath);
    }
   }
   else {
    if(this.IsCheckedItem(indexPath)) {
     ASPx.Data.ArrayRemove(this.checkedItems, indexPath);
     this.DeselectItem(indexPath);
    }
    else {
     this.SelectItem(indexPath);
     this.checkedItems.push(indexPath);
    }
   }
  }
  var element = this.GetItemContentElement(indexPath);
  if(element != null)
   this.SetHoverElement(element);
 },
 GetItemsGroup: function(indexPath) {
  for(var i = 0; i < this.itemCheckedGroups.length; i++) {
   if(ASPx.Data.ArrayIndexOf(this.itemCheckedGroups[i], indexPath) > -1)
    return this.itemCheckedGroups[i];
  }
  return null;
 },
 IsCheckedItem: function(indexPath) {
  return ASPx.Data.ArrayIndexOf(this.checkedItems, indexPath) > -1;
 },
 UpdateStateObject: function(){
  this.UpdateStateObjectWithObject({ selectedItemIndexPath: this.selectedItemIndexPath, checkedState: this.GetCheckedState() });
 },
 GetCheckedState: function() {
  var state = "";
  for(var i = 0; i < this.checkedItems.length; i++) {
   state += this.checkedItems[i];
   if(i < this.checkedItems.length - 1)
    state += ";";
  }
  return state;
 },
 GetAnimationVerticalDirection: function(indexPath, popupPosition, isVertical) {
  var verticalDirection = (this.IsRootItem(indexPath) && !isVertical) ? -1 : 0;
  if(popupPosition.isInverted) verticalDirection *= -1;
  return verticalDirection;
 },
 GetAnimationHorizontalDirection: function(indexPath, popupPosition, isVertical) {
  var horizontalDirection = (this.IsRootItem(indexPath) && !isVertical) ? 0 : -1;
  if(popupPosition.isInverted) horizontalDirection *= -1;
  return horizontalDirection;
 },
 StartAnimation: function(animationDivElement, indexPath, horizontalPopupPosition, verticalPopupPosition, isVertical) {
  var element = this.GetMenuMainElement(animationDivElement);
  var clientX = horizontalPopupPosition.position;
  var clientY = verticalPopupPosition.position;
  ASPx.PopupUtils.InitAnimationDiv(animationDivElement, clientX, clientY);
  var verticalDirection = this.GetAnimationVerticalDirection(indexPath, verticalPopupPosition, isVertical);
  var horizontalDirection = this.GetAnimationHorizontalDirection(indexPath, horizontalPopupPosition, isVertical);
  var yPos = verticalDirection * element.offsetHeight;
  var xPos = horizontalDirection * element.offsetWidth;
  ASPx.SetStyles(element, { left: xPos, top: yPos });
  ASPx.SetElementVisibility(animationDivElement, true);
  if(this.enableSubMenuFullWidth)
   this.ApplySubMenuFullWidth(animationDivElement);
  this.DoShowPopupMenuIFrame(animationDivElement, clientX, clientY, 0, 0, indexPath);
  this.DoShowPopupMenuBorderCorrector(animationDivElement, clientX, clientY, indexPath,
   horizontalPopupPosition.isInverted, verticalPopupPosition.isInverted);
  ASPx.PopupUtils.StartSlideAnimation(animationDivElement, element, this.GetMenuIFrameElement(indexPath), this.slideAnimationDuration, this.enableSubMenuFullWidth, false);
 },
 OnItemClick: function(indexPath, evt) {
  var sourceElement = ASPx.Evt.GetEventSource(evt);
  var clickedLinkElement = ASPx.GetParentByTagName(sourceElement, "A");
  var isLinkClicked = (clickedLinkElement != null && clickedLinkElement.href != ASPx.AccessibilityEmptyUrl);
  var element = this.GetItemContentElement(indexPath);
  var linkElement = (element != null) ? (element.tagName === "A" ? element : ASPx.GetNodeByTagName(element, "A", 0)) : null;
  if(linkElement != null && linkElement.href == ASPx.AccessibilityEmptyUrl)
   linkElement = null;
  if(this.allowSelectItem)
   this.SetSelectedItemInternal(indexPath, true);
  if(this.allowCheckItems)
   this.ChangeCheckedItem(indexPath);
  this.DoItemClick(indexPath, isLinkClicked || (linkElement != null), evt);
  if(!isLinkClicked && linkElement != null && !(ASPx.Browser.WebKitTouchUI && this.HasChildren(indexPath)))
   ASPx.Url.NavigateByLink(linkElement);
 },
 OnItemDropDownClick: function(indexPath, evt) {
  if(this.IsItemEnabled(indexPath))
   this.ShowSubMenu(indexPath);
 },
 AfterItemOverAllowed: function(hoverItem) {
  return hoverItem.name != "" && !this.lockHoverEvents;
 },
 OnAfterItemOver: function(hoverItem, hoverElement) {
  if(!this.AfterItemOverAllowed(hoverItem)) return;
  if(!this.showSubMenus) {
   this.savedCallbackHoverItem = hoverItem;
   this.savedCallbackHoverElement = hoverElement;
   return;
  }
  this.ClearDisappearTimer();
  this.ClearAppearTimer();
  var indexPath = this.GetMenuIndexPathById(hoverItem.name);
  if(indexPath == "") {
   indexPath = this.GetItemIndexPathById(hoverItem.name);
   var canShowSubMenu = true;
   if(this.IsDropDownItem(indexPath)) {
    var popOutImageElement = this.GetItemPopOutElement(indexPath);
    if(popOutImageElement != null && popOutImageElement != hoverElement) {
     hoverItem.needRefreshBetweenElements = true;
     canShowSubMenu = false;
    }
   }
   var preventSubMenu = !(canShowSubMenu && hoverItem.enabled && hoverItem.kind == ASPx.HoverItemKind);
   this.SetAppearTimer(indexPath, preventSubMenu);
   this.RaiseItemMouseOver(indexPath);
  }
 },
 OnBeforeItemOver: function(hoverItem, hoverElement) {
  if(ASPx.Browser.NetscapeFamily && ASPx.IsExists(hoverElement.offsetParent) &&
    hoverElement.offsetParent.style.borderCollapse == "collapse") {
   hoverElement.offsetParent.style.borderCollapse = "separate";
   hoverElement.offsetParent.style.borderCollapse = "collapse";
  }
  var indexPath = this.GetItemIndexPathById(hoverItem.name);
  var element = this.GetMenuElement(indexPath);
  if(element) this.CancelSubMenuItemHoverItem(element);
 },
 OnItemOverTimer: function(indexPath, preventSubMenu) {
  var element = this.GetMenuElement(indexPath);
  if(element == null || preventSubMenu) {
   var level = this.GetMenuLevel(indexPath);
   aspxGetMenuCollection().DoHidePopupMenus(null, level - 1, this.name, false, "");
  }
  if(this.IsAppearTimerActive() && !preventSubMenu) {
   this.ClearAppearTimer();
   if(this.GetItemContentElement(indexPath) != null || this.GetItemPopOutElement(indexPath) != null) {
    this.ShowSubMenu(indexPath);
   }
  }
 },
 OnBeforeItemDisabled: function(disabledItem, disabledElement) {
  this.ClearAppearTimer();
  var indexPath = this.GetItemIndexPathById(disabledElement.id);
  if(indexPath != "") {
   var element = this.GetMenuElement(indexPath);
   if(element != null) this.DoHidePopupMenu(null, element);
  }
 },
 OnAfterItemOut: function(hoverItem, hoverElement, newHoverElement) {
  if(!this.showSubMenus) {
   this.savedCallbackHoverItem = null;
   this.savedCallbackHoverElement = null;
  }
  if(hoverItem.name == "" || this.lockHoverEvents) return;
  if(hoverItem.IsChildElement(newHoverElement)) return;
  var indexPath = this.GetItemIndexPathById(hoverItem.name);
  var element = this.GetMenuElement(indexPath);
  this.ClearDisappearTimer();
  this.ClearAppearTimer();
  if(element == null || !ASPx.GetIsParent(element, newHoverElement))
   this.SetDisappearTimer();
  if(element != null)
   this.ApplySubMenuItemHoverItem(element, hoverItem, hoverElement);
  if(indexPath != "")
   this.RaiseItemMouseOut(indexPath);
 },
 OnItemOutTimer: function() {
  if(this.IsDisappearTimerActive()) {
   this.ClearDisappearTimer();
   if(aspxGetMenuCollection().CheckFocusedElement())
    this.SetDisappearTimer();
   else
    this.OnHideByItemOut();
  }
 },
 OnHideByItemOut: function() {
  aspxGetMenuCollection().DoHidePopupMenus(null, 0, this.name, true, "");
 },
 TryFocusItem: function(itemIndex) {
  var item = this.GetItem(itemIndex);
  if(item.GetVisible() && item.GetEnabled()) {
   this.FocusItemByIndexPath(item.GetIndexPath());
   return true;
  }
  return false;
 },
 Focus: function() {
  if(this.rootItem != null) { 
   for(var i = 0; i < this.GetItemCount() ; i++) {
    if(this.TryFocusItem(i))
     return true;
   }
  }
  else
   this.FocusNextItem("-1");
 },
 FocusLastItem: function() {
  if(this.rootItem != null) { 
   for(var i = this.GetItemCount() - 1; i >= 0; i--) {
    if(this.TryFocusItem(i))
     return true;
   }
  }
  else
   this.FocusPrevItem(this.GetItemCount() - 1);
 },
 FocusItemByIndexPath: function(indexPath) {
  this.keyboardHelper.FocusItemByIndexPath(indexPath);
 },
 OnFocusedItemKeyDown: function(evt, focusedItem) {
  this.keyboardHelper.OnFocusedItemKeyDown(evt, focusedItem);
 },
 OnLostFocus: function(evt) {
  if(!this.isContextMenu || !this.accessibilityCompliant) return;
  if(this.accessibleFocusElement) {
   this.accessibleFocusElement.focus();
   this.accessibleFocusElement = null;
  }
  this.Hide();
  if(evt)
   ASPx.Evt.PreventEventAndBubble(evt);
 },
 OnCallback: function(result) {
  ASPx.InitializeScripts(); 
  this.InitializeScrollableMenus();
  for(var indexPath in result) {
   var menuElement = this.GetMenuElement(indexPath);
   if(menuElement) {
    var menuResult = result[indexPath];
    if(aspxGetMenuCollection().IsSubMenuVisible(menuElement.id)) 
     this.ShowPopupSubMenuAfterCallback(menuElement, menuResult);
    else
     this.SetSubMenuInnerHtml(menuElement, menuResult);
   }
  }
  this.ClearVerticalAlignedElementsCache();
  this.CorrectVerticalAlignment(ASPx.AdjustHeight, this.GetPopOutElements, "PopOut");
  this.CorrectVerticalAlignment(ASPx.AdjustVerticalMargins, this.GetPopOutImages, "PopOutImg");
  this.InitializeInternal(false);
  if(!this.showSubMenus) {
   this.showSubMenus = true;
   if(this.savedCallbackHoverItem != null && this.savedCallbackHoverElement != null)
    this.OnAfterItemOver(this.savedCallbackHoverItem, this.savedCallbackHoverElement);
   this.savedCallbackHoverItem = null;
   this.savedCallbackHoverElement = null;
  }
 },
 SetSubMenuInnerHtml: function(menuElement, html) {
  ASPx.SetInnerHtml(this.GetMenuMainElement(menuElement), html);
  this.dropElementsCache = true;
  MenuRenderHelper.InlineInitializeSubMenuMenuElement(this, menuElement);
  MenuRenderHelper.CalculateSubMenu(this, menuElement, true);
 },
 ShowPopupSubMenuAfterCallback: function(element, callbackResult) {
  var indexPath = this.GetIndexPathById(element.id, true);
  var currentX = ASPx.PxToInt(element.style.left);
  var currentY = ASPx.PxToInt(element.style.top);
  var showedToTheTop = this.ShowedToTheTop(element, indexPath);
  var showedToTheLeft = this.ShowedToTheLeft(element, indexPath);
  ASPx.SetStyles(element, {
   left: ASPx.InvalidPosition, top: ASPx.InvalidPosition
  });
  this.SetSubMenuInnerHtml(element, callbackResult);
  var vertPos = this.GetClientSubMenuPos(element, indexPath, ASPx.InvalidPosition, this.IsVertical(indexPath), false);
  var clientY = vertPos.position;
  var toTheTop = vertPos.isInverted;
  if(!this.IsVertical(indexPath) && showedToTheTop != toTheTop) {
   clientY = currentY;
   toTheTop = showedToTheTop;
  }
  var scrollHelper = this.scrollHelpers[indexPath];
  if(scrollHelper) {
   var yClientCorrection = this.GetScrollSubMenuYCorrection(element, scrollHelper, clientY);
   if(yClientCorrection > 0)
    clientY += yClientCorrection;
  }
  ASPx.SetStyles(element, { left: currentX, top: clientY });
  if(this.enableSubMenuFullWidth)
   this.ApplySubMenuFullWidth(element);
  this.DoShowPopupMenuIFrame(element, currentX, clientY, ASPx.InvalidDimension, ASPx.InvalidDimension, indexPath);
  this.DoShowPopupMenuBorderCorrector(element, currentX, clientY, indexPath, showedToTheLeft, toTheTop);
  ASPx.GetControlCollection().AdjustControls(element);
 },
 ShowedToTheTop: function(element, indexPath) {
  var currentY = ASPx.PxToInt(element.style.top);
  var parentBottomY = this.GetSubMenuYPosition(indexPath, this.IsVertical(indexPath));
  return currentY < parentBottomY;
 },
 ShowedToTheLeft: function(element, indexPath) {
  var currentX = ASPx.PxToInt(element.style.left);
  var parentX = this.GetSubMenuXPosition(indexPath, this.IsVertical(indexPath));
  return currentX < parentX;
 },
 CreateItems: function(items) {
  if (items.length == 0)
   return;
  if(this.NeedCreateItemsOnClientSide())
   this.CreateClientItems(items);
  else
   this.CreateServerItems(items);
 },
 AddItem: function(item) {
  this.PreInitializeClientMenuItems();
  this.RenderItemIfRequired(this.rootItem.CreateItemInternal(item), false);
  this.InitializeClientItems();
 },
 CreateClientItems: function(items) {
  this.PreInitializeClientMenuItems();
  this.rootItem.CreateItems(items);
  this.RenderItems(this.rootItem.items);
  this.InitializeClientItems();
 },
 CreateServerItems: function(items) {
  this.CreateRootItemIfRequired();
  this.rootItem.CreateItems(items);
 },
 PreInitializeClientMenuItems: function() {
  if(!this.rootMenuSample)
   this.InitializeMenuSamples();
  this.CreateRootItemIfRequired();
  if(!this.renderData)
   this.CreateRenderData();
 },
 InitializeClientItems: function() {
  this.dropElementsCache = true;
  MenuRenderHelper.InlineInitializeElements(this);
  this.InitializeEnabledAndVisible(true);
 },
 CreateRootItemIfRequired: function() {
  if(!this.rootItem) {
   var itemType = this.GetClientItemType();
   this.rootItem = new itemType(this, null, 0, "");
  }
 },
 CreateRootMenuElement: function() {
  var wrapperElement = this.GetMainElement().parentNode;
  wrapperElement.innerHTML = "";
  wrapperElement.appendChild(this.rootMenuSample.cloneNode(true));
 }, 
 NeedAppendToRenderData: function(item) {
  return this.NeedCreateItemsOnClientSide() && item.visible || typeof(item.visible) == "undefined";
 },
 ClearItems: function() {
  this.PreInitializeClientMenuItems();
  this.CreateRootMenuElement();
  this.ClearRenderData();
  this.rootItem.items = [];
 },
 GetParentItem: function(rootItemIndexPath) {
  if(!rootItemIndexPath)
   return this.rootItem;
  return this.GetItemByIndexPath(rootItemIndexPath);
 },
 RenderItems: function(items) {
  for(var i=0; i < items.length; i++) {
   var item = items[i];
   this.RenderItemIfRequired(item, item.items.length > 0);
   this.RenderItems(item.items);
  }
 },
 RenderItemIfRequired: function(item, withSubitems) {
  var rootItemElement = item.parent.name ? this.GetItemElement(item.parent.indexPath) : null;
  var rootMenuElement = this.GetOrRenderRootItem(item);
  if(!this.GetItemElement(item.indexPath)) {
   if(!rootItemElement)
    this.RenderItemInternal(rootMenuElement, item, withSubitems);
   else {
    this.AddPopOutElementToItemElementIfNeeded(rootItemElement, item.parent.indexPath, true);
    this.RenderItemInternal(rootMenuElement, item, withSubitems);
   }
   var itemElementId = this.GetItemElementId(item.indexPath);
   ASPx.GetStateController().AddHoverItem(itemElementId, ["dxm-hovered"], [""], [""], null, null, false);
   ASPx.GetStateController().AddDisabledItem(itemElementId, ["dxm-disabled"], [""], [""], null, null, false);
  }
 },
 GetOrRenderRootItem: function(item) {
  if(item.parent.name) {
   var rootMenuElement = this.GetMenuElement(item.parent.indexPath);
   return rootMenuElement ? rootMenuElement : this.RenderSubMenuItem(item.parent.indexPath);
  } else
   return this.GetMenuElement("");
 },
 RenderItemInternal: function(rootItem, item, withSubitems) {
  var rootItem =  ASPx.GetNodeByTagName(rootItem, "UL", 0);
  var element = this.CreateItemElement(item, withSubitems);
  var li = ASPx.GetNodesByTagName(rootItem, "LI");
  if(li.length == 0) {
   rootItem.appendChild(element);
   return;
  }
  this.RenderSeparatorElementIfRequired(rootItem, item.indexPath, item.beginGroup);
  this.RenderSpaceElementIfRequired(rootItem, item.indexPath);
  if(!this.GetItemElement(item.indexPath))
   rootItem.appendChild(element);
 },
 NeedAddPopOutElement: function(rootMenuElement) {
  return ASPx.GetNodesByClassName(rootMenuElement, MenuCssClasses.PopOutContainer).length == 0
 },
 AddPopOutElementToItemElementIfNeeded: function(itemElement, indexPath, withSubitems) {
  if(this.NeedAddPopOutElement(itemElement) && withSubitems) {
   if(this.isPopupMenu || !this.IsRootItem(indexPath)) {
    itemElement.className = itemElement.className.replace(MenuCssClasses.ItemWithoutSubMenu, MenuCssClasses.ItemWithSubMenu);
    itemElement.insertBefore(this.samplePopOutElement.cloneNode(true), itemElement.childNodes[itemElement.childNodes.length - 1]);
   }
  }
 },
 RenderSeparatorElementIfRequired: function(rootItem, indexPath, needAddSeparator) {
  if(needAddSeparator) {
   var item = this.CreateSeparatorElement(indexPath);
   rootItem.appendChild(item);
  }
 },
 RenderSpaceElementIfRequired: function(rootItem, indexPath) {
  if(rootItem.childNodes.length > 0) {
   var item = this.CreateSpacingElement(indexPath);
   rootItem.appendChild(item);
  }
 },
 RenderSubMenuItem: function(indexPath) {
  var subMenuElement = this.CreateSubMenuElement(indexPath);
  this.GetMainElement().parentElement.appendChild(subMenuElement);
  return subMenuElement;
 },
 HasSeparatorOnCurrentPosition: function(itemElements, position) {
  return itemElements[position - 1 > 0 ? position - 1 : 0].className.indexOf(MenuCssClasses.Separator) > -1;
 },
 CreateItemElement: function(item, withSubitems) {
  var itemElement = this.sampleEmptyItemElement.cloneNode();
  var contentElement = this.sampleContentElement.cloneNode();
  this.AddImageToItemElementIfNeeded(item, itemElement, contentElement);
  this.AddTextElementToItemElement(contentElement, itemElement, item.text);
  this.AddPopOutElementToItemElementIfNeeded(itemElement, item.indexPath, withSubitems);
  itemElement.appendChild(this.sampleClearElement.cloneNode());
  itemElement.id = this.GetItemElementId(item.indexPath);
  return itemElement;
 },
 AddTextElementToItemElement: function(contentElement, itemElement, text) {
  var textElement = this.sampleTextElementForItem.cloneNode();
  ASPx.SetInnerHtml(textElement, text);
  contentElement.appendChild(textElement);
  itemElement.appendChild(contentElement);
 },
 AddImageToItemElementIfNeeded: function(item, itemElement, contentElement) {
  if(item.imageSrc || item.imageClassName) {
   var imageElement = this.sampleImageElementForItem.cloneNode();
   if(item.imageSrc)
    imageElement.src = item.imageSrc;
   if(item.imageClassName)
    imageElement.className += " " + item.imageClassName;
   ASPx.RemoveClassNameFromElement(imageElement, Constants.SampleCssClassNameForImageElement);
   ASPx.RemoveClassNameFromElement(itemElement, MenuCssClasses.ItemWithoutImage);
   ASPx.RemoveClassNameFromElement(ASPx.GetNodeByTagName(this.GetMenuElement(item.parent.indexPath), "UL", 0), MenuCssClasses.WithoutImages);
   contentElement.appendChild(imageElement);
  }
 },
 CreateSpacingElement: function(indexPath) {
  var item = this.sampleSpacingElement.cloneNode();
  item.id = this.GetItemIndentElementId(indexPath);
  return item;
 },
 CreateSeparatorElement: function(indexPath) {
  var item = this.sampleSeparatorElement.cloneNode(true);
  item.id = this.GetItemSeparatorElementId(indexPath);
  return item;
 },
 CreateSubMenuElement: function(indexPath) {
  var subMenu = this.sampleSubMenuElement.cloneNode(true);
  subMenu.id =  this.name + Constants.MMIdSuffix + indexPath + "_";
  return subMenu;
 },
 AppendToRenderData: function(rootItemIndexPath, index) {
  if(rootItemIndexPath) {
   if(!this.renderData[rootItemIndexPath])
    this.renderData[rootItemIndexPath] = [[index]];
   this.renderData[rootItemIndexPath][index] = [index];
  } else {
   this.renderData[""].push([[index]]);
  }
 },
 CreateRenderData: function() {
  this.renderData = {"" : []};
 },
 ClearRenderData: function() {
  this.renderData = null;
 },
 GetClientItemType: function() {
  return ASPxClientMenuItem;
 },
 GetItemByIndexPath: function(indexPath) {
  var item = this.rootItem;
  if(indexPath != "" && item != null) {
   var indexes = this.GetItemIndexes(indexPath);
   for(var i = 0; i < indexes.length; i++)
    item = item.GetItem(indexes[i]);
  }
  return item;
 },
 SetItemChecked: function(indexPath, checked) {
  var itemsGroup = this.GetItemsGroup(indexPath);
  if(itemsGroup != null) {
   if(!checked && this.IsCheckedItem(indexPath)) {
    ASPx.Data.ArrayRemove(this.checkedItems, indexPath);
    this.DeselectItem(indexPath);
   }
   else if(checked && !this.IsCheckedItem(indexPath)) {
    if(itemsGroup.length > 1) {
     for(var i = 0; i < itemsGroup.length; i++) {
      if(itemsGroup[i] == indexPath) continue;
      if(this.IsCheckedItem(itemsGroup[i])) {
       ASPx.Data.ArrayRemove(this.checkedItems, itemsGroup[i]);
       this.DeselectItem(itemsGroup[i]);
      }
     }
    }
    this.SelectItem(indexPath);
    this.checkedItems.push(indexPath);
   }
   if(this.accessibilityCompliant) {
    var itemElement = this.GetItemElement(indexPath);
    var link = ASPx.GetNodeByTagName(itemElement, "A");
    if(link)
     ASPx.Attr.SetAttribute(link, "aria-checked", checked ? "true" : "false");
   }
  }
 },
 ChangeItemEnabledAttributes: function(indexPath, enabled) {
  MenuRenderHelper.ChangeItemEnabledAttributes(this.GetItemElement(indexPath), enabled, this.accessibilityCompliant);
 },
 IsItemEnabled: function(indexPath) {
  var item = this.GetItemByIndexPath(indexPath);
  return (item != null) ? item.GetEnabled() : true;
 },
 SetItemEnabled: function(indexPath, enabled, initialization) {
  if(indexPath == "" || !this.GetItemByIndexPath(indexPath).enabled) return;
  if(!enabled) {
   if(this.GetSelectedItemIndexPath() == indexPath)
    this.DeselectItem(indexPath);
  }
  if(!initialization || !enabled)
   this.ChangeItemEnabledStateItems(indexPath, enabled);
  this.ChangeItemEnabledAttributes(indexPath, enabled);
  if(enabled) {
   if(this.GetSelectedItemIndexPath() == indexPath)
    this.SelectItem(indexPath);
  }
 },
 ChangeItemEnabledStateItems: function(indexPath, enabled) {
  if(!this.IsStateControllerEnabled()) return;
  var element = this.GetItemElement(indexPath);
  if(element)
   ASPx.GetStateController().SetElementEnabled(element, enabled);
 },
 GetItemImageUrl: function(indexPath) {
  var image = this.GetItemImage(indexPath);
  if(image)
   return image.src;
  return "";
 },
 SetItemImageUrl: function(indexPath, url) {
  var image = this.GetItemImage(indexPath);
  if(image)
   image.src = url;
 },
 GetItemImage: function(indexPath) {
  var element = this.GetItemContentElement(indexPath);
  if(element != null) {
   var img = ASPx.GetNodeByTagName(element, "IMG", 0);
   if(img != null)
    return img;
  }
 },
 GetItemNavigateUrl: function(indexPath) {
  var element = this.GetItemContentElement(indexPath);
  if(element != null && element.tagName === "A")
   return ASPx.Attr.GetAttribute(element, "savedhref") || element.href;
  if(element != null) {
   var link = ASPx.GetNodeByTagName(element, "A", 0);
   if(link != null)
    return ASPx.Attr.GetAttribute(link, "savedhref") || link.href;
  }
  return "";
 },
 SetItemNavigateUrl: function(indexPath, url) {
  var element = this.GetItemContentElement(indexPath);
  var setUrl = function(link) {
   if(link != null) {
    if(ASPx.Attr.IsExistsAttribute(link, "savedhref"))
     ASPx.Attr.SetAttribute(link, "savedhref", url);
    else if(ASPx.Attr.IsExistsAttribute(link, "href"))
     link.href = url;
   }
  };
  if(element != null) {
   if(element.tagName === "A")
    setUrl(element);
   else {
    setUrl(ASPx.GetNodeByTagName(element, "A", 0));
    setUrl(ASPx.GetNodeByTagName(element, "A", 1));
   }
  }
 },
 FindTextNode: function(indexPath) {
  var element = this.GetItemContentElement(indexPath);
  if(element) {
   var link = ASPx.GetNodeByTagName(element, "A", 0); 
   if(link)
    return ASPx.GetTextNode(link);
   var titleSpan = ASPx.GetNodeByTagName(element, "SPAN", 0); 
   if(titleSpan)
    return ASPx.GetTextNode(titleSpan);
   for(var i = 0; i < element.childNodes.length; i++) { 
    var child = element.childNodes[i];
    if(child.nodeValue && (ASPx.Str.Trim(child.nodeValue) != ""))
     return child;
   }
   return ASPx.GetTextNode(element);
  }
  return null;
 },
 GetItemText: function(indexPath) {
  var textNode = this.FindTextNode(indexPath);
  return textNode
   ? ASPx.Str.Trim(textNode.nodeValue) 
   : "";
 },
 SetItemText: function(indexPath, text) {
  var textNode = this.FindTextNode(indexPath);
  if(textNode) {
   textNode.nodeValue = text;
   var menuElement = this.GetMenuElement(this.GetParentIndexPath(indexPath));
   if(menuElement && !this.IsRootItem(indexPath))
    MenuRenderHelper.CalculateSubMenu(this, menuElement, true);
   if(this.IsRootItem(indexPath) && !this.isPopupMenu) {
    var itemElement = this.GetItemElement(indexPath);
    if(itemElement)
     MenuRenderHelper.CalculateItemMinSize(itemElement, true);
   }
  }
 },
 SetItemVisible: function(indexPath, visible, initialization) {
  if(indexPath == "" || !this.GetItemByIndexPath(indexPath).visible) return;
  if(visible && initialization) return;
  var element = this.GetItemElement(indexPath);
  if(element != null)
   ASPx.SetElementDisplay(element, visible);
  this.SetIndentsVisiblility(indexPath);
  this.SetSeparatorsVisiblility(indexPath);
  var parent = this.GetItemByIndexPath(indexPath).parent;
  var parentHasVisibleItems = this.HasVisibleItems(parent);
  if(this.IsRootItem(indexPath) && !this.isPopupMenu) {
   if(this.clientVisible)
    ASPx.SetElementDisplay(this.GetMainElement(), parentHasVisibleItems);
  }
  else
   this.SetPopOutElementVisible(parent.indexPath, parentHasVisibleItems);
  var parentIndexPath = this.GetParentIndexPath(indexPath); 
  if(!this.IsRootItem(parentIndexPath) || this.isPopupMenu) {
   var menuElement = this.GetMenuElement(parentIndexPath);
   if(menuElement) 
    MenuRenderHelper.CalculateSubMenu(this, menuElement, true);
  }
  if(this.IsRootItem(indexPath) && !this.isPopupMenu) 
   MenuRenderHelper.CalculateMenuControl(this, this.GetMainElement(), true);
 },
 SetIndentsVisiblility: function(indexPath) {
  var parent = this.GetItemByIndexPath(indexPath).parent;
  for(var i = 0; i < parent.GetItemCount() ; i++) {
   var item = parent.GetItem(i);
   var separatorVisible = this.HasPrevVisibleItems(parent, i) && item.GetVisible();
   var element = this.GetItemIndentElement(item.GetIndexPath());
   if(element != null) ASPx.SetElementDisplay(element, separatorVisible);
  }
 },
 SetSeparatorsVisiblility: function(indexPath) {
  var parent = this.GetItemByIndexPath(indexPath).parent;
  for(var i = 0; i < parent.GetItemCount() ; i++) {
   var item = parent.GetItem(i);
   var separatorVisible = this.HasPrevVisibleItems(parent, i) && (item.GetVisible() || this.HasNextVisibleItemInGroup(parent, i));
   var element = this.GetItemSeparatorElement(item.GetIndexPath());
   if(element != null) ASPx.SetElementDisplay(element, separatorVisible);
  }
 },
 SetPopOutElementVisible: function(indexPath, visible) {
  var popOutElement = this.GetItemPopOutElement(indexPath);
  if(popOutElement)
   ASPx.SetElementDisplay(popOutElement, visible);
 },
 HasNextVisibleItemInGroup: function(parent, index) {
  for(var i = index + 1; i < parent.GetItemCount() ; i++) {
   var item = parent.GetItem(i);
   if(this.IsItemBeginsGroup(item))
    return false;
   if(item.GetVisible() && !this.IsAdaptiveItem(item.indexPath))
    return true;
  }
  return false;
 },
 IsItemBeginsGroup: function(item) {
  var itemSeparator = this.GetItemSeparatorElement(item.GetIndexPath());
  return itemSeparator && ASPx.ElementContainsCssClass(itemSeparator, MenuCssClasses.Separator);
 },
 HasVisibleItems: function(parent) {
  for(var i = 0; i < parent.GetItemCount() ; i++) {
   if(parent.GetItem(i).GetVisible())
    return true;
  }
  return false;
 },
 HasNextVisibleItems: function(parent, index) {
  for(var i = index + 1; i < parent.GetItemCount() ; i++) {
   if(parent.GetItem(i).GetVisible())
    return true;
  }
  return false;
 },
 HasPrevVisibleItems: function(parent, index) {
  for(var i = index - 1; i >= 0; i--) {
   if(parent.GetItem(i).GetVisible())
    return true;
  }
  return false;
 },
 GetItemIndentElement: function(indexPath) {
  return ASPx.GetElementById(this.GetItemIndentElementId(indexPath));
 },
 GetItemSeparatorElement: function(indexPath) {
  return ASPx.GetElementById(this.GetItemSeparatorElementId(indexPath));
 },
 RaiseItemClick: function(indexPath, htmlEvent) {
  var processOnServer = this.autoPostBack || this.IsServerEventAssigned("ItemClick");
  if(!this.ItemClick.IsEmpty()) {
   var item = this.GetItemByIndexPath(indexPath);
   var htmlElement = this.GetItemContentElement(indexPath);
   var args = new ASPxClientMenuItemClickEventArgs(processOnServer, item, htmlElement, htmlEvent);
   this.ItemClick.FireEvent(this, args);
   processOnServer = args.processOnServer;
  }
  return processOnServer;
 },
 RaiseItemMouseOver: function(indexPath) {
  if(!this.ItemMouseOver.IsEmpty()) {
   var item = this.GetItemByIndexPath(indexPath);
   var htmlElement = this.GetItemContentElement(indexPath);
   var args = new ASPxClientMenuItemMouseEventArgs(item, htmlElement);
   this.ItemMouseOver.FireEvent(this, args);
  }
 },
 RaiseItemMouseOut: function(indexPath) {
  if(!this.ItemMouseOut.IsEmpty()) {
   var item = this.GetItemByIndexPath(indexPath);
   var htmlElement = this.GetItemContentElement(indexPath);
   var args = new ASPxClientMenuItemMouseEventArgs(item, htmlElement);
   this.ItemMouseOut.FireEvent(this, args);
  }
 },
 RaisePopUp: function(indexPath) {
  var item = this.GetItemByIndexPath(indexPath);
  if(!this.PopUp.IsEmpty()) {
   var args = new ASPxClientMenuItemEventArgs(item);
   this.PopUp.FireEvent(this, args);
  }
 },
 RaiseCloseUp: function(indexPath) {
  var item = this.GetItemByIndexPath(indexPath);
  if(!this.CloseUp.IsEmpty()) {
   var args = new ASPxClientMenuItemEventArgs(item);
   this.CloseUp.FireEvent(this, args);
  }
 },
 SetEnabled: function(enabled) {
  for(var i = this.GetItemCount() - 1; i >= 0; i--) {
   var item = this.GetItem(i);
   item.SetEnabled(enabled);
  }
 },
 SetVisible: function(visible) {
  ASPxClientControl.prototype.SetVisible.call(this, visible);
  if(visible && !this.HasVisibleItems(this))
   ASPx.SetElementDisplay(this.GetMainElement(), false);
 },
 GetItemCount: function() {
  return (this.rootItem != null) ? this.rootItem.GetItemCount() : 0;
 },
 GetItem: function(index) {
  return (this.rootItem != null) ? this.rootItem.GetItem(index) : null;
 },
 GetItemByName: function(name) {
  return (this.rootItem != null) ? this.rootItem.GetItemByName(name) : null;
 },
 GetSelectedItem: function() {
  var indexPath = this.GetSelectedItemIndexPath();
  if(indexPath != "")
   return this.GetItemByIndexPath(indexPath);
  return null;
 },
 SetSelectedItem: function(item) {
  var indexPath = (item != null) ? item.GetIndexPath() : "";
  this.SetSelectedItemInternal(indexPath, false);
 },
 GetRootItem: function() {
  return this.rootItem;
 }
});
ASPxClientMenuBase.GetMenuCollection = function() {
 return aspxGetMenuCollection();
}
var ASPxMenuKeyboardHelper = ASPx.CreateClass(null, {
 constructor: function(menu) {
  this.menu = menu;
  this.accessibilityCompliant = menu.accessibilityCompliant;
  this.isContextMenu = menu.isContextMenu;
  this.rtl = menu.rtl;
 },
 OnFocusedItemKeyDown: function(evt, focusedItem) {
  var indexPath = this.menu.GetItemIndexPathById(focusedItem.name);
  if(!this.IsAllowedItemAction(evt, focusedItem.enabled, indexPath))
   ASPx.Evt.PreventEventAndBubble(evt);
  else
   this.OnFocusedItemKeyDownInternal(evt, indexPath);
 },
 OnFocusedItemKeyDownInternal: function(evt, indexPath) {
  var keyKode = ASPx.Evt.GetKeyCode(evt);
  switch (keyKode) {
   case ASPx.Key.Tab: {
    this.OnTab(indexPath, evt);
    break;
   }
   case ASPx.Key.Down: {
    this.OnArrowDown(indexPath, evt);
    break;
   }
   case ASPx.Key.Up: {
    this.OnArrowUp(indexPath, evt);
    break;
   }
   case ASPx.Key.Left: {
    var focusingItemAction = this.rtl ? this.OnArrowRight : this.OnArrowLeft;
    focusingItemAction.call(this, indexPath, evt);
    break;
   }
   case ASPx.Key.Right: {
    var focusingItemAction = this.rtl ? this.OnArrowLeft : this.OnArrowRight;
    focusingItemAction.call(this, indexPath, evt);
    break;
   }
   case ASPx.Key.Esc: {
    this.OnEscape(indexPath, evt);
    break;
   }
   case ASPx.Key.Space: break;
   case ASPx.Key.Enter: break;
   case ASPx.Key.Shift: break;
   case ASPx.Key.Alt: break;
   case ASPx.Key.Ctrl: break;
   default: {
    ASPx.Evt.PreventEventAndBubble(evt);
    break;
   }
  }
 },
 OnTab: function(indexPath, evt) {
  var isRootItem = this.menu.IsRootItem(indexPath);
  if(isRootItem && !this.accessibilityCompliant) return;
  var isShiftTabPressedOnNonFirstRootItem = isRootItem && evt.shiftKey && !!this.GetPrevSiblingIndexPath(indexPath);
  var isTabPressedOnNonLastRootItem = isRootItem && !evt.shiftKey && !!this.GetNextSiblingIndexPath(indexPath);
  var focusingItemAction;
  if(isShiftTabPressedOnNonFirstRootItem)
   focusingItemAction = this.menu.IsVertical(indexPath) ? this.OnArrowUp : this.OnArrowLeft;
  else if(isTabPressedOnNonLastRootItem)
   focusingItemAction = this.menu.IsVertical(indexPath) ? this.OnArrowDown : this.OnArrowRight;
  else if(!isRootItem)
   focusingItemAction = evt.shiftKey ? this.OnShiftTabSubmenu : this.OnArrowDown;
  if(focusingItemAction)
   focusingItemAction.call(this, indexPath, evt);
  else
   this.menu.OnLostFocus(evt);
 },
 OnArrowDown: function(indexPath, evt) {
  var focusingItemAction = this.menu.IsVertical(indexPath) ? this.FocusNextItem : this.ShowSubMenuAccessible;
  focusingItemAction.call(this, indexPath);
  ASPx.Evt.PreventEventAndBubble(evt);
 },
 OnArrowUp: function(indexPath, evt) {
  var focusingItemAction = this.menu.IsVertical(indexPath) ? this.FocusPrevItem : this.ShowSubMenuAccessible;
  focusingItemAction.call(this, indexPath);
  ASPx.Evt.PreventEventAndBubble(evt);
 },
 OnArrowLeft: function(indexPath, evt) {
  var isVertical = this.menu.IsVertical(indexPath);
  if(isVertical) {
   var isRootItem = this.menu.IsRootItem(indexPath);
   var focusingItemAction = isRootItem ? this.FocusPrevItem : this.FocusItemByIndexPathAccessible;
   var newIndexPath = isRootItem ? indexPath : this.GetLeftParentIndexPath(indexPath);
   focusingItemAction.call(this, newIndexPath);
  } else
   this.FocusPrevItem(indexPath);
  ASPx.Evt.PreventEventAndBubble(evt);
 },
 OnArrowRight: function(indexPath, evt) {
  var isVertical = this.menu.IsVertical(indexPath);
  if(isVertical) {
   var hasChildren = this.menu.HasChildren(indexPath);
   var focusingItemAction = hasChildren ? this.ShowSubMenuAccessible : this.FocusItemByIndexPathAccessible;
   var newIndexPath = hasChildren ? indexPath : this.GetRightRootParentIndexPath(indexPath);
   focusingItemAction.call(this, newIndexPath);
  }
  else
   this.FocusNextItem(indexPath);
  ASPx.Evt.PreventEventAndBubble(evt);
 },
 OnEscape: function(indexPath, evt) {
  var needPreventEvent = true;
  if(this.menu.IsRootItem(indexPath)) {
   aspxGetMenuCollection().DoHidePopupMenus(null, -1, this.name, false, "");
   this.menu.OnLostFocus(evt);
  }
  else {
   var parentIndexPath = this.menu.GetParentIndexPath(indexPath);
   this.FocusItemByIndexPathAccessible(parentIndexPath);
   var element = this.menu.GetMenuElement(parentIndexPath);
   if(element != null)
    this.menu.DoHidePopupMenu(null, element);
   else
    needPreventEvent = false;
  }
  if(needPreventEvent)
   ASPx.Evt.PreventEventAndBubble(evt);
 },
 OnShiftTabSubmenu: function(indexPath, evt) {
  if(!this.GetPrevSiblingIndexPath(indexPath)) {
   var parentIndexPath = this.menu.GetParentIndexPath(indexPath);
   this.FocusItemByIndexPathAccessible(parentIndexPath);
  } else
   this.FocusPrevItem(indexPath);
  ASPx.Evt.PreventEventAndBubble(evt);
 },
 GetRightRootParentIndexPath: function(indexPath) {
  var parentIndexPath = this.GetParentRootIndexPath(indexPath);
  return this.GetNextFocusableItemIndexPath(parentIndexPath);
 },
 GetLeftParentIndexPath: function(indexPath) {
  var parentIndexPath = this.menu.GetParentIndexPath(indexPath);
  if(!this.menu.IsVertical(parentIndexPath))
   parentIndexPath = this.GetPrevFocusableItemIndexPath(parentIndexPath);
  return parentIndexPath;
 },
 GetParentRootIndexPath: function(indexPath) {
  while(!this.menu.IsRootItem(indexPath))
   indexPath = this.menu.GetParentIndexPath(indexPath);
  return indexPath;
 },
 ShowSubMenuAccessible: function(indexPath) {
  this.menu.ShowSubMenu(indexPath);
  var newIndexPath = this.GetFirstChildIndexPath(indexPath);
  this.FocusItemByIndexPathAccessible(newIndexPath);
 },
 FocusItemByIndexPathAccessible: function(indexPath) {
  if(this.accessibilityCompliant)
   this.PronounceItemDescription(indexPath);
  this.FocusItemByIndexPath(indexPath);
 },
 IsAllowedItemAction: function(evt, isEnabled, indexPath) {
  var isVertical = this.menu.IsVertical(indexPath);
  return !this.accessibilityCompliant ||
      isEnabled ||
      this.IsAllowedFocusMoving(evt) ||
      this.IsAllowedHorizontalFocusMoving(evt, isVertical) ||
      this.IsAllowedVerticalFocusMoving(evt, isVertical);
 },
 IsAllowedFocusMoving: function(evt) {
  return evt.keyCode == ASPx.Key.Tab || evt.keyCode == ASPx.Key.Esc;
 },
 IsAllowedHorizontalFocusMoving: function(evt, isVertical) {
  return !isVertical && (evt.keyCode == ASPx.Key.Left || evt.keyCode == ASPx.Key.Right);
 },
 IsAllowedVerticalFocusMoving: function(evt, isVertical) {
  return isVertical && (evt.keyCode == ASPx.Key.Up || evt.keyCode == ASPx.Key.Down);
 },
 FocusItemByIndexPath: function(indexPath) {
  var element = this.menu.GetItemElement(indexPath);
  var link = ASPx.GetNodeByTagName(element, "A", 0);
  if(link != null) {
   if(this.accessibilityCompliant && !link.href)
    link.href = ASPx.AccessibilityEmptyUrl;
   ASPx.SetFocus(link);
  } else
   this.FocusTemplateItemActionElement(element);
 },
 FocusTemplateItemActionElement: function(element) {
  var focusableElement = ASPx.FindChildActionElement(element);
  if(!!focusableElement)
   ASPx.SetFocus(focusableElement);
 },
 PronounceItemDescription: function(indexPath) {
  var element = this.menu.GetItemElement(indexPath);
  var link = ASPx.GetNodeByTagName(element, "A", 0);
  var span = ASPx.GetNodeByTagName(link, "SPAN", 0);
  if(!link) return;
  if(!!span && !span.id) {
   var spanID = this.GetAccessibilityTextSpanID(indexPath);
   span.id = spanID;
   ASPx.Attr.SetAttribute(link, "aria-describedby", spanID);
  }
  ASPx.Attr.SetAttribute(link, "aria-label", this.GetAccessibilityItemDescription(indexPath));
 },
 RemoveAccessibilityDescription: function(indexPath) {
  var element = this.menu.GetItemElement(indexPath);
  var link = ASPx.GetNodeByTagName(element, "A", 0);
  if(link && ASPx.Attr.GetAttribute(link, "aria-label"))
   ASPx.Attr.RemoveAttribute(link, "aria-label");
 },
 GetAccessibilityTextSpanID: function(indexPath) {
  return this.name + Constants.ATSIdSuffix + indexPath;
 },
 GetAccessibilityItemDescription: function(indexPath) {
  var descriptionParts = [];
  descriptionParts.push(this.menu.IsVertical(indexPath) ? ASPx.AccessibilitySR.MenuVerticalText : ASPx.AccessibilitySR.MenuHorizontalText);
  descriptionParts.push(this.menu.IsRootItem(indexPath) ? ASPx.AccessibilitySR.MenuBarText : ASPx.AccessibilitySR.MenuText);
  descriptionParts.push(this.menu.GetMenuLevel(indexPath));
  descriptionParts.push(ASPx.AccessibilitySR.MenuLevelText);
  return descriptionParts.join(' ');
 },
 FocusNextItem: function(indexPath) {
  var newIndexPath = this.GetNextFocusableItemIndexPath(indexPath);
  if(!newIndexPath) return;
  if(this.accessibilityCompliant)
   this.RemoveAccessibilityDescription(newIndexPath);
  this.FocusItemByIndexPath(newIndexPath);
 },
 FocusPrevItem: function(indexPath) {
  var newIndexPath = this.GetPrevFocusableItemIndexPath(indexPath);
  if(!newIndexPath) return;
  if(this.accessibilityCompliant)
   this.RemoveAccessibilityDescription(newIndexPath);
  this.FocusItemByIndexPath(newIndexPath);
 },
 GetNextFocusableItemIndexPath: function(indexPath) {
  var newIndexPath = this.GetNextSiblingIndexPath(indexPath);
  if(newIndexPath == null)
   newIndexPath = this.GetFirstSiblingIndexPath(indexPath);
  if(indexPath != newIndexPath)
   return newIndexPath;
 },
 GetPrevFocusableItemIndexPath: function(indexPath) {
  var newIndexPath = this.GetPrevSiblingIndexPath(indexPath);
  if(newIndexPath == null)
   newIndexPath = this.GetLastSiblingIndexPath(indexPath);
  if(indexPath != newIndexPath)
   return newIndexPath;
 },
 GetFirstChildIndexPath: function(indexPath) {
  var indexes = this.menu.GetItemIndexes(indexPath);
  indexes[indexes.length] = 0;
  var newIndexPath = this.menu.GetItemIndexPath(indexes);
  return this.GetFirstSiblingIndexPath(newIndexPath);
 },
 GetFirstSiblingIndexPath: function(indexPath) {
  var indexes = this.menu.GetItemIndexes(indexPath);
  var i = 0;
  while(true) {
   indexes[indexes.length - 1] = i;
   var newIndexPath = this.menu.GetItemIndexPath(indexes);
   if(!this.IsItemExist(newIndexPath))
    return null;
   if(this.IsFocusableItem(newIndexPath))
    return newIndexPath;
   i++;
  }
  return null;
 },
 GetLastSiblingIndexPath: function(indexPath) {
  var indexes = this.menu.GetItemIndexes(indexPath);
  var parentItem = this.menu.GetItemByIndexPath(this.menu.GetParentIndexPath(indexPath));
  var i = parentItem ? parentItem.GetItemCount() - 1 : 0;
  while(true) {
   indexes[indexes.length - 1] = i;
   var newIndexPath = this.menu.GetItemIndexPath(indexes);
   if(!this.IsItemExist(newIndexPath))
    return null;
   if(this.IsFocusableItem(newIndexPath))
    return newIndexPath;
   i--;
  }
  return null;
 },
 GetNextSiblingIndexPath: function(indexPath) {
  if(this.menu.IsLastItem(indexPath)) return null;
  var indexes = this.menu.GetItemIndexes(indexPath);
  var i = indexes[indexes.length - 1] + 1;
  while(true) {
   indexes[indexes.length - 1] = i;
   var newIndexPath = this.menu.GetItemIndexPath(indexes);
   if(!this.IsItemExist(newIndexPath))
    return null;
   if(this.IsFocusableItem(newIndexPath))
    return newIndexPath;
   i++;
  }
  return null;
 },
 GetPrevSiblingIndexPath: function(indexPath) {
  if(this.menu.IsFirstItem(indexPath)) return null;
  var indexes = this.menu.GetItemIndexes(indexPath);
  var i = indexes[indexes.length - 1] - 1;
  while(true) {
   indexes[indexes.length - 1] = i;
   var newIndexPath = this.menu.GetItemIndexPath(indexes);
   if(!this.IsItemExist(newIndexPath))
    return null;
   if(this.IsFocusableItem(newIndexPath))
    return newIndexPath;
   i--;
  }
  return null;
 },
 IsItemExist: function(indexPath) {
  return !!this.menu.GetItemByIndexPath(indexPath);
 },
 IsItemVisible: function(indexPath) {
  var item = this.menu.GetItemByIndexPath(indexPath);
  return item ? item.GetVisible() : false;
 },
 IsFocusableItem: function(indexPath) {
  return this.IsItemVisible(indexPath) && (this.menu.IsItemEnabled(indexPath) || this.IsItemAccessibleEnabled(indexPath));
 },
 IsItemAccessibleEnabled: function(indexPath) {
  var item = this.menu.GetItemByIndexPath(indexPath);
  return this.accessibilityCompliant && item && item.enabled;
 }
});
var ASPxClientMenuCollection = ASPx.CreateClass(ASPxClientControlCollection, {
 constructor: function() {
  this.constructor.prototype.constructor.call(this);
  this.appearTimerID = -1;
  this.disappearTimerID = -1;
  this.currentShowingPopupMenuName = null;
  this.visibleSubMenusMenuName = "";
  this.visibleSubMenuIds = [];
  this.overXPos = -1;
  this.overYPos = -1;
 },
 GetCollectionType: function(){
  return "Menu";
 },
 Remove: function(element) {
  if(element.name === this.visibleSubMenusMenuName) {
   this.visibleSubMenusMenuName = "";
   this.visibleSubMenuIds = [ ];
  }
  ASPxClientControlCollection.prototype.Remove.call(this, element);
 },
 RegisterVisiblePopupMenu: function(name, id) {
  this.visibleSubMenuIds.push(id);
  this.visibleSubMenusMenuName = name;
 },
 UnregisterVisiblePopupMenu: function(name, id) {
  ASPx.Data.ArrayRemove(this.visibleSubMenuIds, id);
  if(this.visibleSubMenuIds.length == 0)
   this.visibleSubMenusMenuName = "";
 },
 IsSubMenuVisible: function(subMenuId) {
  for(var i = 0; i < this.visibleSubMenuIds.length; i++) {
   if(this.visibleSubMenuIds[i] == subMenuId)
    return true;
  }
  return false;
 },
 GetMenu: function(id) {
  return this.Get(this.GetMenuName(id));
 },
 GetMenuName: function(id) {
  return this.GetMenuNameBySuffixes(id, [Constants.MMIdSuffix, Constants.MIIdSuffix]);
 },
 GetMenuNameBySuffixes: function(id, idSuffixes) {
  for(var i = 0; i < idSuffixes.length; i++) {
   var pos = id.lastIndexOf(idSuffixes[i]);
   if(pos > -1)
    return id.substring(0, pos);
  }
  return id;
 },
 ClearCurrentShowingPopupMenuName: function() {
  this.SetCurrentShowingPopupMenuName(null);
 },
 SetCurrentShowingPopupMenuName: function(value) {
  this.currentShowingPopupMenuName = value;
 },
 NowPopupMenuIsShowing: function() {
  return this.currentShowingPopupMenuName != null;
 },
 GetMenuLevelById: function(id) {
  var indexPath = this.GetIndexPathById(id, Constants.MMIdSuffix);
  var menu = this.GetMenu(id);
  return menu.GetMenuLevel(indexPath);
 },
 GetIndexPathById: function(id, idSuffix) {
  var pos = id.lastIndexOf(idSuffix);
  if(pos > -1) {
   id = id.substring(pos + idSuffix.length);
   pos = id.lastIndexOf("_");
   if(pos > -1)
    return id.substring(0, pos);
  }
  return "";
 },
 GetItemIndexPath: function(indexes) {
  var indexPath = "";
  for(var i = 0; i < indexes.length; i++) {
   indexPath += indexes[i];
   if(i < indexes.length - 1)
    indexPath += ASPx.ItemIndexSeparator;
  }
  return indexPath;
 },
 GetItemIndexes: function(indexPath) {
  var indexes = indexPath.split(ASPx.ItemIndexSeparator);
  for(var i = 0; i < indexes.length; i++)
   indexes[i] = parseInt(indexes[i]);
  return indexes;
 },
 ClearAppearTimer: function() {
  this.appearTimerID = ASPx.Timer.ClearTimer(this.appearTimerID);
 },
 ClearDisappearTimer: function() {
  this.disappearTimerID = ASPx.Timer.ClearTimer(this.disappearTimerID);
 },
 IsAppearTimerActive: function() {
  return this.appearTimerID > -1;
 },
 IsDisappearTimerActive: function() {
  return this.disappearTimerID > -1;
 },
 SetAppearTimer: function(name, indexPath, timeout, preventSubMenu) {
  this.appearTimerID = window.setTimeout(function() {
   var menu = aspxGetMenuCollection().Get(name);
   if(menu != null) menu.OnItemOverTimer(indexPath, preventSubMenu);
  }, timeout);
 },
 SetDisappearTimer: function(name, timeout) {
  this.disappearTimerID = window.setTimeout(function() {
   var menu = aspxGetMenuCollection().Get(name);
   if(menu != null)
    menu.OnItemOutTimer();
  }, timeout);
 },
 GetMouseDownMenuLevel: function(evt) {
  var srcElement = ASPx.Evt.GetEventSource(evt);
  if(this.visibleSubMenusMenuName != "") {
   var element = ASPx.GetParentById(srcElement, this.visibleSubMenusMenuName);
   if(element != null) return 1;
  }
  for(var i = 0; i < this.visibleSubMenuIds.length; i++) {
   var element = ASPx.GetParentById(srcElement, this.visibleSubMenuIds[i]);
   if(element != null)
    return this.GetMenuLevelById(this.visibleSubMenuIds[i]) + 1;
  }
  return -1;
 },
 CheckFocusedElement: function() {
  try {
   var activeElement = document.activeElement;
   if(activeElement != null) {
    for(var i = 0; i < this.visibleSubMenuIds.length; i++) {
     var menuElement = ASPx.GetElementById(this.visibleSubMenuIds[i]);
     if(menuElement != null && ASPx.GetIsParent(menuElement, activeElement)) {
      var tagName = activeElement.tagName;
      if(tagName == "A" && ASPx.ElementHasCssClass(activeElement, MenuCssClasses.ContentContainer) && !this.GetMenu(this.visibleSubMenusMenuName).accessibilityCompliant)
       return false;
      if(!ASPx.Browser.IE || tagName == "INPUT" || tagName == "TEXTAREA" || tagName == "SELECT")
       return true;
     }
    }
   }
  } catch (e) {
  }
  return false;
 },
 DoHidePopupMenus: function(evt, level, name, leavePopups, exceptId) {
  for(var i = this.visibleSubMenuIds.length - 1; i >= 0 ; i--) {
   var menu = this.GetMenu(this.visibleSubMenuIds[i]);
   if(menu != null) {
    var menuLevel = this.GetMenuLevelById(this.visibleSubMenuIds[i]);
    if((!leavePopups || menuLevel > 0) && exceptId != this.visibleSubMenuIds[i]) {
     if(menuLevel > level || (menu.name != name && name != "")) {
      var element = ASPx.GetElementById(this.visibleSubMenuIds[i]);
      if(element != null)
       menu.DoHidePopupMenu(evt, element);
     }
    }
   }
  }
 },
 DoShowAtCurrentPos: function(name, indexPath) {
  var pc = this.Get(name);
  var element = pc.GetMainElement();
  if(pc != null && !ASPx.GetElementDisplay(element))
   pc.DoShowPopupMenu(element, this.overXPos, this.overYPos, indexPath);
 },
 SaveCurrentMouseOverPos: function(evt, popupElement) {
  if(!this.NowPopupMenuIsShowing()) return;
  var currentShowingPopupMenu = this.Get(this.currentShowingPopupMenuName);
  if(currentShowingPopupMenu.popupElement == popupElement)
   if(!currentShowingPopupMenu.IsMenuVisible()) {
    this.overXPos = ASPx.Evt.GetEventX(evt);
    this.overYPos = ASPx.Evt.GetEventY(evt);
   }
 },
 OnMouseDown: function(evt) {
  var menuLevel = this.GetMouseDownMenuLevel(evt);
  this.DoHidePopupMenus(evt, menuLevel, "", false, "");
 },
 HideAll: function() {
  this.DoHidePopupMenus(null, -1, "", false, "");
 },
 IsAnyMenuVisible: function() {
  return this.visibleSubMenuIds.length != 0;
 }
});
var menuCollection = null;
function aspxGetMenuCollection() {
 if(menuCollection == null)
  menuCollection = new ASPxClientMenuCollection();
 return menuCollection;
}
var ASPxClientMenuItem = ASPx.CreateClass(null, {
 constructor: function(menu, parent, index, name) {
  this.menu = menu;
  this.parent = parent;
  this.index = index;
  this.name = name;
  this.indexPath = "";
  this.text = "";
  this.imageSrc = "";
  this.imageClassName = "";
  this.beginGroup = false;
  if(parent) {
   this.indexPath = this.CreateItemIndexPath(parent);
  }
  this.enabled = true;
  this.clientEnabled = true;
  this.visible = true;
  this.clientVisible = true;
  this.items = [];
 },
 CreateItemIndexPath: function(parent) {
  return parent.indexPath ? parent.indexPath + ASPx.ItemIndexSeparator + this.index.toString() : this.index.toString();
 },
 CreateItems: function(itemsProperties) {
  var itemType = this.menu.GetClientItemType();
  for(var i = 0; i < itemsProperties.length; i++) {
   var itemProperties = itemsProperties[i];
   var item = this.CreateItemInternal(itemProperties, i);
   if(itemProperties.items)
    item.CreateItems(itemProperties.items);
  }
 },
 CreateItemInternal: function(itemProperties, index) {
  var itemName = itemProperties.name || "";
  var correctIndex = index ? index : this.items.length;
  var itemType = this.menu.GetClientItemType();
  var item = new itemType(this.menu, this, correctIndex, itemName);
  if(ASPx.IsExists(itemProperties.text))
   item.text = itemProperties.text;
  if(ASPx.IsExists(itemProperties.imageSrc))
   item.imageSrc = itemProperties.imageSrc;
  if(ASPx.IsExists(itemProperties.imageClassName))
   item.imageClassName = itemProperties.imageClassName;
  if(ASPx.IsExists(itemProperties.beginGroup))
   item.beginGroup = itemProperties.beginGroup;
  if(ASPx.IsExists(itemProperties.enabled))
   item.enabled = itemProperties.enabled;
  if(ASPx.IsExists(itemProperties.clientEnabled))
   item.clientEnabled = itemProperties.clientEnabled;
  if(ASPx.IsExists(itemProperties.visible))
   item.visible = itemProperties.visible;
  if(ASPx.IsExists(itemProperties.clientVisible))
   item.clientVisible = itemProperties.clientVisible;
  if(this.menu.NeedAppendToRenderData(item))
   this.menu.AppendToRenderData(this.indexPath, correctIndex);
  this.items.push(item);
  return item;
 },
 GetIndexPath: function() {
  return this.indexPath;
 },
 GetItemCount: function() {
  return this.items.length;
 },
 GetItem: function(index) {
  return (0 <= index && index < this.items.length) ? this.items[index] : null;
 },
 GetItemByName: function(name) {
  for(var i = 0; i < this.items.length; i++)
   if(this.items[i].name == name) return this.items[i];
  for(var i = 0; i < this.items.length; i++) {
   var item = this.items[i].GetItemByName(name);
   if(item != null) return item;
  }
  return null;
 },
 GetChecked: function() {
  var indexPath = this.GetIndexPath();
  return this.menu.IsCheckedItem(indexPath);
 },
 SetChecked: function(value) {
  var indexPath = this.GetIndexPath();
  this.menu.SetItemChecked(indexPath, value);
 },
 GetEnabled: function() {
  return this.enabled && this.clientEnabled;
 },
 SetEnabled: function(value) {
  if(this.clientEnabled != value) {
   this.clientEnabled = value;
   this.menu.SetItemEnabled(this.GetIndexPath(), value, false);
  }
 },
 GetImage: function() {
  return this.menu.GetItemImage(this.GetIndexPath());
 },
 GetImageUrl: function() {
  return this.menu.GetItemImageUrl(this.GetIndexPath());
 },
 SetImageUrl: function(value) {
  var indexPath = this.GetIndexPath();
  this.menu.SetItemImageUrl(indexPath, value);
 },
 GetNavigateUrl: function() {
  var indexPath = this.GetIndexPath();
  return this.menu.GetItemNavigateUrl(indexPath);
 },
 SetNavigateUrl: function(value) {
  var indexPath = this.GetIndexPath();
  this.menu.SetItemNavigateUrl(indexPath, value);
 },
 GetText: function() {
  var indexPath = this.GetIndexPath();
  return this.menu.GetItemText(indexPath);
 },
 SetText: function(value) {
  var indexPath = this.GetIndexPath();
  this.menu.SetItemText(indexPath, value);
 },
 GetVisible: function() {
  return this.visible && this.clientVisible;
 },
 SetVisible: function(value) {
  if(this.clientVisible != value) {
   this.clientVisible = value;
   this.menu.SetItemVisible(this.GetIndexPath(), value, false);
  }
 },
 InitializeEnabledAndVisible: function(recursive) {
  this.menu.SetItemEnabled(this.GetIndexPath(), this.clientEnabled, true);
  this.menu.SetItemVisible(this.GetIndexPath(), this.clientVisible, true);
  if(recursive) {
   for(var i = 0; i < this.items.length; i++)
    this.items[i].InitializeEnabledAndVisible(recursive);
  }
 }
});
var ASPxClientMenu = ASPx.CreateClass(ASPxClientMenuBase, {
 constructor: function(name) {
  this.constructor.prototype.constructor.call(this, name);
  this.isVertical = false;
  this.orientationChanged = false;
  this.firstSubMenuDirection = "Auto";
 },
 InitializeProperties: function(properties){
  ASPxClientMenuBase.prototype.InitializeProperties.call(this, properties);
  if(properties.adaptiveModeData)
   this.SetAdaptiveMode(properties.adaptiveModeData);
 },
 IsVertical: function(indexPath) {
  return this.isVertical || !this.IsRootItem(indexPath) || this.IsAdaptiveMenuItem(indexPath);
 },
 IsCorrectionDisableMethodRequired: function(indexPath) {
  return (indexPath.indexOf("i") == -1) && (this.firstSubMenuDirection == "RightOrBottom" || this.firstSubMenuDirection == "LeftOrTop");
 },
 SetAdaptiveMode: function(data) {
  this.enableAdaptivity = true;
  if(ASPx.Ident.IsArray(data))
   this.adaptiveItemsOrder = data;
  else {
   for(var i = data - 1; i >= 0; i--)
    this.adaptiveItemsOrder.push(i.toString());
  }
 }, 
 OnBrowserWindowResize: function (e) {
  this.AdjustControl();
 },
 AdjustControlCore: function() {
  this.CorrectVerticalAlignment(ASPx.ClearHeight, this.GetPopOutElements, "PopOut", true);
  this.CorrectVerticalAlignment(ASPx.ClearVerticalMargins, this.GetPopOutImages, "PopOutImg", true);
  if(this.orientationChanged){
   MenuRenderHelper.ChangeOrientaion(this.isVertical, this, this.GetMainElement());
   this.orientationChanged = false;
  }
  else
   MenuRenderHelper.CalculateMenuControl(this, this.GetMainElement());
  this.CorrectVerticalAlignment(ASPx.AdjustHeight, this.GetPopOutElements, "PopOut", true);
  this.CorrectVerticalAlignment(ASPx.AdjustVerticalMargins, this.GetPopOutImages, "PopOutImg", true);
 },
 GetCorrectionDisabledResult: function(x, toLeftX) {
  switch (this.firstSubMenuDirection) {
   case "RightOrBottom": {
    this.popupToLeft = false;
    return x;
   }
   case "LeftOrTop": {
    this.popupToLeft = true;
    return toLeftX;
   }
  }
 },
 IsHorizontalSubmenuNeedInversion: function(subMenuBottom, docClientHeight, menuItemTop, subMenuHeight, itemHeight) {
  if(this.firstSubMenuDirection == "Auto")
   return ASPxClientMenuBase.prototype.IsHorizontalSubmenuNeedInversion.call(this, subMenuBottom, docClientHeight, menuItemTop, subMenuHeight, itemHeight);
  return this.firstSubMenuDirection == "LeftOrTop"
 },
 GetOrientation: function() {
  return this.isVertical ? "Vertical" : "Horizontal";
 },
 SetOrientation: function(orientation) {
  var isVertical = orientation === "Vertical";
  if(this.isVertical !== isVertical){
   this.isVertical = isVertical;
   this.orientationChanged = true;
   this.ResetControlAdjustment();
   this.AdjustControl();
  }
 }
});
ASPx.Ident.scripts.ASPxClientMenu = true;
var ASPxClientMenuExt = ASPx.CreateClass(ASPxClientMenu, {
 constructor: function(name) {
  this.constructor.prototype.constructor.call(this, name);
  this.INDEX_ROOTMENU_ITEM = 0;
  this.INDEX_MAINMENU_ELEMENT = 1;
  this.INDEX_SUBMENU_ELEMENT = 2;
 },
 InitializeMenuSamples: function() {
  var menu = this.InitializeSampleMenuElement();
  this.InitializeRootItemSample(menu);
  this.InitializeItemSamples(this.GetMainMenuElementSample(menu));
  this.InitializeMenuSamplesInternal(menu);
  this.InitializeSubMenuSample(this.GetSubMenuElementSample(menu));
 },
 GetMainMenuElementSample: function(menu) {
  return menu.childNodes[this.INDEX_MAINMENU_ELEMENT];
 },
 GetSubMenuElementSample: function(menu) {
  return menu.childNodes[this.INDEX_SUBMENU_ELEMENT];
 },
 InitializeRootItemSample: function(sample) {
  this.rootMenuSample = this.GetRootMenuItemSample(sample).cloneNode(true);
  ASPx.RemoveElement(ASPx.GetNodeByTagName(this.rootMenuSample, "LI", 0));
  sample.removeChild(this.GetRootMenuItemSample(sample));
 },
 GetRootMenuItemSample: function(menu) {
  return menu.childNodes[this.INDEX_ROOTMENU_ITEM];
 },
 NeedCreateItemsOnClientSide: function() {
  return true;
 }
});
ASPxClientMenu.Cast = ASPxClientControl.Cast;
var ASPxClientMenuItemEventArgs = ASPx.CreateClass(ASPxClientEventArgs, {
 constructor: function(item) {
  this.constructor.prototype.constructor.call(this);
  this.item = item;
 }
});
var ASPxClientMenuItemMouseEventArgs = ASPx.CreateClass(ASPxClientMenuItemEventArgs, {
 constructor: function(item, htmlElement) {
  this.constructor.prototype.constructor.call(this, item);
  this.htmlElement = htmlElement;
 }
});
var ASPxClientMenuItemClickEventArgs = ASPx.CreateClass(ASPxClientProcessingModeEventArgs, {
 constructor: function(processOnServer, item, htmlElement, htmlEvent) {
  this.constructor.prototype.constructor.call(this, processOnServer);
  this.item = item;
  this.htmlElement = htmlElement;
  this.htmlEvent = htmlEvent;
 }
});
ASPx.Evt.AttachEventToDocument(ASPx.TouchUIHelper.touchMouseDownEventName, function(evt) {
 return aspxGetMenuCollection().OnMouseDown(evt);
});
function aspxAMIMOver(source, args) {
 var menu = aspxGetMenuCollection().GetMenu(args.item.name);
 if(menu != null) menu.OnAfterItemOver(args.item, args.element);
}
function aspxBMIMOver(source, args) {
 var menu = aspxGetMenuCollection().GetMenu(args.item.name);
 if(menu != null) menu.OnBeforeItemOver(args.item, args.element);
}
function aspxAMIMOut(source, args) {
 var menu = aspxGetMenuCollection().GetMenu(args.item.name);
 if(menu != null) menu.OnAfterItemOut(args.item, args.element, args.toElement);
}
function aspxMSBOver(source, args) {
 var menu = MenuScrollHelper.GetMenuByScrollButtonId(args.element.id)
 if(menu != null) menu.ClearDisappearTimer();
}
ASPx.AddAfterSetFocusedState(aspxAMIMOver);
ASPx.AddAfterClearFocusedState(aspxAMIMOut);
ASPx.AddAfterSetHoverState(aspxAMIMOver);
ASPx.AddAfterClearHoverState(aspxAMIMOut);
ASPx.AddBeforeSetFocusedState(aspxBMIMOver);
ASPx.AddBeforeSetHoverState(aspxBMIMOver);
ASPx.AddAfterSetHoverState(aspxMSBOver);
ASPx.AddAfterSetPressedState(aspxMSBOver);
ASPx.AddBeforeDisabled(function(source, args) {
 var menu = aspxGetMenuCollection().GetMenu(args.item.name);
 if(menu != null)
  menu.OnBeforeItemDisabled(args.item, args.element);
});
ASPx.AddFocusedItemKeyDown(function(source, args) {
 var menu = aspxGetMenuCollection().GetMenu(args.item.name);
 if(menu != null)
  menu.OnFocusedItemKeyDown(args.htmlEvent, args.item);
});
ASPx.AddAfterClearHoverState(function(source, args) {
 var menu = MenuScrollHelper.GetMenuByScrollButtonId(args.element.id)
 if(menu != null) menu.SetDisappearTimer();
});
ASPx.AddAfterSetPressedState(function(source, args) {
 var menu = MenuScrollHelper.GetMenuByScrollButtonId(args.element.id);
 if(menu) menu.StartScrolling(args.element.id, 1, 4);
});
ASPx.AddAfterClearPressedState(function(source, args) {
 var menu = MenuScrollHelper.GetMenuByScrollButtonId(args.element.id);
 if(menu) menu.StopScrolling(args.element.id);
});
if(!ASPx.Browser.TouchUI) {
 ASPx.AddAfterSetHoverState(function(source, args) {
  var menu = MenuScrollHelper.GetMenuByScrollButtonId(args.element.id);
  if(menu) menu.StartScrolling(args.element.id, 15, 1);
 });
 ASPx.AddAfterClearHoverState(function(source, args) {
  var menu = MenuScrollHelper.GetMenuByScrollButtonId(args.element.id);
  if(menu) menu.StopScrolling(args.element.id);
 });
}
ASPx.MIClick = function(evt, name, indexPath) {
 if(ASPx.TouchUIHelper.isMouseEventFromScrolling) return;
 var menu = aspxGetMenuCollection().Get(name);
 if(menu != null) menu.OnItemClick(indexPath, evt);
 if(!ASPx.Browser.NetscapeFamily)
  evt.cancelBubble = true;
}
ASPx.MIDDClick = function(evt, name, indexPath) {
 var menu = aspxGetMenuCollection().Get(name);
 if(menu != null) menu.OnItemDropDownClick(indexPath, evt);
 if(!ASPx.Browser.NetscapeFamily)
  evt.cancelBubble = true;
}
ASPx.GetMenuCollection = aspxGetMenuCollection;
window.ASPxClientMenuBase = ASPxClientMenuBase;
window.ASPxClientMenuCollection = ASPxClientMenuCollection;
window.ASPxClientMenuItem = ASPxClientMenuItem;
window.ASPxClientMenu = ASPxClientMenu;
window.ASPxClientMenuExt = ASPxClientMenuExt;
window.ASPxClientMenuItemEventArgs = ASPxClientMenuItemEventArgs;
window.ASPxClientMenuItemMouseEventArgs = ASPxClientMenuItemMouseEventArgs;
window.ASPxClientMenuItemClickEventArgs = ASPxClientMenuItemClickEventArgs;
})();
(function() {
ASPx.currentDragHelper = null;
var currentCursorTargets = null;
var DragHelper = ASPx.CreateClass(null, {
 constructor: function(e, root, clone){
  if(ASPx.currentDragHelper != null) ASPx.currentDragHelper.cancelDrag();
  this.dragArea = 5;
  this.clickX = ASPx.Evt.GetEventX(e);
  this.clickY = ASPx.Evt.GetEventY(e);
  this.centerClone = false;
  this.cachedCloneWidth = -1;
  this.cachedCloneHeight = -1;
  this.cachedOriginalX = -1;
  this.cachedOriginalY = -1;
  this.canDrag = true; 
  if(typeof(root) == "string") 
   root = ASPx.GetParentByTagName(ASPx.Evt.GetEventSource(e), root);
  this.obj = root && root != null ? root : ASPx.Evt.GetEventSource(e);
  this.clone = clone;
  this.dragObj = null; 
  this.additionalObj = null;
  this.onDoClick = null;
  this.onEndDrag = null;
  this.onCancelDrag = null;
  this.onDragDivCreating = null;
  this.onCloneCreating = null;
  this.onCloneCreated = null;
  this.dragDiv = null;
  ASPx.currentDragHelper = this;
  this.clearSelectionOnce = false;
 }, 
 drag: function(e) {
  if(!this.canDrag) return;
  ASPx.Selection.Clear();
  if(!this.isDragging()) {
   if(!this.isOutOfDragArea(e)) 
    return;
   this.startDragCore(e);
  }
  if(ASPx.Browser.IE && !ASPx.Evt.IsLeftButtonPressed(e)) {
   this.cancelDrag(e);
   return;
  }
  if(!ASPx.Browser.IE)
   ASPx.Selection.SetElementSelectionEnabled(document.body, false);
  this.dragCore(e);
 },
 startDragCore: function(e) {  
  this.dragObj = this.clone != true ? this.obj : this.createClone(e);
 },
 dragCore: function(e) { 
  this.updateDragDivPosition(e);
 },
 endDrag: function(e) { 
  if(!this.isDragging() && !this.isOutOfDragArea(e)) {
   if(this.onDoClick)
    this.onDoClick(this, e);
  } else {
   if(this.onEndDrag)
    this.onEndDrag(this, e);
  }
  this.cancelDrag();
 },
 cancel: function(){
  this.cancelDrag();
 },
 cancelDrag: function() {
  if(this.dragDiv != null) {
   document.body.removeChild(this.dragDiv);
   this.dragDiv = null;
  }
  if(this.onCancelDrag)
   this.onCancelDrag(this);
  ASPx.currentDragHelper = null;
  if(!ASPx.Browser.IE)
   ASPx.Selection.SetElementSelectionEnabled(document.body, true);
 },
 isDragging: function() {    
  return this.dragObj != null;
 },
 updateDragDivPosition: function(e) {
  if(this.centerClone) {
   this.dragDiv.style.left = ASPx.Evt.GetEventX(e) - this.cachedCloneWidth / 2 + "px";
   this.dragDiv.style.top = ASPx.Evt.GetEventY(e) - this.cachedCloneHeight / 2 + "px";
  } else {
   this.dragDiv.style.left = this.cachedOriginalX + ASPx.Evt.GetEventX(e) - this.clickX + "px";
   this.dragDiv.style.top = this.cachedOriginalY + ASPx.Evt.GetEventY(e) - this.clickY + "px";
  }
 },
 createClone: function(e) {
  this.dragDiv = document.createElement("div");
  if(this.onDragDivCreating)
   this.onDragDivCreating(this, this.dragDiv);
  var clone = this.creatingClone();  
  this.dragDiv.appendChild(clone);
  document.body.appendChild(this.dragDiv);
  this.dragDiv.style.position = "absolute";    
  this.dragDiv.style.cursor = "move";
  this.dragDiv.style.borderStyle = "none";
  this.dragDiv.style.padding = "0";
  this.dragDiv.style.margin = "0";
  this.dragDiv.style.backgroundColor = "transparent";
  this.dragDiv.style.zIndex = 20000; 
  if(this.onCloneCreated)
   this.onCloneCreated(clone);
  this.cachedCloneWidth = clone.offsetWidth;
  this.cachedCloneHeight = clone.offsetHeight;
  if(!this.centerClone) {  
   this.cachedOriginalX = ASPx.GetAbsoluteX(this.obj);
   this.cachedOriginalY = ASPx.GetAbsoluteY(this.obj);
  }
  this.dragDiv.style.width = this.cachedCloneWidth + "px";
  this.dragDiv.style.height = this.cachedCloneHeight + "px";
  this.updateDragDivPosition(e);
  return this.dragDiv;
 },
 creatingClone: function() {
  var clone = this.obj.cloneNode(true);
  var scripts = ASPx.GetNodesByTagName(clone, "SCRIPT");
  for(var i = scripts.length - 1; i >= 0; i--)
   ASPx.RemoveElement(scripts[i]);
  if(!this.onCloneCreating) return clone;
  return this.onCloneCreating(clone);
 },
 addElementToDragDiv: function(element) {
  if(this.dragDiv == null) return;
  this.additionalObj = element.cloneNode(true);
  this.additionalObj.style.visibility = "visible";
  this.additionalObj.style.display = "";
  this.additionalObj.style.top = "";
  this.dragDiv.appendChild(this.additionalObj);
 },
 removeElementFromDragDiv: function() {
  if(this.additionalObj == null || this.dragDiv == null) return;
  this.dragDiv.removeChild(this.additionalObj);
  this.additionalObj = null;
 },
 isOutOfDragArea: function(e) {
  return Math.max(
   Math.abs(ASPx.Evt.GetEventX(e) - this.clickX), 
   Math.abs(ASPx.Evt.GetEventY(e) - this.clickY)
  ) >= this.dragArea;
 }
});
var CursorTargets = ASPx.CreateClass(null, {
 constructor: function() {
  this.list = [];
  this.oldtargetElement = null;
  this.oldtargetTag = 0;
  this.targetElement = null;
  this.targetTag = 0;
  this.x = 0;
  this.y = 0;
  this.removedX = 0;
  this.removedY = 0;
  this.removedWidth = 0;
  this.removedHeight = 0;
  this.onTargetCreated = null;
  this.onTargetChanging = null;
  this.onTargetChanged = null;
  this.onTargetAdding = null;
  this.onTargetAllowed = null;
  currentCursorTargets = this;
 },
 addElement: function(element) {
  if(!this.canAddElement(element)) return null;
  var target = new CursorTarget(element);
  this.onTargetCreated && this.onTargetCreated(this, target);
  this.list.push(target);
  return target;
 },
 removeElement: function(element) {
  for(var i = 0; i < this.list.length; i++) {
   if(this.list[i].element == element) {
    this.list.splice(i, 1);
    return;
   }
  }
 },
 addParentElement: function(parent, child) {
  var target = this.addElement(parent);
  if(target != null) {
   target.targetElement = child;
  }
  return target;
 },
 RegisterTargets: function(element, idPrefixArray) {
  this.addFunc = this.addElement;
  this.RegisterTargetsCore(element, idPrefixArray);
 },
 UnregisterTargets: function(element, idPrefixArray) {
  this.addFunc = this.removeElement;
  this.RegisterTargetsCore(element, idPrefixArray);
 },
 RegisterTargetsCore: function(element, idPrefixArray) {
  if(element == null) return;
  for(var i = 0; i < idPrefixArray.length; i++)
   this.RegisterTargetCore(element, idPrefixArray[i]);
 },
 RegisterTargetCore: function(element, idPrefix) {
  if(!ASPx.IsExists(element.id)) return;
  if(element.id.indexOf(idPrefix) > -1)
   this.addFunc(element);
  for(var i = 0; i < element.childNodes.length; i++)
   this.RegisterTargetCore(element.childNodes[i], idPrefix);
 },
 canAddElement: function(element) {
  if(element == null || !ASPx.GetElementDisplay(element))
   return false;
  for(var i = 0; i < this.list.length; i++) {
   if(this.list[i].targetElement == element) return false;
  }
  if(this.onTargetAdding != null && !this.onTargetAdding(this, element)) return false;
  return element.style.visibility != "hidden";
 },
 removeInitialTarget: function(x, y) {
  var el = this.getTarget(x + ASPx.GetDocumentScrollLeft(), y + ASPx.GetDocumentScrollTop());
  if(el == null) return;
  this.removedX = ASPx.GetAbsoluteX(el);
  this.removedY = ASPx.GetAbsoluteY(el);
  this.removedWidth = el.offsetWidth;
  this.removedHeight = el.offsetHeight;
 },
 getTarget: function(x, y) {
  for(var i = 0; i < this.list.length; i++) {
   var record = this.list[i];
   if(record.contains(x, y)) {
    if(!this.onTargetAllowed || this.onTargetAllowed(record.targetElement, x, y))
     return record.targetElement;
   }
  }
  return null;
 },
 targetChanged: function(element, tag) {
  this.targetElement = element;
  this.targetTag = tag;
  if(this.onTargetChanging)
   this.onTargetChanging(this);
  if(this.oldtargetElement != this.targetElement || this.oldtargetTag != this.targetTag) {
   if(this.onTargetChanged)
    this.onTargetChanged(this);
   this.oldtargetElement = this.targetElement;
   this.oldtargetTag = this.targetTag;
  }
 },
 cancelChanging: function() {
  this.targetElement = this.oldtargetElement;
  this.targetTag = this.oldtargetTag;
 },
 isLeftPartOfElement: function() {
  if(this.targetElement == null) return true;
  var left = this.x - this.targetElementX();
  return left < this.targetElement.offsetWidth / 2;
 },
 isTopPartOfElement: function() {
  if(this.targetElement == null) return true;
  var top = this.y - this.targetElementY();
  return top < this.targetElement.offsetHeight / 2;
 },
 targetElementX: function() {
  return this.targetElement != null ? ASPx.GetAbsoluteX(this.targetElement) : 0;
 },
 targetElementY: function() {
  return this.targetElement != null ? ASPx.GetAbsoluteY(this.targetElement) : 0;
 },
 onmousemove: function(e) {
  this.doTargetChanged(e);
 },
 onmouseup: function(e) {
  this.doTargetChanged(e);
  currentCursorTargets = null;
 },
 doTargetChanged: function(e) {
  this.x = ASPx.Evt.GetEventX(e);
  this.y = ASPx.Evt.GetEventY(e);
  if(this.inRemovedBounds(this.x, this.y)) return;
  this.targetChanged(this.getTarget(this.x, this.y), 0);
 },
 inRemovedBounds: function(x, y) {
  if(this.removedWidth == 0) return false;
  return x > this.removedX && x < (this.removedX + this.removedWidth) &&
   y > this.removedY && y < (this.removedY + this.removedHeight);
 }
});
var CursorTarget = ASPx.CreateClass(null, {
 constructor: function(element) {
  this.element = element;
  this.targetElement = element;
  this.UpdatePosition();
 },
 contains: function(x, y) {
  return x >= this.absoluteX && x <= this.absoluteX + this.GetElementWidth() &&
   y >= this.absoluteY && y <= this.absoluteY + this.GetElementHeight();
 },
 GetElementWidth: function() {
  return this.element.offsetWidth;
 },
 GetElementHeight: function() {
  return this.element.offsetHeight;
 },
 UpdatePosition: function() {
  this.absoluteX = ASPx.GetAbsoluteX(this.element);
  this.absoluteY = ASPx.GetAbsoluteY(this.element);
 }
});
if(ASPx.Browser.MSTouchUI)
 ASPx.Evt.AttachEventToDocument(ASPx.TouchUIHelper.pointerCancelEventName, function(e) {
  if(ASPx.currentDragHelper != null) {
   ASPx.currentDragHelper.cancel(e);
   return true;
  }
 });
ASPx.Evt.AttachEventToDocument(ASPx.TouchUIHelper.touchMouseUpEventName, function(e) {
  if(ASPx.currentDragHelper != null) {
   ASPx.currentDragHelper.endDrag(e);
   return true;
  }
});
ASPx.Evt.AttachEventToDocument(ASPx.TouchUIHelper.touchMouseMoveEventName, function(e) {
 if(ASPx.currentDragHelper != null && !(ASPx.Browser.WebKitTouchUI && ASPx.TouchUIHelper.isGesture)) {
  ASPx.currentDragHelper.drag(e);
  if(ASPx.TouchUIHelper.isTouchEvent(e) && ASPx.currentDragHelper.canDrag) {
   e.preventDefault();
   ASPx.TouchUIHelper.preventScrollOnEvent(e);
  }
  return true;
 }
});
ASPx.Evt.AttachEventToDocument("keydown", function(e) {
 if(!ASPx.currentDragHelper) return;
 if(e.keyCode == ASPx.Key.Esc)
  ASPx.currentDragHelper.cancelDrag();
 return true;
});
ASPx.Evt.AttachEventToDocument("keyup", function(e) {
 if (!ASPx.currentDragHelper) return;
 if(e.keyCode == ASPx.Key.Esc && ASPx.Browser.WebKitFamily)
  ASPx.currentDragHelper.cancelDrag();
 return true;
});
ASPx.Evt.AttachEventToDocument("selectstart", function(e) {
 var drag = ASPx.currentDragHelper;
 if(drag && (drag.canDrag || drag.clearSelectionOnce)) {
  ASPx.Selection.Clear();
  drag.clearSelectionOnce = false;
  return false;
 }
});
ASPx.Evt.AttachEventToDocument(ASPx.TouchUIHelper.touchMouseUpEventName, function(e) { 
 if(currentCursorTargets != null) {
  currentCursorTargets.onmouseup(e);
  return true;
 }
});
ASPx.Evt.AttachEventToDocument(ASPx.TouchUIHelper.touchMouseMoveEventName, function(e) {
 if(currentCursorTargets != null) {
  currentCursorTargets.onmousemove(e);
  return true;
 }
});
ASPx.DragHelper = DragHelper;
ASPx.CursorTargets = CursorTargets;
ASPx.CursorTarget = CursorTarget;
})();
(function() {
var ASPxClientGridBase = ASPx.CreateClass(ASPxClientControl, {
 MainTableID: "DXMainTable",
 CustomizationWindowSuffix: "_custwindow",
 EditingRowID: "_DXEditingRow",
 EditingErrorItemID: "DXEditingErrorItem",
 BatchEditCellErrorTableID: "DXCErrorTable",
 EmptyHeaderSuffix: "_emptyheader", 
 PagerBottomID: "DXPagerBottom",
 PagerTopID: "DXPagerTop",
 SearchEditorID: "DXSE",
 EllipsisClassName: "dx-ellipsis",
 HeaderFilterButtonClassName: "dxgv__hfb",
 CommandColumnItemClassName: "dxgv__cci",
 ContextMenuItemImageMask: "dxGridView_gvCM",
 DetailGridSuffix: "dxdt",
 FixedColumnsDivID: "DXFixedColumnsDiv",
 FixedColumnsContentDivID: "DXFixedColumnsContentDiv",
 ProgressBarDisplayControlIDFormat: "PBc{0}i{1}",
 AccessibleFilterRowButtonID: "AFRB",
 ContextMenuItems: {
  FullExpand: "FullExpand",
  FullCollapse: "FullCollapse",
  SortAscending: "SortAscending",
  SortDescending: "SortDescending",
  ClearSorting: "ClearSorting",
  ShowFilterBuilder: "ShowFilterEditor",
  ShowFilterRow: "ShowFilterRow",
  ClearFilter: "ClearFilter",
  ShowFilterRowMenu: "ShowFilterRowMenu",
  GroupByColumn: "GroupByColumn",
  UngroupColumn: "UngroupColumn",
  ClearGrouping: "ClearGrouping",
  ShowGroupPanel: "ShowGroupPanel",
  ShowSearchPanel: "ShowSearchPanel",
  ShowColumn: "ShowColumn",
  HideColumn: "HideColumn",
  ShowCustomizationWindow: "ShowCustomizationWindow",
  ShowFooter: "ShowFooter",
  ExpandRow: "ExpandRow",
  CollapseRow: "CollapseRow",
  ExpandDetailRow: "ExpandDetailRow",
  CollapseDetailRow: "CollapseDetailRow",
  NewRow: "NewRow",
  EditRow: "EditRow",
  DeleteRow: "DeleteRow",
  Refresh: "Refresh",
  SummarySum: "SummarySum",
  SummaryMin: "SummaryMin",
  SummaryMax: "SummaryMax",
  SummaryAverage: "SummaryAverage",
  SummaryCount: "SummaryCount",
  SummaryNone: "SummaryNone",
  GroupSummarySum: "GroupSummarySum",
  GroupSummaryMin: "GroupSummaryMin",
  GroupSummaryMax: "GroupSummaryMax",
  GroupSummaryAverage: "GroupSummaryAverage",
  GroupSummaryCount: "GroupSummaryCount",
  GroupSummaryNone: "GroupSummaryNone",
  CustomItem: "CustomItem"
 },
 constructor: function(name){
  this.constructor.prototype.constructor.call(this, name);
  this.callBacksEnabled = true;
  this.custwindowLeft = null;
  this.custwindowTop = null;
  this.custwindowVisible = null;
  this.activeElement = null;
  this.filterKeyPressInputValue = "";
  this.userChangedSelection = false;
  this.lockFilter = true;
  this.confirmDelete = "";
  this.filterKeyPressTimerId = -1;
  this.filterRowMenuColumnIndex = -1;
  this.editorIDList = [ ];
  this.keys = [ ];
  this.lastMultiSelectIndex = -1;
  this.hasFooterRowTemplate = false;
  this.mainTableClickData = {
   processing: false,
   focusChanged: false,
   selectionChanged: false
  };
  this.afterCallbackRequired = false;
  this.headerFilterPopupDimensions = { };
  this.enableHeaderFilterCaching = true;
  this.postbackRequestCount = 0;
  this.supportGestures = true;
  this.checkBoxImageProperties = null;
  this.internalCheckBoxCollection = null;
  this.sizingConfig.adjustControl = true;
  this.lookupBehavior = false;
  this.clickedMenuItem = null;
  this.EmptyElementIndex = -1;
  this.currentCheckedItemIndex = -1;
  this.batchEditApi = this.CreateBatchEditApi();
  this.CustomButtonClick = new ASPxClientEvent();
  this.SelectionChanged = new ASPxClientEvent();
  this.ColumnSorting = new ASPxClientEvent();
  this.CustomizationWindowCloseUp = new ASPxClientEvent();
  this.InternalCheckBoxClick = new ASPxClientEvent();
  this.BatchEditStartEditing = new ASPxClientEvent();
  this.BatchEditEndEditing = new ASPxClientEvent();
  this.BatchEditConfirmShowing = new ASPxClientEvent();
  this.BatchEditTemplateCellFocused = new ASPxClientEvent();
  this.BatchEditChangesSaving = new ASPxClientEvent();
  this.BatchEditChangesCanceling = new ASPxClientEvent();
  this.funcCallbacks = [ ];
  this.pendingCommands = [ ];
  this.pageRowCount = 0;
  this.pageRowSize = 0;
  this.pageIndex = 0;
  this.pageCount = 1;
  this.allowFocusedRow = false;
  this.allowFocusedCell = false;
  this.allowSelectByItemClick = false;
  this.allowSelectSingleRowOnly = false;
  this.allowMultiColumnAutoFilter = false,
  this.focusedRowIndex = -1;
  this.selectedWithoutPageRowCount = 0;
  this.selectAllSettings = [ ];
  this.selectAllBtnStateWithoutPage = null;
  this.visibleStartIndex = 0;
  this.columns = [ ];
  this.columnResizeMode = ASPx.ColumnResizeMode.None;
  this.fixedColumnCount = 0;
  this.horzScroll = ASPx.ScrollBarMode.Hidden;
  this.vertScroll = ASPx.ScrollBarMode.Hidden;
  this.scrollToRowIndex = -1;
  this.useEndlessPaging = false;
  this.allowBatchEditing = false;
  this.batchEditClientState = { };
  this.resetScrollTop = false;
  this.callbackOnFocusedRowChanged = false;
  this.callbackOnSelectionChanged = false;
  this.autoFilterDelay = 1200;
  this.searchFilterDelay = 1200;
  this.allowSearchFilterTimer = true;
  this.editState = 0;
  this.kbdHelper = null;
  this.enableKeyboard = false;
  this.keyboardLock = false;
  this.accessKey = null;
  this.customKbdHelperName = null;
  this.endlessPagingHelper = null;
  this.icbFocusedStyle = null;
  this.pendingEvents = [ ];
  this.customSearchPanelEditorID = null;
  this.searchPanelFilter = null;
  this.isDetailGrid = null;
  this.rowHotTrackStyle = null;
  this.filterEditorState = [];
  this.sourceContextMenuRow = null;
  this.activeContextMenu = null;
  this.contextMenuActivating = false;
  this.updateButtonName = "";
  this.cancelButtonName = "";
  this.isAccessibleFilterRowMenu = false;
 },
 HasHorzScroll: function() { return this.horzScroll != ASPx.ScrollBarMode.Hidden; },
 HasVertScroll: function() { return this.vertScroll != ASPx.ScrollBarMode.Hidden; },
 HasScrolling: function() { return this.HasHorzScroll() || this.HasVertScroll(); },
 AllowResizing: function() { return this.columnResizeMode != ASPx.ColumnResizeMode.None; },
 GetRootTable: function() { return ASPx.GetElementById(this.name); },
 GetGridTD: function() { 
  var table = this.GetRootTable();
  if(!table) return null;
  return table.rows[0].cells[0];
 },
 GetArrowDragDownImage: function() { return this.GetChildElement("IADD"); },
 GetArrowDragUpImage: function() { return this.GetChildElement("IADU"); },
 GetArrowDragLeftImage: function() { return this.GetChildElement("IADL"); },
 GetArrowDragRightImage: function() { return this.GetChildElement("IADR"); },
 GetArrowDragFieldImage: function() { return this.GetChildElement("IDHF"); },
 GetEndlessPagingUpdatableContainer: function() { return this.GetChildElement("DXEPUC"); },
 GetEndlessPagingLPContainer: function() { return this.GetChildElement("DXEPLPC"); },
 GetBatchEditorsContainer: function() { return this.GetChildElement("DXBEsC"); },
 GetBatchEditorContainer: function(columnIndex) { return this.GetChildElement("DXBEC" + columnIndex); },
 GetBatchEditCellErrorTable: function() { return this.GetChildElement(this.BatchEditCellErrorTableID); },
 GetLoadingPanelDiv: function() {  return this.GetChildElement("LPD"); },
 GetFixedColumnsDiv: function() {  return this.GetChildElement(this.FixedColumnsDivID); },
 GettItem: function(visibleIndex) { return null; },
 GetDataItemIDPrefix: function() { },
 GetEmptyDataItemIDPostfix: function() { },
 GetEmptyDataItem: function() { return this.GetChildElement(this.GetEmptyDataItemIDPostfix()); },
 GetDataRowSelBtn: function(index) { return this.GetChildElement("DXSelBtn" + index); },
 GetSelectAllBtn: function(index) { return this.GetChildElement("DXSelAllBtn" + index); },
 GetMainTable: function() { return this.GetChildElement(this.MainTableID); },
 GetLoadingPanelContainer: function() { return this.GetChildElement("DXLPContainer"); },
 GetGroupPanel: function() { return this.GetChildElement("grouppanel"); },
 GetHeader: function(columnIndex, inGroupPanel) { 
  var id = "col" + columnIndex;
  if(inGroupPanel)
   id = "group" + id;
  return this.GetChildElement(id); 
 },
 GetHeaderRow: function(index) {
  return ASPx.GetElementById(this.name + ASPx.GridViewConsts.HeaderRowID + index);
 },
 GetEditingRow: function(obj) { return ASPx.GetElementById((obj ? obj.name : this.name) + this.EditingRowID); },
 GetEditingErrorItem: function(obj) { return ASPx.GetElementById((obj ? obj.name : this.name) + "_" + this.EditingErrorItemID); },
 GetEditFormTable: function() { return ASPx.GetElementById(this.name + "_DXEFT"); },
 GetEditFormTableCell: function() { return ASPx.GetElementById(this.name + "_DXEFC"); },
 GetCustomizationWindow: function() { return ASPx.GetControlCollection().Get(this.name + this.CustomizationWindowSuffix); },
 GetParentRowsWindow: function() { return ASPx.GetControlCollection().Get(this.name + "_DXparentrowswindow"); },
 GetEditorPrefix: function() { return "DXEditor"; },
 GetPopupEditForm: function() { return ASPx.GetControlCollection().Get(this.name  + "_DXPEForm"); },
 GetFilterRowMenu: function() { return ASPx.GetControlCollection().Get(this.name + "_DXFilterRowMenu"); },
 GetFilterRow: function() { return ASPx.GetControlCollection().Get(this.name + "_DXFilterRow"); },
 GetFilterControlPopup: function() { return ASPx.GetControlCollection().Get(this.name + "_DXPFCForm"); },
 GetFilterControl: function() { return ASPx.GetControlCollection().Get(this.name +  "_DXPFCForm_DXPFC"); }, 
 GetHeaderFilterPopup: function() { return ASPx.GetControlCollection().Get(this.name + "_DXHFP"); },
 GetHeaderFilterHelper:function(){
  if(!this.headerFilterHelper)
   this.headerFilterHelper = new ASPxClientGridHeaderFilterHelper(this);
  return this.headerFilterHelper;
 },
 IsEmptyHeaderID: function(id) { return false; },
 IsDataItem: function(visibleIndex) { return !!this.GetItem(visibleIndex); },
 GetGroupPanelContextMenu: function() { return ASPx.GetControlCollection().Get(this.name + "_DXContextMenu_GroupPanel"); },
 GetColumnContextMenu: function() { return ASPx.GetControlCollection().Get(this.name + "_DXContextMenu_Columns"); },
 GetRowContextMenu: function() { return ASPx.GetControlCollection().Get(this.name + "_DXContextMenu_Rows"); },
 GetFooterContextMenu: function() { return ASPx.GetControlCollection().Get(this.name + "_DXContextMenu_Footer"); },
 GetGroupFooterContextMenu: function() { return ASPx.GetControlCollection().Get(this.GetGroupFooterContextMenuName()); },
 GetGroupFooterContextMenuName: function() { return this.name + "_DXContextMenu_GroupFooter"; },
 GetSearchEditor: function() { 
  var editor = this.GetCustomSearchPanelEditor() || this.GetGridSearchEditor();
  if(editor && editor.GetMainElement())
   return editor;
  return null;
 },
 GetGridSearchEditor: function() { return ASPx.GetControlCollection().Get(this.name + "_" + this.SearchEditorID); },
 GetCustomSearchPanelEditor: function() { return ASPx.GetControlCollection().Get(this.customSearchPanelEditorID); },
 GetEditorByColumnIndex: function(colIndex) {
  var list = this._getEditors();
  for(var i = 0; i < list.length; i++) {
   if(this.tryGetNumberFromEndOfString(list[i].name).value === colIndex)
    return list[i];
  }
  return null;
 },
 GetProgressBarControlID: function(visibleIndex, columnIndex) { return ASPx.Str.ApplyReplacement(this.ProgressBarDisplayControlIDFormat, [["{0}", columnIndex], ["{1}", visibleIndex]]); },
 GetProgressBarControl: function(visibleIndex, columnIndex) { return ASPx.GetControlCollection().Get(this.name + "_" + this.GetProgressBarControlID(visibleIndex, columnIndex)); },
 CreateBatchEditApi: function() { },
 Initialize: function() {
  ASPxClientControl.prototype.Initialize.call(this);
  this.EnsureRowKeys();
  this._setFocusedItemInputValue();
  this.AddSelectStartHandler();
  if(this.isAccessibleFilterRowMenu)
   this.AddKeyDownFilterRowButtonHandler();
  this.EnsureRowHotTrackItems();
  if(this.checkBoxImageProperties){
   this.CreateInternalCheckBoxCollection();
   this.UpdateSelectAllCheckboxesState();
  }
  this.CheckPendingEvents();
  this.InitializeHeaderFilterPopup();
  this.CheckEndlessPagingLoadNextPage();
  this.PrepareCommandButtons();
  var batchEditHelper = this.GetBatchEditHelper();
  if(batchEditHelper)
   batchEditHelper.Init();
  var cellFocusHelper = this.GetCellFocusHelper();
  if(cellFocusHelper)
   cellFocusHelper.Update();
  this.EnsureSearchEditor();
  window.setTimeout(function() { 
   this.SaveAutoFilterColumnEditorState(); 
   this.lockFilter = false;
  }.aspxBind(this), 0);
  window.setTimeout(function() { this.EnsureVisibleRowFromServer(); }.aspxBind(this), 0);
  this.AssignEllipsisToolTips();
 },
 AttachEventToEditor: function(columnIndex, eventName, handler) {
  var editor = this.GetEditorByColumnIndex(columnIndex);
  if(!ASPx.Ident.IsASPxClientEdit(editor))
   return;
  var attachKeyDownToInput = eventName === "KeyDown" && this.IsCheckEditor(editor);
  if(!editor[eventName] && !attachKeyDownToInput)
   return;
  var duplicateAttachLocker = "dxgv" + eventName + "Assigned";
  if(editor[duplicateAttachLocker]) 
   return;
  if(attachKeyDownToInput)
   ASPx.Evt.AttachEventToElement(editor.GetFocusableInputElement(), "keydown", function(e) { handler(editor, { htmlEvent: e }); });
  else
   editor[eventName].AddHandler(handler);
  editor.dxgvColumnIndex = columnIndex;
  editor[duplicateAttachLocker] = true;
 },
 IsCheckEditor: function(editor) {
  return ASPx.Ident.IsASPxClientCheckEdit && ASPx.Ident.IsASPxClientCheckEdit(editor);
 },
 IsStaticBinaryImageEditor: function(editor) {
  return ASPx.Ident.IsStaticASPxClientBinaryImage && ASPx.Ident.IsStaticASPxClientBinaryImage(editor);
 },
 IsDetailGrid: function() { 
  if(this.isDetailGrid !== null)
   return this.isDetailGrid;
  var regTest = new RegExp(this.DetailGridSuffix + "[0-9]");
  this.isDetailGrid = regTest.test(this.name);
  if(this.isDetailGrid)
   return true;
  var mainElement = this.GetMainElement();
  var parent = mainElement.parentNode;
  while(parent && parent.tagName !== "BODY") {
   this.isDetailGrid = regTest.test(parent.id);
   if(this.isDetailGrid) return true;
   parent = parent.parentNode;
  }
  return false;
 },
 PrepareCommandButtons: function(){
  if(!this.cButtonIDs || this.cButtonIDs.length == 0) return;
  for(var i = 0; i < this.cButtonIDs.length; i++){
   var name = this.cButtonIDs[i];
   if(!ASPx.GetElementById(name)) continue;
   var button = new ASPxClientButton(name);
   button.cpGVName = this.name;
   button.useSubmitBehavior = false;
   button.causesValidation = false;
   button.isNative = !!eval(ASPx.Attr.GetAttribute(button.GetMainElement(), "data-isNative"));
   button.encodeHtml = !!eval(ASPx.Attr.GetAttribute(button.GetMainElement(), "data-encodeHtml"));
   button.enabled = !ASPx.ElementContainsCssClass(button.GetMainElement(), "dxbDisabled");
   button.Click.AddHandler(this.OnCommandButtonClick.aspxBind(this));
   button.InlineInitialize();
   this.PrepareBatchEditCommandButton(button);
  }
  delete this.cButtonIDs;
 },
 PrepareBatchEditCommandButton: function(button) {
  if(!this.allowBatchEditing)
   return;
  this.EnsureCommandButtonClickArgs(button);
  var commandName = button.gvClickArgs && button.gvClickArgs[0][0];
  if(commandName === "UpdateEdit")
   this.updateButtonName = button.name;
  if(commandName === "CancelEdit")
   this.cancelButtonName = button.name;
 },
 GetBatchEditCommandButtons: function() {
  var buttons = [];
  this.AddBatchEditCommandButton(buttons, this.cancelButtonName);
  this.AddBatchEditCommandButton(buttons, this.updateButtonName);
  return buttons;
 },
 AddBatchEditCommandButton: function(buttons, name) {
  var button = ASPx.GetControlCollection().Get(name);
  button && buttons.push(button);
 },
 EnsureCommandButtonClickArgs: function(button) {
  if(!button.gvClickArgs)
   button.gvClickArgs = eval(ASPx.Attr.GetAttribute(button.GetMainElement(), "data-args"));
 },
 OnCommandButtonClick: function(s, e){
  var mainElement = s.GetMainElement();
  if(!s.gvClickArgs)
   s.gvClickArgs = eval(ASPx.Attr.GetAttribute(mainElement, "data-args"));
  this.EnsureCommandButtonClickArgs(s);
  if(s.gvClickArgs && s.gvClickArgs.length > 1)
   this.ScheduleUserCommand(s.gvClickArgs[0], s.gvClickArgs[1], mainElement);
 },
 CheckEndlessPagingLoadNextPage: function() {
  window.setTimeout(function() {
   var scrollHelper = this.GetScrollHelper();
   if(this.useEndlessPaging && scrollHelper)
    scrollHelper.CheckEndlessPagingLoadNextPage();
  }.aspxBind(this), 0);
 },
 EnsureRowKeys: function() {
  if(ASPx.IsExists(this.stateObject.keys))
   this.keys = this.stateObject.keys;
  if(!this.keys)
   this.keys = [ ];
 }, 
 InitializeHeaderFilterPopup: function() {
  window.setTimeout(function() { this.InitializeHeaderFilterPopupCore(); }.aspxBind(this), 0);
 },
 InitializeHeaderFilterPopupCore: function() {
  var popup = this.GetHeaderFilterPopup();
  if(!popup)
   return;
  popup.PopUp.AddHandler(function() { this.OnPopUpHeaderFilterWindow(); }.aspxBind(this));
  popup.CloseUp.AddHandler(function(s) { 
   if(!this.UseHFContentCaching())
    window.setTimeout(function() { s.SetContentHtml(""); }, 0);
  }.aspxBind(this));
  popup.Resize.AddHandler(function(s) { 
   var colIndex = this.FindColumnIndexByHeaderChild(s.GetCurrentPopupElement());
   var column = this._getColumn(colIndex);
   if(!column) return;
   this.SetHeaderFilterPopupSize(colIndex, s.GetWidth(), s.GetHeight());
  }.aspxBind(this));
  var buttons = this.GetHeaderFilterButtons();
  for(var i = 0; i < buttons.length; i++)
   popup.AddPopupElement(buttons[i]);
 },
 GetHeaderFilterButtons: function() {
  var buttons = [ ];
  for(var i = 0; i < this.GetColumnsCount(); i++) {
   if(!this.GetColumn(i).visible)
    continue;
   this.PopulateHeaderFilterButtons(this.GetHeader(i, false), buttons);
   this.PopulateHeaderFilterButtons(this.GetHeader(i, true), buttons);
  }
  var custWindow = this.GetCustomizationWindow();
  if(custWindow)
   this.PopulateHeaderFilterButtons(custWindow.GetWindowClientTable(-1), buttons);
  return buttons;
 },
 PopulateHeaderFilterButtons: function(container, buttons) {
  if(!container) return;
  var images = container.getElementsByTagName("IMG");
  for(var i = 0; i < images.length; i++) {
   var button = ASPx.getSpriteMainElement(images[i]);
   if(ASPx.ElementContainsCssClass(button, this.HeaderFilterButtonClassName))
    buttons.push(button);
  }
 },
 UseHFContentCaching: function() {
  var helper = this.GetHeaderFilterHelper();
  var listBox = helper.GetListBox();
  return this.enableHeaderFilterCaching && (!helper.RenderExistsOnPage(listBox) || listBox.GetItemCount() < 1000);
 },
 OnPopUpHeaderFilterWindow: function() {
  var popup = this.GetHeaderFilterPopup();
  var colIndex = this.FindColumnIndexByHeaderChild(popup.GetCurrentPopupElement());
  var column = this._getColumn(colIndex);
  if(!column) return;
  var shiftKey = popup.GetPopUpReasonMouseEvent().shiftKey;
  var headerFilterHelper = this.GetHeaderFilterHelper();
  if(headerFilterHelper.column && headerFilterHelper.column.index == colIndex && this.UseHFContentCaching() && popup.savedShiftKey === shiftKey) {
   headerFilterHelper.RestoreState();
   return;
  }
  popup.savedShiftKey = shiftKey;
  this.gridFuncCallBack([ASPxClientGridViewCallbackCommand.FilterPopup, this.name, colIndex, shiftKey ? "T" : ""], headerFilterHelper.OnFilterPopupCallback);
  popup.SetContentHtml("");
  var buttonPanel = document.getElementById(popup.cpButtonPanelID);
  if(buttonPanel) {
   buttonPanel.style.display = column.HFCheckedList ? "" : "none";
   this.SetHFOkButtonEnabled(false);
  }
  var size = this.GetHeaderFilterPopupSize(colIndex);
  if(size) {
   popup.SetSize(size[0], size[1]);
   if(ASPx.Browser.Firefox)
    popup.Shown.AddHandler(function(s) { 
     window.setTimeout(function() { s.SetSize(size[0], size[1]); }, 0); 
    });
  }
  this.CreateLoadingPanelWithoutBordersInsideContainer(popup.GetContentContainer(-1));
 },
 SetHFOkButtonEnabled: function(enabled) {
  var popup = this.GetHeaderFilterPopup();
  if(!popup) return;
  var button = ASPx.GetControlCollection().Get(popup.cpOkButtonID);
  if(!button) return;
  button.SetEnabled(enabled);
 },
 GetHeaderFilterPopupSize: function(key) {
  var size = this.headerFilterPopupDimensions[key];
  if(size) return size;
  if(!this.headerFilterPopupDimensions["Default"]) {
   var popup = this.GetHeaderFilterPopup();
   this.SetHeaderFilterPopupSize("Default", popup.GetWidth(), popup.GetHeight());
  }
  return this.headerFilterPopupDimensions["Default"];
 },
 SetHeaderFilterPopupSize: function(key, width, height) {
  this.headerFilterPopupDimensions[key] = [ width, height ];
 },
 FindColumnIndexByHeaderChild: function(element) {
  if(!element) 
   return -1;
  var level = 0;
  while(level < 6) {
   var index = this.getColumnIndex(element.id);
   if(index > -1)
    return index;
   element = element.parentNode;
   level++;
  }
  return -1;
 },
 InitializeHeaderFilter: function(columnIndex){
  var helper = this.GetHeaderFilterHelper();
  helper.Initialize(columnIndex);
 },
 CheckPendingEvents: function() {
  if(this.pendingEvents.length < 1)
   return;
  for(var i = 0; i < this.pendingEvents.length; i++)
   this.ScheduleRaisingEvent(this.pendingEvents[i]);
  this.pendingEvents.length = 0;
 },
 ScheduleRaisingEvent: function(eventName) {
  window.setTimeout(function() { this[eventName](); }.aspxBind(this), 0);
 },
 CreateInternalCheckBoxCollection: function() {
  if(!this.internalCheckBoxCollection)
   this.internalCheckBoxCollection = new ASPx.CheckBoxInternalCollection(this.checkBoxImageProperties, true, undefined, undefined, undefined, this.accessibilityCompliant);
  else
   this.internalCheckBoxCollection.SetImageProperties(this.checkBoxImageProperties);
  this.CompleteInternalCheckBoxCollection();
 },
 CompleteInternalCheckBoxCollection: function() {
  if(!this.IsLastCallbackProcessedAsEndless()){
   this.internalCheckBoxCollection.Clear();
   for(var i = 0; i < this.selectAllSettings.length; i++){
    var selectAllSettings = this.selectAllSettings[i];
    var icbSelectAllElement = this.GetSelectAllBtn(selectAllSettings.index);
    if(ASPx.IsExistsElement(icbSelectAllElement))
     this.AddInternalCheckBoxToCollection(icbSelectAllElement, -(selectAllSettings.index + 1), !this.IsCheckBoxDisabled(icbSelectAllElement));
   }
  }
  for(var i = 0; i < this.pageRowCount; i ++) {
   var index = i + this.visibleStartIndex;
   var icbInputElement = this.GetDataRowSelBtn(index);
   if(icbInputElement) {
    var enabled = !this.IsCheckBoxDisabled(icbInputElement);
    this.AddInternalCheckBoxToCollection(icbInputElement, index, enabled);
   }
  }
 },
 IsCheckBoxDisabled: function(icbInputElement) {
  var icbMainElement = ASPx.CheckableElementHelper.Instance.GetICBMainElementByInput(icbInputElement);
  return icbMainElement.className.indexOf(this.GetDisabledCheckboxClassName()) != -1;
 },
 GetCssClassNamePrefix: function() { return ""; },
 GetDisabledCheckboxClassName: function() { return this.GetCssClassNamePrefix() + "_cd"; },
 AddInternalCheckBoxToCollection: function (icbInputElement, visibleIndex, enabled) {
  var internalCheckBox = null;
  if(this.IsLastCallbackProcessedAsEndless())
   internalCheckBox = this.internalCheckBoxCollection.Get(icbInputElement.id);
  if(internalCheckBox && internalCheckBox.inputElement != icbInputElement){
   this.internalCheckBoxCollection.Remove(icbInputElement.id);
   internalCheckBox = null;
  }
  if(!internalCheckBox)
   internalCheckBox = this.internalCheckBoxCollection.Add(icbInputElement.id, icbInputElement);
  internalCheckBox.CreateFocusDecoration(this.icbFocusedStyle);
  internalCheckBox.SetEnabled(enabled && this.GetEnabled());
  internalCheckBox.readOnly = this.readOnly;
  internalCheckBox.autoSwitchEnabled = !this.allowSelectSingleRowOnly;
  var grid = this;
  function OnCheckedChanged(s, e){
   if(!s.autoSwitchEnabled && s.GetValue() == ASPx.CheckBoxInputKey.Unchecked){
    var value = s.stateController.GetNextCheckBoxValue(s.GetValue(), s.allowGrayedByClick && s.allowGrayed);
    s.SetValue(value);
   }
   var rowCheckBox = grid.GetDataRowSelBtn(visibleIndex);
   if(grid.allowSelectSingleRowOnly)
    grid._selectAllSelBtn(false, rowCheckBox.id);
   if(!grid.RaiseInternalCheckBoxClick(visibleIndex)){
    grid.ScheduleCommand(function() { grid.SelectItem(visibleIndex, s.GetChecked()); }, true);
    grid.mainTableClickCore(e, true);
   }
  }
  function OnSelectAllCheckedChanged(s, e){
   grid.ScheduleCommand(function() {
    var index = grid.tryGetNumberFromEndOfString(s.inputElement.id).value;
    var columnSelectAllSettings = grid.GetColumnSelectAllSettings(index);
    if(!columnSelectAllSettings)
     return;
    switch(columnSelectAllSettings.mode){
     case 1:
      s.GetChecked() ? grid.SelectAllRowsOnPage() : grid.UnselectAllRowsOnPage();
      break;
     case 2:
      s.GetChecked() ? grid.SelectItemsCore(null, true, true) : grid.UnselectFilteredItemsCore(true);
      break;
    }
    grid.UpdateSelectAllCheckboxesState();
   }, true);
   grid.mainTableClickCore(e, true);
  }
  var checkedChangedHandler = visibleIndex < 0 ? OnSelectAllCheckedChanged : OnCheckedChanged;
  internalCheckBox.CheckedChanged.AddHandler(checkedChangedHandler);
 },
 GetColumnSelectAllSettings: function(index){
  for(var i = 0; i < this.selectAllSettings.length; i++){
   if(this.selectAllSettings[i].index == index)
    return this.selectAllSettings[i];
  }
 },
 SelectItemsCore: function(visibleIndices, selected, changedBySelectAll){
  if(!ASPx.IsExists(selected)) selected = true;
  if(!ASPx.IsExists(visibleIndices)) {
   selected = selected ? "all" : "unall";
   changedBySelectAll = ASPx.IsExists(changedBySelectAll) ? changedBySelectAll : false;
   visibleIndices = [ ];
  } else {
   changedBySelectAll = false;
   if(visibleIndices.constructor != Array)
    visibleIndices = [visibleIndices];
  }
  this.gridCallBack([ASPxClientGridViewCallbackCommand.SelectRows, selected, changedBySelectAll].concat(visibleIndices));
 },
 UnselectFilteredItemsCore: function(changedBySelectAll){
  if(!ASPx.IsExists(changedBySelectAll))
   changedBySelectAll = false;
  this.gridCallBack([ASPxClientGridViewCallbackCommand.SelectRows, "unallf", changedBySelectAll]);
 },
 AdjustControlCore: function() {
  ASPxClientControl.prototype.AdjustControlCore.call(this);
  this.UpdateScrollableControls();
  this.ApplyPostBackSyncData();
  this.AdjustPagerControls();
 },
 NeedCollapseControlCore: function() {
  return this.HasScrolling();
 },
 SerializeCallbackArgs: function(array) {
  if(!ASPx.IsExists(array) || array.constructor != Array || array.length == 0)
   return "";
  var sb = [ ];
  for(var i = 0; i < array.length; i++) {
   var item = array[i].toString();
   sb.push(item.length);
   sb.push('|');
   sb.push(item);
  }
  return sb.join("");
 }, 
 gridCallBack: function (args, handler) {
  this.OnBeforeCallbackOrPostBack();
  if(!this.callBack || !this.callBacksEnabled) {
   this.gridPostBack(args);
  } else {
   var serializedArgs = this.SerializeCallbackArgs(args); 
   var command = this.GetCorrectedCommand(args);
   this.OnBeforeCallback(command);
   var preparedArgs = this.prepareCallbackArgs(serializedArgs, this.GetGridTD());
   this.lockFilter = true;
   this.userChangedSelection = false;
   this.CreateCallback(preparedArgs, command, handler);
  }
 },
 gridPostBack: function(args) { 
  var serializedArgs = this.SerializeCallbackArgs(args); 
  this.postbackRequestCount++;
  this.SendPostBack(serializedArgs);
 },
 GetContextMenuInfo: function() {
  if(!this.clickedMenuItem)
   return "";
  var menu = this.clickedMenuItem.menu;
  var elementInfo = menu.elementInfo;
  return menu.cpType + "," + this.clickedMenuItem.indexPath + "," + elementInfo.index;
 },
 GetCorrectedCommand: function(args) {
  if(args.length == 0)
   return "";
  var command = args[0];
  if(args.length > 1 && command == ASPxClientGridViewCallbackCommand.ColumnMove) {
   if(args[args.length - 1])
    command = ASPxClientGridViewCallbackCommand.UnGroup;
   if(args[args.length - 2])
    command = ASPxClientGridViewCallbackCommand.Group;
  }
  return command;
 },
 GetFuncCallBackIndex: function(onCallBack) {
  var item = { date: new Date(), callback: onCallBack };
  for(var i = 0; i < this.funcCallbacks.length; i ++) {
   if(this.funcCallbacks[i] == null) {
    this.funcCallbacks[i] = item;
    return i;
   }
  }
  this.funcCallbacks.push(item);
  return this.funcCallbacks.length - 1;
 },
 GetFuncCallBack: function(index) {
  if(index < 0 || index >= this.funcCallbacks.length) return null;
  var result = this.funcCallbacks[index];
  this.funcCallbacks[index] = null;
  return result;
 },
 GetWaitedFuncCallbackCount: function() {
  var count = 0;
  for(var i = 0; i < this.funcCallbacks.length; i++)
   if(this.funcCallbacks[i] !== null) count++;
  return count;
 },
 gridFuncCallBack: function(args, onCallBack) {
  var serializedArgs = this.SerializeCallbackArgs(args); 
  var callbackArgs = this.formatCallbackArg("FB", this.GetFuncCallBackIndex(onCallBack).toString()) +
   this.prepareCallbackArgs(serializedArgs, null);
  this.CreateCallback(callbackArgs, "FUNCTION");
 }, 
 prepareCallbackArgs: function(serializedArgs, rootTD) {
  var preparedArgs =
   this.formatCallbackArg("EV", this.GetEditorValues(rootTD)) +
   this.formatCallbackArg("SR", this.GetSelectedState()) +
   this.formatCallbackArg("KV", this.GetKeyValues()) + 
   this.formatCallbackArg("FR", this.stateObject.focusedRow) +
   this.formatCallbackArg("CR", this.stateObject.resizingState) +
   this.formatCallbackArg("CM", this.GetContextMenuInfo()) +
   this.formatCallbackArg("GB", serializedArgs);
  return preparedArgs;
 },
 formatCallbackArg: function(prefix, arg) {
  if(!ASPx.IsExists(arg) || arg === "") return "";
  var s = arg.toString();
  return prefix + "|" + s.length + ';' + s + ';';
 },
 OnCallback: function (result) {
  var html = result.html;
  this.HideFilterControlPopup();
  var isFuncCallback = html.indexOf("FB|") == 0;
  this.afterCallbackRequired = !isFuncCallback; 
  if(isFuncCallback)
   this.OnFunctionalCallback(html);
  else {
   this.UpdateStateObjectWithObject(result.stateObject);
   if(this.RequirePartialUpdate(html))
    this.DoPartialUpdate(html);
   else
    this.SetRootTDInnerHtml(html);
  }
 },
 RequirePartialUpdate: function(html) {
  var helper = this.GetEndlessPagingHelper();
  return html.indexOf("EP|") == 0 && helper;
 },
 DoPartialUpdate: function(html) {
  var helper = this.GetEndlessPagingHelper();
  helper.OnCallback(html);
 },
 SetRootTDInnerHtml: function(html) {
  var rootTD = this.GetGridTD();
  if(rootTD)
   ASPx.SetInnerHtml(rootTD, html);
 },
 OnFunctionalCallback: function(result){
  this.PreventCallbackAnimation();
  var result = this.ParseFuncCallbackResult(result.substr(3));
  if(!result) return;
  if(this.IsHeaderFilterFuncCallback(result.callback))
   this.OnFuncCallback(result);
  else 
   window.setTimeout(function() { this.OnFuncCallback(result); }.aspxBind(this), 0);
 },
 OnCallbackFinalized: function() {
  if(this.afterCallbackRequired)
   this.OnAfterCallback();
 },
 IsHeaderFilterFuncCallback: function(callback) {
  return callback === this.GetHeaderFilterHelper().OnFilterPopupCallback;
 },
 ParseFuncCallbackResult: function(result) {
  var pos = result.indexOf("|");
  if(pos < 0) return;
  var index = parseInt(result.substr(0, pos), 10);
  var callbackItem = this.GetFuncCallBack(index);
  if(!callbackItem || !callbackItem.callback) return;
  result = result.substr(pos + 1);
  return { callback: callbackItem.callback, params: result };
 },
 OnFuncCallback: function(result) {
  if(result && result.callback)
   result.callback(eval(result.params));
 },
 OnCallbackError: function(result, data){
  this.showingError = result;
  this.errorData = data;
  if(this.GetGridTD())
   this.afterCallbackRequired = true;
 },
 ShowCallbackError: function(errorText, errorData) {
  var batchEditHelper = this.GetBatchEditHelper();
  if(batchEditHelper && batchEditHelper.ShowCallbackError(errorText, errorData))
   return;
  var displayIn = this;
  var popupForm = this.GetPopupEditForm();
  if(popupForm) {
   displayIn = popupForm;
   if(!popupForm.IsVisible()) {
    popupForm.Show();
   }
  }
  var errorTextContainer = this.GetErrorTextContainer(displayIn);
  if(errorTextContainer)
   errorTextContainer.innerHTML = errorText;
  else
   alert(errorText);
 },
 GetErrorTextContainer: function(displayIn) { },
 CreateEditingErrorItem: function() { },
 CancelCallbackCore: function() {
  this.RestoreCallbackSettings();
  this.AddSelectStartHandler();
  if(this.isAccessibleFilterRowMenu)
   this.AddKeyDownFilterRowButtonHandler();
  this.lockFilter = false;
  this.keyboardLock = false;
 },
 OnBeforeCallbackOrPostBack: function() {
  this.HidePopupEditForm();
  ASPxClientGridBase.SaveActiveElementSettings(this);
 },
 OnBeforeCallback: function(command) {
  this.keyboardLock = true;
  var endlessPagingHelper = this.GetEndlessPagingHelper();
  if(endlessPagingHelper)
   endlessPagingHelper.OnBeforeCallback(command);
  var scrollHelper = this.GetScrollHelper();
  if(scrollHelper)
   scrollHelper.OnBeforeCallback(command);
  this.ShowLoadingElements();
  this.SaveCallbackSettings();
  this.RemoveSelectStartHandler();
  var popup = this.GetHeaderFilterPopup();
  if(popup)
   popup.RemoveAllPopupElements();
 },
 OnAfterCallback: function() {
  this.clickedMenuItem = null;
  var checkBoxCollectionReinitializeRequired = true; 
  if(this.showingError) {
   checkBoxCollectionReinitializeRequired = false;
   this.ShowCallbackError(this.showingError, this.errorData);
      this.showingError = null;
   this.errorData = null;
    }
  this.pendingCommands = [ ];
  this.lockFilter = true;
  try {
   this._setFocusedItemInputValue();
   this.EnsureRowKeys();
   if(!this.IsLastCallbackProcessedAsEndless() && this.headerMatrix)
    this.headerMatrix.Invalidate();
   this.SetHeadersClientEvents();
   this.RestoreCallbackSettings();
   this.AddSelectStartHandler();
   if(this.isAccessibleFilterRowMenu)
    this.AddKeyDownFilterRowButtonHandler();
   this.EnsureRowHotTrackItems();
   if(this.kbdHelper && !this.useEndlessPaging)
    this.kbdHelper.EnsureFocusedRowVisible();
  }
  finally {
   window.setTimeout(function() { this.lockFilter = false; }.aspxBind(this), 0); 
   this.keyboardLock = false;
  }
  if(this.checkBoxImageProperties && checkBoxCollectionReinitializeRequired){
   this.CreateInternalCheckBoxCollection();
   this.UpdateSelectAllCheckboxesState();
  }
  this.CheckPendingEvents();
  this.InitializeHeaderFilterPopup();
  this.PrepareCommandButtons();
  var endlessPagingHelper = this.GetEndlessPagingHelper();
  if(endlessPagingHelper)
   endlessPagingHelper.OnAfterCallback();
  var batchEditHelper = this.GetBatchEditHelper();
  if(batchEditHelper)
   batchEditHelper.OnAfterCallback();
  var cellFocusHelper = this.GetCellFocusHelper();
  if(cellFocusHelper)
   cellFocusHelper.Update();
  this.CheckEndlessPagingLoadNextPage();
  this.EnsureSearchEditor();
  window.setTimeout(function() { this.SaveAutoFilterColumnEditorState(); }.aspxBind(this), 0);
  window.setTimeout(function() { this.EnsureVisibleRowFromServer(); }.aspxBind(this), 0);
  this.AssignEllipsisToolTips();
 },
 SaveAutoFilterColumnEditorState: function() {
  for(var i = 0; i < this.columns.length; i++) {
   var columnIndex = this.columns[i].index;
   this.filterEditorState[columnIndex] = this.GetAutoFilterEditorValue(columnIndex);
  }
 },
 GetAutoFilterEditorValue: function(columnIndex) {
  var editor = this.GetAutoFilterEditor(columnIndex);
  var editorValue = "";
  if(editor && editor.GetMainElement())
   editorValue = editor.GetValueString();
  return {
   value: editorValue,
   filterCondition: this.filterRowConditions ? this.filterRowConditions[columnIndex] : ""
  };
 },
 ClearAutoFilterState: function() {
  this.filterEditorState = [];
 },
 SaveCallbackSettings: function() {
  var custWindow = this.GetCustomizationWindow();
  if(custWindow != null) {
   var custWindowElement = custWindow.GetWindowElement(-1);
   if(custWindowElement) {
    this.custwindowLeft = ASPx.GetAbsoluteX(custWindowElement);
    this.custwindowTop = ASPx.GetAbsoluteY(custWindowElement);
    this.custwindowVisible = custWindow.IsVisible();
    var scroller = ASPx.GetElementById(custWindow.name + "_Scroller");
    this.custwindowScrollPosition = scroller.scrollTop;
   }
  } else {
   this.custwindowVisible = null;
  }
 },
 RestoreCallbackSettings: function() {
  var custWindow = this.GetCustomizationWindow();
  if(custWindow != null && this.custwindowVisible != null) {
   if(this.custwindowVisible){
    custWindow.LockAnimation();
    custWindow.ShowAtPos(this.custwindowLeft, this.custwindowTop);
    custWindow.UnlockAnimation();
    var scroller = ASPx.GetElementById(custWindow.name + "_Scroller");
    scroller.scrollTop = this.custwindowScrollPosition;
   }
  }
  this.ApplyPostBackSyncData();
  this.ResetControlAdjustment(); 
  ASPxClientGridBase.RestoreActiveElementSettings(this); 
 },
 HidePopupEditForm: function() {
  var popup = this.GetPopupEditForm();
  if(popup)
   popup.Hide();
 },
 OnPopupEditFormInit: function(popup) {
  if(this.HasHorzScroll() && this.GetVisibleItemsOnPage() > 0) {
   var popupHorzOffset = popup.GetPopupHorizontalOffset();
   popup.SetPopupHorizontalOffset(popupHorzOffset - this.GetPopupEditFormHorzOffsetCorrection(popup));
  }
  popup.Show();
 },
 GetPopupEditFormHorzOffsetCorrection: function(popup) {
  return 0;
 },
 _isRowSelected: function(visibleIndex) {
  if(!ASPx.IsExists(this.stateObject.selection)) return false;
  var index = this._getItemIndexOnPage(visibleIndex);
  return this._isTrueInCheckList(this.stateObject.selection, index);
 },
 _isTrueInCheckList: function(checkList, index) {
  if(index < 0 ||  index >= checkList.length) return false;
  return checkList.charAt(index) == "T";
 },
 _getSelectedRowCount: function() {
  return this.selectedWithoutPageRowCount + this._getSelectedRowCountOnPage();
 },
 _getSelectedRowCountOnPage: function(){
  if(!ASPx.IsExists(this.stateObject.selection))
   return 0;
  var checkList = this.stateObject.selection;
  var selCount = 0;
  for(var i = 0; i < checkList.length; i++) {
   if(checkList.charAt(i) == "T") selCount ++;
  }
  return selCount;
 },
 _selectAllRowsOnPage: function(checked) {
  if(checked && this.allowSelectSingleRowOnly) {
   this.SelectItem(0, true);
   return;
  }
  if(!ASPx.IsExists(this.stateObject.selection)) return;
  this._selectAllSelBtn(checked);
  var prevSelectedRowCount = 0;
  var isTrueInCheckList = false;
  for(var i = 0; i < this.pageRowCount; i ++) {
   isTrueInCheckList = this._isTrueInCheckList(this.stateObject.selection, i);
   if(isTrueInCheckList) prevSelectedRowCount++; 
   if(isTrueInCheckList != checked)
    this.ChangeItemStyle(i + this.visibleStartIndex, checked ? ASPxClientGridItemStyle.Selected : ASPxClientGridItemStyle.Item);
  }
  if (prevSelectedRowCount == 0 && !checked) return;
  var selValue = "";
  if(checked) {
   for(var i = 0; i < this.pageRowCount; i ++)
    selValue += this.IsDataItem(this.visibleStartIndex + i ) ? "T" : "F";
  }
  if(selValue != this.stateObject.selection) {
   this.userChangedSelection = true;
   if(selValue == "") selValue = "U";
   this.stateObject.selection = selValue;
  }
  this.DoSelectionChanged(-1, checked, true);
  this.UpdateSelectAllCheckboxesState();
 },
 DeleteGridItem: function(visibleIndex) {
  if(this.confirmDelete != "" && !confirm(this.confirmDelete)) return;
  this.DeleteItem(visibleIndex);
 },
 _selectAllSelBtn: function(checked, exceptName) {
  if(!this.checkBoxImageProperties) return;
  this.internalCheckBoxCollection.elementsMap.forEachEntry(function(key, checkBox) {
   if(key !== exceptName && checkBox.SetValue)
    checkBox.SetValue(checked ? ASPx.CheckBoxInputKey.Checked : ASPx.CheckBoxInputKey.Unchecked);
  });
 },
 doRowMultiSelect: function(row, rowIndex, evt) {
  var ctrlKey = evt.ctrlKey || evt.metaKey,
   shiftKey = evt.shiftKey;
  if((ctrlKey || shiftKey) && (!ASPx.Browser.IE || ASPx.Browser.Version > 8))
   ASPx.Selection.Clear();
  if(this.allowSelectSingleRowOnly)
   shiftKey = false;
  if(!ctrlKey && !shiftKey) {
   if(this._getSelectedRowCountOnPage() === 1 && this._isRowSelected(rowIndex))
    return;
   this._selectAllRowsOnPage(false);
   this.SelectItem(rowIndex, true);
   this.lastMultiSelectIndex = rowIndex;
  } else {
   if(ctrlKey) {
    this.SelectItem(rowIndex, !this._isRowSelected(rowIndex));
    this.lastMultiSelectIndex = rowIndex;
   } else {
    var startIndex = rowIndex > this.lastMultiSelectIndex ? this.lastMultiSelectIndex + 1 : rowIndex;
    var endIndex = rowIndex > this.lastMultiSelectIndex ? rowIndex : this.lastMultiSelectIndex - 1;
    for(var i = this.visibleStartIndex; i < this.pageRowCount + this.visibleStartIndex; i ++) {
     if(i == this.lastMultiSelectIndex) 
      continue;
     this.SelectItem(i, i >= startIndex && i <= endIndex);
    }
   }
  }
  this.UpdatePostBackSyncInput();
 },
 AddSelectStartHandler: function() {   
  if(!this.allowSelectByItemClick || !ASPx.Browser.IE || ASPx.Browser.Version > 8 )
   return;
  ASPx.Evt.AttachEventToElement(this.GetMainTable(), "selectstart", ASPxClientGridBase.SelectStartHandler);
 },
 AddKeyDownFilterRowButtonHandler: function() {
  var buttons = [];
  var filterRow = this.GetFilterRow();
  ASPx.GetNodesByPartialId(filterRow, this.AccessibleFilterRowButtonID, buttons);
  for(var i = 0; i < buttons.length; i++)
   ASPx.Evt.AttachEventToElement(buttons[i], "keydown", this.OnKeyDownFilterRowButton);
 },
 OnKeyDownFilterRowButton: function(e) {
  if(e.keyCode === ASPx.Key.Space ||
     e.keyCode === ASPx.Key.Enter ||
     (e.keyCode === ASPx.Key.Down && e.altKey)) {
   ASPx.Evt.PreventEvent(e);
   this.onclick(e.source);
  }
 },
 RemoveSelectStartHandler: function() {
  if(!this.allowSelectByItemClick || !ASPx.Browser.IE)
   return; 
  ASPx.Evt.DetachEventFromElement(this.GetMainTable(), "selectstart", ASPxClientGridBase.SelectStartHandler);
 },
 SelectItemsByKey: function(keys, selected){
  if(!ASPx.IsExists(selected)) selected = true;
  if(!ASPx.IsExists(keys)) return;
  if(keys.constructor != Array)
   keys = [keys];
  this.gridCallBack([ASPxClientGridViewCallbackCommand.SelectRowsKey, selected].concat(keys));
 },
 SelectItem: function(visibleIndex, checked, fromCheckBox) {
  if(!this.IsPossibleSelectItem(visibleIndex, checked)) return;
  if(ASPx.IsExists(fromCheckBox)) fromCheckBox = false;
  var index = this._getItemIndexOnPage(visibleIndex);
  if(index < 0) return;
  if(checked && this.allowSelectSingleRowOnly)
   this._selectAllRowsOnPage(false);
  if(ASPx.IsExists(this.stateObject.selection)) {
   this.userChangedSelection = true;
   var checkList = this.stateObject.selection;
   if(index >= checkList.length) {
    if(!checked) return;
    for(var i = checkList.length; i <= index; i ++)
     checkList += "F";
   }
   checkList = checkList.substr(0, index) + (checked ? "T" : "F") + checkList.substr(index + 1, checkList.length - index - 1);
   if(checkList.indexOf("T") < 0) checkList = "U";
   this.stateObject.selection = checkList;
  }
  var checkBox = this.GetDataRowSelBtn(visibleIndex);
  if(checkBox) {
   var internalCheckBox = this.internalCheckBoxCollection.Get(checkBox.id);
   internalCheckBox.SetValue(checked ? ASPx.CheckBoxInputKey.Checked : ASPx.CheckBoxInputKey.Unchecked);
  }
  this.UpdateSelectAllCheckboxesState();
  this.ChangeItemStyle(visibleIndex, checked ? ASPxClientGridItemStyle.Selected : ASPxClientGridItemStyle.Item);
  this.DoSelectionChanged(visibleIndex, checked, false);
 },
 IsPossibleSelectItem: function(visibleIndex, newSelectedValue){
  return visibleIndex > -1 && this._isRowSelected(visibleIndex) != newSelectedValue;
 },
 UpdateSelectAllCheckboxesState: function(){
  if(!this.selectAllSettings)
   return;
  for(var i = 0; i < this.selectAllSettings.length; i++){
   var columnSelectAllSettings = this.selectAllSettings[i];
   var selectAllButtonInput = this.GetSelectAllBtn(columnSelectAllSettings.index);
   if(selectAllButtonInput && !this.IsCheckBoxDisabled(selectAllButtonInput))
    this.UpdateSelectAllCheckboxStateCore(selectAllButtonInput, columnSelectAllSettings.mode);
  }
 },
 UpdateSelectAllCheckboxStateCore: function(selectAllButtonInput, selectMode){
  var value = ASPx.CheckBoxInputKey.Indeterminate;
  var selectedRowCountOnPage = this.GetSelectedKeysOnPage().length;
  var considerSelectionOnPages = selectMode == 2 && this.selectAllBtnStateWithoutPage !== null;
  if(this.GetDataItemCountOnPage() == selectedRowCountOnPage && (!considerSelectionOnPages || this.selectAllBtnStateWithoutPage == ASPx.CheckBoxInputKey.Checked))
   value = ASPx.CheckBoxInputKey.Checked;
  else if(selectedRowCountOnPage == 0 && (!considerSelectionOnPages || this.selectAllBtnStateWithoutPage == ASPx.CheckBoxInputKey.Unchecked))
   value = ASPx.CheckBoxInputKey.Unchecked;
  var selectAllCheckBoxInst = this.internalCheckBoxCollection.Get(selectAllButtonInput.id);
  selectAllCheckBoxInst.SetValue(value);
 },
 GetDataItemCountOnPage: function(){
  return this.pageRowCount;
 },
 ScheduleUserCommand: function(args, postponed, eventSource) {
  if(!args || args.length == 0) 
   return;
  var commandName = args[0];
  var rowCommands = this.GetUserCommandNamesForRow();
  if((this.useEndlessPaging || this.allowBatchEditing) && ASPx.Data.ArrayIndexOf(rowCommands, commandName) > -1)
   args[args.length - 1] = this.FindParentRowVisibleIndex(eventSource, true);
  postponed &= this.IsMainTableChildElement(eventSource);
  this.ScheduleCommand(args, postponed);
 },
 GetUserCommandNamesForRow: function() { return [ "CustomButton", "Select", "StartEdit", "Delete" ]; },
 IsMainTableChildElement: function(src) { return true; },
 FindParentRowVisibleIndex: function(element, dataAndGroupOnly) {
  var regEx = this.GetItemVisibleIndexRegExp(dataAndGroupOnly);
  while(element) {
   if(element.tagName === "BODY" || element.id == this.name)
    return -1;
   var matches = regEx.exec(element.id);
   if(matches && matches.length == 3)
    return parseInt(matches[2]);
   element = element.parentNode;
  }
  return -1;
 },
 GetItemVisibleIndexRegExp: function(dataAndGroupOnly) {
  return this.GetItemVisibleIndexRegExpByIdParts();
 },
 GetItemVisibleIndexRegExpByIdParts: function(idParts){
  if(!idParts) idParts = [ ];
  return new RegExp("^(" + this.name + "_(?:" + idParts.join("|") + "))(-?\\d+)(?:_\\d+)?$");
 },
 ScheduleCommand: function(args, postponed) {
  if(postponed)
   this.pendingCommands.push(args);
  else 
   this.PerformScheduledCommand(args);
 },
 PerformScheduledCommand: function(args) {
  if(ASPx.IsFunction(args)) {
   args(); 
   return;
  }
  if(args && args.length > 0) {
   var commandName = "UA_" + args[0];
   if(this[commandName])
    this[commandName].apply(this, args.slice(1));
  }
 },
 PerformPendingCommands: function() {
  var commandCount = this.pendingCommands.length;
  for(var i = 0; i < commandCount; i++)
   this.PerformScheduledCommand(this.pendingCommands.pop());
 },
 getItemByHtmlEvent: function(evt) {
  return null;
 },
 getItemByHtmlEventCore: function(evt, partialID) {
  var row = ASPx.GetParentByPartialId(ASPx.Evt.GetEventSource(evt), partialID);
  if(row && row.id.indexOf(this.name) > -1)
   return row;
  return null;
 },
 NeedProcessTableClick: function(evt) {
  var mainTable = ASPx.GetParentByPartialId(ASPx.Evt.GetEventSource(evt), this.MainTableID);
  if(mainTable) {
   var mainTableID = mainTable.id;
   var gridID = mainTableID.substr(0, mainTableID.length - this.MainTableID.length - 1);
   return this.name == gridID;
  }
  return false;
 },
 mainTableClick: function(evt) { this.mainTableClickCore(evt); },
 mainTableDblClick: function(evt) { 
  var row = this.getItemByHtmlEvent(evt);
  if(!row) return;
  var forceRowDblClickEvent = true;
  var rowIndex = this.getItemIndex(row.id);
  var batchEditHelper = this.GetBatchEditHelper();
  if(batchEditHelper){
   batchEditHelper.ProcessTableClick(row, ASPx.Evt.GetEventSource(evt), true);
   forceRowDblClickEvent = batchEditHelper.editRowVisibleIndex != rowIndex;
  }
  if(forceRowDblClickEvent)
   this.RaiseItemDblClick(rowIndex, evt);
 },
 mainTableClickCore: function(evt, fromCheckBox) {
  if(this.kbdHelper)
   this.kbdHelper.HandleClick(evt);
  var sendNotificationCallack = true;
  this.mainTableClickData.processing = true;
  try {
   this.ProcessTableClick(evt, fromCheckBox);
   var savedRequestCount = this.requestCount + this.postbackRequestCount;
   this.PerformPendingCommands();
   var currentRequestCount = this.requestCount + this.postbackRequestCount;
   sendNotificationCallack = currentRequestCount == savedRequestCount;
  } finally {
   if(sendNotificationCallack)
    if(this.mainTableClickData.focusChanged && !this.mainTableClickData.selectionChanged) {
     this.gridCallBack([ASPxClientGridViewCallbackCommand.FocusedRow]);
    } else if(this.mainTableClickData.selectionChanged) {
     this.gridCallBack([ASPxClientGridViewCallbackCommand.Selection]);
    }
   this.mainTableClickData.processing = false;
   this.mainTableClickData.focusChanged = false;
   this.mainTableClickData.selectionChanged = false;
  }
 },
 ProcessTableClick: function(evt, fromCheckBox) {
  var source = ASPx.Evt.GetEventSource(evt);
  var row = this.getItemByHtmlEvent(evt);
  if(row) {
   var itemIndex = this.getItemIndex(row.id);
   var isCommandColumnItem = this.IsCommandColumnItem(source);
   if(!isCommandColumnItem && !fromCheckBox) {
    var batchEditHelper = this.GetBatchEditHelper();
    if(batchEditHelper && batchEditHelper.ProcessTableClick(row, source))
     return;
    if(this.RaiseItemClick(itemIndex, evt)) 
     return;
   }
   var prevFocusedItemIndex = this._getFocusedItemIndex();
   if(this.allowFocusedRow)
    this._setFocusedItemIndex(itemIndex);
   if(this.allowSelectByItemClick) {
    if(!this.testActionElement(source) && !isCommandColumnItem && !fromCheckBox) {
     if(this.lookupBehavior){
      var checked = this.allowSelectSingleRowOnly || !this._isRowSelected(itemIndex);
      this.SelectItem(itemIndex, checked);
     } else {
      if(this.lastMultiSelectIndex < 0 && prevFocusedItemIndex > -1) {
       this.SelectItem(prevFocusedItemIndex, true);
       this.lastMultiSelectIndex = prevFocusedItemIndex;
      }
      this.doRowMultiSelect(row, itemIndex, evt);
     }
    }
   } else {
    this.lastMultiSelectIndex = itemIndex;
   }
  }
 },
 testActionElement: function(element) {
  return element && element.tagName.match(/input|select|textarea|^a$/i);
 },
 IsCommandColumnItem: function(element) {
  if(!element)
   return false;
  if(ASPx.ElementHasCssClass(element, this.CommandColumnItemClassName))
   return true;
  var elementId = element.parentNode.id;
  return ASPx.IsExists(elementId) && elementId.indexOf("DXCBtn") > -1 && elementId.indexOf(this.name) > -1;
 },
 _setFocusedItemIndex: function(visibleIndex) {
  if(visibleIndex < 0) 
   visibleIndex = -1;
  if(!this.allowFocusedRow || visibleIndex == this.focusedRowIndex) 
   return;
  var oldIndex = this.focusedRowIndex;
  this.focusedRowIndex = visibleIndex;
  this.ChangeFocusedItemStyle(oldIndex, false);
  this.ChangeFocusedItemStyle(this.focusedRowIndex, true);
  this._setFocusedItemInputValue();
  if(this.callbackOnFocusedRowChanged) {
   this.UpdatePostBackSyncInput(true);
   if(!this.mainTableClickData.processing) {
    this.gridCallBack([ASPxClientGridViewCallbackCommand.FocusedRow]);
   } else {
    this.mainTableClickData.focusChanged = true;
   }
   return;
  }
  this.RaiseFocusedItemChanged();
 },
 ChangeFocusedItemStyle: function(visibleIndex, focused) {
  if(visibleIndex < 0) return;
  var itemStyle = this.GetFocusedItemStyle(visibleIndex, focused);
  this.ChangeItemStyle(visibleIndex, itemStyle);
 },
 GetFocusedItemStyle: function(visibleIndex, focused){
  if(focused)
   return ASPxClientGridItemStyle.FocusedItem;
  return this._isRowSelected(visibleIndex) ? ASPxClientGridItemStyle.Selected : ASPxClientGridItemStyle.Item;
 },
 GetFocusedCell: function() {
  var cellFocusHelper = this.GetCellFocusHelper()
  return cellFocusHelper &&  cellFocusHelper.GetFocusedCell();
 },
 SetFocusedCell: function(itemIndex, columnIndex) {
  var cellFocusHelper = this.GetCellFocusHelper()
  if(cellFocusHelper) 
   cellFocusHelper.SetFocusedCell(itemIndex, columnIndex);
 },
 _setFocusedItemInputValue: function() {
  if(ASPx.IsExists(this.stateObject.focusedRow)) 
   this.stateObject.focusedRow = this.focusedRowIndex;
 },
 _getFocusedItemIndex: function() {
  if(!this.allowFocusedRow) return -1;
  return this.focusedRowIndex;
 },
 getItemIndex: function(rowId) {   
  return this.tryGetNumberFromEndOfString(rowId).value;
 },
 tryGetNumberFromEndOfString: function(str) {
  var value = -1;
  var success = false;
  var n = str.length - 1;
  while(!isNaN(parseInt(str.substr(n), 10))) {
   value = parseInt(str.substr(n), 10);
   success = true;
   n--;
  }
  return { success: success, value: value };
 },
 GetSelectedState: function() {
  if(!this.userChangedSelection) return null;
  if(!ASPx.IsExists(this.stateObject.selection)) return null;
  return this.stateObject.selection;
 },
 GetKeyValues: function() {
  return ASPx.Json.ToJson(this.stateObject.keys);
 },
 UpdateItemsStyle: function() {
  var start = this.GetTopVisibleIndex();
  var end = start + this.GetVisibleItemsOnPage();
  for(var i = start; i < end; i++) 
   this.UpdateItemStyle(i, this.GetItemStyle(i));
 },
 UpdateItemStyle: function(visibleIndex) {
  this.ChangeItemStyle(visibleIndex, this.GetItemStyle(visibleIndex));
 },
 GetItemStyle: function(visibleIndex){
  var style = ASPxClientGridItemStyle.Item;
  if(this.allowFocusedRow && this._getFocusedItemIndex() == visibleIndex)
   style = ASPxClientGridItemStyle.FocusedItem;
  else if(this._isRowSelected(visibleIndex))
   style = ASPxClientGridItemStyle.Selected;
  return style;
 },
 ChangeItemStyle: function(visibleIndex, rowStyle) {
  if(!this.RequireChangeItemStyle(visibleIndex, rowStyle))
   return;
  var styleInfo = this.getItemStyleInfo(rowStyle);
  this.ApplyItemStyle(visibleIndex, styleInfo);
  var batchEditHelper = this.GetBatchEditHelper();
  if(batchEditHelper)
   batchEditHelper.OnItemStyleChanged(visibleIndex);
 },
 ApplyItemStyle: function(visibleIndex, styleInfo) {
  var item = this.GetItem(visibleIndex);
  this.ApplyElementStyle(item, styleInfo);
 },
 ApplyElementStyle: function(element, styleInfo){
  if(!ASPx.IsExists(element.initialClassName))
   element.initialClassName = element.className;
  if(!ASPx.IsExists(element.initialCssText))
   element.initialCssText = element.style.cssText;
  element.className = element.initialClassName;
  element.style.cssText = element.initialCssText;
  if(styleInfo) {
   element.className += " " + styleInfo.css;
   element.style.cssText += " " + styleInfo.style;
  }
 },
 RequireChangeItemStyle: function(visibleIndex, itemStyle){
  if(this._getFocusedItemIndex() == visibleIndex && itemStyle != ASPxClientGridItemStyle.FocusedItem && itemStyle != ASPxClientGridItemStyle.FocusedGroupItem)
   return false;
  return !!this.GetItem(visibleIndex);
 },
 _getItemIndexOnPage: function(visibleIndex) { 
  return visibleIndex - this.visibleStartIndex; 
 },
 getColumnIndex: function(colId) {
  if(this.IsEmptyHeaderID(colId))
   return -1;
  var index = this.tryGetNumberFromEndOfString(colId).value;
  var postfix = "col" + index;
  if(colId.lastIndexOf(postfix) == colId.length - postfix.length)
   return index;
  return -1;
 },
 getColumnObject: function(colId) {
  var index = this.getColumnIndex(colId);
  return index > -1 ? this._getColumn(index) : null;
 },
 _getColumnIndexByColumnArgs: function(column) {
  column = this._getColumnObjectByArg(column);
  if(!column) return null;
  return column.index;
 },
 _getColumnObjectByArg: function(arg) {
  if(!ASPx.IsExists(arg)) return null;
  if(typeof(arg) == "number") return this._getColumn(arg);
  if(ASPx.IsExists(arg.index)) return arg;
  var column = this._getColumnById(arg);
  if(column) return column;
  return this._getColumnByField(arg);  
 },
 _getColumnCount: function() { return this.columns.length; },
 _getColumn: function(index) { 
  if(index < 0 || index >= this.columns.length) return null;
  return this.columns[index];
 },
 _getColumnById: function(id) {
  if(!ASPx.IsExists(id)) return null;
  for(var i = 0; i < this.columns.length; i++) {
   if(this.columns[i].id == id) return this.columns[i];
  }
  return null;
 },
 _getColumnByField: function(fieldName) {
  if(!ASPx.IsExists(fieldName)) return null;
  for(var i = 0; i < this.columns.length; i++) {
   if(this.columns[i].fieldName == fieldName) return this.columns[i];
  }
  return null;
 },
 getItemStyleInfo: function(itemStyleType, columnIndex) {
  if(!this.styleInfo) return;
  if(ASPx.IsExists(columnIndex)) {
   var key = itemStyleType + columnIndex;
   if(this.styleInfo.hasOwnProperty(key))
    return this.styleInfo[key];
  }
  return this.styleInfo[itemStyleType];
 },
 DoSelectionChanged: function(index, isSelected, isSelectAllOnPage){
  if(this.callbackOnSelectionChanged) {
   this.UpdatePostBackSyncInput(true);
   if(!this.mainTableClickData.processing) {
    this.gridCallBack([ASPxClientGridViewCallbackCommand.Selection]);
   } else {
    this.mainTableClickData.selectionChanged = true;
   }
   return;
  }
  this.RaiseSelectionChanged(index, isSelected, isSelectAllOnPage, false);
 },
 CommandCustomButton:function(id, index) {
  var processOnServer = true;
  if(!this.CustomButtonClick.IsEmpty()) {
   var e = this.CreateCommandCustomButtonEventArgs(index, id);
   this.CustomButtonClick.FireEvent(this, e);
   processOnServer = e.processOnServer;
  }
  if(processOnServer)
   this.gridCallBack([ASPxClientGridViewCallbackCommand.CustomButton, id, index]);
 },
 CreateCommandCustomButtonEventArgs: function(index, id){
  return null;
 },
 HeaderMouseDown: function(element, e){
  if(!ASPx.Evt.IsLeftButtonPressed(e)) 
   return;
  var source = ASPx.Evt.GetEventSource(e);
  if(ASPx.ElementContainsCssClass(ASPx.getSpriteMainElement(source), this.HeaderFilterButtonClassName))
   return;
  if(this.TryStartColumnResizing(e, element))
   return;
  var canDrag = this.canDragColumn(element) && source.tagName != "IMG";
  var dragHelper = this.GetDragHelper();
  var drag = dragHelper.CreateDrag(e, element, canDrag);
  if(!canDrag && (e.shiftKey || e.ctrlKey))
   drag.clearSelectionOnce = true;
  dragHelper.CreateTargets(drag, e);
 },
 TryStartColumnResizing: function(e, headerCell) {
  return false;
 }, 
 OnParentRowMouseEnter: function(element) {
  if(this.GetParentRowsWindow() == null) return;
  if(this.GetParentRowsWindow().IsWindowVisible()) return;
  this.ParentRowsTimerId = window.setTimeout(function() {
   var gv = ASPx.GetControlCollection().Get(this.name);
   if(gv)
    gv.OnParentRowsTimer(element.id);
  }.aspxBind(this), 500);
 },
 OnParentRowsTimer: function(rowId) {
  var element = ASPx.GetElementById(rowId);
  if(element)
   this.ShowParentRows(element);
 },
 OnParentRowMouseLeave: function(evt) {
  ASPx.Timer.ClearTimer(this.ParentRowsTimerId);
  if(this.GetParentRowsWindow() == null) return;
  if(evt && evt.toElement) {
   if(ASPx.GetParentByPartialId(evt.toElement, this.GetParentRowsWindow().name) != null)
    return;
  }
  this.HideParentRows();
 },
 ShowParentRows: function(element) {
  this.ParentRowsTimerId = null;
  if(this.GetParentRowsWindow() != null) {
   this.GetParentRowsWindow().ShowAtElement(element);
  }
 },
 HideParentRows: function() {
  this.ParentRowsTimerId = null;
  if(this.GetParentRowsWindow() != null) {
   this.GetParentRowsWindow().Hide();
  }
 }, 
 canSortByColumn: function(headerElement) {
  return this.getColumnObject(headerElement.id).allowSort;
 },
 canGroupByColumn: function(headerElement) {
  return false;
 },
 canDragColumn: function(headerElement) {
  return false;
 },
 doPagerOnClick: function(id) {
  if(!ASPx.IsExists(id)) return;
  this.gridCallBack([ASPxClientGridViewCallbackCommand.PagerOnClick, id]);
 },
 CanHandleGesture: function(evt) {
  var source = ASPx.Evt.GetEventSource(evt);
  var table = this.GetMainTable();
  if(!table) return false;
  if(ASPx.GetIsParent(table, source))
   return !this.NeedPreventGestures(source, table);
  if(table.parentNode.tagName == "DIV" && ASPx.GetIsParent(table.parentNode, source))
   return ASPx.Browser.TouchUI || evt.offsetX < table.parentNode.clientWidth;
  return false;
 },
 AllowStartGesture: function() {
  return ASPxClientControl.prototype.AllowStartGesture.call(this) && 
   (this.AllowExecutePagerGesture(this.pageIndex, this.pageCount, 1) || this.AllowExecutePagerGesture(this.pageIndex, this.pageCount, -1));
 },
 AllowExecuteGesture: function(value) {
  return this.AllowExecutePagerGesture(this.pageIndex, this.pageCount, value);
 },
 ExecuteGesture: function(value, count) {
  this.ExecutePagerGesture(this.pageIndex, this.pageCount, value, count, function(arg) { this.doPagerOnClick(arg); }.aspxBind(this));
 },
 OnColumnFilterInputChanged: function(editor) {
  this.ApplyColumnAutoFilterCore(editor);
 },
 OnColumnFilterInputSpecKeyPress: function(editor, e) {
  if(e.htmlEvent) 
   e = e.htmlEvent;
  if(e.keyCode == ASPx.Key.Tab) 
   return true;
  if(e.keyCode == ASPx.Key.Enter) {
   ASPx.Evt.PreventEventAndBubble(e);
   window.setTimeout(function() {
     editor.Validate();
     if(this.allowMultiColumnAutoFilter)
      this.ApplyMultiColumnAutoFilter(editor);
     else
      this.ApplyColumnAutoFilterCore(editor);
    }.aspxBind(this), 0);
   return true;
  }
  if(e.keyCode == ASPx.Key.Delete && e.ctrlKey) {
   ASPx.Evt.PreventEventAndBubble(e);
   window.setTimeout(function() {
     editor.SetValue(null);
     if(!this.allowMultiColumnAutoFilter)
      this.ApplyColumnAutoFilterCore(editor);
    }.aspxBind(this), 0);
   return true;
  }
  return false;
 },
 OnColumnFilterInputKeyPress: function(editor, e) {
  if(this.OnColumnFilterInputSpecKeyPress(editor, e))
   return;
  this.ClearAutoFilterInputTimer();
  if(editor != this.FilterKeyPressEditor)
   this.filterKeyPressInputValue = editor.GetValueString();
  this.FilterKeyPressEditor = editor;
  this.filterKeyPressTimerId = window.setTimeout(function() {
   var gv = ASPx.GetControlCollection().Get(this.name);
   if(gv != null)
    gv.OnFilterKeyPressTick();
  }.aspxBind(this), this.autoFilterDelay);
 },
 ClearAutoFilterInputTimer: function() {
  this.filterKeyPressTimerId = ASPx.Timer.ClearTimer(this.filterKeyPressTimerId);
 },
 OnFilterKeyPressTick: function() {
  if(this.FilterKeyPressEditor) {
   this.ApplyColumnAutoFilterCore(this.FilterKeyPressEditor);
  }
 },
 ApplyColumnAutoFilterCore: function(editor) {
  if(this.lockFilter) return;
  this.ClearAutoFilterInputTimer();
  if(this.FilterKeyPressEditor && editor == this.FilterKeyPressEditor) {
   if(this.FilterKeyPressEditor.GetValueString() == this.filterKeyPressInputValue) return;
  }
  var column = this.getColumnIndex(editor.name);
  if(column < 0) return;
  this.SaveFilterEditorActiveElement(editor);
  this.AutoFilterByColumn(column, editor.GetValueString());
 },
 ApplyMultiColumnAutoFilter: function(editor) {
  if(this.lockFilter) return;
  this.SaveFilterEditorActiveElement(editor);
  var args = [];
  var modifiedValues = this.GetModifiedAutoFilterValues();
  for(var columnIndex in modifiedValues) {
   args.push(columnIndex);
   args.push(modifiedValues[columnIndex].value);
   args.push(modifiedValues[columnIndex].filterCondition);
  }
  if(args.length > 0)
   this.gridCallBack([ASPxClientGridViewCallbackCommand.ApplyMultiColumnFilter].concat(args));
 },
 SaveFilterEditorActiveElement: function(editor) {
  if(!editor) return;
  var columnIndex = this.getColumnIndex(editor.name);
  if(columnIndex < 0 && editor !== this.GetSearchEditor())
   return;
  this.activeElement = this.GetFilterEditorInputElement(editor);
 },
 GetFilterEditorInputElement: function(editor) {
  if(document.activeElement && !ASPx.Browser.VirtualKeyboardSupported) return document.activeElement;
  if(editor.GetInputElement) return editor.GetInputElement();
  return null;
 },
 GetModifiedAutoFilterValues: function() {
  var result = {};
  for(var i = 0; i < this.columns.length; ++i) {
   var columnIndex = this.columns[i].index;
   var editorState = this.GetAutoFilterEditorValue(columnIndex);
   var chachedEditorState = this.filterEditorState[columnIndex];
   if(chachedEditorState.value !== editorState.value || chachedEditorState.filterCondition !== editorState.filterCondition) {
    result[columnIndex] = {
     value: editorState.value != null ? editorState.value : "",
     filterCondition: editorState.filterCondition
    }
   }
  }
  return result;
 },
 EnsureSearchEditor: function() {
  var edit = this.GetSearchEditor();
  if(!edit) return;
  if(edit === this.GetCustomSearchPanelEditor())
   window.setTimeout(function() { edit.SetValue(this.searchPanelFilter) }.aspxBind(this), 0);
  if(edit.dxgvSearchGrid !== this) {
   edit.KeyDown && edit.KeyDown.AddHandler(function(s, e) {
     if(!this.IsValidInstance()) return;
     this.OnSearchEditorKeyDown(s, e);
    }.aspxBind(this));
   edit.ValueChanged && edit.ValueChanged.AddHandler(function(s, e) {
     if(!this.IsValidInstance()) return;
     this.OnSearchEditorValueChanged(s, e);
    }.aspxBind(this));
   edit.dxgvSearchGrid = this;
  }
  var isCustomEditorInsideTemplate = edit === this.GetCustomSearchPanelEditor() && ASPx.GetIsParent(this.GetMainElement(), edit.GetMainElement());
  this.searchEditorInitialValue = isCustomEditorInsideTemplate ? this.searchPanelFilter : edit.GetValueString(); 
 },
 OnSearchEditorKeyDown: function(s, e) {
  if(!e.htmlEvent) return;
  e = e.htmlEvent;
  var clearEditor = e.keyCode == ASPx.Key.Delete && e.ctrlKey;
  if(e.keyCode == ASPx.Key.Enter || clearEditor) {
   if(clearEditor)
    s.SetValue(null);
   this.ApplySearchFilterFromEditor(s);
   ASPx.Evt.PreventEventAndBubble(e);
   return;
  }
  this.CreateSearchFilterTimer(s);
 },
 OnSearchEditorValueChanged: function(s, e) {
  window.setTimeout(function() { this.ApplySearchFilterFromEditor(s);  }.aspxBind(this), 0)
 },
 CreateSearchFilterTimer: function(editor) {
  if(!this.allowSearchFilterTimer) return;
  this.ClearSearchFilterTimer();
  this.searchFilterTimer = window.setTimeout(function() { this.ApplySearchFilterFromEditor(editor);  }.aspxBind(this), this.searchFilterDelay);
 },
 ClearSearchFilterTimer: function() {
  this.searchFilterTimer = ASPx.Timer.ClearTimer(this.searchFilterTimer);
 },
 ApplySearchFilterFromEditor: function(edit) {
  this.ClearSearchFilterTimer();
  if(this.lockFilter) return;
  if(!this.GetMainTable() || !edit) 
   return;
  edit.Validate();
  if(!edit.GetIsValid()) 
   return;
  var value = edit.GetValueString();
  if(value === this.searchEditorInitialValue)
   return;
  this.SaveFilterEditorActiveElement(edit)
  this.ApplySearchPanelFilter(value);
 },
 ApplySearchPanelFilter: function(value) {
  if(!ASPx.IsExists(value))
   value = "";
  this.gridCallBack([ASPxClientGridViewCallbackCommand.ApplySearchPanelFilter, value]);
 },
 FilterRowMenuButtonClick: function(columnIndex, element) {
  var menu = this.GetFilterRowMenu();
  if(!menu) return;
  var column = this._getColumn(columnIndex);
  if(!column) return;
  var checkedItemIndex;
  for(var i = menu.GetItemCount() - 1; i >= 0; i--) {
   var item = menu.GetItem(i);
   var isItemChecked = item.name.substr(0, item.name.indexOf("|")) == this.filterRowConditions[columnIndex];
   item.SetChecked(isItemChecked);
   if(isItemChecked)
    checkedItemIndex = item.index;
   item.SetVisible(this.GetFilterRowMenuItemVisible(item, column));
  }
  menu.ShowAtElement(element);
  this.filterRowMenuColumnIndex = columnIndex;
  this.currentCheckedItemIndex = checkedItemIndex;
  if(this.accessibilityCompliant)
   menu.accessibleFocusElement = element;
 },
 GetFilterRowMenuItemVisible: function(item, column) {
  if(column.filterRowTypeKind) {
   var visible = item.name.indexOf(column.filterRowTypeKind) > -1;
   if(!visible && column.showFilterMenuLikeItem)
    return item.name.indexOf("L") > -1;
   return visible;
  }
  return false;
 },
 FilterRowMenuItemClick: function(item) {
  var itemName = item.name.substr(0, item.name.indexOf("|"));
  item.menu.OnLostFocus();
  if(this.allowMultiColumnAutoFilter)
   this.filterRowConditions[this.filterRowMenuColumnIndex] = parseInt(itemName);
  else if(this.currentCheckedItemIndex !== item.index) {
    var args = [this.filterRowMenuColumnIndex, itemName];
    this.gridCallBack([ASPxClientGridViewCallbackCommand.FilterRowMenu].concat(args));
  }
 },
 NeedShowLoadingPanelInsideEndlessPagingContainer: function() {
  var endlessPagingHelper = this.GetEndlessPagingHelper();
  return endlessPagingHelper && endlessPagingHelper.NeedShowLoadingPanelAtBottom();
 },
 ShowLoadingPanel: function() {
  var gridMainCell = this.GetGridTD();
  if(!gridMainCell)
   return;
  if(this.NeedShowLoadingPanelInsideEndlessPagingContainer()) {
   var container = this.GetEndlessPagingLPContainer();
   ASPx.SetElementDisplay(container, true);
   this.CreateLoadingPanelWithoutBordersInsideContainer(container);
   return;
  }
  var lpContainer = this.GetLoadingPanelContainer();
  if(lpContainer)
   this.CreateLoadingPanelInline(lpContainer);
  else
   this.CreateLoadingPanelWithAbsolutePosition(gridMainCell, this.GetLoadingPanelOffsetElement(gridMainCell));
 },
 ShowLoadingDiv: function () {
  if(!this.NeedShowLoadingPanelInsideEndlessPagingContainer())
   this.CreateLoadingDiv(this.GetGridTD());
 },
 GetCallbackAnimationElement: function() {
  var table = this.GetMainTable();
  if(table && table.parentNode && table.parentNode.tagName == "DIV")
   return table.parentNode;
  return table;
 },
 NeedPreventTouchUIMouseScrolling: function(element) {
  return this.NeedPreventGestures(element);
 },
 NeedPreventGestures: function(element, mainElement) {
  if(!ASPx.IsExists(mainElement)) {
   mainElement = this.GetMainElement();
   if(!ASPx.IsExists(mainElement) || !ASPx.GetIsParent(mainElement, element))
    return false;
  }
  var preventElement = this.IsHeaderChild(element) || this.IsActionElement(mainElement, element);
  if(preventElement)
   return true;
  return this.pageCount <= 1 ? !ASPx.Browser.MSTouchUI : false;
 },
 IsHeaderChild: function(source) {
  return false;
 },
 IsActionElement: function(mainElement, source) {
  return false;
 },
 _updateEdit: function() {
  var batchEditHelper = this.GetBatchEditHelper();
  if(batchEditHelper && !batchEditHelper.CanUpdate())
   return;
  if(!batchEditHelper && !this._validateEditors())
   return;
  if(batchEditHelper)
   batchEditHelper.OnUpdate();
  this.gridCallBack([ASPxClientGridViewCallbackCommand.UpdateEdit]);
 },
 _validateEditors: function() {
  var editors = this._getEditors();
  var isValid = true;
  if(editors.length > 0)
   isValid &= this._validate(editors);
  if(window.ASPxClientEdit)
   isValid &= ASPxClientEdit.ValidateEditorsInContainer(this.GetEditFormTable(), this.name);
  return isValid;
 },
 _validate: function(list) {
  var isValid = true;
  var firstInvalid = null;
  var edit;
  for(var i = 0; i < list.length; i ++) {
   edit = list[i];
   edit.Validate();
   isValid = edit.GetIsValid() && isValid;
   if(firstInvalid == null && edit.setFocusOnError && !edit.GetIsValid())
    firstInvalid = edit;
  }
  if (firstInvalid != null)
   firstInvalid.Focus();
  return isValid;
 },
 _getEditors: function() {
  var list = [ ];
  for(var i = 0; i < this.editorIDList.length; i++) {
   var editor = ASPx.GetControlCollection().Get(this.editorIDList[i]);
   if(editor && editor.enabled && editor.GetMainElement && ASPx.IsExistsElement(editor.GetMainElement())) {
    if(!editor.Validate || this.IsStaticBinaryImageEditor(editor)) 
     continue; 
    list.push(editor);
   }
  }
  return list;
 },
 GetEditorValues: function() {
  if(this.allowBatchEditing) return null;
  var list = this._getEditors();
  if(list.length == 0) return null;
  var res = list.length + ";";
  for(var i = 0; i < list.length; i ++) {
   res += this.GetEditorValue(list[i]);
  }
  return res;
 },
 GetEditorValue: function(editor) {
  var value = editor.GetValueString();
  var valueLength = -1;
  if(!ASPx.IsExists(value)) {
   value = "";
  } else {
   value = value.toString();
   valueLength = value.length;
  }
  return this.GetEditorIndex(editor.name) + "," + valueLength + "," + value + ";";
 },
 GetEditorIndex: function(editorId) {
  var i = editorId.lastIndexOf(this.GetEditorPrefix());
  if(i < 0) return -1;
  var result = editorId.substr(i + this.GetEditorPrefix().length);
  i = result.indexOf('_'); 
  return i > 0
   ? result.substr(0, i)
   : result;
 },
 GetBatchEditHelper: function() {
  if(!this.allowBatchEditing) return null;
  if(!this.batchEditHelper)
   this.batchEditHelper = this.CreateBatchEditHelper();
  return this.batchEditHelper;
 },
 CreateBatchEditHelper: function() { },
 GetScrollHelper: function() { return null; },
 GetDragHelper: function() {
  if(!this.dragHelper)
   this.dragHelper = new GridViewDragHelper(this);
  return this.dragHelper;
 },
 GetEndlessPagingHelper: function() {
  if(!this.useEndlessPaging) return null;
  if(!this.endlessPagingHelper)
   this.endlessPagingHelper = this.CreateEndlessPagingHelper();
  return this.endlessPagingHelper;
 },
 CreateEndlessPagingHelper: function() { return null; },
 GetCellFocusHelper: function() {
  if(!this.allowFocusedCell) return null;
  if(!this.cellFocusHelper)
   this.cellFocusHelper = this.CreateCellFocusHelper();
  return this.cellFocusHelper;
 },
 CreateCellFocusHelper: function() { return null; },
 GetCellStyleManager: function() {
  if(!this.cellStyleManager)
   this.cellStyleManager = new GridCellStyleManager(this);
  return this.cellStyleManager;
 },
 IsLastCallbackProcessedAsEndless: function() {
  var helper = this.GetEndlessPagingHelper();
  return helper && helper.endlessCallbackComplete;
 },
 UpdateScrollableControls: function() {
  var helper = this.GetScrollHelper();
  if(helper)
   helper.Update();
 },
 SetHeight: function(height) {
  var mainElemnt = this.GetMainElement();
  if(!ASPx.IsExistsElement(mainElemnt)) return;
  var scrollHelper = this.GetScrollHelper();
  if(scrollHelper)
   scrollHelper.SetHeight(height);
 },
 SetHeadersClientEvents: function() { },
 UpdatePostBackSyncInput: function(isChangedNotification) {
  if(!ASPx.IsExists(this.stateObject.lastMultiSelectIndex)) return;
  var selectedIndex = isChangedNotification ? -1 : this.lastMultiSelectIndex; 
  this.stateObject.lastMultiSelectIndex = selectedIndex;
 },
 ApplyPostBackSyncData: function() {
  if(!ASPx.IsExists(this.stateObject.lastMultiSelectIndex)) return;
  this.lastMultiSelectIndex = this.stateObject.lastMultiSelectIndex;
 },
 EnsureVisibleRowFromServer: function() {
  if(this.scrollToRowIndex < 0) return;
  this.MakeRowVisible(this.scrollToRowIndex);
  this.scrollToRowIndex = -1;
 },
 EnsureRowHotTrackItems: function() {
  if(this.rowHotTrackStyle == null) 
   return;
  var list = [ ];
  var rowIndices = this.GetRowHotTrackItemsRowIndices();
  for(var i = rowIndices.start; i < rowIndices.start + rowIndices.end; i++)
   list.push(this.GetDataItemIDPrefix() + i);
  if(list.length > 0)
   ASPx.AddHoverItems(this.name, [ [ [this.rowHotTrackStyle[0]], [this.rowHotTrackStyle[1]],  list ] ]);
 },
 GetRowHotTrackItemsRowIndices: function() {
  return {
   start: this.visibleStartIndex,
   end: this.pageRowCount
  };
 },
 OnContextMenuClick: function(e) {
  var showDefaultMenu = ASPx.EventStorage.getInstance().Load(e);
  if(showDefaultMenu)
   return showDefaultMenu;
  if(this.IsDetailGrid())
   ASPx.EventStorage.getInstance().Save(e, true);
  var args = this.GetContextMenuArgs(e);
  if(!args.objectType && !this.HasAnyContextMenu())
   return true;
  var menu = this.GetPreparedContextMenu(args);
  var showBrowserMenu = !menu && this.ContextMenu.IsEmpty();
  showBrowserMenu = this.RaiseContextMenu(args.objectType, args.index, e, menu, showBrowserMenu);
  if(menu && !showBrowserMenu) {
   this.ShowContextMenu(e, menu);
   return false;
  }
  return showBrowserMenu;
 },
 ShowContextMenu: function(mouseEvent, menu) {
  this.contextMenuActivating = true;
  this.HandleContextMenuHover(menu, mouseEvent);
  menu.ShowInternal(mouseEvent);
 },
 HandleContextMenuHover: function(menu, mouseEvent) {
  if(this.rowHotTrackStyle == null)
   return;
  this.activeContextMenu = menu;
  this.sourceContextMenuRow = this.getItemByHtmlEvent(mouseEvent);
  menu.CloseUp.AddHandler(function(s) { this.OnContextMenuCloseUp(s); }.aspxBind(this));
  ASPx.AddAfterClearHoverState( function(source, args) { this.OnClearHoverState(args.item, args.element, args.toElement); }.aspxBind(this));
 },
 OnClearHoverState: function(hoverItem, hoverElement, newHoverElement) {
  if(!this.activeContextMenu || !this.activeContextMenu.GetVisible() || !this.sourceContextMenuRow) {
   ASPx.RemoveClassNameFromElement(hoverElement, this.rowHotTrackStyle[0]);
   return;
  }
  if(this.sourceContextMenuRow.id === hoverElement.id) {
   var newHoverItem = hoverItem.Clone();
   newHoverItem.Apply(hoverElement);
  }
 },
 OnContextMenuCloseUp: function(e) {
  if(!this.sourceContextMenuRow || this.activeContextMenu.GetVisible()) return;
  var stateController = ASPx.GetStateController();
  if(!stateController) return;
  if(stateController.currentHoverElement !== this.sourceContextMenuRow)
   stateController.DoClearHoverState(this.sourceContextMenuRow, null);
  this.sourceContextMenuRow = null;
  this.activeContextMenu = null;
 },
 HasAnyContextMenu: function() {
  return this.GetGroupPanelContextMenu() || this.GetColumnContextMenu() || this.GetRowContextMenu() || this.GetFooterContextMenu();
 },
 GetPreparedContextMenu: function(args) { 
  var menuName = this.name + "_DXContextMenu_";
  var menu = null;
  switch(args.objectType) {
   case "grouppanel":
    menu = this.GetGroupPanelContextMenu();
    break;
   case "header":
   case "emptyheader":
    menu = this.GetColumnContextMenu();
    break;
   case "row":
   case "grouprow":
   case "emptyrow":
    menu = this.GetRowContextMenu();
    break;
   case "footer":
    menu = this.GetFooterContextMenu();
    break;
   case "groupfooter":
    menu = this.GetGroupFooterContextMenu();
    break;
  }
  if(menu)
   this.ActivateContextMenuItems(menu, args);
  return menu;
 },
 GetContextMenuArgs: function(e) {
  var objectTypes = this.GetContextMenuObjectTypes();
  var src = ASPx.Evt.GetEventSource(e);
  var element = src;
  while(element && element.tagName !== "BODY") {
   var id = element.id;
   element = element.parentNode;
   if(!id) continue;
   var indexInfo = this.tryGetNumberFromEndOfString(id);
   var index = indexInfo.success ? indexInfo.value : "";
   for(var partialID in objectTypes) {
    if(id == partialID + index) {
     var type = objectTypes[partialID];
     var isGroupFooter = type == "groupfooter";
     if(type == "footer" || isGroupFooter) {
      if(!isGroupFooter)
       index = this.GetFooterCellIndex(src);
      else
       index = this.GetGroupFooterCellIndex(src);
      if(index < 0)
       return { objectType: null, index: -1 };
     } else if(type == "emptyheader" || type == "grouppanel" || type == "emptyrow") {
      index = this.EmptyElementIndex;
     }
     return { objectType: type, index: index };
    }
   }
  }
  return { objectType: null, index: -1 };
 },
 GetContextMenuObjectTypes: function(){
  return { };
 },
 GetFooterCellIndex: function(element) {
  element = this.GetFooterCellElement(element, ASPx.GridViewConsts.FooterRowID);
  if(element == null)
   return -1;
  var matrix = this.GetHeaderMatrix();
  var leafIndex = element.cellIndex - this.GetFooterIndentCount(element.parentNode);
  var index = matrix.GetLeafIndices()[leafIndex];
  return ASPx.IsExists(index) ? index : -1;
 },
 GetGroupFooterCellIndex: function(element) {
  element = this.GetFooterCellElement(element, ASPx.GridViewConsts.GroupFooterRowID);
  return element != null ? this.GetColumnIndexByDataCell(element) : -1;
 },
 GetColumnIndexByDataCell: function(element) {
  return -1;
 },
 GetFooterCellElement: function(element, footerRowID) {
  var footerRowName = this.name + "_" + footerRowID;
  while(element.parentNode.id.indexOf(footerRowName) === -1) {
   if(element.tagName == "BODY")
    return null;
   element = element.parentElement;
  }
  return element;
 },
 GetFooterIndentCount: function(footerElement) {
  return ASPx.GetChildNodesByClassName(footerElement, "dxgvIndentCell").length;
 },
 ActivateContextMenuItems: function(menu, args) {
  menu.elementInfo = args;
  this.SyncMenuItemsInfoSettings(menu, args.index, menu.cpItemsInfo);
 },
 SyncMenuItemsInfoSettings: function(menu, groupElementIndex, itemsInfo) {
  for(var i = 0; i < menu.GetItemCount() ; ++i) {
   var item = menu.GetItem(i);
   var itemInfo = itemsInfo[item.indexPath];
   var visible = false, enabled = false, checked = false;
   visible = this.GetItemServerState(itemInfo[0], groupElementIndex);
   enabled = this.GetItemServerState(itemInfo[1], groupElementIndex);
   checked = this.GetItemServerState(itemInfo[2], groupElementIndex);
   if(item.name === this.ContextMenuItems.ShowCustomizationWindow)
    checked = this.IsCustomizationWindowVisible();
   item.SetVisible(visible);
   this.SetContextMenuItemEnabled(item, enabled);
   item.SetChecked(checked);
   if(visible && enabled && !checked)
    this.SyncMenuItemsInfoSettings(item, groupElementIndex, itemsInfo);
  }
 },
 SetContextMenuItemEnabled: function(item, enabled) {
  item.SetEnabled(enabled);
  var imageElement = item.GetImage();
  if(!ASPx.IsExists(imageElement))
   return;
  var itemImageClassName = this.FindContextMenuItemImageClass(imageElement);
  if(!itemImageClassName)
   return;
  var imageEnabled = itemImageClassName.indexOf("Disabled") == -1;
  if(enabled) {
   if(!imageEnabled)
    this.UpdateContextMenuImageClass(imageElement, itemImageClassName, itemImageClassName.replace("Disabled", ""));
  } else if(imageEnabled) {
   this.DisableContextMenuImage(item, imageElement, itemImageClassName);
  }
 },
 DisableContextMenuImage: function(item, imageElement, itemImageClassName) {
  var oldClass = itemImageClassName;
  var postfix = "";
  var newClass = "";
  if(oldClass) {
   var portions = oldClass.split("_");
   var length = portions.length;
   if(length > 2) postfix = portions[--length];
   portions[length - 1] = portions[length - 1] + "Disabled";
   newClass = portions.join("_");
  } else {
   newClass = this.ContextMenuItemImageMask + item.name + "Disabled" + postfix;
  }
  this.UpdateContextMenuImageClass(imageElement, itemImageClassName, newClass);
 },
 UpdateContextMenuImageClass: function(imageElement, remove, add) {
  ASPx.RemoveClassNameFromElement(imageElement, remove);
  ASPx.AddClassNameToElement(imageElement, add);
 },
 FindContextMenuItemImageClass: function(imageElement) {
  var regExp = new RegExp(this.ContextMenuItemImageMask + "\\w+\\b");
  var itemImageClassName = imageElement.className.match(regExp);
  if(!itemImageClassName || !itemImageClassName.length)
   return null;
  return itemImageClassName[0];
 },
 GetContextMenuItemChecked: function(item) {
  var itemInfo = item.menu.cpItemsInfo[item.indexPath];
  var elementIndex = item.menu.elementInfo.index;
  return this.GetItemServerState(itemInfo[2], elementIndex);
 },
 GetItemServerState: function(itemInfo,
  groupElementIndex) {
  var saveVisible = !!itemInfo[0];
  var indices = itemInfo.length === 1 ? [ ] : itemInfo[1];
  return ASPx.Data.ArrayIndexOf(indices, groupElementIndex) > -1 ? saveVisible : !saveVisible;
 },
 OnContextMenuItemClick: function(e) {
  var elementInfo = e.item.menu.elementInfo;
  this.clickedMenuItem = e.item;
  if(this.RaiseContextMenuItemClick(e, elementInfo))
   return true;
  this.ProcessContextMenuItemClick(e);
 },
 ProcessContextMenuItemClick: function(e){
  var item = e.item;
  var elementInfo = item.menu.elementInfo;
  switch(item.name) {
   case this.ContextMenuItems.FullExpand:
    this.ExpandAll();
    break;
   case this.ContextMenuItems.FullCollapse:
    this.CollapseAll();
    break;
   case this.ContextMenuItems.SortAscending:
    this.SortBy(elementInfo.index, "ASC", false);
    break;
   case this.ContextMenuItems.SortDescending:
    this.SortBy(elementInfo.index, "DSC", false);
    break;
   case this.ContextMenuItems.ClearSorting:
    this.SortBy(elementInfo.index, "NONE", false);
    break;
   case this.ContextMenuItems.ShowFilterBuilder:
    this.ShowFilterControl();
    break;
   case this.ContextMenuItems.ShowFilterRow:
    this.ContextMenuShowFilterRow(!this.GetContextMenuItemChecked(item));
    break;
   case this.ContextMenuItems.ClearFilter:
    this.AutoFilterByColumn(this.GetColumn(elementInfo.index));
    break;
   case this.ContextMenuItems.ShowFilterRowMenu:
    this.ContextMenuShowFilterRowMenu(!this.GetContextMenuItemChecked(item));
    break;
   case this.ContextMenuItems.ShowGroupPanel:
    this.ContextMenuShowGroupPanel(!this.GetContextMenuItemChecked(item));
    break;
   case this.ContextMenuItems.ShowSearchPanel:
    this.ContextMenuShowSearchPanel(!this.GetContextMenuItemChecked(item));
    break;
   case this.ContextMenuItems.ShowCustomizationWindow:
    if(!this.IsCustomizationWindowVisible())
     this.ShowCustomizationWindow();
    else
     this.HideCustomizationWindow();
    break;
   case this.ContextMenuItems.ShowFooter:
    this.ContextMenuShowFooter(!this.GetContextMenuItemChecked(item));
    break;
   case this.ContextMenuItems.ExpandRow:
    this.ExpandRow(elementInfo.index);
    break;
   case this.ContextMenuItems.CollapseRow:
    this.CollapseRow(elementInfo.index);
    break;
   case this.ContextMenuItems.ExpandDetailRow:
    this.ExpandDetailRow(elementInfo.index);
    break;
   case this.ContextMenuItems.CollapseDetailRow:
    this.CollapseDetailRow(elementInfo.index);
    break;
   case this.ContextMenuItems.NewRow:
    this.AddNewItem();
    break;
   case this.ContextMenuItems.EditRow:
    this.ContextMenuStartEditItem(elementInfo.index, e.item.menu);
    break;
   case this.ContextMenuItems.DeleteRow:
    this.DeleteGridItem(elementInfo.index);
    break;
   case this.ContextMenuItems.Refresh:
    this.Refresh();
    break;
   case this.ContextMenuItems.HideColumn:
    var groupped = ASPx.IsExists(this.GetHeader(elementInfo.index, true));
    this.MoveColumn(elementInfo.index, -1, false, false, groupped);
    break;
   case this.ContextMenuItems.ShowColumn:
    this.MoveColumn(elementInfo.index, elementInfo.index);
    break;
   case this.ContextMenuItems.SummarySum:
    this.ContextMenuSetSummary(item, elementInfo.index, 0);
    break;
   case this.ContextMenuItems.SummaryMin:
    this.ContextMenuSetSummary(item, elementInfo.index, 1);
    break;
   case this.ContextMenuItems.SummaryMax:
    this.ContextMenuSetSummary(item, elementInfo.index, 2);
    break;
   case this.ContextMenuItems.SummaryCount:
    this.ContextMenuSetSummary(item, elementInfo.index, 3);
    break;
   case this.ContextMenuItems.SummaryAverage:
    this.ContextMenuSetSummary(item, elementInfo.index, 4);
    break;
   case this.ContextMenuItems.SummaryNone:
    this.ContextMenuClearSummary(elementInfo.index);
    break;
   case this.ContextMenuItems.GroupSummarySum:
    this.ContextMenuSetGroupSummary(item, elementInfo.index, 0);
    break;
   case this.ContextMenuItems.GroupSummaryMin:
    this.ContextMenuSetGroupSummary(item, elementInfo.index, 1);
    break;
   case this.ContextMenuItems.GroupSummaryMax:
    this.ContextMenuSetGroupSummary(item, elementInfo.index, 2);
    break;
   case this.ContextMenuItems.GroupSummaryCount:
    this.ContextMenuSetGroupSummary(item, elementInfo.index, 3);
    break;
   case this.ContextMenuItems.GroupSummaryAverage:
    this.ContextMenuSetGroupSummary(item, elementInfo.index, 4);
    break;
   case this.ContextMenuItems.GroupSummaryNone:
    this.ContextMenuClearGroupSummary(elementInfo);
    break;
  }
 },
 ContextMenuStartEditItem: function(visibleIndex, menu) {
  var rowCells = this.GetRow(visibleIndex).children;
  var colIndex = -1;
  var menuLocationX = menu.GetMainElement().getBoundingClientRect().left;
  for(var i = 0; i < rowCells.length; ++i) {
   var cell = rowCells[i];
   if(cell.tagName !== "TD") continue;
   var cellRect = cell.getBoundingClientRect();
   if(cellRect.left > menuLocationX) break;
   if(menuLocationX > cellRect.left && menuLocationX < cellRect.right) {
    colIndex = i;
    break;
   }
  }
  this.StartEditItem(visibleIndex, colIndex);
 },
 RaiseContextMenuItemClick: function(e, itemInfo) {
  return false;
 },
 ProcessCustomContextMenuItemClick: function(item, usePostBack) {
  if(usePostBack) {
   this.clickedMenuItem = null;
   var menu = item.menu;
   this.gridPostBack([ASPxClientGridViewCallbackCommand.ContextMenu, "ItemClick", menu.cpType, item.indexPath, menu.elementInfo.index]);
  } else {
   this.gridCallBack([ASPxClientGridViewCallbackCommand.ContextMenu, ""]);
  }
 },
 ContextMenuShowGroupPanel: function(show) {
  this.gridCallBack([ASPxClientGridViewCallbackCommand.ContextMenu, "ShowGroupPanel", show ? 1 : 0]);
 },
 ContextMenuShowSearchPanel: function(show) {
  this.gridCallBack([ASPxClientGridViewCallbackCommand.ContextMenu, "ShowSearchPanel", show ? 1 : 0]);
 },
 ContextMenuShowFilterRow: function(show) {
  this.gridCallBack([ASPxClientGridViewCallbackCommand.ContextMenu, "ShowFilterRow", show ? 1 : 0]);
 },
 ContextMenuShowFilterRowMenu: function(show) {
  this.gridCallBack([ASPxClientGridViewCallbackCommand.ContextMenu, "ShowFilterRowMenu", show ? 1 : 0]);
 },
 ContextMenuShowFooter: function(show) {
  this.gridCallBack([ASPxClientGridViewCallbackCommand.ContextMenu, "ShowFooter", show ? 1 : 0]);
 },
 ContextMenuClearGrouping: function() {
  this.gridCallBack([ASPxClientGridViewCallbackCommand.ContextMenu, "ClearGrouping"]);
 },
 ContextMenuSetSummary: function(item, index, typeSummary) {
  var checkSummary = this.GetContextMenuItemChecked(item) ? 0 : 1;
  this.gridCallBack([ASPxClientGridViewCallbackCommand.ContextMenu, "SetSummary", index, typeSummary, checkSummary]);
 },
 ContextMenuSetGroupSummary: function(item, index, typeSummary, isGroupSummary) {
  var checkSummary = this.GetContextMenuItemChecked(item) ? 0 : 1;
  var isGroupFooterSummary = this.IsGroupFooterMenuItem(item) ? "1" : "0";
  this.gridCallBack([ASPxClientGridViewCallbackCommand.ContextMenu, "SetGroupSummary", index, typeSummary, checkSummary, isGroupFooterSummary]);
 },
 ContextMenuClearSummary: function(index) {
  this.gridCallBack([ASPxClientGridViewCallbackCommand.ContextMenu, "ClearSummary", index]);
 },
 ContextMenuClearGroupSummary: function(elementInfo) {
  var isGroupFooterSummary = elementInfo.objectType === "groupfooter" ? "1" : "0";
  this.gridCallBack([ASPxClientGridViewCallbackCommand.ContextMenu, "ClearGroupSummary", elementInfo.index, isGroupFooterSummary]);
 },
 IsGroupFooterMenuItem: function(item) {
  return item.menu.name === this.GetGroupFooterContextMenuName();
 },
 Focus: function() {
  if(this.kbdHelper)
   this.kbdHelper.Focus();
 },
 PerformCallback: function(args, onSuccess){
  if(!ASPx.IsExists(args)) args = "";
  this.gridCallBack([ASPxClientGridViewCallbackCommand.CustomCallback, args], onSuccess);
 },
 GetValuesOnCustomCallback: function(args, onCallBack) {
  this.gridFuncCallBack([ASPxClientGridViewCallbackCommand.CustomValues, args], onCallBack);
 },
 GotoPage: function(pageIndex){
  if(this.useEndlessPaging)
   return;
  this.gridCallBack([ASPxClientGridViewCallbackCommand.GotoPage, pageIndex]);
 },
 GetPageIndex: function(){
  return this.pageIndex;
 },
 GetPageCount: function(){
  return this.pageCount;
 },
 NextPage: function(){
  this.gridCallBack([ASPxClientGridViewCallbackCommand.NextPage]);
 },
 PrevPage: function(focusBottomRow){
  if(!this.useEndlessPaging)
   this.gridCallBack([ASPxClientGridViewCallbackCommand.PreviousPage, focusBottomRow ? "T" : "F"]);
 },
 IsLastPage: function() {
  return this.pageIndex === this.pageCount - 1;
 },
 GetItemKey: function(visibleIndex) {
  var arrayIndex = visibleIndex - this.visibleStartIndex;
  if(arrayIndex < 0 || arrayIndex > this.keys.length - 1) 
   return null;
  var key = this.keys[arrayIndex];
  if(key == "/^DXN")
   key = null;
  return key;
 },   
 StartEditItem: function(visibleIndex, columnIndex) {
  var batchEditHelper = this.GetBatchEditHelper();
  if(batchEditHelper) {
   batchEditHelper.StartEditCell(visibleIndex, columnIndex);
  } else {
   var key = this.GetItemKey(visibleIndex);
   if(key != null)
    this.StartEditItemByKey(key);
  }
 },
 StartEditItemByKey: function(key) {
  var batchEditHelper = this.GetBatchEditHelper();
  if(batchEditHelper)
   batchEditHelper.StartEditItemByKey(key);
  else
   this.gridCallBack([ASPxClientGridViewCallbackCommand.StartEdit, key]);
 },
 IsEditing: function() { return this.editState > 0; },
 IsNewItemEditing: function() { return this.editState > 1; },
 IsEditingItem: function(visibleIndex) { return this.editItemVisibleIndex === visibleIndex; },
 IsNewRowAtBottom: function() { return this.editState == 3; },
 UpdateEdit: function(){
  this._updateEdit();
 },
 CancelEdit: function() {
  var batchEditHelper = this.GetBatchEditHelper();
  if(batchEditHelper)
   batchEditHelper.CancelEdit();
  else
   this.gridCallBack([ASPxClientGridViewCallbackCommand.CancelEdit]);
 },
 AddNewItem: function(){
  var batchEditHelper = this.GetBatchEditHelper();
  if(batchEditHelper)
   batchEditHelper.AddNewItem();
  else 
   this.gridCallBack([ASPxClientGridViewCallbackCommand.AddNewRow]);
 },
 DeleteItem: function(visibleIndex){
  var batchEditHelper = this.GetBatchEditHelper();
  if(batchEditHelper) {
   batchEditHelper.DeleteItem(visibleIndex);
  } else {
   var key = this.GetItemKey(visibleIndex);
   if(key != null)
    this.DeleteItemByKey(key);
  }
 },
 DeleteItemByKey: function(key) {
  var batchEditHelper = this.GetBatchEditHelper();
  if(batchEditHelper)
   batchEditHelper.DeleteItemByKey(key);
  else
   this.gridCallBack([ASPxClientGridViewCallbackCommand.DeleteRow, key]);
 },
 Refresh: function(){
  var batchEditHelper = this.GetBatchEditHelper();
  if(batchEditHelper)
   batchEditHelper.CancelEdit();
  this.gridCallBack([ASPxClientGridViewCallbackCommand.Refresh]);
 },
 ApplyFilter: function(expression){
  expression = expression || "";
  this.gridCallBack([ASPxClientGridViewCallbackCommand.ApplyFilter, expression]);
 },
 ClearFilter: function () {
  this.ClearAutoFilterState();
  this.ApplyFilter();
 },
 GetAutoFilterEditor: function(column) { 
  var index = this._getColumnIndexByColumnArgs(column);
  if(!ASPx.IsExists(index)) return null;
  return ASPx.GetControlCollection().Get(this.name + "_DXFREditorcol" + index);
 },
 AutoFilterByColumn: function(column, val){
  var index = this._getColumnIndexByColumnArgs(column);
  if(!ASPx.IsExists(index)) return;
  if(!ASPx.IsExists(val)) val = "";  
  this.gridCallBack([ASPxClientGridViewCallbackCommand.ApplyColumnFilter, index, val]);
 },
 ApplyHeaderFilterByColumn: function(){
  this.GetHeaderFilterPopup().Hide();
  var helper = this.GetHeaderFilterHelper();
  if(helper.column)
   this.gridCallBack([ASPxClientGridViewCallbackCommand.ApplyHeaderColumnFilter, helper.column.index, ASPx.Json.ToJson(helper.GetCallbackValue())]);
 },
 SortBy: function(column, sortOrder, reset, sortIndex){
  if(this.RaiseColumnSorting(this._getColumnObjectByArg(column))) return;
  column = this._getColumnIndexByColumnArgs(column);
  if(!ASPx.IsExists(sortIndex)) sortIndex = "";
  if(!ASPx.IsExists(sortOrder)) sortOrder = "";
  if(!ASPx.IsExists(reset)) reset = true;
  this.gridCallBack([ASPxClientGridViewCallbackCommand.Sort, column, sortIndex, sortOrder, reset]);
 },
 MoveColumn: function(column, columnMoveTo, moveBefore, moveToGroup, moveFromGroup){
  if(!ASPx.IsExists(column)) return;
  if(!ASPx.IsExists(columnMoveTo)) columnMoveTo = -1;
  if(!ASPx.IsExists(moveBefore)) moveBefore = true;
  if(!ASPx.IsExists(moveToGroup)) moveToGroup = false;
  if(!ASPx.IsExists(moveFromGroup)) moveFromGroup = false;
  if(moveToGroup) {
   if(this.RaiseColumnGrouping(this._getColumnObjectByArg(column))) return;
  }
  column = this._getColumnIndexByColumnArgs(column);
  this.gridCallBack([ASPxClientGridViewCallbackCommand.ColumnMove, column, columnMoveTo, moveBefore, moveToGroup, moveFromGroup]);
 },
 IsCustomizationWindowVisible: function(){
  var custWindow = this.GetCustomizationWindow();
  return custWindow != null && custWindow.IsVisible();
 },
 ShowCustomizationWindow: function(showAtElement){
  var custWindow = this.GetCustomizationWindow();
  if(!custWindow) return;
  if(!showAtElement) showAtElement = this.GetMainElement();
  custWindow.ShowAtElement(showAtElement);
 },
 HideCustomizationWindow: function(){
  var custWindow = this.GetCustomizationWindow();
  if(custWindow != null) custWindow.Hide();
 },
 GetSelectedFieldValues: function(fieldNames, onCallBack) {
  this.gridFuncCallBack([ASPxClientGridViewCallbackCommand.SelFieldValues, fieldNames], onCallBack);
 },
 GetSelectedKeysOnPage: function() {
  var keys = [];
  for(var i = 0; i < this.pageRowCount; i++) {
   if(this._isRowSelected(this.visibleStartIndex + i))
    keys.push(this.keys[i]);
  }
  return keys; 
 },
 GetItemValues: function(visibleIndex, fieldNames, onCallBack) {
  this.gridFuncCallBack([ASPxClientGridViewCallbackCommand.RowValues, visibleIndex, fieldNames], onCallBack);
 },
 GetPageItemValues: function(fieldNames, onCallBack) {
  this.gridFuncCallBack([ASPxClientGridViewCallbackCommand.PageRowValues, fieldNames], onCallBack);
 },
 GetVisibleItemsOnPage: function() {
  var batchEditHelper = this.GetBatchEditHelper();
  if(batchEditHelper)
   return batchEditHelper.GetVisibleItemsOnPageCount();
  return this.pageRowCount;
 },
 GetTopVisibleIndex: function() {
  return this.visibleStartIndex;
 },
 GetColumnsCount: function() {
  return this.GetColumnCount();
 },
 GetColumnCount: function() {
  return this._getColumnCount();
 },
 GetColumn: function(index) {
  return this._getColumn(index);
 },
 GetColumnById: function(id) {
  return this._getColumnById(id);
 },
 GetColumnByField: function(fieldName) {
  return this._getColumnByField(fieldName);
 },
 GetEditor: function(column) {
  var columnObject = this._getColumnObjectByArg(column);
  return columnObject != null ? this.GetEditorByColumnIndex(columnObject.index) : null;
 },
 FocusEditor: function(column) {
  var editor = this.GetEditor(column);
  if(editor && editor.SetFocus) {
   editor.SetFocus();  
  }
 },
 GetEditValue: function(column) {
  var editor = this.GetEditor(column);
  return editor != null && editor.enabled ? editor.GetValue() : null;
 },
 SetEditValue: function(column, value) {
  var editor = this.GetEditor(column);
  if(editor != null && editor.enabled) {
   editor.SetValue(value);
  }
 },
 ShowFilterControl: function() {
  this.PreventCallbackAnimation();
  this.gridCallBack([ASPxClientGridViewCallbackCommand.ShowFilterControl]);
 },
 CloseFilterControl: function() {
  this.PreventCallbackAnimation();
  this.HideFilterControlPopup();
  this.gridCallBack([ASPxClientGridViewCallbackCommand.CloseFilterControl]);
 },
 HideFilterControlPopup: function() {
  var popup = this.GetFilterControlPopup();
  if(popup) popup.Hide();
 },
 ApplyFilterControl: function() {
  this.PreventCallbackAnimation();
  var fc = this.GetFilterControl();
  if(fc == null) return;
  if(!this.callBacksEnabled)
   this.HideFilterControlPopup();
  if(!fc.isApplied)
   fc.Apply(this);
 },
 SetFilterEnabled: function(isFilterEnabled) {
  this.gridCallBack([ASPxClientGridViewCallbackCommand.SetFilterEnabled, isFilterEnabled]);
 },
 GetVerticalScrollPosition: function() { return 0; },
 SetVerticalScrollPosition: function(value) { },
 RaiseSelectionChangedOutOfServer: function() {
  this.RaiseSelectionChanged(-1, false, false, true);
 },
 RaiseSelectionChanged: function(visibleIndex, isSelected, isAllRecordsOnPage, isChangedOnServer) {
  if(!this.SelectionChanged.IsEmpty()){
   var args = this.CreateSelectionEventArgs(visibleIndex, isSelected, isAllRecordsOnPage, isChangedOnServer);
   this.SelectionChanged.FireEvent(this, args);
   if(args.processOnServer) {
    this.gridCallBack([ASPxClientGridViewCallbackCommand.Selection]);
   }
  }
  return false; 
 },
 CreateSelectionEventArgs: function(visibleIndex, isSelected, isAllRecordsOnPage, isChangedOnServer){
  return null;
 },
 RaiseFocusedItemChanged: function() { return false; },
 RaiseColumnSorting: function(column) {
  if(!this.ColumnSorting.IsEmpty()){
   var args = this.CreateColumnCancelEventArgs(column);
   this.ColumnSorting.FireEvent(this, args);
   return args.cancel;
  }
  return false; 
 },
 CreateColumnCancelEventArgs: function(column){
  return null;
 },
 RaiseColumnGrouping: function(column) {
  return false; 
 },
 RaiseItemClick: function(visibleIndex, htmlEvent) {
  return false; 
 },
 RaiseItemDblClick: function(visibleIndex, htmlEvent) {
  return false; 
 },
 RaiseContextMenu: function(objectType, index, htmlEvent, menu, showBrowserMenu) {
  return false;
 },
 RaiseCustomizationWindowCloseUp: function() {
  if(!this.CustomizationWindowCloseUp.IsEmpty()){
   var args = new ASPxClientEventArgs();
   this.CustomizationWindowCloseUp.FireEvent(this, args);
  }
  return false; 
 },
 RaiseColumnMoving: function(targets) {
  return false;
 },
 RaiseBatchEditStartEditing: function(visibleIndex, column, rowValues) { return null; },
 RaiseBatchEditEndEditing: function(visibleIndex, rowValues) { return null; },
 RaiseBatchEditItemValidating: function(visibleIndex, validationInfo) { return null; },
 RaiseBatchEditConfirmShowing: function(requestTriggerID) { return false; },
 RaiseBatchEditTemplateCellFocused: function(columnIndex) { return false; },
 RaiseBatchEditChangesSaving: function(valuesInfo) { return false; },
 RaiseBatchEditChangesCanceling: function(valuesInfo) { return false; },
 RaiseBatchEditItemInserting: function(visibleIndex) { return false; },
 RaiseBatchEditItemDeleting: function(visibleIndex, itemValues) { return false; },
 RaiseInternalCheckBoxClick: function(visibleIndex) {
  if(!this.InternalCheckBoxClick.IsEmpty()){
   var args = {"visibleIndex": visibleIndex, cancel: false};
   this.InternalCheckBoxClick.FireEvent(this, args);
   return args.cancel;
  }
  return false;
 },
 UA_AddNew: function() {
  this.AddNewItem();
 },
 UA_StartEdit: function(visibleIndex) {
  this.StartEditItem(visibleIndex);
 },
 UA_Delete: function(visibleIndex) {
  this.DeleteGridItem(visibleIndex);
 },
 UA_UpdateEdit: function() {
  this.UpdateEdit();
 },
 UA_CancelEdit: function() {
  this.CancelEdit();
 },
 UA_CustomButton: function(id, visibleIndex) {
  this.CommandCustomButton(id, visibleIndex);
 },
 UA_Select: function(visibleIndex) {
  if(!this.lookupBehavior || this.allowSelectByItemClick){
   var selected = this.allowSelectSingleRowOnly || !this._isRowSelected(visibleIndex);
   this.SelectItem(visibleIndex, selected);
  }
 },
 UA_ClearFilter: function() {
  this.ClearFilter();
 },
 UA_ApplyMultiColumnAutoFilter: function() {
  this.ApplyMultiColumnAutoFilter();
 },
 UA_ApplySearchFilter: function() {
  this.ApplySearchFilterFromEditor(this.GetSearchEditor());
 },
 UA_ClearSearchFilter: function() {
  var editor = this.GetSearchEditor();
  if(editor)
   editor.SetValue(null);
  this.ApplySearchFilterFromEditor(this.GetSearchEditor());
 },
 ChangeCellInitialClass: function(cell, className, add) { this.GetCellStyleManager().ChangeCellInitialClass(cell, className, add); }
});
ASPxClientGridBase.Cast = ASPxClientControl.Cast;
var GridCellStyleManager = ASPx.CreateClass(null, {
 InitialStyleKey: "initial",
 BatchEditStylKey: "batchEdit",
 FocusedStyleKey: "focused",
 constructor: function(grid) {
  this.grid = grid;
 },
 SetBatchEditStyle: function(styleType, cell, columnIndex) { this.SetCellStyle(this.BatchEditStylKey, styleType, cell, columnIndex); },
 SetFocusedStyle: function(styleType, cell, columnIndex) { this.SetCellStyle(this.FocusedStyleKey, styleType, cell, columnIndex); },
 SetCellStyle: function(styleKey, styleType, cell, columnIndex) {
  if(!cell) return;
  this.EnsureCellStyles(cell);
  cell.appliedStyles[styleKey] = this.GetGridStyle(styleType, columnIndex);
  this.ApplyCellStyle(cell);
 },
 EnsureCellStyles: function(cell) {
  if(!cell.appliedStyles){
   cell.appliedStyles = { }; 
   cell.appliedStyles[this.InitialStyleKey] = this.CreateStyle(cell.className, cell.style.cssText);
   cell.appliedStyles[this.BatchEditStylKey] = null;
   cell.appliedStyles[this.FocusedStyleKey] = null;
  }
 },
 CreateStyle: function(className, cssText) {  
  return { className: className, cssText: cssText};
 },
 GetGridStyle: function(styleType, columnIndex) {
  if(!styleType) return null;
  var styleInfo = this.grid.getItemStyleInfo(styleType, columnIndex);
  if(!styleInfo) return null;
  return this.CreateStyle(styleInfo.css, styleInfo.style);
 },
 ApplyCellStyle: function(cell) {
  var className = "";
  var cssText = "";
  for(var key in cell.appliedStyles) {
   var style = cell.appliedStyles[key];
   if(!style) continue;
   if(ASPx.IsExists(style.className))
    className += " " + style.className;
   if(ASPx.IsExists(style.cssText))
    cssText += ";" + style.cssText;
  }
  cell.className = className;
  cell.style.cssText = cssText;
 },
 AddToBatchEditStyle: function(cell, styles) {
  if(!styles || !cell) return;
  var batchEditStyle = cell.appliedStyles[this.BatchEditStylKey];
  if(!batchEditStyle)
   batchEditStyle = this.CreateStyle();
  var cssText = batchEditStyle.cssText || "";
  for(var property in styles) {
   if(!styles.hasOwnProperty(property))
    continue;
   var value = styles[property];
   cssText +=  property + ":" +  value + (typeof (value) == "number" ? "px" : "") + ";";
  }
  batchEditStyle.cssText = cssText;
  this.ApplyCellStyle(cell);
 },
 ChangeCellInitialClass: function(cell, className, add) {
  if(!cell.appliedStyles)
   return;
  var hasClass = cell.appliedStyles.initial.className.indexOf(className) > -1;
  if(hasClass && !add)
    cell.appliedStyles.initial.className =  cell.appliedStyles.initial.className.replace(className, "");
  if(!hasClass && add)
    cell.appliedStyles.initial.className += " " + className;
 }
});
var ASPxClientGridColumnBase = ASPx.CreateClass(null, {
 constructor: function(name, index, fieldName, visible, allowSort, HFCheckedList) {
  this.name = name;
  this.id = name;
  this.index = index;
  this.fieldName = fieldName;
  this.visible = !!visible;
  this.allowSort = !!allowSort;
  this.HFCheckedList = !!HFCheckedList;
 }
});
var GridViewDragHelper = ASPx.CreateClass(null, {
 constructor: function(grid) {
  this.grid = grid;
 },
 CreateDrag: function(e, element, canDrag) {
  var drag = new ASPx.DragHelper(e, element, true);
  drag.centerClone = true;
  drag.canDrag = canDrag;  
  drag.grid = this.grid;
  drag.ctrl = e.ctrlKey;
  drag.shift = e.shiftKey;
  drag.onDragDivCreating = this.OnDragDivCreating;
  drag.onDoClick = this.OnDoClick;
  drag.onCloneCreating = this.OnCloneCreating;
  drag.onEndDrag = this.OnEndDrag;
  drag.onCancelDrag = this.OnCancelDrag;
  return drag;
 },
 PrepareTargetHeightFunc: function() {
  GridViewDragHelper.Target_GetElementHeight = null;
  var headerRowCount = this.grid.GetHeaderMatrix().GetRowCount();
  if(headerRowCount) {
   var row = this.grid.GetHeaderRow(headerRowCount - 1);
   var headerBottom = ASPx.GetAbsoluteY(row) + row.offsetHeight;
   GridViewDragHelper.Target_GetElementHeight = function() {
    return headerBottom - this.absoluteY;
   };
  }
 },
 CreateTargets: function(drag, e) {
  if(!drag.canDrag) return;
  var grid = this.grid;
  this.PrepareTargetHeightFunc();
  var targets = new ASPx.CursorTargets();
  targets.obj = drag.obj;
  targets.grid = grid;
  targets.onTargetCreated = this.OnTargetCreated;
  targets.onTargetChanging = this.OnTargetChanging;
  targets.onTargetChanged = this.OnTargetChanged;
  var scrollLeft = null, scrollRight;
  var scrollHelper = grid.GetScrollHelper();
  var scrollableControl = scrollHelper && scrollHelper.GetHorzScrollableControl();
  if(scrollableControl) {
   scrollLeft = ASPx.GetAbsoluteX(scrollableControl);
   scrollRight = scrollLeft + scrollableControl.offsetWidth;
  }
  var sourceColumn = grid.getColumnObject(drag.obj.id);
  var win = grid.GetCustomizationWindow();
  if(win && !sourceColumn.inCustWindow)
   this.AddDragDropTarget(targets, win.GetWindowClientTable(-1));
  for(var i = 0; i < grid.columns.length; i++) {
   var column = grid.columns[i];
   for(var grouped = 0; grouped <= 1; grouped++) {
    var targetElement = grid.GetHeader(column.index, !!grouped);
    if(!targetElement)
     continue;
    if(scrollLeft !== null) {
     var targetX = ASPx.GetAbsoluteX(targetElement);
     if(targetX < scrollLeft || targetX + targetElement.offsetWidth > scrollRight)
      continue;
    }
    if(this.IsValidColumnDragDropTarget(drag.obj, targetElement, sourceColumn, column))
     this.AddDragDropTarget(targets, targetElement);  
   }
  }
  this.AddAdaptivePanelTarget(targets, grid.GetAdaptiveHeaderPanel());
  this.AddAdaptivePanelTarget(targets, grid.GetAdaptiveGroupPanel());
  this.AddDragDropTarget(targets, grid.GetGroupPanel());
  this.AddDragDropTarget(targets, ASPx.GetElementById(grid.name + this.grid.EmptyHeaderSuffix));
 },
 IsValidColumnDragDropTarget: function(sourceElement, targetElement, sourceColumn, targetColumn) {
  if(sourceColumn == targetColumn)
   return false;
  if(sourceColumn.parentIndex == targetColumn.parentIndex)
   return true;
  if(sourceColumn.parentIndex == targetColumn.index) {
   return (sourceColumn.inCustWindow || this.IsGroupingTarget(sourceElement))
    && this.grid.GetHeaderMatrix().IsLeaf(targetColumn.index);
  }
  if(this.IsParentColumn(sourceColumn.index, targetColumn.index))
   return (sourceColumn.inCustWindow || this.IsGroupingTarget(sourceElement));
  if(this.IsGroupingTarget(targetElement))
   return true;
  if(this.IsValidAdaptiveTarget(sourceElement, targetElement, sourceColumn, targetColumn))
   return true;
  return false;
 },
 AddAdaptivePanelTarget: function(targets, panel) {
  if(!panel) return;
  this.AppendAdaptivePanelDragAreas(targets, panel);
  this.AddDragDropTarget(targets, panel);
 },
 AppendAdaptivePanelDragAreas: function(targets, panel) {
  panel.dragAreas = [ ];
  var headers = ASPx.GetNodesByPartialClassName(panel, ASPx.GridViewConsts.HeaderCellCssClass);
  if(headers.length === 0) 
   return;
  var rows = [ ];
  var row = [ headers[0] ];
  rows.push(row);
  for(var i = 0; i < headers.length - 1; i++) {
   var currentHeader = headers[i];
   var nextHeader = headers[i + 1];
   if(ASPx.GetAbsoluteY(currentHeader) !== ASPx.GetAbsoluteY(nextHeader)) {
    row = [ ];
    rows.push(row);
   }
   row.push(nextHeader);
  }
  for(var i = 0; i < rows.length; i++) {
   var row = rows[i];
   this.CreateDragArea(panel, row[0], targets, true);
   this.CreateDragArea(panel, row[row.length - 1], targets,  false);
  }
 },
 CreateDragArea: function(panel, target, targets, isLeft) {
  if(!this.ContainsTarget(targets, target)) 
   return; 
  var targetTop = ASPx.GetAbsolutePositionY(target);
  var area = { 
   target: target,
   isLeft: isLeft,
   top: targetTop,
   bottom: targetTop + target.offsetHeight,
   left: isLeft ? ASPx.GetAbsolutePositionX(panel) : ASPx.GetAbsolutePositionX(target) + target.offsetWidth,
   right: isLeft ? ASPx.GetAbsolutePositionX(target) :  ASPx.GetAbsolutePositionX(panel) + panel.offsetWidth
  };
  panel.dragAreas.push(area);
 },
 ContainsTarget: function(targets, target) {
  for(var i = 0; i < targets.list.length; i++) {
   if(targets.list[i].element == target)
    return true;
  }
  return false;
 },
 IsValidAdaptiveTarget: function(sourceElement, targetElement, sourceColumn, targetColumn) {
  this.EnsureAdaptiveTargetInfo(sourceElement, targetElement, sourceColumn, targetColumn);
  return !!targetElement.adaptiveInfo;
 },
 EnsureAdaptiveTargetInfo: function(sourceElement, targetElement, sourceColumn, targetColumn) {
  if(!this.IsAdaptiveHeaderTarget(targetElement))
   return;
  var matrix = this.grid.GetHeaderMatrix();
  var sourceLevel = matrix.GetColumnLevel(sourceColumn.index);
  var targetLevel = matrix.GetColumnLevel(targetColumn.index);
  targetElement.adaptiveInfo = null;
  if(targetLevel < 0 || sourceLevel >= targetLevel)
   return;
  var brother = this.FindColumnBrother(sourceColumn, targetColumn);
  if(!brother) 
   return;
  var leftLeaf = matrix.GetLeaf(brother.index, true);
  var rightLeaf = matrix.GetLeaf(brother.index, false);  
  if(targetColumn.index === leftLeaf || targetColumn.index === rightLeaf)
   targetElement.adaptiveInfo = { brotherIndex : brother.index, brotherHasOnlyOneLeaf: leftLeaf == rightLeaf, isLeftLeaf: targetColumn.index == leftLeaf };
 },
 FindColumnBrother: function(sourceColumn, targetColumn) {
  while(targetColumn && targetColumn.parentIndex !== sourceColumn.parentIndex)
   targetColumn = this.grid.GetColumn(targetColumn.parentIndex);
  return targetColumn;
 },
 AddDragDropTarget: function(targets, element) {
  element && targets.addElement(element);
 },
 IsAdaptiveHeaderPanelVisible: function() { return ASPx.IsElementDisplayed(this.grid.GetAdaptiveHeaderPanel()) },
 IsAdaptiveGroupPanelVisible: function() { return ASPx.IsElementDisplayed(this.grid.GetAdaptiveGroupPanel()) },
 IsDataHeaderTarget: function(element) { return element && element.id.indexOf(this.grid.name + "_col") == 0; },
 IsAdaptiveHeaderTarget: function(element) { return this.IsAdaptiveHeaderPanelVisible() && this.IsDataHeaderTarget(element) && element.adaptiveMoved; },
 IsAdaptivePanelTarget: function(element) { return element && (element == this.grid.GetAdaptiveHeaderPanel() || element == this.grid.GetAdaptiveGroupPanel()); },
 IsAdaptiveGroupHeaderTarget: function(element) { return this.IsAdaptiveGroupPanelVisible() && this.IsGroupHeaderTarget(element) && element.adaptiveMoved; },
 IsGroupHeaderTarget: function(element) {
  if(!element)
   return false;
  return element.id.indexOf(this.grid.name + "_groupcol") == 0;
 },
 IsGroupingTarget: function(element) { 
  return element == this.grid.GetGroupPanel() || this.IsGroupHeaderTarget(element) || element ==  this.grid.GetAdaptiveGroupPanel();
 },
 IsCustWindowTarget: function(element) {
  var win = this.grid.GetCustomizationWindow();
  return win && element == win.GetWindowClientTable(-1); 
 },
 OnDragDivCreating: function(drag, dragDiv) {
  var rootTable = drag.grid.GetRootTable();
  if(!dragDiv || !rootTable) return;
  dragDiv.className = rootTable.className;
  dragDiv.style.cssText = rootTable.style.cssText;
 },
 OnDoClick: function(drag) {
  window.setTimeout(function() {
   if(drag.grid.contextMenuActivating) {
    drag.grid.contextMenuActivating = false;
    return;
   }
   if(!drag.grid.canSortByColumn(drag.obj) || drag.grid.InCallback() && drag.grid.GetWaitedFuncCallbackCount() === 0) 
    return;
   drag.grid.SortBy(drag.grid.getColumnIndex(drag.obj.id), drag.ctrl ? "NONE" : "", !drag.shift && !drag.ctrl);
  }, 0);
 },
 OnCancelDrag: function(drag) {
  drag.grid.dragHelper.ChangeTargetImagesVisibility(false);
 },
 OnEndDrag: function(drag) {
  if(!drag.targetElement)
   return;
  var grid = drag.grid;
  var sourceElement = drag.obj;
  var targetElement = drag.targetElement;
  var sourceIndex = grid.getColumnIndex(sourceElement.id);
  var targetIndex =  grid.getColumnIndex(targetElement.id);
  var isLeft = drag.targetTag;
  if(grid.IsEmptyHeaderID(targetElement.id) || targetElement == grid.GetAdaptiveHeaderPanel())
   targetIndex = 0;
  if(grid.dragHelper.IsAdaptiveHeaderTarget(targetElement) && targetElement.adaptiveInfo) {
   targetIndex = targetElement.adaptiveInfo.brotherIndex;
   isLeft = !targetElement.adaptiveInfo.brotherHasOnlyOneLeaf ? targetElement.adaptiveInfo.isLeftLeaf : isLeft;
  }
  if(grid.rtl)
   isLeft = !isLeft;
  grid.MoveColumn(
   sourceIndex,
   targetIndex,
   isLeft,
   grid.dragHelper.IsGroupingTarget(targetElement),
   grid.dragHelper.IsGroupingTarget(sourceElement)
  );
 },
 OnCloneCreating: function(clone) {
  var table = document.createElement("table");
  table.cellSpacing = 0;
  if(this.obj.offsetWidth > 0)
   table.style.width = Math.min(200, this.obj.offsetWidth) + "px";
  if(this.obj.offsetHeight > 0)
   table.style.height = this.obj.offsetHeight + "px";
  var row = table.insertRow(-1);
  clone.style.borderLeftWidth = "";
  clone.style.borderTopWidth = "";
  clone.style.borderRightWidth = "";
  row.appendChild(clone);
  table.style.opacity = 0.80;
  table.style.filter = "alpha(opacity=80)"; 
  if(ASPx.IsElementRightToLeft(this.obj))
   table.dir = "rtl";
  return table;
 },
 OnTargetCreated: function(targets, targetObj) {
  var f = GridViewDragHelper.Target_GetElementHeight;
  var h = targets.grid.dragHelper;
  var el = targetObj.element;
  if(f && !h.IsCustWindowTarget(el) && !h.IsGroupingTarget(el) && !h.IsAdaptiveHeaderTarget(el) && !h.IsAdaptivePanelTarget(el))
   targetObj.GetElementHeight = f;
 },
 OnTargetChanging: function(targets) {
  if(!targets.targetElement)
   return;
  targets.targetTag = targets.isLeftPartOfElement();
  var grid = targets.grid;
  var grouping = false;
  if(targets.targetElement == grid.GetGroupPanel() || targets.targetElement == grid.GetAdaptiveGroupPanel()) {
   targets.targetTag = true;
   grouping = true;
  }  
  if(grid.dragHelper.IsGroupHeaderTarget(targets.targetElement)) {
   grouping = true;
  }
  if(grouping && !grid.canGroupByColumn(targets.obj))
   targets.targetElement = null;
   if(grid.dragHelper.IsAdaptivePanelTarget(targets.targetElement)) {
   var info = grid.dragHelper.GetAdaptivePanelTargetInfo(targets, targets.targetElement);
   targets.targetTag = info.isLeftSide;
   targets.targetElement = info.targetElement;
   targets.skipNeighbor = true;
  }
  if(targets.targetElement) {
   grid.RaiseColumnMoving(targets);
  }
 },
 GetAdaptivePanelTargetInfo: function(targets, panel) {
  var x = targets.x;
  var y = targets.y;
  for(var i = 0; i < panel.dragAreas.length; i++) {
   var dragArea = panel.dragAreas[i];
   if(x >= dragArea.left && x <= dragArea.right && y >= dragArea.top && y <= dragArea.bottom)
    return { targetElement: dragArea.target, isLeftSide: dragArea.isLeft };
  }
  return { targetElement: panel.children.length == 0 ? panel : null, isLeftSide: true };
 },
 OnTargetChanged: function(targets) {
  if(ASPx.currentDragHelper == null)
   return;
  var element = targets.targetElement;
  if(element == ASPx.currentDragHelper.obj)
   return;
  var grid = targets.grid;
  grid.dragHelper.ChangeTargetImagesVisibility(false);
  if(!element) {
   ASPx.currentDragHelper.targetElement = null;
   return;
  }
  ASPx.currentDragHelper.targetElement = element;
  ASPx.currentDragHelper.targetTag = targets.targetTag;
  var moveToGroup = grid.dragHelper.IsGroupingTarget(element);
  var moveToCustWindow = grid.dragHelper.IsCustWindowTarget(element);
  if(moveToCustWindow) {
   ASPx.currentDragHelper.addElementToDragDiv(grid.GetArrowDragFieldImage());
   return;
  }
  var info = grid.dragHelper.GetTargetChangedInfo(targets, moveToGroup);
  if(!info) {
   ASPx.currentDragHelper.targetElement = null;
   return;
  }
  var targetColumnIndex = info.targetColumnIndex;
  var isRightSide = info.isRightSide;
  var neighbor = targets.skipNeighbor ? null : info.neighbor;
  var position = { };
  var left = ASPx.GetAbsoluteX(element);
  if(element == grid.GetGroupPanel() || element == grid.GetAdaptiveHeaderPanel() || element == grid.GetAdaptiveGroupPanel()) {
   if(grid.rtl)
    left += element.offsetWidth;
  } else {
   if(isRightSide) {
    if(neighbor)
     left = ASPx.GetAbsoluteX(neighbor);
    else
     left += element.offsetWidth;
   }
  }
  position.left = left;
  position.right = left;
  position.top = ASPx.GetAbsoluteY(element);
  position.bottom = position.top;
  var dragColumn = grid._getColumn(grid.getColumnIndex(this.obj.id));
  var destColumn = grid._getColumn(grid.getColumnIndex(element.id));
  var moveParentColumn = !moveToGroup && dragColumn && destColumn && grid.dragHelper.IsParentColumn(dragColumn.index, destColumn.index);
  if(!moveParentColumn){
   var bottomElement = element;
   if(!moveToGroup && targetColumnIndex > -1)
    bottomElement = grid.GetHeader(grid.GetHeaderMatrix().GetLeaf(targetColumnIndex, !isRightSide, false));
   position.bottom = ASPx.GetAbsoluteY(bottomElement) + bottomElement.offsetHeight;
  }
  if(moveParentColumn){
   var rightElement = grid.dragHelper.GetChildHeaderElement(dragColumn.index, destColumn.index, false);
   position.right = ASPx.GetAbsoluteX(rightElement) + rightElement.offsetWidth;
   position.left = ASPx.GetAbsoluteX(grid.dragHelper.GetChildHeaderElement(dragColumn.index, destColumn.index, true));
  }
  grid.dragHelper.SetDragImagesPosition(position);
  grid.dragHelper.ChangeTargetImagesVisibility(true, position.top === position.bottom);
 },
 GetChildHeaderElement: function(parentIndex, childIndex, left){
  var grid = this.grid;
  var childColumnIndex = childIndex;
  var currentColumnIndex = childIndex;
  var getNextNeighborHeaderMatrixMethodName = "Get" + (left ? "Left" : "Right") + "Neighbor";
  while(ASPx.IsExists(currentColumnIndex) && this.IsParentColumn(parentIndex, currentColumnIndex)){
   childColumnIndex = currentColumnIndex; 
   currentColumnIndex = grid.GetHeaderMatrix()[getNextNeighborHeaderMatrixMethodName](childColumnIndex);
  }
  return grid.GetHeader(childColumnIndex);
 },
 IsParentColumn: function(parentIndex, columnIndex){
  var index = columnIndex;
  while(index >= 0 && index != parentIndex)
   index = this.grid.GetColumn(index).parentIndex;
  return index >= 0;
 },
 GetTargetChangedInfo: function(targets, moveToGroup) {
  var grid = targets.grid;
  var targetElement = targets.targetElement;
  var info = { 
   targetColumnIndex: grid.getColumnIndex(targetElement.id), 
   isRightSide: !targets.targetTag,
   neighbor: null
  };
  var matrix =  grid.GetHeaderMatrix();
  if(moveToGroup) {
   var method = info.isRightSide ^ grid.rtl ? "nextSibling" : "previousSibling";
   info.neighbor = grid.dragHelper.GetGroupNodeNeighbor(targetElement, method);
   if(info.neighbor && info.neighbor.id == ASPx.currentDragHelper.obj.id)
    return;
   return info;
  } 
  var isAdaptiveHeader = grid.dragHelper.IsAdaptiveHeaderTarget(targetElement);
  if(!isAdaptiveHeader && info.targetColumnIndex < 0)
   return info;
  if(isAdaptiveHeader && targetElement.adaptiveInfo) {
   info.targetColumnIndex = targetElement.adaptiveInfo.brotherIndex;
   info.isRightSide = !targetElement.adaptiveInfo.brotherHasOnlyOneLeaf ? !targetElement.adaptiveInfo.isLeftLeaf : info.isRightSide;
  }
  var method = info.isRightSide ^ grid.rtl ? "GetRightNeighbor" : "GetLeftNeighbor";
  var neighborIndex = matrix[method](info.targetColumnIndex, !isAdaptiveHeader);
  var sourceColumn = grid.getColumnObject(ASPx.currentDragHelper.obj.id);
  if(neighborIndex == sourceColumn.index && !sourceColumn.inCustWindow && !grid.dragHelper.IsGroupHeaderTarget(ASPx.currentDragHelper.obj))
   return;
  if(!isNaN(neighborIndex)){
   if(isAdaptiveHeader && !matrix.IsLeaf(neighborIndex))
    neighborIndex = matrix.GetLeaf(neighborIndex, info.isRightSide);
   info.neighbor = grid.GetHeader(neighborIndex);
  }
  return info;
 },
 GetGroupNodeNeighbor: function(element, method) {
  if(this.IsAdaptiveGroupHeaderTarget(element)) 
   return this.GetAdaptiveGroupNodeNeighbor(element, method);
  return this.GetGroupNodeNeighborCore(element, method, 2);
 },
 GetAdaptiveGroupNodeNeighbor: function(element, method) {   
  var headers = ASPx.GetNodesByPartialClassName(this.grid.GetAdaptiveGroupPanel(), ASPx.GridViewConsts.HeaderCellCssClass);
  var index = ASPx.Data.ArrayIndexOf(headers, element);
  if(index < 0) return null;   
  return method == "nextSibling" ? headers[index + 1] : headers[index - 1];
 },
 GetGroupNodeNeighborCore: function(element, method, distance) {
  var neighbor = element[method];
  if(neighbor && neighbor.nodeType == 1) {
   if(this.IsGroupingTarget(neighbor)) 
    return neighbor;
   if(distance > 1)
    return this.GetGroupNodeNeighborCore(neighbor, method, --distance);
  }
  return null;
 },
 ChangeTargetImagesVisibility: function(vis, horizontalArrows) {
  if(this.grid.GetArrowDragDownImage() == null) return;
  ASPx.SetElementVisibility(this.grid.GetArrowDragLeftImage(), vis && horizontalArrows);
  ASPx.SetElementVisibility(this.grid.GetArrowDragRightImage(), vis && horizontalArrows);
  ASPx.SetElementVisibility(this.grid.GetArrowDragDownImage(), vis && !horizontalArrows);
  ASPx.SetElementVisibility(this.grid.GetArrowDragUpImage(), vis && !horizontalArrows);
  if(ASPx.currentDragHelper != null)
   ASPx.currentDragHelper.removeElementFromDragDiv();
 },
 SetDragImagesPosition: function(position) {
  var downImage = this.grid.GetArrowDragDownImage();
  if(downImage && position.left == position.right) {
   ASPx.SetAbsoluteX(downImage, position.left - downImage.offsetWidth / 2);
   ASPx.SetAbsoluteY(downImage, position.top - downImage.offsetHeight);
  }
  var upImage = this.grid.GetArrowDragUpImage();
  if(upImage && position.left == position.right) {
   ASPx.SetAbsoluteX(upImage, position.left - upImage.offsetWidth / 2);
   ASPx.SetAbsoluteY(upImage, position.bottom);
  }
  var rightImage = this.grid.GetArrowDragRightImage();
  if(rightImage && position.left != position.right){
   ASPx.SetAbsoluteX(rightImage, position.left - rightImage.offsetWidth);
   ASPx.SetAbsoluteY(rightImage, position.top - rightImage.offsetHeight / 2);
  }
  var leftImage = this.grid.GetArrowDragLeftImage();
  if(leftImage && position.left != position.right){
   ASPx.SetAbsoluteX(leftImage, position.right);
   ASPx.SetAbsoluteY(leftImage, position.top - rightImage.offsetHeight / 2);
  }
 }
});
GridViewDragHelper.Target_GetElementHeight = null;
ASPxClientGridBase.SelectStartHandler = function(e) {
 if(ASPx.Evt.GetEventSource(e).tagName.match(/input|select|textarea/i))
  return;
 if(e.ctrlKey || e.shiftKey) {
  ASPx.Selection.Clear();
  ASPx.Evt.PreventEventAndBubble(e);
 }
};
ASPxClientGridBase.SaveActiveElementSettings = function(grid) {
 var element = grid.activeElement;
 grid.activeElement = null;
 ASPxClientGridBase.activeElementData = null;
 if (!element || !element.id || element.tagName != "INPUT" || !(ASPx.GetIsParent(grid.GetMainElement(), element) || element.id.indexOf(grid.name + "_") == 0))
  return;  
 ASPxClientGridBase.activeElementData = [ grid.name, element.id, ASPx.Selection.GetInfo(element).endPos ];
 if(typeof(Sys) != "undefined" && typeof(Sys.Application) != "undefined") {
  if(!ASPxClientGridBase.MsAjaxActiveElementHandlerAdded) {
   Sys.Application.add_load(function() { ASPxClientGridBase.RestoreActiveElementSettings(); } );
   ASPxClientGridBase.MsAjaxActiveElementHandlerAdded = true;
  }
 } 
};
ASPxClientGridBase.RestoreActiveElementSettings = function(grid) {
 var data = ASPxClientGridBase.activeElementData;
 if(!data || grid && data[0] != grid.name) return;
 var element = ASPx.GetElementById(data[1]);
 if(element) {
  window.setTimeout(function() {
   element.focus();
   ASPx.Selection.Set(element, data[2], data[2]);
  }, 0);
 }
 ASPxClientGridBase.activeElementData = null;
};
var ASPxClientGridItemStyle = {
 Item: "items",
 Selected: "sel",
 FocusedItem: "fi",
 FocusedGroupItem: "fgi",
 ErrorItemHtml: "ei",
 BatchEditCell: "bec",
 BatchEditModifiedCell: "bemc",
 BatchEditMergedModifiedCell: "bemergmc",
 FocusedCell: "fc"
};
var ASPxClientGridHeaderFilterHelper = ASPx.CreateClass(null, {
 constructor: function(grid){
  this.grid = grid;
  this.column = null;
  this.initSelectedIndices = [];
  this.initCalendarDates = {};
  this.initDateRangePickerRange = [];
  this.FilterMenuID = "HFFM";
  this.FilterMenuPostfix = "_" + this.FilterMenuID + "_GCTC";
 },
 GetPopup: function() { return this.grid.GetHeaderFilterPopup(); },
 GetSelectAllCheckBox: function() { return ASPx.GetControlCollection().Get(this.grid.name + "_HFSACheckBox"); },
 GetListBox: function() { return ASPx.GetControlCollection().Get(this.grid.name + "_HFListBox"); },
 GetCalendar: function(){ return ASPx.GetControlCollection().Get(this.grid.name + "_HFC"); },
 GetHeaderFilterFromDateEdit: function() { return ASPx.GetControlCollection().Get(this.grid.name + "_HFFDE"); },
 GetHeaderFilterToDateEdit: function() { return ASPx.GetControlCollection().Get(this.grid.name + "_HFTDE"); },
 GetFilterValuesSeparatorClassName: function() { return this.grid.GetCssClassNamePrefix() + "HFSD"; },
 OnFilterPopupCallback: function(values) {
  var grid = ASPx.GetControlCollection().Get(values[0]);
  if(!grid) return;
  var helper = grid.GetHeaderFilterHelper();
  helper.GetPopup().SetContentHtml(values[1], grid.enableCallbackAnimation);
  ASPx.GetControlCollection().ControlsInitialized.AddHandler(helper.OnControlsInitialized, helper);
 },
 OnControlsInitialized: function(){
  this.Initialize();
  ASPx.GetControlCollection().ControlsInitialized.RemoveHandler(this.OnControlsInitialized, this);
 },
 Initialize: function(){
  this.initSelectedIndices = [];
  this.initCalendarDates = {};
  this.initDateRangePickerRange = [];
  var columnIndex = this.grid.FindColumnIndexByHeaderChild(this.GetPopup().GetCurrentPopupElement());
  this.column = this.grid.GetColumn(columnIndex);
  this.InitializeListBox();
  this.InitializeSelectAllCheckBox();
  this.InitializeCalendar();
  this.InitializeDateRangePicker();
 },
 InitializeListBox: function() {
  var listBox = this.GetListBox();
  if(!this.RenderExistsOnPage(listBox))
   return;
  this.initSelectedIndices = listBox.GetSelectedIndices();
  var element = listBox.GetListTable ? listBox.GetListTable() : listBox.GetMainElement();
  ASPx.Evt.AttachEventToElement(element, "mousedown", function() { window.setTimeout(ASPx.Selection.Clear, 0); });
  listBox.SelectedIndexChanged.AddHandler(function(s) { this.OnListBoxSelectionChanged(s); }.aspxBind(this));
  if(listBox.cpFSI)
   this.PrepareSeparators(listBox);
 },
 PrepareSeparators: function(listBox) {
  if(this.IsASPxClientListBox(listBox))
   GridHFListBoxWrapper.Initialize(listBox);
  for(var i = 0; i < listBox.cpFSI.length; i++) {
   var separatorIndex = listBox.cpFSI[i];
   var item = listBox.GetItemElement(separatorIndex);
   if(ASPx.IsExists(item)) {
    var tr = ASPx.GetParentByTagName(item, "TR");
    this.AppendSeparatorRow(tr);
   }
  }
 },
 IsASPxClientListBox: function(control){
  return typeof(ASPxClientListBox) != "undefined" && control instanceof ASPxClientListBox;
 },
 AppendSeparatorRow: function(targetRow){
  var newTr = document.createElement("TR");
  ASPx.InsertElementAfter(newTr, targetRow);
  var td = document.createElement("TD");
  var colSpan = this.GetColSpanSum(targetRow);
  if(colSpan > 1)
   td.colSpan = colSpan;
  newTr.appendChild(td);
  var separatorDiv = document.createElement("DIV");
  separatorDiv.className = this.GetFilterValuesSeparatorClassName();
  td.appendChild(separatorDiv);
 },
 GetColSpanSum: function(tableRow){
  var colSpan = 0;
  var cells = ASPx.GetChildNodesByTagName(tableRow, "TD");
  for(var i = 0; i < cells.length; i++){
   colSpan += cells[i].colSpan;
  }
  return colSpan;
 },
 InitializeSelectAllCheckBox: function(){
  var checkBox = this.GetSelectAllCheckBox();
  if(this.RenderExistsOnPage(checkBox))
   checkBox.CheckedChanged.AddHandler(function(s){ this.OnSelectAllCheckedChanged(s); }.aspxBind(this));
 },
 InitializeCalendar: function() {
  var calendar = this.GetCalendar();
  if(this.RenderExistsOnPage(calendar))
   this.initCalendarDates = calendar.GetSelectedDates();
 },
 InitializeDateRangePicker: function(){
  var fromDateEdit = this.GetHeaderFilterFromDateEdit();
  var toDateEdit = this.GetHeaderFilterToDateEdit();
  if(!this.RenderExistsOnPage(toDateEdit) || !this.RenderExistsOnPage(toDateEdit))
   return;
  var fromDECaptionCell = fromDateEdit.GetCaptionCell();
  var toDECaptionCell = toDateEdit.GetCaptionCell();
  var width = Math.max(ASPx.GetClearClientWidth(fromDECaptionCell), ASPx.GetClearClientWidth(toDECaptionCell));
  fromDECaptionCell.style.minWidth = width + "px";
  toDECaptionCell.style.minWidth = width + "px";
  fromDateEdit.ValueChanged.AddHandler(function(){ this.OnDateRangePickerValueChanged(); }.aspxBind(this));
  toDateEdit.ValueChanged.AddHandler(function(){ this.OnDateRangePickerValueChanged(); }.aspxBind(this));
  this.initDateRangePickerRange.start = fromDateEdit.GetValue();
  this.initDateRangePickerRange.end = toDateEdit.GetValue();
 },
 InitializeCalendar: function(){
  var calendar = this.GetCalendar();
  if(calendar){
   calendar.SelectionChanged.AddHandler(function(s) { this.OnCalendarSelectionChanged(s); }.aspxBind(this));
   this.initCalendarDates = calendar.GetSelectedDates();
  }
 },
 OnSelectAllCheckedChanged: function(checkBox){
  var listBox = this.GetListBox();
  if(checkBox.GetChecked())
   listBox.SelectAll();
  else
   listBox.UnselectAll();
  this.UpdateOkButtonEnabledState();
 },
 OnListBoxSelectionChanged: function(){
  if(!this.column) return;
  if(!this.column.HFCheckedList) {
   this.grid.ApplyHeaderFilterByColumn();
   return;
  }
  this.UpdateSelectAllCheckState();
  this.UpdateOkButtonEnabledState();
 },
 OnDateRangePickerValueChanged: function(){
  this.UpdateOkButtonEnabledState();
 },
 OnCalendarSelectionChanged: function(){
  this.UpdateOkButtonEnabledState();
 },
 UpdateSelectAllCheckState: function(){
  var checkBox = this.GetSelectAllCheckBox();
  if(!this.RenderExistsOnPage(checkBox))
   return;
  var listBox = this.GetListBox();
  var selectedItemCount = listBox.GetSelectedIndices().length;
  var checkState = ASPx.CheckBoxCheckState.Indeterminate;
  if(selectedItemCount == 0)
   checkState = ASPx.CheckBoxCheckState.Unchecked;
  else if(selectedItemCount == listBox.GetItemCount())
   checkState = ASPx.CheckBoxCheckState.Checked;
  checkBox.SetCheckState(checkState);
 },
 UpdateOkButtonEnabledState: function(){
  this.SetOkButtonEnabled(this.IsFilterChanged());
 },
 SetOkButtonEnabled: function(enabled) {
  var popup = this.GetPopup();
  if(!popup) return;
  var button = ASPx.GetControlCollection().Get(popup.cpOkButtonID);
  if(!button) return;
  button.SetEnabled(enabled);
 },
 IsFilterChanged: function(){
  return this.IsListBoxSelectedIndicesChanged() || this.IsDateRangePickerValueChanged() || this.IsCalendarSelectedDatesChanged();
 },
 IsListBoxSelectedIndicesChanged: function(){
  var listBox = this.GetListBox();
  if(!listBox) return false;
  var indices = listBox.GetSelectedIndices();
  if(indices.length != this.initSelectedIndices.length)
   return true;
  for(var i = 0; i < indices.length; i++) {
   if(ASPx.Data.ArrayBinarySearch(this.initSelectedIndices, indices[i]) < 0)
    return true;
  }
  return false;
 },
 IsCalendarSelectedDatesChanged: function(){
  var calendar = this.GetCalendar();
  if(!this.RenderExistsOnPage(calendar))
   return false;
  return !ASPx.Data.ArrayEqual(this.initCalendarDates, calendar.GetSelectedDates());
 },
 IsDateRangePickerValueChanged: function(){
  var fromDateEdit = this.GetHeaderFilterFromDateEdit();
  var toDateEdit = this.GetHeaderFilterToDateEdit();
  if(!this.RenderExistsOnPage(fromDateEdit) || !this.RenderExistsOnPage(toDateEdit))
   return false;
  return this.initDateRangePickerRange.start != fromDateEdit.GetValue() || this.initDateRangePickerRange.end != toDateEdit.GetValue();
 },
 GetCallbackValue: function(){
  var values = [ ];
  var listBox = this.GetListBox();
  if(listBox)
   values = listBox.GetSelectedValues();
  var calendarValue = this.GetCalendarCallbackValue();
  calendarValue && values.push(calendarValue);
  var pickerValue = this.GetDateRangePickerCallbackValue();
  pickerValue && values.push(pickerValue);
  return values;
 },
 GetCalendarCallbackValue: function(){
  var calendar = this.GetCalendar();
  if(!this.RenderExistsOnPage(calendar))
   return null;
  var dates = calendar.GetSelectedDates();
  if(dates && dates.length == 0)
   return null;
  dates.sort(function(a,b){ return a-b; });
  var selectedRanges = [ ];
  var range = {};
  for(var i = 0; i < dates.length; i++){
   if(!range.start)
    range.start = range.end = dates[i];
   if(i + 1 < dates.length && ASPx.DateUtils.AreDatesEqualExact(this.GetNextDate(range.end), dates[i + 1]))
    range.end = dates[i + 1];
   else {
    selectedRanges.push(ASPx.DateUtils.GetInvariantDateString(range.start));
    selectedRanges.push(ASPx.DateUtils.GetInvariantDateString(range.end));
    range.start = range.end = null;
   }
  }
  return "(Calendar)|" + selectedRanges.join("|");
 },
 GetNextDate: function(date){
  var nextDate = new Date(date.getTime());
  nextDate.setDate(nextDate.getDate() + 1);
  return nextDate;
 },
 GetDateRangePickerCallbackValue: function(){
  var fromDateEdit = this.GetHeaderFilterFromDateEdit();
  var toDateEdit = this.GetHeaderFilterToDateEdit();
  if(!this.RenderExistsOnPage(fromDateEdit) || !this.RenderExistsOnPage(toDateEdit))
   return null;
  var start = fromDateEdit.GetValue();
  var end = toDateEdit.GetValue();
  var range = [ ];
  if(start || end){
   range.push(start && ASPx.DateUtils.GetInvariantDateString(start) || "");
   range.push(end && ASPx.DateUtils.GetInvariantDateString(end) || "");
  }
  return range.length > 0 ? "(DateRangePicker)|" + range.join("|") : null;
 },
 RestoreState: function(){
  this.RestoreListBoxState();
  this.RestoreCalendarState();
  this.RestoreDateRangePickerState();
  this.SetOkButtonEnabled(false);
 },
 RestoreListBoxState: function() {
  var listBox = this.GetListBox();
  if(!this.column.HFCheckedList || !this.RenderExistsOnPage(listBox))
   return;
  listBox.UnselectAll();
  listBox.SelectIndices(this.initSelectedIndices);
  this.UpdateSelectAllCheckState();
 },
 RestoreCalendarState: function(){
  var calendar = this.GetCalendar();
  if(!this.RenderExistsOnPage(calendar))
   return;
  calendar.SetValue(null);
  for(var i = 0; i < this.initCalendarDates.length; i++)
   calendar.SelectDate(this.initCalendarDates[i]);
 },
 RestoreDateRangePickerState: function(){
  var fromDateEdit = this.GetHeaderFilterFromDateEdit();
  var toDateEdit = this.GetHeaderFilterToDateEdit();
  if(!this.RenderExistsOnPage(fromDateEdit) || !this.RenderExistsOnPage(toDateEdit))
   return;
  fromDateEdit.SetValue(this.initDateRangePickerRange.start);
  toDateEdit.SetValue(this.initDateRangePickerRange.end);
 },
 RenderExistsOnPage: function(control){
  return control && !control.IsDOMDisposed();
 }
});
var GridHFListBoxWrapper = {
 Initialize: function(listBox){
  listBox.GetItemRow = GridHFListBoxWrapper.GetItemRow;
  listBox.GetItemCount = GridHFListBoxWrapper.GetItemCount;
  listBox.OnItemClickCore = listBox.OnItemClick;
  listBox.OnItemClick = GridHFListBoxWrapper.OnItemClick;
  listBox.FindInternalCheckBoxIndexCore = listBox.FindInternalCheckBoxIndex;
  listBox.FindInternalCheckBoxIndex = GridHFListBoxWrapper.FindInternalCheckBoxIndex;
 },
 GetItemRow: function(index){
  var itemRows = GridHFListBoxWrapper.GetItemRows(this);
  if(index >= 0)
   return itemRows[index] || null;
  return null;
 },
 OnItemClick: function(index, evt){
  var correctIndex = GridHFListBoxWrapper.GetCorrectItemIndex(this, index);
  this.OnItemClickCore(correctIndex, evt);
 },
 FindInternalCheckBoxIndex: function(element){
  var index = this.FindInternalCheckBoxIndexCore(element);
  return GridHFListBoxWrapper.GetCorrectItemIndex(this, index);
 },
 GetItemCount: function(){
  return GridHFListBoxWrapper.GetItemRows(this).length;
 },
 GetCorrectItemIndex: function(listBox, index){
  for(var i = 0; i < listBox.cpFSI.length; i++) {
   if(listBox.cpFSI[i] < index)
    index--;
  }
  return index;
 },
 GetItemRows: function(listBox){
  var itemRows = [];
  var listTable = listBox.GetListTable();
  var rows = listTable ? listTable.rows : null;
  for(var i = 0; rows && i < rows.length; i++){
   if(ASPx.ElementContainsCssClass(rows[i], "dxeListBoxItemRow"))
    itemRows.push(rows[i]);
  }
  return itemRows;
 }
}
var ASPxClientGridViewCallbackCommand = {
 NextPage: "NEXTPAGE",
 PreviousPage: "PREVPAGE",
 GotoPage: "GOTOPAGE",
 SelectRows: "SELECTROWS",
 SelectRowsKey: "SELECTROWSKEY",
 Selection: "SELECTION",
 FocusedRow: "FOCUSEDROW",
 Group: "GROUP",
 UnGroup: "UNGROUP",
 Sort: "SORT",
 ColumnMove: "COLUMNMOVE",
 CollapseAll: "COLLAPSEALL",
 ExpandAll: "EXPANDALL",
 ExpandRow: "EXPANDROW",
 CollapseRow: "COLLAPSEROW",
 HideAllDetail: "HIDEALLDETAIL",
 ShowAllDetail: "SHOWALLDETAIL",
 ShowDetailRow: "SHOWDETAILROW",
 HideDetailRow: "HIDEDETAILROW",
 PagerOnClick: "PAGERONCLICK",
 ApplyFilter: "APPLYFILTER",
 ApplyColumnFilter: "APPLYCOLUMNFILTER",
 ApplyMultiColumnFilter: "APPLYMULTICOLUMNFILTER",
 ApplyHeaderColumnFilter: "APPLYHEADERCOLUMNFILTER",
 ApplySearchPanelFilter: "APPLYSEARCHPANELFILTER",
 FilterRowMenu: "FILTERROWMENU",
 StartEdit: "STARTEDIT",
 CancelEdit: "CANCELEDIT",
 UpdateEdit: "UPDATEEDIT",
 AddNewRow: "ADDNEWROW",
 DeleteRow: "DELETEROW",
 CustomButton: "CUSTOMBUTTON",
 CustomCallback: "CUSTOMCALLBACK",
 ShowFilterControl: "SHOWFILTERCONTROL",
 CloseFilterControl: "CLOSEFILTERCONTROL",
 SetFilterEnabled: "SETFILTERENABLED",
 Refresh: "REFRESH",
 SelFieldValues: "SELFIELDVALUES",
 RowValues: "ROWVALUES",
 PageRowValues: "PAGEROWVALUES",
 FilterPopup: "FILTERPOPUP",
 ContextMenu: "CONTEXTMENU",
 CustomValues: "CUSTOMVALUES"
};
var ASPxClientGridBatchEditStartEditingEventArgs = ASPx.CreateClass(ASPxClientCancelEventArgs, {
 constructor: function(visibleIndex, focusedColumn, itemValues) {
  this.constructor.prototype.constructor.call(this);
  this.visibleIndex = visibleIndex;
  this.focusedColumn = focusedColumn;
  this.itemValues = ASPx.CloneObject(itemValues);
 }
});
var ASPxClientGridBatchEditEndEditingEventArgs = ASPx.CreateClass(ASPxClientCancelEventArgs, {
 constructor: function(visibleIndex, itemValues) {
  this.constructor.prototype.constructor.call(this);
  this.visibleIndex = visibleIndex;
  this.itemValues = ASPx.CloneObject(itemValues);
 }
});
var ASPxClientGridBatchEditItemValidatingEventArgs = ASPx.CreateClass(ASPxClientEventArgs, {
 constructor: function(visibleIndex, validationInfo) {
  this.constructor.prototype.constructor.call(this);
  this.visibleIndex = visibleIndex;
  this.validationInfo = ASPx.CloneObject(validationInfo);
 }
});
var ASPxClientGridBatchEditConfirmShowingEventArgs = ASPx.CreateClass(ASPxClientCancelEventArgs, {
 constructor: function(requestTriggerID) {
  this.constructor.prototype.constructor.call(this);
  this.requestTriggerID = requestTriggerID;
 }
});
var ASPxClientGridBatchEditTemplateCellFocusedEventArgs = ASPx.CreateClass(ASPxClientEventArgs, {
 constructor: function(column) {
  this.constructor.prototype.constructor.call(this);
  this.column = column;
  this.handled = false;
 }
});
var ASPxClientGridBatchEditClientChangesEventArgs = ASPx.CreateClass(ASPxClientCancelEventArgs, {
 constructor: function(insertedValues, deletedValues, updatedValues) {
  this.constructor.prototype.constructor.call(this);
  this.insertedValues = insertedValues;
  this.deletedValues = deletedValues;
  this.updatedValues = updatedValues;
 }
});
var ASPxClientGridBatchEditItemInsertingEventArgs = ASPx.CreateClass(ASPxClientCancelEventArgs, {
 constructor: function(visibleIndex) {
  this.constructor.prototype.constructor.call(this);
  this.visibleIndex = visibleIndex;
 }
});
var ASPxClientGridBatchEditItemDeletingEventArgs = ASPx.CreateClass(ASPxClientCancelEventArgs, {
 constructor: function(visibleIndex, itemValues) {
  this.constructor.prototype.constructor.call(this);
  this.visibleIndex = visibleIndex;
  this.itemValues = itemValues;
 }
});
var ASPxClientGridBatchEditApi = ASPx.CreateClass(null, {
 constructor: function(grid) {
  this.grid = grid;
 },
 GetHelper: function() { return this.grid.GetBatchEditHelper(); },
 GetColumnIndex: function(column) { return this.grid._getColumnIndexByColumnArgs(column); },
 SetCellValue: function(visibleIndex, column, value, displayText, cancelCellHighlighting) {
  var helper = this.GetHelper();
  var columnIndex = this.GetColumnIndex(column);
  if(!helper || columnIndex === null) 
   return;
  if(!helper.IsValidVisibleIndex(visibleIndex))
   return;
  if(!ASPx.IsExists(displayText))
   displayText = helper.GetColumnDisplayTextByEditor(value, visibleIndex, columnIndex);
  if(helper.IsCheckColumn(columnIndex))
   displayText = helper.GetCheckColumnDisplayText(value, columnIndex);
  if(helper.IsColorEditColumn(columnIndex))
   displayText = helper.GetColorEditColumnDisplayText(value, columnIndex);
  helper.SetCellValue(visibleIndex, columnIndex, value, displayText, cancelCellHighlighting);
  helper.UpdateSyncInput(); 
  helper.UpdateItem(visibleIndex, [columnIndex], helper.IsEditingCell(visibleIndex, columnIndex), false, true);
  helper.UpdateCommandButtonsEnabled();
 },
 GetCellValue: function(visibleIndex, column, initial) {
  var helper = this.GetHelper();
  var columnIndex = this.GetColumnIndex(column);
  if(!helper || columnIndex === null) return;
  return helper.GetCellValue(visibleIndex, columnIndex, initial);
 },
 HasChanges: function(visibleIndex, column) {
  var helper = this.GetHelper();
  if(!helper) return false;
  var columnIndex = this.GetColumnIndex(column);
  return helper.HasChanges(visibleIndex, columnIndex);
 },
 ResetChanges: function(visibleIndex, columnIndex) {
  var helper = this.GetHelper();
  if(!helper) return;
  helper.ResetChanges(visibleIndex, columnIndex);
 },
 StartEdit: function(visibleIndex, columnIndex) {
  var helper = this.GetHelper();
  if(!helper) return;
  helper.StartEdit(visibleIndex, columnIndex);
 },
 EndEdit: function() {
  var helper = this.GetHelper();
  if(!helper || helper.focusHelper.lockUserEndEdit) 
   return;
  helper.EndEdit();
 },
 MoveFocusBackward: function() {
  var helper = this.GetHelper();
  if(!helper) return;
  return helper.focusHelper.MoveFocusPrev();
 },
 MoveFocusForward: function() {
  var helper = this.GetHelper();
  if(!helper) return;
  return helper.focusHelper.MoveFocusNext();
 },
 IsColumnEdited: function(column) {
  var helper = this.GetHelper();
  if(!helper || !column) return;
  return helper.IsColumnEdited(column.index);
 },
 ValidateItems: function() {
  var helper = this.GetHelper();
  if(!helper) return;
  return helper.UserValidateItems().isValid;
 },
 ValidateItem: function(visibleIndex) {
  var helper = this.GetHelper();
  if(!helper) return;
  return helper.UserValidateItems(visibleIndex).isValid;
 },
 GetItemVisibleIndices: function(includeDeleted) {
  var helper = this.GetHelper();
  if(!helper) return;
  return helper.GetDataItemVisibleIndices(!includeDeleted)
 },
 GetInsertedItemVisibleIndices: function() {
  var helper = this.GetHelper();
  if(!helper) return;
  var indices = helper.insertedItemIndices.slice();
  if(helper.IsNewItemOnTop())
   indices.reverse();
  return indices;
 },
 GetDeletedItemVisibleIndices: function() {
  var helper = this.GetHelper();
  if(!helper) return;
  return helper.GetDeletedItemVisibleIndices();
 },
 IsDeletedItem: function(visibleIndex) {
  var helper = this.GetHelper();
  if(!helper) return false;
  return helper.IsDeletedItem(helper.GetItemKey(visibleIndex));
 },
 IsNewItem: function(visibleIndex) {
  var helper = this.GetHelper();
  if(!helper) return false;
  return helper.IsNewItem(visibleIndex);
 },
 GetEditCellInfo: function() {
  var helper = this.GetHelper();
  if(!helper || !helper.IsEditing()) return;
  return this.CreateCellInfo(helper.editItemVisibleIndex, helper.GetFocusedColumn());
 },
 CreateCellInfo: function(visibleIndex, column) { return null; }
});
var ASPxClientGridCellInfo = ASPx.CreateClass(null, {
 constructor: function(visibleIndex, column) {
  this.itemVisibleIndex = visibleIndex;
  this.column = column;
 }
});
ASPxClientGridBase.InitializeStyles = function(name, styleInfo, commandButtonIDs){
 var grid = ASPx.GetControlCollection().Get(name);
 if(grid) {
  grid.styleInfo = styleInfo;
  grid.cButtonIDs = commandButtonIDs;
  grid.EnsureRowKeys();
  grid.UpdateItemsStyle();
 }
}
ASPx.GHeaderMouseDown = function(name, element, e) {
 var grid = ASPx.GetControlCollection().Get(name);
 if(grid != null) 
  grid.HeaderMouseDown(element, e);
}
ASPx.GSort = function(name, columnIndex) {
 var grid = ASPx.GetControlCollection().Get(name);
 if(grid != null)  
  grid.SortBy(columnIndex);
}
ASPx.GVPopupEditFormOnInit = function(name, popup) {
 var gv = ASPx.GetControlCollection().Get(name);
 if(gv != null)
  window.setTimeout(function() { gv.OnPopupEditFormInit(popup); }, 0);
}
ASPx.GVPagerOnClick = function(name, value) {
 var gv = ASPx.GetControlCollection().Get(name);
 if(gv != null) 
  gv.doPagerOnClick(value);
}
ASPx.GVFilterKeyPress = function(name, element, e) {
 var gv = ASPx.GetControlCollection().Get(name);
 if(gv != null) 
  gv.OnColumnFilterInputKeyPress(element, e);
}
ASPx.GVFilterSpecKeyPress = function(name, element, e) {
 var gv = ASPx.GetControlCollection().Get(name);
 if(gv != null) 
  gv.OnColumnFilterInputSpecKeyPress(element, e);
}
ASPx.GVFilterChanged = function(name, element) {
 window.setTimeout(function() {
  var gv = ASPx.GetControlCollection().Get(name);
  var el = ASPx.GetControlCollection().Get(element.name);
  if(gv != null && el != null) 
   gv.OnColumnFilterInputChanged(el);
 }, 0);
}
ASPx.GVShowParentRows = function(name, evt, element) {
 var gv = ASPx.GetControlCollection().Get(name);
 if(gv != null) {
  if(element)
   gv.OnParentRowMouseEnter(element);  
  else 
   gv.OnParentRowMouseLeave(evt);
 }
}
ASPx.GTableClick = function(name, evt) {
 var g = ASPx.GetControlCollection().Get(name);
 if(g != null && g.NeedProcessTableClick(evt))
  g.mainTableClick(evt);
}
ASPx.GVTableDblClick = function(name, evt) {
 var gv = ASPx.GetControlCollection().Get(name);
 if(gv != null && gv.NeedProcessTableClick(evt))
  gv.mainTableDblClick(evt);
}
ASPx.GVCustWindowShown_IE = function(s) {
 var div = document.getElementById(s.name + "_Scroller");
 div.style.overflow = "hidden";
 var width1 = div.clientWidth;
 div.style.overflow = "auto";
 var width2 = div.clientWidth;
 if(width2 > width1) {
  div.style.width = width1 + "px";
  div.style.paddingRight = (width2 - width1) + "px";
  window.setTimeout(function() { 
   div.className = "_";
   div.className = "";
  }, 0);
 }
}
ASPx.GVCustWindowCloseUp = function(name) {
 var gv = ASPx.GetControlCollection().Get(name);
 if(gv != null) {
  gv.RaiseCustomizationWindowCloseUp();
 }
}
ASPx.GVApplyFilterPopup = function(name) {
 var gv = ASPx.GetControlCollection().Get(name);
 if(gv != null)
  gv.ApplyHeaderFilterByColumn();
}
ASPx.GVShowFilterControl = function(name) {
 var gv = ASPx.GetControlCollection().Get(name);
 if(gv != null) {
  gv.ShowFilterControl();
 }
}
ASPx.GVCloseFilterControl = function(name) {
 var gv = ASPx.GetControlCollection().Get(name);
 if(gv != null) {
  gv.CloseFilterControl();
 }
}
ASPx.GVSetFilterEnabled = function(name, value) {
 var gv = ASPx.GetControlCollection().Get(name);
 if(gv != null) {
  gv.SetFilterEnabled(value);
 }
}
ASPx.GVApplyFilterControl = function(name) {
 var gv = ASPx.GetControlCollection().Get(name);
 if(gv != null)
  gv.ApplyFilterControl();
}
ASPx.GVFilterRowMenu = function(name, columnIndex, element) {
 var gv = ASPx.GetControlCollection().Get(name);
 if(gv != null)
  gv.FilterRowMenuButtonClick(columnIndex, element);
}
ASPx.GVFilterRowMenuClick = function(name, e) {
 var gv = ASPx.GetControlCollection().Get(name);
 if(gv != null)
  gv.FilterRowMenuItemClick(e.item);
}
ASPx.GVScheduleCommand = function(name, commandArgs, postponed, event) {
 var gv = ASPx.GetControlCollection().Get(name);
 if(gv != null)
  gv.ScheduleUserCommand(commandArgs, postponed, ASPx.Evt.GetEventSource(event));
}
ASPx.GVHFCancelButtonClick = function(name) {
 var gv = ASPx.GetControlCollection().Get(name);
 if(gv != null)
  gv.GetHeaderFilterPopup().Hide();
}
window.ASPxClientGridItemStyle = ASPxClientGridItemStyle; 
window.ASPxClientGridBase = ASPxClientGridBase;
window.ASPxClientGridColumnBase = ASPxClientGridColumnBase;
window.ASPxClientGridViewCallbackCommand = ASPxClientGridViewCallbackCommand;
window.ASPxClientGridBatchEditStartEditingEventArgs = ASPxClientGridBatchEditStartEditingEventArgs;
window.ASPxClientGridBatchEditEndEditingEventArgs = ASPxClientGridBatchEditEndEditingEventArgs;
window.ASPxClientGridBatchEditItemValidatingEventArgs = ASPxClientGridBatchEditItemValidatingEventArgs;
window.ASPxClientGridBatchEditConfirmShowingEventArgs = ASPxClientGridBatchEditConfirmShowingEventArgs;
window.ASPxClientGridBatchEditTemplateCellFocusedEventArgs = ASPxClientGridBatchEditTemplateCellFocusedEventArgs;
window.ASPxClientGridBatchEditClientChangesEventArgs = ASPxClientGridBatchEditClientChangesEventArgs;
window.ASPxClientGridBatchEditItemInsertingEventArgs = ASPxClientGridBatchEditItemInsertingEventArgs;
window.ASPxClientGridBatchEditItemDeletingEventArgs = ASPxClientGridBatchEditItemDeletingEventArgs;
window.ASPxClientGridBatchEditApi = ASPxClientGridBatchEditApi;
window.ASPxClientGridCellInfo = ASPxClientGridCellInfo;
})();
(function(){
var GridViewConsts = {
 AdaptiveGroupPanelID: "DXAGroupPanel",
 AdaptiveHeaderPanelID: "DXAHeaderPanel",
 AdaptiveFooterPanelID: "DXAFooterPanel",
 AdaptiveGroupHeaderID: "DXADGroupHeader",
 AdaptiveHeaderID: "DXADHeader",
 HeaderTableID: "DXHeaderTable",
 FooterTableID: "DXFooterTable",
 FilterRowID: "DXFilterRow",
 DataRowID: "DXDataRow",
 DetailRowID: "DXDRow",
 AdaptiveDetailRowID: "DXADRow",
 PreviewRowID: "DXPRow",
 GroupRowID: "DXGroupRow",
 EmptyDataRowID: "DXEmptyRow",
 FooterRowID: "DXFooterRow",
 GroupFooterRowID: "DXGFRow",
 HeaderRowID: "_DXHeadersRow",
 BandedRowPattern: "_DXDataRow(\\d+)_(\\d+)$",
 GridViewMarkerCssClass: "dxgv",
 GroupRowCssClass: "dxgvGroupRow",
 EmptyPagerRowCssClass: "dxgvEPDR",
 GroupFooterRowClass: "dxgvGroupFooter",
 GroupPanelCssClass: "dxgvGroupPanel",
 FooterScrollDivContainerCssClass: "dxgvFSDC",
 HeaderScrollDivContainerCssClass: "dxgvHSDC",
 HeaderCellCssClass: "dxgvHeader",
 CommandColumnCellCssClass: "dxgvCommandColumn",
 IndentCellCssClass: "dxgvIndentCell",
 InlineEditCellCssClass: "dxgvInlineEditCell",
 DetailIndentCellCssClass: "dxgvDIC",
 DetailButtonCellCssClass: "dxgvDetailButton",
 AdaptivityEnabledCssClass: "dxgvAE",
 AdaptivityWithLimitEnabledCssClass: "dxgvALE",
 AdaptiveHiddenCssClass: "dxgvAH",
 AdaptiveIndentCellCssClass: "dxgvAIC",
 AdaptiveDetailShowButtonCssClass: "dxgvADSB",
 AdaptiveDetailHideButtonCssClass: "dxgvADHB",
 AdaptiveDetailTableCssClass: "dxgvADT",
 AdaptiveDetailCaptionCellCssClass: "dxgvADCC",
 AdaptiveDetailDataCellCssClass: "dxgvADDC",
 AdaptiveDetailSpacerCellCssClass: "dxgvADSC",
 AdaptiveDetailCommandCellCssClass: "dxgvADCMDC",
 AdaptiveDetailLayoutItemContentCssClass: "dxgvADLIC",
 LastVisibleRowClassName: "dxgvLVR"
};
var GridViewColumnType = { Data: 0, Command: 1, Band: 2 };
var GridViewRowsLayoutMode = { Default: 0, MergedCell: 1, BandedCell: 2 };
var ASPxClientGridView = ASPx.CreateClass(ASPxClientGridBase, {
 NewRowVisibleIndex: -2147483647,
 constructor: function(name){
  this.constructor.prototype.constructor.call(this, name);
  this.editMode = 2;
  this.FocusedRowChanged = new ASPxClientEvent();
  this.ColumnGrouping = new ASPxClientEvent();
  this.ColumnStartDragging  = new ASPxClientEvent();
  this.ColumnResizing  = new ASPxClientEvent();
  this.ColumnResized  = new ASPxClientEvent();
  this.ColumnMoving = new ASPxClientEvent();
  this.RowExpanding  = new ASPxClientEvent();
  this.RowCollapsing  = new ASPxClientEvent();
  this.DetailRowExpanding  = new ASPxClientEvent();
  this.DetailRowCollapsing  = new ASPxClientEvent();
  this.RowClick  = new ASPxClientEvent();
  this.RowDblClick  = new ASPxClientEvent();
  this.ContextMenu = new ASPxClientEvent();
  this.ContextMenuItemClick = new ASPxClientEvent();
  this.BatchEditRowValidating = new ASPxClientEvent();
  this.BatchEditRowInserting = new ASPxClientEvent();
  this.BatchEditRowDeleting = new ASPxClientEvent();
  this.rowsLayoutInfo = { };
  this.allowFixedGroups = false;
  this.virtualScrollMode = 0;
  this.tableHelper = null;
  this.dragHelper = null;
  this.batchEditHelper = null;
  this.virtualScrollingDelay = 500;
  this.adaptivityMode = 0;
  this.adaptivityHelper = null;
 },
 GetItem: function(visibleIndex, level){
  var res = this.GetDataRow(visibleIndex, level);
  if(res == null) res = this.GetGroupRow(visibleIndex);
  return res;
 },
 GetDataItem: function(visibleIndex) { return this.GetDataRow(visibleIndex); },
 IsDataItem: function(visibleIndex) { return this.IsDataRow(visibleIndex); },
 GetRow: function(visibleIndex) { return this.GetItem(visibleIndex); },
 GetDataItemIDPrefix: function() { return GridViewConsts.DataRowID; },
 GetEmptyDataItemIDPostfix: function() { return GridViewConsts.EmptyDataRowID; },
 GetEmptyDataItemCell: function() { 
  var row = this.GetEmptyDataItem();
  return row ? this.GetLastNonAdaptiveIndentCell(row) : null;
 },
 GetDataRow: function(visibleIndex, level) {
  if(!this.HasBandedDataRows())
   level = -1;
  if(!ASPx.IsExists(level))
   level = 0;
  var levelPostfix = level >= 0 ? "_" + level : "";
  return this.GetChildElement(GridViewConsts.DataRowID + visibleIndex + levelPostfix);
 },
 HasBandedDataRows: function() { return this.rowsLayoutInfo.mode == GridViewRowsLayoutMode.BandedCell; },
 GetBandedDataRows: function(visibleIndex) {
  var advBandedRows = [ ];
  ASPx.GetNodesByPartialId(this.GetMainTable(), this.GetDataItemIDPrefix() + visibleIndex + "_", advBandedRows)
  return advBandedRows;
 },
 GetEditingCell: function(columnIndex) { 
  var row = this.GetEditingRow();
  var cellIndex = this.GetDataCellIndex(columnIndex);
  return row ? row.cells[cellIndex] : null;
 },
 GetEditingErrorCell: function(row) { 
  var row = row || this.GetEditingErrorItem();
  return row ? this.GetLastNonAdaptiveIndentCell(row) : null;
 },
 GetErrorTextContainer: function(displayIn) {
  var errorRow = this.GetEditingErrorItem(displayIn);
  if(!errorRow) {
   var editRow = this.GetEditingRow(displayIn);
   if(editRow) {
    errorRow = this.CreateEditingErrorItem();
    errorRow.id = editRow.id.replace("DXEditingRow", this.EditingErrorItemID);
    ASPx.InsertElementAfter(errorRow, editRow);
   }
  }
  return this.GetEditingErrorCell(errorRow);
 },
 CreateEditingErrorItem: function() {
  var wrapperElement = document.createElement("div");
  wrapperElement.innerHTML = "<table><tbody>" + this.styleInfo[ASPxClientGridItemStyle.ErrorItemHtml] + "</tbody></table>";
  var row = wrapperElement.firstChild.rows[0];
  for(var i = 0; i < row.cells.length; i++) {
   var cell = row.cells[i];
   var colSpan = parseInt(ASPx.Attr.GetAttribute(cell, "data-colSpan"));
   if(!isNaN(colSpan)) 
    cell.colSpan = colSpan;
  }
  var adaptivityHelper = this.GetAdaptivityHelper();
  if(adaptivityHelper && adaptivityHelper.HasAnyAdaptiveElement()) {
   var errorCell = this.GetLastNonAdaptiveIndentCell(row);
   var adaptiveSampleCell = this.GetSampleAdaptiveDetailCell();
   errorCell.colSpan = adaptiveSampleCell.colSpan;
   errorCell.originalColSpan = adaptiveSampleCell.originalColSpan;
  }
  return row;
 },
 GetDetailRow: function(visibleIndex) { return this.GetChildElement(GridViewConsts.DetailRowID + visibleIndex); },
 GetDetailCell: function(visibleIndex) { 
  var row = this.GetDetailRow(visibleIndex);
  return row ? this.GetLastNonAdaptiveIndentCell(row) : null;
 },
 GetPreviewRow: function(visibleIndex) { return this.GetChildElement(GridViewConsts.PreviewRowID + visibleIndex); },
 GetPreviewCell: function(visibleIndex) { 
  var row = this.GetPreviewRow(visibleIndex);
  return row ? this.GetLastNonAdaptiveIndentCell(row) : null;
 },
 GetSampleAdaptiveDetailRow: function() { return this.GetChildElement(GridViewConsts.AdaptiveDetailRowID); },
 GetSampleAdaptiveDetailCell: function() { 
  var row = this.GetSampleAdaptiveDetailRow();
  return row ? this.GetLastNonAdaptiveIndentCell(row) : null;
 },
 GetAdaptiveDataRow: function(visibleIndex) { 
  if(this.IsGroupRow(visibleIndex))
   return null;
  var row = this.GetDataRow(visibleIndex);
  if(row)
   return row;
  if(this.IsInlineEditMode())
   return this.GetEditingRow();
  return null;
 },
 GetAdaptiveDetailRow: function(visibleIndex, forceCreate) {
  var row = this.GetChildElement(GridViewConsts.AdaptiveDetailRowID + visibleIndex);
  if(!row && forceCreate) {
   var sampleRow = this.GetSampleAdaptiveDetailRow();
   var dataRow = this.GetAdaptiveDataRow(visibleIndex);
   if(sampleRow && dataRow) {
    row = sampleRow.cloneNode(true);
    row.id = this.name + "_" + GridViewConsts.AdaptiveDetailRowID + visibleIndex;
    this.GetLastNonAdaptiveIndentCell(row).originalColSpan = this.GetLastNonAdaptiveIndentCell(sampleRow).originalColSpan;
    ASPx.InsertElementAfter(row, dataRow);
    for(var i = 0; i < this.indentColumnCount; i++)
     row.cells[i].style.borderBottomWidth = dataRow.cells[i].style.borderBottomWidth;
   }
  }
  return row;
 },
 GetAdaptiveHeaderContainer: function(columnIndex, adaptivePanel) { 
  if(!adaptivePanel) return null;
  var isGroupHeader = adaptivePanel === this.GetAdaptiveGroupPanel();
  var containerID = this.name + "_" + (isGroupHeader ? GridViewConsts.AdaptiveGroupHeaderID : GridViewConsts.AdaptiveHeaderID) + columnIndex;
  var adaptiveHeader = document.getElementById(containerID);
  if(!adaptiveHeader) {
    adaptiveHeader = this.GetSampleAdaptiveHeader(isGroupHeader).cloneNode(true);
    adaptiveHeader.id = containerID;
    ASPx.SetElementDisplay(adaptiveHeader, true);
    var table = ASPx.GetChildByTagName(adaptiveHeader, "TABLE", 0);
    var row = table.rows[0];
    adaptiveHeader.dxHeaderContainer = row;
    adaptivePanel.appendChild(adaptiveHeader);
   }
  return adaptiveHeader.dxHeaderContainer;
 },
 GetAdaptiveGroupPanel: function() { return this.GetChildElement(GridViewConsts.AdaptiveGroupPanelID); },
 GetAdaptiveHeaderPanel: function() { return this.GetChildElement(GridViewConsts.AdaptiveHeaderPanelID); },
 GetAdaptiveFooterPanel: function() { return this.GetChildElement(GridViewConsts.AdaptiveFooterPanelID); },
 GetSampleAdaptiveHeader: function(isGroupHeader) { return this.GetChildElement(isGroupHeader ? GridViewConsts.AdaptiveGroupHeaderID : GridViewConsts.AdaptiveHeaderID); },
 IsAdaptiveCell: function(cell) {
  var adaptiveClasses = [ASPx.GridViewConsts.AdaptiveDetailDataCellCssClass, ASPx.GridViewConsts.AdaptiveDetailCommandCellCssClass];
  for(var i = 0; i < adaptiveClasses.length; i++)
   if(ASPx.ElementHasCssClass(cell, adaptiveClasses[i])) return true;     
  return false;
 }, 
 IsCellAdaptiveHidden: function(cell) {
  return ASPx.ElementContainsCssClass(cell, ASPx.GridViewConsts.AdaptiveHiddenCssClass);
 },
 GetAdaptiveCell: function(visibleIndex, columnIndex) {
  var adaptiveDetailsCell = this.GetAdaptiveDetailCell(visibleIndex, false);
  return adaptiveDetailsCell && adaptiveDetailsCell.adaptiveDetailsCells ? adaptiveDetailsCell.adaptiveDetailsCells[columnIndex] : null;
 },
 GetAdaptiveDetailCell: function(visibleIndex, forceCreate) { 
  var row = this.GetAdaptiveDetailRow(visibleIndex, forceCreate);
  return row ? this.GetLastNonAdaptiveIndentCell(row) : null;
 },
 GetDetailButtonCell: function(visibleIndex, fromAdaptiveRow) {
  var row = fromAdaptiveRow ? this.GetAdaptiveDetailRow(visibleIndex) : this.GetAdaptiveDataRow(visibleIndex);
  return ASPx.GetChildByPartialClassName(row, GridViewConsts.DetailButtonCellCssClass);
 },
 GetGroupRow: function(visibleIndex) { 
  var element = this.GetChildElement(GridViewConsts.GroupRowID + visibleIndex);
  if(!element)
   element = this.GetExpandedGroupRow(visibleIndex);
  return element; 
 },
 GetGroupCell: function(visibleIndex) { 
  var row = this.GetGroupRow(visibleIndex);
  return row ? this.GetLastNonAdaptiveIndentCell(row) : null;
 },
 GetGroupMoreRows: function(visibleIndex){
  var group = this.GetGroupRow(visibleIndex);
  if(!group)
   return null;
  var elements = ASPx.GetNodesByPartialClassName(group, "dxgvFGI");
  return elements && elements.length ? elements[0] : null;
 },
 GetGroupLevel: function(visibleIndex){
  var group = this.GetGroupRow(visibleIndex);
  return group ? this.GetFooterIndentCount(group) : -1;
 },
 GetExpandedGroupRow: function(visibleIndex) { return this.GetChildElement(GridViewConsts.GroupRowID + "Exp" + visibleIndex); },
 _isGroupRow: function(row) { return row.id.indexOf(GridViewConsts.GroupRowID) > -1; },
 IsHeaderRow: function(row) { return this.IsHeaderRowID(row.id); },
 IsHeaderRowID: function(id) { return id.indexOf(this.name + GridViewConsts.HeaderRowID) == 0; },
 IsEmptyHeaderID: function(id) { return id.indexOf(this.EmptyHeaderSuffix) > -1 },
 IsBandedDataRowID: function(id) {
  var pattern = new RegExp(this.name + GridViewConsts.BandedRowPattern);
  return pattern.test(id);
 },
 CreateEndlessPagingHelper: function(){
  return new ASPx.GridViewEndlessPagingHelper(this);
 },
 GetCssClassNamePrefix: function() { return "dxgv"; },
 GetFilterRow: function() { return this.GetChildElement(GridViewConsts.FilterRowID); },
 GetFilterCell: function(columnIndex) { 
  var row = this.GetFilterRow();
  var cellIndex = this.GetDataCellIndex(columnIndex);
  return row ? row.cells[cellIndex] : null;
 },
 GetDataRowLevel: function(columnIndex){
  return this.GetRowsLayout().GetDataCellLevel(columnIndex);
 },
 GetDataCellIndex: function(columnIndex, visibleIndex) {
  return this.GetRowsLayout().GetDataCellIndex(columnIndex, visibleIndex);
 },
 GetColumnIndexByDataCell: function(dataCell) {
  if(!dataCell) return -1;
  if(ASPx.IsExists(dataCell.columnIndex)) return dataCell.columnIndex;
  var dataRow = this.GetDataItemByChild(dataCell);
  var visibleIndex = dataRow ? this.getItemIndex(dataRow.id) : -1;
  var level = dataRow ? this.GetBandedDataRowLevelByID(dataRow.id) : -1;
  return this.GetRowsLayout().GetColumnIndex(dataCell.cellIndex, visibleIndex, level);
 },
 GetDataItemByChild: function(element) { return ASPx.GetParent(element, this.IsDataItemElement.aspxBind(this)); },
 IsDataItemElement: function(item) {
  if(!item || !item.id) return false;
  var regex = new RegExp(GridViewConsts.DataRowID + "\\d+(?:_\\d+)?$");
  return regex.test(item.id);
 },
 GetDataCell: function(visibleIndex, columnIndex) {
  var level = this.GetDataRowLevel(columnIndex);
  var dataRow = this.GetDataRow(visibleIndex, level);
  return this.GetDataCellByRow(dataRow, columnIndex, visibleIndex);
 },
 GetDataCellByRow: function(row, columnIndex, visibleIndex){
  if(!row)
   return null;
  var cellIndex = this.GetDataCellIndex(columnIndex, visibleIndex);
  return (0 <= cellIndex && cellIndex < row.cells.length) ? row.cells[cellIndex] : null;
 },
 GetVisibleColumnIndices: function() {
  return this.GetRowsLayout().GetVisibleColumnIndices();
 },
 GetArmatureCells: function(columnIndex) {
  var result = [ ];
  var cellIndex = this.GetDataCellIndex(columnIndex);
  var tableHelper = this.GetTableHelper();
  if(tableHelper) {
   if(tableHelper.GetHeaderTable()) {
    var cells = tableHelper.GetArmatureCells(tableHelper.GetHeaderTable());
    if(cells) result.push(cells[cellIndex]);
   }
   if(tableHelper.GetContentTable()) {
    var cells = tableHelper.GetArmatureCells(tableHelper.GetContentTable());
    if(cells) result.push(cells[cellIndex]);
   }
   if(tableHelper.GetFooterTable()) {
    var cells = tableHelper.GetArmatureCells(tableHelper.GetFooterTable());
    if(cells) result.push(cells[cellIndex]);
   }
  }
  else {
   var mainTable = this.GetMainTable();
   var rowIndex = this.GetRowsLayout().GetDataCellLevel(columnIndex);
   rowIndex = Math.max(0, rowIndex);
   result.push(mainTable.rows[rowIndex].cells[cellIndex]);
  }
  return result;
 },
 GetLastNonAdaptiveIndentCell: function(row) {
  var count = 1;
  while(count <= row.cells.length){
   var cell = row.cells[row.cells.length - count]
   if(!ASPx.ElementHasCssClass(cell, GridViewConsts.AdaptiveIndentCellCssClass))
    return cell;
   count++;
  }
  return null;
 },
 GetHeaderScrollContainer:function() {
  return ASPx.GetNodeByClassName(this.GetMainElement(), GridViewConsts.HeaderScrollDivContainerCssClass);
 },
 GetFooterScrollContainer:function() {
  return ASPx.GetNodeByClassName(this.GetMainElement(), GridViewConsts.FooterScrollDivContainerCssClass);
 },
 SetHeadersClientEvents: function() {
  if(!this.AllowResizing())
   return;
  var helper = this.GetResizingHelper();
  var attachMouseMove = function(headerCell) { 
   ASPx.Evt.AttachEventToElement(headerCell, "mousemove", function(e) { helper.UpdateCursor(e, headerCell); });
  };
  for(var i = 0; i < this.columns.length; i++) {
   var header = this.GetHeader(this.columns[i].index);
   if(header) 
    attachMouseMove(header);
  }
 },
 GetFooterRow: function(){
  return this.GetChildElement(GridViewConsts.FooterRowID);
 },
 GetFooterCell: function(columnIndex){
  var row = this.GetFooterRow();
  var cellIndex = this.GetDataCellIndex(columnIndex);
  return row ? row.cells[cellIndex] : null;
 },
 GetGroupFooterCells: function(columnIndex) {
  var mainTable = this.GetMainTable();
  var tBody = ASPx.GetChildByTagName(mainTable, "TBODY");
  var groupFooterRows = ASPx.GetChildNodesByPartialClassName(tBody, GridViewConsts.GroupFooterRowClass);
  var cellIndex = this.GetDataCellIndex(columnIndex);
  var result = [ ];
  for(var i = 0; i < groupFooterRows.length; i++) {
   var row = groupFooterRows[i];
   var cell = row && row.cells[cellIndex];
   if(cell)
    result.push(cell);
  }
  return result;
 },
 GetUserCommandNamesForRow: function() { return ASPxClientGridBase.prototype.GetUserCommandNamesForRow().concat([ "ShowAdaptiveDetail", "HideAdaptiveDetail" ]); },
 GetItemVisibleIndexRegExp: function(dataAndGroupOnly) {
  var idParts = [ GridViewConsts.DataRowID, GridViewConsts.GroupRowID + "(?:Exp)?", GridViewConsts.AdaptiveDetailRowID ];
  if(!dataAndGroupOnly) {
   idParts.push(GridViewConsts.PreviewRowID);
   idParts.push(GridViewConsts.DetailRowID);
  }
  return this.GetItemVisibleIndexRegExpByIdParts(idParts);
 },
 IsMainTableChildElement: function(src) {
  if(!src) return true;
  var tables = [ this.GetMainTable() ];
  var tableHelper = this.GetTableHelper();
  if(tableHelper) {
   tables.push(tableHelper.GetHeaderTable());
   tables.push(tableHelper.GetFooterTable());
  }
  for(var i = 0; i < tables.length; i++) {
   if(ASPx.GetIsParent(tables[i], src))
    return true;
  }
  return false;
 },
 CreateBatchEditApi: function() { return new ASPxClientGridViewBatchEditApi(this); },
 IsVirtualScrolling: function() { return this.virtualScrollMode > 0; },
 IsVirtualSmoothScrolling: function() { return this.virtualScrollMode === 2; },
 InitializeProperties: function(properties){
  if(properties.adaptiveModeInfo)
   this.SetAdaptiveMode(properties.adaptiveModeInfo);
 },
 Initialize: function() {
  ASPxClientGridBase.prototype.Initialize.call(this);
  this.enabled && this.SetHeadersClientEvents();
  if(this.enableKeyboard) {
   this.kbdHelper = this.customKbdHelperName ? new ASPx[this.customKbdHelperName](this) : new ASPx.GridViewKbdHelper(this);
   this.kbdHelper.Init();
   ASPx.KbdHelper.RegisterAccessKey(this);
  }
  this.ResetStretchedColumnWidth();
  this.PrepareEditorsToKeyboardNavigation();
  this.AttachInternalContexMenuEventHandler();
  this.InitializeDropDownElementsScrolling();
 },
 InitializeDropDownElementsScrolling: function() {
  if(this.HasVertScroll()) {
   this.ScrollableContainerDropDownEditors = null;
   var vertScrollableControl = this.GetScrollHelper().GetVertScrollableControl();
   ASPx.Evt.AttachEventToElement(vertScrollableControl, "scroll", function(evt) {
    if(ASPx.Evt.GetEventSource(evt) === vertScrollableControl)
     this.AdjustDropDownElements();
   }.aspxBind(this));
  }
 },
 AttachInternalContexMenuEventHandler: function() {
  if(this.IsDetailGrid()) {
   ASPx.Evt.AttachEventToElement(this.GetMainElement(), "contextmenu", function(e) {
    var showDefaultMenu = ASPx.EventStorage.getInstance().Load(e);
    if(showDefaultMenu)
     ASPx.Evt.CancelBubble(e);
    else 
     ASPx.EventStorage.getInstance().Save(e, true);
   }.aspxBind(this), true);
  }
 },
 AdjustControlCore: function() {
  ASPxClientGridBase.prototype.AdjustControlCore.call(this);
  this.CalculateAdaptivity();
  this.UpdateIndentCellWidths();
  this.ValidateColumnWidths();
 },
 IsAdjustmentRequired: function() {
  if(ASPxClientControl.prototype.IsAdjustmentRequired.call(this))
   return true;
  var scrollHelper = this.GetScrollHelper()
  return scrollHelper ? scrollHelper.IsRestoreScrollPosition() : false;
 },
 SaveCallbackSettings: function() {
  ASPxClientGridBase.prototype.SaveCallbackSettings.call(this);
  var helper = this.GetFixedColumnsHelper();
  if(helper != null) helper.SaveCallbackSettings();
 },
 RestoreCallbackSettings: function() {
  this.ResetStretchedColumnWidth();
  var fixedColumnsHelper = this.GetFixedColumnsHelper();
  if(fixedColumnsHelper != null)
   fixedColumnsHelper.RestoreCallbackSettings();
  this.SaveAdaptiveScrollTop();
  this.UpdateScrollableControls();
  if(fixedColumnsHelper != null)
   fixedColumnsHelper.HideColumnsRelyOnScrollPosition();
  this.UpdateIndentCellWidths();
  this.ValidateColumnWidths();
  ASPxClientGridBase.prototype.RestoreCallbackSettings.call(this);
 },
 SaveAdaptiveScrollTop: function() {
  this.adaptiveScrollTop = this.stateObject.scrollState ? this.stateObject.scrollState[1] : null;
 },
 ApplyAdaptiveScrollTop: function() {
  if(ASPx.IsExists(this.adaptiveScrollTop)) {
   this.SetVerticalScrollPosition(this.adaptiveScrollTop);
   this.adaptiveScrollTop = null;
  }
 },
 GetPopupEditFormHorzOffsetCorrection: function(popup) {
  var scrollHelper = this.GetScrollHelper();
  if(!scrollHelper) return 0;
  var scrollDiv = scrollHelper.GetHorzScrollableControl();
  if(!scrollDiv)  return 0;
  var horzAlign = popup.GetHorizontalAlign();
  if(ASPx.PopupUtils.IsRightSidesAlign(horzAlign) || ASPx.PopupUtils.IsOutsideRightAlign(horzAlign))
   return scrollDiv.scrollWidth - scrollDiv.offsetWidth;
  if(ASPx.PopupUtils.IsCenterAlign(horzAlign))
   return (scrollDiv.scrollWidth - scrollDiv.offsetWidth) / 2;
  return 0;
 },
 UpdateIndentCellWidths: function() {
  var tableHelper = this.GetTableHelper();
  if(tableHelper)
     tableHelper.UpdateIndentCellWidths();
 },
 OnBeforeCallbackOrPostBack: function() {
  ASPxClientGridBase.prototype.OnBeforeCallbackOrPostBack.call(this);
  this.SaveControlDimensions();
 },
 OnBeforeCallback: function(command) {
  ASPxClientGridBase.prototype.OnBeforeCallback.call(this, command);
  var scrollHelper = this.GetScrollHelper();
  if(scrollHelper && this.IsVirtualScrolling())
   scrollHelper.ClearVirtualScrollTimer();
 },
 OnAfterCallback: function() { 
  var layout = this.GetRowsLayout();
  layout && layout.Invalidate();
  ASPxClientGridBase.prototype.OnAfterCallback.call(this);
  this.SaveControlDimensions();
  var fixedGroupsHelper = this.GetFixedGroupsHelper();
  if(fixedGroupsHelper){
   fixedGroupsHelper.PopulateRowsHeight();
   fixedGroupsHelper.UpdateFixedGroups();
  }
  this.PrepareEditorsToKeyboardNavigation();
  this.UpdateLastVisibleRow();
  this.InitializeDropDownElementsScrolling();
  if(this.rowsLayout)
   this.rowsLayout.Invalidate();
 },
 PrepareEditorsToKeyboardNavigation: function() {
  if(!this.RequireEditorsKeyboardNavigation()) return;
  for(var i = 0; i < this.columns.length; i++) {
   this.AttachEventToEditor(this.columns[i].index, "GotFocus", function(s, e) { this.OnEditorGotFocus(s, e); }.aspxBind(this));
   this.AttachEventToEditor(this.columns[i].index, "KeyDown", function(s, e) { this.OnEditorKeyDown(s, e); }.aspxBind(this));
  }
 },
 RequireEditorsKeyboardNavigation: function() {
  return this.IsInlineEditMode() && this.GetFixedColumnsHelper();
 },
 OnEditorGotFocus: function(s, e) {
  if(!this.RequireEditorsKeyboardNavigation()) return;
  var helper = this.GetFixedColumnsHelper();
  helper.TryShowColumn(s.dxgvColumnIndex);
 },
 OnEditorKeyDown: function(s, e) {
  if(!this.RequireEditorsKeyboardNavigation()) return;
  var keyCode = ASPx.Evt.GetKeyCode(e.htmlEvent);
  if(keyCode !== ASPx.Key.Tab) return;
  var helper = this.GetFixedColumnsHelper();
  var matrix = this.GetHeaderMatrix();
  var neighborColumnIndex = e.htmlEvent.shiftKey ? matrix.GetLeftNeighbor(s.dxgvColumnIndex, true) : matrix.GetRightNeighbor(s.dxgvColumnIndex, true);
  var neighborEditor = this.GetEditorByColumnIndex(neighborColumnIndex);
  if(neighborEditor && helper.TryShowColumn(neighborColumnIndex, true)) {
   ASPx.Evt.PreventEventAndBubble(e.htmlEvent);
   ASPx.Selection.SetCaretPosition(s.GetInputElement());
   neighborEditor.Focus();
  }
 },
 IsInlineEditMode: function() { return this.editMode === 0; },
 IsEditRowHasDisplayedDataRow: function() { return this.editMode >= 2; },
 canGroupByColumn: function(headerElement) {
  return this.getColumnObject(headerElement.id).allowGroup;
 },
 canDragColumn: function(headerElement) {
  var column = this._getColumnObjectByArg(this.getColumnIndex(headerElement.id));
  return !this.RaiseColumnStartDragging(column) && this.getColumnObject(headerElement.id).allowDrag;
 },
 doPagerOnClick: function(id) {
  if(!ASPx.IsExists(id)) return;
  if(ASPx.Browser.IE && this.kbdHelper)
   this.kbdHelper.Focus();
  var scrollHelper = this.GetScrollHelper();
  if(scrollHelper)
   scrollHelper.ResetScrollTop();
  ASPxClientGridBase.prototype.doPagerOnClick.call(this, id);
 },
 TryStartColumnResizing: function(e, headerCell) {
  var helper = this.GetResizingHelper();
  if(!helper || !helper.CanStartResizing(e, headerCell))
   return false;
  var column = this.columns[helper.GetResizingColumnIndex(e, headerCell)];
  if(this.RaiseColumnResizing(column))
   return false;
  helper.StartResizing(column.index);
  return true;
 },
 IsPossibleSelectItem: function(visibleIndex, newSelectedValue){
  return this.IsDataRow(visibleIndex) && ASPxClientGridBase.prototype.IsPossibleSelectItem.call(this, visibleIndex, newSelectedValue);
 },
 _isRowSelected: function(visibleIndex) {
  return this.IsDataRow(visibleIndex) && ASPxClientGridBase.prototype._isRowSelected.call(this, visibleIndex);
 },
 GetDataItemCountOnPage: function(){
  var dataRowCount = 0;
  for(var i = 0; i < this.pageRowCount; i++){
   var index = i + this.visibleStartIndex;
   if(!this.IsGroupRow(index))
    dataRowCount++;
  }
  return dataRowCount;
 },
 GetFocusedItemStyle: function(visibleIndex, focused){
  var row = this.GetItem(visibleIndex);
  if(focused && row)
   return this._isGroupRow(row) ? ASPxClientGridItemStyle.FocusedGroupItem : ASPxClientGridItemStyle.FocusedItem;
  return ASPxClientGridBase.prototype.GetFocusedItemStyle.call(this, visibleIndex, focused);
 },
 RequireChangeItemStyle: function(visibleIndex, itemStyle){
  if(!ASPxClientGridBase.prototype.RequireChangeItemStyle.call(this, visibleIndex, itemStyle))
   return false;
  return itemStyle != ASPxClientGridItemStyle.Selected || !this.IsGroupRow(visibleIndex); 
 },
 GetItemStyle: function(visibleIndex){
  var style = ASPxClientGridBase.prototype.GetItemStyle.call(this, visibleIndex);
  if(style == ASPxClientGridItemStyle.FocusedItem && this.IsGroupRow(visibleIndex))
   style = ASPxClientGridItemStyle.FocusedGroupItem;
  return style;
 },
 ApplyItemStyle: function(visibleIndex, styleInfo) {
  if(this.HasBandedDataRows() && !this.IsGroupRow(visibleIndex)){
   var rows = this.GetBandedDataRows(visibleIndex);
   for(var i = 0; i < rows.length; i++)
    this.ApplyElementStyle(rows[i], styleInfo);
  } else
   ASPxClientGridBase.prototype.ApplyItemStyle.call(this, visibleIndex, styleInfo);
  var adaptivityHelper = this.GetAdaptivityHelper();
  if(adaptivityHelper && !adaptivityHelper.IsResponsiveMode()) {
   var item = this.GetItem(visibleIndex);
   if(item && adaptivityHelper.HasAnyAdaptiveElement() && !this.IsGroupRow(visibleIndex))
    ASPx.AddClassNameToElement(item, GridViewConsts.AdaptiveHiddenCssClass);
   var adaptiveItem = this.GetAdaptiveDetailRow(visibleIndex);
   if(adaptiveItem)
    this.ApplyElementStyle(adaptiveItem, styleInfo);
  }
 },
 OnScroll: function(evt){
  var fixedGroupsHelper = this.GetFixedGroupsHelper();
  if(fixedGroupsHelper)
   fixedGroupsHelper.OnDocumentScroll();
 },
 getItemByHtmlEvent: function(evt) {
  return this.getItemByHtmlEventCore(evt, GridViewConsts.DataRowID) || this.getItemByHtmlEventCore(evt, GridViewConsts.GroupRowID) || this.getItemByHtmlEventCore(evt, GridViewConsts.AdaptiveDetailRowID);
 },
 NeedProcessTableClick: function(evt){
  var headerTable = ASPx.GetParentByPartialId(ASPx.Evt.GetEventSource(evt), GridViewConsts.HeaderTableID);
  if(headerTable) {
   var headerTableID = headerTable.id;
   var gridID = headerTableID.substr(0, headerTableID.length - GridViewConsts.HeaderTableID.length - 1);
   return this.name == gridID;
  }
  return ASPxClientGridBase.prototype.NeedProcessTableClick.call(this, evt);
 },
 IsHeaderChild: function(source) {
  var headerRowCount = this.GetHeaderMatrix().GetRowCount();
  for(var i = 0; i < headerRowCount; i++) {
   if(ASPx.GetIsParent(this.GetHeaderRow(i), source))
    return true;
  }
  return false;
 },
 IsActionElement: function(mainElement, source) {
  if(this.testActionElement(source))
   return true;
  var parent = source;
  var controlCollection = ASPx.GetControlCollection();
  while(parent.id !== mainElement.id) {
   var control = controlCollection.Get(parent.id);
   if(ASPx.IsExists(control) && (control instanceof ASPxClientButton || control instanceof ASPxClientEditBase))
    return true;
   parent = parent.parentElement;
  }  
  return false;
 },
 getItemIndex: function(rowId) {
  if(this.IsHeaderRowID(rowId))
   return -1;
  if(this.IsBandedDataRowID(rowId))
   return this.GetBandedDataRowVisibleIndexByID(rowId);
  return ASPxClientGridBase.prototype.getItemIndex.call(this, rowId);
 },
 GetBandedDataRowLevelByID: function(rowId){
  if(!rowId) return -1;
  var matches = rowId.match(this.name + GridViewConsts.BandedRowPattern);
  return matches && matches.length > 2 ? parseInt(matches[2]) : -1;
 },
 GetBandedDataRowVisibleIndexByID: function(rowId){
  if(!rowId) return -1;
  var matches = rowId.match(this.name + GridViewConsts.BandedRowPattern);
  return matches && matches.length > 2 ? parseInt(matches[1]) : -1;
 },
 CreateBatchEditHelper: function() { return new ASPx.GridViewBatchEditHelper(this); },
 CreateCellFocusHelper: function() { return new ASPx.GridViewCellFocusHelper(this); },
 GetTableHelper: function() {
  if(!this.tableHelper && typeof(ASPx.GridViewTableHelper) != "undefined")
   this.tableHelper = new ASPx.GridViewTableHelper(this, this.MainTableID, GridViewConsts.HeaderTableID, GridViewConsts.FooterTableID, this.horzScroll, this.vertScroll);
  return this.tableHelper;
 },
 GetScrollHelper: function() {
  if(!this.HasScrolling()) return null;
  if(!this.scrollableHelper)
   this.scrollableHelper = new ASPx.GridViewTableScrollHelper(this.GetTableHelper());
  return this.scrollableHelper;
 },
 GetFixedColumnsHelper: function() {
  if(!this.GetFixedColumnsDiv()) return null;
  if(!this.fixedColumnsHelper)
   this.fixedColumnsHelper = new ASPx.GridViewTableFixedColumnsHelper(this.GetTableHelper(), this.FixedColumnsDivID, this.FixedColumnsContentDivID, this.fixedColumnCount);
  return this.fixedColumnsHelper;
 },
 GetFixedGroupsHelper: function() {
  if(!this.allowFixedGroups) return null;
  if(!this.fixedGroupsHelper)
   this.fixedGroupsHelper = new ASPx.GridViewFixedGroupsHelper(this.GetTableHelper());
  return this.fixedGroupsHelper;
 },
 GetResizingHelper: function() {
  if(!this.AllowResizing()) return null;
  if(!this.resizingHelper)
   this.resizingHelper = new ASPx.GridViewTableResizingHelper(this.GetTableHelper());
  return this.resizingHelper;
 },
 GetHeaderMatrix: function() {
  if(!this.headerMatrix)
   this.headerMatrix = new GridViewHeaderMatrix(this);
  return this.headerMatrix;
 },
 GetRowsLayout: function(){
  if(!this.rowsLayout)
     this.rowsLayout = this.CreateRowsLayout();
  return this.rowsLayout;
 },
 CreateRowsLayout: function(){
  if(this.rowsLayoutInfo.mode == GridViewRowsLayoutMode.MergedCell)
   return new GridViewRowsCellMergingLayout(this);
  if(this.rowsLayoutInfo.mode == GridViewRowsLayoutMode.BandedCell)
   return new GridViewBandedRowsLayout(this);
  return new GridViewRowsDefaultLayout(this);
 },
 ValidateColumnWidths: function() {
  var helper = this.GetResizingHelper();
  if(helper)
   helper.ValidateColumnWidths();
 },
 ResetStretchedColumnWidth: function() {
  var helper = this.GetResizingHelper();
  if(helper)
   helper.ResetStretchedColumnWidth();
 },
 SaveControlDimensions: function() {
  var helper = this.GetResizingHelper();
  if(helper)
   helper.SaveControlDimensions(true);
 },
 AdjustDropDownElements: function() {
  var vertScrollableControl = this.GetScrollHelper().GetVertScrollableControl();
  var scrollableRect = vertScrollableControl.getBoundingClientRect();
  ASPx.Data.ForEach(this.GetDropDownEditors(), function(dropDownEditor) {
   var editorRect = dropDownEditor.GetMainElement().getBoundingClientRect();
   var editorBottomIsVisible = editorRect.top + editorRect.height < scrollableRect.bottom
    && editorRect.top + editorRect.height > scrollableRect.top;
   if(dropDownEditor.GetPopupControl().IsVisible())
    if(editorBottomIsVisible)
     dropDownEditor.AdjustDropDownWindow();
    else
     dropDownEditor.HideDropDown();
  });
 },
 GetDropDownEditors: function() {
  if(this.ScrollableContainerDropDownEditors === null) {
   var vertScrollableControl = this.GetScrollHelper().GetVertScrollableControl();
   var ddPopupElements = ASPx.GetNodesByClassName(vertScrollableControl, "dxpc-ddSys");
   this.ScrollableContainerDropDownEditors = ddPopupElements.map(function(element) {
    var editorName = element.id.replace(/_DDD_PW-\d+$/g, "");
    return ASPx.GetControlCollection().GetByName(editorName);
   });
  }
  return this.ScrollableContainerDropDownEditors;
 },
 OnBrowserWindowResize: function(e) {
  this.EndBatchEdit(e);
  if(this.AllowResizing() && !this.HasScrolling())
   this.ValidateColumnWidths();
  this.AdjustControl();
 },
 EndBatchEdit: function(e){ 
  if(this.GetAdaptivityHelper() && this.GetBatchEditHelper() && e.prevWndWidth != e.wndWidth)
   this.GetBatchEditHelper().EndEdit();
 },
 GetAdaptivityHelper: function() {
  if(this.adaptivityMode === 0) return null;
  if(!this.adaptivityHelper)
   this.adaptivityHelper = new ASPx.GridViewColumnAdaptivityHelper(this);
  return this.adaptivityHelper;
 },
 SetAdaptiveMode: function(data) {
  this.adaptivityMode = data.adaptivityMode;
  var adaptivityHelper = this.GetAdaptivityHelper();
  if(adaptivityHelper)
   adaptivityHelper.ApplySettings(data);
 }, 
 CalculateAdaptivity: function() {
  var adaptivityHelper = this.GetAdaptivityHelper();
  if(adaptivityHelper)
   adaptivityHelper.CalculateAdaptivity();
 },
 ResetAdaptivityOnCallback: function(){
  var adaptivityHelper = this.GetAdaptivityHelper();
  if(adaptivityHelper)
   adaptivityHelper.ResetAdaptivityOnCallback();
 },
 RestoreAdaptivityState: function() {
  var adaptivityHelper = this.GetAdaptivityHelper();
  if(adaptivityHelper)
   adaptivityHelper.RestoreAdaptivityState();
 },
 ToggleAdaptiveDetails: function(visibleIndex) {
  var adaptivityHelper = this.GetAdaptivityHelper();
  if(adaptivityHelper)
   adaptivityHelper.ToggleAdaptiveDetails(visibleIndex);
 },
 UA_ShowAdaptiveDetail: function(visibleIndex) {
  this.ToggleAdaptiveDetails(visibleIndex);
 },
 UA_HideAdaptiveDetail: function(visibleIndex) {
  this.ToggleAdaptiveDetails(visibleIndex);
 },
 IsLastDataRow: function(visibleIndex) {
  return visibleIndex == this.visibleStartIndex + this.pageRowCount - 1 && (this.IsLastPage() || this.pageIndex < 0);
 },
 UpdateLastVisibleRow: function() {
  var tBody = ASPx.GetNodeByTagName(this.GetMainTable(), "TBODY", 0);
  var prevLastRows = ASPx.GetChildNodesByClassName(tBody, GridViewConsts.LastVisibleRowClassName);
  for(var i = 0; i < prevLastRows.length; i++) {
   ASPx.RemoveClassNameFromElement(prevLastRows[i], GridViewConsts.LastVisibleRowClassName);
  }
  var lastRow = this.FindLastVisibleRow();
  if(lastRow)
   ASPx.AddClassNameToElement(lastRow, GridViewConsts.LastVisibleRowClassName);
 },
 FindLastVisibleRow: function() {
  var dataGroupRowRegEx = this.GetItemVisibleIndexRegExp(false);
  var rows = this.GetMainTable().rows;
  for(var i = rows.length - 1; i >= 0; i--) {
   var row = rows[i];
   if(ASPx.ElementContainsCssClass(row, GridViewConsts.EmptyPagerRowCssClass))
    return row;
   if((dataGroupRowRegEx.test(row.id) || row.id && row.id.indexOf(this.EditingRowID) > -1) && ASPx.GetElementDisplay(row))
    return row;
  }
  return this.GetEmptyDataItem();
 },
 OnCallbackFinalized: function() {
  this.ResetAdaptivityOnCallback();
  ASPxClientGridBase.prototype.OnCallbackFinalized.call(this);
  this.AdjustPagerControls();
  this.CalculateAdaptivity();
  this.RestoreAdaptivityState();
 },
 ProcessContextMenuItemClick: function(e) {
  var item = e.item;
  var elementInfo = item.menu.elementInfo;
  switch(item.name){
   case this.ContextMenuItems.ClearGrouping:
    this.ContextMenuClearGrouping();
    break;
   case this.ContextMenuItems.GroupByColumn:
    this.GroupBy(elementInfo.index);
    break;
   case this.ContextMenuItems.UngroupColumn:
    this.UnGroup(elementInfo.index);
    break;
   default:
    ASPxClientGridBase.prototype.ProcessContextMenuItemClick.call(this, e);
  }
 },
 GetContextMenuObjectTypes: function(){
  var objectTypes = { };
  objectTypes[this.name + "_" + "grouppanel"]            = "grouppanel";
  objectTypes[this.name + "_" + GridViewConsts.AdaptiveGroupPanelID]    = "grouppanel";
  objectTypes[this.name + GridViewConsts.HeaderRowID]          = "emptyheader";
  objectTypes[this.name + "_" + "col"]             = "header";
  objectTypes[this.name + this.CustomizationWindowSuffix + "_" + "col"]    = "header";
  objectTypes[this.name + "_" + "groupcol"]           = "header";
  objectTypes[this.name + "_" + GridViewConsts.DataRowID]         = "row";
  objectTypes[this.name + "_" + GridViewConsts.DetailRowID]       = "row";
  objectTypes[this.name + "_" + GridViewConsts.EmptyDataRowID]       = "emptyrow";
  objectTypes[this.name + "_" + GridViewConsts.GroupRowID]        = "grouprow";
  objectTypes[this.name + "_" + GridViewConsts.GroupRowID + "Exp"]      = "grouprow";
  objectTypes[this.name + "_" + GridViewConsts.FooterRowID]       = "footer";
  objectTypes[this.name + "_" + GridViewConsts.FilterRowID]       = "filterrow";
  objectTypes[this.name + "_" + GridViewConsts.GroupFooterRowID]     = "groupfooter";
  return objectTypes;
 },
 SetWidth: function(width) {
  if(this.IsControlCollapsed())
   this.ExpandControl();
  var mainElemnt = this.GetMainElement();
  if(!ASPx.IsExistsElement(mainElemnt) || mainElemnt.offsetWidth === width) return;
  var scrollHelper = this.GetScrollHelper();
  if(scrollHelper)
   scrollHelper.OnSetWidth(width);
  this.ResetControlAdjustment();
  ASPxClientControl.prototype.SetWidth.call(this, width);
  this.AssignEllipsisToolTips();
 },
 NeedCollapseControlCore: function() {
  var adaptivityHelper = this.GetAdaptivityHelper();
  return adaptivityHelper && adaptivityHelper.IsResponsiveMode() || ASPxClientGridBase.prototype.NeedCollapseControlCore.call(this);
 },
 SortBy: function(column, sortOrder, reset, sortIndex){
    ASPxClientGridBase.prototype.SortBy.call(this, column, sortOrder, reset, sortIndex);
 },
 MoveColumn: function(column, columnMoveTo, moveBefore, moveToGroup, moveFromGroup){
  ASPxClientGridBase.prototype.MoveColumn.call(this, column, columnMoveTo, moveBefore, moveToGroup, moveFromGroup);
 },
 GroupBy: function(column, groupIndex, sortOrder){
  if(this.RaiseColumnGrouping(this._getColumnObjectByArg(column))) return;
  column = this._getColumnIndexByColumnArgs(column);
  if(!ASPx.IsExists(groupIndex)) groupIndex = "";
  if(!ASPx.IsExists(sortOrder)) sortOrder = "ASC";
  this.gridCallBack([ASPxClientGridViewCallbackCommand.Group, column, groupIndex, sortOrder]);
 },
 UnGroup: function(column){
  column = this._getColumnIndexByColumnArgs(column);
  this.GroupBy(column, -1);
 },
 ExpandAll: function(){
  this.gridCallBack([ASPxClientGridViewCallbackCommand.ExpandAll]);
 },
 CollapseAll: function(){
  this.gridCallBack([ASPxClientGridViewCallbackCommand.CollapseAll]);
 },
 ExpandAllDetailRows: function(){
  this.gridCallBack([ASPxClientGridViewCallbackCommand.ShowAllDetail]);
 },
 CollapseAllDetailRows: function(){
  this.gridCallBack([ASPxClientGridViewCallbackCommand.HideAllDetail]);
 },
 ExpandRow: function(visibleIndex, recursive){
  if(this.RaiseRowExpanding(visibleIndex)) return;
  recursive = !!recursive;
  this.gridCallBack([ASPxClientGridViewCallbackCommand.ExpandRow, visibleIndex, recursive]);
 },
 CollapseRow: function(visibleIndex, recursive){
  if(this.RaiseRowCollapsing(visibleIndex)) return;
  recursive = !!recursive;
  this.gridCallBack([ASPxClientGridViewCallbackCommand.CollapseRow, visibleIndex, recursive]);
 },
 MakeRowVisible: function(visibleIndex) {
  if(!this.HasVertScroll()) return;
  var row = this.GetItem(visibleIndex);
  if(row == null && visibleIndex >= this.visibleStartIndex && visibleIndex < this.visibleStartIndex + this.pageRowCount) 
   row = this.GetEditingRow();
  if(row == null) return;
  this.GetScrollHelper().MakeRowVisible(row);
 },
 ExpandDetailRow: function(visibleIndex){
  var key = this.GetRowKey(visibleIndex);
  if(key == null) return;
  if(this.RaiseDetailRowExpanding(visibleIndex)) return;
  this.gridCallBack([ASPxClientGridViewCallbackCommand.ShowDetailRow, key]);
 },
 CollapseDetailRow: function(visibleIndex){
  var key = this.GetRowKey(visibleIndex);
  if(key == null) return;
  if(this.RaiseDetailRowCollapsing(visibleIndex)) return;
  this.gridCallBack([ASPxClientGridViewCallbackCommand.HideDetailRow, key]);
 },
 GetRowKey: function(visibleIndex) {
  return this.GetItemKey(visibleIndex);
 },
 StartEditRow: function(visibleIndex) {
    this.StartEditItem(visibleIndex);
 },
 StartEditRowByKey: function(key) {
  this.StartEditItemByKey(key);
 },
 IsNewRowEditing: function() {
  return this.IsNewItemEditing();
 },
 AddNewRow: function(){
    this.AddNewItem();
 },
 DeleteRow: function(visibleIndex){
  this.DeleteItem(visibleIndex);
 },
 DeleteRowByKey: function(key) {
  this.DeleteItemByKey(key);
 },
 GetFocusedRowIndex: function() {
  return this._getFocusedItemIndex();
 },
 SetFocusedRowIndex: function(visibleIndex) {
  return this._setFocusedItemIndex(visibleIndex);
 },
 SelectRows: function(visibleIndices, selected){
  this.SelectItemsCore(visibleIndices, selected, false);
 },
 SelectRowsByKey: function(keys, selected){
  this.SelectItemsByKey(keys, selected);
 },
 UnselectRowsByKey: function(keys){
  this.SelectRowsByKey(keys, false);
 },
 UnselectRows: function(visibleIndices){
  this.SelectRows(visibleIndices, false);
 },
 UnselectFilteredRows: function() {
  this.UnselectFilteredItemsCore();
 },
 SelectRowOnPage: function(visibleIndex, selected){
  if(!ASPx.IsExists(selected)) selected = true;
  this.SelectItem(visibleIndex, selected);
 },
 UnselectRowOnPage: function(visibleIndex){
  this.SelectRowOnPage(visibleIndex, false);
 },
 SelectAllRowsOnPage: function(selected){
  if(!ASPx.IsExists(selected)) selected = true;
  this._selectAllRowsOnPage(selected);
 },
 UnselectAllRowsOnPage: function(){
  this._selectAllRowsOnPage(false);
 },
 GetSelectedRowCount: function() {
  return this._getSelectedRowCount();
 },
 IsRowSelectedOnPage: function(visibleIndex) {
  return this._isRowSelected(visibleIndex);
 },
 IsGroupRow: function(visibleIndex) {
  return this.GetGroupRow(visibleIndex) != null;
 },
 IsDataRow: function(visibleIndex) {
  return this.GetDataRow(visibleIndex) != null || this.GetBandedDataRows(visibleIndex).length > 0;
 },
 IsGroupRowExpanded: function(visibleIndex) { 
  return this.GetExpandedGroupRow(visibleIndex) != null;
 },
 GetVertScrollPos: function() {
  return this.GetVerticalScrollPosition();
 },
 GetVerticalScrollPosition: function() {
  if(this.IsVirtualScrolling())
   return 0;
  var scrollHelper = this.GetScrollHelper();
  if(scrollHelper)
   return scrollHelper.GetVertScrollPosition();
  return 0;
 },
 GetHorzScrollPos: function() {
  return this.GetHorizontalScrollPosition();
 },
 GetHorizontalScrollPosition: function() {
  var scrollHelper = this.GetScrollHelper();
  if(scrollHelper)
   return scrollHelper.GetHorzScrollPosition();
  return 0;
 },
 SetVertScrollPos: function(value) {
  this.SetVerticalScrollPosition(value);
 },
 SetVerticalScrollPosition: function(value) {
  if(this.IsVirtualScrolling())
   return;
  var scrollHelper = this.GetScrollHelper();
  if(scrollHelper)
   scrollHelper.SetVertScrollPosition(value);
 },
 SetHorzScrollPos: function(value) {
  this.SetHorizontalScrollPosition(value);
 },
 SetHorizontalScrollPosition: function(value) {
  var scrollHelper = this.GetScrollHelper();
  if(scrollHelper)
   scrollHelper.SetHorzScrollPosition(value);
 },
 RaiseColumnGrouping: function(column) {
  if(!this.ColumnGrouping.IsEmpty()){
   var args = new ASPxClientGridViewColumnCancelEventArgs(column);
   this.ColumnGrouping.FireEvent(this, args);
   return args.cancel;
  }
  return false; 
 },
 RaiseItemClick: function(visibleIndex, htmlEvent) {
  if(!this.RowClick.IsEmpty()){
   var args = new ASPxClientGridViewRowClickEventArgs(visibleIndex, htmlEvent);
   this.RowClick.FireEvent(this, args);
   return args.cancel;
  }
  return false; 
 },
 RaiseItemDblClick: function(visibleIndex, htmlEvent) {
  if(!this.RowDblClick.IsEmpty()){
   ASPx.Selection.Clear(); 
   var args = new ASPxClientGridViewRowClickEventArgs(visibleIndex, htmlEvent);
   this.RowDblClick.FireEvent(this, args);
   return args.cancel;
  }
  return false; 
 },
 RaiseContextMenu: function(objectType, index, htmlEvent, menu, showBrowserMenu) {
  var args = new ASPxClientGridViewContextMenuEventArgs(objectType, index, htmlEvent, menu, showBrowserMenu);
  if(!this.ContextMenu.IsEmpty())
   this.ContextMenu.FireEvent(this, args);
  return !!args.showBrowserMenu;
 },
 RaiseFocusedItemChanged: function(){
  if(!this.FocusedRowChanged.IsEmpty()){
   var args = new ASPxClientProcessingModeEventArgs(false);
   this.FocusedRowChanged.FireEvent(this, args);
   if(args.processOnServer)
    this.gridCallBack([ASPxClientGridViewCallbackCommand.FocusedRow]);
  }
  return false; 
 },
 RaiseColumnStartDragging: function(column) {
  if(!this.ColumnStartDragging.IsEmpty()){
   var args = new ASPxClientGridViewColumnCancelEventArgs(column);
   this.ColumnStartDragging.FireEvent(this, args);
   return args.cancel;
  }
  return false; 
 },
 RaiseColumnResizing: function(column) {
  if(!this.ColumnResizing.IsEmpty()){
   var args = new ASPxClientGridViewColumnCancelEventArgs(column);
   this.ColumnResizing.FireEvent(this, args);
   return args.cancel;
  }
  return false; 
 },
 RaiseColumnResized: function(column) {
  if(!this.ColumnResized.IsEmpty()){
   var args = new ASPxClientGridViewColumnProcessingModeEventArgs(column);
   this.ColumnResized.FireEvent(this, args);
   if(args.processOnServer)
    this.Refresh();
  }
 },
 RaiseRowExpanding: function(visibleIndex) {
  if(!this.RowExpanding.IsEmpty()){
   var args = new ASPxClientGridViewRowCancelEventArgs(visibleIndex);
   this.RowExpanding.FireEvent(this, args);
   return args.cancel;
  }
  return false; 
 },
 RaiseRowCollapsing: function(visibleIndex) {
  if(!this.RowCollapsing.IsEmpty()){
   var args = new ASPxClientGridViewRowCancelEventArgs(visibleIndex);
   this.RowCollapsing.FireEvent(this, args);
   return args.cancel;
  }
  return false; 
 },
 RaiseDetailRowExpanding: function(visibleIndex) {
  if(!this.DetailRowExpanding.IsEmpty()){
   var args = new ASPxClientGridViewRowCancelEventArgs(visibleIndex);
   this.DetailRowExpanding.FireEvent(this, args);
   return args.cancel;
  }
  return false; 
 },
 RaiseDetailRowCollapsing: function(visibleIndex) {
  if(!this.DetailRowCollapsing.IsEmpty()){
   var args = new ASPxClientGridViewRowCancelEventArgs(visibleIndex);
   this.DetailRowCollapsing.FireEvent(this, args);
   return args.cancel;
  }
  return false; 
 },
 RaiseBatchEditConfirmShowing: function(requestTriggerID) {
  if(!this.BatchEditConfirmShowing.IsEmpty()) {
   var args = new ASPxClientGridViewBatchEditConfirmShowingEventArgs(requestTriggerID);
   this.BatchEditConfirmShowing.FireEvent(this, args);
   return args.cancel;
  }
  return false;
 },
 RaiseBatchEditStartEditing: function(visibleIndex, column, rowValues) {
  var args = new ASPxClientGridViewBatchEditStartEditingEventArgs(visibleIndex, column, rowValues);
  if(!this.BatchEditStartEditing.IsEmpty())
   this.BatchEditStartEditing.FireEvent(this, args);
  return args;
 },
 RaiseBatchEditEndEditing: function(visibleIndex, rowValues) {
  var args = new ASPxClientGridViewBatchEditEndEditingEventArgs(visibleIndex, rowValues);
  if(!this.BatchEditEndEditing.IsEmpty())
   this.BatchEditEndEditing.FireEvent(this, args);
  return args;
 },
 RaiseBatchEditItemValidating: function(visibleIndex, validationInfo) {
  var args = new ASPxClientGridViewBatchEditRowValidatingEventArgs(visibleIndex, validationInfo);
  if(!this.BatchEditRowValidating.IsEmpty())
   this.BatchEditRowValidating.FireEvent(this, args);
  return args.validationInfo;
 },
 RaiseBatchEditTemplateCellFocused: function(columnIndex) {
  var column = this._getColumn(columnIndex);
  if(!column) return false;
  var args = new ASPxClientGridViewBatchEditTemplateCellFocusedEventArgs(column);
  if(!this.BatchEditTemplateCellFocused.IsEmpty())
   this.BatchEditTemplateCellFocused.FireEvent(this, args);
  return args.handled;
 },
 RaiseBatchEditChangesSaving: function(valuesInfo) { 
  if(!this.BatchEditChangesSaving.IsEmpty()){
   var args = new ASPxClientGridViewBatchEditChangesSavingEventArgs(valuesInfo.insertedValues, valuesInfo.deletedValues, valuesInfo.updatedValues);
   this.BatchEditChangesSaving.FireEvent(this, args);
   return args.cancel;
  }
  return false; 
 },
 RaiseBatchEditChangesCanceling: function(valuesInfo) { 
  if(!this.BatchEditChangesCanceling.IsEmpty()){
   var args = new ASPxClientGridViewBatchEditChangesCancelingEventArgs(valuesInfo.insertedValues, valuesInfo.deletedValues, valuesInfo.updatedValues);
   this.BatchEditChangesCanceling.FireEvent(this, args);
   return args.cancel;
  }
  return false; 
 },
 RaiseBatchEditItemInserting: function(visibleIndex) { 
  if(!this.BatchEditRowInserting.IsEmpty()){
   var args = new ASPxClientGridViewBatchEditRowInsertingEventArgs(visibleIndex);
   this.BatchEditRowInserting.FireEvent(this, args);
   return args.cancel;
  }
  return false; 
 },
 RaiseBatchEditItemDeleting: function(visibleIndex, itemValues) { 
  if(!this.BatchEditRowDeleting.IsEmpty()){
   var args = new ASPxClientGridViewBatchEditRowDeletingEventArgs(visibleIndex, itemValues);
   this.BatchEditRowDeleting.FireEvent(this, args);
   return args.cancel;
  }
  return false; 
 },
 RaiseContextMenuItemClick: function(e, itemInfo) {
  if(this.ContextMenuItemClick.IsEmpty())
   return false;
  var args = new ASPxClientGridViewContextMenuItemClickEventArgs(e.item, itemInfo.objectType, itemInfo.index);
  this.ContextMenuItemClick.FireEvent(this, args);
  if(!args.handled && args.processOnServer) {
   this.ProcessCustomContextMenuItemClick(e.item, args.usePostBack);
   return true;
  }
  return args.handled;
 },
 RaiseColumnMoving: function(targets) {
  if(this.ColumnMoving.IsEmpty()) return;
  var srcColumn = this.getColumnObject(targets.obj.id);
  var destColumn = this.getColumnObject(targets.targetElement.id);
  var isLeft = targets.isLeftPartOfElement();
  var isGroupPanel = targets.targetElement == targets.grid.GetGroupPanel();
  var args = new ASPxClientGridViewColumnMovingEventArgs(srcColumn, destColumn, isLeft, isGroupPanel);
  this.ColumnMoving.FireEvent(this, args);
  if(!args.allow)
   targets.targetElement = null;
 },
 CreateCommandCustomButtonEventArgs: function(index, id){
  return new ASPxClientGridViewCustomButtonEventArgs(index, id);
 },
 CreateSelectionEventArgs: function(visibleIndex, isSelected, isAllRecordsOnPage, isChangedOnServer){
  return new ASPxClientGridViewSelectionEventArgs(visibleIndex, isSelected, isAllRecordsOnPage, isChangedOnServer);
 },
 CreateColumnCancelEventArgs: function(column){
  return new ASPxClientGridViewColumnCancelEventArgs(column);
 },
 CreateColumnMovingEventArgs: function(sourceColumn, destinationColumn, isDropBefore, isGroupPanel){
  return new ASPxClientGridViewColumnMovingEventArgs(sourceColumn, destinationColumn, isDropBefore, isGroupPanel);;
 },
 GetRowValues: function(visibleIndex, fieldNames, onCallBack) {
  this.GetItemValues(visibleIndex, fieldNames, onCallBack);
 },
 GetPageRowValues: function(fieldNames, onCallBack) {
  this.GetPageItemValues(fieldNames, onCallBack);
 },
 GetVisibleRowsOnPage: function() {
  return this.GetVisibleItemsOnPage();
 },
 ApplyOnClickRowFilter: function() {
  this.ApplyMultiColumnAutoFilter();
 }
});
ASPxClientGridView.Cast = ASPxClientControl.Cast;
var ASPxClientGridViewColumn = ASPx.CreateClass(ASPxClientGridColumnBase, {
 constructor: function(name, index, parentIndex, fieldName, visible, filterRowTypeKind, showFilterMenuLikeItem,
  allowGroup, allowSort, allowDrag, HFCheckedList, inCustWindow, minWidth, columnType){
  this.constructor.prototype.constructor.call(this, name, index, fieldName, visible, allowSort, HFCheckedList);
  this.parentIndex = parentIndex;
  this.filterRowTypeKind = filterRowTypeKind;
  this.showFilterMenuLikeItem = !!showFilterMenuLikeItem;
  this.allowGroup = !!allowGroup;
  this.allowDrag = !!allowDrag;
  this.inCustWindow = !!inCustWindow;
  this.minWidth = minWidth;
  this.columnType = columnType;
  this.isCommandColumn = this.columnType == GridViewColumnType.Command;
  this.isPureBand = this.columnType == GridViewColumnType.Band;
 }
});
var ASPxClientGridViewColumnCancelEventArgs = ASPx.CreateClass(ASPxClientCancelEventArgs, {
 constructor: function(column){
  this.constructor.prototype.constructor.call(this);
  this.column = column;
 }
});
var ASPxClientGridViewColumnProcessingModeEventArgs = ASPx.CreateClass(ASPxClientProcessingModeEventArgs, {
 constructor: function(column){
  this.constructor.prototype.constructor.call(this, false);
  this.column = column;
 }
});
var ASPxClientGridViewRowCancelEventArgs = ASPx.CreateClass(ASPxClientCancelEventArgs, {
 constructor: function(visibleIndex){
  this.constructor.prototype.constructor.call(this);
  this.visibleIndex = visibleIndex;
 }
});
var ASPxClientGridViewSelectionEventArgs = ASPx.CreateClass(ASPxClientProcessingModeEventArgs, {
 constructor: function(visibleIndex, isSelected, isAllRecordsOnPage, isChangedOnServer){
  this.constructor.prototype.constructor.call(this, false);
  this.visibleIndex = visibleIndex;
  this.isSelected = isSelected;
  this.isAllRecordsOnPage = isAllRecordsOnPage;
  this.isChangedOnServer = isChangedOnServer;
 }
});
var ASPxClientGridViewRowClickEventArgs = ASPx.CreateClass(ASPxClientGridViewRowCancelEventArgs, {
 constructor: function(visibleIndex, htmlEvent){
  this.constructor.prototype.constructor.call(this, visibleIndex);
  this.htmlEvent = htmlEvent;
 }
});
var ASPxClientGridViewContextMenuEventArgs = ASPx.CreateClass(ASPxClientEventArgs, {
 constructor: function(objectType, index, htmlEvent, menu, showBrowserMenu) {
  this.constructor.prototype.constructor.call(this);
  this.objectType = objectType;
  this.index = index;
  this.htmlEvent = htmlEvent;
  this.menu = menu;
  this.showBrowserMenu = showBrowserMenu;
 }
});
var ASPxClientGridViewContextMenuItemClickEventArgs = ASPx.CreateClass(ASPxClientProcessingModeEventArgs, {
 constructor: function(item, objectType, elementIndex, processOnServer){
  this.constructor.prototype.constructor.call(this, processOnServer);
  this.item = item;
  this.objectType = objectType;
  this.elementIndex = elementIndex;
  this.usePostBack = false;
  this.handled = false;
 }
});
var ASPxClientGridViewCustomButtonEventArgs = ASPx.CreateClass(ASPxClientProcessingModeEventArgs, {
 constructor: function(visibleIndex, buttonID) {
  this.constructor.prototype.constructor.call(this, false);
  this.visibleIndex = visibleIndex;
  this.buttonID = buttonID;
 } 
});
var ASPxClientGridViewColumnMovingEventArgs = ASPx.CreateClass(ASPxClientEventArgs, {
 constructor: function(sourceColumn, destinationColumn, isDropBefore, isGroupPanel) {
  this.constructor.prototype.constructor.call(this);
  this.allow = true;
  this.sourceColumn = sourceColumn;
  this.destinationColumn = destinationColumn;
  this.isDropBefore = isDropBefore;
  this.isGroupPanel = isGroupPanel;
 }
});
var ASPxClientGridViewBatchEditConfirmShowingEventArgs = ASPx.CreateClass(ASPxClientGridBatchEditConfirmShowingEventArgs, {
 constructor: function(requestTriggerID) {
  this.constructor.prototype.constructor.call(this, requestTriggerID);
 }
});
var ASPxClientGridViewBatchEditStartEditingEventArgs = ASPx.CreateClass(ASPxClientGridBatchEditStartEditingEventArgs, {
 constructor: function(visibleIndex, focusedColumn, itemValues) {
  this.constructor.prototype.constructor.call(this, visibleIndex, focusedColumn, itemValues);
  this.rowValues = this.itemValues;
 }
});
var ASPxClientGridViewBatchEditEndEditingEventArgs = ASPx.CreateClass(ASPxClientGridBatchEditEndEditingEventArgs, {
 constructor: function(visibleIndex, itemValues) {
  this.constructor.prototype.constructor.call(this, visibleIndex, itemValues);
  this.rowValues = this.itemValues;
 }
});
var ASPxClientGridViewBatchEditRowValidatingEventArgs = ASPx.CreateClass(ASPxClientGridBatchEditItemValidatingEventArgs, {
 constructor: function(visibleIndex, validationInfo) {
  this.constructor.prototype.constructor.call(this, visibleIndex, validationInfo);
 }
});
var ASPxClientGridViewBatchEditTemplateCellFocusedEventArgs = ASPx.CreateClass(ASPxClientGridBatchEditTemplateCellFocusedEventArgs, {
 constructor: function(column) {
  this.constructor.prototype.constructor.call(this, column);
 }
});
var ASPxClientGridViewBatchEditChangesSavingEventArgs = ASPx.CreateClass(ASPxClientGridBatchEditClientChangesEventArgs, {
 constructor: function(insertedValues, deletedValues, updatedValues) {
  this.constructor.prototype.constructor.call(this, insertedValues, deletedValues, updatedValues);
 }
});
var ASPxClientGridViewBatchEditChangesCancelingEventArgs = ASPx.CreateClass(ASPxClientGridBatchEditClientChangesEventArgs, {
 constructor: function(insertedValues, deletedValues, updatedValues) {
  this.constructor.prototype.constructor.call(this, insertedValues, deletedValues, updatedValues);
 }
});
var ASPxClientGridViewBatchEditRowInsertingEventArgs = ASPx.CreateClass(ASPxClientGridBatchEditItemInsertingEventArgs, {
 constructor: function(visibleIndex) {
  this.constructor.prototype.constructor.call(this, visibleIndex);
 }
});
var ASPxClientGridViewBatchEditRowDeletingEventArgs = ASPx.CreateClass(ASPxClientGridBatchEditItemDeletingEventArgs, {
 constructor: function(visibleIndex, itemValues) {
  this.constructor.prototype.constructor.call(this, visibleIndex, itemValues);  
  this.rowValues = this.itemValues;  
 }
});
var ASPxClientGridViewCellInfo = ASPx.CreateClass(ASPxClientGridCellInfo, {
 constructor: function(visibleIndex, column) {
  this.constructor.prototype.constructor.call(this, visibleIndex, column);
  this.rowVisibleIndex = this.itemVisibleIndex;
 }
});
ASPx.GVContextMenu = function(name, e) {
 var gv = ASPx.GetControlCollection().Get(name);
 if(gv != null) {
  var showDefaultMenu = gv.OnContextMenuClick(e);
  return showDefaultMenu;
  }
 return true;
}
ASPx.GVContextMenuItemClick = function(name, e) {
 var gv = ASPx.GetControlCollection().Get(name);
 if(gv != null)
  gv.OnContextMenuItemClick(e);
}
ASPx.GVExpandRow = function(name, visibleIndex, event) {
 var gv = ASPx.GetControlCollection().Get(name);
 if(gv != null) {
  if(gv.useEndlessPaging && event)
   visibleIndex = gv.FindParentRowVisibleIndex(ASPx.Evt.GetEventSource(event), true);
  gv.ExpandRow(visibleIndex);
 }
}
ASPx.GVCollapseRow = function(name, visibleIndex, event) {
 var gv = ASPx.GetControlCollection().Get(name);
 if(gv != null) {
  if(gv.useEndlessPaging && event)
   visibleIndex = gv.FindParentRowVisibleIndex(ASPx.Evt.GetEventSource(event), true);
  gv.CollapseRow(visibleIndex);
 }
}
ASPx.GVShowDetailRow = function(name, visibleIndex, event) {
 var gv = ASPx.GetControlCollection().Get(name);
 if(gv != null) {
  if(gv.useEndlessPaging && event)
   visibleIndex = gv.FindParentRowVisibleIndex(ASPx.Evt.GetEventSource(event), true);
  gv.ExpandDetailRow(visibleIndex);
 }
}
ASPx.GVHideDetailRow = function(name, visibleIndex, event) {
 var gv = ASPx.GetControlCollection().Get(name);
 if(gv != null) {
  if(gv.useEndlessPaging && event)
   visibleIndex = gv.FindParentRowVisibleIndex(ASPx.Evt.GetEventSource(event), true);
  gv.CollapseDetailRow(visibleIndex);
 }
}
ASPx.Evt.AttachEventToElement(window, "scroll", function(evt) {
 ASPx.GetControlCollection().ForEachControl(function(control){
  if(control instanceof ASPxClientGridView && ASPx.IsExists(control.GetMainElement()))
   control.OnScroll(evt);
 });
});
var GridViewKbdHelper = ASPx.CreateClass(ASPx.KbdHelper, {
  CanFocus: function(e) {
  var grid = this.control;
  var batchEditHelper = grid.GetBatchEditHelper();
  if(batchEditHelper && batchEditHelper.CanStartEditOnTableClick(e))
   return false;
  return ASPx.KbdHelper.prototype.CanFocus(e);
 },
 HandleKeyDown: function(e) {
  var grid = this.control;
  var index = grid.GetFocusedRowIndex();
  var busy = grid.keyboardLock;
  var key = ASPx.Evt.GetKeyCode(e);
  if(grid.rtl) {
   if(key == ASPx.Key.Left)
    key = ASPx.Key.Right;
   else if(key == ASPx.Key.Right)
    key = ASPx.Key.Left;
  }
  switch(key) {
   case ASPx.Key.Down:
    if(!busy) 
     this.TryMoveFocusDown(index, e.shiftKey);
    return true;
   case ASPx.Key.Up:
    if(!busy) 
     this.TryMoveFocusUp(index, e.shiftKey);
    return true;
   case ASPx.Key.Right:
    if(!busy) {
     if(!this.TryExpand(index))
      this.TryMoveFocusDown(index, e.shiftKey);
    }
    return true;
   case ASPx.Key.Left:
    if(!busy) {
     if(!this.TryCollapse(index))
      this.TryMoveFocusUp(index, e.shiftKey);
    }
    return true;
   case ASPx.Key.PageDown:
    if(e.shiftKey) {
     if(!busy && grid.pageIndex < grid.pageCount - 1)
      grid.NextPage();
     return true; 
    }
    break;
   case ASPx.Key.PageUp:
    if(e.shiftKey) {
     if(!busy && grid.pageIndex > 0)
      grid.PrevPage();
     return true; 
    }
    break;     
  }
  return false;
 },
 HandleKeyPress: function(e) {
  var grid = this.control;
  var index = grid.GetFocusedRowIndex();
  var busy = grid.keyboardLock;
  switch(ASPx.Evt.GetKeyCode(e)) {
   case ASPx.Key.Space:
    if(!busy && this.IsRowSelectable(index))
     grid.IsRowSelectedOnPage(index) ? grid.UnselectRowOnPage(index) : grid.SelectRowOnPage(index);
    return true;
    case 43:
    if(!busy)
     this.TryExpand(index);
    return true;
    case 45: 
    if(!busy)   
     this.TryCollapse(index);    
    return true;
  }
  return false;
 },
 EnsureFocusedRowVisible: function() {
  var grid = this.control;
  if(!grid.HasVertScroll()) return;
  var row = grid.GetItem(grid.GetFocusedRowIndex());
  grid.GetScrollHelper().MakeRowVisible(row, true);
 },
 HasDetailButton: function(expanded) {
  var grid = this.control;
  var row = grid.GetItem(grid.GetFocusedRowIndex());
  if(!row) return;
  var needle = expanded ? "ASPx.GVHideDetailRow" : "ASPx.GVShowDetailRow";
  return row.innerHTML.indexOf(needle) > -1;
 },
 IsRowSelectable: function(index) {
  if(this.control.allowSelectByItemClick)
   return true;
  var row = this.control.GetItem(index);
  if(row && row.innerHTML.indexOf("aspxGVSelectRow") > -1)
   return true;
  var check = this.control.GetDataRowSelBtn(index); 
  if(check && this.control.internalCheckBoxCollection && !!this.control.internalCheckBoxCollection.Get(check.id))
   return true;
  return false;
 },
 UpdateShiftSelection: function(start, end) {
  var grid = this.control;
  grid.UnselectAllRowsOnPage();
  if(grid.lastMultiSelectIndex > -1)   
   start = grid.lastMultiSelectIndex;
  else   
   grid.lastMultiSelectIndex = start;
  for(var i = Math.min(start, end); i <= Math.max(start, end); i++)
   grid.SelectRowOnPage(i);
 },
 TryExpand: function(index) {
  var grid = this.control;
  if(grid.IsGroupRow(index) && !grid.IsGroupRowExpanded(index)) {
   grid.ExpandRow(index);
   return true;
  }
  if(this.HasDetailButton(false)) {
   grid.ExpandDetailRow(index);
   return true;
  }
  return false;
 },
 TryCollapse: function(index) {
  var grid = this.control;
  if(grid.IsGroupRow(index) && grid.IsGroupRowExpanded(index)) {
   grid.CollapseRow(index);
   return true;
  }
  if(this.HasDetailButton(true)) {
   grid.CollapseDetailRow(index);
   return true;
  }
  return false;
 },
 TryMoveFocusDown: function(index, select) {
  var grid = this.control;
  if(index < grid.visibleStartIndex + grid.pageRowCount - 1) {
   if(index < 0) 
    grid.SetFocusedRowIndex(grid.visibleStartIndex);
    else
    grid.SetFocusedRowIndex(index + 1);
   this.EnsureFocusedRowVisible();
   if(this.IsRowSelectable(index)) {
    if(select) {
     this.UpdateShiftSelection(index, index + 1);
    } else {
     grid.lastMultiSelectIndex = -1;
    }
   }
  } else {
   if(grid.pageIndex < grid.pageCount - 1 && grid.pageIndex >= 0) {       
    grid.NextPage();
   }
  }  
 },
 TryMoveFocusUp: function(index, select) {
  var grid = this.control;
  if(index > grid.visibleStartIndex || index == -1) {
   if(index < 0) 
    grid.SetFocusedRowIndex(grid.visibleStartIndex + grid.pageRowCount - 1);
   else
    grid.SetFocusedRowIndex(index - 1);
   this.EnsureFocusedRowVisible();
   if(this.IsRowSelectable(index)) {
    if(select) {
     this.UpdateShiftSelection(index, index - 1);
    } else {
     grid.lastMultiSelectIndex = -1;
    }
   }
  } else {
   if(grid.pageIndex > 0) {
    grid.PrevPage(true);
   }
  }
 }
});
var GridViewHeaderMatrix = ASPx.CreateClass(null, {
 constructor: function(grid) {
  this.grid = grid;
 },
 Invalidate: function() {
  this.matrix = null;
  this.inverseMatrix = null;
 },
 GetRowCount: function() {
  this.EnsureMatrix();
  return this.matrix.length;
 },
 IsLeftmostColumn: function(columnIndex) {
  this.EnsureMatrix();
  return this.inverseMatrix[columnIndex].left == 0;
 },
 IsRightmostColumn: function(columnIndex) {
  this.EnsureMatrix();  
  return this.inverseMatrix[columnIndex].right == this.matrix[0].length - 1;
 },
 IsLeaf: function(columnIndex) {
  this.EnsureMatrix();
  return this.inverseMatrix.hasOwnProperty(columnIndex) && this.inverseMatrix[columnIndex].bottom == this.matrix.length - 1;
 },
 GetLeaf: function(columnIndex, isLeft, isOuter) {
  this.EnsureMatrix();
  var rect = this.inverseMatrix[columnIndex];
  var row = this.matrix[this.matrix.length - 1];
  if(isLeft) {
   if(isOuter)
    return row[rect.left - 1];
   return row[rect.left];
  }
  if(isOuter)
   return row[rect.right + 1];
  return row[rect.right];
 },
 GetLeafIndex: function(columnIndex) {
  this.EnsureMatrix();
  return this.inverseMatrix[columnIndex].left;
 },
 GetLeafIndices: function() {
  return this.GetRowIndices(this.GetRowCount() - 1);
 },
 GetRowIndices: function(rowIndex) {
  this.EnsureMatrix();
  return this.matrix[rowIndex] || [];
 },
 GetRowSpan: function(columnIndex) {
  this.EnsureMatrix();
  var rect = this.inverseMatrix[columnIndex];
  return rect.bottom - rect.top + 1;
 },
 GetLeftNeighbor: function(columnIndex, skipHiddenColumns) {
  this.EnsureMatrix();
  if(!skipHiddenColumns)
   return this.GetLeftNeighborCore(columnIndex);
  while(columnIndex !== this.GetFirstColumnIndex()) {
   columnIndex = this.GetLeftNeighborCore(columnIndex);
   if(isNaN(columnIndex) || !this.grid.GetColumn(columnIndex).adaptiveHidden)
    return columnIndex;
  }
 },
 GetLeftNeighborCore: function(columnIndex) {
  var rect = this.inverseMatrix[columnIndex];
  return this.matrix[rect.top][rect.left - 1];
 },
 GetRightNeighbor: function(columnIndex, skipHiddenColumns) {
  this.EnsureMatrix();
  if(!skipHiddenColumns)
   return this.GetRightNeighborCore(columnIndex);
  while(columnIndex !== this.GetLastColumnIndex()) {
   columnIndex = this.GetRightNeighborCore(columnIndex);
   if(isNaN(columnIndex) || !this.grid.GetColumn(columnIndex).adaptiveHidden)
    return columnIndex;
  }
 },
 GetRightNeighborCore: function(columnIndex) {
  var rect = this.inverseMatrix[columnIndex];
  return this.matrix[rect.top][rect.right + 1];
 },
 GetLastColumnIndex: function(){
  var leafs = this.GetLeafIndices();
  return leafs[leafs.length - 1];
 },
 GetFirstColumnIndex: function(){
  var leafs = this.GetLeafIndices();
  return leafs[0];
 },
 GetRightNeighborLeaf: function(columnIndex) {
  return this.GetLeaf(columnIndex, false, true);
 },
 GetColumnLevel: function(columnIndex) {
  this.EnsureMatrix();
  var rect = this.inverseMatrix[columnIndex];
  return rect ? rect.top : -1;
 },
 EnsureMatrix: function() {
  this.matrix || this.Fill();
 },
 Fill: function() {
  this.matrix = [ ];
  this.inverseMatrix = { };
  var rowIndex = 0;
  while(true) {
   var row = this.grid.GetHeaderRow(rowIndex);
   if(!row)
    break;
   var lastFreeIndex = 0;
   for(var cellIndex = !rowIndex ? this.grid.indentColumnCount : 0; cellIndex < row.cells.length; cellIndex++) {
    var cell = row.cells[cellIndex];
    var columnIndex = this.grid.getColumnIndex(cell.id);
    if(columnIndex < 0)
     break;
    lastFreeIndex = this.FindFreeCellIndex(rowIndex, lastFreeIndex);
    this.FillBlock(rowIndex, lastFreeIndex, cell.rowSpan, cell.colSpan, columnIndex);
    lastFreeIndex += cell.colSpan;
   }
   ++rowIndex;
  }
 },
 FindFreeCellIndex: function(rowIndex, lastFreeCell) {
  var row = this.matrix[rowIndex];
  var result = lastFreeCell;
  if(row) {
   while(!isNaN(row[result]))
    result++;
  } 
  return result;
 },
 FillBlock: function(rowIndex, cellIndex, rowSpan, colSpan, columnIndex) {
  var rect = {
   top: rowIndex,
   bottom: rowIndex + rowSpan - 1,
   left: cellIndex,
   right: cellIndex + colSpan - 1
  };
  for(var i = rect.top; i <= rect.bottom; i++) {
   while(!this.matrix[i])
    this.matrix.push([]);
   for(var j = rect.left; j <= rect.right; j++)
    this.matrix[i][j] = columnIndex;
  }
  this.inverseMatrix[columnIndex] = rect;
 }
});
var GridViewRowsDefaultLayout = ASPx.CreateClass(null, {
 constructor: function(grid) {
  this.grid = grid;
 },
 Invalidate: function() { },
 IsMergedCell: function(columnIndex, visibleIndex){ return false; },
 GetLevelsCount: function() { return 1; },
 GetParentColumnIndices: function(columnIndex) { return []; },
 GetDataCellLevel: function(columnIndex) { return -1 },
 GetDataCellIndex: function(columnIndex, visibleIndex){
  return ASPx.Data.ArrayIndexOf(this.GetVisibleColumnIndices(), columnIndex) + this.GetIndentColumnCount();
 },
 GetColumnIndex: function(cellIndex, visibleIndex, level){
  cellIndex -= this.GetIndentColumnCount();
  var columnIndices = this.GetVisibleColumnIndices();
  if(cellIndex < 0 || cellIndex >= columnIndices.length) 
   return -1;
  return columnIndices[cellIndex];
 },
 GetVisibleColumnIndices: function() {
  var headerMatrix = this.GetHeaderMatrix();
  if(headerMatrix.GetRowCount() > 0)
   return headerMatrix.GetLeafIndices();
  return this.GetRowsLayoutInfo().visibleColumnIndices || [];
 },
 IsLoneRightColumn: function(columnIndex){
  var indices = this.GetVisibleColumnIndices();
  return indices.length > 0 && columnIndex === indices[indices.length - 1];
 },
 GetIndentColumnCount: function() { return this.grid.indentColumnCount; },
 GetHeaderMatrix: function() { return this.grid.GetHeaderMatrix(); },
 GetRowsLayoutInfo: function() { return this.grid.rowsLayoutInfo; }
});
var GridViewBandedRowsLayout = ASPx.CreateClass(GridViewRowsDefaultLayout, {
 constructor: function(grid){
  this.constructor.prototype.constructor.call(this, grid);
 },
 GetAllInfoItems: function(){
  return ASPx.Data.ArrayFlattern(this.GetBandedCellInfo());
 }, 
 GetColumnIndex: function(cellIndex, visibleIndex, level) {
  cellIndex -= this.GetIndentColumnCount();
  var rowColumnIndeces = this.GetColumnIndices(level);
  return rowColumnIndeces && cellIndex < rowColumnIndeces.length ? rowColumnIndeces[cellIndex] : -1;
 },
 GetColumnIndices: function(level) {
  var infoItems = this.GetBandedCellInfo()[level];
  return this.GetColumnIndicesFromLayoutItems(infoItems);
 },
 GetVisibleColumnIndices: function() {
  var infoItems = this.GetAllInfoItems();
  return this.GetColumnIndicesFromLayoutItems(infoItems);
 },
 GetColumnIndicesFromLayoutItems:  function(items){
  return items.map(function(item) { return item.columnIndex; });
 },
 GetDataCellLevel: function(columnIndex) {
  var levelsCount = this.GetLevelsCount();
  for(var i = 0; i < levelsCount; i++) {
   if(this.GetColumnIndices(i).indexOf(columnIndex) > -1)
    return i;
  }
  return -1;
 },
 GetDataCellIndex: function(columnIndex, visibleIndex){
  var level = this.GetDataCellLevel(columnIndex);
  if(level < 0)
   return -1;
  return this.GetColumnIndices(level).indexOf(columnIndex);
 },
 GetLevelsCount: function() {
  return this.GetBandedCellInfo().length;
 },
 GetParentColumnIndex: function(columnIndex) {
  var infoItems = this.GetAllInfoItems();
  var infoItem = infoItems.filter(function(item) { return item.columnIndex === columnIndex })[0];
  if(infoItem && infoItem.parent >= 0)
   return infoItem.parent;
  return null;
 },
 GetParentColumnIndices: function(columnIndex) {
  var result = [];
  var parentIndex = columnIndex;
  while(parentIndex = this.GetParentColumnIndex(parentIndex)) {
   result.push(parentIndex);
  }
  return result;
 },
 IsLoneRightColumn: function(columnIndex){ return false; },
 GetBandedCellInfo: function() { return this.GetRowsLayoutInfo().bandedCellInfo; }
});
var GridViewRowsCellMergingLayout = ASPx.CreateClass(GridViewRowsDefaultLayout, {
 constructor: function(grid){
  this.rowsSpanLayout = null;
  this.constructor.prototype.constructor.call(this, grid);
 },
 Invalidate: function(){
  this.rowsSpanLayout = null;
 },
 IsMergedCell: function(columnIndex, visibleIndex){
  this.EnsureLayout();
  var columnPosition = ASPx.Data.ArrayIndexOf(this.GetVisibleColumnIndices(), columnIndex);
  return this.rowsSpanLayout[visibleIndex - this.GetVisibleStartIndex()][columnPosition] > 1;
 },
 GetDataCellIndex: function(columnIndex, visibleIndex){
  this.EnsureLayout();
  var columnIndices = this.GetVisibleColumnIndices();
  var prevMergedCellsCount = this.GetHiddenPreviousCellCount(columnIndices.indexOf(columnIndex), visibleIndex);
  return GridViewRowsDefaultLayout.prototype.GetDataCellIndex.call(this, columnIndex, visibleIndex) - prevMergedCellsCount;
 },
 GetColumnIndex: function(cellIndex, visibleIndex) {
  cellIndex -= this.GetIndentColumnCount();
  var columnIndices = this.GetVisibleColumnIndices();
  if(cellIndex < 0 || cellIndex >= columnIndices.length) 
   return -1;
  this.EnsureLayout();
  cellIndex += this.GetHiddenPreviousCellCount(cellIndex + 1, visibleIndex);
  return columnIndices[cellIndex];
 },
 IsCellRendered: function(cellIndex, visibleIndex){
  var layoutRowIndex = visibleIndex - this.GetVisibleStartIndex();
  if(layoutRowIndex == 0 || !this.rowsSpanLayout[layoutRowIndex] || !this.rowsSpanLayout[layoutRowIndex - 1])
   return true;
  return this.rowsSpanLayout[layoutRowIndex][cellIndex] != this.rowsSpanLayout[layoutRowIndex - 1][cellIndex] - 1;
 },
 EnsureLayout: function(){
  if(this.rowsSpanLayout)
   return;
  this.rowsSpanLayout = [ ]
  var columnsCount = this.GetVisibleColumnIndices().length;
  var rowsCount = this.GetVisibleRowsOnPage();
  for(var layoutRowIndex = 0; layoutRowIndex < rowsCount; layoutRowIndex++){
   var rowElement = this.GetDataRow(layoutRowIndex + this.GetVisibleStartIndex());
   var rowLayout = rowElement ? new Array(columnsCount) : null;
   this.rowsSpanLayout.push(rowLayout);
   var delta = 0;
   for(var i = 0; rowLayout && i < columnsCount; i++){
    rowLayout[i] = layoutRowIndex > 0 ? this.GetLayoutCellRowSpan(layoutRowIndex - 1, i) - 1 : 0;
    if(rowLayout[i] == 0){
     var cellElement = rowElement.cells[this.GetIndentColumnCount() + i - delta];
     rowLayout[i] = cellElement.rowSpan;
    } else
     delta++;
   }
  }
 },
 GetLayoutCellRowSpan: function(vi, columnPosition){
  if(!this.rowsSpanLayout || vi >= this.rowsSpanLayout.length)
   return 1;
  if(!this.rowsSpanLayout[vi] || columnPosition >= this.rowsSpanLayout[vi].length)
   return 1;
  return this.rowsSpanLayout[vi][columnPosition];
 },
 GetHiddenPreviousCellCount: function(columnPosition, visibleIndex){
  if(!ASPx.IsExists(visibleIndex) || visibleIndex < 0)
   return 0;
  var count = 0;
  for(var i = 0; i < columnPosition; i++)
   if(!this.IsCellRendered(i, visibleIndex))
    count++;
  return count;
 },
 GetVisibleStartIndex: function(){ return this.grid.visibleStartIndex },
 GetVisibleRowsOnPage: function() { return this.grid.GetVisibleItemsOnPage(); },
 GetDataRow: function(visibleIndex){ return this.grid.GetDataRow(visibleIndex); }
});
var ASPxClientGridViewBatchEditApi = ASPx.CreateClass(ASPxClientGridBatchEditApi, {
 constructor: function(grid) {
  this.constructor.prototype.constructor.call(this, grid);
 },
 ValidateRows: function() { return this.ValidateItems(); },
 ValidateRow: function(visibleIndex) { return this.ValidateItem(visibleIndex); },
 GetRowVisibleIndices: function(includeDeleted) { return this.GetItemVisibleIndices(includeDeleted); },
 GetDeletedRowIndices: function() { return this.GetDeletedItemVisibleIndices(); },
 GetInsertedRowIndices: function() { return this.GetInsertedItemVisibleIndices(); },
 IsDeletedRow: function(visibleIndex) { return this.IsDeletedItem(visibleIndex); },
 IsNewRow: function(visibleIndex) { return this.IsNewItem(visibleIndex); },
 CreateCellInfo: function(visibleIndex, column) { return new ASPxClientGridViewCellInfo(visibleIndex, column); }
});
window.ASPxClientGridView = ASPxClientGridView;
window.ASPxClientGridViewColumn = ASPxClientGridViewColumn;
window.ASPxClientGridViewColumnCancelEventArgs = ASPxClientGridViewColumnCancelEventArgs;
window.ASPxClientGridViewColumnProcessingModeEventArgs = ASPxClientGridViewColumnProcessingModeEventArgs;
window.ASPxClientGridViewRowCancelEventArgs = ASPxClientGridViewRowCancelEventArgs;
window.ASPxClientGridViewSelectionEventArgs = ASPxClientGridViewSelectionEventArgs;
window.ASPxClientGridViewRowClickEventArgs = ASPxClientGridViewRowClickEventArgs;
window.ASPxClientGridViewContextMenuEventArgs = ASPxClientGridViewContextMenuEventArgs;
window.ASPxClientGridViewContextMenuItemClickEventArgs = ASPxClientGridViewContextMenuItemClickEventArgs;
window.ASPxClientGridViewCustomButtonEventArgs = ASPxClientGridViewCustomButtonEventArgs;
window.ASPxClientGridViewColumnMovingEventArgs = ASPxClientGridViewColumnMovingEventArgs;
window.ASPxClientGridViewBatchEditConfirmShowingEventArgs = ASPxClientGridViewBatchEditConfirmShowingEventArgs;
window.ASPxClientGridViewBatchEditStartEditingEventArgs = ASPxClientGridViewBatchEditStartEditingEventArgs;
window.ASPxClientGridViewBatchEditEndEditingEventArgs = ASPxClientGridViewBatchEditEndEditingEventArgs;
window.ASPxClientGridViewBatchEditRowValidatingEventArgs = ASPxClientGridViewBatchEditRowValidatingEventArgs;
window.ASPxClientGridViewBatchEditTemplateCellFocusedEventArgs = ASPxClientGridViewBatchEditTemplateCellFocusedEventArgs;
window.ASPxClientGridViewBatchEditChangesSavingEventArgs = ASPxClientGridViewBatchEditChangesSavingEventArgs;
window.ASPxClientGridViewBatchEditChangesCancelingEventArgs = ASPxClientGridViewBatchEditChangesCancelingEventArgs;
window.ASPxClientGridViewBatchEditRowInsertingEventArgs = ASPxClientGridViewBatchEditRowInsertingEventArgs;
window.ASPxClientGridViewBatchEditRowDeletingEventArgs = ASPxClientGridViewBatchEditRowDeletingEventArgs;
ASPx.GridViewKbdHelper = GridViewKbdHelper;
ASPx.GridViewConsts = GridViewConsts;
window.ASPxClientGridViewBatchEditApi = ASPxClientGridViewBatchEditApi;
window.ASPxClientGridViewCellInfo = ASPxClientGridViewCellInfo;
})();
(function() {
var ASPxClientEditBase = ASPx.CreateClass(ASPxClientControl, {
 constructor: function(name) {
  this.constructor.prototype.constructor.call(this, name);
  this.EnabledChanged = new ASPxClientEvent();
  this.captionPosition = ASPx.Position.Left;
  this.showCaptionColon = true;
 },
 InlineInitialize: function(){
  ASPxClientControl.prototype.InlineInitialize.call(this);
  this.InitializeEnabled(); 
 },
 InitializeEnabled: function() {
  this.SetEnabledInternal(this.clientEnabled, true);
 },
 GetValue: function() {
  var element = this.GetMainElement();
  if(ASPx.IsExistsElement(element))
   return element.innerHTML;
  return "";
 },
 GetValueString: function(){
  var value = this.GetValue();
  return (value == null) ? null : value.toString();
 },
 SetValue: function(value) {
  if(value == null)
   value = "";
  var element = this.GetMainElement();
  if(ASPx.IsExistsElement(element))
   element.innerHTML = value;
 },
 GetEnabled: function(){
  return this.enabled && this.clientEnabled;
 },
 SetEnabled: function(enabled){
  if(this.clientEnabled != enabled) {
   var errorFrameRequiresUpdate = this.GetIsValid && !this.GetIsValid();
   if(errorFrameRequiresUpdate && !enabled)
    this.UpdateErrorFrameAndFocus(false , null , true );
   this.clientEnabled = enabled;
   this.SetEnabledInternal(enabled, false);
   if(errorFrameRequiresUpdate && enabled)
    this.UpdateErrorFrameAndFocus(false );
   this.RaiseEnabledChangedEvent();
  }
 },
 SetEnabledInternal: function(enabled, initialization){
  if(!this.enabled) return;
  if(!initialization || !enabled)
   this.ChangeEnabledStateItems(enabled);
  this.ChangeEnabledAttributes(enabled);
  if(ASPx.Browser.Chrome) {   
   var mainElement = this.GetMainElement();
   if(mainElement)
    mainElement.className = mainElement.className;
  } 
 },
 ChangeEnabledAttributes: function(enabled){
 },
 ChangeEnabledStateItems: function(enabled){
 },
 RaiseEnabledChangedEvent: function(){
  if(!this.EnabledChanged.IsEmpty()){
   var args = new ASPxClientEventArgs();
   this.EnabledChanged.FireEvent(this, args);
  }
 },
 GetDecodeValue: function (value) { 
  if(typeof (value) == "string" && value.length > 1)
   value = this.SimpleDecodeHtml(value);
  return value;
 },
 SimpleDecodeHtml: function (html) {
  return ASPx.Str.ApplyReplacement(html, [
   [/&lt;/g, '<'],
   [/&amp;/g, '&'],
   [/&quot;/g, '"'],
   [/&#39;/g, '\''],
   [/&#32;/g, ' ']
  ]);
 },
 GetCachedElementById: function(idSuffix) {
  return ASPx.CacheHelper.GetCachedElementById(this, this.name + idSuffix);
 },
 GetCaptionCell: function() {
  return this.GetCachedElementById(EditElementSuffix.CaptionCell);
 },
 GetExternalTable: function() {
  return this.GetCachedElementById(EditElementSuffix.ExternalTable);
 },
 getCaptionRelatedCellCount: function() {
  if(!this.captionRelatedCellCount)
   this.captionRelatedCellCount = ASPx.GetNodesByClassName(this.GetExternalTable(), CaptionRelatedCellClassName).length;
  return this.captionRelatedCellCount;
 },
 addCssClassToCaptionRelatedCells: function() {
  if(this.captionPosition == ASPx.Position.Left || this.captionPosition == ASPx.Position.Right) {
   var captionRelatedCellsIndex = this.captionPosition == ASPx.Position.Left ? 0 : this.GetCaptionCell().cellIndex;
   for(var i = 0; i < this.GetExternalTable().rows.length; i++)
    ASPx.AddClassNameToElement(this.GetExternalTable().rows[i].cells[captionRelatedCellsIndex], CaptionRelatedCellClassName);
  }
  if(this.captionPosition == ASPx.Position.Top || this.captionPosition == ASPx.Position.Bottom)
   for(var i = 0; i < this.GetCaptionCell().parentNode.cells.length; i++)
    ASPx.AddClassNameToElement(this.GetCaptionCell().parentNode.cells[i], CaptionRelatedCellClassName);
 },
 GetCaption: function() {
  if(ASPx.IsExists(this.GetCaptionCell()))
   return this.getCaptionInternal();
  return "";
 },
 SetCaption: function(caption) {
  if(!ASPx.IsExists(this.GetCaptionCell()))
   return;
  if(this.getCaptionRelatedCellCount() == 0)
   this.addCssClassToCaptionRelatedCells();
  if(caption !== "")
   ASPx.RemoveClassNameFromElement(this.GetExternalTable(), ASPxEditExternalTableClassNames.TableWithEmptyCaptionClassName);
  else
   ASPx.AddClassNameToElement(this.GetExternalTable(), ASPxEditExternalTableClassNames.TableWithEmptyCaptionClassName);
  this.setCaptionInternal(caption);
 },
 getCaptionTextNode: function() {
  var captionElement = ASPx.GetNodesByPartialClassName(this.GetCaptionCell(), CaptionElementPartialClassName)[0];
  return ASPx.GetTextNode(captionElement);
 },
 getCaptionInternal: function() {
  var captionText = this.getCaptionTextNode().nodeValue;
  if(captionText !== "" && captionText[captionText.length - 1] == ":")
   captionText = captionText.substring(0, captionText.length - 1);
  return captionText;
 },
 setCaptionInternal: function(caption) {
  caption = ASPx.Str.Trim(caption);
  var captionTextNode = this.getCaptionTextNode();
  if(this.showCaptionColon && caption[caption.length - 1] != ":" && caption !== "")
   caption += ":";
  captionTextNode.nodeValue = caption;
 }
});
var ValidationPattern = ASPx.CreateClass(null, {
 constructor: function(errorText) {
  this.errorText = errorText;
 }
});
var RequiredFieldValidationPattern = ASPx.CreateClass(ValidationPattern, {
 constructor: function(errorText) {
  this.constructor.prototype.constructor.call(this, errorText);
 },
 EvaluateIsValid: function(value) {
  return value != null && (value.constructor == Array || ASPx.Str.Trim(value.toString()) != "");
 }
});
var RegularExpressionValidationPattern = ASPx.CreateClass(ValidationPattern, {
 constructor: function(errorText, pattern) {
  this.constructor.prototype.constructor.call(this, errorText);
  this.pattern = pattern;
 },
 EvaluateIsValid: function(value) {
  if(value == null) 
   return true;
  var strValue = value.toString();
  if(ASPx.Str.Trim(strValue).length == 0)
   return true;
  var regEx = new RegExp(this.pattern);
  var matches = regEx.exec(strValue);
  return matches != null && strValue == matches[0];
 }
});
function _aspxIsEditorFocusable(inputElement) {
 return ASPx.IsFocusableCore(inputElement, function(container) {
  return container.getAttribute("errorFrame") == "errorFrame";
 });
}
var invalidEditorToBeFocused = null;
var ValidationType = {
 PersonalOnValueChanged: "ValueChanged",
 PersonalViaScript: "CalledViaScript",
 MassValidation: "MassValidation"
};
var ErrorFrameDisplay = {
 None: "None",
 Static: "Static",
 Dynamic: "Dynamic"
};
var EditElementSuffix = {
 ExternalTable: "_ET",
 ControlCell: "_CC",
 ErrorCell: "_EC",
 ErrorTextCell: "_ETC",
 ErrorImage: "_EI",
 CaptionCell: "_CapC",
 AccessibilityAdditionalTextRow: "_AHTR"
};
var ASPxEditExternalTableClassNames = {
 ValidStaticTableClassName: "dxeValidStEditorTable",
 ValidDynamicTableClassName: "dxeValidDynEditorTable",
 TableWithSeparateBordersClassName: "tableWithSeparateBorders",
 TableWithEmptyCaptionClassName: "tableWithEmptyCaption"
};
var CaptionRelatedCellClassName = "dxeCaptionRelatedCell";
var CaptionElementPartialClassName = "dxeCaption";
var AccessibilityInvisibleRowCssClassName = "dxAIR";
var ASPxClientEdit = ASPx.CreateClass(ASPxClientEditBase, {
 constructor: function(name) {
  this.constructor.prototype.constructor.call(this, name);
  this.isASPxClientEdit = true;
  this.inputElement = null;
  this.convertEmptyStringToNull = true;
  this.readOnly = false;
  this.focused = false;
  this.focusEventsLocked = false;
  this.receiveGlobalMouseWheel = true;
  this.styleDecoration = null;
  this.heightCorrectionRequired = false;
  this.customValidationEnabled = false;
  this.display = ErrorFrameDisplay.Static;
  this.initialErrorText = "";
  this.causesValidation = false;
  this.validateOnLeave = true;
  this.validationGroup = "";
  this.sendPostBackWithValidation = null;
  this.validationPatterns = [];
  this.setFocusOnError = false;
  this.errorDisplayMode = "it";
  this.errorText = "";
  this.isValid = true;
  this.errorImageIsAssigned = false;
  this.notifyValidationSummariesToAcceptNewError = false;
  this.isErrorFrameRequired = false;
  this.enterProcessed = false;
  this.keyDownHandlers = {};
  this.keyPressHandlers = {};
  this.keyUpHandlers = {};
  this.specialKeyboardHandlingUsed = false;
  this.onKeyDownHandler = null;
  this.onKeyPressHandler = null;
  this.onKeyUpHandler = null;
  this.onGotFocusHandler = null;
  this.onLostFocusHandler = null;
  this.GotFocus = new ASPxClientEvent();
  this.LostFocus = new ASPxClientEvent();
  this.Validation = new ASPxClientEvent();
  this.ValueChanged = new ASPxClientEvent();
  this.KeyDown = new ASPxClientEvent();
  this.KeyPress = new ASPxClientEvent();
  this.KeyUp = new ASPxClientEvent();
  this.eventHandlersInitialized = false;
 },
 InitializeProperties: function(properties){
  if(properties.decorationStyles){
   for(var i = 0; i < properties.decorationStyles.length; i++)
    this.AddDecorationStyle(properties.decorationStyles[i].key, 
     properties.decorationStyles[i].className, 
     properties.decorationStyles[i].cssText);
  }
 },
 Initialize: function() {
  this.initialErrorText = this.errorText;
  ASPxClientEditBase.prototype.Initialize.call(this);
  this.InitializeKeyHandlers();
  this.UpdateClientValidationState();
  this.UpdateValidationSummaries(null , true );
 },
 InlineInitialize: function() {
  ASPxClientEditBase.prototype.InlineInitialize.call(this);
  if(!this.eventHandlersInitialized)
   this.InitializeEvents();
  if(this.styleDecoration)
   this.styleDecoration.Update();
  var externalTable = this.GetExternalTable();
  if(externalTable && ASPx.IsPercentageSize(externalTable.style.width)) {
   this.width = "100%";
   this.GetMainElement().style.width = "100%";
   if(this.isErrorFrameRequired)
    externalTable.setAttribute("errorFrame", "errorFrame");
  }
 }, 
 AfterInitialize: function() {
  this.SetAccessibilityCaptionAssociating();
  this.UpdateAccessibilityAdditionalTextRelation();
  this.UpdateValidationAccessibilityAttributes();
  ASPxClientEditBase.prototype.AfterInitialize.call(this);
 },
 InitializeEvents: function() {
 },
 InitSpecialKeyboardHandling: function(){
  var name = this.name;
  this.onKeyDownHandler = function(evt) { ASPx.KBSIKeyDown(name,evt); };
  this.onKeyPressHandler = function(evt) { ASPx.KBSIKeyPress(name, evt); };
  this.onKeyUpHandler = function(evt) { ASPx.KBSIKeyUp(name, evt); };
  this.onGotFocusHandler = function(evt) { ASPx.ESGotFocus(name); };
  this.onLostFocusHandler = function(evt) { ASPx.ESLostFocus(name); };
  this.specialKeyboardHandlingUsed = true;
  this.InitializeDelayedSpecialFocus();
 },
 InitializeKeyHandlers: function() {
 },
 AddKeyDownHandler: function(key, handler) {
  this.keyDownHandlers[key] = handler;
 },
 AddKeyPressHandler: function(key, handler) {
  this.keyPressHandlers[key] = handler;
 },
 ChangeSpecialInputEnabledAttributes: function(element, method, doNotChangeAutoComplete){
  if(!doNotChangeAutoComplete) 
   element.autocomplete = "off";
  if(this.onKeyDownHandler != null)
   method(element, "keydown", this.onKeyDownHandler);
  if(this.onKeyPressHandler != null)
   method(element, "keypress", this.onKeyPressHandler);
  if(this.onKeyUpHandler != null)
   method(element, "keyup", this.onKeyUpHandler);
  if(this.onGotFocusHandler != null)
   method(element, "focus", this.onGotFocusHandler);
  if(this.onLostFocusHandler != null)
   method(element, "blur", this.onLostFocusHandler);
 },
 UpdateClientValidationState: function() {
  if(!this.customValidationEnabled)
   return;
  var mainElement = this.GetMainElement();
  if(mainElement) {
   var validationState = !this.GetIsValid() ? ("-" + this.GetErrorText()) : "";
   this.UpdateStateObjectWithObject({ validationState: validationState });
  }
 },
 UpdateValidationSummaries: function(validationType, initializing) {
  if(ASPx.Ident.scripts.ASPxClientValidationSummary) {
   var summaryCollection = ASPx.GetClientValidationSummaryCollection();
   summaryCollection.OnEditorIsValidStateChanged(this, validationType, initializing && this.notifyValidationSummariesToAcceptNewError);
  }
 },
 FindInputElement: function(){
  return null;
 },
 GetInputElement: function(){
  if(!ASPx.IsExistsElement(this.inputElement))
   this.inputElement = this.FindInputElement();
  return this.inputElement;
 },
 GetFocusableInputElement: function() {
  return this.GetInputElement();
 },
 GetAccessibilityActiveElements: function() {
  return [this.GetInputElement()];
 },
 GetAccessibilityFirstActiveElement: function() {
  return this.accessibilityHelper ? 
    this.accessibilityHelper.getMainElement() : 
    this.GetAccessibilityActiveElements()[0];
 },
 GetAccessibilityAdditionalTextRowId: function() {
  return this.name + EditElementSuffix.AccessibilityAdditionalTextRow;
 },
 UpdateAccessibilityAdditionalTextRelation: function() {
  var additionalTextElement = this.GetAccessibilityAdditionalTextElement();
  if(ASPx.IsExists(additionalTextElement)) {
   var pronounceElement = this.GetAccessibilityFirstActiveElement();
   var hasAnyLabel = !!ASPx.Attr.GetAttribute(pronounceElement, "aria-label") || 
    !!ASPx.Attr.GetAttribute(pronounceElement, "aria-labelledby") ||
    ASPx.FindAssociatedLabelElements(this).length > 0;
   this.SetOrRemoveAccessibilityAdditionalText([pronounceElement], additionalTextElement, true, !hasAnyLabel, false);
  }
 },
 GetAccessibilityAdditionalTextElement: function() {
  if(!this.accessibilityCompliant) return null;
  var mainElement = this.GetMainElement();
  var additionalText = "";
  var additionalTextElement = null;
  if(!!this.nullText)
   additionalText = this.nullText;
  else if(!!this.helpTextObj)
   additionalTextElement = this.helpTextObj.helpTextElement;
  else if(!!mainElement.title)
   additionalText = mainElement.title;
  if(!!additionalText && mainElement.tagName == "TABLE") {
   additionalTextElement = ASPx.GetElementById(this.GetAccessibilityAdditionalTextRowId());
   if(!additionalTextElement)
    additionalTextElement = this.CreateAccessibilityAdditionalTextRow();
   ASPx.SetInnerHtml(additionalTextElement.cells[0], additionalText);
  }
  return additionalTextElement;
 },
 CreateAccessibilityAdditionalTextRow: function() {
  var textRow = this.GetMainElement().insertRow(-1);
  textRow.insertCell();
  textRow.id = this.GetAccessibilityAdditionalTextRowId();
  ASPx.AddClassNameToElement(textRow, AccessibilityInvisibleRowCssClassName);
  return textRow;
 },
 GetErrorImage: function() {
  return this.GetCachedElementById(EditElementSuffix.ErrorImage);
 },
 GetControlCell: function() {
  return this.GetCachedElementById(EditElementSuffix.ControlCell);
 },
 GetErrorCell: function() {
  return this.GetCachedElementById(EditElementSuffix.ErrorCell);
 },
 GetErrorTextCell: function() {
  return this.GetCachedElementById(this.errorImageIsAssigned ? EditElementSuffix.ErrorTextCell : EditElementSuffix.ErrorCell);
 },
 GetAccessibilityErrorTextElement: function () {
  return !!this.GetErrorTextCell() ? this.GetErrorTextCell() : this.GetErrorImage();
 },
 SetAccessibilityCaptionAssociating: function() {
  var captionCell = this.GetCaptionCell();
  if(!this.accessibilityCompliant || !captionCell || captionCell.childNodes[0].tagName == "LABEL") return;
  var labelElement = captionCell.childNodes[0];
  ASPx.SetAccessibilityLabelAssociating(this, this.GetAccessibilityFirstActiveElement(), labelElement);
 },
 SetOrRemoveAccessibilityAdditionalText: function(accessibilityElements, textElement, setText, isLabel, isFirst) {
  var idsRefAttribute = isLabel ? "aria-labelledby" : "aria-describedby";
  if(!this.accessibilityCompliant || !textElement) return;
  var textId = !!textElement.id ? textElement.id : textElement.parentNode.id;
  for(var i = 0; i < accessibilityElements.length; i++) {
   if(!accessibilityElements[i]) continue;
   var descRefString = ASPx.Attr.GetAttribute(accessibilityElements[i], idsRefAttribute);
   var descRefIds = !!descRefString ? descRefString.split(" ") : [ ];
   var descIndex = descRefIds.indexOf(textId);
   if(setText && descIndex == -1)
    isFirst ? descRefIds.unshift(textId) : descRefIds.push(textId);
   else if(!setText && descIndex > -1)
    descRefIds.splice(descIndex, 1);
   ASPx.Attr.SetOrRemoveAttribute(accessibilityElements[i], idsRefAttribute, descRefIds.join(" "));
  }
 },
 SetVisible: function (isVisible) {
  if(this.clientVisible == isVisible)
   return;
  var externalTable = this.GetExternalTable();
  if(externalTable) {
   ASPx.SetElementDisplay(externalTable, isVisible);
   if(this.customValidationEnabled) {
    var isValid = !isVisible ? true : void (0);
    this.UpdateErrorFrameAndFocus(false , true , isValid );
   }
  }
  ASPxClientControl.prototype.SetVisible.call(this, isVisible);
 },
 GetStateHiddenFieldName: function() {
  return this.uniqueID + "$State";
 },
 GetValueInputToValidate: function() {
  return this.GetInputElement();
 },
 IsVisible: function() {
  if(!this.clientVisible)
   return false;
  var element = this.GetMainElement();
  if(!element) 
   return false;
  while(element && element.tagName != "BODY") {
   if(element.getAttribute("errorFrame") != "errorFrame" && (!ASPx.GetElementVisibility(element) || !ASPx.GetElementDisplay(element)))
    return false;
   element = element.parentNode;
  }
  return true;
 },
 AdjustControlCore: function() {
  this.CollapseEditor();
  this.UnstretchInputElement();
  if(this.heightCorrectionRequired)
   this.CorrectEditorHeight();
 },
 CorrectEditorHeight: function() {
 },
 UnstretchInputElement: function() {
 },
 UseDelayedSpecialFocus: function() {
  return false;
 },
 GetDelayedSpecialFocusTriggers: function() {
  return [ this.GetMainElement() ];
 },
 InitializeDelayedSpecialFocus: function() {
  if(!this.UseDelayedSpecialFocus())
   return;
  this.specialFocusTimer = -1;    
  var handler = function(evt) { this.OnDelayedSpecialFocusMouseDown(evt); }.aspxBind(this);
  var triggers = this.GetDelayedSpecialFocusTriggers();
  for(var i = 0; i < triggers.length; i++)
   ASPx.Evt.AttachEventToElement(triggers[i], "mousedown", handler);
 },
 OnDelayedSpecialFocusMouseDown: function(evt) {
  window.setTimeout(function() { this.SetFocus(); }.aspxBind(this), 0);
 },
 IsFocusEventsLocked: function() {
  return this.focusEventsLocked;
 },
 LockFocusEvents: function() {
  if(!this.focused) return;
  this.focusEventsLocked = true;
 },
 UnlockFocusEvents: function() {
  this.focusEventsLocked = false;
 },
 ForceRefocusEditor: function(evt, isNativeFocus) {
  if(ASPx.Browser.VirtualKeyboardSupported) {
   var focusedEditor = ASPx.VirtualKeyboardUI.getFocusedEditor();
   if(ASPx.VirtualKeyboardUI.getInputNativeFocusLocked() && (!focusedEditor || focusedEditor === this))
     return;
   ASPx.VirtualKeyboardUI.setInputNativeFocusLocked(!isNativeFocus);
  }
  this.LockFocusEvents();
  this.BlurInputElement();
  window.setTimeout(function() { 
   if(ASPx.Browser.VirtualKeyboardSupported) {
    ASPx.VirtualKeyboardUI.setFocusEditorCore(this);
   } else {
    this.SetFocus();
   }
  }.aspxBind(this), 0);
 },
 BlurInputElement: function() {
  var inputElement = this.GetFocusableInputElement();
  if(inputElement && inputElement.blur)
   inputElement.blur();
 },
 IsEditorElement: function(element) {
  return this.GetMainElement() == element || ASPx.GetIsParent(this.GetMainElement(), element);
 },
 IsClearButtonElement: function(element) {
  return false;
 },
 IsElementBelongToInputElement: function(element) {
  return this.GetInputElement() == element;
 },
 OnFocusCore: function() {
  if(this.UseDelayedSpecialFocus())
   window.clearTimeout(this.specialFocusTimer);
  if(!this.IsFocusEventsLocked()){
   this.focused = true;
   ASPx.SetFocusedEditor(this);
   if(this.styleDecoration)
    this.styleDecoration.Update();
   if(this.isInitialized)
    this.RaiseFocus();
  }
  else
   this.UnlockFocusEvents();
 },
 OnLostFocusCore: function() {
  if(!this.IsFocusEventsLocked()){
   this.focused = false;
   if(!this.UseDelayedSpecialFocus() || ASPx.GetFocusedEditor() === this) 
    ASPx.SetFocusedEditor(null);
   if(this.styleDecoration)
    this.styleDecoration.Update();
   this.RaiseLostFocus();
  }
 },
 OnFocus: function() {
  if(!this.specialKeyboardHandlingUsed)
   this.OnFocusCore();
 },
 OnLostFocus: function() {
  if(this.isInitialized && !this.specialKeyboardHandlingUsed)
   this.OnLostFocusCore();
 },
 OnSpecialFocus: function() {
  if(this.isInitialized)
   this.OnFocusCore();
 },
 OnSpecialLostFocus: function() {
  if(this.isInitialized)
   this.OnLostFocusCore();
 },
 OnMouseWheel: function(evt){
 },
 OnValidation: function(validationType) {
  if(this.customValidationEnabled && this.isInitialized && ASPx.IsExistsElement(this.GetMainElement()) &&
   (!this.IsErrorFrameDisplayed() || this.GetExternalTable())) {
   this.BeginErrorFrameUpdate();
   try {
    if(this.validateOnLeave || validationType != ValidationType.PersonalOnValueChanged) {
     this.SetIsValid(true, true );
     this.SetErrorText(this.initialErrorText, true );
     this.ValidateWithPatterns();
     this.RaiseValidation();
    }
    this.UpdateErrorFrameAndFocus(this.editorFocusingRequired(validationType));
   } finally {
    this.EndErrorFrameUpdate();
   }
   this.UpdateValidationSummaries(validationType);
   this.UpdateValidationAccessibilityAttributes(validationType);
  }
 },
 UpdateValidationAccessibilityAttributes: function(validationType) {
  if(!this.accessibilityCompliant || (validationType == ValidationType.PersonalOnValueChanged && this.accessibilityHelper)) return;
  var accessibilityElements = this.GetAccessibilityActiveElements();
  var errorTextElement = this.GetAccessibilityErrorTextElement();
  this.SetOrRemoveAccessibilityAdditionalText(accessibilityElements, errorTextElement, !this.isValid, false, true);
  if(accessibilityElements.length > 0 && !!errorTextElement) {
   for(var i = 0; i < accessibilityElements.length; i++) {
    if(!ASPx.IsExists(accessibilityElements[i])) continue;
    ASPx.Attr.SetOrRemoveAttribute(accessibilityElements[i], "aria-invalid", !this.isValid);
   }
  }
 },
 editorFocusingRequired: function(validationType) {
  return !this.GetIsValid() && ((validationType == ValidationType.PersonalOnValueChanged && this.validateOnLeave) ||
         (validationType == ValidationType.PersonalViaScript && this.setFocusOnError));
 },
 OnValueChanged: function() {
  var processOnServer = this.RaiseValidationInternal();
  processOnServer = this.RaiseValueChangedEvent() && processOnServer;
  if(processOnServer)
   this.SendPostBackInternal("");
 },
 ParseValue: function() {
 },
 RaisePersonalStandardValidation: function() {
  if(ASPx.IsFunction(window.ValidatorOnChange)) {
   var inputElement = this.GetValueInputToValidate();
   if(inputElement && inputElement.Validators)
    window.ValidatorOnChange({ srcElement: inputElement });
  }
 },
 RaiseValidationInternal: function() {
  if(this.isPostBackAllowed() && this.causesValidation && this.validateOnLeave)
   return ASPxClientEdit.ValidateGroup(this.validationGroup);
  else {
   this.OnValidation(ValidationType.PersonalOnValueChanged);
   return this.GetIsValid();
  }
 },
 RaiseValueChangedEvent: function(){
  return this.RaiseValueChanged();
 },
 SendPostBackInternal: function(postBackArg) {
  if(ASPx.IsFunction(this.sendPostBackWithValidation))
   this.sendPostBackWithValidation(postBackArg);
  else
   this.SendPostBack(postBackArg);
 },
 SetElementToBeFocused: function() {
  if(this.IsVisible())
   invalidEditorToBeFocused = this;
 },
 GetFocusSelectAction: function() {
  return null;
 },
 SetFocus: function() {
  var inputElement = this.GetFocusableInputElement();
  if(!inputElement) return; 
  var isIE9 = ASPx.Browser.IE && ASPx.Browser.Version >= 9;
  if((ASPx.GetActiveElement() != inputElement || isIE9) && _aspxIsEditorFocusable(inputElement))
   ASPx.SetFocus(inputElement, this.GetFocusSelectAction());
 },
 SetFocusOnError: function() {
  if(invalidEditorToBeFocused == this) {
   this.SetFocus();
   invalidEditorToBeFocused = null;
  }
 },
 BeginErrorFrameUpdate: function() {
  if(!this.errorFrameUpdateLocked)
   this.errorFrameUpdateLocked = true;
 },
 EndErrorFrameUpdate: function() {
  this.errorFrameUpdateLocked = false;
  var args = this.updateErrorFrameAndFocusLastCallArgs;
  if(args) {
   this.UpdateErrorFrameAndFocus(args[0], args[1]);
   delete this.updateErrorFrameAndFocusLastCallArgs;
  }
 },
 UpdateErrorFrameAndFocus: function(setFocusOnError, ignoreVisibilityCheck, isValid) {
  if(!this.GetEnabled() || !ignoreVisibilityCheck && !this.GetVisible())
   return;
  if(this.errorFrameUpdateLocked) {
   this.updateErrorFrameAndFocusLastCallArgs = [ setFocusOnError, ignoreVisibilityCheck ];
   return;
  }
  if(this.styleDecoration)
   this.styleDecoration.Update();
  if(typeof(isValid) == "undefined")
   isValid = this.GetIsValid();
  var externalTable = this.GetExternalTable();
  var isStaticDisplay = this.display == ErrorFrameDisplay.Static;
  if(isValid && this.IsErrorFrameDisplayed()) {
   if(isStaticDisplay) {
    this.HideErrorCell(true);
    ASPx.AddClassNameToElement(externalTable, ASPxEditExternalTableClassNames.ValidStaticTableClassName);
   } else {
    this.HideErrorCell();
    this.SaveControlCellStyles();
    this.ClearControlCellStyles();
    ASPx.AddClassNameToElement(externalTable, ASPxEditExternalTableClassNames.ValidDynamicTableClassName);
   }
  } else {
   var editorLocatedWithinVisibleContainer = this.IsVisible();
   if(this.IsErrorFrameDisplayed()) {
    this.UpdateErrorCellContent();
    if(isStaticDisplay) {
     this.ShowErrorCell(true);
     ASPx.RemoveClassNameFromElement(externalTable, ASPxEditExternalTableClassNames.ValidStaticTableClassName);
    } else {
     this.EnsureControlCellStylesLoaded();
     this.RestoreControlCellStyles();
     this.ShowErrorCell();
     ASPx.RemoveClassNameFromElement(externalTable, ASPxEditExternalTableClassNames.ValidDynamicTableClassName);
    }
   }
   if(editorLocatedWithinVisibleContainer) {
    if(setFocusOnError && this.setFocusOnError && invalidEditorToBeFocused == null) {
     this.SetElementToBeFocused();
     this.SetFocusOnError();
    }
   }
  }
 },
 ShowErrorCell: function (useVisibilityAttribute) {
  var errorCell = this.GetErrorCell();
  if(errorCell) {
   if(useVisibilityAttribute)
    ASPx.SetElementVisibility(errorCell, true);
   else
    ASPx.SetElementDisplay(errorCell, true);
  }
 },
 HideErrorCell: function(useVisibilityAttribute) {
  var errorCell = this.GetErrorCell();
  if(errorCell) {
   if(useVisibilityAttribute)
    ASPx.SetElementVisibility(errorCell, false);
   else
    ASPx.SetElementDisplay(errorCell, false);
  }
 },
 SaveControlCellStyles: function() {
  this.EnsureControlCellStylesLoaded();
 },
 EnsureControlCellStylesLoaded: function() {
  if(typeof(this.controlCellStyles) == "undefined") {
   var controlCell = this.GetControlCell();
   this.controlCellStyles = {
    cssClass: controlCell.className,
    style: this.ExtractElementStyleStringIgnoringVisibilityProps(controlCell)
   };
  }
 },
 ClearControlCellStyles: function() {
  this.ClearElementStyle(this.GetControlCell());
 },
 RestoreControlCellStyles: function() {
  var controlCell = this.GetControlCell();
  var externalTable = this.GetExternalTable();
  if(ASPx.Browser.WebKitFamily)
   this.MakeBorderSeparateForTable(externalTable);
  controlCell.className = this.controlCellStyles.cssClass;
  controlCell.style.cssText = this.controlCellStyles.style;
  if(ASPx.Browser.WebKitFamily)
   this.UndoBorderSeparateForTable(externalTable);
 },
 MakeBorderSeparateForTable: function(table) {
  ASPx.AddClassNameToElement(table, ASPxEditExternalTableClassNames.TableWithSeparateBordersClassName);
 },
 UndoBorderSeparateForTable: function(table) {
  setTimeout(function () {
   ASPx.RemoveClassNameFromElement(table, ASPxEditExternalTableClassNames.TableWithSeparateBordersClassName);
  }, 0);
 },
 ExtractElementStyleStringIgnoringVisibilityProps: function(element) {
  var savedVisibility = element.style.visibility;
  var savedDisplay = element.style.display;
  element.style.visibility = "";
  element.style.display = "";
  var styleStr = element.style.cssText;
  element.style.visibility = savedVisibility;
  element.style.display = savedDisplay;
  return styleStr;
 },
 ClearElementStyle: function(element) {
  if(!element)
   return;
  element.className = "";
  var excludedAttrNames = [
   "width", "display", "visibility",
   "position", "left", "top", "z-index",
   "margin", "margin-top", "margin-right", "margin-bottom", "margin-left",
   "float", "clear"
  ];
  var savedAttrValues = { };
  for(var i = 0; i < excludedAttrNames.length; i++) {
   var attrName = excludedAttrNames[i];
   var attrValue = element.style[attrName];
   if(attrValue)
    savedAttrValues[attrName] = attrValue;
  }
  element.style.cssText = "";
  for(var styleAttrName in savedAttrValues)
   element.style[styleAttrName] = savedAttrValues[styleAttrName];
 },
 Clear: function() {
  this.SetValue(null);
  this.SetIsValid(true);
  return true;
 },
 UpdateErrorCellContent: function() {
  if(this.errorDisplayMode.indexOf("t") > -1)
   this.UpdateErrorText();
  if(this.errorDisplayMode == "i")
   this.UpdateErrorImage();
 },
 UpdateErrorImage: function() {
  var image = this.GetErrorImage();
  if(ASPx.IsExistsElement(image)) {
   if(this.accessibilityCompliant) {
    ASPx.Attr.SetAttribute(image, "aria-label", this.errorText);
    var innerImg = ASPx.GetNodeByTagName(image, "IMG", 0);
    if(ASPx.IsExists(innerImg))
     innerImg.alt = this.errorText;
   }
   image.alt = this.errorText;
   image.title = this.errorText;
  } else {
   this.UpdateErrorText();
  }
 },
 UpdateErrorText: function() {
  var errorTextCell = this.GetErrorTextCell();
  if(ASPx.IsExistsElement(errorTextCell))
   errorTextCell.innerHTML = this.HtmlEncode(this.errorText);
 },
 ValidateWithPatterns: function() {
  if(this.validationPatterns.length > 0) {
   var value = this.GetValue();
   for(var i = 0; i < this.validationPatterns.length; i++) {
    var validator = this.validationPatterns[i];
    if(!validator.EvaluateIsValid(value)) {
     this.SetIsValid(false, true );
     this.SetErrorText(validator.errorText, true );
     return;
    }
   }
  }
 },
 OnSpecialKeyDown: function(evt){
  this.RaiseKeyDown(evt);
  var handler = this.keyDownHandlers[evt.keyCode];
  if(handler) 
   return this[handler](evt);
  return false;
 },
 OnSpecialKeyPress: function(evt){
  this.RaiseKeyPress(evt);
  var handler = this.keyPressHandlers[evt.keyCode];
  if(handler) 
   return this[handler](evt);
  if(ASPx.Browser.NetscapeFamily || ASPx.Browser.Opera){
   if(evt.keyCode == ASPx.Key.Enter)
    return this.enterProcessed;
  }
  return false;
 },
 OnSpecialKeyUp: function(evt){
  this.RaiseKeyUp(evt);
  var handler = this.keyUpHandlers[evt.keyCode];
  if(handler) 
   return this[handler](evt);
  return false;
 },
 OnKeyDown: function(evt) {
  if(!this.specialKeyboardHandlingUsed)
   this.RaiseKeyDown(evt);
 },
 OnKeyPress: function(evt) {
  if(!this.specialKeyboardHandlingUsed)
   this.RaiseKeyPress(evt);
 },
 OnKeyUp: function(evt) {
  if(!this.specialKeyboardHandlingUsed)
   this.RaiseKeyUp(evt);
 },
 RaiseKeyDown: function(evt){
  if(!this.KeyDown.IsEmpty()){
   var args = new ASPxClientEditKeyEventArgs(evt);
   this.KeyDown.FireEvent(this, args);
  }
 },
 RaiseKeyPress: function(evt){
  if(!this.KeyPress.IsEmpty()){
   var args = new ASPxClientEditKeyEventArgs(evt);
   this.KeyPress.FireEvent(this, args);
  }
 },
 RaiseKeyUp: function(evt){
  if(!this.KeyUp.IsEmpty()){
   var args = new ASPxClientEditKeyEventArgs(evt);
   this.KeyUp.FireEvent(this, args);
  }
 },
 RaiseFocus: function(){
  if(!this.GotFocus.IsEmpty()){
   var args = new ASPxClientEventArgs();
   this.GotFocus.FireEvent(this, args);
  }
 },
 RaiseLostFocus: function(){
  if(!this.LostFocus.IsEmpty()){
   var args = new ASPxClientEventArgs();
   this.LostFocus.FireEvent(this, args);
  }
 },
 RaiseValidation: function() {
  if(this.customValidationEnabled && !this.Validation.IsEmpty()) {
   var currentValue = this.GetValue();
   var args = new ASPxClientEditValidationEventArgs(currentValue, this.errorText, this.GetIsValid());
   this.Validation.FireEvent(this, args);
   this.SetErrorText(args.errorText, true );
   this.SetIsValid(args.isValid, true );
   if(args.value != currentValue)
    this.SetValue(args.value);
  }
 },
 RaiseValueChanged: function(){
  var processOnServer = this.isPostBackAllowed();
  if(!this.ValueChanged.IsEmpty()){
   var args = new ASPxClientProcessingModeEventArgs(processOnServer);
   this.ValueChanged.FireEvent(this, args);
   processOnServer = args.processOnServer;
  }
  return processOnServer;  
 },
 isPostBackAllowed: function() {
  return this.autoPostBack;
 },
 AddDecorationStyle: function(key, className, cssText) {
  if(!this.styleDecoration) 
   this.RequireStyleDecoration();
  this.styleDecoration.AddStyle(key, className, cssText);
 }, 
 RequireStyleDecoration: function() {
  this.styleDecoration = new ASPx.EditorStyleDecoration(this);
  this.PopulateStyleDecorationPostfixes();
 }, 
 PopulateStyleDecorationPostfixes: function() {
  this.styleDecoration.AddPostfix("");
 },
 Focus: function(){
  this.SetFocus();
 },
 GetIsValid: function() {
  var hasRequiredInputElement = !this.RequireInputElementToValidate() || ASPx.IsExistsElement(this.GetInputElement());
  if(!hasRequiredInputElement || this.IsErrorFrameDisplayed() && !ASPx.IsExistsElement(this.GetExternalTable()))
   return true;
  return this.isValid;
 },
 RequireInputElementToValidate: function() {
  return true;
 },
 IsErrorFrameDisplayed: function() {
  return this.display !== ErrorFrameDisplay.None;
 },
 GetErrorText: function(){
  return this.errorText;
 },
 SetIsValid: function(isValid, validating){
  if(this.customValidationEnabled && this.isValid != isValid) {
   this.isValid = isValid;
   this.UpdateErrorFrameAndFocus(false );
   this.UpdateClientValidationState();
   if(!validating)
    this.UpdateValidationSummaries(ValidationType.PersonalViaScript);
  }
 },
 SetErrorText: function(errorText, validating){
  if(this.customValidationEnabled && this.errorText != errorText) {
   this.errorText = errorText;
   this.UpdateErrorFrameAndFocus(false );
   this.UpdateClientValidationState();
   if(!validating)
    this.UpdateValidationSummaries(ValidationType.PersonalViaScript);
  }
 },
 Validate: function(){
  this.ParseValue();
  this.OnValidation(ValidationType.PersonalViaScript);
 }
});
ASPx.Ident.scripts.ASPxClientEdit = true;
ASPx.focusedEditorName = "";
ASPx.GetFocusedEditor = function() {
 var focusedEditor = ASPx.GetControlCollection().Get(ASPx.focusedEditorName);
 if(focusedEditor && !focusedEditor.focused){
  ASPx.SetFocusedEditor(null);
  focusedEditor = null;
 }
 return focusedEditor;
}
ASPx.SetFocusedEditor = function(editor) {
 ASPx.focusedEditorName = editor ? editor.name : "";
}
ASPx.SetAccessibilityLabelAssociating = function(editor, activeElement, labelElement) {
 var clickHandler = function(evt) {
  if(editor && editor.OnAssociatedLabelClick)
   editor.OnAssociatedLabelClick(evt);
  else
   activeElement.click();
 }.aspxBind(this);
 ASPx.Evt.AttachEventToElement(labelElement, "click", clickHandler);
 if(!!editor) {
  var hasAriaLabel = !!ASPx.Attr.GetAttribute(activeElement, "aria-label");
  editor.SetOrRemoveAccessibilityAdditionalText([activeElement], labelElement, true, !hasAriaLabel, true);
 }
}
ASPx.FindAssociatedLabelElements = function(editor) {
 var assocciatedLabels = [];
 var inputElement = editor.GetInputElement();
 if(!ASPx.IsExists(inputElement) || !inputElement.id) 
  return assocciatedLabels;
 var labels = ASPx.GetNodesByTagName(document, "LABEL");
 for(var i = 0; i < labels.length; i++) {
  if(!!labels[i].htmlFor && labels[i].htmlFor === inputElement.id)
   assocciatedLabels.push(labels[i]);
 }
 return assocciatedLabels;
}
ASPxClientEdit.ClearEditorsInContainer = function(container, validationGroup, clearInvisibleEditors) {
 invalidEditorToBeFocused = null;
 ASPx.ProcessEditorsInContainer(container, ASPx.ClearProcessingProc, ASPx.ClearChoiceCondition, validationGroup, clearInvisibleEditors, true );
 ASPxClientEdit.ClearExternalControlsInContainer(container, validationGroup, clearInvisibleEditors);
}
ASPxClientEdit.ClearEditorsInContainerById = function(containerId, validationGroup, clearInvisibleEditors) {
 var container = document.getElementById(containerId);
 this.ClearEditorsInContainer(container, validationGroup, clearInvisibleEditors);
}
ASPxClientEdit.ClearGroup = function(validationGroup, clearInvisibleEditors) {
 return this.ClearEditorsInContainer(null, validationGroup, clearInvisibleEditors);
}
ASPxClientEdit.ValidateEditorsInContainer = function(container, validationGroup, validateInvisibleEditors) {
 var summaryCollection;
 if(ASPx.Ident.scripts.ASPxClientValidationSummary) {
  summaryCollection = ASPx.GetClientValidationSummaryCollection();
  summaryCollection.AllowNewErrorsAccepting(validationGroup);
 }
 var validationResult = ASPx.ProcessEditorsInContainer(container, ASPx.ValidateProcessingProc, _aspxValidateChoiceCondition, validationGroup, validateInvisibleEditors,
  false );
 validationResult.isValid = ASPxClientEdit.ValidateExternalControlsInContainer(container, validationGroup, validateInvisibleEditors) && validationResult.isValid;
 if(typeof(validateInvisibleEditors) == "undefined")
  validateInvisibleEditors = false;
 if(typeof(validationGroup) == "undefined")
  validationGroup = null;    
 ASPx.GetControlCollection().RaiseValidationCompleted(container, validationGroup,
 validateInvisibleEditors, validationResult.isValid, validationResult.firstInvalid, validationResult.firstVisibleInvalid);
 if(summaryCollection)
  summaryCollection.ForbidNewErrorsAccepting(validationGroup);
 if(!validationResult.isValid && !!validationResult.firstVisibleInvalid && validationResult.firstVisibleInvalid.accessibilityCompliant && !validationResult.firstVisibleInvalid.setFocusOnError) {
  var accessInvalidControl = validationResult.firstVisibleInvalid;
  if(!summaryCollection && !accessInvalidControl.focused) {
   var beforeDelayActiveElement = ASPx.GetActiveElement();
   setTimeout(function() {
    var currentActiveElement = ASPx.GetActiveElement();
    if(accessInvalidControl.focused || (currentActiveElement != beforeDelayActiveElement && ASPx.Attr.IsExistsAttribute(currentActiveElement, 'role')))
     return;
    var errorTextElement = accessInvalidControl.GetAccessibilityErrorTextElement();
    ASPx.SetElementDisplay(errorTextElement, false);
    ASPx.Attr.SetAttribute(errorTextElement, 'role', 'alert');
    ASPx.SetElementDisplay(errorTextElement, true);
    setTimeout(function() { ASPx.Attr.RemoveAttribute(errorTextElement, 'role'); }, 500);
   }, 500);    
  }
 }
 return validationResult.isValid;
}
ASPxClientEdit.ValidateEditorsInContainerById = function(containerId, validationGroup, validateInvisibleEditors) {
 var container = document.getElementById(containerId);
 return this.ValidateEditorsInContainer(container, validationGroup, validateInvisibleEditors);
}
ASPxClientEdit.ValidateGroup = function(validationGroup, validateInvisibleEditors) {
 return this.ValidateEditorsInContainer(null, validationGroup, validateInvisibleEditors);
}
ASPxClientEdit.AreEditorsValid = function(containerOrContainerId, validationGroup, checkInvisibleEditors) {
 var container = typeof(containerOrContainerId) == "string" ? document.getElementById(containerOrContainerId) : containerOrContainerId;
 var checkResult = ASPx.ProcessEditorsInContainer(container, ASPx.EditorsValidProcessingProc, _aspxEditorsValidChoiceCondition, validationGroup,
  checkInvisibleEditors, false );
 checkResult.isValid = ASPxClientEdit.AreExternalControlsValidInContainer(containerOrContainerId, validationGroup, checkInvisibleEditors) && checkResult.isValid;
 return checkResult.isValid;
}
ASPxClientEdit.AreExternalControlsValidInContainer = function(containerId, validationGroup, validateInvisibleEditors) {
 if(ASPx.Ident.scripts.ASPxClientHtmlEditor)
  return ASPxClientHtmlEditor.AreEditorsValidInContainer(containerId, validationGroup, validateInvisibleEditors);
 return true;
}
ASPxClientEdit.ClearExternalControlsInContainer = function(containerId, validationGroup, validateInvisibleEditors) {
 if(ASPx.Ident.scripts.ASPxClientHtmlEditor)
  return ASPxClientHtmlEditor.ClearEditorsInContainer(containerId, validationGroup, validateInvisibleEditors);
 return true;
}
ASPxClientEdit.ValidateExternalControlsInContainer = function(containerId, validationGroup, validateInvisibleEditors) {
 if(ASPx.Ident.scripts.ASPxClientHtmlEditor)
  return ASPxClientHtmlEditor.ValidateEditorsInContainer(containerId, validationGroup, validateInvisibleEditors);
 return true;
}
var ASPxClientEditKeyEventArgs = ASPx.CreateClass(ASPxClientEventArgs, {
 constructor: function(htmlEvent) {
  this.constructor.prototype.constructor.call(this);
  this.htmlEvent = htmlEvent;
 }
});
var ASPxClientEditValidationEventArgs = ASPx.CreateClass(ASPxClientEventArgs, {
 constructor: function(value, errorText, isValid) {
  this.constructor.prototype.constructor.call(this);
  this.errorText = errorText;
  this.isValid = isValid;
  this.value = value;
 }
});
ASPx.ProcessEditorsInContainer = function(container, processingProc, choiceCondition, validationGroup, processInvisibleEditors, processDisabledEditors) {
 var allProcessedSuccessfull = true;
 var firstInvalid = null;
 var firstVisibleInvalid = null;
 var invalidEditorToBeFocused = null;
 ASPx.GetControlCollection().ForEachControl(function(control) {
  var needToProcessRatingControl = window.ASPxClientRatingControl && (control instanceof ASPxClientRatingControl) && processingProc === ASPx.ClearProcessingProc;
  if(!ASPx.Ident.isDialogInvisibleControl(control) && (ASPx.Ident.IsASPxClientEdit(control) || needToProcessRatingControl) && (processDisabledEditors || control.GetEnabled())) {
   var mainElement = control.GetMainElement();
   if(mainElement &&
    (container == null || ASPx.GetIsParent(container, mainElement)) &&
    (processInvisibleEditors || control.IsVisible()) &&
    (!choiceCondition || choiceCondition(control, validationGroup))) {
    var isSuccess = processingProc(control);
    if(!isSuccess) {
     allProcessedSuccessfull = false;
     if(firstInvalid == null)
      firstInvalid = control;
     var isVisible = control.IsVisible();
     if(isVisible && firstVisibleInvalid == null)
      firstVisibleInvalid = control;
     if(control.setFocusOnError && invalidEditorToBeFocused == null && isVisible)
      invalidEditorToBeFocused = control;
    }
   }
  }
 }, this);
 if(invalidEditorToBeFocused != null)
  invalidEditorToBeFocused.SetFocus();
 return new ASPxValidationResult(allProcessedSuccessfull, firstInvalid, firstVisibleInvalid);
}
var ASPxValidationResult = ASPx.CreateClass(null, {
 constructor: function(isValid, firstInvalid, firstVisibleInvalid) {
  this.isValid = isValid;
  this.firstInvalid = firstInvalid;
  this.firstVisibleInvalid = firstVisibleInvalid;
 }
});
ASPx.ClearChoiceCondition = function(edit, validationGroup) {
 return !ASPx.IsExists(validationGroup) || (edit.validationGroup == validationGroup);
}
function _aspxValidateChoiceCondition(edit, validationGroup) {
 return ASPx.ClearChoiceCondition(edit, validationGroup) && edit.customValidationEnabled;
}
function _aspxEditorsValidChoiceCondition(edit, validationGroup) {
 return _aspxValidateChoiceCondition(edit, validationGroup);
}
function wrapLostFocusHandler(handler) {
 if(ASPx.Browser.Edge) {
  return function(name) {
   var edit = ASPx.GetControlCollection().Get(name);
   if(edit && !ASPx.IsElementVisible(edit.GetMainElement()))
    setTimeout(handler, 0, name);
   else
    handler(name);
  };
 }
 return handler;
};
ASPx.EGotFocus = function(name) {
 var edit = ASPx.GetControlCollection().Get(name); 
 if(!edit) return;
 if(!edit.isInitialized){
  var inputElement = edit.GetFocusableInputElement();
  if(inputElement && inputElement === document.activeElement)
   ASPx.Browser.Firefox ? window.setTimeout(function() { document.activeElement.blur(); }, 0) : document.activeElement.blur();
  return;
 }
  if(ASPx.Browser.VirtualKeyboardSupported) {
  ASPx.VirtualKeyboardUI.onCallingVirtualKeyboard(edit, false);
 } else {
  edit.OnFocus();
 }
}
ASPx.ELostFocusCore = function(name) {
 if(ASPx.Browser.VirtualKeyboardSupported) {
  var supressLostFocus = ASPx.VirtualKeyboardUI.isInputNativeBluring();
  if(supressLostFocus)
   return;
  ASPx.VirtualKeyboardUI.resetFocusedEditor();
 }
 var edit = ASPx.GetControlCollection().Get(name);
 if(edit != null) 
  edit.OnLostFocus();
}
ASPx.ELostFocus = wrapLostFocusHandler(ASPx.ELostFocusCore);
ASPx.ESGotFocus = function(name) {
 var edit = ASPx.GetControlCollection().Get(name); 
 if(!edit) return;
   if(ASPx.Browser.VirtualKeyboardSupported) {
  ASPx.VirtualKeyboardUI.onCallingVirtualKeyboard(edit, true);
 } else {
  edit.OnSpecialFocus();
 }
}
ASPx.ESLostFocusCore = function(name) {
 if(ASPx.Browser.VirtualKeyboardSupported) {
  var supressLostFocus = ASPx.VirtualKeyboardUI.isInputNativeBluring();
  if(supressLostFocus)
   return;
  ASPx.VirtualKeyboardUI.resetFocusedEditor();
 }
 var edit = ASPx.GetControlCollection().Get(name);
 if(!edit) return;
 if(edit.UseDelayedSpecialFocus())
  edit.specialFocusTimer = window.setTimeout(function() { edit.OnSpecialLostFocus(); }, 30);
 else
  edit.OnSpecialLostFocus();
}
ASPx.ESLostFocus = wrapLostFocusHandler(ASPx.ESLostFocusCore);
ASPx.EValueChanged = function(name) {
 var edit = ASPx.GetControlCollection().Get(name);
 if(edit != null)
  edit.OnValueChanged();
}
ASPx.VirtualKeyboardUI = (function() {
 var focusedEditor = null;
 var inputNativeFocusLocked = false;
 function elementBelongsToEditor(element) {
  if(!element) return false;
  var isBelongsToEditor = false;
  ASPx.GetControlCollection().ForEachControl(function(control) {
   if(ASPx.Ident.IsASPxClientEdit(control) && control.IsEditorElement(element)) {
    isBelongsToEditor = true;
    return true;
   }
  }, this);
  return isBelongsToEditor;
 }
 function elementBelongsToFocusedEditor(element) {
  return focusedEditor && focusedEditor.IsEditorElement(element);
 }
 return {
  onTouchStart: function (evt) {
   if (!ASPx.Browser.VirtualKeyboardSupported) return;
   inputNativeFocusLocked = false;
   if(ASPx.TouchUIHelper.pointerEnabled) {
    if(evt.pointerType != ASPx.TouchUIHelper.pointerType.Touch)
     return;
    this.processFocusEditorControl(evt);
   } else
    ASPx.TouchUIHelper.handleFastTapIfRequired(evt,  function(){ this.processFocusEditorControl(evt); }.aspxBind(this), false);
  },
  processFocusEditorControl: function(evt) {
   var evtSource = ASPx.Evt.GetEventSource(evt);
   var timeEditHasAppliedFocus = focusedEditor && (ASPx.Ident.IsASPxClientTimeEdit && ASPx.Ident.IsASPxClientTimeEdit(focusedEditor));
   var focusedTimeEditBelongsToDateEdit = timeEditHasAppliedFocus && focusedEditor.OwnerDateEdit && focusedEditor.OwnerDateEdit.GetShowTimeSection();
   if(focusedTimeEditBelongsToDateEdit) {
    focusedEditor.OwnerDateEdit.ForceRefocusTimeSectionTimeEdit(evtSource);
    return;
   }
   var elementWithNativeFocus = ASPx.GetActiveElement();
   var someEditorInputIsFocused = elementBelongsToEditor(elementWithNativeFocus);
   var touchKeyboardIsVisible = someEditorInputIsFocused;
   var tapOutsideEditorAndInputs = !elementBelongsToEditor(evtSource) && !ASPx.Ident.IsFocusableElementRegardlessTabIndex(evtSource);
   var blurToHideTouchKeyboard = touchKeyboardIsVisible && tapOutsideEditorAndInputs;
   if(blurToHideTouchKeyboard) {
    elementWithNativeFocus.blur();
    return;
   }
   var tapOutsideFocusedEditor = focusedEditor && !elementBelongsToFocusedEditor(evtSource);
   if(tapOutsideFocusedEditor) {
    var focusedEditorWithBluredInput = !elementBelongsToFocusedEditor(elementWithNativeFocus);
    if(focusedEditorWithBluredInput) 
     this.lostAppliedFocusOfEditor();
   }
  },
  smartFocusEditor: function(edit) {
   if(!edit.focused) {
    this.setInputNativeFocusLocked(true);
    this.setFocusEditorCore(edit);
   } else {
    edit.ForceRefocusEditor();
   }
  },
  setFocusEditorCore: function(edit) {
   if(ASPx.Browser.MacOSMobilePlatform) {
    var timeoutDuration = ASPx.Browser.Chrome ? 250 : 30;
    window.setTimeout(function(){ edit.SetFocus(); }, timeoutDuration);
   } else {
    edit.SetFocus();
   }
  },
  onCallingVirtualKeyboard: function(edit, isSpecial) {
   this.setAppliedFocusOfEditor(edit, isSpecial);
   if(edit.specialKeyboardHandlingUsed == isSpecial && inputNativeFocusLocked)
    edit.BlurInputElement();
  },
  isInputNativeBluring: function() {
   return focusedEditor && inputNativeFocusLocked;
  },
  setInputNativeFocusLocked: function(locked) {
   inputNativeFocusLocked = locked;
  },
  getInputNativeFocusLocked: function() {
   return inputNativeFocusLocked;
  },
  setAppliedFocusOfEditor: function(edit, isSpecial) {
   if(focusedEditor === edit) {
    if(edit.specialKeyboardHandlingUsed == isSpecial) {
     focusedEditor.UnlockFocusEvents();
     if(focusedEditor.EnsureClearButtonVisibility)
      focusedEditor.EnsureClearButtonVisibility();
    }
    return;
   }
   if(edit.specialKeyboardHandlingUsed == isSpecial) {
    this.lostAppliedFocusOfEditor();
    focusedEditor = edit;
    ASPx.SetFocusedEditor(edit);
   }
   if(isSpecial)
    edit.OnSpecialFocus();
   else
    edit.OnFocus();
  },
  lostAppliedFocusOfEditor: function() {
   if(!focusedEditor) return;
   var curEditorName = focusedEditor.name; 
   var skbdHandlingUsed = focusedEditor.specialKeyboardHandlingUsed;
   var focusedEditorInputElementExists = focusedEditor.GetInputElement();
   focusedEditor = null;
   if(!focusedEditorInputElementExists)
    return;
   ASPx.ELostFocusCore(curEditorName);
   if(skbdHandlingUsed)
    ASPx.ESLostFocusCore(curEditorName);
  },
  getFocusedEditor: function() {
   return focusedEditor;
  },
  resetFocusedEditor: function() {
   focusedEditor = null;
  },
  focusableInputElementIsActive: function(edit) {
   var inputElement = edit.GetFocusableInputElement();
   return !!inputElement ? ASPx.GetActiveElement() === inputElement : false;
  }
 }
})();
if(ASPx.Browser.VirtualKeyboardSupported) {
 var touchEventName = ASPx.TouchUIHelper.pointerEnabled ? ASPx.TouchUIHelper.pointerDownEventName : 'touchstart';
 ASPx.Evt.AttachEventToDocument(touchEventName, function(evt){ ASPx.VirtualKeyboardUI.onTouchStart(evt); });
}
ASPx.Evt.AttachEventToDocument("mousedown", function(evt) {
 var editor = ASPx.GetFocusedEditor();
 if(!editor) 
  return;
 var evtSource = ASPx.Evt.GetEventSource(evt);
 if(editor.IsClearButtonElement(evtSource))
  return;
 if(editor.OwnerDateEdit && editor.OwnerDateEdit.GetShowTimeSection()) {
  editor.OwnerDateEdit.ForceRefocusTimeSectionTimeEdit(evtSource);
  return;
 }
 if(editor.IsEditorElement(evtSource) && !editor.IsElementBelongToInputElement(evtSource))
  editor.ForceRefocusEditor(evt);
});
ASPx.Evt.AttachEventToDocument(ASPx.Evt.GetMouseWheelEventName(), function(evt) {
 var editor = ASPx.GetFocusedEditor();
 if(editor != null && ASPx.IsExistsElement(editor.GetMainElement()) && editor.focused && editor.receiveGlobalMouseWheel)
  editor.OnMouseWheel(evt);
});
ASPx.KBSIKeyDown = function(name, evt){
 var control = ASPx.GetControlCollection().Get(name);
 if(control != null){
  var isProcessed = control.OnSpecialKeyDown(evt);
  if(isProcessed)
   return ASPx.Evt.PreventEventAndBubble(evt);
 }
}
ASPx.KBSIKeyPress = function(name, evt){
 var control = ASPx.GetControlCollection().Get(name);
 if(control != null){
  var isProcessed = control.OnSpecialKeyPress(evt);
  if(isProcessed)
   return ASPx.Evt.PreventEventAndBubble(evt);
 }
}
ASPx.KBSIKeyUp = function(name, evt){
 var control = ASPx.GetControlCollection().Get(name);
 if(control != null){
  var isProcessed = control.OnSpecialKeyUp(evt);
  if(isProcessed)
   return ASPx.Evt.PreventEventAndBubble(evt);
 }
}
ASPx.ClearProcessingProc = function(edit) {
 return edit.Clear();
}
ASPx.ValidateProcessingProc = function(edit) {
 edit.OnValidation(ValidationType.MassValidation);
 return edit.GetIsValid();
}
ASPx.EditorsValidProcessingProc = function(edit) {
 return edit.GetIsValid();
}
var CheckEditElementHelper = ASPx.CreateClass(ASPx.CheckableElementHelper, {
 AttachToMainElement: function(internalCheckBox) {
  ASPx.CheckableElementHelper.prototype.AttachToMainElement.call(this, internalCheckBox);
  this.AttachToLabelElement(this.GetLabelElement(internalCheckBox.container), internalCheckBox);
 },
 AttachToLabelElement: function(labelElement, internalCheckBox) {
  var _this = this;
  if(labelElement) {
   ASPx.Evt.AttachEventToElement(labelElement, "click", 
    function (evt) { 
     _this.InvokeClick(internalCheckBox, evt);
    }
   );
   ASPx.Evt.AttachEventToElement(labelElement, "mousedown",
    function (evt) {
     internalCheckBox.Refocus();
    }
   );
  }
 },
 GetLabelElement: function(container) {
  var labelElement = ASPx.GetNodeByTagName(container, "LABEL", 0);
  if(!labelElement) {
   var labelCell = ASPx.GetNodeByClassName(container, "dxichTextCellSys", 0);
   labelElement = ASPx.GetNodeByTagName(labelCell, "SPAN", 0);
  }
  return labelElement;
 }
});
CheckEditElementHelper.Instance = new CheckEditElementHelper();
var CalendarSharedParameters = ASPx.CreateClass(null, {
 updateCalendarCallbackCommand: "UPDATE",
 constructor: function() {
  this.minDate = null;
  this.maxDate = null;
  this.disabledDates = [];
  this.calendarCustomDraw = false;
  this.hasCustomDisabledDatesViaCallback = false;
  this.dateRangeMode = false;
  this.currentDateEdit = null;
  this.DaysSelectingOnMouseOver = new ASPxClientEvent();
  this.VisibleDaysMouseOut = new ASPxClientEvent();
  this.CalendarSelectionChangedInternal = new ASPxClientEvent();
 },
 Assign: function(source) {
  this.minDate = source.minDate ? source.minDate : null;
  this.maxDate = source.maxDate ? source.maxDate : null;
  this.calendarCustomDraw = source.calendarCustomDraw ? source.calendarCustomDraw : false;
  this.hasCustomDisabledDatesViaCallback = source.hasCustomDisabledDatesViaCallback ? source.hasCustomDisabledDatesViaCallback : false;
  this.disabledDates = source.disabledDates ? source.disabledDates : [];
  this.currentDateEdit = source.currentDateEdit ? source.currentDateEdit : null;
 },
 GetUpdateCallbackParameters: function() {
  var callbackArgs = this.GetCallbackArgs();
  callbackArgs = this.FormatCallbackArg(this.updateCalendarCallbackCommand, callbackArgs);
  return callbackArgs;
 },
 GetCallbackArgs: function() {
  var args = {};
  if(this.minDate)
   args.clientMinDate = ASPx.DateUtils.GetInvariantDateString(this.minDate);
  if(this.maxDate)
   args.clientMaxDate = ASPx.DateUtils.GetInvariantDateString(this.maxDate);
  for(key in args) {
   var jsonArgs = JSON.stringify(args);
   return ASPx.Str.EncodeHtml(jsonArgs);
  }
  return null;
 },
 FormatCallbackArg: function(prefix, arg) {
  if(!arg) return prefix;
  return [prefix, '|', arg.length, ';', arg, ';'].join('');
 }
});
ASPx.CalendarSharedParameters = CalendarSharedParameters;
ASPx.ValidationType = ValidationType;
ASPx.ErrorFrameDisplay = ErrorFrameDisplay;
ASPx.EditElementSuffix = EditElementSuffix;
ASPx.ValidationPattern = ValidationPattern;
ASPx.RequiredFieldValidationPattern = RequiredFieldValidationPattern;
ASPx.RegularExpressionValidationPattern = RegularExpressionValidationPattern;
ASPx.CheckEditElementHelper = CheckEditElementHelper;
ASPx.IsEditorFocusable = _aspxIsEditorFocusable;
window.ASPxClientEditBase = ASPxClientEditBase;
window.ASPxClientEdit = ASPxClientEdit;
window.ASPxClientEditKeyEventArgs = ASPxClientEditKeyEventArgs;
window.ASPxClientEditValidationEventArgs = ASPxClientEditValidationEventArgs;
})();

(function() {
ASPx.TEInputSuffix = "_I";
ASPx.PasteCheckInterval = 50;
ASPx.TEHelpTextElementSuffix = "_HTE";
var passwordInputClonedSuffix = "_CLND";
var memoMinHeight = 34;
var BrowserHelper = {
 SAFARI_SYSTEM_CLASS_NAME: "dxeSafariSys",
 MOBILE_SAFARI_SYSTEM_CLASS_NAME: "dxeIPadSys",
 GetBrowserSpecificSystemClassName: function() {
  if(ASPx.Browser.Safari)
   return ASPx.Browser.MacOSMobilePlatform ? this.MOBILE_SAFARI_SYSTEM_CLASS_NAME : this.SAFARI_SYSTEM_CLASS_NAME;
  return "";
 }
};
var ASPxClientTextEdit = ASPx.CreateClass(ASPxClientEdit, {
 constructor: function(name) {
  this.constructor.prototype.constructor.call(this, name);      
  this.isASPxClientTextEdit = true;
  this.nullText = "";
  this.escCount = 0;
  this.raiseValueChangedOnEnter = true;
  this.autoResizeWithContainer = false;
  this.lastChangedValue = null;
  this.autoCompleteAttribute = null;
  this.passwordNullTextIntervalID = -1;
  this.nullTextInputElement = null;
  this.helpText = "";
  this.helpTextObj = null;  
  this.helpTextStyle = [];
  this.externalTableStyle = [];
  this.helpTextPosition = ASPx.Position.Right;
  this.helpTextMargins = null;
  this.helpTextHAlign = ASPxClientTextEditHelpTextHAlign.Left;
  this.helpTextVAlign = ASPxClientTextEditHelpTextVAlign.Top;
  this.enableHelpTextPopupAnimation = true;
  this.helpTextDisplayMode = ASPxClientTextEditHelpTextDisplayMode.Inline;
  this.maskInfo = null;  
  this.maskValueBeforeUserInput = "";
  this.maskPasteTimerID = -1;
  this.maskPasteLock = false;    
  this.maskPasteCounter = 0;
  this.maskTextBeforePaste = "";    
  this.maskHintHtml = "";
  this.maskHintTimerID = -1;
  this.maskedEditorClickEventHandlers = [];
  this.errorCellPosition = ASPx.Position.Right;
  this.displayFormat = null;
  this.TextChanged = new ASPxClientEvent();
 },
 InitializeProperties: function(properties){
  ASPxClientEdit.prototype.InitializeProperties.call(this, properties);
  if(properties.maskInfo) {
   this.maskInfo = ASPx.MaskInfo.Create(properties.maskInfo.maskText, properties.maskInfo.dateTimeOnly);
   this.SetProperties(properties.maskInfo.properties, this.maskInfo);
  }
 },
 Initialize: function(){
  this.SaveChangedValue();
  ASPxClientEdit.prototype.Initialize.call(this);
  this.CorrectInputMaxLength();
  this.SubscribeToIeDropEvent();
  if(ASPx.Browser.WebKitFamily)  
   this.CorrectMainElementWhiteSpaceStyle();
  if(this.GetInputElement().type == "password")
   this.ToggleTextDecoration();
 },
 InlineInitialize: function(){
  ASPxClientEdit.prototype.InlineInitialize.call(this);
  if(this.maskInfo != null)
   this.InitMask();
  this.ApplyBrowserSpecificClassName();
  this.helpTextInitialize();
  if(ASPx.Browser.IE && ASPx.Browser.Version >= 10 && this.nullText != "")
   this.addIEXButtonEventHandler();
  if(this.autoCompleteAttribute)
   this.GetInputElement().setAttribute(this.autoCompleteAttribute.name, this.autoCompleteAttribute.value);
 },
 InitializeEvents: function() {
  ASPxClientEdit.prototype.InitializeEvents.call(this);
  ASPx.Evt.AttachEventToElement(this.GetInputElement(), "keydown", this.OnKeyDown.aspxBind(this));
  ASPx.Evt.AttachEventToElement(this.GetInputElement(), "keyup", this.OnKeyUp.aspxBind(this));
  ASPx.Evt.AttachEventToElement(this.GetInputElement(), "keypress", this.OnKeyPress.aspxBind(this));
 },
 AdjustControl: function() {
  ASPxClientEdit.prototype.AdjustControl.call(this);
  if(ASPx.Browser.IE && ASPx.Browser.Version > 8 && !this.isNative)
   this.correctInputElementHeight();
 },
 correctInputElementHeight: function() {
  var mainElement = this.GetMainElement();
  var inputElement = this.GetInputElement();
  if(mainElement) {
   var mainElementHeight = mainElement.style.height;
   var mainElementHeightSpecified = mainElementHeight && mainElementHeight.indexOf('px') !== -1; 
   if(mainElementHeightSpecified) {
    var inputElementHeight = this.getInputElementHeight();
    inputElement.style.height = inputElementHeight + "px";
    if(!ASPx.Ident.IsASPxClientMemo(this))
     inputElement.style.lineHeight = inputElementHeight + "px";
   }
  }
 },
 getInputElementHeight: function() {
  var mainElement = this.GetMainElement(),
   inputElement = this.GetInputElement();
  var inputElementHeight = ASPx.Browser.IE && ASPx.Browser.Version > 9 ? ASPx.PxToInt(getComputedStyle(mainElement).height)
   : mainElement.offsetHeight - ASPx.GetTopBottomBordersAndPaddingsSummaryValue(mainElement);
  var inputElementContainer = inputElement.parentNode,
   inputContainerStyle = ASPx.GetCurrentStyle(inputElementContainer);
  inputElementHeight -= ASPx.GetTopBottomBordersAndPaddingsSummaryValue(inputElementContainer, inputContainerStyle) 
   + ASPx.GetTopBottomMargins(inputElementContainer, inputContainerStyle);
  var mainElementCellspacing = ASPx.GetCellSpacing(mainElement);
  if(mainElementCellspacing)
   inputElementHeight -= mainElementCellspacing * 2;
  var inputStyle = ASPx.GetCurrentStyle(inputElement);
  inputElementHeight -= ASPx.GetTopBottomBordersAndPaddingsSummaryValue(inputElement, inputStyle) 
   + ASPx.GetTopBottomMargins(inputElement, inputStyle);
  return inputElementHeight;
 },
 addIEXButtonEventHandler: function() {
  var inputElement = this.GetInputElement()
  if(ASPx.IsExists(inputElement)) {
   this.isDeleteOrBackspaceKeyClick = false;
   ASPx.Evt.AttachEventToElement(inputElement, "input", function (evt) {
    if(this.isDeleteOrBackspaceKeyClick) {
     this.isDeleteOrBackspaceKeyClick = false;
     return;
    }
    if(inputElement.value === '') {
     this.SyncRawValue();
    }
   }.aspxBind(this));
   ASPx.Evt.AttachEventToElement(inputElement, "keydown", function (evt) {
    this.isDeleteOrBackspaceKeyClick = (evt.keyCode == ASPx.Key.Delete || evt.keyCode == ASPx.Key.Backspace);
   }.aspxBind(this));
  }   
 },
 ensureOutOfRangeWarningManager: function (minValue, maxValue, defaultMinValue, defaultMaxValue, valueFormatter) {
  if (!this.outOfRangeWarningManager)
   this.outOfRangeWarningManager = new ASPxOutOfRangeWarningManager(this, minValue, maxValue, defaultMinValue, defaultMaxValue,
    this.hasRightPopupHelpText() ? ASPx.Position.Bottom : ASPx.Position.Right, valueFormatter);
 },
 helpTextInitialize: function () {
  if(this.helpText) {
   this.helpTextObj = new ASPxClientTextEditHelpText(this, this.helpTextStyle, this.helpText, this.helpTextPosition,
    this.helpTextHAlign, this.helpTextVAlign, this.helpTextMargins, this.enableHelpTextPopupAnimation, this.helpTextDisplayMode);
  }
 },
 hasRightPopupHelpText: function() {
  return this.helpText && this.helpTextDisplayMode === ASPxClientTextEditHelpTextDisplayMode.Popup
   && this.helpTextPosition === ASPx.Position.Right;
 },
 showHelpText: function () {
  if(this.helpTextObj)
   this.helpTextObj.show();
 },
 hideHelpText: function () {
  if(this.helpTextObj)
   this.helpTextObj.hide();
 },
 ApplyBrowserSpecificClassName: function() {
  var mainElement = this.GetMainElement();
  if(ASPx.IsExistsElement(mainElement)) {
   var className = BrowserHelper.GetBrowserSpecificSystemClassName();
   if(className)
    mainElement.className += " " + className;
  }
 },
  CorrectMainElementWhiteSpaceStyle: function() {
  var inputElement = this.GetInputElement();
  if(inputElement && inputElement.parentNode) {
   if(this.IsElementHasWhiteSpaceStyle(inputElement.parentNode))
    inputElement.parentNode.style.whiteSpace = "normal";
  }
 },
 IsElementHasWhiteSpaceStyle: function(element) {
  var currentStyle = ASPx.GetCurrentStyle(element);
  return currentStyle.whiteSpace == "nowrap" || currentStyle.whiteSpace == "pre";  
 },
 FindInputElement: function(){
  return this.isNative ? this.GetMainElement() : ASPx.GetElementById(this.name + ASPx.TEInputSuffix);
 },
 DecodeRawInputValue: function(value) {
  return value;
 },
 GetRawValue: function(value){
  return ASPx.IsExists(this.stateObject) ? this.stateObject.rawValue : null;
 },
 SetRawValue: function(value){
  if(ASPx.IsExists(value))
   value = value.toString();
  this.UpdateStateObjectWithObject({ rawValue: value });
 },
 SyncRawValue: function() {
  if(this.maskInfo != null)
   this.SetRawValue(this.maskInfo.GetValue());
  else
   this.SetRawValue(this.GetInputElement().value);
 },
 HasTextDecorators: function() {
  return this.nullText != "" || this.displayFormat != null;
 },
 CanApplyTextDecorators: function(){
  return !this.focused;
 },
 GetDecoratedText: function(value) {
  if(this.IsNull(value) && this.nullText != "") {
   if(this.CanApplyNullTextDecoration) {
    if(this.CanApplyNullTextDecoration())
     return this.nullText;
   } else {
    return this.nullText;
   }
  }
  if(this.displayFormat != null)
   return ASPx.Formatter.Format(this.displayFormat, value);
  if(this.maskInfo != null)
   return this.maskInfo.GetText();
  if(value == null)
   return "";
  return value;
 },
 ToggleTextDecoration: function() {
  if(this.HasTextDecorators()) {
   if(this.focused) {
    var input = this.GetInputElement();
    var oldValue = input.value;
    var sel = ASPx.Selection.GetExtInfo(input);
    this.ToggleTextDecorationCore();
    if(oldValue != input.value) {
     if(sel.startPos == 0 && sel.endPos == oldValue.length)
      sel.endPos = input.value.length;
     else
      sel.endPos = sel.startPos;
     if(!this.accessibilityCompliant || ASPx.GetActiveElement() == input)
      ASPx.Selection.Set(input, sel.startPos, sel.endPos);
    }
   } else
    this.ToggleTextDecorationCore();
  }
 },
 ToggleTextDecorationCore: function() {
  if(this.maskInfo != null) {   
   this.ApplyMaskInfo(false);
  } else {
   var input = this.GetInputElement();
   var rawValue = this.GetRawValue();
   var value = this.CanApplyTextDecorators() ? this.GetDecoratedText(rawValue) : rawValue;
   if(input.value != value) {
    if(input.type == "password")
     this.TogglePasswordInputTextDecoration(value);
    else
     input.value = value;
   }
  }
 },
 GetPasswordNullTextInputElement: function() {
  if(!this.isPasswordNullTextInputElementExists())
   this.nullTextInputElement = this.createPasswordNullTextInputElement();
  return this.nullTextInputElement;
 },
 createPasswordNullTextInputElement: function() {
  var inputElement = this.GetInputElement(),
   nullTextInputElement = document.createElement("INPUT");
  nullTextInputElement.className = inputElement.className;
  nullTextInputElement.style.cssText = inputElement.style.cssText;
  nullTextInputElement.id = inputElement.id + passwordInputClonedSuffix;
  nullTextInputElement.type = "text";
  if(ASPx.IsExists(inputElement.tabIndex))
   nullTextInputElement.tabIndex = inputElement.tabIndex;
  var onFocusEventHandler = function() {
   var inputElement = this.GetInputElement(),
    nullTextInputElement = this.GetPasswordNullTextInputElement();
   if(inputElement) {
    this.LockFocusEvents();  
    ASPx.SetElementDisplay(inputElement, true);
    inputElement.focus();
    ASPx.SetElementDisplay(nullTextInputElement, false);
    this.ReplaceAssociatedIdInLabels(nullTextInputElement.id, inputElement.id);
   }
  }.aspxBind(this);
  ASPx.Evt.AttachEventToElement(nullTextInputElement, "focus", onFocusEventHandler);
  return nullTextInputElement;
 },
 isPasswordNullTextInputElementExists: function() {
  return ASPx.IsExistsElement(this.nullTextInputElement);
 },
 TogglePasswordNullTextTimeoutChecker: function() {
  if(this.passwordNullTextIntervalID < 0) {
   var timeoutChecker = function() {
    var inputElement = this.GetInputElement();
    if(ASPx.GetControlCollection().GetByName(this.name) !== this || inputElement == null) {
     window.clearTimeout(this.passwordNullTextIntervalID);
     this.passwordNullTextIntervalID = -1;
     return;
    } else {
     if(!this.focused) {
      var passwordNullTextInputElement = this.GetPasswordNullTextInputElement();
      if(passwordNullTextInputElement.value != this.nullText && inputElement.value == "") { 
       passwordNullTextInputElement.value = this.nullText;
       this.SetValue(null);
      }
      if(inputElement.value != "") {
       if(inputElement.style.display == "none") {
        this.SetValue(inputElement.value);
        this.UnhidePasswordInput();
       }
      } else {
       if(inputElement.style.display != "none") {
        this.SetValue(null);
        this.HidePasswordInput();
       }
      }
     }
    }
   }.aspxBind(this);
   timeoutChecker(); 
   this.passwordNullTextIntervalID = window.setInterval(timeoutChecker, 100);
  }
 },
 TogglePasswordInputTextDecoration: function(value) {
  var inputElement = this.GetInputElement();
  var nullTextInputElement = this.GetPasswordNullTextInputElement();
  nullTextInputElement.value = value;
  var parentNode = inputElement.parentNode;
  if(ASPx.Data.ArrayIndexOf(parentNode.childNodes, nullTextInputElement) < 0) {
   ASPx.Attr.ChangeStyleAttribute(nullTextInputElement, "display", "none");
   parentNode.appendChild(nullTextInputElement);
  }
  this.HidePasswordInput();
  this.TogglePasswordNullTextTimeoutChecker();
 },
 HidePasswordInput: function() {
  ASPx.Attr.ChangeStyleAttribute(this.GetInputElement(), "display", "none");
  ASPx.Attr.ChangeStyleAttribute(this.GetPasswordNullTextInputElement(), "display", "");
  this.ReplaceAssociatedIdInLabels(this.GetInputElement().id, this.GetPasswordNullTextInputElement().id);
 },
 UnhidePasswordInput: function() {
  ASPx.Attr.ChangeStyleAttribute(this.GetInputElement(), "display", "");
  ASPx.Attr.ChangeStyleAttribute(this.GetPasswordNullTextInputElement(), "display", "none");
  this.ReplaceAssociatedIdInLabels(this.GetPasswordNullTextInputElement().id, this.GetInputElement().id);
 },
 ReplaceAssociatedIdInLabels: function(oldId, newId) {
  var labels = document.getElementsByTagName("LABEL");
  for(var i = 0; i < labels.length; i++) {
   if(labels[i].attributes["for"] && labels[i].attributes["for"].value == oldId)
    labels[i].attributes["for"].value = newId;
  }
 },
 GetFormattedText: function() {
  var value = this.GetValue();
  if(this.IsNull(value) && this.nullText != "")
   return this.GetText();
  return this.GetDecoratedText(value);
 },
 IsNull: function(value) {
  return value == null || value === "";
 },
 PopulateStyleDecorationPostfixes: function() {
  ASPxClientEdit.prototype.PopulateStyleDecorationPostfixes.call(this);
  this.styleDecoration.AddPostfix(ASPx.TEInputSuffix);
 },
 GetValue: function() {
  var value = null;
  if(this.maskInfo != null)
   value = this.maskInfo.GetValue();
  else if(this.HasTextDecorators())
   value = this.GetRawValue();
  else {
   var input = this.GetInputElement();
   value = input ? input.value : null;
  };
  return (value == "" && this.convertEmptyStringToNull) ? null : value;
 },
 SetValue: function(value) {
  if(value == null || value === undefined) 
   value = "";
  if(this.maskInfo != null) {
   this.maskInfo.SetValue(value.toString());
   this.ApplyMaskInfo(false);
   this.SavePrevMaskValue();
  } 
  else if(this.HasTextDecorators()) {
   this.SetRawValue(value);
   this.GetInputElement().value = this.CanApplyTextDecorators() && this.GetInputElement().type != "password" ? this.GetDecoratedText(value) : value;
  }
  else
   this.GetInputElement().value = value;
  if(this.styleDecoration)
   this.styleDecoration.Update();   
  this.SaveChangedValue();   
 },
 SetVisible: function(visible) {
  ASPxClientEdit.prototype.SetVisible.call(this, visible);
  if(this.helpTextDisplayMode === ASPxClientTextEditHelpTextDisplayMode.Inline) {
   if(visible)
    this.showHelpText();
   else
    this.hideHelpText();
  }
 },
 UnstretchInputElement: function(){
  var inputElement = this.GetInputElement();
  var mainElement = this.GetMainElement();
  var mainElementCurStyle = ASPx.GetCurrentStyle(mainElement);
  if(ASPx.IsExistsElement(mainElement) && ASPx.IsExistsElement(inputElement) && ASPx.IsExists(mainElementCurStyle) && 
   inputElement.style.width == "100%" &&
   (mainElementCurStyle.width == "" || mainElementCurStyle.width == "auto"))
   inputElement.style.width = "";
 },
 RestoreActiveElement: function(activeElement) {
  if(activeElement && activeElement.setActive && activeElement.tagName != "IFRAME")
   activeElement.setActive();
 },
 RaiseValueChangedEvent: function() {
  var processOnServer = ASPxClientEdit.prototype.RaiseValueChangedEvent.call(this);
  processOnServer = this.RaiseTextChanged(processOnServer);
  return processOnServer;
 },
 InitMask: function() {
  var rawValue = this.GetRawValue();
  this.SetValue(rawValue.length ? this.DecodeRawInputValue(rawValue) : this.maskInfo.GetValue());
  this.validationPatterns.unshift(new MaskValidationPattern(this.maskInfo.errorText, this.maskInfo));
 },
 SetMaskPasteTimer: function() {
  this.ClearMaskPasteTimer();
  this.maskPasteTimerID = ASPx.Timer.SetControlBoundInterval(this.MaskPasteTimerProc, this, ASPx.PasteCheckInterval);
 },
 ClearMaskPasteTimer: function() {
  this.maskPasteTimerID = ASPx.Timer.ClearInterval(this.maskPasteTimerID);
 },
 SavePrevMaskValue: function() {
  this.maskValueBeforeUserInput = this.maskInfo.GetValue();
 },
 FillMaskInfo: function() {
  var input = this.GetInputElement();
  if(!input) return; 
  var sel = ASPx.Selection.GetInfo(input);
  this.maskInfo.SetCaret(sel.startPos, sel.endPos - sel.startPos);  
 },
 ApplyMaskInfo: function(applyCaret) {
  this.SyncRawValue();
  var input = this.GetInputElement();
  var text = this.GetMaskDisplayText();
  this.maskTextBeforePaste = text;
  if(input.value != text)
   input.value = text;
  if(applyCaret)
   ASPx.Selection.Set(input, this.maskInfo.caretPos, this.maskInfo.caretPos + this.maskInfo.selectionLength);
 },
 GetMaskDisplayText: function() {
  if(!this.focused && this.HasTextDecorators())
   return this.GetDecoratedText(this.maskInfo.GetValue());
  return this.maskInfo.GetText();
 },
 ShouldCancelMaskKeyProcessing: function(htmlEvent, keyDownInfo) {
  return ASPx.Evt.IsEventPrevented(htmlEvent);
 }, 
 HandleMaskKeyDown: function(evt) {
  var keyInfo = ASPx.MaskManager.CreateKeyInfoByEvent(evt);
  ASPx.MaskManager.keyCancelled = this.ShouldCancelMaskKeyProcessing(evt, keyInfo);
  if(ASPx.MaskManager.keyCancelled) {
   ASPx.Evt.PreventEvent(evt);
   return;
  }
  this.maskPasteLock = true;
  this.FillMaskInfo();  
  var canHandle = ASPx.MaskManager.CanHandleControlKey(keyInfo);   
  ASPx.MaskManager.savedKeyDownKeyInfo = keyInfo;
  if(canHandle) {   
   ASPx.MaskManager.OnKeyDown(this.maskInfo, keyInfo);
   this.ApplyMaskInfo(true);
   ASPx.Evt.PreventEvent(evt);
  }
  ASPx.MaskManager.keyDownHandled = canHandle;
  this.maskPasteLock = false;
  this.UpdateMaskHintHtml();
 },
 HandleMaskKeyPress: function(evt) {
  var keyInfo = ASPx.MaskManager.CreateKeyInfoByEvent(evt);
  ASPx.MaskManager.keyCancelled = ASPx.MaskManager.keyCancelled || this.ShouldCancelMaskKeyProcessing(evt, ASPx.MaskManager.savedKeyDownKeyInfo);
  if(ASPx.MaskManager.keyCancelled) {
   ASPx.Evt.PreventEvent(evt);
   return;
  }
  this.maskPasteLock = true;  
  var printable = ASPx.MaskManager.savedKeyDownKeyInfo != null && ASPx.MaskManager.IsPrintableKeyCode(ASPx.MaskManager.savedKeyDownKeyInfo);
  if(printable) {
   ASPx.MaskManager.OnKeyPress(this.maskInfo, keyInfo);
   this.ApplyMaskInfo(true);
  }
  if(printable || ASPx.MaskManager.keyDownHandled)   
   ASPx.Evt.PreventEvent(evt); 
  this.maskPasteLock = false;
  this.UpdateMaskHintHtml();
 },
 MaskPasteTimerProc: function() {
  if(this.maskPasteLock || !this.maskInfo) return;
  this.maskPasteCounter++;
  var inputElement = this.inputElement;
  if(!inputElement || this.maskPasteCounter > 40) {
   this.maskPasteCounter = 0;
   inputElement = this.GetInputElement();
   if(!ASPx.IsExistsElement(inputElement)) {
    this.ClearMaskPasteTimer();
    return;
   }
  }
  if(this.maskTextBeforePaste !== inputElement.value) {
   this.maskInfo.ProcessPaste(inputElement.value, ASPx.Selection.GetInfo(inputElement).endPos);
   this.ApplyMaskInfo(true);
  }
  if(!this.focused)
   this.ClearMaskPasteTimer();
 },
 BeginShowMaskHint: function() {  
  if(!this.readOnly && this.maskHintTimerID == -1)
   this.maskHintTimerID = window.setInterval(ASPx.MaskHintTimerProc, 500);
 },
 EndShowMaskHint: function() {
  window.clearInterval(this.maskHintTimerID);
  this.maskHintTimerID = -1;
 },
 MaskHintTimerProc: function() {  
  if(this.maskInfo) {
   this.FillMaskInfo();
   this.UpdateMaskHintHtml();
  } else {
   this.EndShowMaskHint();
  }
 },
 UpdateMaskHintHtml: function() {  
  var hint =  this.GetMaskHintElement();
  if(!ASPx.IsExistsElement(hint))
   return;
  var html = ASPx.MaskManager.GetHintHtml(this.maskInfo);
  if(html == this.maskHintHtml)
   return;
  if(html != "") {
   var mainElement = this.GetMainElement();
   if(ASPx.IsExistsElement(mainElement)) {
    hint.innerHTML = html;
    hint.style.position = "absolute";  
    hint.style.left = ASPx.PrepareClientPosForElement(ASPx.GetAbsoluteX(mainElement), mainElement, true) + "px";
    hint.style.top = (ASPx.PrepareClientPosForElement(ASPx.GetAbsoluteY(mainElement), mainElement, false) + mainElement.offsetHeight + 2) + "px";
    hint.style.display = "block";    
   }   
  } else {
   hint.style.display = "none";
  }
  this.maskHintHtml = html;
 },
 HideMaskHint: function() {
  var hint =  this.GetMaskHintElement();
  if(ASPx.IsExistsElement(hint))
   hint.style.display = "none";
  this.maskHintHtml = "";
 },
 GetMaskHintElement: function() {
  return ASPx.GetElementById(this.name + "_MaskHint");
 },
 OnFocus: function() {
  if(this.maskInfo != null && !ASPx.GetControlCollection().InCallback())
   this.SetMaskPasteTimer();
  ASPxClientEdit.prototype.OnFocus.call(this);
 },
 OnMouseWheel: function(evt){
  if(this.readOnly || this.maskInfo == null) return;
  this.FillMaskInfo();
  ASPx.MaskManager.OnMouseWheel(this.maskInfo, ASPx.Evt.GetWheelDelta(evt) < 0 ? -1 : 1);
  this.ApplyMaskInfo(true);
  ASPx.Evt.PreventEvent(evt);
  this.UpdateMaskHintHtml();
 }, 
 OnBrowserWindowResize: function(e) {
  if(!this.autoResizeWithContainer)
   this.AdjustControl();
 },
 IsValueChanged: function() {
  return this.GetValue() != this.lastChangedValue; 
 },
 OnKeyDown: function(evt) {        
  if(this.NeedPreventBrowserUndoBehaviour(evt))
   return ASPx.Evt.PreventEvent(evt);
  if(ASPx.Browser.IE && ASPx.Evt.GetKeyCode(evt) == ASPx.Key.Esc) {   
   if(++this.escCount > 1) {
    ASPx.Evt.PreventEvent(evt);
    return;
   }
  } else 
   this.escCount = 0;
  ASPxClientEdit.prototype.OnKeyDown.call(this, evt);
  if(!this.IsRaiseStandardOnChange(evt)) {
   if(!this.readOnly && this.maskInfo != null)
    this.HandleMaskKeyDown(evt);
  }
 },
 IsCtrlZ: function(evt) {
  return evt.ctrlKey && !evt.altKey && !evt.shiftKey && (ASPx.Evt.GetKeyCode(evt) == 122 || ASPx.Evt.GetKeyCode(evt) == 90)
 },
 NeedPreventBrowserUndoBehaviour: function(evt) {
  var inputElement = this.GetInputElement();
  return this.IsCtrlZ(evt) && !!inputElement && !inputElement.value;
 },
 OnKeyPress: function(evt) {
  ASPxClientEdit.prototype.OnKeyPress.call(this, evt);
  if(!this.readOnly && this.maskInfo != null && !this.IsRaiseStandardOnChange(evt))
   this.HandleMaskKeyPress(evt);
  if(this.NeedOnKeyEventEnd(evt, true))
   this.OnKeyEventEnd(evt);
 },
 OnKeyUp: function(evt) {
  if(ASPx.Browser.Firefox && !this.focused && ASPx.Evt.GetKeyCode(evt) === ASPx.Key.Tab)
   return;
  if(this.NeedOnKeyEventEnd(evt, false)) {
   var proccessNextCommingPress = ASPx.Evt.GetKeyCode(evt) === ASPx.Key.Alt; 
   this.OnKeyEventEnd(evt, proccessNextCommingPress);
  }
  ASPxClientEdit.prototype.OnKeyUp.call(this, evt);
 },
 NeedOnKeyEventEnd: function(evt, isKeyPress) { 
  var handleKeyPress = this.maskInfo != null && evt.keyCode == ASPx.Key.Enter;
  return handleKeyPress == isKeyPress;
 },
 OnKeyEventEnd: function(evt, withDelay){
  if(!this.readOnly) {
   if(this.IsRaiseStandardOnChange(evt))
    this.RaiseStandardOnChange();
   this.SyncRawValueIfHasTextDecorators(withDelay);
  }
 },
 SyncRawValueIfHasTextDecorators: function(withDelay) {
  if(this.HasTextDecorators()) {
   if(withDelay) {
    window.setTimeout(function() {
     this.SyncRawValue();
    }.aspxBind(this), 0);
   } else 
    this.SyncRawValue();
  }
 },
 IsRaiseStandardOnChange: function(evt){
  return !this.specialKeyboardHandlingUsed && this.raiseValueChangedOnEnter && evt.keyCode == ASPx.Key.Enter;
 },
 GetFocusSelectAction: function() {
  if(this.maskInfo)
   return "start";
  return "all"; 
 },
 CorrectFocusWhenDisabled: function() {
  if(!this.GetEnabled()) {
   var inputElement = this.GetInputElement();
   if(inputElement)
    inputElement.blur();
   return true;
  }
  return false;
 },
 EnsureShowPopupHelpText: function() {
  if(this.helpTextDisplayMode === ASPxClientTextEditHelpTextDisplayMode.Popup)
   this.showHelpText();
 },
 EnsureHidePopupHelpText: function() {
  if(this.helpTextDisplayMode === ASPxClientTextEditHelpTextDisplayMode.Popup)
   this.hideHelpText();
 },
 OnFocusCore: function() {
  if(this.CorrectFocusWhenDisabled())
   return;
  var wasLocked = this.IsFocusEventsLocked();
  ASPxClientEdit.prototype.OnFocusCore.call(this);
  this.CorrectInputMaxLength(true);
  if(this.maskInfo != null) {
   this.SavePrevMaskValue();
   this.BeginShowMaskHint();
   this.AttachOnMouseClickIfNeeded();
  }
  if(!wasLocked)
   this.ToggleTextDecoration();
  if(this.isPasswordNullTextInputElementExists())
   setTimeout(function() { this.EnsureShowPopupHelpText(); }.aspxBind(this), 0);
  else
   this.EnsureShowPopupHelpText();
 },
 clearMaskedEditorClickEventHandlers: function () {
  for(var i = 0; i < this.maskedEditorClickEventHandlers.length; i++)
   ASPx.Evt.DetachEventFromElement(this.GetInputElement(), "click", this.maskedEditorClickEventHandlers[i]);
  this.maskedEditorClickEventHandlers = [];
 },
 addMaskedEditorClickEventHandler: function () {
  this.maskedEditorClickEventHandlers.push(this.MouseClickOnMaskedEditorFunc);
  ASPx.Evt.AttachEventToElement(this.GetInputElement(), "click", this.MouseClickOnMaskedEditorFunc);
 },
 AttachOnMouseClickIfNeeded: function () {
  this.clearMaskedEditorClickEventHandlers();
  if(this.GetValue() == "" || this.GetValue() == null) {
   this.MouseClickOnMaskedEditorFunc = function (e) {
    this.clearMaskedEditorClickEventHandlers();
    var selectionInfo = ASPx.Selection.GetExtInfo(this.GetInputElement());
    if(selectionInfo.startPos == selectionInfo.endPos)
     this.SetCaretPosition(this.GetInitialCaretPositionInEmptyMaskedInput());
   }.aspxBind(this);
   this.addMaskedEditorClickEventHandler();
  }
 },
 GetInitialCaretPositionInEmptyMaskedInput: function() {
  var maskParts = this.maskInfo.parts;
  return ASPx.MaskManager.IsLiteralPart(maskParts[0]) ? maskParts[0].GetSize() : 0;
 },
 OnLostFocusCore: function() {
  var wasLocked = this.IsFocusEventsLocked();
  ASPxClientEdit.prototype.OnLostFocusCore.call(this);
  this.CorrectInputMaxLength();
  if(this.maskInfo != null) {
   this.EndShowMaskHint();
   this.HideMaskHint();   
   if(this.maskInfo.ApplyFixes(null))
    this.ApplyMaskInfo(false);
   this.RaiseStandardOnChange();
  }
  if(!wasLocked)
   this.ToggleTextDecoration();
  this.escCount = 0;
  this.EnsureHidePopupHelpText();
 },
 InputMaxLengthCorrectionRequired: function () {
  return ASPx.Browser.IE && ASPx.Browser.Version >= 10 && (!this.isNative || this.nullText != "");
 },
 CorrectInputMaxLength: function (onFocus) {
  if(this.InputMaxLengthCorrectionRequired()) {
   var input = this.GetInputElement();
   if(!ASPx.IsExists(this.inputMaxLength))
    this.inputMaxLength = input.maxLength;
   input.maxLength = onFocus ? this.inputMaxLength : -1;
  }
 },
 SubscribeToIeDropEvent: function() {
  if(this.InputMaxLengthCorrectionRequired()) {
   var input = this.GetInputElement();
   ASPx.Evt.AttachEventToElement(input, "drop", function(e) { this.CorrectInputMaxLength(true); }.aspxBind(this));
  }
 },
 SetFocus: function() {
  if(this.isPasswordNullTextInputElementExists()) {
   this.GetPasswordNullTextInputElement().focus();
  } else {
     ASPxClientEdit.prototype.SetFocus.call(this);
  }
 },
 OnValueChanged: function() {
  if(this.maskInfo != null) {
   if(this.maskInfo.GetValue() == this.maskValueBeforeUserInput && !this.IsValueChangeForced())
    return;
   this.SavePrevMaskValue();
  }
  if(this.HasTextDecorators())
   this.SyncRawValue();
  if(!this.IsValueChanged() && !this.IsValueChangeForced())
   return;
  this.SaveChangedValue(); 
  ASPxClientEdit.prototype.OnValueChanged.call(this);
 },
 IsValueChangeForced: function() {
  return false;
 },
 OnTextChanged: function() {
 },
 SaveChangedValue: function() {
  this.lastChangedValue = this.GetValue();
 },
 RaiseStandardOnChange: function(){
  var element = this.GetInputElement();
  if(element && element.onchange) {
   element.onchange({ target: this.GetInputElement() });
  }
  else if(this.ValueChanged) {
   this.ValueChanged.FireEvent(this);
  }
 },
 RaiseTextChanged: function(processOnServer){
  if(!this.TextChanged.IsEmpty()){
   var args = new ASPxClientProcessingModeEventArgs(processOnServer);
   this.TextChanged.FireEvent(this, args);
   processOnServer = args.processOnServer;
  }
  return processOnServer;  
 },
 GetText: function(){
  if(this.maskInfo != null) {
   return this.maskInfo.GetText();
  } else {
   var value = this.GetValue();
   return value != null ? value : "";
  }
 },
 SetText: function (value){
  if(this.maskInfo != null) {
   this.maskInfo.SetText(value);
   this.ApplyMaskInfo(false);
   this.SavePrevMaskValue();
  } else {
   this.SetValue(value);
  }
 },
 SelectAll: function() {
  this.SetSelection(0, -1, false);
 },
 SetCaretPosition: function(pos) {
  var inputElement = this.GetInputElement();
  ASPx.Selection.SetCaretPosition(inputElement, pos);
 },
 SetSelection: function(startPos, endPos, scrollToSelection) { 
  var inputElement = this.GetInputElement();
  ASPx.Selection.Set(inputElement, startPos, endPos, scrollToSelection);
 },
 ChangeEnabledAttributes: function(enabled){
  var inputElement = this.GetInputElement();
  if(inputElement){
   this.ChangeInputEnabledAttributes(inputElement, ASPx.Attr.ChangeAttributesMethod(enabled), enabled);
   if(this.specialKeyboardHandlingUsed)
    this.ChangeSpecialInputEnabledAttributes(inputElement, ASPx.Attr.ChangeEventsMethod(enabled));
   this.ChangeInputEnabled(inputElement, enabled, this.readOnly);
  }
 },
 ChangeEnabledStateItems: function(enabled){
  if(!this.isNative) {
   var sc = ASPx.GetStateController();
   sc.SetElementEnabled(this.GetMainElement(), enabled);
   sc.SetElementEnabled(this.GetInputElement(), enabled);
  }
 },
 ChangeInputEnabled: function(element, enabled, readOnly) {
  if(this.UseReadOnlyForDisabled())
   element.readOnly = !enabled || readOnly;
  else
   element.disabled = !enabled;
 },
 ChangeInputEnabledAttributes: function(element, method, enabled) {
  var ieTabIndexFix = enabled && ASPx.Browser.IE && element.setAttribute && ASPx.Attr.IsExistsAttribute(element, "savedtabIndex");
  method(element, "tabIndex");
  if(!enabled) element.tabIndex = -1;
  if(ieTabIndexFix) { 
   window.setTimeout(function() {
    if(element && element.parentNode)
     element.parentNode.replaceChild(element, element); 
   }, 0);
  }
  method(element, "onclick");
  if(!this.NeedFocusCorrectionWhenDisabled())
   method(element, "onfocus");
  method(element, "onblur");
  method(element, "onkeydown");
  method(element, "onkeypress");
  method(element, "onkeyup");
 },
 UseReadOnlyForDisabled: function() {
  return (ASPx.Browser.IE && ASPx.Browser.Version < 10) && !this.isNative;
 },
 NeedFocusCorrectionWhenDisabled: function(){
  return (ASPx.Browser.IE && ASPx.Browser.Version < 10) && !this.isNative;
 },
 OnPostFinalization: function(args) {
  if(this.GetEnabled() || !this.UseReadOnlyForDisabled() || args.isDXCallback)
   return;
  var inputElement = this.GetInputElement();
  if(inputElement) {
   var inputDisabled = inputElement.disabled;
   inputElement.disabled = true;
   window.setTimeout(function() {
    inputElement.disabled = inputDisabled;
   }.aspxBind(this), 0);
  }
 }
});
MaskValidationPattern = ASPx.CreateClass(ASPx.ValidationPattern, {
 constructor: function(errorText, maskInfo) {
  this.constructor.prototype.constructor.call(this, errorText);
  this.maskInfo = maskInfo;
 },
 EvaluateIsValid: function(value) {
  return this.maskInfo.IsValid();
 }
});
ASPx.Ident.IsASPxClientTextEdit = function(obj) {
 return !!obj.isASPxClientTextEdit;
};
var ASPxClientTextBoxBase = ASPx.CreateClass(ASPxClientTextEdit, {
 constructor: function(name) {
  this.constructor.prototype.constructor.call(this, name);
  this.sizingConfig.allowSetHeight = false;
  this.sizingConfig.adjustControl = true;
 }
});
var ASPxClientTextBox = ASPx.CreateClass(ASPxClientTextBoxBase, {
 constructor: function(name) {
  this.constructor.prototype.constructor.call(this, name);
  this.isASPxClientTextBox = true;
 }
});
ASPxClientTextBox.Cast = ASPxClientControl.Cast;
ASPx.Ident.IsASPxClientTextBox = function(obj) {
 return !!obj.isASPxClientTextBox;
};
var ASPxClientMemo = ASPx.CreateClass(ASPxClientTextEdit, { 
 constructor: function(name) {
  this.constructor.prototype.constructor.call(this, name);        
  this.isASPxClientMemo = true;
  this.raiseValueChangedOnEnter = false;
  this.maxLength = 0;
  this.pasteTimerID = -1;
  this.pasteTimerActivatorCount = 0;
 },
 Initialize: function() {
  ASPxClientTextEdit.prototype.Initialize.call(this);
  this.SaveChangedValue();
  this.maxLengthRestricted = this.maxLength > 0;
 },
 CutString: function() {
  var text = this.GetText();
  if(text.length > this.maxLength) {
   text = text.substring(0, this.maxLength);
   this.SetText(text);
  }
 },
 EventKeyCodeChangesTheInput: function(evt){
  if(ASPx.IsPasteShortcut(evt))
   return true;
  else if(evt.ctrlKey)
   return false;
  var keyCode = ASPx.Evt.GetKeyCode(evt);
  var isSystemKey = ASPx.Key.Windows <= keyCode && keyCode <= ASPx.Key.ContextMenu;
  var isFKey = ASPx.Key.F1 <= keyCode && keyCode <= 127; 
  return ASPx.Key.Delete < keyCode && !isSystemKey && !isFKey || keyCode == ASPx.Key.Enter || keyCode == ASPx.Key.Space;
 },
 OnTextChangingCheck: function() {
  if(this.maxLengthRestricted)  
   this.CutString(); 
 },
 StartTextChangingTimer: function() {
  if(this.maxLengthRestricted) {
   if(this.pasteTimerActivatorCount == 0) 
    this.SetTextChangingTimer();
   this.pasteTimerActivatorCount ++;
  }
 },
 EndTextChangingTimer: function() {
  if(this.maxLengthRestricted) {
   this.pasteTimerActivatorCount --;
   if(this.pasteTimerActivatorCount == 0) 
    this.ClearTextChangingTimer();
  }
 },
 CollapseEditor: function() {
  if(!this.IsAdjustmentRequired()) return;
  var mainElement = this.GetMainElement();
  var inputElement = this.GetInputElement();
  if(!ASPx.IsExistsElement(mainElement) || !ASPx.IsExistsElement(inputElement))
   return;
  ASPxClientTextEdit.prototype.CollapseEditor.call(this);
  var mainElementCurStyle = ASPx.GetCurrentStyle(mainElement);
  if(this.heightCorrectionRequired && mainElement && inputElement) {
   if(mainElement.style.height == "100%" || mainElementCurStyle.height == "100%") {
    mainElement.style.height = "0";
    mainElement.wasCollapsed = true;
   }
   inputElement.style.height = "0";
  }
 },
 CorrectEditorHeight: function() {
  var mainElement = this.GetMainElement();
  if(mainElement.wasCollapsed) {
   mainElement.wasCollapsed = null;
   ASPx.SetOffsetHeight(mainElement, ASPx.GetClearClientHeight(ASPx.FindOffsetParent(mainElement)));
  }
  if(!this.isNative) {
   var inputElement = this.GetInputElement();
   var inputClearClientHeight = ASPx.GetClearClientHeight(ASPx.FindOffsetParent(inputElement));
   if(ASPx.Browser.IE) {
    inputClearClientHeight -= 2;
    var calculatedMainElementStyle = ASPx.GetCurrentStyle(mainElement);
    inputClearClientHeight += ASPx.PxToInt(calculatedMainElementStyle.borderTopWidth) + ASPx.PxToInt(calculatedMainElementStyle.borderBottomWidth);
   }
   if(inputClearClientHeight < memoMinHeight)
    inputClearClientHeight = memoMinHeight;
   ASPx.SetOffsetHeight(inputElement, inputClearClientHeight);
   mainElement.style.height = "100%";
   var inputParentOffsetHeight = ASPx.GetClearClientHeight(ASPx.FindOffsetParent(inputElement));
   if(inputParentOffsetHeight != inputClearClientHeight) {
    ASPx.SetOffsetHeight(inputElement, inputParentOffsetHeight);
   }
  }
 },
 SetWidth: function(width) {
  ASPxClientTextEdit.prototype.SetWidth.call(this, width);
  if(ASPx.Browser.IE)
   this.AdjustControl();
 },
 SetHeight: function(height) {
  var textarea = this.GetInputElement();
  textarea.style.height = "1px";
  ASPxClientTextEdit.prototype.SetHeight.call(this, height);
  textarea.style.height = ASPx.GetClearClientHeight(this.GetMainElement()) - ASPx.GetTopBottomBordersAndPaddingsSummaryValue(textarea) + "px";
 },
 ClearErrorFrameElementsStyles: function() {
  var textarea = this.GetInputElement();
  if(!textarea)
   return;
  var scrollBarPosition = textarea.scrollTop;
  ASPxClientTextEdit.prototype.ClearErrorFrameElementsStyles.call(this);
  if(ASPx.Browser.Firefox)
   textarea.scrollTop = scrollBarPosition;
 },
 OnMouseOver: function() {
  this.StartTextChangingTimer();
 },  
 OnMouseOut: function() {
  this.EndTextChangingTimer();
 },   
 OnFocus: function() {  
  this.StartTextChangingTimer();
  ASPxClientEdit.prototype.OnFocus.call(this);
 },
 OnLostFocus: function() {
  this.EndTextChangingTimer();
  ASPxClientEdit.prototype.OnLostFocus.call(this);
 },
 OnKeyDown: function(evt) { 
  if(this.NeedPreventBrowserUndoBehaviour(evt))
   return ASPx.Evt.PreventEvent(evt);
  if(this.maxLengthRestricted){
   var selection = ASPx.Selection.GetInfo(this.GetInputElement()); 
   var noCharToReplace = selection.startPos == selection.endPos;
   if(this.GetText().length >= this.maxLength && noCharToReplace && this.EventKeyCodeChangesTheInput(evt)) {
    return ASPx.Evt.PreventEvent(evt);
   }
  }
  ASPxClientEdit.prototype.OnKeyDown.call(this, evt);
 },
 SetTextChangingTimer: function() {
  this.pasteTimerID = ASPx.Timer.SetControlBoundInterval(this.OnTextChangingCheck, this, ASPx.PasteCheckInterval);
 },
 ClearTextChangingTimer: function() {
  this.pasteTimerID = ASPx.Timer.ClearInterval(this.pasteTimerID);
 }
});
ASPxClientMemo.Cast = ASPxClientControl.Cast;
ASPx.Ident.IsASPxClientMemo = function(obj) {
 return !!obj.isASPxClientMemo;
};
var CLEAR_BUTTON_INDEX = -100;
var HIDE_CONTENT_CSS_CLASS_NAME = "dxHideContent";
var setContentVisibility = function(clearButtonElement, value) {
 var action = value ? ASPx.RemoveClassNameFromElement : ASPx.AddClassNameToElement;
 action(clearButtonElement, HIDE_CONTENT_CSS_CLASS_NAME);
};
var CLEAR_BUTTON_DISPLAY_MODE = {
 AUTO: 'Auto',
 ALWAYS: 'Always',
 NEVER: 'Never',
 ON_HOVER: 'OnHover'
};
var AccessibilityFocusedButtonClassName = "dxAFB";
var ASPxClientButtonEditBase = ASPx.CreateClass(ASPxClientTextBoxBase, {
 constructor: function(name) {
  this.constructor.prototype.constructor.call(this, name);        
  this.allowUserInput = true;
  this.isValueChanging = false;
  this.allowMouseWheel = true;
  this.isMouseOver = false;
  this.buttonCount = 0;
  this.emptyValueMaskDisplayText = "";
  this.clearButtonDisplayMode = CLEAR_BUTTON_DISPLAY_MODE.AUTO;
  this.forceShowClearButtonAlways = false;
  this.recoverClearButtonVisibility = false;
  this.ButtonClick = new ASPxClientEvent();
 },
 Initialize: function() {
  ASPxClientTextBoxBase.prototype.Initialize.call(this);
  this.EnsureEmptyValueMaskDisplayText();
  if(this.HasClearButton())
   this.InitializeClearButton();
  this.InitAccessibilityCompliant();
 },
 InlineInitialize: function() {
  ASPxClientTextBoxBase.prototype.InlineInitialize.call(this);
  if(this.clearButtonDisplayMode === CLEAR_BUTTON_DISPLAY_MODE.AUTO) {
   this.clearButtonDisplayMode = this.IsClearButtonVisibleAuto() || this.forceShowClearButtonAlways ?
    CLEAR_BUTTON_DISPLAY_MODE.ALWAYS : CLEAR_BUTTON_DISPLAY_MODE.NEVER;
  }
  this.EnsureClearButtonVisibility();
 },
 InitializeClearButton: function() {
  if(this.clearButtonDisplayMode === CLEAR_BUTTON_DISPLAY_MODE.ON_HOVER) {
   var mainElement = this.GetMainElement();
   ASPx.Evt.AttachMouseEnterToElement(mainElement, this.OnMouseOver.aspxBind(this), this.OnMouseOut.aspxBind(this));
  }
 },
 IsClearButtonVisibleAuto: function() {
  return ASPx.Browser.MobileUI;
 },
 EnsureEmptyValueMaskDisplayText: function() {
  if(this.maskInfo && this.HasClearButton()) {
   var savedText = this.maskInfo.GetText();
   this.maskInfo.SetText("");
   this.emptyValueMaskDisplayText = this.maskInfo.GetText();
   this.maskInfo.SetText(savedText);
  }
 },
 GetButton: function(number) {
  return this.GetChildElement("B" + number);
 },
 GetCustomButtonCollection: function() {
  var buttonElements = [];
  for(var i = 0; i < this.buttonCount; i++) {
   var button =  this.GetButton(i);
   if(!!button)
    buttonElements.push(button);
  }
  return buttonElements;
 },
 GetButtonCollection: function() {
  var buttonElements = [];
  var clearButton = this.GetClearButton();
  if(!!clearButton)
   buttonElements.push(clearButton);
  return buttonElements.concat(this.GetCustomButtonCollection());
 },
 GetAccessibilityAnchor: function(buttonElement) {
  var firstChild = buttonElement.firstElementChild;
  var isExistsAnchorElement = ASPx.Attr.GetAttribute(firstChild, "role") === "button";
  return isExistsAnchorElement ? firstChild : null;
 },
 GetButtonByAccessibilityAnchor: function(anchorElement) {
  return anchorElement.parentNode;
 },
 SetAccessibilityAnchorEnabled: function(buttonElement, enabled) {
  var anchorElement = this.GetAccessibilityAnchor(buttonElement);
  if(ASPx.IsExists(anchorElement))
   ASPx.Attr.SetOrRemoveAttribute(anchorElement, "tabindex", enabled ? "0" : "");
 },
 InitAccessibilityCompliant: function() {
  if(!this.accessibilityCompliant) return;
  var buttonElements = this.GetButtonCollection();
  var labelElements = ASPx.FindAssociatedLabelElements(this);
  for(var i = 0; i < buttonElements.length; i++)
   this.InitAccessibilityAnchor(this.GetAccessibilityAnchor(buttonElements[i]), labelElements);     
 },
 InitAccessibilityAnchor: function(anchorElement, labelElements) {
  if(!ASPx.IsExists(anchorElement))
   return;
  for(var i = 0; i < labelElements.length; i++)
   this.SetOrRemoveAccessibilityAdditionalText([anchorElement], labelElements[i], true, false, false);
  ASPx.Evt.AttachEventToElement(anchorElement, "keydown", function(evt) { this.OnButtonKeysHandling(evt); }.aspxBind(this));
  ASPx.Evt.AttachEventToElement(anchorElement, "keyup", function(evt) { this.OnButtonKeysHandling(evt); }.aspxBind(this));
  ASPx.Evt.AttachEventToElement(anchorElement, "focus", function(evt) { this.OnButtonGotFocus(evt); }.aspxBind(this));
  ASPx.Evt.AttachEventToElement(anchorElement, "blur", function(evt) { this.OnButtonLostFocus(evt); }.aspxBind(this));
 },
 OnButtonKeysHandling: function(evt) {
  var isKeyUp = evt.type == "keyup";
  var keyCode = ASPx.Evt.GetKeyCode(evt);
  var sourceElement = ASPx.Evt.GetEventSource(evt);
  if((keyCode == ASPx.Key.Space && isKeyUp) || (keyCode == ASPx.Key.Enter && !isKeyUp)) {
   var buttonElement = this.GetButtonByAccessibilityAnchor(sourceElement);
   var mouseEvent = buttonElement.onclick || buttonElement.onmousedown || buttonElement.ontouchstart || buttonElement.onpointerdown;
   var emulateMouseEvtArgs = { button: 0, which: 1, srcElement: buttonElement, target: buttonElement };
   if(!!mouseEvent) {
    ASPx.Attr.SetAttribute(sourceElement, "aria-pressed", true);
    setTimeout(function() {
     mouseEvent(emulateMouseEvtArgs); 
     ASPx.Attr.RemoveAttribute(sourceElement, "aria-pressed");
    }, 300);
   }
  }
  if(keyCode != ASPx.Key.Tab) {
   evt.cancelBubble = true;
   evt.preventDefault();
  }
  return false;
 },
 OnButtonGotFocus: function(evt) {
  var editor = ASPx.GetControlCollection().Get(this.name);
  var sourceElement = ASPx.Evt.GetEventSource(evt);
  if(!!editor && !editor.CorrectAccessibilityButtonFocus(sourceElement)) {
   var buttonElement = editor.GetButtonByAccessibilityAnchor(sourceElement);
   ASPx.AddClassNameToElement(buttonElement, AccessibilityFocusedButtonClassName);
   ASPx.EGotFocus(editor.name);
   if(editor.specialKeyboardHandlingUsed)
    ASPx.ESGotFocus(editor.name);
  }
 },
 OnButtonLostFocus: function(evt) {
  var editor = ASPx.GetControlCollection().Get(this.name);
  var sourceElement = ASPx.Evt.GetEventSource(evt);
  if(!!editor) {
   var buttonElement = editor.GetButtonByAccessibilityAnchor(sourceElement);
   ASPx.RemoveClassNameFromElement(buttonElement, AccessibilityFocusedButtonClassName);
  }
  setTimeout(function() {
   if(!!editor && !editor.IsEditorElement(ASPx.GetActiveElement())) {
    ASPx.ELostFocus(editor.name);
    if(editor.specialKeyboardHandlingUsed)
     ASPx.ESLostFocus(editor.name);
   }
  }.aspxBind(this), 0);
 },
 ForceRefocusEditor: function(evt, isNativeFocus) {
  if(this.accessibilityCompliant) {
   var srcElement = ASPx.Evt.GetEventSource(evt);
   var customButtons = this.GetCustomButtonCollection();
   for(var i = 0; i < customButtons.length; i++)
    if(customButtons[i] == srcElement || ASPx.GetIsParent(customButtons[i], srcElement))
     return;
  }
  ASPxClientEdit.prototype.ForceRefocusEditor.call(this, evt, isNativeFocus);
 },
 CorrectAccessibilityButtonFocus: function(sourceElement) {
  if(ASPx.Attr.IsExistsAttribute(sourceElement, "tabindex"))
   return false;
  setTimeout(function() {
   var buttonElements = this.GetButtonCollection();
   for(var i = 0; i < buttonElements.length; i++)
    if(ASPx.GetIsParent(buttonElements[i], sourceElement))
     this.GetAccessibilityAnchor(buttonElements[i]).focus();
  }.aspxBind(this), 0);
  return true;
 },
 OnKeyDown: function(evt) { 
  if(this.accessibilityCompliant) {
   var hasClearButtonOnHover = this.HasClearButton() && this.clearButtonDisplayMode === CLEAR_BUTTON_DISPLAY_MODE.ON_HOVER;
   this.recoverClearButtonVisibility = hasClearButtonOnHover && ASPx.Evt.GetKeyCode(evt) == ASPx.Key.Tab && !evt.shiftKey;
  }
  ASPxClientTextBoxBase.prototype.OnKeyDown.call(this, evt);
 },
 SetButtonVisible: function(number, value) {
  var button = this.GetButton(number);
  if(!button)
   return;
  var isAlwaysShownClearButton = number === CLEAR_BUTTON_INDEX && this.clearButtonDisplayMode === CLEAR_BUTTON_DISPLAY_MODE.ALWAYS;
  var visibilityModifier = isAlwaysShownClearButton ? setContentVisibility : ASPx.SetElementDisplay;
  if(isAlwaysShownClearButton && this.accessibilityCompliant)
   this.SetAccessibilityAnchorEnabled(button, value);
  visibilityModifier(button, value);
 },
 GetButtonVisible: function(number) {
  var button = this.GetButton(number);
  if(number === CLEAR_BUTTON_INDEX && this.clearButtonDisplayMode === CLEAR_BUTTON_DISPLAY_MODE.ALWAYS)
   return button && !ASPx.ElementHasCssClass(button, HIDE_CONTENT_CSS_CLASS_NAME);
  return button && ASPx.IsElementVisible(button);
 },
 ProcessInternalButtonClick: function(buttonIndex) {
  return false;
 },
 OnButtonClick: function(number) {
  var processOnServer = this.RaiseButtonClick(number);
  if(!this.ProcessInternalButtonClick(number) && processOnServer)
   this.SendPostBack('BC:' + number);
 },
 GetLastSuccesfullValue: function() {
  return this.lastChangedValue;
 },
 OnClear: function() {
  this.ClearEditorValueAndForceOnChange();
  this.ForceRefocusEditor(null, true);
  window.setTimeout(this.EnsureClearButtonVisibility.aspxBind(this), 0);
 },
 ClearEditorValueAndForceOnChange: function() {
  if(this.readOnly || !this.GetButtonVisible(CLEAR_BUTTON_INDEX))
   return;
  var raiseOnChange = this.ClearEditorValueByClearButton();
  if(raiseOnChange)
   this.ForceStandardOnChange();
 },
 ClearEditorValueByClearButton: function() {
  var prevValue = this.GetLastSuccesfullValue();
  this.ClearEditorValueByClearButtonCore();
  return prevValue !== this.GetValue();
 },
 ClearEditorValueByClearButtonCore: function() {
  this.Clear();
  this.GetInputElement().value = '';
 },
 ForceStandardOnChange: function() {
  this.forceValueChanged = true;
  this.RaiseStandardOnChange();
  this.forceValueChanged = false;
 },
 IsValueChangeForced: function() {
  return this.forceValueChanged || ASPxClientTextBoxBase.prototype.IsValueChangeForced.call(this);
 },
 IsValueChanging: function() { return this.isValueChanging; },
 StartValueChanging: function() { this.isValueChanging = true; },
 EndValueChanging: function() { this.isValueChanging = false; },
 IsClearButtonElement: function(element) {
  return ASPx.GetIsParent(this.GetClearButton(), element);
 },
 OnFocusCore: function() {
  ASPxClientTextBoxBase.prototype.OnFocusCore.call(this);
  this.EnsureClearButtonVisibility();
 },
 OnLostFocusCore: function() {
  ASPxClientTextBoxBase.prototype.OnLostFocusCore.call(this);
  this.EnsureClearButtonVisibility();
  this.recoverClearButtonVisibility = false;
 },
 GetClearButton: function() {
  return this.GetButton(CLEAR_BUTTON_INDEX);
 },
 HasClearButton: function() {
  return !!this.GetClearButton();
 },
 RequireShowClearButton: function() {
  if(!this.clientEnabled || !this.HasClearButton() || this.clearButtonDisplayMode === CLEAR_BUTTON_DISPLAY_MODE.NEVER)
   return false;
  var isFocused = this.IsFocused();
  if(!isFocused && !this.isMouseOver && this.clearButtonDisplayMode !== CLEAR_BUTTON_DISPLAY_MODE.ALWAYS && !this.recoverClearButtonVisibility)
   return false;
  if(isFocused)
   return this.RequireShowClearButtonCore();
  return !this.IsNullState();
 },
 IsFocused: function() {
  return this === ASPx.GetFocusedEditor();
 },
 IsNullState: function() {
  return this.IsNull(this.GetValue());
 },
 RequireShowClearButtonCore: function() {
  var inputText = this.GetInputElement().value;
  return inputText !== this.GetEmptyValueDisplayText();
 },
 GetEmptyValueDisplayText: function() { 
  return this.maskInfo ? this.emptyValueMaskDisplayText : "";
 },
 EnsureClearButtonVisibility: function() {
  this.SetButtonVisible(CLEAR_BUTTON_INDEX, this.RequireShowClearButton());
 },
 OnMouseOver: function() {
  this.isMouseOver = true;
  this.EnsureClearButtonVisibility();
 },
 OnMouseOut: function() {
  this.isMouseOver = false;
  this.EnsureClearButtonVisibility();
 },
 OnKeyPress: function(evt) {
  if(this.allowUserInput)
   ASPxClientTextBoxBase.prototype.OnKeyPress.call(this, evt);
 },
 OnKeyEventEnd: function(evt, withDelay) {
  ASPxClientTextBoxBase.prototype.OnKeyEventEnd.call(this, evt, withDelay);
  this.EnsureClearButtonVisibility();
 },
 RaiseButtonClick: function(number){
  var processOnServer = this.autoPostBack || this.IsServerEventAssigned("ButtonClick");
  if(!this.ButtonClick.IsEmpty()){
   var args = new ASPxClientButtonEditClickEventArgs(processOnServer, number);
   this.ButtonClick.FireEvent(this, args);
   processOnServer = args.processOnServer;
  }
  return processOnServer;
 },
 ChangeEnabledAttributes: function(enabled){
  ASPxClientTextEdit.prototype.ChangeEnabledAttributes.call(this, enabled);
  for(var i = 0; i < this.buttonCount; i++){
   var element = this.GetButton(i);
   if(element)
    this.ChangeButtonEnabledAttributes(element, ASPx.Attr.ChangeAttributesMethod(enabled));
  }
  if(this.accessibilityCompliant)
   this.ChangeAccessibilityButtonEnabledAttributes(enabled);
 },
 ChangeEnabledStateItems: function(enabled){
  ASPxClientTextEdit.prototype.ChangeEnabledStateItems.call(this, enabled);
  for(var i = 0; i < this.buttonCount; i++){
   var element = this.GetButton(i);
   if(element) 
    ASPx.GetStateController().SetElementEnabled(element, enabled);
  }
 },
 ChangeButtonEnabledAttributes: function(element, method){
  method(element, "onclick");
  method(element, "ondblclick");
  method(element, "on" + ASPx.TouchUIHelper.touchMouseDownEventName);
  method(element, "on" + ASPx.TouchUIHelper.touchMouseUpEventName);
 },
 ChangeInputEnabled: function(element, enabled, readOnly) {
  ASPxClientTextEdit.prototype.ChangeInputEnabled.call(this, element, enabled, readOnly || !this.allowUserInput);
 },
 ChangeAccessibilityButtonEnabledAttributes: function(enabled) {
  var buttonElements = this.GetButtonCollection();
  for(var i = 0; i < buttonElements.length; i++)
   this.SetAccessibilityAnchorEnabled(buttonElements[i], enabled);
 },
 SetValue: function(value) {
  ASPxClientTextEdit.prototype.SetValue.call(this, value);
  if(!this.IsFocused())
   this.EnsureClearButtonVisibility();
 }
});
var ASPxClientButtonEdit = ASPx.CreateClass(ASPxClientButtonEditBase, {
});
ASPxClientButtonEdit.Cast = ASPxClientControl.Cast;
var ASPxClientButtonEditClickEventArgs = ASPx.CreateClass(ASPxClientProcessingModeEventArgs, {
 constructor: function(processOnServer, buttonIndex){
  this.constructor.prototype.constructor.call(this, processOnServer);
  this.buttonIndex = buttonIndex;
 }
});
var ASPxClientTextEditHelpTextHAlign = {
 Left: "Left",
 Right: "Right",
 Center: "Center"
};
var ASPxClientTextEditHelpTextVAlign = {
 Top: "Top",
 Bottom: "Bottom",
 Middle: "Middle"
};
var ASPxClientTextEditHelpTextDisplayMode = {
 Inline: "Inline",
 Popup: "Popup"
};
var ASPxClientTextEditHelpTextConsts = {
 VERTICAL_ORIENTATION_CLASS_NAME: "dxeVHelpTextSys",
 HORIZONTAL_ORIENTATION_CLASS_NAME: "dxeHHelpTextSys"
};
var ASPxClientTextEditHelpText = ASPx.CreateClass(null, {
 constructor: function (editor, helpTextStyle, helpText, position, hAlign, vAlign, margins, animationEnabled, helpTextDisplayMode) {
  this.hAlign = hAlign;
  this.vAlign = vAlign;
  this.animationEnabled = animationEnabled;
  this.displayMode = helpTextDisplayMode;
  this.editor = editor;
  this.editorMainElement = editor.GetMainElement();
  this.margins = margins ? { Top: margins[0], Right: margins[1], Bottom: margins[2], Left: margins[3] } : null;
  this.defaultMargins = { Top: 10, Right: 10, Bottom: 10, Left: 10 };
  this.position = position;
  this.helpTextElement = this.createHelpTextElement();
  this.setHelpTextZIndex(true);
  this.prepareHelpTextElement(helpTextStyle, helpText);
 },
 getRows: function (table) {
  return ASPx.GetChildNodesByTagName(table, "TR");
 },
 getCells: function (row) {
  return ASPx.GetChildNodesByTagName(row, "TD");
 },
 getCellByIndex: function(row, cellIndex) {
  return this.getCells(row)[cellIndex];
 },
 getCellIndex: function(row, cell) {
  var cells = this.getCells(row);
  for(var i = 0; i < cells.length; i++) {
   if(cells[i] === cell)
    return i;
  }
 },
 isHorizontal: function(position) {
  return position === ASPx.Position.Left || position === ASPx.Position.Right;
 },
 isVertical: function (position) {
  return position === ASPx.Position.Top || position === ASPx.Position.Bottom;
 },
 createEmptyCell: function(assignClassName) {
  var cell = document.createElement("TD");
  if(assignClassName)
   cell.className = "dxeFakeEmptyCell";
  return cell;
 },
 addHelpTextCellToExternalTableWithTwoCells: function (captionCell, errorCell, helpTextCell, errorTableBody, tableRows) {
  var captionPosition = this.editor.captionPosition;
  var errorCellPosition = this.editor.errorCellPosition;
  var helpTextRow = this.isVertical(this.position) ? document.createElement("TR") : null;
  if(captionPosition === ASPx.Position.Left && this.position === ASPx.Position.Left && this.isHorizontal(errorCellPosition))
   captionCell.parentNode.insertBefore(helpTextCell, captionCell.nextSibling);
  if(captionPosition === ASPx.Position.Right && this.position === ASPx.Position.Right && this.isHorizontal(errorCellPosition))
   captionCell.parentNode.insertBefore(helpTextCell, captionCell);
  if(captionPosition === ASPx.Position.Left && this.position === ASPx.Position.Right && this.isHorizontal(errorCellPosition))
   tableRows[0].appendChild(helpTextCell);
  if(captionPosition === ASPx.Position.Right && this.position === ASPx.Position.Left && this.isHorizontal(errorCellPosition))
   tableRows[0].insertBefore(helpTextCell, tableRows[0].childNodes[0]);
  if(captionPosition === ASPx.Position.Top && this.position === ASPx.Position.Bottom && this.isVertical(errorCellPosition)) {
   helpTextRow.appendChild(helpTextCell);
   errorTableBody.appendChild(helpTextRow);
  }
  if(captionPosition === ASPx.Position.Bottom && this.position === ASPx.Position.Top && this.isVertical(errorCellPosition)) {
   helpTextRow.appendChild(helpTextCell);
   errorTableBody.insertBefore(helpTextRow, errorTableBody.childNodes[0]);
  }
  if(captionPosition === ASPx.Position.Top && this.position === ASPx.Position.Top && this.isVertical(errorCellPosition)) {
   helpTextRow.appendChild(helpTextCell);
   errorTableBody.insertBefore(helpTextRow, captionCell.parentNode.nextSibling);
  }
  if(captionPosition === ASPx.Position.Bottom && this.position === ASPx.Position.Bottom && this.isVertical(errorCellPosition)) {
   helpTextRow.appendChild(helpTextCell);
   errorTableBody.insertBefore(helpTextRow, captionCell.parentNode);
  }
  if(captionPosition === ASPx.Position.Right && this.position === ASPx.Position.Top && this.isVertical(errorCellPosition)) {
   helpTextRow.appendChild(helpTextCell);
   helpTextRow.appendChild(this.createEmptyCell());
   errorTableBody.insertBefore(helpTextRow, errorTableBody.childNodes[0]);
  }
  if(this.position === ASPx.Position.Bottom) {
   if(captionPosition === ASPx.Position.Right && errorCellPosition === ASPx.Position.Top || captionPosition === ASPx.Position.Top && errorCellPosition === ASPx.Position.Right) {
    helpTextRow.appendChild(helpTextCell);
    helpTextRow.appendChild(this.createEmptyCell());
    errorTableBody.appendChild(helpTextRow);
   }
  }
  if(captionPosition === ASPx.Position.Left && this.position === ASPx.Position.Top && this.isVertical(errorCellPosition)) {
   helpTextRow.appendChild(this.createEmptyCell());
   helpTextRow.appendChild(helpTextCell);
   errorTableBody.insertBefore(helpTextRow, errorTableBody.childNodes[0]);
  }
  if(captionPosition === ASPx.Position.Left && this.position === ASPx.Position.Bottom && this.isVertical(errorCellPosition)) {
   helpTextRow.appendChild(this.createEmptyCell());
   helpTextRow.appendChild(helpTextCell);
   errorTableBody.appendChild(helpTextRow);
  }
  if(this.position === ASPx.Position.Right) {
   if(captionPosition === ASPx.Position.Top && errorCellPosition === ASPx.Position.Left || captionPosition === ASPx.Position.Left && errorCellPosition === ASPx.Position.Top
    || captionPosition === ASPx.Position.Top && errorCellPosition === ASPx.Position.Right) {
    tableRows[1].appendChild(helpTextCell);
    tableRows[0].appendChild(this.createEmptyCell());
   }
   if(captionPosition === ASPx.Position.Left && errorCellPosition === ASPx.Position.Bottom || captionPosition === ASPx.Position.Bottom && errorCellPosition === ASPx.Position.Left) {
    tableRows[0].appendChild(helpTextCell);
    tableRows[1].appendChild(this.createEmptyCell());
   }
  }
  if(this.position === ASPx.Position.Left) {
   if(captionPosition === ASPx.Position.Right && errorCellPosition === ASPx.Position.Top || captionPosition === ASPx.Position.Top && errorCellPosition === ASPx.Position.Right
    || captionPosition === ASPx.Position.Top && errorCellPosition === ASPx.Position.Left) {
    tableRows[1].insertBefore(helpTextCell, tableRows[1].childNodes[0]);
    tableRows[0].insertBefore(this.createEmptyCell(), tableRows[0].childNodes[0]);
   }
   if(captionPosition === ASPx.Position.Bottom && errorCellPosition === ASPx.Position.Top || captionPosition === ASPx.Position.Top && errorCellPosition === ASPx.Position.Bottom) {
    tableRows[1].insertBefore(helpTextCell, tableRows[1].childNodes[0]);
    tableRows[0].insertBefore(this.createEmptyCell(errorCellPosition === ASPx.Position.Top), tableRows[0].childNodes[0]);
    tableRows[2].insertBefore(this.createEmptyCell(errorCellPosition !== ASPx.Position.Top), tableRows[2].childNodes[0]);
   }
   if(captionPosition === ASPx.Position.Top && errorCellPosition === ASPx.Position.Top) {
    tableRows[2].insertBefore(helpTextCell, tableRows[2].childNodes[0]);
    tableRows[0].insertBefore(this.createEmptyCell(false), tableRows[0].childNodes[0]);
    tableRows[1].insertBefore(this.createEmptyCell(true), tableRows[1].childNodes[0]);
   }
   if(captionPosition === ASPx.Position.Bottom && errorCellPosition === ASPx.Position.Bottom) {
    tableRows[0].insertBefore(helpTextCell, tableRows[0].childNodes[0]);
    tableRows[1].insertBefore(this.createEmptyCell(true), tableRows[1].childNodes[0]);
    tableRows[2].insertBefore(this.createEmptyCell(false), tableRows[2].childNodes[0]);
   }
   if(captionPosition === ASPx.Position.Bottom && errorCellPosition === ASPx.Position.Left || captionPosition === ASPx.Position.Right && errorCellPosition === ASPx.Position.Bottom
    || captionPosition === ASPx.Position.Bottom && errorCellPosition === ASPx.Position.Right) {
    tableRows[0].insertBefore(helpTextCell, tableRows[0].childNodes[0]);
    tableRows[1].insertBefore(this.createEmptyCell(), tableRows[1].childNodes[0]);
   }
   if(captionPosition === ASPx.Position.Left && this.isVertical(errorCellPosition)) {
    captionCell.parentNode.insertBefore(helpTextCell, captionCell.nextSibling);
    var emptyCellParentRow = errorCellPosition === ASPx.Position.Top ? tableRows[0] : tableRows[1];
    var helpTextCellIndex = this.getCellIndex(helpTextCell.parentNode, helpTextCell);
    emptyCellParentRow.insertBefore(this.createEmptyCell(), this.getCellByIndex(emptyCellParentRow, helpTextCellIndex));
   }
  }
  if(this.position === ASPx.Position.Right) {
   if(captionPosition === ASPx.Position.Bottom && errorCellPosition === ASPx.Position.Top || captionPosition === ASPx.Position.Top && errorCellPosition === ASPx.Position.Bottom) {
    tableRows[1].appendChild(helpTextCell);
    tableRows[0].appendChild(this.createEmptyCell(errorCellPosition === ASPx.Position.Top));
    tableRows[2].appendChild(this.createEmptyCell(errorCellPosition !== ASPx.Position.Top));
   }
   if(captionPosition === ASPx.Position.Top && errorCellPosition === ASPx.Position.Top) {
    tableRows[2].appendChild(helpTextCell);
    tableRows[0].appendChild(this.createEmptyCell(false));
    tableRows[1].appendChild(this.createEmptyCell(true));
   }
   if(captionPosition === ASPx.Position.Bottom && errorCellPosition === ASPx.Position.Bottom) {
    tableRows[0].appendChild(helpTextCell);
    tableRows[1].appendChild(this.createEmptyCell(true));
    tableRows[2].appendChild(this.createEmptyCell(false));
   }
   if(captionPosition === ASPx.Position.Bottom && errorCellPosition === ASPx.Position.Right) {
    tableRows[0].appendChild(helpTextCell);
    tableRows[1].appendChild(this.createEmptyCell());
   }
   if(captionPosition === ASPx.Position.Right && this.isVertical(errorCellPosition)) {
    captionCell.parentNode.insertBefore(helpTextCell, captionCell);
    var emptyCellParentRow = errorCellPosition === ASPx.Position.Top ? tableRows[0] : tableRows[1];
    var helpTextCellIndex = this.getCellIndex(helpTextCell.parentNode, helpTextCell);
    emptyCellParentRow.insertBefore(this.createEmptyCell(), this.getCellByIndex(emptyCellParentRow, helpTextCellIndex));
   }
  }
  if(captionPosition === ASPx.Position.Top && this.position === ASPx.Position.Top && this.isHorizontal(errorCellPosition)) {
   if(errorCellPosition === ASPx.Position.Left) {
    helpTextRow.appendChild(this.createEmptyCell(true));
    helpTextRow.appendChild(helpTextCell);
   }
   else {
    helpTextRow.appendChild(helpTextCell);
    helpTextRow.appendChild(this.createEmptyCell());
   }
   errorTableBody.insertBefore(helpTextRow, captionCell.parentNode.nextSibling);
  }
  if(captionPosition === ASPx.Position.Bottom && this.position === ASPx.Position.Top && this.isHorizontal(errorCellPosition)) {
   if(errorCellPosition === ASPx.Position.Left) {
    helpTextRow.appendChild(this.createEmptyCell(true));
    helpTextRow.appendChild(helpTextCell);
   }
   else {
    helpTextRow.appendChild(helpTextCell);
    helpTextRow.appendChild(this.createEmptyCell());
   }
   errorTableBody.insertBefore(helpTextRow, errorTableBody.childNodes[0]);
  }
  if(captionPosition === ASPx.Position.Bottom && this.position === ASPx.Position.Bottom && this.isHorizontal(errorCellPosition)) {
   if(errorCellPosition === ASPx.Position.Left) {
    helpTextRow.appendChild(this.createEmptyCell(true));
    helpTextRow.appendChild(helpTextCell);
   }
   else {
    helpTextRow.appendChild(helpTextCell);
    helpTextRow.appendChild(this.createEmptyCell());
   }
   errorTableBody.insertBefore(helpTextRow, captionCell.parentNode);
  }
  if(captionPosition === ASPx.Position.Top && this.position === ASPx.Position.Bottom && errorCellPosition === ASPx.Position.Left) {
   helpTextRow.appendChild(this.createEmptyCell(true));
   helpTextRow.appendChild(helpTextCell);
   errorTableBody.appendChild(helpTextRow);
  }
  if(captionPosition === ASPx.Position.Right && this.position === ASPx.Position.Bottom && errorCellPosition === ASPx.Position.Bottom) {
   helpTextRow.appendChild(helpTextCell);
   helpTextRow.appendChild(this.createEmptyCell());
   errorTableBody.appendChild(helpTextRow);
  }
  if(this.position === ASPx.Position.Bottom) {
   if(captionPosition === ASPx.Position.Left && errorCellPosition === ASPx.Position.Right || captionPosition === ASPx.Position.Right && errorCellPosition === ASPx.Position.Left) {
    helpTextRow.appendChild(this.createEmptyCell(errorCellPosition !== ASPx.Position.Right));
    helpTextRow.appendChild(helpTextCell);
    helpTextRow.appendChild(this.createEmptyCell(errorCellPosition === ASPx.Position.Right));
    errorTableBody.appendChild(helpTextRow);
   }
   if(captionPosition === ASPx.Position.Left && errorCellPosition === ASPx.Position.Left) {
    helpTextRow.appendChild(this.createEmptyCell(false));
    helpTextRow.appendChild(this.createEmptyCell(true));
    helpTextRow.appendChild(helpTextCell);
    errorTableBody.appendChild(helpTextRow);
   }
   if(captionPosition === ASPx.Position.Right && errorCellPosition === ASPx.Position.Right) {
    helpTextRow.appendChild(helpTextCell);
    helpTextRow.appendChild(this.createEmptyCell(true));
    helpTextRow.appendChild(this.createEmptyCell(false));
    errorTableBody.appendChild(helpTextRow);
   }   
  }
  if(this.position === ASPx.Position.Top) {
   if(captionPosition === ASPx.Position.Left && errorCellPosition === ASPx.Position.Right || captionPosition === ASPx.Position.Right && errorCellPosition === ASPx.Position.Left) {
    helpTextRow.appendChild(this.createEmptyCell(errorCellPosition !== ASPx.Position.Right));
    helpTextRow.appendChild(helpTextCell);
    helpTextRow.appendChild(this.createEmptyCell(errorCellPosition === ASPx.Position.Right));
    errorTableBody.insertBefore(helpTextRow, errorTableBody.childNodes[0]);
   }
   if(captionPosition === ASPx.Position.Left && errorCellPosition === ASPx.Position.Left) {
    helpTextRow.appendChild(this.createEmptyCell(false));
    helpTextRow.appendChild(this.createEmptyCell(true));
    helpTextRow.appendChild(helpTextCell);
    errorTableBody.insertBefore(helpTextRow, errorTableBody.childNodes[0]);
   }
   if(captionPosition === ASPx.Position.Right && errorCellPosition === ASPx.Position.Right) {
    helpTextRow.appendChild(helpTextCell);
    helpTextRow.appendChild(this.createEmptyCell(true));
    helpTextRow.appendChild(this.createEmptyCell(false));
    errorTableBody.insertBefore(helpTextRow, errorTableBody.childNodes[0]);
   }
  }
 },
 addHelpTextCellToExternalTableWithErrorCell: function (errorCell, helpTextCell, errorTableBody, tableRows) {
  var errorCellPosition = this.editor.errorCellPosition;
  var helpTextRow = document.createElement("TR");
  if(this.position === ASPx.Position.Left && this.isHorizontal(errorCellPosition))
   tableRows[0].insertBefore(helpTextCell, tableRows[0].childNodes[0]);
  if(this.position === ASPx.Position.Right && this.isHorizontal(errorCellPosition))
   tableRows[0].appendChild(helpTextCell);
  if(this.position === ASPx.Position.Top && this.isVertical(errorCellPosition)) {
   helpTextRow.appendChild(helpTextCell);
   errorTableBody.insertBefore(helpTextRow, errorTableBody.childNodes[0]);
  }
  if(this.position === ASPx.Position.Bottom && this.isVertical(errorCellPosition)) {
   helpTextRow.appendChild(helpTextCell);
   errorTableBody.appendChild(helpTextRow);
  }
  if(errorCellPosition === ASPx.Position.Left && this.isVertical(this.position)) {
   helpTextRow.appendChild(this.createEmptyCell(true));
   helpTextRow.appendChild(helpTextCell);
   if(this.position === ASPx.Position.Top)
    errorTableBody.insertBefore(helpTextRow, errorTableBody.childNodes[0]);
   else
    errorTableBody.appendChild(helpTextRow);
  }
  if(errorCellPosition === ASPx.Position.Right && this.isVertical(this.position)) {
   helpTextRow.appendChild(helpTextCell);
   helpTextRow.appendChild(this.createEmptyCell(true));
   if(this.position === ASPx.Position.Top)
    errorTableBody.insertBefore(helpTextRow, errorTableBody.childNodes[0]);
   else
    errorTableBody.appendChild(helpTextRow);
  }
  if(this.position === ASPx.Position.Left && this.isVertical(errorCellPosition)) {
   var helpTextParentRowIndex = errorCellPosition === ASPx.Position.Top ? 1 : 0;
   var emptyCellRowIndex = helpTextParentRowIndex === 0 ? 1 : 0;
   tableRows[helpTextParentRowIndex].insertBefore(helpTextCell, tableRows[helpTextParentRowIndex].childNodes[0]);
   tableRows[emptyCellRowIndex].insertBefore(this.createEmptyCell(true), tableRows[emptyCellRowIndex].childNodes[0]);
  }
  if(this.position === ASPx.Position.Right && this.isVertical(errorCellPosition)) {
   var helpTextParentRowIndex = errorCellPosition === ASPx.Position.Top ? 1 : 0;
   var emptyCellRowIndex = helpTextParentRowIndex === 0 ? 1 : 0;
   tableRows[helpTextParentRowIndex].appendChild(helpTextCell);
   tableRows[emptyCellRowIndex].appendChild(this.createEmptyCell(true));
  }
 },
 addHelpTextCellToExternalTableWithCaption: function (captionCell, helpTextCell, errorTableBody, tableRows) {
  var captionPosition = this.editor.captionPosition;
  var helpTextRow = document.createElement("TR");
  if(captionPosition === ASPx.Position.Left && this.isVertical(this.position)) {
   helpTextRow.appendChild(this.createEmptyCell());
   helpTextRow.appendChild(helpTextCell);
   if(this.position === ASPx.Position.Top)
    errorTableBody.insertBefore(helpTextRow, errorTableBody.childNodes[0]);
   else
    errorTableBody.appendChild(helpTextRow);
  }
  if(this.position === ASPx.Position.Left && this.isVertical(captionPosition)) {
   var helpTextParentRowIndex = captionPosition === ASPx.Position.Top ? 1 : 0;
   var emptyCellParentRowIndex = helpTextParentRowIndex === 0 ? 1 : 0;
   tableRows[helpTextParentRowIndex].insertBefore(helpTextCell, tableRows[helpTextParentRowIndex].childNodes[0]);
   tableRows[emptyCellParentRowIndex].insertBefore(this.createEmptyCell(), tableRows[emptyCellParentRowIndex].childNodes[0]);
  }
  if(this.position === ASPx.Position.Right && this.isVertical(captionPosition)) {
   var helpTextParentRowIndex = captionPosition === ASPx.Position.Top ? 1 : 0;
   var emptyCellParentRowIndex = helpTextParentRowIndex === 0 ? 1 : 0;
   tableRows[helpTextParentRowIndex].appendChild(helpTextCell);
   tableRows[emptyCellParentRowIndex].appendChild(this.createEmptyCell());
  }
  if(captionPosition === ASPx.Position.Right && this.isVertical(this.position)) {
   helpTextRow.appendChild(helpTextCell);
   helpTextRow.appendChild(this.createEmptyCell());
   if(this.position === ASPx.Position.Top)
    errorTableBody.insertBefore(helpTextRow, errorTableBody.childNodes[0]);
   else
    errorTableBody.appendChild(helpTextRow);
  }
  if(this.isVertical(captionPosition) && this.isVertical(this.position)) {
   helpTextRow.appendChild(helpTextCell);
   if(captionPosition === ASPx.Position.Top && this.position === ASPx.Position.Top)
    errorTableBody.insertBefore(helpTextRow, captionCell.parentNode.nextSibling);
   if(captionPosition === ASPx.Position.Top && this.position === ASPx.Position.Bottom)
    errorTableBody.appendChild(helpTextRow);
   if(captionPosition === ASPx.Position.Bottom && this.position === ASPx.Position.Top)
    errorTableBody.insertBefore(helpTextRow, errorTableBody.childNodes[0]);
   if(captionPosition === ASPx.Position.Bottom && this.position === ASPx.Position.Bottom)
    errorTableBody.insertBefore(helpTextRow, captionCell.parentNode);
  }
  if(captionPosition === ASPx.Position.Left && this.position === ASPx.Position.Left)
   captionCell.parentNode.insertBefore(helpTextCell, captionCell.nextSibling);
  if(captionPosition === ASPx.Position.Right && this.position === ASPx.Position.Right)
   captionCell.parentNode.insertBefore(helpTextCell, captionCell);
  if(captionPosition === ASPx.Position.Left && this.position === ASPx.Position.Right)
   tableRows[0].appendChild(helpTextCell);
  if(captionPosition === ASPx.Position.Right && this.position === ASPx.Position.Left)
   tableRows[0].insertBefore(helpTextCell, tableRows[0].childNodes[0]);
 },
 addHelpTextCellToExternalTableWithEditorOnly: function (helpTextCell, errorTableBody, tableRows) {
  if(this.isHorizontal(this.position)) {
   if(this.position === ASPx.Position.Left)
    tableRows[0].insertBefore(helpTextCell, tableRows[0].childNodes[0]);
   else
    tableRows[0].appendChild(helpTextCell);
  }
  else {
   var helpTextRow = document.createElement("TR");
   helpTextRow.appendChild(helpTextCell);
   if(this.position === ASPx.Position.Top)
    errorTableBody.insertBefore(helpTextRow, errorTableBody.childNodes[0]);
   else
    errorTableBody.appendChild(helpTextRow);
  }
 },
 addHelpTextCellToExternalTable: function (errorTable, helpTextCell) {
  var errorTableBody = ASPx.GetNodeByTagName(errorTable, "TBODY", 0);
  var tableRows = this.getRows(errorTableBody);
  var captionCell = this.editor.GetCaptionCell();
  var errorCell = this.editor.GetErrorCell();
  if(captionCell) {
   if(errorCell)
    this.addHelpTextCellToExternalTableWithTwoCells(captionCell, errorCell, helpTextCell, errorTableBody, tableRows);
   else
    this.addHelpTextCellToExternalTableWithCaption(captionCell, helpTextCell, errorTableBody, tableRows);
  }
  else if(errorCell)
   this.addHelpTextCellToExternalTableWithErrorCell(errorCell, helpTextCell, errorTableBody, tableRows);
  else
   this.addHelpTextCellToExternalTableWithEditorOnly(helpTextCell, errorTableBody, tableRows);
 },
 createExternalTable: function () {
  var externalTable = document.createElement("TABLE");
  externalTable.id = this.editor.name + ASPx.EditElementSuffix.ExternalTable;
  externalTable.cellPadding = 0;
  externalTable.cellSpacing = 0;
  this.applyExternalTableStyle(externalTable);
  var editorWidth = this.editorMainElement.style.width;
  if(ASPx.IsPercentageSize(editorWidth)) {
   externalTable.style.width = editorWidth;
   this.editorMainElement.style.width = "100%";
   this.editor.width = "100%";
  }
  var externalTableBody = document.createElement("TBODY");
  var externalTableRow = document.createElement("TR");
  var externalTableCell = document.createElement("TD");
  externalTable.appendChild(externalTableBody);
  externalTableBody.appendChild(externalTableRow);
  externalTableRow.appendChild(externalTableCell);
  this.editorMainElement.parentNode.appendChild(externalTable);
  ASPx.ChangeElementContainer(this.editorMainElement, externalTableCell, true);
  return externalTable;
 },
 applyExternalTableStyle: function (externalTable) {
  var externalTableStyle = this.editor.externalTableStyle;
  if(externalTableStyle.length > 0) {
   this.applyStyleToElement(externalTable, externalTableStyle);
  }
 },
 applyStyleToElement: function(element, style) {
  element.className = style[0];
  if(style[1]) {
   var styleSheet = ASPx.GetCurrentStyleSheet();
   element.className += " " + ASPx.CreateImportantStyleRule(styleSheet, style[1]);
  }
 },
 createInlineHelpTextElement: function () {
  var helpTextElement = document.createElement("TD");
  var externalTable = this.editor.GetExternalTable();
  if(!externalTable)
   externalTable = this.createExternalTable();
  this.addHelpTextCellToExternalTable(externalTable, helpTextElement);
  return helpTextElement;
 },
 createPopupHelpTextElement: function () {
  var helpTextElement = document.createElement("DIV");
  document.body.appendChild(helpTextElement);
  ASPx.AnimationHelper.setOpacity(helpTextElement, 0);
  return helpTextElement;
 },
 createHelpTextElement: function () {
  return this.displayMode === ASPxClientTextEditHelpTextDisplayMode.Popup ?
   this.createPopupHelpTextElement() : this.createInlineHelpTextElement();
 },
 prepareHelpTextElement: function (helpTextStyle, helpText) {
  this.helpTextElement.id = this.getHelpTextElementId();
  this.applyStyleToElement(this.helpTextElement, helpTextStyle);
  ASPx.SetInnerHtml(this.helpTextElement, "<SPAN>" + helpText + "</SPAN>");
  if(this.displayMode === ASPxClientTextEditHelpTextDisplayMode.Popup)
   this.updatePopupHelpTextPosition();
  else {
   var isVerticalOrientation = this.position === ASPx.Position.Top || this.position === ASPx.Position.Bottom;
   var orientationClassName = isVerticalOrientation ? ASPxClientTextEditHelpTextConsts.VERTICAL_ORIENTATION_CLASS_NAME :
    ASPxClientTextEditHelpTextConsts.HORIZONTAL_ORIENTATION_CLASS_NAME;
   this.helpTextElement.className += " " + orientationClassName;
   this.setInlineHelpTextElementAlign();
   ASPx.SetElementDisplay(this.helpTextElement, this.editor.clientVisible);
  }
 },
 getHelpTextElementId: function() {
  return this.editor.name + ASPx.TEHelpTextElementSuffix;
 },
 setInlineHelpTextElementAlign: function() {
  var hAlignValue = "", vAlignValue = "";
  switch(this.hAlign) {
   case ASPxClientTextEditHelpTextHAlign.Left: hAlignValue = "left"; break;
   case ASPxClientTextEditHelpTextHAlign.Right: hAlignValue = "right"; break;
   case ASPxClientTextEditHelpTextHAlign.Center: hAlignValue = "center"; break;
  }
  switch(this.vAlign) {
   case ASPxClientTextEditHelpTextVAlign.Top: vAlignValue = "top"; break;
   case ASPxClientTextEditHelpTextVAlign.Bottom: vAlignValue = "bottom"; break;
   case ASPxClientTextEditHelpTextVAlign.Middle: vAlignValue = "middle"; break;
  }
  this.helpTextElement.style.textAlign = hAlignValue;
  this.helpTextElement.style.verticalAlign = vAlignValue;
 },
 getHelpTextMargins: function() {
  if(this.margins)
   return this.margins;
  var result = this.defaultMargins;
  if(this.position === ASPx.Position.Top || this.position === ASPx.Position.Bottom)
   result.Left = result.Right = 0;
  else
   result.Top = result.Bottom = 0;
  return result;
 },
 updatePopupHelpTextPosition: function (editorMainElement) {
  var editorWidth = this.editorMainElement.offsetWidth;
  var editorHeight = this.editorMainElement.offsetHeight;
  var helpTextWidth = this.helpTextElement.offsetWidth;
  var helpTextHeight = this.helpTextElement.offsetHeight;
  var editorX = ASPx.GetAbsoluteX(this.editorMainElement);
  var editorY = ASPx.GetAbsoluteY(this.editorMainElement);
  var helpTextX = 0, helpTextY = 0;
  var margins = this.getHelpTextMargins();
  if(this.position === ASPx.Position.Top || this.position === ASPx.Position.Bottom) {
   if(this.position === ASPx.Position.Top)
    helpTextY = editorY - margins.Bottom - helpTextHeight;
   else if(this.position === ASPx.Position.Bottom)
    helpTextY = editorY + editorHeight + margins.Top;
   if(this.hAlign === ASPxClientTextEditHelpTextHAlign.Left)
    helpTextX = editorX + margins.Left;
   else if(this.hAlign === ASPxClientTextEditHelpTextHAlign.Right)
    helpTextX = editorX + editorWidth - helpTextWidth - margins.Right;
   else if(this.hAlign === ASPxClientTextEditHelpTextHAlign.Center) {
    var editorCenterX = editorX + editorWidth / 2;
    var helpTextWidthWithMargins = helpTextWidth + margins.Left + margins.Right;
    helpTextX = editorCenterX - helpTextWidthWithMargins / 2 + margins.Left;
   }
  } else {
   if(this.position === ASPx.Position.Left)
    helpTextX = editorX - margins.Right - helpTextWidth;
   else if(this.position === ASPx.Position.Right)
    helpTextX = editorX + editorWidth + margins.Left;
   if(this.vAlign === ASPxClientTextEditHelpTextVAlign.Top)
    helpTextY = editorY + margins.Top;
   else if(this.vAlign === ASPxClientTextEditHelpTextVAlign.Bottom)
    helpTextY = editorY + editorHeight - helpTextHeight - margins.Bottom;
   else if(this.vAlign === ASPxClientTextEditHelpTextVAlign.Middle) {
    var editorCenterY = editorY + editorHeight / 2;
    var helpTextHeightWithMargins = helpTextHeight + margins.Top + margins.Bottom;
    helpTextY = editorCenterY - helpTextHeightWithMargins / 2 + margins.Top;
   }
  }
  helpTextX = helpTextX < 0 ? 0 : helpTextX;
  helpTextY = helpTextY < 0 ? 0 : helpTextY;
  ASPx.SetAbsoluteX(this.helpTextElement, helpTextX);
  ASPx.SetAbsoluteY(this.helpTextElement, helpTextY);
 },
 setHelpTextZIndex: function (hide) { 
  var newZIndex = 41998 * (hide ? -1 : 1);
  if(this.helpTextElement.style.zIndex != newZIndex)
   this.helpTextElement.style.zIndex = newZIndex;
 },
 hide: function () {
  if(this.displayMode === ASPxClientTextEditHelpTextDisplayMode.Inline) {
   ASPx.SetElementDisplay(this.helpTextElement, false);
  }
  else {
   this.animationEnabled ? ASPx.AnimationHelper.fadeOut(this.helpTextElement) :
    ASPx.AnimationHelper.setOpacity(this.helpTextElement, 0);
   this.setHelpTextZIndex(true);
  }
 },
 show: function () {
  if(this.displayMode === ASPxClientTextEditHelpTextDisplayMode.Inline) {
   ASPx.SetElementDisplay(this.helpTextElement, true);
  }
  else {
   this.updatePopupHelpTextPosition();
   this.animationEnabled ? ASPx.AnimationHelper.fadeIn(this.helpTextElement) :
    ASPx.AnimationHelper.setOpacity(this.helpTextElement, 1);
   this.setHelpTextZIndex(false);
  }
 }
});
var ASPxOutOfRangeWarningManager = ASPx.CreateClass(null, {
 constructor: function (editor, minValue, maxValue, defaultMinValue, defaultMaxValue, outOfRangeWarningElementPosition, valueFormatter) {
  this.editor = editor;
  this.outOfRangeWarningElementPosition = outOfRangeWarningElementPosition;
  this.minValue = minValue;
  this.maxValue = maxValue;
  this.defaultMinValue = defaultMinValue;
  this.defaultMaxValue = defaultMaxValue;
  this.minMaxValueFormatter = valueFormatter;
  this.animationDuration = 150;
  this.CreateOutOfRangeWarningElement();
 },
 SetMinValue: function (minValue) {
  this.minValue = minValue;
  this.UpdateOutOfRangeWarningElementText();
 },
 SetMaxValue: function (maxValue) {
  this.maxValue = maxValue;
  this.UpdateOutOfRangeWarningElementText();
 },
 CreateOutOfRangeWarningElement: function () {
  this.outOfRangeWarningElement = document.createElement("DIV");
  this.outOfRangeWarningElement.id = this.editor.name + "OutOfRWarn";
  ASPx.InsertElementAfter(this.outOfRangeWarningElement, this.editor.GetMainElement());
  ASPx.AnimationHelper.setOpacity(this.outOfRangeWarningElement, 0);
  this.outOfRangeWarningElement.className = this.editor.outOfRangeWarningClassName;
  this.UpdateOutOfRangeWarningElementText();
 },
 IsValueInRange: function (value) {
  return (!this.IsMinValueExists() || value >= this.minValue)
   && (!this.IsMaxValueExists() || value <= this.maxValue);
 },
 IsMinValueExists: function() {
  return ASPx.IsExists(this.minValue) && !isNaN(this.minValue) && this.minValue !== this.defaultMinValue;
 },
 IsMaxValueExists: function () {
  return ASPx.IsExists(this.maxValue) && !isNaN(this.maxValue) && this.maxValue !== this.defaultMaxValue;
 },
 GetFormattedTextByValue: function(value) {
  if (this.minMaxValueFormatter)
   return this.minMaxValueFormatter.Format(value);
  return value;
 },
 GetWarningText: function() {
  var textTemplate = arguments[0];
  var valueTexts = [];
  for (var i = 1; i < arguments.length; i++) {
   var valueText = this.GetFormattedTextByValue(arguments[i]);
   valueTexts.push(valueText);
  }
  return ASPx.Formatter.Format(textTemplate, valueTexts);
 },
 UpdateOutOfRangeWarningElementText: function () {
  var text = "";
  if (this.IsMinValueExists() && this.IsMaxValueExists())
   text = this.GetWarningText(this.editor.outOfRangeWarningMessages[0], this.minValue, this.maxValue);
  if (this.IsMinValueExists() && !this.IsMaxValueExists())
   text = this.GetWarningText(this.editor.outOfRangeWarningMessages[1], this.minValue);
  if (!this.IsMinValueExists() && this.IsMaxValueExists())
   text = this.GetWarningText(this.editor.outOfRangeWarningMessages[2], this.maxValue);
  ASPx.SetInnerHtml(this.outOfRangeWarningElement, "<LABEL>" + text + "</LABEL>");
 },
 UpdateOutOfRangeWarningElementVisibility: function (currentValue) {
  var isValidValue = currentValue == null || this.IsValueInRange(currentValue);
  if (!isValidValue && !this.outOfRangeWarningElementShown)
   this.ShowOutOfRangeWarningElement();
  if (isValidValue && this.outOfRangeWarningElementShown)
   this.HideOutOfRangeWarningElement();
 },
 GetOutOfRangeWarningElementCoordinates: function() {
  var editorMainElement = this.editor.GetMainElement();
  var editorWidth = editorMainElement.offsetWidth;
  var editorHeight = editorMainElement.offsetHeight;
  var editorX = ASPx.GetAbsoluteX(editorMainElement);
  var editorY = ASPx.GetAbsoluteY(editorMainElement);
  var outOfRangeWarningElementX = this.outOfRangeWarningElementPosition === ASPx.Position.Right ? editorX + editorWidth : editorX;
  var outOfRangeWarningElementY = this.outOfRangeWarningElementPosition === ASPx.Position.Right ? editorY : editorY + editorHeight;
  outOfRangeWarningElementX = outOfRangeWarningElementX < 0 ? 0 : outOfRangeWarningElementX;
  outOfRangeWarningElementY = outOfRangeWarningElementY < 0 ? 0 : outOfRangeWarningElementY;
  return {
   x: outOfRangeWarningElementX,
   y: outOfRangeWarningElementY
  };
 },
 ShowOutOfRangeWarningElement: function () {
  this.outOfRangeWarningElement.style.display = "inline";
  var outOfRangeWarningElementCoordinates = this.GetOutOfRangeWarningElementCoordinates();
  ASPx.SetAbsoluteX(this.outOfRangeWarningElement, outOfRangeWarningElementCoordinates.x);
  ASPx.SetAbsoluteY(this.outOfRangeWarningElement, outOfRangeWarningElementCoordinates.y);
  ASPx.AnimationHelper.fadeIn(this.outOfRangeWarningElement, null, this.animationDuration);
  this.outOfRangeWarningElementShown = true;
 },
 HideOutOfRangeWarningElement: function () {
  ASPx.AnimationHelper.fadeOut(this.outOfRangeWarningElement, function () {
   ASPx.SetElementDisplay(this.outOfRangeWarningElement, false);
  }.aspxBind(this), this.animationDuration);
  this.outOfRangeWarningElementShown = false;
 }
});
ASPx.MMMouseOut = function(name, evt) {
 var edit = ASPx.GetControlCollection().Get(name);
 if(edit != null) edit.OnMouseOut(evt);
}
ASPx.MMMouseOver = function(name, evt) {
 var edit = ASPx.GetControlCollection().Get(name);
 if(edit != null) edit.OnMouseOver(evt);
}
ASPx.MaskHintTimerProc = function() {
 var focusedEditor = ASPx.GetFocusedEditor();
 if(focusedEditor != null && ASPx.IsFunction(focusedEditor.MaskHintTimerProc))
  focusedEditor.MaskHintTimerProc();
}
ASPx.ETextChanged = function(name) {
 var edit = ASPx.GetControlCollection().Get(name);
 if(edit != null) edit.OnTextChanged(); 
}
ASPx.BEClick = function(name,number){
 var edit = ASPx.GetControlCollection().Get(name);
 if(edit != null) edit.OnButtonClick(number);
}
ASPx.BEClear = function(name, evt) {
 var edit = ASPx.GetControlCollection().Get(name);
 if(edit && (evt.button === 0 || ASPx.Browser.TouchUI)) {
  var requireFocus = !ASPx.Browser.VirtualKeyboardSupported || ASPx.Browser.MSTouchUI;
  if(requireFocus)
   edit.GetInputElement().focus();
  (function performOnClean() {
   if(edit.IsFocused() || !requireFocus)
    edit.OnClear();
   else
    window.setTimeout(performOnClean, 100);
  })();
 }
}
ASPx.SetFocusToTextEditWithDelay = function(name) {
 window.setTimeout(function() {
  var edit = ASPx.GetControlCollection().Get(name);
  if(!edit)
   return;
  ASPx.Browser.IE ? edit.SetCaretPosition(0) : edit.SetFocus();
 }, 500);
}
window.ASPxClientTextEdit = ASPxClientTextEdit;
window.ASPxClientTextBoxBase = ASPxClientTextBoxBase;
window.ASPxClientTextBox = ASPxClientTextBox;
window.ASPxClientMemo = ASPxClientMemo;
window.ASPxClientButtonEditBase = ASPxClientButtonEditBase;
window.ASPxClientButtonEdit = ASPxClientButtonEdit;
window.ASPxClientButtonEditClickEventArgs = ASPxClientButtonEditClickEventArgs;
})();

(function () {
var PagerIDSuffix = {
 PageSizeBox: "PSB",
 PageSizeButton: "DDB",
 PageSizePopup: "PSP"
};
var ASPxClientPager = ASPx.CreateClass(ASPxClientControl, {
 constructor: function (name) {
  this.constructor.prototype.constructor.call(this, name);
  this.hasOwnerControl = false;
  this.originalWidth = null;
  this.containerOffsetWidth = 0;
  this.droppedDown = false;
  this.pageSizeItems = [];
  this.pageSizeSelectedItem = null;
  this.enableAdaptivity = false;
  this.pageSizeChanged = new ASPxClientEvent();
  this.requireInlineLayout = false;
 },
 InlineInitialize: function () {
  this.originalWidth = this.GetMainElement().style.width;
  ASPxClientControl.prototype.InlineInitialize.call(this);
 },
 Initialize: function() {
  ASPxClientControl.prototype.Initialize.call(this);
  aspxGetPagersCollection().Add(this);
  if(this.requireInlineLayout) {
   var mainElement = this.GetMainElement();
   mainElement.style.display = "inline-block";
   mainElement.style.float = "none";
  }
 },
 BrowserWindowResizeSubscriber: function () {
  return ASPxClientControl.prototype.BrowserWindowResizeSubscriber.call(this) || this.hasOwnerControl;
 },
 OnBrowserWindowResize: function (e) {
  this.AdjustControl();
 },
 GetAdjustedSizes: function () {
  if(this.hasOwnerControl) {
   var mainElement = this.GetMainElement();
   if(mainElement)
    return { width: mainElement.parentNode.offsetWidth, height: mainElement.parentNode.offsetHeight };
  }
  return ASPxClientControl.prototype.GetAdjustedSizes.call(this);
 },
 AdjustControlCore: function() {
  this.CorrectVerticalAlignment(ASPx.ClearHeight, this.GetPageSizeButtonElement, "PSB");
  this.CorrectVerticalAlignment(ASPx.ClearVerticalMargins, this.GetPageSizeButtonImage, "PSBImg");
  this.CorrectVerticalAlignment(ASPx.ClearHeight, this.GetButtonElements, "Btns");
  this.CorrectVerticalAlignment(ASPx.ClearVerticalMargins, this.GetButtonImages, "BtnImgs");
  this.CorrectVerticalAlignment(ASPx.ClearVerticalMargins, this.GetSeparatorElements, "Seps");
  this.containerOffsetWidth = this.GetContainerWidth();
  var savedDroppedDown = false;
  if(this.droppedDown && this.GetPageSizePopupMenu()) {
   this.HidePageSizeDropDown();
   savedDroppedDown = true;
  }
  if(ASPx.IsPercentageSize(this.originalWidth))
   this.AdjustControlItems();
  else if(this.hasOwnerControl)
   this.AdjustControlMinWidth();
  if(savedDroppedDown)
   this.ShowPageSizeDropDown();
  this.CorrectVerticalAlignment(ASPx.AdjustHeight, this.GetPageSizeButtonElement, "PSB");
  this.CorrectVerticalAlignment(ASPx.AdjustVerticalMargins, this.GetPageSizeButtonImage, "PSBImg");
  this.CorrectVerticalAlignment(ASPx.AdjustHeight, this.GetButtonElements, "Btns");
  this.CorrectVerticalAlignment(ASPx.AdjustVerticalMargins, this.GetButtonImages, "BtnImgs");
  this.CorrectVerticalAlignment(ASPx.AdjustVerticalMargins, this.GetSeparatorElements, "Seps");
 },
 AdjustControlMinWidth: function() {
  var mainElement = this.GetMainElement();
  if(!mainElement) return;  
  if(this.enableAdaptivity) {
   this.SetElementsDisplay(mainElement, "dxp-num", true);
   this.SetElementsDisplay(mainElement, "dxp-ellip", true);
   this.SetElementsDisplay(mainElement, "dxp-summary", true);
   if(this.GetAdaptiveWidth(mainElement) < this.GetMinWidth(mainElement)){
    this.SetElementsDisplay(mainElement, "dxp-num", false);
    this.SetElementsDisplay(mainElement, "dxp-ellip", false);
   }
   if(this.GetAdaptiveWidth(mainElement) < this.GetMinWidth(mainElement)){
    this.SetElementsDisplay(mainElement, "dxp-summary", false);
   }
  }
  else {
   var minWidth = this.GetMinWidth(mainElement);
   mainElement.style.minWidth = minWidth + "px";
  }
 },
 GetAdaptiveWidth: function(element){
  if(ASPx.IsPercentageSize(this.originalWidth)) 
   return element.offsetWidth;
  else if(this.hasOwnerControl)
   return element.parentNode.offsetWidth;
  else
   return 10000;
 },
 GetMinWidth: function(element){
  return this.GetItemsWidth(element) + ASPx.GetLeftRightPaddings(element) + (ASPx.Browser.HardwareAcceleration ? 1 : 0);
 },
 SetElementsDisplay: function(element, cssClass, value) {
  var elements = ASPx.GetNodesByPartialClassName(element, cssClass);
  for(var i = 0; i < elements.length; i++) 
   ASPx.SetElementDisplay(elements[i], value);
 },
 AdjustControlItems: function () {
  var mainElement = this.GetMainElement();
  mainElement.style.width = this.originalWidth;
  var spacers = [];
  for(var i = 0; i < mainElement.childNodes.length; i++) {
   var itemElement = mainElement.childNodes[i];
   if(!itemElement.tagName) continue;
   if(itemElement.className === "dxp-spacer") {
    spacers.push(itemElement);
    itemElement.style.width = "0px";
   }
  }
  this.AdjustControlMinWidth();
  if(spacers.length > 0) {
   var clientWidth = mainElement.clientWidth - ASPx.GetLeftRightPaddings(mainElement);
   var spacerWidth = Math.floor((clientWidth - this.GetItemsWidth(mainElement)) / spacers.length);
   var makeItemsFloatRight = false;
   var rightItems = [];
   for(var i = 0; i < mainElement.childNodes.length; i++) {
    var itemElement = mainElement.childNodes[i];
    if(!itemElement.tagName) continue;
    if(itemElement.className === "dxp-spacer") {
     if(itemElement == spacers[spacers.length - 1])
      makeItemsFloatRight = true;
     else
      itemElement.style.width = spacerWidth + "px";
    }
    else if(makeItemsFloatRight) {
     if(!this.IsAdjusted())
      rightItems.push(itemElement);
    }
   }
   this.AdjustRightFloatItems(rightItems, ASPx.GetLeftRightPaddings(mainElement));
   this.AdjustControlMinWidth();
  }
 },
 AdjustRightFloatItems: function (items, rightMargin) {
  for(var i = 0; i < items.length; i++) {
   if(i > 0)
    items[i].parentNode.insertBefore(items[i], items[i - 1]);
   items[i].className += " dxp-right";
  }
 },
 GetItemsWidth: function (mainElement) {
  var width = 0;
  for(var i = 0; i < mainElement.childNodes.length; i++)
   width += this.GetItemWidth(mainElement.childNodes[i]);
  return width;
 },
 GetItemWidth: function (item) {
  if(!item || !item.tagName || !ASPx.GetElementDisplay(item))
   return 0;
  var style = ASPx.GetCurrentStyle(item);
  var margins = ASPx.PxToInt(style.marginLeft) + ASPx.PxToInt(style.marginRight);
  if(ASPx.Browser.IE) {
   if(ASPx.Browser.Version > 8)
    return ASPx.PxToFloat(window.getComputedStyle(item, null).width) + ASPx.GetLeftRightBordersAndPaddingsSummaryValue(item) + margins;
   return item.offsetWidth + margins;
  }
  return ASPx.PxToFloat(style.width) + ASPx.GetLeftRightBordersAndPaddingsSummaryValue(item) + margins;
 },
 GetContainerWidth: function () {
  var mainElement = this.GetMainElement();
  if(mainElement && mainElement.parentNode)
   return mainElement.parentNode.offsetWidth;
  return 0;
 },
 GetPageSizeBoxID: function () {
  return this.name + "_" + PagerIDSuffix.PageSizeBox;
 },
 GetPageSizeButtonID: function () {
  return this.name + "_" + PagerIDSuffix.PageSizeButton;
 },
 GetPageSizePopupMenuID: function () {
  return this.name + "_" + PagerIDSuffix.PageSizePopup;
 },
 GetPageSizeBoxElement: function () {
  return ASPx.GetElementById(this.GetPageSizeBoxID());
 },
 GetPageSizeButtonElement: function () {
  return ASPx.GetElementById(this.GetPageSizeButtonID());
 },
 GetPageSizeButtonImage: function () {
  return ASPx.GetNodeByTagName(this.GetPageSizeButtonElement(), "IMG", 0);
 },
 GetPageSizeInputElement: function () {
  return ASPx.GetNodeByTagName(this.GetPageSizeBoxElement(), "INPUT", 0);
 },
 GetPageSizePopupMenu: function () {
  return ASPx.GetControlCollection().Get(this.GetPageSizePopupMenuID());
 },
 GetButtonElements: function () {
  return ASPx.GetNodesByClassName(this.GetMainElement(), "dxp-button");
 },
 GetButtonImages: function () {
  var images = [];
  var buttons = this.GetButtonElements();
  for(var i = 0; i < buttons.length; i++) {
   var img = ASPx.GetNodeByTagName(buttons[i], "IMG", 0);
   if(img) images.push(img);
  }
  return images;
 },
 GetSeparatorElements: function () {
  return ASPx.GetNodesByClassName(this.GetMainElement(), "dxp-sep");
 },
 TogglePageSizeDropDown: function () {
  if(!this.droppedDown)
   this.ShowPageSizeDropDown();
  else
   this.HidePageSizeDropDown();
 },
 ShowPageSizeDropDown: function () {
  this.GetPageSizePopupMenu().Show();
  this.droppedDown = true;
 },
 HidePageSizeDropDown: function () {
  this.GetPageSizePopupMenu().Hide();
  this.droppedDown = false;
 },
 ChangePageSizeInput: function (isNext) {
  var input = this.GetPageSizeInputElement();
  var index = this.GetPageSizeIndexByText(input.value);
  var count = this.pageSizeItems.length;
  if(isNext)
   index = (index < count - 1) ? (index + 1) : 0;
  else
   index = (index > 0) ? (index - 1) : (count - 1);
  input.value = this.pageSizeItems[index].text;
 },
 ChangePageSizeValue: function (value) {
  this.GetPageSizeInputElement().value = this.GetPageSizeTextByValue(value);
 },
 IsPageSizeValueChanged: function () {
  var newValue = this.GetPageSizeValueByText(this.GetPageSizeInputElement().value);
  return newValue != this.pageSizeSelectedItem.value;
 },
 OnDocumentOnClick: function (evt) {
  var srcElement = ASPx.Evt.GetEventSource(evt);
  if(srcElement != this.GetPageSizeBoxElement() && ASPx.GetParentById(srcElement, this.GetPageSizeBoxID()) == null) {
   this.droppedDown = false;
  }
 },
 OnPageSizeClick: function (evt) {
  var self = this;
  window.setTimeout(function () {
   self.TogglePageSizeDropDown();
  }, 0);
  ASPx.SetFocus(this.GetPageSizeInputElement());
 },
 OnPageSizePopupItemClick: function (value) {
  this.ChangePageSizeValue(value);
  if(this.IsPageSizeValueChanged())
   this.OnPageSizeValueChanged();
 },
 OnPageSizeBlur: function (evt) {
  if(this.IsPageSizeValueChanged())
   this.OnPageSizeValueChanged();
 },
 OnPageSizeKeyDown: function (evt) {
  var keyCode = ASPx.Evt.GetKeyCode(evt);
  if(keyCode == ASPx.Key.Down || keyCode == ASPx.Key.Up) {
   if(evt.altKey)
    this.TogglePageSizeDropDown();
   else
    this.ChangePageSizeInput(keyCode == ASPx.Key.Down);
   if(this.droppedDown) {
    var popupMenu = this.GetPageSizePopupMenu();
    var value = this.GetPageSizeValueByText(this.GetPageSizeInputElement().value);
    var item = popupMenu.GetItemByName(value);
    popupMenu.SetSelectedItem(item);
    ASPx.Evt.PreventEvent(evt);
   }
  }
  else if(keyCode == ASPx.Key.Enter) {
   if(this.IsPageSizeValueChanged())
    this.OnPageSizeValueChanged();
   else
    this.HidePageSizeDropDown();
   return ASPx.Evt.PreventEventAndBubble(evt);
  }
  else if(keyCode == ASPx.Key.Tab) {
   this.HidePageSizeDropDown();
  }
  else if(keyCode == ASPx.Key.Esc) {
   this.HidePageSizeDropDown();
   this.GetPageSizeInputElement().value = this.pageSizeSelectedItem.text;
  }
  return true;
 },
 UpdatePageSizeSelectedItem: function() {
  this.pageSizeSelectedItem.text = this.GetPageSizeInputElement().value;
  this.pageSizeSelectedItem.value = this.GetPageSizeValueByText(this.pageSizeSelectedItem.text);
 },
 OnPageSizeValueChanged: function () {
  this.UpdatePageSizeSelectedItem();
  if(!this.pageSizeChanged.IsEmpty()) {
   var popupMenu = this.GetPageSizePopupMenu();
   var menuItem = popupMenu.GetItemByName(this.pageSizeSelectedItem.value);
   var menuItemElement = popupMenu.GetItemElement(menuItem.index);
   var command = PagerIDSuffix.PageSizePopup + this.pageSizeSelectedItem.value;
   var args = new ASPxClientPagerPageSizeChangedEventArgs(menuItemElement, command);
   this.pageSizeChanged.FireEvent(this, args);
  }
 },
 GetPageSizeIndexByText: function (text) {
  var count = this.pageSizeItems.length;
  for(var i = 0; i < count; i++) {
   if(text == this.pageSizeItems[i].text)
    return i;
  }
  return -1;
 },
 GetPageSizeTextByValue: function (value) {
  var count = this.pageSizeItems.length;
  for(var i = 0; i < count; i++) {
   if(value == this.pageSizeItems[i].value)
    return this.pageSizeItems[i].text;
  }
  return value.toString();
 },
 GetPageSizeValueByText: function (text) {
  var count = this.pageSizeItems.length;
  for(var i = 0; i < count; i++) {
   if(text == this.pageSizeItems[i].text)
    return this.pageSizeItems[i].value;
  }
  return this.pageSizeSelectedItem.value;
 }
});
var ASPxClientPagerPageSizeChangedEventArgs = ASPx.CreateClass(ASPxClientEventArgs, {
 constructor: function (element, value) {
  this.constructor.prototype.constructor.call(this);
  this.element = element;
  this.value = value;
 }
});
var pagersCollection = null;
function aspxGetPagersCollection() {
 if(pagersCollection == null)
  pagersCollection = new ASPxClientPagersCollection();
 return pagersCollection;
}
var ASPxClientPagersCollection = ASPx.CreateClass(ASPxClientControlCollection, {
 constructor: function () {
  this.constructor.prototype.constructor.call(this);
 },
 GetCollectionType: function(){
  return "Pager";
 },
 OnDocumentOnClick: function (evt) {
  this.ForEachControl(function (control) {
   control.OnDocumentOnClick(evt);
  });
 }
});
ASPx.Evt.AttachEventToDocument("click", aspxPagerDocumentOnClick);
function aspxPagerDocumentOnClick(evt) {
 return aspxGetPagersCollection().OnDocumentOnClick(evt);
}
function _aspxPGNavCore(element) {
 if(element != null) {
  if(element.tagName != "A") {
   var linkElement = ASPx.GetNodeByTagName(element, "A", 0);
   if(linkElement != null)
    ASPx.Url.NavigateByLink(linkElement);
  }
 }
}
ASPx.PGNav = function(evt) {
 var element = ASPx.Evt.GetEventSource(evt);
 _aspxPGNavCore(element);
 if(!ASPx.Browser.NetscapeFamily)
  evt.cancelBubble = true;
}
ASPx.POnPageSizeChanged = function(s, e) {
 s.SendPostBack(e.value);
}
ASPx.POnSeoPageSizeChanged = function(s, e) {
 _aspxPGNavCore(e.element);
}
ASPx.POnPageSizeBlur = function(name, evt) {
 var pager = ASPx.GetControlCollection().Get(name);
 if(pager != null)
  pager.OnPageSizeBlur(evt);
 return true;
}
ASPx.POnPageSizeKeyDown = function(name, evt) {
 var pager = ASPx.GetControlCollection().Get(name);
 if(pager != null)
  return pager.OnPageSizeKeyDown(evt);
 return true;
}
ASPx.POnPageSizeClick = function(name, evt) {
 var pager = ASPx.GetControlCollection().Get(name);
 if(pager != null)
  pager.OnPageSizeClick(evt);
}
ASPx.POnPageSizePopupItemClick = function(name, item) {
 var pager = ASPx.GetControlCollection().Get(name);
 if(pager != null) {
  pager.OnPageSizePopupItemClick(item.name);
 }
}
window.ASPxClientPager = ASPxClientPager;
window.ASPxClientPagerPageSizeChangedEventArgs = ASPxClientPagerPageSizeChangedEventArgs;
ASPx.GetPagersCollection = aspxGetPagersCollection;
})();
