unit Core.SpTrello.RestResponse;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  REST.Client, system.JSON, REST.Types;

type
  TCoreSpTrelloRestResponse = class
  public
    function RestResponse: TRESTResponse;
  end;

implementation

{ TCoreSpTrelloRestResponse }

function TCoreSpTrelloRestResponse.RestResponse: TRESTResponse;
begin
  Result := TRESTResponse.Create(nil);
  Result.ContentType := 'application/json';
end;

end.

