{//////////////////////////////////////////////////////////////////////////}
{                                                                          }
{                          MORETYPE.INC                                    }
{                                                                          }
{                MORE WIN32 TYPE DEFINITIONS FOR GPC                       }
{                                                                          }
{   Authors: Allan Mertner <vpascal@vpascal.com>                           }
{            Prof. Abimbola Olowofoyeku <chiefsoft at bigfoot dot com>     }
{                                                                          }
{   This file is derived from the Virtual Pascal "Windows" unit, and       }
{   has been amended and is used herein with the kind permission of        }
{   Allan Mertner, who develops and owns the copyright to the Virtual      }
{   Pascal compiler. For Virtual Pascal, see http://www.vpascal.com        }
{                                                                          }
{   This file is FREEWARE.                                                 }
{                                                                          }
{   Last modified: 15 April 2003                                           }
{                                                                          }
{//////////////////////////////////////////////////////////////////////////}

TYPE
  PWIN32StreamID = ^TWIN32StreamID;
  TWIN32StreamID = RECORD
    dwStreamId : DWord;
    dwStreamAttributes : DWord;
    Size : TLargeInteger;
    dwStreamNameSize : DWord;
    cStreamName : ARRAY [0..0] OF WCHAR;
  END;

TYPE
  PWin32FileAttributeData = ^TWin32FileAttributeData;
  TWin32FileAttributeData = RECORD
    dwFileAttributes : DWord;
    ftCreationTime : TFileTime;
    ftLastAccessTime : TFileTime;
    ftLastWriteTime : TFileTime;
    nFileSizeHigh : DWord;
    nFileSizeLow : DWord;
  END;


{--}
{ Map a WIN32 error value into a HRESULT }
{ Note: This assumes that WIN32 errors fall in the range -32k to 32k. }
CONST
  { Define bits here so macros are guaranteed to work }
  facility_NT_Bit = $10000000;


CONST
  { HRESULT value definitions }
  { Codes $4000-$40ff are reserved for OLE }

  { Success codes }
  s_OK    = $00000000;
  s_False = $00000001;

  NoError = 0;

  { Catastrophic failure }
  E_Unexpected = $8000FFFF;

  { Not implemented }
  E_NotImpl = $80004001;

  { Ran out of memory }
  E_OutOfMemory = $8007000E;

  { One or more arguments are invalid }
  E_InvalidArg = $80070057;

  { No such interface supported }
  E_NoInterface = $80004002;

  { Invalid pointer }
  E_Pointer = $80004003;

  { Invalid handle }
  E_Handle = $80070006;

  { Operation aborted }
  E_Abort = $80004004;

  { Unspecified error }
  E_Fail = $80004005;

  { General access denied error }
  E_AccessDenied = $80070005;

  { The data necessary to complete this operation is not yet available. }
  E_Pending = $8000000A;

  { Thread local storage failure }
  CO_E_Init_TLS = $80004006;

  { Get shared memory allocator failure }
  CO_E_Init_Shared_Allocator = $80004007;

  { Get memory allocator failure }
  CO_E_Init_Memory_Allocator = $80004008;

  { Unable to initialize class cache }
  CO_E_Init_Class_Cache = $80004009;

  { Unable to initialize RPC services }
  CO_E_Init_RPC_Channel = $8000400A;

  { Cannot set thread local storage channel control }
  CO_E_Init_TLS_Set_Channel_Contro = $8000400B;

  { Could not allocate thread local storage channel control }
  CO_E_Init_TLS_Channel_Control = $8000400C;

  { The user supplied memory allocator is unacceptable }
  CO_E_Init_Unaccepted_User_Alloca = $8000400D;

  { The OLE service mutex already exists }
  CO_E_Init_SCM_Mutex_Exists = $8000400E;

  { The OLE service file mapping already exists }
  CO_E_Init_SCM_File_Mapping_Exist = $8000400F;

  { Unable to map view of file for OLE service }
  CO_E_Init_SCM_Map_View_of_Fild = $80004010;

  { Failure attempting to launch OLE service }
  CO_E_Init_SCM_Exec_Failure = $80004011;

  { There was an attempt to call CoInitialize a second time while single threaded }
  CO_E_Init_only_Single_Threaded = $80004012;

  { A Remote activation was necessary but was not allowed }
  CO_E_cant_Remote = $80004013;

  { A Remote activation was necessary but the server name provided was invalid }
  CO_E_bad_Server_Name = $80004014;

  { The class is configured to run as a security id different from the caller }
  CO_E_Wrong_Server_Identity = $80004015;

  { Use of Ole1 services requiring DDE windows is disabled }
  CO_E_OLE1DDE_Disabled = $80004016;

  { A RunAs specification must be <domain name>\<user name> or simply <user name> }
  CO_E_RunAs_Syntax = $80004017;

  { The server process could not be started.  The pathname may be incorrect. }
  CO_E_CreateProcess_Failure = $80004018;

  { The server process could not be started as the configured identity.  The pathname may be incorrect or unavailable. }
  CO_E_RunAs_CreateProcess_Failure = $80004019;

  { The server process could not be started because the configured identity is incorrect.  Check the username and password. }
  CO_E_RunAs_Logon_Failure = $8000401A;

  { The client is not allowed to launch this server. }
  CO_E_Launch_Permssion_Denied = $8000401B;

  { The service providing this server could not be started. }
  CO_E_Start_Service_Failure = $8000401C;

  { This computer was unable to communicate with the computer providing the server. }
  CO_E_Remote_Communication_Failure = $8000401D;

  { The server did not respond after being launched. }
  CO_E_Server_Start_Timeout = $8000401E;

  { The registration information for this server is inconsistent or incomplete. }
  CO_E_ClsReg_Inconsistent = $8000401F;

  { The registration information for this interface is inconsistent or incomplete. }
  CO_E_IIdReg_Inconsistent = $80004020;

  { The operation attempted is not supported. }
  CO_E_not_Supported = $80004021;


  { FACILITY_ITF }
  { Codes $0-$01ff are reserved for the OLE group of }

  { Generic OLE errors that may be returned by many inerfaces}
  OLE_E_First = $80040000;
  OLE_E_Last  = $800400FF;
  OLE_S_First = $40000;
  OLE_S_Last  = $400FF;

  { Invalid OLEVERB structure }
  OLE_E_OleVerb = $80040000;

  { Invalid advise flags }
  OLE_E_AdvF = $80040001;

  { Can't enumerate any more, because the associated data is missing }
  OLE_E_Enum_NoMore = $80040002;

  { This implementation doesn't take advises }
  OLE_E_AdviseNotSupported = $80040003;

  { There is no connection for this connection ID }
  OLE_E_NoConnection = $80040004;

  { Need to run the object to perform this operation }
  OLE_E_NotRunning = $80040005;

  { There is no cache to operate on }
  OLE_E_NoCache = $80040006;

  { Uninitialized object }
  OLE_E_Blank = $80040007;

  { Linked object's source class has changed }
  OLE_E_ClassDiff = $80040008;

  { Not able to get the moniker of the object }
  OLE_E_Cant_GetMoniker = $80040009;

  { Not able to bind to the source }
  OLE_E_Cant_BindToSource = $8004000A;

  { Object is static; operation not allowed }
  OLE_E_Static = $8004000B;

  { User cancelled out of save dialog }
  OLE_E_PromptSaveCancelled = $8004000C;

  { Invalid rectangle }
  OLE_E_InvalidRect = $8004000D;

  { compobj.dll is too old for the ole2.dll initialized }
  OLE_E_WrongCompObj = $8004000E;

  { Invalid window handle }
  OLE_E_InvalidHWnd = $8004000F;

  { Object is not in any of the inplace active states }
  OLE_E_not_InplaceActive = $80040010;

  { Not able to convert object }
  OLE_E_CantConvert = $80040011;

  OLE_E_NoStorage = $80040012;

  { Invalid FORMATETC structure }
  DV_E_FormatEtc = $80040064;

  { Invalid DVTARGETDEVICE structure }
  DV_E_DvTargetDevice = $80040065;

  { Invalid STDGMEDIUM structure }
  DV_E_StgMedium = $80040066;

  { Invalid STATDATA structure }
  DV_E_StatData = $80040067;

  { Invalid lindex }
  DV_E_LIndex = $80040068;

  { Invalid tymed }
  DV_E_TYMED = $80040069;

  { Invalid clipboard format }
  DV_E_ClipFormat = $8004006A;

  { Invalid aspect(s) }
  DV_E_DvAspect = $8004006B;

  { tdSize parameter of the DVTARGETDEVICE structure is invalid }
  DV_E_DvTargetDevice_Size = $8004006C;

  { Object doesn't support IViewObject interface }
  DV_E_NoIViewObject = $8004006D;

  DragDrop_E_First = $80040100;
  DragDrop_E_Last  = $8004010F;
  DragDrop_S_First = $40100;

  { Trying to revoke a drop target that has not been registered }
  DragDrop_E_NotRegistered = $80040100;

  { This window has already been registered as a drop target }
  DragDrop_E_AlreadyRegistered = $80040101;

  { Invalid window handle }
  DragDrop_E_InvalidHWnd = $80040102;

  ClassFactory_E_First = $80040110;
  ClassFactory_E_LAST  = $8004011F;
  ClassFactory_S_FIRST = $40110;

  { Class does not support aggregation (or class object is remote) }
  CLASS_E_NoAggregation = $80040110;

  { ClassFactory cannot supply requested class }
  CLASS_E_ClassNotAvailable = $80040111;

  MARSHAL_E_First = $80040120;
  MARSHAL_E_Last  = $8004012F;
  MARSHAL_S_First = $40120;
  MARSHAL_S_Last  = $4012F;
  DATA_E_First    = $80040130;
  DATA_E_Last     = $8004013F;
  DATA_S_Fisrt    = $40130;
  DATA_S_Last     = $4013F;
  VIEW_E_First    = $80040140;
  VIEW_E_Last     = $8004014F;
  VIEW_S_First    = $40140;

  { Error drawing view }
  VIEW_E_Draw = $80040140;

  RegDB_E_First = $80040150;
  RegDB_E_Last  = $8004015F;
  RegDB_S_First = $40150;

  { Could not read key from registry }
  RegDB_E_ReadRegDB = $80040150;

  { Could not write key to registry }
  RegDB_E_WriteRegDB = $80040151;

  { Could not find the key in the registry }
  RegDB_E_KeyMissing = $80040152;

  { Invalid value for registry }
  RegDB_E_InvalidValue = $80040153;

  { Class not registered }
  RegDB_E_ClassNotReg = $80040154;

  { Interface not registered }
  RegDB_E_IIdNotReg = $80040155;

  CACHE_E_First = $80040170;
  CACHE_E_Last  = $8004017F;
  CACHE_S_First = $40170;

  { Cache not updated }
  CACHE_E_NoCache_Updated = $80040170;

  OleObj_E_First = $80040180;
  OleObj_E_Last  = $8004018F;
  OleObj_S_First = $40180;

  { No verbs for OLE object }
  OleObj_E_NoVerbs = $80040180;

  { Invalid verb for OLE object }
  OleObj_E_ImvalidVerb = $80040181;

  ClientSite_E_First = $80040190;
  ClientSite_E_Last = $8004019F;
  ClientSite_S_First = $40190;

  { Undo is not available }
  InPlace_E_NotUndoable = $800401A0;

  { Space for tools is not available }
  InPlace_E_NoToolSpace = $800401A1;

  InPlace_E_First = $800401A0;
  InPlace_E_Last  = $800401AF;
  InPlace_S_First = $401A0;
  InPlace_S_Last  = $401AF;
  ENUM_E_First = $800401B0;
  ENUM_E_Last  = $800401BF;
  ENUM_S_First = $401B0;
  ENUM_S_Last  = $401BF;
  Convert10_E_First = $800401C0;
  Convert10_E_Last  = $800401CF;
  Convert10_S_First = $401C0;

  { OLESTREAM Get method failed }
  Convert10_E_OleStream_Get = $800401C0;

  { OLESTREAM Put method failed }
  Convert10_E_OleStream_Put = $800401C1;

  { Contents of the OLESTREAM not in correct format }
  Convert10_E_OleStream_FMT = $800401C2;

  { There was an error in a Windows GDI call while converting the bitmap to a DIB }
  Convert10_E_OleStream_Bitmap_to_DIB = $800401C3;

  { Contents of the IStorage not in correct format }
  Convert10_E_STg_FMT = $800401C4;

  { Contents of IStorage is missing one of the standard streams }
  Convert10_E_STg_no_Std_Stream = $800401C5;

  Convert10_E_STg_DIB_to_Bitmap = $800401C6;

  ClipBrd_E_First = $800401D0;
  ClipBrd_E_Last  = $800401DF;
  ClipBrd_S_First = $401D0;

  { OpenClipboard Failed }
  ClipBrd_E_cant_Open = $800401D0;

  { EmptyClipboard Failed }
  ClipBrd_E_cant_Empty = $800401D1;

  { SetClipboard Failed }
  ClipBrd_E_cant_Set = $800401D2;

  { Data on clipboard is invalid }
  ClipBrd_E_bad_Data = $800401D3;

  { CloseClipboard Failed }
  ClipBrd_E_cant_Close = $800401D4;

  MK_E_First = $800401E0;
  MK_E_Last  = $800401EF;
  MK_S_First = $401E0;

  { Moniker needs to be connected manually }
  MK_E_ConnectManually = $800401E0;

  { Operation exceeded deadline }
  MK_E_ExceededDeadline = $800401E1;

  { Moniker needs to be generic }
  MK_E_NeedGeneric = $800401E2;

  { Operation unavailable }
  MK_E_Unavailable = $800401E3;

  { Invalid syntax }
  MK_E_Syntax = $800401E4;

  { No object for moniker }
  MK_E_NoObject = $800401E5;

  { Bad extension for file }
  MK_E_InvalidExtension = $800401E6;

  { Intermediate operation failed }
  MK_E_IntermediateInterfaceNotSup = $800401E7;

  { Moniker is not bindable }
  MK_E_NotBindable = $800401E8;

  { Moniker is not bound }
  MK_E_NotBound = $800401E9;

  { Moniker cannot open file }
  MK_E_CantOpenFile = $800401EA;

  { User input required for operation to succeed }
  MK_E_MustBotherUser = $800401EB;

  { Moniker class has no inverse }
  MK_E_NoInverse = $800401EC;

  { Moniker does not refer to storage }
  MK_E_NoStorage = $800401ED;

  { No common prefix }
  MK_E_NoPrefix = $800401EE;

  { Moniker could not be enumerated }
  MK_E_Enumeration_Failed = $800401EF;

  CO_E_First = $800401F0;
  CO_E_Last  = $800401FF;
  CO_S_First = $401F0;

  { CoInitialize has not been called. }
  CO_E_NotInitialized = $800401F0;

  { CoInitialize has already been called. }
  CO_E_AlreadyInitialized = $800401F1;

  { Class of object cannot be determined }
  CO_E_CantDetermineClass = $800401F2;

  { Invalid class string }
  CO_E_ClassString = $800401F3;

  { Invalid interface string }
  CO_E_IIdString = $800401F4;

  { Application not found }
  CO_E_AppNotFound = $800401F5;

  { Application cannot be run more than once }
  CO_E_AppSingleUse = $800401F6;

  { Some error in application program }
  CO_E_ErrorInApp = $800401F7;

  { DLL for class not found }
  CO_E_DllNotFound = $800401F8;

  { Error in the DLL }
  CO_E_ErrorInDll = $800401F9;

  { Wrong OS or OS version for application }
  CO_E_WrongOsForApp = $800401FA;

  { Object is not registered }
  CO_E_OjbNotReg = $800401FB;

  { Object is already registered }
  CO_E_ObjIsReg = $800401FC;

  { Object is not connected to server }
  CO_E_ObjNotConnected = $800401FD;

  { Application was launched but it didn't register a class factory }
  CO_E_AppDidntReg = $800401FE;

  { Object has been released }
  CO_E_Released = $800401FF;

  { Use the registry database to provide the requested information }
  OLE_S_UseReg = $40000;

  { Success, but static }
  OLE_S_Static = $40001;

  { Macintosh clipboard format }
  OLE_S_Mac_ClipFormat = $40002;

  { Successful drop took place }
  DragDrop_S_Drio = $40100;

  { Drag-drop operation canceled }
  DragDrop_S_Cancel = $40101;

  { Use the default cursor }
  DragDrop_S_UseDefaultCursors = $40102;

  { Data has same FORMATETC }
  DATA_S_SameFormatEtc = $40130;

  { View is already frozen }
  VIEW_S_Already_Frozen = $40140;

  { FORMATETC not supported }
  CACHE_S_FormatEtc_NotSupported = $40170;

  { Same cache }
  CACHE_S_SameCache = $40171;

  { Some cache(s) not updated }
  CACHE_S_SomeCaches_NotUpdated = $40172;

  { Invalid verb for OLE object }
  OleObj_S_InvalidVerb = $40180;

  { Verb number is valid but verb cannot be done now }
  OleObj_S_Cannot_DoVerb_NoW = $40181;

  { Invalid window handle passed }
  OleObj_S_InvalidHWnd = $40182;

  { Message is too long; some of it had to be truncated before displaying }
  Inplace_S_Truncated = $401A0;

  { Unable to convert OLESTREAM to IStorage }
  Convert10_S_no_Presentation = $401C0;

  { Moniker reduced to itself }
  MK_S_Reduced_to_Self = $401E2;

  { Common prefix is this moniker }
  MK_S_Me = $401E4;

  { Common prefix is input moniker }
  MK_S_Him = $401E5;

  { Common prefix is both monikers }
  MK_S_Us = $401E6;

  { Moniker is already registered in running object table }
  MK_S_MonikerAlreadyRegistered = $401E7;


  { FACILITY_WINDOWS }
  { Codes $0-$01ff are reserved for the OLE group of}

  { Attempt to create a class object failed }
  CO_E_Class_Create_Failed = $80080001;

  { OLE service could not bind object }
  CO_E_SCM_Error = $80080002;

  { RPC communication failed with OLE service }
  CO_E_SCM_RPC_Failure = $80080003;

  { Bad path to object }
  CO_E_Bad_Path = $80080004;

  { Server execution failed }
  CO_E_Server_Exec_Failure = $80080005;

  { OLE service could not communicate with the object server }
  CO_E_ObjSrv_RPC_Failure = $80080006;

  { Moniker path could not be normalized }
  MK_E_NO_Normalized = $80080007;

  { Object server is stopping when OLE service contacts it }
  CO_E_Server_Stopping = $80080008;

  { An invalid root block pointer was specified }
  Mem_E_Invalid_Root = $80080009;

  { An allocation chain contained an invalid link pointer }
  Mem_E_Invalid_Link = $80080010;

  { The requested allocation size was too large }
  MEM_E_Invalid_Size = $80080011;

  { Not all the requested interfaces were available }
  CO_S_NotAllInterfaces = $00080012;


  { FACILITY_DISPATCH }

  { Unknown interface. }
  Disp_E_UnknownInterface = $80020001;

  { Member not found. }
  Disp_E_MemberNotFound = $80020003;

  { Parameter not found. }
  Disp_E_ParamNotFound = $80020004;

  { Type mismatch. }
  Disp_E_TypeMismatch = $80020005;

  { Unknown name. }
  Disp_E_UnknownName = $80020006;

  { No named arguments. }
  Disp_E_NonamedArgs = $80020007;

  { Bad variable type. }
  Disp_E_BadVarType = $80020008;

  { Exception occurred. }
  Disp_E_Exception = $80020009;

  { Out of present range. }
  Disp_E_Overflow = $8002000A;

  { Invalid index. }
  Disp_E_BadIndex = $8002000B;

  { Unknown language. }
  Disp_E_UnknownLCId = $8002000C;

  { Memory is locked. }
  Disp_E_ArrayIsLocked = $8002000D;

  { Invalid number of parameters. }
  Disp_E_BadParamCount = $8002000E;

  { Parameter not optional. }
  Disp_E_ParamNotOptional = $8002000F;

  { Invalid callee. }
  Disp_E_BadCallee = $80020010;

  { Does not support a collection. }
  Disp_E_NotACollection = $80020011;

  { Buffer too small. }
  Type_E_BufferTooSmall = $80028016;

  { Old format or invalid type library. }
  Type_E_InvDataRead = $80028018;

  { Old format or invalid type library. }
  Type_E_UnsupFormat = $80028019;

  { Error accessing the OLE registry. }
  Type_E_RegistryAccess = $8002801C;

  { Library not registered. }
  Type_E_LibNotRegistered = $8002801D;

  { Bound to unknown type. }
  Type_E_UndefinedType = $80028027;

  { Qualified name disallowed. }
  Type_E_QualifiedNameDisallowed = $80028028;

  { Invalid forward reference, or reference to uncompiled type. }
  Type_E_InvalidState = $80028029;

  { Type mismatch. }
  Type_E_WrongTypeKind = $8002802A;

  { Element not found. }
  Type_E_ElementNotFound = $8002802B;

  { Ambiguous name. }
  Type_E_AmbiguousName = $8002802C;

  { Name already exists in the library. }
  Type_E_NameConflict = $8002802D;

  { Unknown LCID. }
  Type_E_UnknownLCID = $8002802E;

  { Function not defined in specified DLL. }
  Type_E_DllFunctionNotFound = $8002802F;

  { Wrong module kind for the operation. }
  Type_E_BadModuleKind = $800288BD;

  { Size may not exceed 64K. }
  Type_E_SizeTooBig = $800288C5;

  { Duplicate ID in inheritance hierarchy. }
  Type_E_DuplicateId = $800288C6;

  { Incorrect inheritance depth in standard OLE hmember. }
  Type_E_InvalidId = $800288CF;

  { Type mismatch. }
  Type_E_TypeMismatch = $80028CA0;

  { Invalid number of arguments. }
  Type_E_OutOfBounds = $80028CA1;

  { I/O Error. }
  Type_E_IoError = $80028CA2;

  { Error creating unique tmp file. }
  Type_E_CantCreateTmpFile = $80028CA3;

  { Error loading type library/DLL. }
  Type_E_CantLoadLibrary = $80029C4A;

  { Inconsistent property functions. }
  Type_E_InconsistentPropFuncs = $80029C83;

  { Circular dependency between types/modules. }
  Type_E_CircularType = $80029C84;


  { FACILITY_STORAGE }

  { Unable to perform requested operation. }
  STG_E_InvalidFunction = $80030001;

  { %l could not be found. }
  STG_E_FileNotFound = $80030002;

  { The path %l could not be found. }
  STG_E_PathNotFound = $80030003;

  { There are insufficient resources to open another file. }
  STG_E_TooManyOpenFiles = $80030004;

  { Access Denied. }
  STG_E_AccessDenied = $80030005;

  { Attempted an operation on an invalid object. }
  STG_E_InvalidHandle = $80030006;

  { There is insufficient memory available to complete operation. }
  STG_E_InsufficientMemory = $80030008;

  { Invalid pointer error. }
  STG_E_InvalidPointer = $80030009;

  { There are no more entries to return. }
  STG_E_NoMoreFiles = $80030012;

  { Disk is write-protected. }
  STG_E_DiskIsWriteProtected = $80030013;

  { An error occurred during a seek operation. }
  STG_E_SeekError = $80030019;

  { A disk error occurred during a write operation. }
  STG_E_WriteFault = $8003001D;

  { A disk error occurred during a read operation. }
  STG_E_ReadFault = $8003001E;

  { A share violation has occurred. }
  STG_E_ShareViolation = $80030020;

  { A lock violation has occurred. }
  STG_E_LockViolation = $80030021;

  { %l already exists. }
  STG_E_FileAlreadyExists = $80030050;

  { Invalid parameter error. }
  STG_E_InvalidParameter = $80030057;

  { There is insufficient disk space to complete operation. }
  STG_E_MediumFull = $80030070;

  { Illegal write of non-simple property to simple property set. }
  STG_E_PropSetMismatched = $800300F0;

  { An API call exited abnormally. }
  STG_E_AbnormalApiExit = $800300FA;

  { The file %l is not a valid compound file. }
  STG_E_InvalidHeader = $800300FB;

  { The name %l is not valid. }
  STG_E_InvalidName = $800300FC;

  { An unexpected error occurred. }
  STG_E_Unknown = $800300FD;

  { That function is not implemented. }
  STG_E_UnimplementedFunction = $800300FE;

  { Invalid flag error. }
  STG_E_InvalidFlag = $800300FF;

  { Attempted to use an object that is busy. }
  STG_E_InUse = $80030100;

  { The storage has been changed since the last commit. }
  STG_E_NotCurrent = $80030101;

  { Attempted to use an object that has ceased to exist. }
  STG_E_Reverted = $80030102;

  { Can't save. }
  STG_E_CantSave = $80030103;

  { The compound file %l was produced with an incompatible version of storage. }
  STG_E_OldFormat = $80030104;

  { The compound file %l was produced with a newer version of storage. }
  STG_E_OldDll = $80030105;

  { Share.exe or equivalent is required for operation. }
  STG_E_ShareRequired = $80030106;

  { Illegal operation called on non-file based storage. }
  STG_E_NotFileBasedStorage = $80030107;

  { Illegal operation called on object with extant marshallings. }
  STG_E_ExtantMarshallings = $80030108;

  { The docfile has been corrupted. }
  STG_E_DocFileCorrupt = $80030109;

  { OLE32.DLL has been loaded at the wrong address. }
  STG_E_BadBaseAddress = $80030110;

  { The file download was aborted abnormally.  The file is incomplete. }
  STG_E_Incomplete = $80030201;

  { The file download has been terminated. }
  STG_E_Terminated = $80030202;

  { The underlying file was converted to compound file format. }
  STG_S_Converted = $00030200;

  { The storage operation should block until more data is available. }
  STG_S_Block = $00030201;

  { The storage operation should retry immediately. }
  STG_S_RetryNow = $00030202;

  { The notified event sink will not influence the storage operation. }
  STG_S_Monitoring = $00030203;


  { FACILITY_RPC }

  { Call was rejected by callee. }
  RPC_E_Call_Rejected = $80010001;

  { Call was canceled by the message filter. }
  RPC_E_Call_Canceled = $80010002;

  { The caller is dispatching an intertask SendMessage call and }
  { cannot call out via PostMessage. }
  RPC_E_CantPost_InSendCall = $80010003;

  { The caller is dispatching an asynchronous call and cannot }
  { make an outgoing call on behalf of this call. }
  RPC_E_CantCallOut_InAsyncCall = $80010004;

  { It is illegal to call out while inside message filter. }
  RPC_E_CantCallOut_InExternalCall = $80010005;

  { The connection terminated or is in a bogus state }
  { and cannot be used any more. Other connections }
  { are still valid. }
  RPC_E_Connection_Terminated = $80010006;

  { The callee (server [not server application]) is not available }
  { and disappeared; all connections are invalid.  The call may }
  { have executed. }
  RPC_E_Server_Died = $80010007;

  { The caller (client) disappeared while the callee (server) was }
  { processing a call. }
  RPC_E_Client_Died = $80010008;

  { The data packet with the marshalled parameter data is incorrect. }
  RPC_E_Invalid_DataPacket = $80010009;

  { The call was not transmitted properly; the message queue }
  { was full and was not emptied after yielding. }
  RPC_E_CantTransmit_Call = $8001000A;

  { The client (caller) cannot marshall the parameter data - low memory, etc. }
  RPC_E_Client_CantMarshal_Data = $8001000B;

  { The client (caller) cannot unmarshall the return data - low memory, etc. }
  RPC_E_Client_CantUnmarshal_Data = $8001000C;

  { The server (callee) cannot marshall the return data - low memory, etc. }
  RPC_E_Server_CantMarshal_Data = $8001000D;

  { The server (callee) cannot unmarshall the parameter data - low memory, etc. }
  RPC_E_Server_CantUnmarshal_Data = $8001000E;

  { Received data is invalid; could be server or client data. }
  RPC_E_Invalid_Data = $8001000F;

  { A particular parameter is invalid and cannot be (un)marshalled. }
  RPC_E_Invalid_Parameter = $80010010;

  { There is no second outgoing call on same channel in DDE conversation. }
  RPC_E_CantCallOut_Again = $80010011;

  { The callee (server [not server application]) is not available }
  { and disappeared; all connections are invalid.  The call did not execute. }
  RPC_E_Server_Died_DNE = $80010012;

  { System call failed. }
  RPC_E_Sys_Call_Failed = $80010100;

  { Could not allocate some required resource (memory, events, ...) }
  RPC_E_Out_Of_Resources = $80010101;

  { Attempted to make calls on more than one thread in single threaded mode. }
  RPC_E_Attempted_MultiThread = $80010102;

  { The requested interface is not registered on the server object. }
  RPC_E_Not_Registered = $80010103;

  { RPC could not call the server or could not return the results of calling the server. }
  RPC_E_Fault = $80010104;

  { The server threw an exception. }
  RPC_E_ServerFault = $80010105;

  { Cannot change thread mode after it is set. }
  RPC_E_Changed_Mode = $80010106;

  { The method called does not exist on the server. }
  RPC_E_InvalidMethod = $80010107;

  { The object invoked has disconnected from its clients. }
  RPC_E_Disconnected = $80010108;

  { The object invoked chose not to process the call now.  Try again later. }
  RPC_E_Retry = $80010109;

  { The message filter indicated that the application is busy. }
  RPC_E_ServerCall_RetryLater = $8001010A;

  { The message filter rejected the call. }
  RPC_E_ServerCall_Rejected = $8001010B;

  { A call control interfaces was called with invalid data. }
  RPC_E_Invalid_CallData = $8001010C;

  { An outgoing call cannot be made since the application is dispatching an input-synchronous call. }
  RPC_E_CantCallOut_InInputSyncCal = $8001010D;

  { The application called an interface that was marshalled for a different thread. }
  RPC_E_Wrong_Thread = $8001010E;

  { CoInitialize has not been called on the current thread. }
  RPC_E_Thread_Not_Init = $8001010F;

  { The version of OLE on the client and server machines does not match. }
  RPC_E_Version_Mismatch = $80010110;

  { OLE received a packet with an invalid header. }
  RPC_E_Invalid_Header = $80010111;

  { OLE received a packet with an invalid extension. }
  RPC_E_Invalid_Extension = $80010112;

  { The requested object or interface does not exist. }
  RPC_E_Invalid_IPID = $80010113;

  { The requested object does not exist. }
  RPC_E_Invalid_Object = $80010114;

  { OLE has sent a request and is waiting for a reply. }
  RPC_S_CallPending = $80010115;

  { OLE is waiting before retrying a request. }
  RPC_S_WaitOnTimer = $80010116;

  { Call context cannot be accessed after call completed. }
  RPC_E_Call_Complete = $80010117;

  { Impersonate on unsecure calls is not supported. }
  RPC_E_Unsecure_Call = $80010118;

  { Security must be initialized before any interfaces are marshalled or }
  RPC_E_Too_Late = $80010119;

  { No security packages are installed on this machine or the user is not logged }
  RPC_E_No_Good_Security_Packages = $8001011A;

  { Access is denied. }
  RPC_E_Access_Denied = $8001011B;

  { Remote calls are not allowed for this process. }
  RPC_E_Remote_Disabled = $8001011C;

  { The marshaled interface data packet (OBJREF) has an invalid or unknown format. }
  RPC_E_Invalid_ObjRef = $8001011D;

  { An internal error occurred. }
  RPC_E_Unexpected = $8001FFFF;


{ FACILITY_SSPI }

  { Bad UID. }
  NTE_Bad_UID = $80090001;

  { Bad Hash. }
  NTE_Bad_Hash = $80090002;

  { Bad Key. }
  NTE_Bad_Key = $80090003;

  { Bad Length. }
  NTE_Bad_Len = $80090004;

  { Bad Data. }
  NTE_Bad_Data = $80090005;

  { Invalid Signature. }
  NTE_Bad_Signature = $80090006;

  { Bad Version of provider. }
  NTE_Bad_Ver = $80090007;

  { Invalid algorithm specified. }
  NTE_Bad_AlgId = $80090008;

  { Invalid flags specified. }
  NTE_Bad_Flags = $80090009;

  { Invalid type specified. }
  NTE_Bad_Type = $8009000A;

  { Key not valid for use in specified state. }
  NTE_Bad_Key_State = $8009000B;

  { Hash not valid for use in specified state. }
  NTE_Bad_Hash_State = $8009000C;

  { Key does not exist. }
  NTE_No_Key = $8009000D;

  { Insufficient memory available for the operation. }
  NTE_No_Memory = $8009000E;

  { Object already exists. }
  NTE_Exists = $8009000F;

  { Access denied. }
  NTE_Perm = $80090010;

  { Object was not found. }
  NTE_Not_Found = $80090011;

  { Data already encrypted. }
  NTE_Double_Encrypt = $80090012;

  { Invalid provider specified. }
  NTE_Bad_Provider = $80090013;

  { Invalid provider type specified. }
  NTE_Bad_Prov_Type = $80090014;

  { Provider's public key is invalid. }
  NTE_Bad_Public_Key = $80090015;

  { Keyset does not exist }
  NTE_Bad_KeySet = $80090016;

  { Provider type not defined. }
  NTE_Prov_Type_Not_Def = $80090017;

  { Provider type as registered is invalid. }
  NTE_Prov_Type_Entry_Bad = $80090018;

  { The keyset is not defined. }
  NTE_KeySet_Not_Def = $80090019;

  { Keyset as registered is invalid. }
  NTE_KeySet_Entry_Bad = $8009001A;

  { Provider type does not match registered value. }
  NTE_Prov_Type_no_Match = $8009001B;

  { The digital signature file is corrupt. }
  NTE_Signature_File_Bad = $8009001C;

  { Provider DLL failed to initialize correctly. }
  NTE_Provider_DLL_Fail = $8009001D;

  { Provider DLL could not be found. }
  NTE_Prov_DLL_not_Found = $8009001E;

  { The Keyset parameter is invalid. }
  NTE_Bad_KeySet_Param = $8009001F;

  { An internal error occurred. }
  NTE_Fail = $80090020;

  { A base error occurred. }
  NTE_Sys_Err = $80090021;

  NTE_Op_Ok = 0;

{ FACILITY_CERT }

  { The specified trust provider is not known on this system. }
  Trust_E_Provider_Unknown = $800B0001;

  { The trust verification action specified is not supported by the specified trust provider. }
  Trust_E_Action_Unknown = $800B0002;

  { The form specified for the subject is not one supported or known by the specified trust provider. }
  Trust_E_Subject_Form_Unknown = $800B0003;

  { The subject is not trusted for the specified action. }
  Trust_E_Subject_not_Trusted = $800B0004;

  { Error due to problem in ASN.1 encoding process. }
  DigSig_E_Encode = $800B0005;

  { Error due to problem in ASN.1 decoding process. }
  DigSig_E_Decode = $800B0006;

  { Reading / writing Extensions where Attributes are appropriate, and visa versa. }
  DigSig_E_Extensibility = $800B0007;

  { Unspecified cryptographic failure. }
  DigSig_E_Crypto = $800B0008;

  { The size of the data could not be determined. }
  Persist_E_SizeDefinite = $800B0009;

  { The size of the indefinite-sized data could not be determined. }
  Persist_E_SizeIndefinite = $800B000A;

  { This object does not read and write self-sizing data. }
  Persist_E_NotSelfSizing = $800B000B;

  { No signature was present in the subject. }
  Trust_E_NoSignature = $800B0100;

  { A required certificate is not within its validity period. }
  Cert_E_Expired = $800B0101;

  { The validity periods of the certification chain do not nest correctly. }
  Cert_E_ValidiyPeriodNesting = $800B0102;

  { A certificate that can only be used as an end-entity is being used as a CA or visa versa. }
  Cert_E_Role = $800B0103;

  { A path length constraint in the certification chain has been violated. }
  Cert_E_PathLenConst = $800B0104;

  { An extension of unknown type that is labeled 'critical' is present in a certificate. }
  Cert_E_Critical = $800B0105;

  { A certificate is being used for a purpose other than that for which it is permitted. }
  Cert_E_Purpose = $800B0106;

  { A parent of a given certificate in fact did not issue that child certificate. }
  Cert_E_IssuerChaining = $800B0107;

  { A certificate is missing or has an empty value for an important field, such as a subject or issuer name. }
  Cert_E_Malformed = $800B0108;

  { A certification chain processed correctly, but terminated in a root certificate which isn't trusted by the trust provider. }
  Cert_E_UntrustedRoot = $800B0109;

  { A chain of certs didn't chain as they should in a certain application of chaining. }
  Cert_E_Chaining = $800B010A;

{ End WINERROR.H }


  { Abnormal termination codes }

  TC_Normal = 0;
  TC_HardErr = 1;
  TC_GP_Trap = 2;
  TC_Signal = 3;

  { Power Management APIs }
CONST
  AC_Line_Offline = 0;
  AC_Line_Online = 1;
  AC_Line_Backup_Power = 2;
  AC_Line_Unknown = 255;

  Battery_Flag_High = 1;
  Battery_Flag_Low = 2;
  Battery_Flag_Critical = 4;
  Battery_Flag_Charging = 8;
  Battery_Flag_no_Battery = $80;
  Battery_Flag_Unknown = 255;
  Battery_Percentage_Unknown = 255;
  Battery_Life_Unknown = $FFFFFFFF;

TYPE
  PSystemPowerStatus = ^TSystemPowerStatus;
  TSystemPowerStatus = {$ifndef __GPC__}PACKED{$endif} RECORD
    ACLineStatus : Byte;
    BatteryFlag : Byte;
    BatteryLifePercent : Byte;
    Reserved1 : Byte;
    BatteryLifeTime : DWord;
    BatteryFullLifeTime : DWord;
  END;

{ Win Certificate API and Structures }

{ Structures }

TYPE
  PWinCertificate = ^TWinCertificate;
  TWinCertificate = {$ifndef __GPC__}PACKED{$endif} RECORD
    dwLength : DWord;
    wRevision : Word;
    wCertificateType : Word;         { WIN_CERT_TYPE_xxx }
    bCertificate : {$ifndef __GPC__}PACKED{$endif} ARRAY [0..0] OF Byte;
  END;

{ Currently, the only defined certificate revision is WIN_CERT_REVISION_1_0 }

CONST
  WIN_CERT_REVISION_1_0 = $0100;

{ Possible certificate types are specified by the following values }

  Win_Cert_Type_X509 = $0001;                        { bCertificate contains an X.509 Certificate }
  Win_Cert_Type_PKCS_Signed_Data = $0002;            { bCertificate contains a PKCS SignedData structure }
  Win_Cert_Type_Reserved_1 = $0003;                  { Reserved }

  { Pel Array }
TYPE
  PPelArray = ^TPelArray;
  TPelArray = RECORD
    paXCount : Longint;
    paYCount : Longint;
    paXExt : Longint;
    paYExt : Longint;
    paRGBs : Byte;
  END;

  PPattern = ^TPattern;
  TPattern = TLogBrush;

TYPE
  PMaxLogPalette = ^TMaxLogPalette;
  TMaxLogPalette = {$ifndef __GPC__}PACKED{$endif} RECORD
    palVersion : Word;
    palNumEntries : Word;
    palPalEntry : ARRAY [Byte] OF TPaletteEntry;
  END;

{+++++++++++++++++++++++++++++++++++++++++++++++++++}
TYPE
  PGCPResults = ^TGCPResults;
  TGCPResults =  RECORD
    lStructSize : DWord;
    lpOutString : PChar;
    lpOrder : PUINT;
    lpDx : PINT;
    lpCaretPos : PINT;
    lpClass : PChar;
    lpGlyphs : PUINT;
    nGlyphs : UInt;
    nMaxFit : Integer;
  END;


TYPE
  TFNOldFontEnumProc = TFarProc;


{ define types of pointers to ExtDeviceMode() and DeviceCapabilities()
  functions for Win 3.1 compatibility }

TYPE
  TFNDevCaps = FUNCTION ( DeviceName, Port : LPSTR;
    Index : UInt; Output : LPSTR; VAR DevMode : TDeviceMode ) : DWord;

{ new GDI }
  PEMRExtCreateFontIndirect = ^TEMRExtCreateFontIndirect;
  TEMRExtCreateFontIndirect = RECORD
    emr : TEMR;
    ihFont : DWord;     { Font handle index}
    elfw : TExtLogFont;
  END;

  PEMRGLSRecord = ^TEMRGLSRecord;
  TEMRGLSRecord =  RECORD
    emr : TEMR;
    cbData : DWord;              { Size of data in bytes }
    Data :  ARRAY [0..0] OF Byte;
  END;

  PEMRGLSBoundedRecord = ^TEMRGLSBoundedRecord;
  TEMRGLSBoundedRecord =  RECORD
    emr : TEMR;
    rclBounds : TRect;           { Bounds in recording coordinates }
    cbData : DWord;              { Size of data in bytes }
    Data :  ARRAY [0..0] OF Byte;
  END;

  PEMRPixelFormat = ^TEMRPixelFormat;
  TEMRPixelFormat =  RECORD
    emr : TEMR;
    pfd : TPixelFormatDescriptor;
  END;

{ TLayerPlaneDescriptor flags }
CONST
  LPD_DoubleBuffer = $00000001;
  LPD_Stereo = $00000002;
  LPD_Support_GDI = $00000010;
  LPD_Support_OpenGL = $00000020;
  LPD_Share_Depth = $00000040;
  LPD_Share_Stencil = $00000080;
  LPD_Share_Accum = $00000100;
  LPD_Swap_Exchange = $00000200;
  LPD_Swap_Copy = $00000400;
  LPD_Transparent = $00001000;

  LPD_TYPE_RGBA = 0;
  LPD_TYPE_COLORINDEX = 1;

{ wglSwapLayerBuffers flags }
  WGL_Swap_Main_Plane = $00000001;
  WGL_Swap_Overlay1 = $00000002;
  WGL_Swap_Overlay2 = $00000004;
  WGL_Swap_Overlay3 = $00000008;
  WGL_Swap_Overlay4 = $00000010;
  WGL_Swap_Overlay5 = $00000020;
  WGL_Swap_Overlay6 = $00000040;
  WGL_Swap_Overlay7 = $00000080;
  WGL_Swap_Overlay8 = $00000100;
  WGL_Swap_Overlay9 = $00000200;
  WGL_Swap_Overlay10 = $00000400;
  WGL_Swap_Overlay11 = $00000800;
  WGL_Swap_Overlay12 = $00001000;
  WGL_Swap_Overlay13 = $00002000;
  WGL_Swap_Overlay14 = $00004000;
  WGL_Swap_Overlay15 = $00008000;
  WGL_Swap_Underlay1 = $00010000;
  WGL_Swap_Underlay2 = $00020000;
  WGL_Swap_Underlay3 = $00040000;
  WGL_Swap_Underlay4 = $00080000;
  WGL_Swap_Underlay5 = $00100000;
  WGL_Swap_Underlay6 = $00200000;
  WGL_Swap_Underlay7 = $00400000;
  WGL_Swap_Underlay8 = $00800000;
  WGL_Swap_Underlay9 = $01000000;
  WGL_Swap_Underlay10 = $02000000;
  WGL_Swap_Underlay11 = $04000000;
  WGL_Swap_Underlay12 = $08000000;
  WGL_Swap_Underlay13 = $10000000;
  WGL_Swap_Underlay14 = $20000000;
  WGL_Swap_Underlay15 = $40000000;



{ Translated from WINUSER.H }

TYPE
  PMENUTEMPLATE = Pointer;

  TFNGrayStringProc = TFarProc;
  TFNSendAsyncProc = TFarProc;
  TFNDrawStateProc = TFarProc;

TYPE
  TFNEditWordBreakProc = TFarProc;
  TFNNameEnumProc = TFarProc;
  TFNWinStaEnumProc = TFNNameEnumProc;
  TFNDeskTopEnumProc = TFNNameEnumProc;

TYPE
  { HCBT_CREATEWND parameters pointed to by lParam }
  PCBTCreateWnd = ^TCBTCreateWnd;
  TCBTCreateWnd =  RECORD
    lpcs : PCreateStruct;
    hwndInsertAfter : hWnd;
  END;

  { Structure used by WH_Hardware }
  PHardwareHookStruct = ^THardwareHookStruct;
  THardwareHookStruct =  RECORD
    hWnd : hWnd;
    message : UInt;
    wParam : wParam32;
    lParam : lParam32;
  END;

TYPE
  PMDINextMenu = ^TMDINextMenu;
  TMDINextMenu =  RECORD
    hmenuIn : hMenu;
    hmenuNext : hMenu;
    hwndNext : hWnd;
  END;


CONST
  IDAni_Caption = 3;

TYPE
  PBroadcastSysMsg = ^TBroadcastSysMsg;
  TBroadcastSysMsg =  RECORD
    uiMessage : UInt;
    wParam : wParam32;
    lParam : lParam32;
  END;

TYPE
  PKeyboardState = ^TKeyboardState;
  TKeyboardState = ARRAY [0..255] OF Byte;

TYPE
  PDropStruct = ^TDropStruct;
  TDropStruct =  RECORD
    hwndSource : hWnd;
    hwndSink : hWnd;
    wFmt : DWord;
    dwData : DWord;
    ptDrop : TPoint;
    dwControlData : DWord;
  END;

TYPE
  TPRMsgBoxCallback = PROCEDURE ( VAR lpHelpInfo : THelpInfo );

TYPE
  HelpPoly = DWord;

CONST
  { These are in winhelp.h in Win95. }
  IDH_No_Help = 28440;
  IDH_Missing_Context = 28441;      { Control doesn't have matching help context }
  IDH_Generic_Help_Button = 28442;  { Property sheet help button }
  IDH_Ok = 28443;
  IDH_Cancel = 28444;
  IDH_Help = 28445;

  Metrics_UseDefault = - 1;

CONST
  ARW_StartMask = 3;
  ARW_StartRight = 1;
  ARW_StartTop = 2;

  ARW_Valid = 15;

CONST
  { SOUNDSENTRY dwFlags field }
  SSF_Indicator = 4;

{ Sorting Flags.

     WORD Sort:    culturally correct sort
                   hyphen and apostrophe are special cased
                   example: "coop" and "co-op" will sort together in a list

                         co_op     <-------  underscore (symbol)
                         coat
                         comb
                         coop
                         co-op     <-------  hyphen (punctuation)
                         cork
                         went
                         were
                         we're     <-------  apostrophe (punctuation)


     STRING Sort:  hyphen and apostrophe will sort with all other symbols

                         co-op     <-------  hyphen (punctuation)
                         co_op     <-------  underscore (symbol)
                         coat
                         comb
                         coop
                         cork
                         we're     <-------  apostrophe (punctuation)
                         went
                         were
 }

{ Code Page Default Values. }
  CP_UTF7                  = 65000;         { UTF-7 translation }
  CP_UTF8                  = 65001;         { UTF-8 translation }

{ Country Codes. }

  Ctry_Default = 0;
  Ctry_Australia = 61; { Australia }
  Ctry_Austria = 43; { Austria }
  Ctry_Belgium = $20; { Belgium }
  Ctry_Brazil = 55; { Brazil }
  Ctry_Canada = 2; { Canada }
  Ctry_Denmark = 45; { Denmark }
  Ctry_Finland = 358; { Finland }
  Ctry_France = 33; { France }
  Ctry_Germany = 49; { Germany }
  Ctry_Iceland = 354; { Iceland }
  Ctry_Ireland = 353; { Ireland }
  Ctry_Italy = 39; { Italy }
  Ctry_Japan = 81; { Japan }
  Ctry_Mexico = 52; { Mexico }
  Ctry_Netherlands = 31; { Netherlands }
  Ctry_New_Zealand = $40; { New Zealand }
  Ctry_Norway = 47; { Norway }
  Ctry_Portugal = 351; { Portugal }
  Ctry_PrChina = 86; { PR China }
  Ctry_South_Korea = 82; { South Korea }
  Ctry_Spain = 34; { Spain }
  Ctry_Sweden = 46; { Sweden }
  Ctry_Switzerland = 41; { Switzerland }
  Ctry_Taiwan = 886; { Taiwan }
  Ctry_United_Kingdom = 44; { United Kingdom }
  Ctry_United_States = 1; { United States }

{ Calendar Enumeration Value. }

{ Calendar ID Values. }

  CAL_Gregorian = 1;           { Gregorian (localized) calendar }
  CAL_Gregorian_US = 2;        { Gregorian (U.S.) calendar }
  CAL_Japan = 3;               { Japanese Emperor Era calendar }
  CAL_Taiwan = 4;              { Republic of China Era calendar }
  CAL_Korea = 5;               { Korean Tangun Era calendar }
  CAL_Hijri = 6;               { Hijri (Arabic Lunar) calendar }
  CAL_Thai = 7;                { Thai calendar }
  CAL_Hebrew = 8;              { Hebrew calendar }


{ Enumeration function constants. }
Type
  TFNLocaleEnumProc = TFarProc;
  TFNCodepageEnumProc = TFarProc;
  TFNDateFmtEnumProc = TFarProc;
  TFNTimeFmtEnumProc = TFarProc;
  TFNCalInfoEnumProc = TFarProc;


{ Translated from WINCON.H }

{ This module contains the public data structures, data types,
    and procedures exported by the NT console subsystem. }

TYPE
  PKeyEventRecord = ^TKeyEventRecord;
  TKeyEventRecord =  PACKED RECORD
    bKeyDown : WinBool;
    wRepeatCount : Word;
    wVirtualKeyCode : Word;
    wVirtualScanCode : Word;
    CASE Integer OF
      0 : (
        UnicodeChar : WCHAR;
        dwControlKeyState : DWord );
      1 : (
        AsciiChar : CHAR );
  END;

TYPE
  PMouseEventRecord = ^TMouseEventRecord;
  TMouseEventRecord =  RECORD
    dwMousePosition : TCoord;
    dwButtonState : DWord;
    dwControlKeyState : DWord;
    dwEventFlags : DWord;
  END;

TYPE
  PWindowBufferSizeRecord = ^TWindowBufferSizeRecord;
  TWindowBufferSizeRecord =  RECORD
    dwSize : TCoord;
  END;

  PMenuEventRecord = ^TMenuEventRecord;
  TMenuEventRecord =  RECORD
    dwCommandId : UInt;
  END;

  PFocusEventRecord = ^TFocusEventRecord;
  TFocusEventRecord =  RECORD
    bSetFocus : Bool;
  END;

  PInputRecord = ^TInputRecord;
  TInputRecord = RECORD
    EventType : Word;
    Event : RECORD CASE Integer OF
      0 : ( KeyEvent : TKeyEventRecord );
      1 : ( MouseEvent : TMouseEventRecord );
      2 : ( WindowBufferSizeEvent : TWindowBufferSizeRecord );
      3 : ( MenuEvent : TMenuEventRecord );
      4 : ( FocusEvent : TFocusEventRecord );
    END;
  END;


TYPE
  PWin32Cell = ^TWin32Cell;
  TWin32Cell = RECORD
    Ch :     SmallWord;
    Attr :   SmallWord;
  END;

  TFNHandlerRoutine = TFarProc;

{ Translated from WINVER.H }

{ Version management functions, types, and definitions
  Include file for VER.DLL.  This library is designed to allow version
  stamping of Windows executable files and of special .VER files for
  DOS executable files. }

CONST
{ Symbols }
  VS_User_Defined = 100;

{ VS_Version.dwFileFlags }

  VS_FFI_Signature = $FEEF04BD;
  VS_FFI_StrucVersion = $10000;
  VS_FFI_FileFlagsMask = 63;

{ VS_Version.dwFileOS }

  VOS__Base = 0;
  VOS__Windows16 = 1;
  VOS__PM16 = 2;
  VOS__PM32 = 3;
  VOS__Windows32 = 4;

TYPE
  PVSFixedFileInfo = ^TVSFixedFileInfo;
  TVSFixedFileInfo =  RECORD
    dwSignature : DWord;        { e.g. $feef04bd }
    dwStrucVersion : DWord;     { e.g. $00000042 = "0.42" }
    dwFileVersionMS : DWord;    { e.g. $00030075 = "3.75" }
    dwFileVersionLS : DWord;    { e.g. $00000031 = "0.31" }
    dwProductVersionMS : DWord; { e.g. $00030010 = "3.10" }
    dwProductVersionLS : DWord; { e.g. $00000031 = "0.31" }
    dwFileFlagsMask : DWord;    { = $3F for version "0.42" }
    dwFileFlags : DWord;        { e.g. VFF_Debug | VFF_Prerelease }
    dwFileOS : DWord;           { e.g. VOS_Dos_Windows16 }
    dwFileType : DWord;         { e.g. VFT_Driver }
    dwFileSubtype : DWord;      { e.g. VFT2_Drv_Keyboard }
    dwFileDateMS : DWord;       { e.g. 0 }
    dwFileDateLS : DWord;       { e.g. 0 }
  END;

{ Translated from WINREG.H }

{ This module contains the function prototypes and constant, type and
   structure definitions for the Windows 32-Bit Registry API. }

CONST
  Provider_Keeps_Value_Length = 1;

TYPE
  PValContext = ^TValContext;
  TValContext =  RECORD
    valuelen : Integer;       { the total length of this value }
    value_context : Pointer;  { provider's context }
    val_buff_ptr : Pointer;   { where in the ouput buffer the value is }
  END;


TYPE
{ Provider supplied value/context.}
  PPValue = ^TPValue;
  TPValue =  RECORD
    pv_valuename : PChar;           { The value name pointer }
    pv_valuelen : Bool;
    pv_value_context : Pointer;
    pv_type : DWord;
  END;

  TFNQueryHandler = TFarProc;
  PFNQueryHandler = ^TFNQueryHandler;

  PProviderInfo = ^TProviderInfo;
  TProviderInfo =  RECORD
    pi_R0_1val : PFNQueryHandler;
    pi_R0_allvals : PFNQueryHandler;
    pi_R3_1val : PFNQueryHandler;
    pi_R3_allvals : PFNQueryHandler;
    pi_flags : DWord;              { capability flags (none defined yet). }
    pi_key_context : Pointer;
  END;
  TRegProvider = TProviderInfo;
  PProvider = PProviderInfo;
{ Default values for parameters that do not exist in the Win 3.1
  compatible APIs. }

{ Translated from WINNETWK.H }

CONST
{ Network types }

  WNNC_Net_MsNet              = $00010000;
  WNNC_Net_LanMan             = $00020000;
  WNNC_Net_Netware            = $00030000;
  WNNC_Net_Vines              = $00040000;
  WNNC_Net_10Net              = $00050000;
  WNNC_Net_Locus              = $00060000;
  WNNC_Net_Sun_PC_NFS         = $00070000;
  WNNC_Net_LanStep            = $00080000;
  WNNC_Net_9Tiles             = $00090000;
  WNNC_Net_Lantastic          = $000A0000;
  WNNC_Net_AS400              = $000B0000;
  WNNC_Net_FTP_NFS            = $000C0000;
  WNNC_Net_Pathworks          = $000D0000;
  WNNC_Net_LifeNet            = $000E0000;
  WNNC_Net_PowerLan           = $000F0000;
  WNNC_Net_BWNFS              = $00100000;
  WNNC_Net_Cogent             = $00110000;
  WNNC_Net_Farallon           = $00120000;
  WNNC_Net_AppleTalk          = $00130000;
  WNNC_Net_InterGraph         = $00140000;
  WNNC_Net_SymfoNet           = $00150000;
  WNNC_Net_ClearCase          = $00160000;

{ Network Resources. }

CONST
{ Network Connections. }
NetProperty_Persistent = 1;

CONST
  ConnDlg_RO_Path = 1;    { Resource path should be read-only     }
  ConnDlg_Conn_Point = 2; { Netware -style movable connection point enabled  }
  ConnDlg_use_MRU = 4;    { Use MRU combobox   }
  ConnDlg_Hide_Box = 8;   { Hide persistent connect checkbox   }

  { NOTE:  Set at most ONE of the below flags.  If neither flag is set,
           then the persistence is set to whatever the user chose during
           a previous connection }

  ConnDlg_Persist = $10;       { Force persistent connection  }
  ConnDlg_not_Persist = $20;   { Force connection NOT persistent  }

CONST
  Disc_Update_Profile = 1;
  Disc_no_Force = $40;

TYPE
  PUniversalNameInfo = ^TUniversalNameInfo;
  TUniversalNameInfo =  RECORD
    lpUniversalName : PChar;
  END;

  PRemoteNameInfo = ^TRemoteNameInfo;
  TRemoteNameInfo =  RECORD
    lpUniversalName : PChar;
    lpConnectionName : PChar;
    lpRemainingPath : PChar;
  END;

CONST
  WNFmt_MultiLine = 1;
  WNFmt_Abbreviated = 2;
  WNFmt_IneNum = $10;
  WNFmt_Connection = $20;

CONST
  NetInfo_DLL16 = 1;      { Provider running as 16 bit Winnet Driver  }
  NetInfo_DiskRed = 4;    { Provider requires disk redirections to connect  }
  NetInfo_PrinterRed = 8; { Provider requires printer redirections to connect  }


TYPE
{ User Profiles }
  TFNGetProfilePath = TFarProc;
  TFNReconcileProfile = TFarProc;


CONST
  RP_Logon = 1;    { if set, do for logon, else for logoff }
  RP_IniFile = 2;  { if set, reconcile .INI file, else reg. hive }

TYPE
{ Policies }

  TFNProcessPolicies = TFarProc;

CONST
  WnCon_ForNetCard = 1;
  WnCon_NotRouted = 2;
  WnCon_SlowLink = 4;
  WnCon_Dynamic = 8;

{ Translated from DDE.H }

CONST
  WM_DDE_First      = $03E0;
  WM_DDE_Initiate   = WM_DDE_First;
  WM_DDE_Terminate  = WM_DDE_First + 1;
  WM_DDE_Advise     = WM_DDE_First + 2;
  WM_DDE_Unadvise   = WM_DDE_First + 3;
  WM_DDE_Ack        = WM_DDE_First + 4;
  WM_DDE_Data       = WM_DDE_First + 5;
  WM_DDE_Request    = WM_DDE_First + 6;
  WM_DDE_Poke       = WM_DDE_First + 7;
  WM_DDE_Execute    = WM_DDE_First + 8;
  WM_DDE_Last       = WM_DDE_First + 8;

{ Constants used for a WM_DDE_Ack message sent in responce to a WM_DDE_Data
  WM_DDE_Request, WM_DDE_Poke, WM_DDE_Advise, or WM_DDE_Unadvise message.
  For example
    if lParam and dde_Ack <> 0 then ...
}

TYPE
  PDDEAck = ^TDDEAck;
  TDDEAck =  RECORD
(*
    unsigned bAppReturnCode:8,
             reserved:6,
             fBusy:1,
             fAck:1;
*)
    Flags : Word;
  END;

CONST
  dde_AppReturnCode = $00FF;
  dde_Busy          = $4000;
  dde_Ack           = $8000;

{ Record for the  WM_DDE_ADVISE Options parameter (LoWord(lParam)) }

TYPE
  PDDEAdvise = ^TDDEAdvise;
  TDDEAdvise =  RECORD
(*
    unsigned reserved:14,
             fDeferUpd:1,
             fAckReq:1;
*)
    Flags : Word;
    cfFormat : SmallInt;
  END;

CONST
  dde_DeferUpd     = $4000;
  dde_AckReq       = $8000;

{ Record for the hData parameter of a WM_DDE_DATA message (LoWord(lParam)).
  The actual size of this record depends on the size of the Value
  array. }

TYPE
  PDDEData = ^TDDEData;
  TDDEData =  RECORD
(*  unsigned unused:12,
             fResponse:1,
             fRelease:1,
             reserved:1,
             fAckReq:1;
*)
    Flags : Word;
    cfFormat : SmallInt;
    Value : ARRAY [0..0] OF Byte;
  END;

CONST
  dde_Response = $1000;
  dde_Release  = $2000;

{ Record for the hData parameter of the WM_DDE_POKE record (LoWord(lParam)).
  The actual size of this record depends on the size of the Value array. }

TYPE
  PDDEPoke = ^TDDEPoke;
  TDDEPoke =  RECORD
(*  unsigned unused:13,
             fRelease:1,
             fReserved:2;
*)
    Flags : Word;
    cfFormat : SmallInt;
    Value : ARRAY [0..0] OF Byte;
  END;


TYPE
// Generic window message RECORD
(*
  PMessage = ^TMessage;
  TMessage = RECORD
    Msg : Longint;
    CASE Integer OF
      0 : (
        WParam : Longint;
        LParam : Longint;
        Result : Longint );
      1 : (
        WParamLo : Word;
        WParamHi : Word;
        LParamLo : Word;
        LParamHi : Word;
        ResultLo : Word;
        ResultHi : Word );
  END;
*)
// Common message format records

  TWMNoParams = RECORD
    Msg : Longint;
    Unused : ARRAY [0..3] OF Word;
    Result : Longint;
  END;

  TWMKey = RECORD
    Msg : Longint;
    CharCode : Word;
    Unused : Word;
    KeyData : Longint;
    Result : Longint;
  END;

  PSmallPoint = ^TSmallPoint;
  TSmallPoint = RECORD
    x : SmallInt;
    y : SmallInt;
  END;


  TWMMouse = RECORD
    Msg : Longint;
    Keys : Longint;
    CASE Integer OF
      0 : (
        XPos : Smallint;
        YPos : Smallint );
      1 : (
        Pos : TSmallPoint;
        Result : Longint );
  END;

  TWMWindowPosMsg = RECORD
    Msg : Longint;
    Unused : Integer;
    WindowPos : PWindowPos;
    Result : Longint;
  END;

  TWMScroll = RECORD
    Msg : Longint;
    ScrollCode : Smallint; // sb_xxxx
    Pos : Smallint;
    ScrollBar : HWND;
    Result : Longint;
  END;

// Message records

  TWMActivate = RECORD
    Msg : Longint;
    Active : Word; // wa_Inactive, wa_Active, wa_ClickActive
    Minimized : WordBool;
    ActiveWindow : HWND;
    Result : Longint;
  END;

  TWMActivateApp = RECORD
    Msg : Longint;
    Active : Bool;
    ThreadId : Longint;
    Result : Longint;
  END;

  TWMAskCBFormatName = RECORD
    Msg : Longint;
    NameLen : Word;
    Unused : Word;
    FormatName : PChar;
    Result : Longint;
  END;

  TWMCancelMode = TWMNoParams;

  TWMChangeCBChain = RECORD
    Msg : Longint;
    Remove : HWND;
    Next : HWND;
    Result : Longint;
  END;

  TWMChar = TWMKey;

  TWMCharToItem = RECORD
    Msg : Longint;
    Key : Word;
    CaretPos : Word;
    ListBox : HWND;
    Result : Longint;
  END;

  TWMChildActivate = TWMNoParams;

  TWMChooseFont_GetLogFont = RECORD
    Msg : Longint;
    Unused : Longint;
    LogFont : PLogFont;
    Result : Longint;
  END;

  TWMClear = TWMNoParams;
  TWMClose = TWMNoParams;

  TWMCommand = RECORD
    Msg : Longint;
    ItemID : Word;
    NotifyCode : Word;
    Ctl : HWND;
    Result : Longint;
  END;

  TWMCompacting = RECORD
    Msg : Longint;
    CompactRatio : Longint;
    Unused : Longint;
    Result : Longint;
  END;

  TWMCompareItem = RECORD
    Msg : Longint;
    Ctl : HWnd;
    CompareItemStruct : PCompareItemStruct;
    Result : Longint;
  END;

  TWMCreate = RECORD
    Msg : Longint;
    Unused : Integer;
    CreateStruct : PCreateStruct;
    Result : Longint;
  END;

  TWMCtlColor = RECORD
    Msg : Longint;
    ChildDC : HDC;
    ChildWnd : HWND;
    Result : Longint;
  END;

  TWMCtlColorBtn = TWMCtlColor;
  TWMCtlColorDlg = TWMCtlColor;
  TWMCtlColorEdit = TWMCtlColor;
  TWMCtlColorListbox = TWMCtlColor;
  TWMCtlColorMsgbox = TWMCtlColor;
  TWMCtlColorScrollbar = TWMCtlColor;
  TWMCtlColorStatic = TWMCtlColor;

  TWMCut = TWMNoParams;

  TWMDDE_Advise = RECORD
    Msg : Longint;
    PostingApp : HWND;
    PackedVal : Longint;
    Result : Longint;
  END;

  TWMDDE_Data = RECORD
    Msg : Longint;
    PostingApp : HWND;
    PackedVal : Longint;
    Result : Longint;
  END;

  TWMDDE_Execute = RECORD
    Msg : Longint;
    PostingApp : HWND;
    Commands : THandle;
    Result : Longint;
  END;

  TWMDDE_Initiate = RECORD
    Msg : Longint;
    PostingApp : HWND;
    App : Word;
    Topic : Word;
    Result : Longint;
  END;

  TWMDDE_Poke = RECORD
    Msg : Longint;
    PostingApp : HWND;
    PackedVal : Longint;
    Result : Longint;
  END;

  TWMDDE_Request = RECORD
    Msg : Longint;
    PostingApp : HWND;
    Format : Word;
    Item : Word;
    Result : Longint;
  END;

  TWMDDE_Terminate = RECORD
    Msg : Longint;
    PostingApp : HWND;
    Unused : Longint;
    Result : Longint;
  END;

  TWMDDE_Unadvise = RECORD
    Msg : Longint;
    PostingApp : HWND;
    Format : Word;
    Item : Word;
    Result : Longint;
  END;

  TWMDeadChar = TWMChar;

  TWMDeleteItem = RECORD
    Msg : Longint;
    Ctl : HWND;
    DeleteItemStruct : PDeleteItemStruct;
    Result : Longint;
  END;

  TWMDestroy = TWMNoParams;
  TWMDestroyClipboard = TWMNoParams;

  TWMDevModeChange = RECORD
    Msg : Longint;
    Unused : Integer;
    Device : PChar;
    Result : Longint;
  END;

  TWMDrawClipboard = TWMNoParams;

  TWMDrawItem = RECORD
    Msg : Longint;
    Ctl : HWND;
    DrawItemStruct : PDrawItemStruct;
    Result : Longint;
  END;

  TWMDropFiles = RECORD
    Msg : Longint;
    Drop : THANDLE;
    Unused : Longint;
    Result : Longint;
  END;

  TWMEnable = RECORD
    Msg : Longint;
    Enabled : LongBool;
    Unused : Longint;
    Result : Longint;
  END;

  TWMEndSession = RECORD
    Msg : Longint;
    EndSession : LongBool;
    Unused : Longint;
    Result : Longint;
  END;

  TWMEnterIdle = RECORD
    Msg : Longint;
    Source : Longint; // Msgf_DialogBox, Msgf_Menu }
    IdleWnd : HWND;
    Result : Longint;
  END;

  TWMEnterMenuLoop = RECORD
    Msg : Longint;
    IsTrackPopupMenu : LongBool;
    Unused : Longint;
    Result : Longint;
  END;

  TWMExitMenuLoop = TWMEnterMenuLoop;

  TWMEraseBkgnd = RECORD
    Msg : Longint;
    DC : HDC;
    Unused : Longint;
    Result : Longint;
  END;

  TWMFontChange = TWMNoParams;
  TWMGetDlgCode = TWMNoParams;
  TWMGetFont = TWMNoParams;

  TWMGetIcon = RECORD
    Msg : Longint;
    BigIcon : Longbool;
    Unused : Longint;
    Result : Longint;
  END;

  TWMGetHotKey = TWMNoParams;

  TWMGetMinMaxInfo = RECORD
    Msg : Longint;
    Unused : Integer;
    MinMaxInfo : PMinMaxInfo;
    Result : Longint;
  END;

  TWMGetText = RECORD
    Msg : Longint;
    TextMax : Integer;
    Text : PChar;
    Result : Longint;
  END;

  TWMGetTextLength = TWMNoParams;

  TWMHotKey = RECORD
    Msg : Longint;
    HotKey : Longint;
    Unused : Longint;
    Result : Longint;
  END;

  TWMHScroll = TWMScroll;

  TWMHScrollClipboard = RECORD
    Msg : Longint;
    Viewer : HWND;
    ScrollCode : Word; {sb_Bottom, sb_EndScroll, sb_LineDown, sb_LineUp,
                       sb_PageDown, SB_PageUp, sb_ThumbPosition,
                       sb_ThumbTrack, sb_Top }
    Pos : Word;
    Result : Longint;
  END;

  TWMIconEraseBkgnd = TWMEraseBkgnd;

  TWMInitDialog = RECORD
    Msg : Longint;
    Focus : HWND;
    InitParam : Longint;
    Result : Longint;
  END;

  TWMInitMenu = RECORD
    Msg : Longint;
    Menu : HMENU;
    Unused : Longint;
    Result : Longint;
  END;

  TWMInitMenuPopup = RECORD
    Msg : Longint;
    MenuPopup : HMENU;
    Pos : Smallint;
    SystemMenu : WordBool;
    Result : Longint;
  END;

  TWMKeyDown = TWMKey;
  TWMKeyUp = TWMKey;

  TWMKillFocus = RECORD
    Msg : Longint;
    FocusedWnd : HWND;
    Unused : Longint;
    Result : Longint;
  END;

  TWMLButtonDblClk = TWMMouse;
  TWMLButtonDown   = TWMMouse;
  TWMLButtonUp     = TWMMouse;
  TWMMButtonDblClk = TWMMouse;
  TWMMButtonDown   = TWMMouse;
  TWMMButtonUp     = TWMMouse;

  TWMMDIActivate = RECORD
    Msg : Longint;
    CASE Integer OF
      0 : (
        ChildWnd : HWND );
      1 : (
        DeactiveWnd : HWND;
        ActiveWnd : HWND;
        Result : Longint );
  END;

  TWMMDICascade = RECORD
    Msg : Longint;
    Cascade : Longint; { 0, MdiTile_SkipDisabled }
    Unused : Longint;
    Result : Longint;
  END;

  TWMMDICreate = RECORD
    Msg : Longint;
    Unused : Integer;
    MDICreateStruct : PMDICreateStruct;
    Result : Longint;
  END;

  TWMMDIDestroy = RECORD
    Msg : Longint;
    Child : HWND;
    Unused : Longint;
    Result : Longint;
  END;

  TWMMDIGetActive = TWMNoParams;
  TWMMDIIconArrange = TWMNoParams;

  TWMMDIMaximize = RECORD
    Msg : Longint;
    Maximize : HWND;
    Unused : Longint;
    Result : Longint;
  END;

  TWMMDINext = RECORD
    Msg : Longint;
    Child : HWND;
    Next : Longint;
    Result : Longint;
  END;

  TWMMDIRefreshMenu = TWMNoParams;

  TWMMDIRestore = RECORD
    Msg : Longint;
    IDChild : HWND;
    Unused : Longint;
    Result : Longint;
  END;

  TWMMDISetMenu = RECORD
    Msg : Longint;
    MenuFrame : HMENU;
    MenuWindow : HMENU;
    Result : Longint;
  END;

  TWMMDITile = RECORD
    Msg : Longint;
    Tile : Longint; { MdiTile_Horizontal, MdiTile_SkipDisable,
                     MdiTile_Vertical }
    Unused : Longint;
    Result : Longint;
  END;

  TWMMeasureItem = RECORD
    Msg : Longint;
    IDCtl : HWnd;
    MeasureItemStruct : PMeasureItemStruct;
    Result : Longint;
  END;

  TWMMenuChar = RECORD
    Msg : Longint;
    User : Char;
    Unused : Byte;
    MenuFlag : Word; { mf_Popup, mf_SysMenu }
    Menu : HMENU;
    Result : Longint;
  END;

  TWMMenuSelect = RECORD
    Msg : Longint;
    IDItem : Word;
    MenuFlag : Word; { mf_Bitmap, mf_Checked, mf_Disabled, mf_Grayed,
                      mf_MouseSelect, mf_OwnerDraw, mf_Popup, mf_Separator,
                      mf_SysMenu }
    Menu : HMENU;
    Result : Longint;
  END;

  TWMMouseActivate = RECORD
    Msg : Longint;
    TopLevel : HWND;
    HitTestCode : Word;
    MouseMsg : Word;
    Result : Longint;
  END;

  TWMMouseMove = TWMMouse;

  TWMMove = RECORD
    Msg : Longint;
    Unused : Integer;
    CASE Integer OF
      0 : (
        XPos : Smallint;
        YPos : Smallint );
      1 : (
        Pos : TSmallPoint;
        Result : Longint );
  END;

  TWMNCActivate = RECORD
    Msg : Longint;
    Active : Bool;
    Unused : Longint;
    Result : Longint;
  END;

  TWMNCCreate = RECORD
    Msg : Longint;
    Unused : Integer;
    CreateStruct : PCreateStruct;
    Result : Longint;
  END;

  TWMNCDestroy = TWMNoParams;

  TWMNCHitTest = RECORD
    Msg : Longint;
    Unused : Longint;
    CASE Integer OF
      0 : (
        XPos : Smallint;
        YPos : Smallint );
      1 : (
        Pos : TSmallPoint;
        Result : Longint );
  END;

  TWMNCHitMessage = RECORD
    Msg : Longint;
    HitTest : Longint;
    XCursor : Smallint;
    YCursor : Smallint;
    Result : Longint;
  END;

  TWMNCLButtonDblClk = TWMNCHitMessage;
  TWMNCLButtonDown   = TWMNCHitMessage;
  TWMNCLButtonUp     = TWMNCHitMessage;
  TWMNCMButtonDblClk = TWMNCHitMessage;
  TWMNCMButtonDown   = TWMNCHitMessage;
  TWMNCMButtonUp     = TWMNCHitMessage;
  TWMNCMouseMove     = TWMNCHitMessage;

  TWMNCPaint = TWMNoParams;

  TWMNCRButtonDblClk = TWMNCHitMessage;
  TWMNCRButtonDown   = TWMNCHitMessage;
  TWMNCRButtonUp     = TWMNCHitMessage;

  TWMNextDlgCtl = RECORD
    Msg : Longint;
    CtlFocus : Longint;
    Handle : WordBool;
    Unused : Word;
    Result : Longint;
  END;

  TWMNotify = RECORD
    Msg : Cardinal;
    IDCtrl : Longint;
    NMHdr : PNMHdr;
    Result : Longint;
  END;

  TWMNotifyFormat = RECORD
    Msg : Longint;
    From : HWND;
    Command : Longint;
    Result : Longint;
  END;

  TWMPaint = RECORD
    Msg : Longint;
    DC : HDC;
    Unused : Longint;
    Result : Longint;
  END;

  TWMPaintClipboard = RECORD
    Msg : Longint;
    Viewer : HWND;
    PaintStruct : THandle;
    Result : Longint;
  END;

  TWMPaintIcon = TWMNoParams;

  TWMPaletteChanged = RECORD
    Msg : Longint;
    PalChg : HWND;
    Unused : Longint;
    Result : Longint;
  END;

  TWMPaletteIsChanging = RECORD
    Msg : Longint;
    Realize : HWND;
    Unused : Longint;
    Result : Longint;
  END;

  TWMParentNotify = RECORD
    Msg : Longint;
    CASE Event : Word OF
      wm_Create, wm_Destroy : (
        ChildID : Word;
        ChildWnd : HWnd );
      wm_LButtonDown, wm_MButtonDown, wm_RButtonDown : (
        Value : Word;
        XPos : Smallint;
        YPos : Smallint );
      0 : (
        Value1 : Word;
        Value2 : Longint;
        Result : Longint );
  END;

  TWMPaste = TWMNoParams;

  TWMPower = RECORD
    Msg : Longint;
    PowerEvt : Longint; { pwr_SuspendRequest, pwr_SuspendResume,
                         pwr_CriticalResume }
    Unused : Longint;
    Result : Longint;
  END;

  TWMQueryDragIcon = TWMNoParams;

  TWMQueryEndSession = RECORD
    Msg : Longint;
    Source : Longint;
    Unused : Longint;
    Result : Longint;
  END;

  TWMQueryNewPalette = TWMNoParams;
  TWMQueryOpen = TWMNoParams;
  TWMQueueSync = TWMNoParams;

  TWMQuit = RECORD
    Msg : Longint;
    ExitCode : Longint;
    Unused : Longint;
    Result : Longint;
  END;

  TWMRButtonDblClk = TWMMouse;
  TWMRButtonDown = TWMMouse;
  TWMRButtonUp = TWMMouse;

  TWMRenderAllFormats = TWMNoParams;

  TWMRenderFormat = RECORD
    Msg : Longint;
    Format : Longint;
    Unused : Longint;
    Result : Longint;
  END;

  TWMSetCursor = RECORD
    Msg : Longint;
    CursorWnd : HWND;
    HitTest : Word;
    MouseMsg : Word;
    Result : Longint;
  END;

  TWMSetFocus = RECORD
    Msg : Longint;
    FocusedWnd : HWND;
    Unused : Longint;
    Result : Longint;
  END;

  TWMSetFont = RECORD
    Msg : Longint;
    Font : HFONT;
    Redraw : WordBool;
    Unused : Word;
    Result : Longint;
  END;

  TWMSetHotKey = RECORD
    Msg : Longint;
    Key : Longint;
    Unused : Longint;
    Result : Longint;
  END;

  TWMSetIcon = RECORD
    Msg : Longint;
    BigIcon : Longbool;
    Icon : HICON;
    Result : Longint;
  END;

  TWMSetRedraw = RECORD
    Msg : Longint;
    Redraw : Longint;
    Unused : Longint;
    Result : Longint;
  END;

  TWMSetText = RECORD
    Msg : Longint;
    Unused : Longint;
    Text : PChar;
    Result : Longint;
  END;

  TWMShowWindow = RECORD
    Msg : Longint;
    Show : Bool;
    Status : Longint;
    Result : Longint;
  END;

  TWMSize = RECORD
    Msg : Longint;
    SizeType : Longint; { Size_Maximized, Size_Minimized, Size_Restored,
                         Size_MaxHide, Size_MaxShow }
    Width : Word;
    Height : Word;
    Result : Longint;
  END;

  TWMSizeClipboard = RECORD
    Msg : Longint;
    Viewer : HWND;
    RC : THandle;
    Result : Longint;
  END;

  TWMSpoolerStatus = RECORD
    Msg : Longint;
    JobStatus : Longint;
    JobsLeft : Word;
    Unused : Word;
    Result : Longint;
  END;

  TWMSysChar = TWMKey;
  TWMSysColorChange = TWMNoParams;

  TWMSysCommand = RECORD
    Msg : Longint;
    CASE CmdType : Longint OF
      sc_Hotkey : (
        ActivateWnd : HWND );
      sc_KeyMenu : (
        Key : Word );
      sc_Close, sc_HScroll, sc_Maximize, sc_Minimize, sc_MouseMenu, sc_Move,
      sc_NextWindow, sc_PrevWindow, sc_Restore, sc_ScreenSave, sc_Size,
      sc_TaskList, sc_VScroll : (
        XPos : Smallint;
        YPos : Smallint;
        Result : Longint );
  END;

  TWMSysDeadChar = RECORD
    Msg : Longint;
    CharCode : Word;
    Unused : Word;
    KeyData : Longint;
    Result : Longint;
  END;

  TWMSysKeyDown = TWMKey;
  TWMSysKeyUp = TWMKey;

  TWMSystemError = RECORD
    Msg : Longint;
    ErrSpec : Word;
    Unused : Longint;
    Result : Longint;
  END;

  TWMTimeChange = TWMNoParams;

  TWMTimer = RECORD
    Msg : Longint;
    TimerID : Longint;
    TimerProc : TFarProc;
    Result : Longint;
  END;

  TWMUndo = TWMNoParams;

  TWMVKeyToItem = TWMCharToItem;

  TWMVScroll = TWMScroll;

  TWMVScrollClipboard = RECORD
    Msg : Longint;
    Viewer : HWND;
    ScollCode : Word;
    ThumbPos : Word;
    Result : Longint;
  END;

  TWMWindowPosChanged = TWMWindowPosMsg;
  TWMWindowPosChanging = TWMWindowPosMsg;

  TWMWinIniChange = RECORD
    Msg : Longint;
    Unused : Integer;
    Section : PChar;
    Result : Longint;
  END;

  TWMDisplayChange = RECORD
    Msg : Longint;
    BitsPerPixel : Integer;
    Width : Word;
    Height : Word;
  END;

  TWMCopy = TWMNoParams;

  TWMCopyData = RECORD
    Msg : Longint;
    From : HWND;
    CopyDataStruct : PCopyDataStruct;
    Result : Longint;
  END;

  TWMDDE_Ack = RECORD
    Msg : Longint;
    PostingApp : HWND;
    CASE Word OF
      wm_DDE_Initiate : (
        App : Word;
        Topic : Word;
        Result : Longint );
      wm_DDE_Execute {and all others} : (
        PackedVal : Longint );
  END;

  TWMNCCalcSize = RECORD
    Msg : Longint;
    CalcValidRects : Bool;
    CalcSize_Params : PNCCalcSizeParams;
    Result : Longint;
  END;

  TWMStyleChange = RECORD
    Msg : Longint;
    StyleType : Longint;
    StyleStruct : PStyleStruct;
    Result : Longint;
  END;

  TWMStyleChanged = TWMStyleChange;
  TWMStyleChanging = TWMStyleChange;

TYPE
  TWMHelp = RECORD
    Msg : Longint;
    Unused : Integer;
    HelpInfo : PHelpInfo;
    Result : Longint;
  END;


