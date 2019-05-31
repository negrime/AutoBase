unit UAddForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, StdCtrls, UData;

type
  TFormInfo = class(TForm)
    lblName: TLabel;
    lblDirector: TLabel;
    LblActors: TLabel;
    LblSummary: TLabel;
    EdName: TEdit;
    EdDirector: TEdit;
    MemoActors: TMemo;
    MemoSummary: TMemo;
    btnOk: TButton;
    btnClose: TButton;
    ActionList: TActionList;
    ActChange: TAction;
    procedure ActChangeExecute(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure EdNameKeyPress(Sender: TObject; var Key: Char);
 private
    FInfo: TInfo;
  public
    property Info:TInfo read FInfo;
  end;

var
  FormInfo: TFormInfo;

implementation

{$R *.dfm}



procedure TFormInfo.ActChangeExecute(Sender: TObject);
begin
  btnOk.Enabled:=(EdName.Text<>'') and (memoActors.Text<>'') and
  (memoSummary.Text<>'') and (EdDirector.Text<>'')
end;

procedure TFormInfo.btnOkClick(Sender: TObject);
begin
  if Trim(EdName.Text)='' then
    begin
      MessageDlg('Не введен ключ', mtError, [mbOK], 0);
      EdName.SetFocus;
      Exit;
    end;
    FInfo:=TInfo.Create(EdName.Text,EdDirector.Text,memoActors.Text,memoSummary.Text);
    ModalResult:=mrOK;
end;



procedure TFormInfo.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFormInfo.EdNameKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9']) then
    Key := #0;
end;

end.
