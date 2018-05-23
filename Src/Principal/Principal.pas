unit Principal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses, UniGUIVars,
  uniGUIClasses, uniGUIRegClasses, uniGUIForm, uniGUIBaseClasses, uniButton,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, uniBasicGrid, uniDBGrid,
  SpTrello.Authenticator, SpTrello.Boards, SpTrello.Lists, SpTrello.Cards,
  uniPanel, uniPageControl, uniHTMLFrame, ServerModule, uniLabel, uniBitBtn,
  uniSpeedButton, uniTimer;

type
  TFrmPrincipal = class(TUniForm)
    QryQuadros: TFDMemTable;
    QryLista: TFDMemTable;
    QryCards: TFDMemTable;
    UniButton1: TUniButton;
    DSQuadros: TDataSource;
    UniDBGrid1: TUniDBGrid;
    procedure UniButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses MainModule;

procedure TFrmPrincipal.UniButton1Click(Sender: TObject);
var
  oAuthenticator: TSpTrelloAuthenticator;
  SpTrelloBoards: TSpTrelloBoards;
  SpTrelloLists: TSpTrelloLists;
  SpTrelloCards: TSpTrelloCards;
begin
  oAuthenticator := TSpTrelloAuthenticator.Create;
  try
    oAuthenticator.User := 'davidroliveira';
    oAuthenticator.Key := '7792613d72989f58b30d11e4017ca86d';
    oAuthenticator.Token := '74fed0ced88cca018486cbf010c441bebcafdbbc55e79365fa2b4098be7d25ee';
    SpTrelloBoards := TSpTrelloBoards.Create;
    try
      SpTrelloBoards.Active := False;
      SpTrelloBoards.SpTrelloAuthenticator := oAuthenticator;
      SpTrelloBoards.DataSet := QryQuadros;
      SpTrelloBoards.Active := True;
      //SpTrelloBoards.Active := False;

//      SpTrelloLists := TSpTrelloLists.Create;
//      try
//        SpTrelloCards := TSpTrelloCards.Create;
//        try
//
//        finally
//          SpTrelloCards.Free;
//        end;
//      finally
//        SpTrelloLists.Free;
//      end;
    finally
      SpTrelloBoards.Free;
    end;
  finally
    oAuthenticator.Free;
  end;
end;

initialization
  RegisterAppFormClass(TFrmPrincipal);
end.
