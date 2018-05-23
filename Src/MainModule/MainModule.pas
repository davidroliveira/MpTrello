unit MainModule;

interface

uses
  uniGUIMainModule, SysUtils, Classes, UniGUIVars, ServerModule, uniGUIApplication,
  uniGUIBaseClasses, uniGUIClasses;

type
  TUniMainModule = class(TUniGUIMainModule)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function UniMainModule: TUniMainModule;

implementation

{$R *.dfm}

function UniMainModule: TUniMainModule;
begin
  Result := TUniMainModule(UniApplication.UniMainModule)
end;

initialization
  RegisterMainModuleClass(TUniMainModule);
end.
