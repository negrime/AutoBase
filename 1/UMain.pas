unit UMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, ExtCtrls, UTrieGUI, ToolWin, ComCtrls, 
  ActnList, ImgList;

type
  TFmMain = class(TForm)
    MainMenu: TMainMenu;
    FileMenu: TMenuItem;
    Newbtn: TMenuItem;
    Openbtn: TMenuItem;
    Savebtn: TMenuItem;
    Saveasbtn: TMenuItem;
    Exitbtn: TMenuItem;
    EditMenu: TMenuItem;
    Addbtn: TMenuItem;
    Deletebtn: TMenuItem;
    Findbtn: TMenuItem;
    TaskMenu: TMenuItem;
    Dobtn: TMenuItem;
    MemoIn: TMemo;
    OpenDialogIn: TOpenDialog;
    ToolBarFile: TToolBar;
    ImageListMenu: TImageList;
    ActionListMenu: TActionList;
    ActOpen: TAction;
    Closebtn: TMenuItem;
    SaveDialog: TSaveDialog;
    Clearbtn: TMenuItem;
    ToolButtonNew: TToolButton;
    ActNew: TAction;
    ToolBtnOpen: TToolButton;
    ToolBtnSave: TToolButton;
    ActSave: TAction;
    ToolBtnSaveAs: TToolButton;
    ActSaveAs: TAction;
    ToolBtnClose: TToolButton;
    ActClose: TAction;
    ToolBtnAdd: TToolButton;
    ActAdd: TAction;
    ToolBtnDel: TToolButton;
    ActDel: TAction;
    ToolSplitter: TToolButton;
    ActFind: TAction;
    ToolBtnFind: TToolButton;
    ActClear: TAction;
    ToolBtnClear: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure ExitbtnClick(Sender: TObject);  
    procedure OpenbtnClick(Sender: TObject);
    procedure ClosebtnClick(Sender: TObject);
    procedure TreeClose(var canClose:Boolean);
    procedure SavebtnClick(Sender: TObject);
    procedure SaveasbtnClick(Sender: TObject);
    procedure NewbtnClick(Sender: TObject);
    procedure AddbtnClick(Sender: TObject);
    procedure DeletebtnClick(Sender: TObject);
    procedure ClearbtnClick(Sender: TObject);
    procedure FindbtnClick(Sender: TObject);
    procedure DobtnClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    Tree:TTrieGUI;
    procedure MyIdle(sender: TObject; var Done:Boolean);
  public
    { Public declarations }
  end;

var
  FmMain: TFmMain;

implementation

{$R *.dfm}
const
  separators = [' ',',',';','.','?','!',':','-'];

function NextWord(s:string; var i:Integer):string;
var
  Len:Integer;
begin
  Len:=Length(s);
  while (i<=Len) and (s[i] in separators) do inc(i);
  Result:='';
  while (i<=Len) and (not (s[i] in separators)) do
  begin
    Result:=Result+s[i];
    inc(i);
  end;
end;

procedure TFmMain.ExitbtnClick(Sender: TObject);
begin
  Closebtn.Click;
end;

procedure TFmMain.OpenbtnClick(Sender: TObject);
begin
   if OpenDialogIn.Execute then
      begin
        if Tree <> nil
          then Closebtn.Click;
        if Tree = nil
          then
            begin
              Tree:=TTrieGUI.Create;
              Tree.LoadFromFile(OpenDialogIn.FileName);
              Tree.PrintAll(MemoIn.Lines);
            end;
      end;
end;

procedure TFmMain.ClosebtnClick(Sender: TObject);
var
  CanClose:Boolean;
begin
  Canclose:=True;
  TreeClose(CanClose);
  if CanClose then
  begin
    MemoIn.Clear;
    FreeAndNil(Tree);
  end;
end;

procedure TFmMain.TreeClose(var CanClose: Boolean);
begin
  Canclose:=True;
  if (Tree<>nil) and (Tree.Modified)then
    case MessageDlg('Сохранить изменения?', mtConfirmation,[mbYes,mbNo,mbCancel],0) of
      mrNo:;
      mrCancel: CanClose:=False;
      mrYes:
        begin
          Savebtn.Click;
          CanClose:= not Tree.Modified;
        end;
    end;
  if CanClose then
  begin
    MemoIn.Clear;
    FreeAndNil(Tree);
  end;
