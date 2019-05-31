unit FmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnList, UHashGUI, Grids, UAddForm, UData, ImgList,
  ToolWin, ComCtrls;

type
  TFormMain = class(TForm)
    MenuFile: TMainMenu;
    File1: TMenuItem;
    btnNew: TMenuItem;
    btnOpen: TMenuItem;
    btnSave: TMenuItem;
    btnSaveas: TMenuItem;
    btnClose: TMenuItem;
    Edit1: TMenuItem;
    btnAdd: TMenuItem;
    btnDelete: TMenuItem;
    btnClear: TMenuItem;
    btnFind: TMenuItem;
    dlgOpen: TOpenDialog;
    dlgSave: TSaveDialog;
    ActionList: TActionList;
    ActNew: TAction;
    ActOpen: TAction;
    ActSave: TAction;
    ActSaveas: TAction;
    ActClear: TAction;
    ActAdd: TAction;
    ActDel: TAction;
    ActFind: TAction;
    ActClose: TAction;
    HashTableView: TStringGrid;
    ToolBarMenu: TToolBar;
    ImageListMenu: TImageList;
    ToolbtnNew: TToolButton;
    ToolButton1: TToolButton;
    ToolBtnSave: TToolButton;
    ToolBtnSaveAs: TToolButton;
    ToolBtnClose: TToolButton;
    ToolButton2: TToolButton;
    ToolBtnAdd: TToolButton;
    ToolBtnDel: TToolButton;
    ToolBtnFind: TToolButton;
    ToolBtnClear: TToolButton;
    procedure ActNewExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ActCloseExecute(Sender: TObject);
    procedure HashClose(var CanClose:boolean);
    procedure ActOpenExecute(Sender: TObject);
    procedure ActSaveExecute(Sender: TObject);
    procedure ActSaveasExecute(Sender: TObject);
    procedure ActAddExecute(Sender: TObject);
    procedure ActDelExecute(Sender: TObject);
    procedure ActFindExecute(Sender: TObject);
    procedure ActClearExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    HashTable:THashGUI;
    procedure MyIdle(sender: TObject; var Done:Boolean);
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

procedure TFormMain.HashClose(var CanClose: Boolean);    //+
begin
  Canclose:=True;
  if (HashTable<>nil) and (HashTable.Modified)then
    case MessageDlg('Save changes?', mtConfirmation,[mbYes,mbNo,mbCancel],0) of
      mrNo:;
      mrCancel: CanClose:=False;
      mrYes:
        begin
          actSave.OnExecute(self);
          CanClose:= not HashTable.Modified;
        end;
    end;
  if CanClose then
  begin
    HashTable.Clear;
  end;
end;

procedure TFormMain.MyIdle(sender: TObject; var Done: Boolean);
begin
  Done:=True;
  HashTableView.Visible:=HashTable<>nil;
  ActSave.Enabled:=HashTable<>nil;
  ActSaveAs.Enabled:=HashTable<>nil;
  ActClose.Enabled:=HashTable<>nil;
  ActAdd.Enabled:=HashTable<>nil;
  ActDel.Enabled:=(HashTable<>nil) and (HashTable.Count>0);
  ActFind.Enabled:=ActDel.Enabled;
  ActClear.Enabled:=ActDel.Enabled;
end;

procedure TFormMain.ActNewExecute(Sender: TObject);
begin
  HashTableView.Visible:=true;
  if HashTable <> nil then actClose.OnExecute(self);
  if HashTable = nil
    then HashTable:=THashGUI.Create(HashTableView);
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  HashTable:=nil;
  with HashTableView do
  begin
    RowCount:=2;
    Rows[1].Clear;
    Cells[0,0]:='№';
    Cells[1,0]:='Название';
    Cells[2,0]:='Режисер';
    Cells[3,0]:='Актеры';
    Cells[4,0]:='Описание';
  end;
 // HashTableView.Visible:=false;
  Application.OnIdle:=MyIdle;
  dlgOpen.InitialDir:=ExtractFilePath(Application.ExeName);
  dlgSave.InitialDir:=dlgOpen.InitialDir;
