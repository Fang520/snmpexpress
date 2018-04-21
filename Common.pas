unit Common;

interface

uses
  Classes, Contnrs;

type
  TConfig = class
    ne_type: String;
    ne_release: String;
    description: String;
    sysOIDValue: String;
    addOIDName1: String;
    addOIDValue1: String;
    addOIDName2: String;
    addOIDValue2: String;
    addOIDName3: String;
    addOIDValue3: String;
    addOIDName4: String;
    addOIDValue4: String;
    parseStatus: String;
    validateStatus: String;
    generateStatus: String;
    deployStatus: String;
    generalStatus: String;
    createUser: String;
    deployUser: String;
    createDate: String;
    deployDate: String
  end;

  TConfigList = class
    Items: TObjectList;
    constructor Create;
    destructor Destroy; override;
  end;

  TMetaData = class
    mibFiles: TStringList;
    allOIDs: TObjectList;
    suggestOIDs: TObjectList;
    constructor Create;
    destructor Destroy; override;    
  end;

  TOIDResult = class
    name: String;
    value: String;
    desc: String
  end;

  TStatus = class
    status: String;
  end;

  function ParseConfigListJSONStringToObject(json: String): TConfigList;
  function ParseConfigJSONStringToObject(json: String): TConfig;
  function ParseStatusJSONString(json: String): String;
  function ParseMetaJSONStringToObject(json: String): TMetaData;
  function BuildConfigJSONString(config: TConfig): String;
  function GetJSONResponse(url: String): String;
  function PostJSONRequest(url: String; json: String): String;
  procedure UploadFile(url, ne_type, ne_release, file_name: String);

implementation

uses
  uLkJSON, Variants, IdHTTP, IdMultipartFormData;

{ TConfig }

constructor TConfigList.Create;
begin
  Items := TObjectList.Create;
end;

destructor TConfigList.Destroy;
begin
  Items.Free;
end;

constructor TMetaData.Create;
begin
  mibFiles := TStringList.Create;
  allOIDs := TObjectList.Create;
  suggestOIDs := TObjectList.Create;
end;

destructor TMetaData.Destroy;
begin
  mibFiles.Free;
  allOIDs.Free;
  suggestOIDs.Free;
end;

function ParseConfigListJSONStringToObject(json: String): TConfigList;
var
  jo1, jo2, jo3, jo4: TlkJSONBase;
  i: Integer;
  config: TConfig;
  configList: TConfigList;
begin
  configList := TConfigList.Create;
  jo1 := TlkJSON.ParseText(json);
  jo2 := jo1.Field['configList'];
  for i:=0 to jo2.Count - 1 do
  begin
    jo3 := jo2.Child[i];
    config := TConfig.Create;
    config.ne_type := VarToStr(jo3.Field['type'].Value);
    config.ne_release := VarToStr(jo3.Field['release'].Value);
    config.description := VarToStr(jo3.Field['description'].Value);
    config.sysOIDValue := VarToStr(jo3.Field['sysOIDValue'].Value);
    config.parseStatus := VarToStr(jo3.Field['parseStatus'].Value);
    config.validateStatus := VarToStr(jo3.Field['validateStatus'].Value);
    config.generateStatus := VarToStr(jo3.Field['generateStatus'].Value);
    config.deployStatus := VarToStr(jo3.Field['deployStatus'].Value);
    config.generalStatus := VarToStr(jo3.Field['generalStatus'].Value);
    config.createUser := VarToStr(jo3.Field['createUser'].Value);
    config.deployUser := VarToStr(jo3.Field['deployUser'].Value);
    config.createDate := VarToStr(jo3.Field['createDate'].Value);
    config.deployDate := VarToStr(jo3.Field['deployDate'].Value);
    jo4 := jo3.Field['additionalOID'];
    config.addOIDName1 := jo4.Child[0].Field['oid'].Value;
    config.addOIDValue1 := jo4.Child[0].Field['value'].Value;
    config.addOIDName2 := jo4.Child[1].Field['oid'].Value;
    config.addOIDValue2 := jo4.Child[1].Field['value'].Value;
    config.addOIDName3 := jo4.Child[2].Field['oid'].Value;
    config.addOIDValue3 := jo4.Child[2].Field['value'].Value;
    config.addOIDName4 := jo4.Child[3].Field['oid'].Value;
    config.addOIDValue4 := jo4.Child[3].Field['value'].Value;
    configList.Items.Add(config);
  end;
  result := configList;
  jo1.Free;