end;

procedure TFmMain.SavebtnClick(Sender: TObject);
begin
  if Tree.Filename = '' then
    SaveAsbtn.Click
  else
    Tree.SaveFile;
end;

procedure TFmMain.SaveasbtnClick(Sender: TObject);
begin
  SaveDialog.FileName:=Tree.Filename;
  if SaveDialog.Execute then
    Tree.SaveToFile(SaveDialog.FileName);
end;

procedure TFmMain.NewbtnClick(Sender: TObject);
begin
  if Tree <> nil then
    Closebtn.Click;
  if Tree = nil then
    begin
      Tree:=TTrieGUI.Create;
      memoIn.Text:='';
    end;
end;

procedure TFmMain.AddbtnClick(Sender: TObject);
var
  temp,inp_str:string;
  i,len,CountWords:Integer;
  ErrorAdd:Boolean;
begin
  inp_str:='';
  CountWords:=0;
  ErrorAdd:=False;
  i:=1;
  if InputQuery('Добавление слов','Введите слова:',inp_str) then
      begin
        Len:=Length(inp_str);
        while (i <= Len) and not ErrorAdd do
        begin
          temp:=NextWord(inp_str,i);
          if temp <> '' then
            if Tree.AddWord(temp) then
              inc(CountWords)
            else
              begin
                ErrorAdd:=True;
                ShowMessage('Cлово уже есть в дереве, либо некорректно. Успешно считано '+inttostr(CountWords)+' слов');
              end;
        end;
      end;
  if CountWords >0
    then Tree.PrintAll(memoIn.Lines);
end;

procedure TFmMain.FormCreate(Sender: TObject);
begin
  Tree:=nil;
  Application.OnIdle:=MyIdle;
  OpenDialogIn.InitialDir:=ExtractFilePath(Application.ExeName);
  SaveDialog.InitialDir:=OpenDialogIn.InitialDir;
end;

procedure TFmMain.DeletebtnClick(Sender: TObject);
var
  word:string;
begin
  word:='';
  if InputQuery('Удаление слова','Введите слов',word)
    then
      if Tree.DeleteWord(word)then
          begin
            Tree.PrintAll(memoIn.Lines);
            ShowMessage('Слово удалено!');
          end
      else MessageDlg('Ошибка удаления слова!',mtError,[mbCancel],0)
end;


procedure TFmMain.MyIdle(sender: TObject; var Done: Boolean);
begin
  Done:=True;
  memoIn.Visible:=Tree<>nil;
  ActSave.Enabled:=Tree<>nil;
  ActSaveAs.Enabled:=Tree<>nil;
  ActClose.Enabled:=Tree<>nil;
  ActAdd.Enabled:=Tree<>nil;
  ActDel.Enabled:=(Tree<>nil) and not Tree.IsEmpty;
  ActFind.Enabled:=ActDel.Enabled;
  ActClear.Enabled:=ActDel.Enabled;
  Dobtn.Enabled:=ActDel.Enabled;
end;

procedure TFmMain.ClearbtnClick(Sender: TObject);
begin
  case MessageDlg('Вы действительно хотите очистить дерево? ',mtConfirmation,[mbYes,mbNo], 0) of
      mrYes :
        begin
          Tree.Clear;
          memoIn.Text:='';
        end ;
      mrNo:;
   end;
end;

procedure TFmMain.FindbtnClick(Sender: TObject);
var
  word:string;
begin
  word:='';
  if InputQuery('Поиск', 'Введите слово', word) then
    begin
      if Tree.FindWord(word) then
        ShowMessage('Слово найдено!')
      else
        ShowMessage('Слово не найдено!');
    end;
end;

procedure TFmMain.DobtnClick(Sender: TObject);
begin
  ShowMessage('Количество слов с буквой А равно ' + IntToStr(Tree.GetWordsCount));
end;

procedure TFmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  TreeClose(CanClose)
end;

end.
