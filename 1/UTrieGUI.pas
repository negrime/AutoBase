unit UTrieGUI;

interface

uses UTrie;
type
  TTrieGUI = class(TTrie)
  private
    FFileName:string;
    FModified:Boolean;
  public
    constructor Create;     //+
    destructor Destroy; override;    //+
    function LoadFromFile (AFileName : string):boolean;  //+
    procedure SaveToFile (AFileName:string);   //+
    procedure SaveFile;  //+
    procedure Clear;     //+
    function AddWord (word : string):boolean;   //+
    function DeleteWord (word : string ):boolean;    //+
    property Filename : string  read FFileName;  //+
    property Modified : Boolean read FModified; //+
  end;

implementation

  function TTrieGUI.AddWord(word: string): boolean;
  begin
    Result:= inherited AddWord(word);
    FModified:=Result or FModified;
  end;

  procedure TTrieGUI.Clear;
  begin
    if not IsEmpty then
      begin
        inherited Clear;
        FModified:=true;
      end;
  end;

  constructor TTrieGUI.Create;
  begin
    inherited Create;
    FFileName:='';
    FModified:=false;
  end;

  destructor TTrieGUI.Destroy;
  begin
    inherited;
  end;

  function TTrieGUI.DeleteWord(word: string): boolean;
  begin
    Result:=inherited DeleteWord(word);
    FModified:= Result or FModified;
  end;

  function TTrieGUI.LoadFromFile(AFileName: string): boolean;
  begin
    FFileName:=AFileName;
    Result:= inherited LoadFromFile(FFileName);
    FModified:=false;
  end;
  
  procedure TTrieGUI.SaveFile;
  begin
    inherited SaveToFile(FFileName);
    FModified:=false;
  end;

  procedure TTrieGUI.SaveToFile(AFileName: string);
  begin
    FFileName:=AFileName;
    FModified:=false;
    inherited SaveToFile(FFileName);
  end;

end.