end;

function ParseConfigJSONStringToObject(json: String): TConfig;
var
  jo1, jo2, jo3: TlkJSONBase;
  config: TConfig;
begin
  config := TConfig.Create;
  jo1 := TlkJSON.ParseText(json);
  jo2 := jo1.Field['config'];
  config.ne_type := VarToStr(jo2.Field['type'].Value);
  config.ne_release := VarToStr(jo2.Field['release'].Value);
  config.description := VarToStr(jo2.Field['description'].Value);
  config.sysOIDValue := VarToStr(jo2.Field['sysOIDValue'].Value);
  config.parseStatus := VarToStr(jo2.Field['parseStatus'].Value);
  config.validateStatus := VarToStr(jo2.Field['validateStatus'].Value);
  config.generateStatus := VarToStr(jo2.Field['generateStatus'].Value);
  config.deployStatus := VarToStr(jo2.Field['deployStatus'].Value);
  config.generalStatus := VarToStr(jo2.Field['generalStatus'].Value);
  config.createUser := VarToStr(jo2.Field['createUser'].Value);
  config.deployUser := VarToStr(jo2.Field['deployUser'].Value);
  config.createDate := VarToStr(jo2.Field['createDate'].Value);
  config.deployDate := VarToStr(jo2.Field['deployDate'].Value);
  jo3 := jo2.Field['additionalOID'];
  config.addOIDName1 := jo3.Child[0].Field['oid'].Value;
  config.addOIDValue1 := jo3.Child[0].Field['value'].Value;
  config.addOIDName2 := jo3.Child[1].Field['oid'].Value;
  config.addOIDValue2 := jo3.Child[1].Field['value'].Value;
  config.addOIDName3 := jo3.Child[2].Field['oid'].Value;
  config.addOIDValue3 := jo3.Child[2].Field['value'].Value;
  config.addOIDName4 := jo3.Child[3].Field['oid'].Value;
  config.addOIDValue4 := jo3.Child[3].Field['value'].Value;
  result := config;
  jo1.Free;
end;

function BuildConfigJSONString(config: TConfig): String;
var
  jo_root: TlkJsonObject;
  jo_addOIDList: TlkJsonList;
  jo_addOID1, jo_addOID2, jo_addOID3, jo_addOID4: TlkJsonObject;
begin
  jo_root := TlkJsonObject.Create;
  jo_root.Add('type', config.ne_type);
  jo_root.Add('release', config.ne_release);
  if config.description <> '' then jo_root.Add('description', config.description);
  if config.createUser <> '' then jo_root.Add('createUser', config.createUser);
  if config.createDate <> '' then jo_root.Add('createDate', config.createDate);
  if config.parseStatus <> '' then jo_root.Add('parseStatus', config.parseStatus);
  if config.validateStatus <> '' then jo_root.Add('validateStatus', config.validateStatus);
  if config.generateStatus <> '' then jo_root.Add('generateStatus', config.generateStatus);
  if config.deployStatus <> '' then jo_root.Add('deployStatus', config.deployStatus);
  if config.generalStatus <> '' then jo_root.Add('generalStatus', config.generalStatus);
  if config.deployUser <> '' then jo_root.Add('deployUser', config.deployUser);
  if config.deployDate <> '' then jo_root.Add('deployDate', config.deployDate);
  if config.sysOIDValue <> '' then jo_root.Add('sysOIDValue', config.sysOIDValue);
  jo_addOIDList := TlkJsonList.Create;
  jo_addOID1 := nil;
  jo_addOID2 := nil;
  jo_addOID3 := nil;
  jo_addOID4 := nil;
  if (config.addOIDName1 <> '') and (config.addOIDValue1 <> '') then
  begin
    jo_addOID1 := TlkJsonObject.Create;
    jo_addOID1.Add('oid', config.addOIDName1);
    jo_addOID1.Add('value', config.addOIDValue1);
    jo_addOIDList.Add(jo_addOID1);
  end;
  if (config.addOIDName2 <> '') and (config.addOIDValue2 <> '') then
  begin
    jo_addOID2 := TlkJsonObject.Create;
    jo_addOID2.Add('oid', config.addOIDName2);
    jo_addOID2.Add('value', config.addOIDValue2);
    jo_addOIDList.Add(jo_addOID2);
  end;
  if (config.addOIDName3 <> '') and (config.addOIDValue3 <> '') then
  begin
    jo_addOID3 := TlkJsonObject.Create;
    jo_addOID3.Add('oid', config.addOIDName3);
    jo_addOID3.Add('value', config.addOIDValue3);
    jo_addOIDList.Add(jo_addOID3);
  end;
  if (config.addOIDName4 <> '') and (config.addOIDValue4 <> '') then
  begin
    jo_addOID4 := TlkJsonObject.Create;
    jo_addOID4.Add('oid', config.addOIDName4);
    jo_addOID4.Add('value', config.addOIDValue4);
    jo_addOIDList.Add(jo_addOID4);
  end;
  if jo_addOIDList.Count > 0 then jo_root.Add('additionalOID', jo_addOIDList);
  result := TlkJSON.GenerateText(jo_root);
  jo_root.Free;
