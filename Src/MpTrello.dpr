program MpTrello;

uses
  Forms,
  ServerModule in 'ServerModule\ServerModule.pas' {UniServerModule: TUniGUIServerModule},
  MainModule in 'MainModule\MainModule.pas' {UniMainModule: TUniGUIMainModule},
  Principal in 'Principal\Principal.pas' {FrmPrincipal: TUniForm},
  SpTrello.Authenticator in 'Lib\Authenticator\SpTrello.Authenticator.pas',
  Core.SpTrello.Authenticator in 'Lib\Core\Core.SpTrello.Authenticator.pas',
  Core.SpTrello.Base in 'Lib\Core\Core.SpTrello.Base.pas',
  Core.SpTrello.RestClient in 'Lib\Core\Core.SpTrello.RestClient.pas',
  Core.SpTrello.RestRequest in 'Lib\Core\Core.SpTrello.RestRequest.pas',
  Core.SpTrello.RestResponse in 'Lib\Core\Core.SpTrello.RestResponse.pas',
  Core.SpTrello.Constants in 'Lib\Core\Core.SpTrello.Constants.pas',
  Core.SpTrello.Util in 'Lib\Core\Core.SpTrello.Util.pas',
  Core.SpTrello.Organizations in 'Lib\Core\Core.SpTrello.Organizations.pas',
  SpTrello.Organizations in 'Lib\Organizations\SpTrello.Organizations.pas',
  Core.SpTrello.Boards in 'Lib\Core\Core.SpTrello.Boards.pas',
  SpTrello.Boards in 'Lib\Boards\SpTrello.Boards.pas',
  Core.SpTrello.Lists in 'Lib\Core\Core.SpTrello.Lists.pas',
  SpTrello.Lists in 'Lib\Lists\SpTrello.Lists.pas',
  Core.SpTrello.Cards in 'Lib\Core\Core.SpTrello.Cards.pas',
  SpTrello.Cards in 'Lib\Cards\SpTrello.Cards.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.Title := 'MP/Trello';
  TUniServerModule.Create(Application);
  Application.Run;
end.
