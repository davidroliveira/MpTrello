unit Core.SpTrello.Cards;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Core.SpTrello.Base, System.JSON, REST.Client, IPPeerCommon, SpTrello.Authenticator;

type
  TCoreSpTrelloCards = class(TCoreSpTrelloBase)
  private
    FIdList: string;
    procedure SetIdList(const Value: string);
  public
    constructor Create(const AIdList: string; const AAuthenticator: TSpTrelloAuthenticator);
    function Get(const aParams: array of TJSONPair): TRESTResponse;
    //function Post(const aParams: array of string): TRESTResponse;
    function Put(const sValue: string;const FieldName: string;
      const AParams: string): TRESTResponse;
    function Delete(const sValue: string): TRESTResponse;
    property IdList: string read FIdList write SetIdList;
  end;

implementation

uses System.StrUtils, REST.Authenticator.OAuth, System.Threading,
  REST.Types, Core.SpTrello.Authenticator, Core.SpTrello.Constants;

resourcestring
  sCARDS = 'cards';

{ TCoreSpTrelloLists }

constructor TCoreSpTrelloCards.Create(const AIdList: string; const AAuthenticator: TSpTrelloAuthenticator);
begin
  inherited Create(AAuthenticator);
  EndPoint := sCARDS;
  FIdList := AIdList;
end;

function TCoreSpTrelloCards.Delete(const sValue: string): TRESTResponse;
begin
  try
    Result := Request(TRESTRequestMethod.rmDELETE,
      Format('%s/%s/%s', [TCoreSpTrelloConstants.BaseUrl, EndPoint, sValue]), []);
  except
    raise;
  end;
end;

function TCoreSpTrelloCards.Get(const aParams: array of TJSONPair): TRESTResponse;
begin
  try
    Result := Request(TRESTRequestMethod.rmGET,
      Format('%s/lists/%s/%s', [TCoreSpTrelloConstants.BaseUrl, IdList, EndPoint]), []);
  except
    raise;
  end;
end;

//function TCoreSpTrelloCards.Post(const aParams: array of string): TRESTResponse;
//begin
//  try
//    Result := Request(TRESTRequestMethod.rmPOST,
//      Format('%s/%s', [TCoreSpTrelloConstants.BaseUrl, EndPoint]),
//      [TJSONPair.Create('name', aParams[0]),
//       TJSONPair.Create('idMembers', SpAuthenticator.Id),
//       TJSONPair.Create('idList', aParams[1])]);
//  except
//    raise;
//  end;
//end;

function TCoreSpTrelloCards.Put(const sValue, FieldName,
  AParams: string): TRESTResponse;
begin
  try
    Result := Request(TRESTRequestMethod.rmPUT,
      Format('%s/%s/%s/%s', [TCoreSpTrelloConstants.BaseUrl, EndPoint, sValue, FieldName]),
      [TJSONPair.Create('value', AParams)]);
  except
    raise;
  end;
end;

procedure TCoreSpTrelloCards.SetIdList(const Value: string);
begin
  FIdList := Value;
end;

end.