end;

function ParseMetaJSONStringToObject(json: String): TMetaData;
var
  joRoot, joMibFileList, joAllOIDList, joSuggestOIDList, joOID: TlkJSONBase;
  i: Integer;
  metaData: TMetaData;
  OIDResult: TOIDResult;
begin
  metaData := TMetaData.Create;
  joRoot := TlkJSON.ParseText(json);
  joMibFileList := joRoot.Field['mibFiles'];
  joAllOIDList := joRoot.Field['allOIDs'];
  joSuggestOIDList := joRoot.Field['suggestOIDs'];
  for i:=0 to joMibFileList.Count - 1 do
  begin
    metaData.mibFiles.Add(VarToStr(joMibFileList.Child[i].Value));
  end;
  for i:=0 to joAllOIDList.Count - 1 do
  begin
    joOID := joAllOIDList.Child[i];
    OIDResult := TOIDResult.Create;
    OIDResult.name := VarToStr(joOID.Field['name'].Value);
    OIDResult.value := VarToStr(joOID.Field['value'].Value);
    OIDResult.desc := VarToStr(joOID.Field['description'].Value);
    metaData.allOIDs.Add(OIDResult);
  end;
  for i:=0 to joSuggestOIDList.Count - 1 do
  begin
    joOID := joSuggestOIDList.Child[i];
    OIDResult := TOIDResult.Create;
    OIDResult.name := VarToStr(joOID.Field['name'].Value);
    OIDResult.value := VarToStr(joOID.Field['value'].Value);
    OIDResult.desc := VarToStr(joOID.Field['description'].Value);
    metaData.suggestOIDs.Add(OIDResult);
  end;
  result := metaData;
  joRoot.Free;
end;

function ParseStatusJSONString(json: String): String;
var
  jo: TlkJSONBase;
  status: TStatus;
begin
  status := TStatus.Create;
  jo := TlkJSON.ParseText(json);
  result := VarToStr(jo.Field['status'].Value);
  status.free;
  jo.Free;
end;

function GetJSONResponse(url: String): String;
var
  idHttp: TIdHTTP;
begin
  idHttp := TIdHTTP.Create(nil);
  try
    result := idHttp.Get(url);
  finally
    idHttp.Free;
  end;
end;

function PostJSONRequest(url: String; json: String): String;
var
  idHttp: TIdHTTP;
  js: TStringStream;
begin
  idHttp := TIdHTTP.Create(nil);
  js := TStringStream.Create(json);
  try
    idHttp.Request.ContentType := 'application/json';
    result := idHttp.Post(url, js);
  finally
    idHttp.Free;
    js.Free;
  end;
end;

procedure UploadFile(url, ne_type, ne_release, file_name: String);
var
  idHttp: TIdHTTP;
  content: TIdMultiPartFormDataStream;
begin
  idHttp := TIdHttp.Create(nil);
  content := TIdMultiPartFormDataStream.Create;
  try
    content.AddFormField('type', ne_type);
    content.AddFormField('release', ne_release);
    content.AddFile('file', file_name, 'application/octet-stream');
    idHttp.Post(url, content);
  finally
    idHttp.Free;
    content.Free;
  end;
end;

end.
