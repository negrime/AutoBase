program PrHash;

uses
  Forms,
  FmMain in 'FmMain.pas' {FormMain},
  UAddForm in '..\Hash\UAddForm.pas' {FormAdd};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TFormInfo, FormInfo);
  Application.Run;
end.
