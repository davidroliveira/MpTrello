unit Core.SpTrello.RestRequest;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  REST.Client, system.JSON, REST.Types;

type
  TCoreSpTrelloRestRequest = class
  public
    function RestClient(const AParams: array of TJSONPair): TRESTRequest;
  end;

implementation

{ TCoreSpTrelloRestRequest }

function TCoreSpTrelloRestRequest.RestClient(
  const AParams: array of TJSONPair): TRESTRequest;
var
  nContador: Integer;
begin
  Result := TRESTRequest.Create(nil);
  Result.SynchronizedEvents := False;
  for nContador := 0 to High(AParams) do
  begin
    Result.AddParameter(StringReplace(AParams[nContador].JsonString.ToString, '"','', [rfReplaceAll, rfIgnoreCase]),
      StringReplace(AParams[nContador].JsonValue.ToString, '"', '', [rfReplaceAll, rfIgnoreCase]));
  end;

  for nContador := High(AParams) downto 0 do
    AParams[nContador].Free;
end;

end.

