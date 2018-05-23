unit Core.SpTrello.Boards;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Core.SpTrello.Base, System.JSON, REST.Client, IPPeerCommon, SpTrello.Authenticator;

type
  TCoreSpTrelloBoards = class(TCoreSpTrelloBase)
  public
    constructor Create(const oAuthenticator: TSpTrelloAuthenticator);
    function Get(const aParams: array of TJSONPair): TRESTResponse;
    function Post(const aParams: array of string): TRESTResponse;
    function Put(const sValue: string; const sFieldName: string;
      const aParams: string): TRESTResponse;
    function Delete(const sValue: string): TRESTResponse;
  end;

implementation

uses System.StrUtils, REST.Authenticator.OAuth, System.Threading,
  REST.Types, Core.SpTrello.Authenticator, Core.SpTrello.Constants;

resourcestring
  sBOARDS = 'boards';

{ TCoreSpTrelloOrganizations }

constructor TCoreSpTrelloBoards.Create(const oAuthenticator: TSpTrelloAuthenticator);
begin
  inherited Create(oAuthenticator);
  EndPoint := sBOARDS;
end;

function TCoreSpTrelloBoards.Delete(const sValue: string): TRESTResponse;
begin
  try
    Result := Request(TRESTRequestMethod.rmDELETE,
      Format('%s/%s/%s', [TCoreSpTrelloConstants.BaseUrl, EndPoint, sValue]), []);
  except
    raise;
  end;
end;

function TCoreSpTrelloBoards.Get(const aParams: array of TJSONPair): TRESTResponse;
begin
  try
    Result := Request(TRESTRequestMethod.rmGET,
      Format('%s/%s', [TCoreSpTrelloConstants.BaseUrl, EndPoint + '/5a25f63cd4647d9a3ef75898']), []);
  except
    raise;
  end;
end;

function TCoreSpTrelloBoards.Post(const aParams: array of string): TRESTResponse;
begin
  try
    Result := Request(TRESTRequestMethod.rmPOST,
      Format('%s/%s', [TCoreSpTrelloConstants.BaseUrl, EndPoint]),
      [TJSONPair.Create('name', aParams[0])]);
  except
    raise;
  end;
end;

function TCoreSpTrelloBoards.Put(const sValue, sFieldName,
  aParams: string): TRESTResponse;
begin
  try
    Result := Request(TRESTRequestMethod.rmPUT,
      Format('%s/%s/%s/%s', [TCoreSpTrelloConstants.BaseUrl, EndPoint, sValue, sFieldName]),
      [TJSONPair.Create('value', aParams)]);
  except
    raise;
  end;
end;

end.

