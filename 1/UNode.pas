unit UNode;

interface

uses SysUtils, Classes;

const LowCh = 'a';
      HighCh = 'z';
type
  TIndex = LowCh..HighCh;
  TNode = class
    private
      FPoint: boolean;
      FNext: array [TIndex] of TNode;
      function GetAllWordsCount: Integer;
    protected
      function GetNext (ch: TIndex): TNode;
      procedure SetNext(ch:TIndex; value:TNode);
    public
      constructor Create;
      destructor Destroy; override;
      function IsCorrectChar(ch:char):boolean;
      function IsEmpty:boolean;
      function AddWord(var wrd: string; i:integer):boolean;
      function FindWord (var wrd: string; i:integer): boolean;
      function DeleteWord (var wrd: string; i:integer): boolean;
      procedure PrintAll (SL:Tstrings; var wrd:string);
      procedure SaveToFile(var f: TextFile; word:string);
      function GetWordsCount: integer;
      property Point:boolean read Fpoint write FPoint;
      property Next[index:TIndex]:TNode read GetNext write SetNext;
  end;

implementation

function TNode.GetNext (ch: TIndex): TNode;
begin
  Result:=FNext[ch];
end;
procedure TNode.SetNext(ch:TIndex; value:TNode);
begin
  if FNext[ch]<>value then
    begin
      FreeAndNil(FNext[ch]);
      FNext[ch]:=value;
    end;
end;

constructor TNode.Create;
var ch:TIndex;
begin
  FPoint:=false;
  for ch:=LowCh to HighCh do
    FNext[ch]:=nil;
end;

destructor TNode.Destroy;
var ch:TIndex;
begin
  for ch:=LowCh to HighCh do
    if Fnext[ch]<>nil then
      FNext[ch].Destroy;
  inherited;
end;

function TNode.IsCorrectChar(ch:char):boolean;
begin
  Result:=(ch>=LowCh)and (ch<=HighCh);
end;

function TNode.IsEmpty:boolean;
var ch:TIndex;
begin
  ch:=LowCh;
  Result:=(FNext[ch]=nil) and not FPoint;
  if Result then
    repeat
      inc(ch);
      Result:=FNext[ch]=nil;
    until (ch=HighCh) or not Result;
end;

function TNode.AddWord(var wrd: string; i:integer):boolean;
begin
  if i>length(wrd) then
    begin
      Result:=not FPoint;
      FPoint:=true;
    end
  else
    if not IsCorrectChar(wrd[i]) then
      Result:=false
    else
      begin
        if FNext[wrd[i]]=nil then
          FNext[wrd[i]]:=TNode.Create;
        Result:=FNext[wrd[i]].AddWord(wrd,i+1);
        if not Result and FNext[wrd[i]].IsEmpty then
          FreeAndNil(FNext[wrd[i]]);
      end;
end;

function TNode.FindWord (var wrd: string; i:integer): boolean;
begin
  if i>length(wrd) then
    Result:=FPoint
  else
    Result:=IsCorrectChar(wrd[i]) and (FNext[wrd[i]]<>nil) and FNext[wrd[i]].FindWord(wrd,i+1);
end;

function TNode.DeleteWord (var wrd: string; i:integer): boolean;
begin
  if i>length(wrd) then
    begin
      Result:=FPoint;
      FPoint:=false;
    end
  else
    begin
    if  not IsCorrectChar(wrd[i]) or (FNext[wrd[i]]=nil) then
      Result:=false
    else
      begin
      Result:=FNext[wrd[i]].DeleteWord(wrd,i+1);
      if Result and FNext[wrd[i]].IsEmpty then
        FreeAndNil(FNext[wrd[i]]);
      end;
    end;
end;

procedure TNode.PrintAll (SL:Tstrings; var wrd:string);
var ch:TIndex;
begin
  if FPoint then
    SL.Add(wrd);
  for ch:=LowCh to HighCh do
    if FNext[ch] <> nil then
    begin
      wrd:=wrd+ch;
      FNext[ch].PrintAll(SL,wrd);
      delete(wrd, length(wrd), 1);
    end;
end;

procedure TNode.SaveToFile(var F: TextFile; word:string);
var
  ch:TIndex;
begin
  if FPoint then
   writeln(F,word);
  for ch:=LowCH to HighCh do
  if FNext[ch] <> nil
    then
      begin
        word:=word+ch;
        FNext[ch].SaveToFile(f,word);
        delete(word, length(word), 1);
      end;
end;

function TNode.GetWordsCount: Integer;
var ch:TIndex;
begin
  Result := 0;
  for ch:=LowCh to HighCh do
    if FNext[ch] <> nil then
      begin
        if ch = 'a' then
          Result := Result + FNext[ch].GetAllWordsCount
        else
          Result := Result + FNext[ch].GetWordsCount
      end;
end;

function TNode.GetAllWordsCount: integer;
var ch:TIndex;
begin
  Result := 0;
  if FPoint then
    Result := 1;
  for ch:=LowCh to HighCh do
    if FNext[ch] <> nil then
      Result := Result + FNext[ch].GetAllWordsCount;
end;

end.

