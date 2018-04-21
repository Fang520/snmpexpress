program snmpexpress;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  CreateConfig in 'CreateConfig.pas' {FormCreateConfig},
  uLkJSON in 'uLkJSON.pas',
  Common in 'Common.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'SNMP Express Client';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TFormCreateConfig, FormCreateConfig);
  Application.Run;
end.
