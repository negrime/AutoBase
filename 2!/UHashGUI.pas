unit UHashGUI;

interface
uses UTable, UData, Grids;
type
  THashGUI = class(THTable)
  private
    FFileName:string;
    FModified:boolean;
    FGrid: TStringGrid;
  protected
    procedure SetModified(value:boolean);
  public
    constructor Create(SG:TStringGrid);
    destructor Destroy; override;
    function LoadFromFile (AFileName : string):boolean;
    procedure SaveToFile (AFileName:string);
    procedure SaveFile;
    procedure Clear;
    function Add (inf : TInfo):boolean;
    function Delete (key : TKey ):boolean;
    property Filename : string  read FFileName;
    property Modified : Boolean read FModified;
  end;
implementation

  function THashGUI.Add(inf: TInfo): boolean;
  begin
    Result:= inherited Add(inf);
    FModified:=Result or FModified;
  end;
  
  procedure THashGUI.Clear;
  begin
    if Count>0 then
      begin
        inherited Clear;
        FModified:=True;
      end;
  end;

  constructor THashGUI.Create(SG:TStringGrid);
  begin
    inherited Create;
    FModified:=False;
    FFileName:='';
    FGrid:=SG;
    TInfo.ShowTitle(FGrid.Rows[0]);
    ShowToGrid(FGrid);
  end;

  destructor THashGUI.Destroy;
  begin
    inherited;
  end;

  function THashGUI.Delete(key:TKey): boolean;
  begin
    Result:=inherited Delete(key);
    FModified:= Result or FModified;
  end;

  function THashGUI.LoadFromFile(AFileName: string): boolean;
  begin
    FFileName:=AFileName;
    Result:= inherited LoadFromFile(FFileName);
    FModified:=false;
    ShowToGrid(FGrid);
  end;
  
  procedure THashGUI.SaveFile;
  begin
    inherited SaveToFile(FFileName);
    FModified:=false;
  end;

  procedure THashGUI.SaveToFile(AFileName: string);
  begin
    FFileName:=AFileName;
    FModified:=false;
    inherited SaveToFile(FFileName);
  end;

  procedure THashGUI.SetModified(value: Boolean);
  begin
    FModified:=value;
    if value then
      ShowToGrid(FGrid);
  end;
  
end.
