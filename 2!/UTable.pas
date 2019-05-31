unit UTable;

interface
uses classes, Grids, SysUtils, UData;
  Const
    N=11;
  Type
    TIndex=0..N-1;
    TState=(sfree,sfull,sdel);
    TCell=record
      Info:TInfo;
      State:TState;
      end;
    TTable=array[TIndex] of TCell;
    THTable=class
    private
      FCount:integer;
      FTable:TTable;
    protected
      function HashFunc1(key:TKey):TIndex;
      function HashFunc2(key:TKey):TIndex;
      function NextCell(h1,h2:TIndex; var i:integer):TIndex;
      function IndexOf(key:TKey):integer;
    public
      constructor Create;
      destructor Destroy; override;
      procedure Clear;
      function Add(info:TInfo):boolean;
      function Find(key:Tkey; var info:TInfo):boolean;
      function Delete(key:TKey):boolean;
      procedure ShowToGrid(SG:TStringGrid);
      procedure SaveToFile(FileName:string);
      function LoadFromFile(FileName:string):boolean;
      property Count:Integer read FCount;
    end;

implementation
  //+
  function THTable.Add(info: TInfo): boolean;
  var
    h1,h2,a:TIndex;
    i, k:integer;
    equal:boolean;
    stop:boolean;
  begin
    h1:=HashFunc1(info.Name);
    h2:=HashFunc2(info.Name);
    i:=0;
    a:=h1;
    equal:=false;
    stop:=false;
    k:=-1;
    while (i<2*N) and not stop do
      begin
        case FTable[a].State of
        sfree: stop:=true;
        sdel:  begin
          k:=a;
          a:=NextCell(h1,h2,i);

        end;
        sfull: begin
                if FTable[a].Info.IsEqualKey(info.Name) then
                  begin
                    FTable[a].info:=info;
                    stop:=true;
                    equal:=true;
                  end
                else
                  a:=NextCell(h1,h2,i);
              end;
       end;
    end;
    if not stop then
      Result:=false
    else
        begin
          if k = -1 then
            k := a;
          Result:=true;
          FTable[k].info:=info;
          FTable[k].State:=sfull;
        end;
    if Result and not equal then Inc(FCount);
  end;

  //+
  procedure THTable.Clear;
  var i:integer;
  begin
  for i:=0 to n-1 do
    begin
    FTable[i].Info.Free;
    FTable[i].State:=sfree;
    end;
  FCount:=0;
  end;
  //+
  constructor THTable.Create;
  var i:integer;
  begin
  FCount:=0;
  for i:=0 to n-1 do
    FTable[i].State:=sfree;
  end;
  //+
  function THTable.Delete(key: TKey): boolean;
  var ind:integer;
  begin
    ind:=IndexOf(key);
    if ind<>-1 then
      begin
        FTable[ind].State:=sdel;
        FreeAndNil(FTable[ind].Info);
        result:=true;
      end
    else
      result:=false;
    if Result then dec(FCount);
  end;
  //+
  destructor THTable.Destroy;
  begin
    Clear;
    inherited;
  end;
  //+
  function THTable.Find(key: Tkey; var info: TInfo): boolean;
  var a:integer;
  begin
    a:=IndexOf(key);
    if a=-1 then
      result:=false
    else
      begin
      result:=true;
      info:=FTable[a].info;
      end;
  end;
  //+
  function THTable.HashFunc1(key: TKey): TIndex;
  begin
    Result:=HF1(key) mod N;
  end;
  //+
  function THTable.HashFunc2(key: TKey): TIndex;
  begin
    Result:=HF2(key) mod N;
  end;

  function THTable.IndexOf(key: TKey): integer;
  var
    h1,h2,ind: TIndex;
    stop,ok:boolean;
    i:integer;
  begin
    h1:=HashFunc1(key);
    h2:=HashFunc2(key);
    ind:=h1;
    stop:=false;
    ok:=false;
    i:=0;
    while (i<2*N) and (not stop) and (not ok) do
      case FTable[ind].State of
        sfree: stop:=true;
        sdel: ind:=NextCell(h1,h2,i);
        sfull: if FTable[ind].Info.IsEqualKey(key) then
                  ok:=true
               else
                ind:=NextCell(h1,h2,i);
      end;
    if ok then result:=ind
    else
      result:=-1;
  end;

  function THTable.LoadFromFile(FileName:string): boolean;
  var f:TextFile;
      info:TInfo;
      ok:boolean;
  begin
    if FileExists(FileName) then
     begin
       Assign(f,FileName);
       Reset(f);
       ok:=true;
       while (not EOF(f))and ok do
       begin
         info:=TInfo.Create;
         ok:=info.LoadFromFile(f);
         if ok then
         begin
           ok:=Add(info);
           if not EOF(f) then Readln(f);
         end;
       end;
       if ok then result:=true
       else result:=false;
     end
    else result:=false;
    CloseFile(f);
  end;
  //+
  function THTable.NextCell(h1,h2:TIndex;var i: integer): TIndex;
  begin
    i:=i+1;
    result:=(h1+h2*i)mod N;
  end;

  procedure THTable.ShowToGrid(SG: TStringGrid);
  var
  i:integer; index:TIndex;
  begin
    if FCount = 0 then
      begin
        SG.RowCount:=2;
        SG.Rows[1].Clear;
      end
    else
      begin
        SG.RowCount:=FCount+1;
        TInfo.ShowTitle(SG.Rows[0]);
        i:=1;
        for index:=0 to N-1 do
          if FTable[index].State=sfull then
              begin
                SG.Cells[0,i]:=IntToStr(i);
                FTable[index].Info.Show(SG.Rows[i]);
                inc(i);
              end;
      end;
  end;
  //+
  procedure THTable.SaveToFile(FileName: string);
  var f:TextFile;
      i:integer;
  begin
         Assign(f,FileName);
         Rewrite(f);
         for i:=0 to N-1 do
          if FTable[i].State=sfull then
            FTable[i].Info.SaveToFile(f);
         CloseFile(f);
  end;


end. 