end;

procedure TFormMain.ActCloseExecute(Sender: TObject);
var
  CanClose:Boolean;
begin
  Canclose:=True;
  HashClose(CanClose);
  if CanClose then
  begin
    FreeAndNil(HashTable);
  end;
end;

procedure TFormMain.ActOpenExecute(Sender: TObject);
begin
if dlgOpen.Execute then
  begin
    if HashTable <> nil then
      actClose.OnExecute(self);
    if HashTable = nil then
        begin
          HashTable:=THashGUI.Create(HashTableView);
          HashTable.LoadFromFile(dlgOpen.FileName);
          HashTable.ShowToGrid(HashTableView);
          HashTableView.Visible:=true;
        end;
   end;
end;

procedure TFormMain.ActSaveExecute(Sender: TObject);
begin
if HashTable.Filename = '' then
    actSaveAs.OnExecute(self)
  else
    HashTable.SaveFile;
end;

procedure TFormMain.ActSaveasExecute(Sender: TObject);
begin
  dlgSave.FileName:=HashTable.Filename;
  if dlgSave.Execute then
    HashTable.SaveToFile(dlgSave.FileName);
end;

procedure TFormMain.ActAddExecute(Sender: TObject);
begin
  with TFormInfo.Create(Self) do
    try
      if ShowModal=mrOK then
          if not HashTable.Add(Info) then
            begin
              MessageDlg('The film with the same title has been already added!',mtError,[mbCancel],0);
              Info.Free
            end
          else
            HashTable.ShowToGrid(HashTableView);
    finally
      Free
      end;
end;

procedure TFormMain.ActDelExecute(Sender: TObject);
var
  key:string;
begin
  key:='';
  if InputQuery('Removing','Put the title',key) then
    if HashTable.Delete(key) then
    begin
      ShowMessage('The film has been removed');
      HashTable.ShowToGrid(HashTableView);
     end
    else MessageDlg('The film has NOT been found!',mtError,[mbCancel],0)
end;

procedure TFormMain.ActFindExecute(Sender: TObject);
var
  key:string;
  MyInfo:TInfo;
  FormInfo: TFormInfo;
  Int : LongInt ;
  ok : Boolean ;
  i : Integer ;
begin
  key:='';
  int := 0;
  i := 1;
  ok := True;
  if InputQuery('Searching', 'Put the whole number', key) then
    begin
      while ((i <= Length(key)) and (ok)) do
      begin
        ok := (key[i] in ['0'..'9']);
        inc(i);
      end;  
      if ok then
      if HashTable.Find(key,MyInfo)
        then
          begin
            FormInfo:=TFormInfo.Create(Self);
            with FormInfo do
            begin
              Caption:='Information about the film';
              EdName.Text:=MyInfo.Name;
              EdDirector.Text:=MyInfo.Director;
              memoActors.Text:=MyInfo.Actors;
              memoSummary.Text:=MyInfo.Summary;
              EdName.ReadOnly:=True;
              memoActors.ReadOnly:=True;
              memoSummary.ReadOnly:=True;
              EdDirector.ReadOnly:=True;
              btnOk.Visible:=False;
              ShowModal
            end;
            FreeAndNil(FormInfo);
          end
        else ShowMessage('The film has NOT been found!')
        else ShowMessage('Only whole number');
    end;
end;

procedure TFormMain.ActClearExecute(Sender: TObject);
begin
  case MessageDlg('Do you really want to clear the hash table?',mtConfirmation,[mbYes,mbNo], 0) of
      mrYes :
      begin
        HashTable.Clear;
        HashTable.ShowToGrid(HashTableView);
      end;
      mrNo:;
   end;
end;

procedure TFormMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if HashTable=nil then CanClose:=true
  else
    HashClose(CanClose)
end;

end.
