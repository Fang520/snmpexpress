unit CreateConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TFormCreateConfig = class(TForm)
    Label1: TLabel;
    edtType: TEdit;
    Label2: TLabel;
    edtRelease: TEdit;
    Label3: TLabel;
    edtDesc: TMemo;
    edtPath: TEdit;
    Label4: TLabel;
    btnSelect: TSpeedButton;
    btnCreate: TButton;
    OpenDialog1: TOpenDialog;
    procedure btnCreateClick(Sender: TObject);
    procedure btnSelectClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormCreateConfig: TFormCreateConfig;

implementation

{$R *.dfm}

uses
  DateUtils, Main, Common;

procedure TFormCreateConfig.btnCreateClick(Sender: TObject);
var
  jsonReq, jsonResp: String;
  config: TConfig;
begin
  if edtType.Text = '' then raise Exception.Create('type empty');
  if edtRelease.Text = '' then raise Exception.Create('release empty');
  if edtPath.Text = '' then raise Exception.Create('file empty');
  config := TConfig.Create;
  config.ne_type := edtType.Text;
  config.ne_release := edtRelease.Text;
  config.description := edtDesc.Text;
  config.createUser := MainForm.cbUser.Text;
  config.createDate := IntToStr(DateTimeToUnix(Now()) * 1000);
  jsonReq := BuildConfigJSONString(config);
  jsonResp := PostJSONRequest(MainForm.edtURL.Text + 'api/create', jsonReq);
  if ParseStatusJSONString(jsonResp) <> 'SUCCESS' then raise Exception.Create('create config fail');
  UploadFile(MainForm.edtURL.Text + 'api/config/mib', edtType.Text, edtRelease.Text, edtPath.Text);
  ModalResult := mrOK;
end;

procedure TFormCreateConfig.btnSelectClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    edtPath.Text := OpenDialog1.FileName;
  end;
end;

end.
