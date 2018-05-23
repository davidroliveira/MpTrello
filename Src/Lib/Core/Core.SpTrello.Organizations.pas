unit Core.SpTrello.Organizations;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Core.SpTrello.Base, System.JSON, REST.Client, IPPeerCommon,
  SpTrello.Authenticator;

type
  TCoreSpTrelloOrganizations = class(TCoreSpTrelloBase)
  public
    constructor Create(const oAuthenticator: TSpTrelloAuthenticator); override;
    function Get(const aParams: array of TJSONPair): TRESTResponse;
    function Post(const aParams: array of string): TRESTResponse;
    function Put(const sValue: string; const FieldName: string;
      const aParams: string): TRESTResponse;
    function Delete(const sValue: string): TRESTResponse;
  end;

implementation

uses System.StrUtils, REST.Authenticator.OAuth, System.Threading, REST.Types,
  Core.SpTrello.Authenticator, Core.SpTrello.Constants;

resourcestring
  sORGANIZATIONS = 'organizations';

{ TCoreSpTrelloOrganizations }

constructor TCoreSpTrelloOrganizations.Create(const oAuthenticator: TSpTrelloAuthenticator);
begin
  inherited Create(oAuthenticator);
  EndPoint := sORGANIZATIONS;
end;

function TCoreSpTrelloOrganizations.Delete(const sValue: string): TRESTResponse;
begin
  try
    Result := Request(TRESTRequestMethod.rmDELETE,
      Format('%s/%s/%s', [TCoreSpTrelloConstants.BaseUrl, EndPoint, sValue]), []);
  except
    raise;
  end;
end;

function TCoreSpTrelloOrganizations.Get(
  const aParams: array of TJSONPair): TRESTResponse;
begin
  try
    Result := Request(TRESTRequestMethod.rmGET,
      Format('%s/members/%s/%s', [TCoreSpTrelloConstants.BaseUrl,
      SpAuthenticator.User, EndPoint]), []);
  except
    raise;
  end;
end;

function TCoreSpTrelloOrganizations.Post(const aParams: array of string): TRESTResponse;
begin
  try
    Result := Request(TRESTRequestMethod.rmPOST,
      Format('%s/%s', [TCoreSpTrelloConstants.BaseUrl, EndPoint]),
      [TJSONPair.Create('name', aParams[0]),
       TJSONPair.Create('displayName', aParams[1]),
       TJSONPair.Create('desc', aParams[2]),
       TJSONPair.Create('website', aParams[3])]);
  except
    raise;
  end;
end;

function TCoreSpTrelloOrganizations.Put(const sValue: string;
  const FieldName: string; const aParams: string): TRESTResponse;
begin
  try
    Result := Request(TRESTRequestMethod.rmPUT,
      Format('%s/%s/%s/%s', [TCoreSpTrelloConstants.BaseUrl, EndPoint, sValue, FieldName]),
      [TJSONPair.Create('value', aParams)]);
  except
    raise;
  end;
end;

end.

