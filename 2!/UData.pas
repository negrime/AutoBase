unit UData;

interface
uses Classes, SysUtils;
  type
    TKey=string;
    TInfo=class
    private
      FName:TKey;
      FDirector:string;
      FActors:string;
      FSummary:string;
    public
      constructor Create; overload;
      constructor Create(AName:TKey;ADirector,AActors,ASummary:string);  overload;
      property Name: TKey read FName;
      property Director: TKey read FDirector;
      property Actors: TKey read FActors;
      property Summary: TKey read FSummary;
      procedure Show(SL:TStrings);
      class procedure ShowTitle(SL:TStrings);
      function IsEqualKey(const key:TKey):boolean;
      function LoadFromFile(var f:TextFile):boolean;
      procedure SaveToFile(var f:TextFile);
    end;
  function HF1(key:TKey):integer;
  function HF2(key:TKey):integer;
implementation

  constructor TInfo.Create;
  begin
    FName:='';
    FDirector:='';
    FActors:='';
    FSummary:='';
    inherited Create;
  end;

constructor TInfo.Create(AName:TKey;ADirector,AActors,ASummary:string);
  begin
    inherited Create;
    FName:=AName;
    FDirector:=ADirector;
    FActors:=AActors;
    FSummary:=ASummary;
  end;

  function HF1(key:TKey): integer;
  var
    i: integer;
  begin
  result:=0;
    for i:=1 to length(key) do
      result:=result+ ord(key[i]);
  end;

  function HF2(key:TKey): integer;
  var
    i: integer;
  begin
  result:=0;
    for i:=1 to length(key) do
      result:=result+ ord(key[i])*(length(key)-i);
  end;

  function TInfo.IsEqualKey(const key: TKey): boolean;
  begin
    Result:=(FName=key);
  end;

  function TInfo.LoadFromFile(var f: TextFile): boolean;
  begin
    if not EOF(f) then Readln(f,FName);
    if not EOF(f) then Readln(f,FDirector);
    if not EOF(f) then Readln(f,FActors);
    if not EOF(f) then Readln(f,FSummary);
    if FName<>'' then result:=true else result:=false;
  end;

  procedure TInfo.SaveToFile(var f: TextFile);
  begin
    Writeln(f,FName);
    Writeln(f,FDirector);
    Writeln(f,FActors);
    Writeln(f,FSummary);
    Writeln(f);
  end;

  procedure TInfo.Show(SL: TStrings);
  begin
    SL[1]:=FName;
    SL[2]:=FDirector;
    SL[3]:=FActors;
    SL[4]:=FSummary;
  end;
  
  class procedure TInfo.ShowTitle(SL: TStrings);
  begin
    SL[0]:='№';
    SL[1]:='Название';
    SL[2]:='Режисер';
    SL[3]:='Актеры';
    SL[4]:='Описание';
  end;

end.

 