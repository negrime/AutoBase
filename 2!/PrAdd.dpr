program PrAdd;

uses
  Forms,
  UAddForm in 'UAddForm.pas' {FormInfo};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormInfo, FormInfo);
  Application.Run;
end.
