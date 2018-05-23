unit Core.SpTrello.Authenticator;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  REST.Authenticator.OAuth;

type
  TCoreSpTrelloOAuth1Authenticator = class(TOAuth1Authenticator)
  strict private
    FAccessUser: string;
    procedure SetAccessUser(const Value: string);
  public
    property AccessUser: string read FAccessUser write SetAccessUser;
  end;

  TCoreSpTrelloAuthenticator = class
  public
    function Authenticator(const psAccessToken, psConsumerKey,
      psAccessUser: string): TCoreSpTrelloOAuth1Authenticator;
  end;

implementation

{ TCoreSpTrelloAuthenticator }

function TCoreSpTrelloAuthenticator.authenticator(const psAccessToken,
  psConsumerKey, psAccessUser: string): TCoreSpTrelloOAuth1Authenticator;
begin
  Result := TCoreSpTrelloOAuth1Authenticator.Create(nil);
  Result.AccessToken := psAccessToken;
  Result.ConsumerKey := psConsumerKey;
  Result.AccessUser := psAccessUser;
end;

{ TCoreSpTrelloOAuth1Authenticator }

procedure TCoreSpTrelloOAuth1Authenticator.SetAccessUser(const Value: string);
begin
  FAccessUser := Value;
end;

end.

