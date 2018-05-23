unit Core.SpTrello.RestClient;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  REST.Client;

type
  TCoreSpTrelloRestClient = class
  public
    function RestClient: TRESTClient;
  end;

implementation

{ TCoreSpTrelloRestClient }

function TCoreSpTrelloRestClient.RestClient: TRESTClient;
begin
  Result := TRESTClient.Create(nil);
  Result.Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8,';
  Result.AcceptCharset := 'UTF-8, *;q=0.8';
  Result.HandleRedirects := True;
  Result.RaiseExceptionOn500 := False;
end;

end.

