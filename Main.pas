unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, ComCtrls, ExtCtrls, Buttons, ImgList, Common;

type
  TMainForm = class(TForm)
    panHead: TPanel;
    Lable1: TLabel;
    Label2: TLabel;
    cbUser: TComboBox;
    pcPages: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    sgConfigList: TStringGrid;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    GroupBox1: TGroupBox;
    Label7: TLabel;
    edtSysOID: TEdit;
    edtSysOIDValue: TEdit;
    Label8: TLabel;
    Label9: TLabel;
    edtAddOIDValue1: TEdit;
    Label10: TLabel;
    edtAddOIDValue2: TEdit;
    Label11: TLabel;
    edtAddOIDValue3: TEdit;
    Label12: TLabel;
    edtAddOIDValue4: TEdit;
    cbAddOID1: TComboBox;
    cbAddOID2: TComboBox;
    cbAddOID3: TComboBox;
    cbAddOID4: TComboBox;
    Label13: TLabel;
    sgDeployStatus: TStringGrid;
    Label14: TLabel;
    btnDeploy: TButton;
    lbLogTitle: TLabel;
    mmLog: TMemo;
    Panel3: TPanel;
    btnLicense: TButton;
    Memo2: TMemo;
    Label16: TLabel;
    Shape1: TShape;
    Shape2: TShape;
    Label3: TLabel;
    btnCreateConfig: TButton;
    ImageList1: TImageList;
    panTail: TPanel;
    Label17: TLabel;
    btnHome: TButton;
    btnRefresh: TButton;
    btnSave: TButton;
    GroupBox2: TGroupBox;
    lbMibs: TListBox;
    btnUpload: TButton;
    OpenDialog1: TOpenDialog;
    cbLicense: TCheckBox;
    edtURL: TComboBox;
    procedure btnCreateConfigClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sgConfigListDblClick(Sender: TObject);
    procedure sgConfigListDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure btnHomeClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnUploadClick(Sender: TObject);
    procedure cbAddOID1Change(Sender: TObject);
    procedure cbAddOID2Change(Sender: TObject);
    procedure cbAddOID3Change(Sender: TObject);
    procedure cbAddOID4Change(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure sgDeployStatusDblClick(Sender: TObject);
    procedure btnLicenseClick(Sender: TObject);
    procedure btnDeployClick(Sender: TObject);
    procedure sgDeployStatusDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
  private
    { Private declarations }
    NEType: String;
    NERelease: String;
    NERow: Integer;
    procedure FillConfigDetail;
    procedure UpdateDeployStatus;
    procedure ShowLog;
    function CheckLicense: Boolean;
    function EvaluateStepDesc(config: TConfig): String;
    function EvaluateStatusDesc(config: TConfig): String;
    function EvaluateNavigateNEIW(config: TConfig): String;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses
  CreateConfig, DateUtils;

{$R *.dfm}

procedure TMainForm.btnCreateConfigClick(Sender: TObject);
begin
  if FormCreateConfig.ShowModal = mrOK then
  begin
    btnRefreshClick(nil);
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  sgConfigList.Cells[0, 0] := 'Type';
  sgConfigList.Cells[1, 0] := 'Release';
  sgConfigList.Cells[2, 0] := 'Steps';
  sgConfigList.Cells[3, 0] := 'Status';
  sgConfigList.Cells[4, 0] := 'Date Created';
  sgConfigList.Cells[5, 0] := 'User';
  sgConfigList.Cells[6, 0] := 'Action';
end;

procedure TMainForm.sgConfigListDblClick(Sender: TObject);
var
  col, row: Integer;
  pt: TPoint;
begin
  if (sgConfigList.RowCount = 2) and (sgConfigList.Cells[0, 1] = '') then Exit;
  pt := sgConfigList.ScreenToClient(Mouse.CursorPos);
  sgConfigList.MouseToCell(pt.X, pt.Y, col, row);
  NEType := sgConfigList.Cells[0, row];
  NERelease := sgConfigList.Cells[1, row];
  NERow := row;
  if (col = 3) and (row > 0) then
  begin
    ShowLog;
  end
  else if (col = 6) and (row > 0) then
  begin
    if (pt.X > 710) and (pt.X < 734) and (sgConfigList.Cells[col, row] = 'neiw') then
    begin
      ShowMessage('TODO: Navigate to NEIW website...');
    end
    else
    begin
      FillConfigDetail;
      pcPages.ActivePageIndex := 1;    
    end;
  end
  else
  begin
    FillConfigDetail;
    pcPages.ActivePageIndex := 1;
  end;
end;

procedure TMainForm.sgConfigListDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  if (ACol = 3) and (ARow > 0) and (sgConfigList.Cells[0, ARow] <> '') then
  begin
    if sgConfigList.Cells[ACol, ARow] = 'success' then
    begin
      sgConfigList.Canvas.FillRect(Rect);
      ImageList1.Draw(sgConfigList.Canvas, Rect.Left + 20 , Rect.Top + 4, 0, True);
    end
    else if sgConfigList.Cells[ACol, ARow] = 'fail' then
    begin
      sgConfigList.Canvas.FillRect(Rect);
      ImageList1.Draw(sgConfigList.Canvas, Rect.Left + 20 , Rect.Top + 4, 1, True);
    end
    else if sgConfigList.Cells[ACol, ARow] = 'process' then
    begin
      sgConfigList.Canvas.FillRect(Rect);
      ImageList1.Draw(sgConfigList.Canvas, Rect.Left + 20 , Rect.Top + 4, 2, True);
    end
    else
    begin
      sgConfigList.Canvas.FillRect(Rect);
      ImageList1.Draw(sgConfigList.Canvas, Rect.Left + 20 , Rect.Top + 4, 3, True);
    end;
  end;
  if (ACol = 6) and (ARow > 0) and (sgConfigList.Cells[0, ARow] <> '') then
  begin
    sgConfigList.Canvas.FillRect(Rect);
    ImageList1.Draw(sgConfigList.Canvas, Rect.Left + 20 , Rect.Top + 4, 4, True);
    if sgConfigList.Cells[ACol, ARow] = 'neiw' then
    begin
      ImageList1.Draw(sgConfigList.Canvas, Rect.Left + 52 , Rect.Top + 4, 5, True);
    end;
  end;
end;

procedure TMainForm.btnHomeClick(Sender: TObject);
begin
  pcPages.ActivePageIndex := 0;
end;

procedure TMainForm.btnRefreshClick(Sender: TObject);
var
  i, row: Integer;
  configList: TConfigList;
  config: TConfig;
  ts: TDateTime;
  json: String;
begin
  if cbLicense.Checked then
  begin
    if not CheckLicense then
    begin
      pcPages.ActivePageIndex := 3;
      Exit;
    end;
  end;
  json := GetJSONResponse(edtURL.Text + 'api/config');
  configList := ParseConfigListJSONStringToObject(json);
  if configList.Items.Count = 0 then exit;
  sgConfigList.RowCount := configList.Items.Count + 1;
  row := 1;
  for i:=0 to configList.Items.Count - 1 do
  begin
    config := configList.Items[i] as TConfig;
    sgConfigList.Cells[0, row] := config.ne_type;
    sgConfigList.Cells[1, row] := config.ne_release;
    sgConfigList.Cells[2, row] := EvaluateStepDesc(config);
    sgConfigList.Cells[3, row] := EvaluateStatusDesc(config);
    ts := UnixToDateTime(StrToInt64(config.createDate) div 1000);
    sgConfigList.Cells[4, row] := DateTimeToStr(ts);
    sgConfigList.Cells[5, row] := config.createUser;
    sgConfigList.Cells[6, row] := EvaluateNavigateNEIW(config);
    Inc(row);
  end;
end;

procedure TMainForm.FillConfigDetail;
var
  url, json: String;
  config: TConfig;
  metadata: TMetaData;
  i: Integer;
  oidResult: TOIDResult;
begin
  url := Format('%sapi/config/%s/%s/', [edtURL.Text, NEType, NERelease]);
  json := GetJSONResponse(url);
  config := ParseConfigJSONStringToObject(json);
  url := Format('%sapi/config/metadata/%s/%s/', [edtURL.Text, NEType, NERelease]);
  json := GetJSONResponse(url);
  metadata := ParseMetaJSONStringToObject(json);
  lbMibs.Clear;
  lbMibs.Items.AddStrings(metadata.mibFiles);
  sgDeployStatus.Cells[0, 0] := 'Component';
  sgDeployStatus.Cells[1, 0] := 'Status';
  sgDeployStatus.Cells[0, 1] := 'Parse MIB';
  sgDeployStatus.Cells[0, 2] := 'Generate FM Mapping';
  sgDeployStatus.Cells[0, 3] := 'Validate FM License';
  sgDeployStatus.Cells[0, 4] := 'Deploy O2ML';
  sgDeployStatus.Cells[1, 1] := config.parseStatus;
  sgDeployStatus.Cells[1, 2] := config.generateStatus;
  sgDeployStatus.Cells[1, 3] := config.validateStatus;
  sgDeployStatus.Cells[1, 4] := config.deployStatus;
  sgDeployStatus.Cells[1, 5] := config.generalStatus;
  edtSysOIDValue.Text := config.sysOIDValue;
  cbAddOID1.Text := config.addOIDName1;
  edtAddOIDValue1.Text := config.addOIDValue1;
  cbAddOID2.Text := config.addOIDName2;
  edtAddOIDValue2.Text := config.addOIDValue2;
  cbAddOID3.Text := config.addOIDName3;
  edtAddOIDValue3.Text := config.addOIDValue3;
  cbAddOID4.Text := config.addOIDName4;
  edtAddOIDValue4.Text := config.addOIDValue4;
  cbAddOID1.Items.Clear;
  cbAddOID2.Items.Clear;
  cbAddOID3.Items.Clear;
  cbAddOID4.Items.Clear;
  for i := 0 to metadata.allOIDs.Count - 1 do
  begin
    oidResult := metadata.allOIDs[i] as TOIDResult;
    cbAddOID1.AddItem(oidResult.name, oidResult);
    cbAddOID2.AddItem(oidResult.name, oidResult);
    cbAddOID3.AddItem(oidResult.name, oidResult);
    cbAddOID4.AddItem(oidResult.name, oidResult);
  end;
end;

procedure TMainForm.btnUploadClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    UploadFile(MainForm.edtURL.Text + 'api/config/mib', NEType, NERelease, OpenDialog1.FileName);
    FillConfigDetail;
  end;
end;

procedure TMainForm.cbAddOID1Change(Sender: TObject);
var
  oid: TOIDResult;
begin
  oid := cbAddOID1.Items.Objects[cbAddOID1.ItemIndex] as TOIDResult;
  edtAddOIDValue1.Text := oid.value;
  cbAddOID1.Hint := oid.name;
  edtAddOIDValue1.Hint := oid.desc;
end;

procedure TMainForm.cbAddOID2Change(Sender: TObject);
var
  oid: TOIDResult;
begin
  oid := cbAddOID2.Items.Objects[cbAddOID2.ItemIndex] as TOIDResult;
  edtAddOIDValue2.Text := oid.value;
  cbAddOID2.Hint := oid.name;
  edtAddOIDValue2.Hint := oid.desc;
end;

procedure TMainForm.cbAddOID3Change(Sender: TObject);
var
  oid: TOIDResult;
begin
  oid := cbAddOID3.Items.Objects[cbAddOID3.ItemIndex] as TOIDResult;
  edtAddOIDValue3.Text := oid.value;
  cbAddOID3.Hint := oid.name;
  edtAddOIDValue3.Hint := oid.desc;
end;

procedure TMainForm.cbAddOID4Change(Sender: TObject);
var
  oid: TOIDResult;
begin
  oid := cbAddOID4.Items.Objects[cbAddOID4.ItemIndex] as TOIDResult;
  edtAddOIDValue4.Text := oid.value;
  cbAddOID4.Hint := oid.name;
  edtAddOIDValue4.Hint := oid.desc;
end;

procedure TMainForm.btnSaveClick(Sender: TObject);
var
  config: TConfig;
  jsonReq: String;
  jsonResp: String;
begin
  config := TConfig.Create;
  config.ne_type := NEType;
  config.ne_release := NERelease;
  config.sysOIDValue := edtSysOIDValue.Text;
  config.addOIDName1 := cbAddOID1.Text;
  config.addOIDValue1 := edtAddOIDValue1.Text;
  config.addOIDName2 := cbAddOID2.Text;
  config.addOIDValue2 := edtAddOIDValue2.Text;
  config.addOIDName3 := cbAddOID3.Text;
  config.addOIDValue3 := edtAddOIDValue3.Text;
  config.addOIDName4 := cbAddOID4.Text;
  config.addOIDValue4 := edtAddOIDValue4.Text;
  jsonReq := BuildConfigJSONString(config);
  jsonResp := PostJSONRequest(MainForm.edtURL.Text + 'api/config', jsonReq);
  if ParseStatusJSONString(jsonResp) <> 'SUCCESS' then raise Exception.Create('save config fail');
end;

procedure TMainForm.sgDeployStatusDblClick(Sender: TObject);
begin
  ShowLog;
end;

procedure TMainForm.ShowLog;
var
  url, json: String;
  pos, len: Integer;
begin
  url := Format('%sapi/log/%s/%s/', [edtURL.Text, NEType, NERelease]);
  json := GetJSONResponse(url);
  pos := Length('{"content":"') + 1;
  len := Length(json) - Length('"}') - pos + 1;
  mmLog.Lines.QuoteChar := '''';
  mmLog.Lines.Delimiter := ',';
  mmLog.Lines.DelimitedText := copy(json, pos, len);
  lbLogTitle.Caption := Format('%s-%s:', [NEType, NERelease]);
  pcPages.ActivePageIndex := 2;
end;

function TMainForm.CheckLicense: Boolean;
var
  url, json: String;
begin
  url := Format('%sapi/app/status', [edtURL.Text]);
  json := GetJSONResponse(url);
  if ParseStatusJSONString(json) <> 'SUCCESS' then
    Result := False
  else
    Result := True;
end;

procedure TMainForm.btnLicenseClick(Sender: TObject);
begin
  pcPages.ActivePageIndex := 0;
end;

procedure TMainForm.btnDeployClick(Sender: TObject);
var
  url: String;
  jsonResp: String;
begin
  url := Format('%sapi/config/%s/%s/', [edtURL.Text, NEType, NERelease]);
  jsonResp := PostJSONRequest(url, '');
  if ParseStatusJSONString(jsonResp) = 'SUCCESS' then
  begin
    ShowMessage('Deploy successed');
  end;
  if ParseStatusJSONString(jsonResp) = 'ERROR' then
  begin
    ShowMessage('Deploy failed');
  end;
  if ParseStatusJSONString(jsonResp) = 'PROCESSING' then
  begin
    ShowMessage('Deployment is not fully successful, please check and redeploy');
  end;
  UpdateDeployStatus;
end;

procedure TMainForm.UpdateDeployStatus;
var
  url, json: String;
  config: TConfig;
begin
  url := Format('%sapi/config/%s/%s/', [edtURL.Text, NEType, NERelease]);
  json := GetJSONResponse(url);
  config := ParseConfigJSONStringToObject(json);
  sgDeployStatus.Cells[1, 1] := config.parseStatus;
  sgDeployStatus.Cells[1, 2] := config.validateStatus;
  sgDeployStatus.Cells[1, 3] := config.generateStatus;
  sgDeployStatus.Cells[1, 4] := config.deployStatus;
  sgConfigList.Cells[2, NERow] := EvaluateStepDesc(config);
  sgConfigList.Cells[3, NERow] := EvaluateStatusDesc(config);
  sgConfigList.Cells[6, NERow] := EvaluateNavigateNEIW(config);
end;

function TMainForm.EvaluateStepDesc(config: TConfig): String;
begin
  if config.deployStatus = 'SUCCESS' then
  begin
    Result := 'Step 4/4 - All step success';
    Exit;
  end;
  if config.deployStatus = 'PROCESSING' then
  begin
    Result := 'Step 4/4 - Mapping deploying...';
    Exit;
  end;
  if config.generateStatus = 'PROCESSING' then
  begin
    Result := 'Step 3/4 - Mapping generating...';
    Exit;
  end;
  if config.generateStatus = 'SUCCESS' then
  begin
    Result := 'Step 3/4 - Deploy mapping failed';
    Exit;
  end;
  if config.validateStatus = 'SUCCESS' then
  begin
    Result := 'Step 2/4 - Generate mapping failed';
    Exit;
  end;
  if config.parseStatus = 'SUCCESS' then
  begin
    Result := 'Step 1/4 - Validate failed';
    Exit;
  end;
  Result := 'Step 0/4 - Ready for parse mibs';
end;

function TMainForm.EvaluateStatusDesc(config: TConfig): String;
begin
  if config.deployStatus = 'SUCCESS' then
  begin
    Result := 'success';
    Exit;
  end;
  if config.deployStatus = 'PROCESSING' then
  begin
    Result := 'process';
    Exit;
  end;
  if config.generateStatus = 'PROCESSING' then
  begin
    Result := 'process';
    Exit;
  end;
  if config.generateStatus = 'SUCCESS' then
  begin
    Result := 'fail';
    Exit;
  end;
  if config.validateStatus = 'SUCCESS' then
  begin
    Result := 'fail';
    Exit;
  end;
  if config.parseStatus = 'SUCCESS' then
  begin
    Result := 'fail';
    Exit;
  end;
  Result := 'none';
end;

function TMainForm.EvaluateNavigateNEIW(config: TConfig): String;
begin
  if config.deployStatus = 'SUCCESS' then
  begin
    Result := 'neiw';
    Exit;
  end;
  Result := 'none';
end;

procedure TMainForm.sgDeployStatusDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  if (ACol = 1) and (ARow > 0) then
  begin
    if sgDeployStatus.Cells[ACol, ARow] = 'SUCCESS' then
    begin
      sgDeployStatus.Canvas.FillRect(Rect);
      ImageList1.Draw(sgDeployStatus.Canvas, Rect.Left + 12 , Rect.Top + 4, 0, True);
    end
    else if sgDeployStatus.Cells[ACol, ARow] = 'ERROR' then
    begin
      sgDeployStatus.Canvas.FillRect(Rect);
      ImageList1.Draw(sgDeployStatus.Canvas, Rect.Left + 12 , Rect.Top + 4, 1, True);
    end
    else if sgDeployStatus.Cells[ACol, ARow] = 'PROCESSING' then
    begin
      sgDeployStatus.Canvas.FillRect(Rect);
      ImageList1.Draw(sgDeployStatus.Canvas, Rect.Left + 12 , Rect.Top + 4, 2, True);
    end
    else
    begin
      sgDeployStatus.Canvas.FillRect(Rect);
      ImageList1.Draw(sgDeployStatus.Canvas, Rect.Left + 12 , Rect.Top + 4, 3, True);
    end;
  end;
end;

end.
