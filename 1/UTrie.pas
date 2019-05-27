unit UTrie;

interface
uses UNode,Classes, SysUtils, ComCtrls,Dialogs;
type
  TTrie = class
  private
    FRoot : TNode;
  public
    constructor Create;
    destructor Destroy; override;
    function AddWord (word : string):boolean;
    function DeleteWord(word:string):boolean;
    function FindWord (word : string ):boolean;
    procedure PrintAll (SL : TStrings);
    function LoadFromFile(AFileName: string):boolean;
    procedure SaveToFile (AFileName : string);
    function IsEmpty:boolean;
    procedure Clear;
    function GetWordsCount:integer;
  end;
  function IsCorrectWord (var wrd : string) : boolean; 

implementation
constructor TTrie.Create;
begin
  inherited Create;
  FRoot:=nil;
end;

destructor TTrie.Destroy;
begin
  Clear;
  inherited Destroy;
end;

function IsCorrectWord (var wrd : string) : boolean;
var i,len:integer;
begin
  wrd:=Trim(wrd);
  i:=1;
  len:=length(wrd);
  Result:=len<>0;
  while (i<=len) and Result do
    begin
    if not (wrd[i] in [LowCh..HighCh]) then
      Result:=false
    else
      inc(i);
    end;
end;

function TTrie.AddWord(word: string):boolean;
begin
  if FRoot=nil then
    FRoot:=TNode.Create;
  Result:=(word<>'') and FRoot.AddWord(word,1);
  if not Result and FRoot.IsEmpty then
    FreeAndNil(Froot);
end;

procedure TTrie.Clear;
begin
  FreeAndNil(FRoot);
end;

function TTrie.DeleteWord(word:string):boolean;
begin
  Result:=(FRoot<>nil)and (word<>'') and FRoot.DeleteWord(word,1);
  if Result and FRoot.IsEmpty then
    FreeAndNil(FRoot);
end;

function TTrie.FindWord(word: string): Boolean;
begin
  Result:=(FRoot<>nil) and FRoot.FindWord(word,1);
end;

function TTrie.IsEmpty: boolean;
begin
  Result:=FRoot=nil;
end;

function TTrie.LoadFromFile(AFileName: string):boolean;
var
  f:TextFile;
  word:string;
begin
  Clear;
  Result:=true;
  AssignFile(f, AFileName);
  reset(f);
  while not eof(f) do
    begin
      readln(f, word);
      if not AddWord(word) then
        Result:=false;
    end;
  CloseFile(f);
end;

procedure TTrie.PrintAll(SL: TStrings);
var s:string;
begin
  SL.Clear;
  s:='';
  if FRoot <> nil then FRoot.PrintAll(SL,s);
end;

procedure TTrie.SaveToFile(AFileName: string);
var
  f:TextFile;
begin
  AssignFile(f,AFileName);
  Rewrite(f);
  if FRoot<>nil then
    FRoot.SaveToFile(f,'');
  CloseFile(F);
end;
function TTrie.GetWordsCount:integer;
begin
  Result:= FRoot.GetWordsCount;
end;


end.
